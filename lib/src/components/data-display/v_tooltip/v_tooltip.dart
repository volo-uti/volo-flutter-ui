import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_tooltip_style.dart';

/// Tooltip position.
enum VTooltipPosition {
  /// Top.
  top,

  /// Bottom.
  bottom,

  /// Left.
  left,

  /// Right.
  right,
}

/// Small overlay that explains a widget on hover or long press.
///
/// Pass plain text as [message], or a widget as [richMessage] for icons and
/// styled text. Exactly one of the two is required.
///
/// ```dart
/// VTooltip(
///   message: 'Copy to clipboard',
///   position: VTooltipPosition.bottom,
///   waitDuration: Duration(milliseconds: 200),
///   child: Icon(IconData(0xe14d, fontFamily: 'MaterialIcons')),
/// )
/// ```
///
/// See also:
///
/// - [VTooltipPosition], where the tooltip appears.
class VTooltip extends StatefulWidget {
  /// Creates a tooltip from [message] or [richMessage].
  const VTooltip({
    required this.child,
    super.key,
    this.message,
    this.richMessage,
    this.position = VTooltipPosition.top,
    this.waitDuration = const Duration(milliseconds: 500),
    this.showDuration = const Duration(milliseconds: 1500),
    this.maxWidth,
    this.style,
  }) : assert(
         (message == null) != (richMessage == null),
         'Provide exactly one of message or richMessage.',
       );

  /// Plain text of the tooltip; also announced by screen readers.
  final String? message;

  /// Widget shown instead of [message], for icons or styled text.
  final Widget? richMessage;

  /// Widget the tooltip describes.
  final Widget child;

  /// Side of [child] the tooltip appears on.
  final VTooltipPosition position;

  /// Time the pointer must rest on [child] before the tooltip shows.
  final Duration waitDuration;

  /// Time the tooltip stays visible before hiding on its own.
  final Duration showDuration;

  /// Maximum width constraint for the tooltip.
  final double? maxWidth;

  /// Per-instance style override merged over the theme style.
  final VTooltipStyle? style;

  @override
  State<VTooltip> createState() => _VTooltipState();
}

class _VTooltipState extends State<VTooltip>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  Timer? _waitTimer;
  Timer? _showTimer;
  VThemeData? _capturedTheme;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // WHY: Sentinel Duration pattern — constructor defaults must be const, but
  // theme tokens are only available at runtime. By comparing the parameter
  // against this sentinel, we detect "caller used the default" and substitute
  // the theme token. Explicit caller values always win.
  /// Sentinel value matching the constructor default for [VTooltip.waitDuration].
  static const Duration _defaultWaitDuration = Duration(milliseconds: 500);

  /// Sentinel value matching the constructor default for [VTooltip.showDuration].
  static const Duration _defaultShowDuration = Duration(milliseconds: 1500);

  /// Returns the effective wait duration, preferring the theme token
  /// when the caller uses the constructor default.
  Duration _effectiveWaitDuration(VThemeData theme) {
    if (widget.waitDuration == _defaultWaitDuration) {
      return theme.animations.slow;
    }
    return widget.waitDuration;
  }

  /// Returns the effective show duration, preferring the theme token
  /// when the caller uses the constructor default.
  Duration _effectiveShowDuration(VThemeData theme) {
    if (widget.showDuration == _defaultShowDuration) {
      return theme.animations.extraSlow;
    }
    return widget.showDuration;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _capturedTheme = VTheme.maybeOf(context);
    if (_capturedTheme != null) {
      _animationController.duration = _capturedTheme!.animations.fast;
    }
  }

  @override
  void dispose() {
    _waitTimer?.cancel();
    _showTimer?.cancel();
    // WHY: Reversing the controller and removing the entry afterwards cannot
    // finish once the controller is disposed, so remove the entry right away.
    _removeEntry();
    _animationController.dispose();
    super.dispose();
  }

  void _removeEntry() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  void _showTooltip() {
    _showTimer?.cancel();
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
    // A tooltip that is still fading out is brought back, not dropped.
    unawaited(_animationController.forward());

    final theme = _capturedTheme;
    final showDur = theme != null
        ? _effectiveShowDuration(theme)
        : widget.showDuration;
    _showTimer = Timer(showDur, _hideTooltip);
  }

  void _hideTooltip() {
    _waitTimer?.cancel();
    _showTimer?.cancel();
    _waitTimer = null;
    _showTimer = null;

    if (_overlayEntry != null) {
      unawaited(
        _animationController.reverse().then((_) {
          // Only remove once the fade-out ran to the end; a show during the
          // fade-out turns the controller around and keeps the entry.
          if (_animationController.status == AnimationStatus.dismissed) {
            _removeEntry();
          }
        }),
      );
    }
  }

  void _startWaiting() {
    _waitTimer?.cancel();
    final theme = _capturedTheme;
    final waitDur = theme != null
        ? _effectiveWaitDuration(theme)
        : widget.waitDuration;
    _waitTimer = Timer(waitDur, _showTooltip);
  }

  void _cancelWaiting() {
    _waitTimer?.cancel();
    _waitTimer = null;
  }

  OverlayEntry _createOverlayEntry() {
    final theme = _capturedTheme;
    final themeStyle = theme?.componentOverrides.get<VTooltipStyle>();
    final style = themeStyle?.merge(widget.style) ?? widget.style;
    return OverlayEntry(
      builder: (context) => _TooltipOverlay(
        layerLink: _layerLink,
        position: widget.position,
        message: widget.message,
        richMessage: widget.richMessage,
        fadeAnimation: _fadeAnimation,
        scaleAnimation: _scaleAnimation,
        themeData: _capturedTheme,
        onDismiss: _hideTooltip,
        maxWidth: widget.maxWidth,
        resolvedStyle: style,
      ),
    );
  }

  @override
  // Style overrides are applied in _createOverlayEntry → _TooltipOverlay
  Widget build(BuildContext context) => Semantics(
    tooltip: widget.message,
    // CONSTRAINT: CompositedTransformTarget/Follower pair — required for
    // overlay positioning relative to the trigger widget. LayerLink
    // connects the target's paint coordinates to the follower in the
    // Overlay, surviving scroll and layout changes.
    child: CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) => _startWaiting(),
        onExit: (_) {
          _cancelWaiting();
          _hideTooltip();
        },
        child: GestureDetector(
          onLongPressStart: (_) => _showTooltip(),
          onLongPressEnd: (_) => _hideTooltip(),
          child: widget.child,
        ),
      ),
    ),
  );
}

