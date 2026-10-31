import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_scroll_area_style.dart';

/// Scrollable area with a themed, fading scrollbar.
///
/// Wraps [child] in a [SingleChildScrollView] and a [RawScrollbar] styled from
/// [VTheme]. Use [VScrollArea.horizontal] or [VScrollArea.both] for other
/// directions. Share a [controller] to read or drive the scroll offset.
///
/// **Basic Usage:**
///
/// ```dart
/// VScrollArea(
///   child: Column(
///     children: List.generate(50, (i) => VListTile(title: Text('Item $i'))),
///   ),
/// )
/// ```
///
/// **Variants:**
///
/// - [VScrollArea] - Vertical scroll (default)
/// - [VScrollArea.horizontal] - Horizontal scroll
/// - [VScrollArea.both] - Bidirectional scroll
///
/// **With Controller:**
///
/// ```dart
/// final controller = ScrollController();
///
/// VScrollArea(
///   controller: controller,
///   thumbVisibility: true,
///   child: Column(children: rows),
/// )
/// ```
class VScrollArea extends StatefulWidget {
  /// Creates a scroll area that scrolls vertically.
  const VScrollArea({
    required this.child,
    super.key,
    this.controller,
    this.padding,
    this.scrollbarThickness,
    this.scrollbarRadius,
    this.thumbVisibility = false,
    this.trackVisibility = false,
    this.thumbColor,
    this.trackColor,
    this.style,
  }) : _direction = Axis.vertical,
       _enableBothDirections = false;

  /// Creates a scroll area that scrolls horizontally.
  const VScrollArea.horizontal({
    required this.child,
    super.key,
    this.controller,
    this.padding,
    this.scrollbarThickness,
    this.scrollbarRadius,
    this.thumbVisibility = false,
    this.trackVisibility = false,
    this.thumbColor,
    this.trackColor,
    this.style,
  }) : _direction = Axis.horizontal,
       _enableBothDirections = false;

  /// Creates a scroll area that scrolls both ways, with two scrollbars.
  const VScrollArea.both({
    required this.child,
    super.key,
    this.controller,
    this.padding,
    this.scrollbarThickness,
    this.scrollbarRadius,
    this.thumbVisibility = false,
    this.trackVisibility = false,
    this.thumbColor,
    this.trackColor,
    this.style,
  }) : _direction = Axis.vertical,
       _enableBothDirections = true;

  /// Content that scrolls; it is not itself a scroll view.
  final Widget child;

  /// Controls the scroll offset; drives the vertical axis in [VScrollArea.both].
  final ScrollController? controller;

  /// Space around [child] inside the scrolling area.
  final EdgeInsets? padding;

  /// Scrollbar width in logical pixels; defaults to 6.
  final double? scrollbarThickness;

  /// Corner radius of the scrollbar thumb; defaults to 3.
  final double? scrollbarRadius;

  /// Whether the thumb stays visible instead of fading out.
  final bool thumbVisibility;

  /// Whether the track behind the thumb is drawn.
  final bool trackVisibility;

  /// Thumb color; defaults to a translucent muted foreground.
  final Color? thumbColor;

  /// Track color, shown only while [trackVisibility] is true.
  final Color? trackColor;

  /// Overrides the theme style, for example thickness, radius and color.
  final VScrollAreaStyle? style;

  final Axis _direction;
  final bool _enableBothDirections;

  @override
  State<VScrollArea> createState() => _VScrollAreaState();
}

class _VScrollAreaState extends State<VScrollArea> {
  // The caller's controller drives the primary axis only: vertical, or
  // horizontal for VScrollArea.horizontal. Every other axis gets a controller
  // owned (created and disposed) by this state, so one controller is never
  // attached to two scroll views.
  ScrollController? _ownedVertical;
  ScrollController? _ownedHorizontal;

  bool get _externalIsHorizontal =>
      widget._direction == Axis.horizontal && !widget._enableBothDirections;

  ScrollController get _verticalController =>
      (widget.controller != null && !_externalIsHorizontal)
      ? widget.controller!
      : (_ownedVertical ??= ScrollController());

