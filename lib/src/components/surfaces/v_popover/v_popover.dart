import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_popover_style.dart';

/// {@template v_popover_position}
/// Popover position.
///
/// Specifies where the popover is displayed relative to the trigger widget.
/// {@endtemplate}
enum VPopoverPosition {
  /// Top center.
  top,

  /// Top start (left in LTR, right in RTL).
  topStart,

  /// Top end (right in LTR, left in RTL).
  topEnd,

  /// Bottom center.
  bottom,

  /// Bottom start (left in LTR, right in RTL).
  bottomStart,

  /// Bottom end (right in LTR, left in RTL).
  bottomEnd,

  /// Left center.
  left,

  /// Right center.
  right,
}

/// {@template v_popover_controller}
/// Popover controller.
///
/// Programmatically controls the open/close state of a popover.
///
/// **Basic Usage:**
///
/// ```dart
/// final controller = VPopoverController();
///
/// // Open the popover
/// controller.show();
///
/// // Close the popover
/// controller.hide();
///
/// // Toggle the popover
/// controller.toggle();
///
/// // Check the state
/// if (controller.isOpen) {
///   print('Popover is open.');
/// }
/// ```
///
/// **With VPopover:**
///
/// ```dart
/// final _popoverController = VPopoverController();
///
/// VPopover(
///   controller: _popoverController,
///   content: Text('Popover content'),
///   child: VButton(
///     onPressed: null, // Controlled via controller
///     child: Text('Open'),
///   ),
/// )
///
/// // Open from elsewhere
/// _popoverController.show();
/// ```
/// {@endtemplate}
class VPopoverController extends ChangeNotifier {
  bool _isOpen = false;
  VoidCallback? _rebuildCallback;

  /// Whether the popover is open.
  bool get isOpen => _isOpen;

  /// Opens the popover.
  ///
  /// Does nothing if already open.
  void show() {
    if (!_isOpen) {
      _isOpen = true;
      notifyListeners();
    }
  }

  /// Closes the popover.
  ///
  /// Does nothing if already closed.
  void hide() {
    if (_isOpen) {
      _isOpen = false;
      notifyListeners();
    }
  }

  /// Toggles the popover.
  ///
  /// Opens if closed, closes if open.
  void toggle() {
    _isOpen = !_isOpen;
    notifyListeners();
  }

  /// Rebuilds the OverlayEntry.
  ///
  /// Call when the popover content has changed.
  void rebuild() {
    _rebuildCallback?.call();
  }
}

/// {@template v_popover}
/// Floating panel with interactive content that opens next to its trigger.
///
/// Unlike [VTooltip], the content can hold buttons and forms.
///
/// ```dart
/// VPopover(
///   position: VPopoverPosition.bottomStart,
///   content: Column(
///     mainAxisSize: MainAxisSize.min,
///     children: [
///       Text('Popover Title'),
///       SizedBox(height: 8),
///       Text('Popover content goes here.'),
///     ],
///   ),
///   child: VButton(
///     onPressed: null, // the popover opens on tap
///     child: Text('Open'),
///   ),
/// )
/// ```
///
/// **Positions:**
///
/// - [VPopoverPosition.top] - Top center
/// - [VPopoverPosition.topStart] - Top start
/// - [VPopoverPosition.topEnd] - Top end
/// - [VPopoverPosition.bottom] - Bottom center (default)
/// - [VPopoverPosition.bottomStart] - Bottom start
/// - [VPopoverPosition.bottomEnd] - Bottom end
/// - [VPopoverPosition.left] - Left center
/// - [VPopoverPosition.right] - Right center
///
/// **With Controller:**
///
/// ```dart
/// final _controller = VPopoverController();
///
/// VPopover(
///   controller: _controller,
///   content: Column(
///     mainAxisSize: MainAxisSize.min,
///     children: [
///       Text('Menu'),
///       VButton(
///         onPressed: () {
///           _controller.hide();
///           // Perform action
///         },
///         child: Text('Select'),
///       ),
///     ],
///   ),
///   child: VButton(onPressed: null, child: Text('Menu')),
/// )
/// ```
///
/// **Custom Position:**
///
/// ```dart
/// VPopover(
///   position: VPopoverPosition.topEnd,
///   offset: Offset(0, 12),
///   content: Text('Displayed at top end'),
///   child: VButton(onPressed: null, child: Text('Open')),
/// )
/// ```
///
/// See also:
///
/// - [VPopoverController], programmatic control for the popover
/// - [VPopoverPosition], popover position enum
/// - [VTooltip], a simple overlay for informational text
/// {@endtemplate}
class VPopover extends StatefulWidget {
  /// {@macro v_popover}
  const VPopover({
    required this.content,
    required this.child,
    super.key,
    this.controller,
    this.position = VPopoverPosition.bottom,
    this.offset = const Offset(0, 8),
    this.barrierDismissible = true,
    this.barrierColor,
    this.triggerOnTap = true,
    this.style,
  });