class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    required this.layerLink,
    required this.position,
    required this.fadeAnimation,
    required this.scaleAnimation,
    required this.onDismiss,
    this.message,
    this.richMessage,
    this.themeData,
    this.maxWidth,
    this.resolvedStyle,
  });

  final LayerLink layerLink;
  final VTooltipPosition position;
  final String? message;
  final Widget? richMessage;
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;
  final VoidCallback onDismiss;
  final VThemeData? themeData;
  final double? maxWidth;
  final VTooltipStyle? resolvedStyle;

  Offset _offsetOf(double gap) {
    switch (position) {
      case VTooltipPosition.top:
        return Offset(0, -gap);
      case VTooltipPosition.bottom:
        return Offset(0, gap);
      case VTooltipPosition.left:
        return Offset(-gap, 0);
      case VTooltipPosition.right:
        return Offset(gap, 0);
    }
  }

  Alignment get _targetAnchor {
    switch (position) {
      case VTooltipPosition.top:
        return Alignment.topCenter;
      case VTooltipPosition.bottom:
        return Alignment.bottomCenter;
      case VTooltipPosition.left:
        return Alignment.centerLeft;
      case VTooltipPosition.right:
        return Alignment.centerRight;
    }
  }

  Alignment get _followerAnchor {
    switch (position) {
      case VTooltipPosition.top:
        return Alignment.bottomCenter;
      case VTooltipPosition.bottom:
        return Alignment.topCenter;
      case VTooltipPosition.left:
        return Alignment.centerRight;
      case VTooltipPosition.right:
        return Alignment.centerLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = themeData ?? VTheme.maybeOf(context) ?? VThemeData.light();
    final colors = theme.colors;
    final typography = theme.typography;

    // Industry standard: dark background (foreground) + light text (background)
    final tooltipBg = resolvedStyle?.backgroundColor ?? colors.foreground;
    final tooltipFg = resolvedStyle?.foregroundColor ?? colors.background;

    final baseTextStyle = (resolvedStyle?.textStyle ?? typography.bodySmall)
        .copyWith(color: tooltipFg);
    final messageWidget =
        richMessage ?? Text(message ?? '', style: baseTextStyle);

    return CompositedTransformFollower(
      link: layerLink,
      targetAnchor: _targetAnchor,
      followerAnchor: _followerAnchor,
      offset: _offsetOf(theme.spacing.sm),
      child: FadeTransition(
        opacity: fadeAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: DefaultTextStyle(
            style: TextStyle(decoration: TextDecoration.none, color: tooltipFg),
            child: Focus(
              autofocus: true,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.escape) {
                  onDismiss();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: Container(
                constraints: BoxConstraints(maxWidth: maxWidth ?? 280),
                padding:
                    resolvedStyle?.padding ??
                    EdgeInsets.symmetric(
                      horizontal: theme.spacing.md,
                      vertical: theme.spacing.sm,
                    ),
                decoration: BoxDecoration(
                  color: tooltipBg,
                  borderRadius:
                      resolvedStyle?.borderRadius ?? theme.radius.smRadius,
                  boxShadow: theme.shadows.lg,
                ),
                child: messageWidget,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