  ScrollController get _horizontalController =>
      (widget.controller != null && _externalIsHorizontal)
      ? widget.controller!
      : (_ownedHorizontal ??= ScrollController());

  @override
  void didUpdateWidget(VScrollArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      // Release owned controllers that the new external controller replaces;
      // the ones still needed are re-created lazily by the getters.
      if (widget.controller != null) {
        if (_externalIsHorizontal) {
          _ownedHorizontal?.dispose();
          _ownedHorizontal = null;
        } else {
          _ownedVertical?.dispose();
          _ownedVertical = null;
        }
      }
    }
  }

  @override
  void dispose() {
    _ownedVertical?.dispose();
    _ownedHorizontal?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides
    // Precedence: instance style > constructor argument > theme override >
    // built-in default.
    final themeStyle = theme.componentOverrides.get<VScrollAreaStyle>();
    final instanceStyle = widget.style;

    final thumbColor =
        instanceStyle?.scrollbarColor ??
        widget.thumbColor ??
        themeStyle?.scrollbarColor ??
        theme.colors.mutedForeground.withValues(alpha: 0.4);
    final trackColor = widget.trackColor ?? theme.colors.muted;

    final effectiveThickness =
        instanceStyle?.scrollbarThickness ??
        widget.scrollbarThickness ??
        themeStyle?.scrollbarThickness ??
        6.0;
    final styleRadius =
        instanceStyle?.scrollbarRadius ?? themeStyle?.scrollbarRadius;
    final effectiveRadius = instanceStyle?.scrollbarRadius != null
        ? instanceStyle!.scrollbarRadius!.topLeft
        : widget.scrollbarRadius != null
        ? Radius.circular(widget.scrollbarRadius!)
        : styleRadius != null
        ? styleRadius.topLeft
        : const Radius.circular(3);

    if (widget._enableBothDirections) {
      return _buildBothDirections(
        theme,
        thumbColor,
        trackColor,
        effectiveThickness,
        effectiveRadius,
      );
    }

    return _buildSingleDirection(
      theme,
      thumbColor,
      trackColor,
      effectiveThickness,
      effectiveRadius,
    );
  }

  Widget _buildSingleDirection(
    VThemeData theme,
    Color thumbColor,
    Color trackColor,
    double thickness,
    Radius radius,
  ) {
    final isHorizontal = widget._direction == Axis.horizontal;
    final controller = isHorizontal
        ? _horizontalController
        : _verticalController;

    return RawScrollbar(
      controller: controller,
      thumbVisibility: widget.thumbVisibility,
      trackVisibility: widget.trackVisibility,
      thickness: thickness,
      radius: radius,
      thumbColor: thumbColor,
      trackColor: widget.trackVisibility ? trackColor : null,
      fadeDuration: theme.animations.normal,
      timeToFade: theme.animations.slow,
      child: SingleChildScrollView(
        controller: controller,
        scrollDirection: widget._direction,
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }

  Widget _buildBothDirections(
    VThemeData theme,
    Color thumbColor,
    Color trackColor,
    double thickness,
    Radius radius,
  ) => RawScrollbar(
    controller: _verticalController,
    thumbVisibility: widget.thumbVisibility,
    trackVisibility: widget.trackVisibility,
    thickness: thickness,
    radius: radius,
    thumbColor: thumbColor,
    trackColor: widget.trackVisibility ? trackColor : null,
    fadeDuration: theme.animations.normal,
    timeToFade: theme.animations.slow,
    notificationPredicate: (notification) => notification.depth == 0,
    child: RawScrollbar(
      controller: _horizontalController,
      thumbVisibility: widget.thumbVisibility,
      trackVisibility: widget.trackVisibility,
      thickness: thickness,
      radius: radius,
      thumbColor: thumbColor,
      trackColor: widget.trackVisibility ? trackColor : null,
      fadeDuration: theme.animations.normal,
      timeToFade: theme.animations.slow,
      notificationPredicate: (notification) => notification.depth == 1,
      child: SingleChildScrollView(
        controller: _verticalController,
        padding: widget.padding,
        child: SingleChildScrollView(
          controller: _horizontalController,
          scrollDirection: Axis.horizontal,
          child: widget.child,
        ),
      ),
    ),
  );
}
