import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_hover_card_style.dart';

/// Side and alignment of a [VHoverCard] relative to its trigger.
enum VHoverCardPosition {
  /// Top.
  top,

  /// Top start.
  topStart,

  /// Top end.
  topEnd,

  /// Bottom.
  bottom,

  /// Bottom start.
  bottomStart,

  /// Bottom end.
  bottomEnd,

  /// Left.
  left,

  /// Left start.
  leftStart,

  /// Left end.
  leftEnd,

  /// Right.
  right,

  /// Right start.
  rightStart,

  /// Right end.
  rightEnd,
}

/// Card with rich content that opens when the pointer rests on its trigger.
///
/// On touch devices a tap toggles the card instead.
///
/// ```dart
/// VHoverCard(
///   position: VHoverCardPosition.bottomStart,
///   openDelay: Duration(milliseconds: 500),
///   content: Row(
///     spacing: 12,
///     children: [
///       VAvatar.text('JD'),
///       Text('@johndoe'),
///     ],
///   ),
///   child: Text('@johndoe'),
/// )
/// ```
///
/// See also:
///
/// - [VHoverCardPosition], where the card appears.
class VHoverCard extends StatefulWidget {
  /// Creates a hover card.
  const VHoverCard({
    required this.child,
    required this.content,
    super.key,
    this.openDelay = const Duration(milliseconds: 700),
    this.closeDelay = const Duration(milliseconds: 300),
    this.position = VHoverCardPosition.bottom,
    this.offset = const Offset(0, 8),
    this.enabled = true,
    this.style,
  });

  /// Maximum width for hover card content.
  static const _kContentMaxWidth = 320.0;

  /// Widget that opens the card when hovered or tapped.
  final Widget child;

  /// Content shown inside the card.
  final Widget content;

  /// Time the pointer must rest on [child] before the card opens.
  final Duration openDelay;

  /// Time after the pointer leaves before the card closes.
  final Duration closeDelay;

  /// Side and alignment of the card relative to [child].
  final VHoverCardPosition position;

  /// Shift of the card from its anchor; `dy` is the distance away from [child].
  final Offset offset;

  /// Whether hovering or tapping opens the card.
  final bool enabled;

  /// Per-instance style override merged over the theme style.
  final VHoverCardStyle? style;

  @override
  State<VHoverCard> createState() => _VHoverCardState();
}

