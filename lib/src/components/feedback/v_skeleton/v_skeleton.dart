import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_skeleton_style.dart';

/// Animation effect of a [VSkeleton]: pulse (default), wave or none.
enum VSkeletonAnimation {
  /// Light band sweeping across the block.
  wave,

  /// Opacity fading in and out (default).
  pulse,

  /// No animation.
  none,
}

/// {@template v_skeleton}
/// Animated gray placeholder that mimics the shape of content while it loads.
///
/// Use [VSkeleton.rectangular], [VSkeleton.text] or [VSkeleton.circular].
///
/// ```dart
/// Row(
///   children: [
///     VSkeleton.circular(size: 48),
///     SizedBox(width: 12),
///     Expanded(child: VSkeleton.text(lines: 2)),
///   ],
/// )
/// ```
///
/// See also:
///
///  * [VProgress], progress indicator
/// {@endtemplate}
class VSkeleton extends StatefulWidget {
  /// Rectangular block placeholder.
  const VSkeleton.rectangular({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.animation = VSkeletonAnimation.pulse,
    this.style,
  }) : _type = _VSkeletonType.box,
       lines = 1,
       spacing = 8,
       size = 40;

  /// Placeholder for one or more lines of text.
  const VSkeleton.text({
    super.key,
    this.width,
    this.lines = 1,
    this.spacing = 8,
    this.animation = VSkeletonAnimation.pulse,
    this.style,
  }) : _type = _VSkeletonType.text,
       height = 14,
       borderRadius = null,
       size = 40;

  /// Round placeholder, for avatars and icons.
  const VSkeleton.circular({
    super.key,
    this.size = 40,
    this.animation = VSkeletonAnimation.pulse,
    this.style,
  }) : _type = _VSkeletonType.circle,
       width = null,
       height = 40,
       borderRadius = null,
       lines = 1,
       spacing = 8;

  final _VSkeletonType _type;

  /// Style override.
  final VSkeletonStyle? style;

  /// Width in logical pixels; fills the available width when null.
  final double? width;

  /// Height of a rectangular skeleton; text lines are always 14 pixels high.
  final double height;

  /// Corner radius of a rectangular skeleton. Defaults to the theme's small radius.
  final BorderRadius? borderRadius;

  /// Number of lines in a text skeleton; the last one is shorter.
  final int lines;

  /// Vertical gap between text lines.
  final double spacing;

  /// Diameter of a circular skeleton.
  final double size;

  /// Animation effect. Defaults to [VSkeletonAnimation.pulse].
  final VSkeletonAnimation animation;

  @override
  State<VSkeleton> createState() => _VSkeletonState();
}

enum _VSkeletonType { box, text, circle }

class _VSkeletonState extends State<VSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _configure(VTheme.of(context));
  }

  @override
  void didUpdateWidget(VSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // WHY: The tween and the repeat mode depend on the animation kind, so a
    // change (wave to pulse, none to pulse) needs a fresh setup.
    if (widget.animation != oldWidget.animation) {
      _configure(VTheme.of(context));
    }
  }

  // Sets the duration, the value range and the repeat mode for
  // `widget.animation` with the theme's animation tokens.
  void _configure(VThemeData theme) {
    final isWave = widget.animation == VSkeletonAnimation.wave;
    _controller.duration = isWave
        ? theme.animations.extraSlow
        : theme.animations.verySlow;

    // WHY: Pulse uses 0.5→1 opacity range — fully disappearing (0→1) looks
    // broken/flickering. The 50% floor keeps the skeleton visible while
    // the subtle pulse signals "loading" state to the user.
    if (widget.animation == VSkeletonAnimation.pulse) {
      _animation = Tween<double>(begin: 0.5, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: theme.animations.curveSmooth,
        ),
      );
    } else {
      // WHY: Wave uses 0→1 as a position value (not opacity) — it drives
      // the gradient stop positions across the container width.
      _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    }

    if (widget.animation == VSkeletonAnimation.none) {
      _controller.stop();
    } else {
      unawaited(
        _controller.repeat(
          reverse: widget.animation == VSkeletonAnimation.pulse,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VSkeletonStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;
    final colors = theme.colors;

    // WCAG 4.1.3: liveRegion for loading state announcement
    return Semantics(
      liveRegion: true,
      label: VoloLocalizations.of(context).loading,
      child: _buildSkeleton(colors, resolvedStyle),
    );
  }

  Widget _buildSkeleton(VColors colors, VSkeletonStyle? resolvedStyle) {
    switch (widget._type) {
      case _VSkeletonType.box:
        return _buildBox(colors, resolvedStyle);
      case _VSkeletonType.text:
        return _buildText(colors, resolvedStyle);
      case _VSkeletonType.circle:
        return _buildCircle(colors, resolvedStyle);
    }
  }

  Widget _buildBox(VColors colors, VSkeletonStyle? resolvedStyle) =>
      _buildAnimatedContainer(
        colors: colors,
        width: widget.width,
        height: widget.height,
        borderRadius:
            resolvedStyle?.borderRadius ??
            widget.borderRadius ??
            VTheme.of(context).radius.smRadius,
        resolvedStyle: resolvedStyle,
      );

  Widget _buildText(VColors colors, VSkeletonStyle? resolvedStyle) {
    final effectiveLines = widget.lines > 0 ? widget.lines : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(effectiveLines, (index) {
        final isLast = index == effectiveLines - 1;
        final shortenLast = isLast && effectiveLines > 1;
        Widget line(double? width) => _buildAnimatedContainer(
          colors: colors,
          width: width,
          height: 14,
          borderRadius:
              resolvedStyle?.borderRadius ?? VTheme.of(context).radius.smRadius,
          resolvedStyle: resolvedStyle,
        );

        Widget child;
        if (!shortenLast) {
          child = line(widget.width);
        } else if (widget.width != null) {
          child = line(widget.width! * 0.75);
        } else {
          // No width: the lines fill the space, so take 75% of what is given.
          child = LayoutBuilder(
            builder: (context, constraints) => line(
              constraints.hasBoundedWidth ? constraints.maxWidth * 0.75 : null,
            ),
          );
        }
        return Padding(
          padding: EdgeInsetsDirectional.only(
            bottom: isLast ? 0 : widget.spacing,
          ),
          child: child,
        );
      }),
    );
  }

  Widget _buildCircle(VColors colors, VSkeletonStyle? resolvedStyle) =>
      _buildAnimatedContainer(
        colors: colors,
        width: widget.size,
        height: widget.size,
        borderRadius: BorderRadius.circular(widget.size / 2),
        resolvedStyle: resolvedStyle,
      );

  Widget _buildAnimatedContainer({
    required VColors colors,
    required double? width,
    required double height,
    required BorderRadius borderRadius,
    VSkeletonStyle? resolvedStyle,
  }) {
    final baseColor = resolvedStyle?.baseColor ?? colors.muted;

    if (widget.animation == VSkeletonAnimation.none) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: baseColor, borderRadius: borderRadius),
      );
    }

    if (widget.animation == VSkeletonAnimation.pulse) {
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Opacity(
          opacity: _animation.value,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: borderRadius,
            ),
          ),
        ),
      );
    }

    // Wave - make highlight brighter
    final highlightColor =
        resolvedStyle?.highlightColor ??
        Color.lerp(baseColor, colors.background, 0.6)!;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