  /// Interactive content shown inside the popover.
  final Widget content;

  /// Trigger widget that anchors the popover and opens it when tapped.
  final Widget child;

  /// Opens and closes the popover from code; an internal one is created when null.
  final VPopoverController? controller;

  /// Where the popover appears relative to [child]. Defaults to [VPopoverPosition.bottom].
  final VPopoverPosition position;

  /// Gap between [child] and the popover. Defaults to `Offset(0, 8)`.
  final Offset offset;

  /// Whether tapping outside the popover, or pressing Escape, closes it.
  final bool barrierDismissible;

  /// Color painted behind the popover while open; transparent when null.
  final Color? barrierColor;

  /// Whether tapping [child] toggles the popover; set to `false` to use only [controller].
  final bool triggerOnTap;

  /// Style override.
  final VPopoverStyle? style;

  @override
  State<VPopover> createState() => _VPopoverState();
}

class _VPopoverState extends State<VPopover>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  VPopoverController? _internalController;
  VPopoverController? _attachedController;
  VThemeData? _capturedTheme;
  VoloLocalizations? _capturedLocalizations;
  bool _triggerFocused = false;

  VPopoverController get _controller =>
      widget.controller ?? (_internalController ??= VPopoverController());

  void _attachController() {
    final controller = _controller;
    _attachedController = controller;
    controller
      ..addListener(_handleControllerChange)
      .._rebuildCallback = _rebuildOverlay;
  }

  void _detachController() {
    final controller = _attachedController;
    if (controller == null) return;
    controller.removeListener(_handleControllerChange);
    if (controller._rebuildCallback == _rebuildOverlay) {
      controller._rebuildCallback = null;
    }
    _attachedController = null;
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

    _attachController();
  }

  void _rebuildOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _capturedTheme = VTheme.maybeOf(context);
    _capturedLocalizations = VoloLocalizations.maybeOf(context);
    if (_capturedTheme != null) {
      _animationController.duration = _capturedTheme!.animations.fast;
    }
  }

  @override
  void didUpdateWidget(VPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      // The effective controller may change from external to the internal one
      // (null) and back; move the listener and the rebuild hook with it.
      _detachController();
      _attachController();
      // Overlay changes are not allowed while building, so sync after it.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _handleControllerChange();
      });
    }
    // Rebuild OverlayEntry when content changes
    if (_overlayEntry != null && widget.content != oldWidget.content) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    }
  }

  @override
  void dispose() {
    _detachController();
    // WHY: Reversing the animation and removing the entry afterwards cannot
    // finish once the controller is disposed, and a leftover entry keeps the
    // full-screen barrier on screen, so remove it right away.
    _removeEntry();
    _internalController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleControllerChange() {
    if (_controller.isOpen) {
      _showPopover();
    } else {
      _hidePopover();
    }
  }

  void _removeEntry() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  void _showPopover() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
    // A popover that is still fading out is brought back, not dropped.
    unawaited(_animationController.forward());
  }

  void _hidePopover() {
    if (_overlayEntry == null) return;

    unawaited(
      _animationController.reverse().then((_) {
        // A show during the fade-out turns the controller around and keeps
        // the entry.
        if (_animationController.status == AnimationStatus.dismissed &&
            !_controller.isOpen) {
          _removeEntry();
        }
      }),
    );
  }

  void _togglePopover() {
    _controller.toggle();
  }

  OverlayEntry _createOverlayEntry() => OverlayEntry(
    builder: (context) {
      final themeStyle = _capturedTheme?.componentOverrides
          .get<VPopoverStyle>();
      final overlayResolvedStyle =
          themeStyle?.merge(widget.style) ?? widget.style;
      return _PopoverOverlay(
        layerLink: _layerLink,
        position: widget.position,
        offset: widget.offset,
        barrierDismissible: widget.barrierDismissible,
        barrierColor: widget.barrierColor,
        fadeAnimation: _fadeAnimation,
        scaleAnimation: _scaleAnimation,
        onDismiss: () => _controller.hide(),
        content: widget.content,
        themeData: _capturedTheme,
        localizations: _capturedLocalizations,
        resolvedStyle: overlayResolvedStyle,
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    // Style overrides are applied in _createOverlayEntry → _PopoverOverlay

    if (widget.triggerOnTap) {
      // Toggle on tap: intercept child taps to toggle popover
      return CompositedTransformTarget(
        link: _layerLink,
        child: Semantics(
          button: true,
          label: VoloLocalizations.of(context).popoverTriggerLabel,
          child: Focus(
            onFocusChange: (focused) {
              if (mounted) setState(() => _triggerFocused = focused);
            },
            onKeyEvent: (node, event) {
              // Enter and Space open and close the popover from the keyboard.
              if (event is KeyDownEvent &&
                  (event.logicalKey == LogicalKeyboardKey.enter ||
                      event.logicalKey == LogicalKeyboardKey.numpadEnter ||
                      event.logicalKey == LogicalKeyboardKey.space)) {
                _togglePopover();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                borderRadius: (VTheme.maybeOf(context) ?? VThemeData.light())
                    .radius
                    .mdRadius,
                border: _triggerFocused
                    ? Border.all(
                        color: (VTheme.maybeOf(context) ?? VThemeData.light())
                            .colors
                            .ring,
                        width: 2,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  // Child widget (visual only, taps ignored)
                  IgnorePointer(child: widget.child),
                  // Tap handler on top
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _togglePopover,
                      behavior: HitTestBehavior.opaque,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      // Programmatic control: child handles its own tap events
      return CompositedTransformTarget(link: _layerLink, child: widget.child);
    }
  }
}

class _PopoverOverlay extends StatelessWidget {
  const _PopoverOverlay({
    required this.layerLink,
    required this.position,
    required this.offset,
    required this.barrierDismissible,
    required this.barrierColor,
    required this.fadeAnimation,
    required this.scaleAnimation,
    required this.onDismiss,
    required this.content,
    this.themeData,
    this.localizations,
    this.resolvedStyle,
  });

  final LayerLink layerLink;
  final VPopoverPosition position;
  final Offset offset;
  final VThemeData? themeData;
  final VoloLocalizations? localizations;
  final bool barrierDismissible;
  final Color? barrierColor;
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;
  final VoidCallback onDismiss;
  final Widget content;
  final VPopoverStyle? resolvedStyle;

  // The horizontal offset of top and bottom positions follows the text
  // direction: a positive dx moves the popover toward the end side.
  Offset _offsetFor(TextDirection direction) {
    final dx = direction == TextDirection.rtl ? -offset.dx : offset.dx;
    switch (position) {
      case VPopoverPosition.top:
      case VPopoverPosition.topStart:
      case VPopoverPosition.topEnd:
        return Offset(dx, -offset.dy);
      case VPopoverPosition.bottom:
      case VPopoverPosition.bottomStart:
      case VPopoverPosition.bottomEnd:
        return Offset(dx, offset.dy);
      case VPopoverPosition.left:
        return Offset(-offset.dy, offset.dx);
      case VPopoverPosition.right:
        return Offset(offset.dy, offset.dx);
    }
  }

  Alignment _targetAnchor(TextDirection direction) {
    switch (position) {
      case VPopoverPosition.top:
        return Alignment.topCenter;
      case VPopoverPosition.topStart:
        return AlignmentDirectional.topStart.resolve(direction);
      case VPopoverPosition.topEnd:
        return AlignmentDirectional.topEnd.resolve(direction);
      case VPopoverPosition.bottom:
        return Alignment.bottomCenter;
      case VPopoverPosition.bottomStart:
        return AlignmentDirectional.bottomStart.resolve(direction);
      case VPopoverPosition.bottomEnd:
        return AlignmentDirectional.bottomEnd.resolve(direction);
      case VPopoverPosition.left:
        return Alignment.centerLeft;
      case VPopoverPosition.right:
        return Alignment.centerRight;
    }
  }

  Alignment _followerAnchor(TextDirection direction) {
    switch (position) {
      case VPopoverPosition.top:
        return Alignment.bottomCenter;
      case VPopoverPosition.topStart:
        return AlignmentDirectional.bottomStart.resolve(direction);
      case VPopoverPosition.topEnd:
        return AlignmentDirectional.bottomEnd.resolve(direction);
      case VPopoverPosition.bottom:
        return Alignment.topCenter;
      case VPopoverPosition.bottomStart:
        return AlignmentDirectional.topStart.resolve(direction);
      case VPopoverPosition.bottomEnd:
        return AlignmentDirectional.topEnd.resolve(direction);
      case VPopoverPosition.left:
        return Alignment.centerRight;
      case VPopoverPosition.right:
        return Alignment.centerLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = themeData ?? VTheme.maybeOf(context) ?? VThemeData.light();
    final l10n =
        localizations ??
        VoloLocalizations.maybeOf(context) ??
        const VoloLocalizationsEn();
    final colors = theme.colors;
    final direction = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final followerAnchor = _followerAnchor(direction);

    final bgColor = resolvedStyle?.backgroundColor ?? colors.popover;
    final fgColor = resolvedStyle?.foregroundColor ?? colors.popoverForeground;
    final popoverBorderRadius =
        resolvedStyle?.borderRadius ?? theme.radius.mdRadius;
    final popoverPadding =
        resolvedStyle?.padding ?? EdgeInsets.all(theme.spacing.lg);

    return Stack(
      children: [
        // Barrier
        if (barrierDismissible || barrierColor != null)
          Positioned.fill(
            child: GestureDetector(
              onTap: barrierDismissible ? onDismiss : null,
              child: Container(color: barrierColor ?? VColors.transparent),
            ),
          ),
        // Popover
        CompositedTransformFollower(
          link: layerLink,
          targetAnchor: _targetAnchor(direction),
          followerAnchor: followerAnchor,
          offset: _offsetFor(direction),
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              alignment: followerAnchor,
              child: VTheme(
                data: theme,
                localizations: l10n,
                child: DefaultTextStyle(
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: fgColor,
                  ),
                  child: Semantics(
                    scopesRoute: true,
                    explicitChildNodes: true,
                    label: l10n.popoverLabel,
                    child: FocusTraversalGroup(
                      policy: WidgetOrderTraversalPolicy(),
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
                          constraints: const BoxConstraints(maxWidth: 320),
                          padding: popoverPadding,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: popoverBorderRadius,
                            border: resolvedStyle?.borderColor != null
                                ? Border.all(color: resolvedStyle!.borderColor!)
                                : null,
                            boxShadow: theme.shadows.md,
                          ),
                          child: content,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