class _VHoverCardState extends State<VHoverCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey _triggerKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _isHoveringTrigger = false;
  bool _isHoveringContent = false;

  Timer? _openTimer;
  Timer? _closeTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.96, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  // WHY: Same sentinel Duration pattern as VTooltip — enables theme token
  // substitution for const constructor defaults. See VTooltip._defaultWaitDuration.
  /// Sentinel value matching the constructor default for [VHoverCard.openDelay].
  static const Duration _defaultOpenDelay = Duration(milliseconds: 700);

  /// Sentinel value matching the constructor default for [VHoverCard.closeDelay].
  static const Duration _defaultCloseDelay = Duration(milliseconds: 300);

  /// Returns the effective open delay, preferring the theme token
  /// when the caller uses the constructor default.
  Duration _effectiveOpenDelay(VThemeData theme) {
    if (widget.openDelay == _defaultOpenDelay) {
      return theme.animations.slower;
    }
    return widget.openDelay;
  }

  /// Returns the effective close delay, preferring the theme token
  /// when the caller uses the constructor default.
  Duration _effectiveCloseDelay(VThemeData theme) {
    if (widget.closeDelay == _defaultCloseDelay) {
      return theme.animations.normal;
    }
    return widget.closeDelay;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _animationController.duration = theme.animations.fast;
  }

  @override
  void didUpdateWidget(VHoverCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled && oldWidget.enabled) {
      // A disabled card must not stay open or open later from a pending timer.
      _openTimer?.cancel();
      _closeTimer?.cancel();
      _hideOverlay();
    }
  }

  @override
  void dispose() {
    _openTimer?.cancel();
    _closeTimer?.cancel();
    _isOpen = false;
    // WHY: Reversing the animation and removing the entry afterwards cannot
    // finish once the controller is disposed, so remove the entry right away.
    _removeEntry();
    _animationController.dispose();
    super.dispose();
  }

  /// Whether the last interaction was from a touch device.
  bool _isTouchDevice = false;

  // WHY: Touch device detection via PointerDeviceKind — on touch devices,
  // hover events fire on tap-down which would open the card prematurely.
  // We skip hover logic for touch/stylus and rely on GestureDetector.onTap
  // instead, matching platform-native behavior.
  void _handleTriggerEnter(PointerEvent event) {
    if (!widget.enabled) return;

    final touch =
        event.kind == PointerDeviceKind.touch ||
        event.kind == PointerDeviceKind.stylus;
    if (touch != _isTouchDevice) {
      // The semantics hint depends on the input kind, so rebuild with it.
      setState(() => _isTouchDevice = touch);
    }
    if (touch) return;

    _isHoveringTrigger = true;
    _closeTimer?.cancel();

    if (!_isOpen) {
      final theme = VTheme.of(context);
      _openTimer = Timer(_effectiveOpenDelay(theme), _showOverlay);
    }
  }

  void _handleTriggerExit(PointerEvent event) {
    _isHoveringTrigger = false;
    _openTimer?.cancel();

    if (_isOpen && !_isHoveringContent) {
      final theme = VTheme.of(context);
      _closeTimer = Timer(_effectiveCloseDelay(theme), _hideOverlay);
    }
  }

  // WHY: Separate content hover tracking — when the mouse moves from trigger
  // to the card content, the close timer must be cancelled. Without this,
  // the card would dismiss while the user is reading it.
  void _handleContentEnter(PointerEvent event) {
    _isHoveringContent = true;
    _closeTimer?.cancel();
  }

  void _handleContentExit(PointerEvent event) {
    _isHoveringContent = false;

    if (_isOpen && !_isHoveringTrigger) {
      final theme = VTheme.of(context);
      _closeTimer = Timer(_effectiveCloseDelay(theme), _hideOverlay);
    }
  }

  void _removeEntry() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  void _showOverlay() {
    if (_isOpen) return;

    _isOpen = true;
    // A card that is still fading out keeps its entry; reopening reuses it
    // instead of stacking a second entry that would never be removed.
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
    unawaited(_animationController.forward());
  }

  void _hideOverlay() {
    if (!_isOpen) return;

    _isOpen = false;
    unawaited(
      _animationController.reverse().then((_) {
        if (!_isOpen &&
            _animationController.status == AnimationStatus.dismissed) {
          _removeEntry();
        }
      }),
    );
  }

  OverlayEntry _createOverlayEntry() {
    final theme = VTheme.of(context);
    final themeStyle = theme.componentOverrides.get<VHoverCardStyle>();
    final style = themeStyle?.merge(widget.style) ?? widget.style;

    return OverlayEntry(
      builder: (context) {
        final direction = Directionality.maybeOf(context) ?? TextDirection.ltr;
        final screenWidth = MediaQuery.maybeSizeOf(context)?.width;
        final maxWidth = screenWidth == null
            ? VHoverCard._kContentMaxWidth
            : math.min(VHoverCard._kContentMaxWidth, screenWidth);
        // WHY: The Overlay gives an entry tight constraints unless it is
        // positioned, and a bare Positioned counts as not positioned. Align
        // hands the card loose constraints, so it is only as wide as its
        // content, up to the maximum width.
        return Align(
          alignment: Alignment.topLeft,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: _calculateOffset(direction),
            targetAnchor: _getTargetAnchor(direction),
            followerAnchor: _getFollowerAnchor(direction),
            child: MouseRegion(
              onEnter: _handleContentEnter,
              onExit: _handleContentExit,
              child: Semantics(
                scopesRoute: true,
                explicitChildNodes: true,
                liveRegion: true,
                label: VoloLocalizations.of(context).hoverCardLabel,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    alignment: _getScaleAlignment(),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      padding:
                          style?.padding ?? EdgeInsets.all(theme.spacing.lg),
                      decoration: BoxDecoration(
                        color: style?.backgroundColor ?? theme.colors.popover,
                        border: Border.all(
                          color: style?.borderColor ?? theme.colors.border,
                        ),
                        borderRadius:
                            style?.borderRadius ?? theme.radius.mdRadius,
                        boxShadow: style?.elevation != null
                            ? [
                                BoxShadow(
                                  blurRadius: style!.elevation!,
                                  color: const Color(0x33000000),
                                ),
                              ]
                            : theme.shadows.lg,
                      ),
                      child: DefaultTextStyle(
                        style: theme.typography.bodyMedium.copyWith(
                          color: theme.colors.popoverForeground,
                        ),
                        child: widget.content,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // The horizontal offset of top and bottom positions follows the text
  // direction: a positive dx moves the card toward the end side.
  Offset _calculateOffset(TextDirection direction) {
    final dx = direction == TextDirection.rtl
        ? -widget.offset.dx
        : widget.offset.dx;
    return switch (widget.position) {
      VHoverCardPosition.top ||
      VHoverCardPosition.topStart ||
      VHoverCardPosition.topEnd => Offset(dx, -widget.offset.dy),
      VHoverCardPosition.bottom ||
      VHoverCardPosition.bottomStart ||
      VHoverCardPosition.bottomEnd => Offset(dx, widget.offset.dy),
      VHoverCardPosition.left ||
      VHoverCardPosition.leftStart ||
      VHoverCardPosition.leftEnd => Offset(-widget.offset.dy, widget.offset.dx),
      VHoverCardPosition.right ||
      VHoverCardPosition.rightStart ||
      VHoverCardPosition.rightEnd => Offset(widget.offset.dy, widget.offset.dx),
    };
  }

  Alignment _getTargetAnchor(TextDirection direction) =>
      switch (widget.position) {
        VHoverCardPosition.top => Alignment.topCenter,
        VHoverCardPosition.topStart => AlignmentDirectional.topStart.resolve(
          direction,
        ),
        VHoverCardPosition.topEnd => AlignmentDirectional.topEnd.resolve(
          direction,
        ),
        VHoverCardPosition.bottom => Alignment.bottomCenter,
        VHoverCardPosition.bottomStart =>
          AlignmentDirectional.bottomStart.resolve(direction),
        VHoverCardPosition.bottomEnd => AlignmentDirectional.bottomEnd.resolve(
          direction,
        ),
        VHoverCardPosition.left => Alignment.centerLeft,
        VHoverCardPosition.leftStart => Alignment.topLeft,
        VHoverCardPosition.leftEnd => Alignment.bottomLeft,
        VHoverCardPosition.right => Alignment.centerRight,
        VHoverCardPosition.rightStart => Alignment.topRight,
        VHoverCardPosition.rightEnd => Alignment.bottomRight,
      };

  Alignment _getFollowerAnchor(TextDirection direction) =>
      switch (widget.position) {
        VHoverCardPosition.top => Alignment.bottomCenter,
        VHoverCardPosition.topStart => AlignmentDirectional.bottomStart.resolve(
          direction,
        ),
        VHoverCardPosition.topEnd => AlignmentDirectional.bottomEnd.resolve(
          direction,
        ),
        VHoverCardPosition.bottom => Alignment.topCenter,
        VHoverCardPosition.bottomStart => AlignmentDirectional.topStart.resolve(
          direction,
        ),
        VHoverCardPosition.bottomEnd => AlignmentDirectional.topEnd.resolve(
          direction,
        ),
        VHoverCardPosition.left => Alignment.centerRight,
        VHoverCardPosition.leftStart => Alignment.topRight,
        VHoverCardPosition.leftEnd => Alignment.bottomRight,
        VHoverCardPosition.right => Alignment.centerLeft,
        VHoverCardPosition.rightStart => Alignment.topLeft,
        VHoverCardPosition.rightEnd => Alignment.bottomLeft,
      };

  Alignment _getScaleAlignment() => switch (widget.position) {
    VHoverCardPosition.top ||
    VHoverCardPosition.topStart ||
    VHoverCardPosition.topEnd => Alignment.bottomCenter,
    VHoverCardPosition.bottom ||
    VHoverCardPosition.bottomStart ||
    VHoverCardPosition.bottomEnd => Alignment.topCenter,
    VHoverCardPosition.left ||
    VHoverCardPosition.leftStart ||
    VHoverCardPosition.leftEnd => Alignment.centerRight,
    VHoverCardPosition.right ||
    VHoverCardPosition.rightStart ||
    VHoverCardPosition.rightEnd => Alignment.centerLeft,
  };

  @override
  // Style overrides are applied in _createOverlayEntry.
  Widget build(BuildContext context) => CompositedTransformTarget(
    link: _layerLink,
    child: Semantics(
      button: true,
      hint: _isTouchDevice
          ? VoloLocalizations.of(context).hoverCardHintTap
          : VoloLocalizations.of(context).hoverCardHintHover,
      child: MouseRegion(
        key: _triggerKey,
        onEnter: _handleTriggerEnter,
        onExit: _handleTriggerExit,
        child: GestureDetector(
          onTap: widget.enabled
              ? () {
                  if (_isOpen) {
                    _hideOverlay();
                  } else {
                    _openTimer?.cancel();
                    _showOverlay();
                  }
                }
              : null,
          child: widget.child,
        ),
      ),
    ),
  );
}
