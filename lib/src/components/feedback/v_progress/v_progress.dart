import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_progress_style.dart';

/// Progress bar size.
///
/// Specifies the size of [VProgress]:
/// - [sm] - Small size (linear: 4px, circular: 24px)
/// - [md] - Medium size (linear: 8px, circular: 40px) - default
/// - [lg] - Large size (linear: 12px, circular: 56px)
enum VProgressSize {
  /// Small size.
  sm,

  /// Medium size (default).
  md,

  /// Large size.
  lg,
}

/// {@template v_progress}
/// Bar or ring that shows how far an operation has come, or that it is still running.
///
/// Pass a `value` from 0.0 to 1.0 for determinate progress, or leave it null
/// for an endless animation. Use [VProgress.linear] or [VProgress.circular].
///
/// ```dart
/// VProgress.linear(value: 0.6, size: VProgressSize.lg)
/// ```
///
/// See also:
///
///  * [VSkeleton], content loading placeholder
///  * [VStepper], step-by-step progress indicator
/// {@endtemplate}
class VProgress extends StatefulWidget {
  /// Horizontal progress bar.
  const VProgress.linear({
    super.key,
    this.value,
    this.size = VProgressSize.md,
    this.color,
    this.backgroundColor,
    this.style,
  }) : assert(
         value == null || (value >= 0.0 && value <= 1.0),
         'VProgress: value must be between 0.0 and 1.0',
       ),
       _type = _VProgressType.linear;

  /// Circular progress ring.
  const VProgress.circular({
    super.key,
    this.value,
    this.size = VProgressSize.md,
    this.color,
    this.backgroundColor,
    this.style,
  }) : assert(
         value == null || (value >= 0.0 && value <= 1.0),
         'VProgress: value must be between 0.0 and 1.0',
       ),
       _type = _VProgressType.circular;

  final _VProgressType _type;

  /// Style override.
  final VProgressStyle? style;

  /// Completed fraction from 0.0 to 1.0, or null for an endless animation.
  final double? value;

  /// Thickness of the bar or diameter of the ring.
  final VProgressSize size;

  /// Color of the filled part. Defaults to the theme's primary color.
  final Color? color;

  /// Color of the unfilled track. Defaults to the theme's muted color.
  final Color? backgroundColor;

  @override
  State<VProgress> createState() => _VProgressState();
}

enum _VProgressType { linear, circular }

class _VProgressState extends State<VProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      // Updated to theme.animations.extraSlow in didChangeDependencies.
      duration: VAnimations.defaults.extraSlow,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    if (widget.value == null) {
      unawaited(_controller.repeat());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _controller.duration = theme.animations.extraSlow;
  }

  @override
  void didUpdateWidget(VProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && oldWidget.value != null) {
      unawaited(_controller.repeat());
    } else if (widget.value != null && oldWidget.value == null) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getSizeValue() {
    final theme = VTheme.of(context);
    if (widget._type == _VProgressType.linear) {
      return switch (widget.size) {
        VProgressSize.sm => theme.spacing.xs,
        VProgressSize.md => theme.spacing.sm,
        VProgressSize.lg => theme.spacing.md,
      };
    } else {
      return switch (widget.size) {
        VProgressSize.sm => theme.sizes.xs.height,
        VProgressSize.md => theme.sizes.md.height,
        VProgressSize.lg => theme.sizes.xl.height,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VProgressStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;
    final colors = theme.colors;
    final l10n = VoloLocalizations.of(context);

    var progressColor = widget.color ?? colors.primary;
    var trackColor = widget.backgroundColor ?? colors.muted;
    var sizeValue = _getSizeValue();
    // NaN has no position on the bar; treat it as an unknown (indeterminate)
    // value instead of crashing when the percentage is rounded.
    final rawValue = widget.value;
    final clampedValue = rawValue == null || rawValue.isNaN
        ? null
        : rawValue.clamp(0.0, 1.0);

    if (resolvedStyle != null) {
      progressColor = resolvedStyle.activeColor ?? progressColor;
      trackColor = resolvedStyle.inactiveColor ?? trackColor;
      if (resolvedStyle.trackHeight != null) {
        sizeValue = resolvedStyle.trackHeight!;
      }
    }

    if (widget._type == _VProgressType.linear) {
      return _buildLinear(
        progressColor,
        trackColor,
        sizeValue,
        clampedValue,
        l10n,
      );
    } else {
      return _buildCircular(
        progressColor,
        trackColor,
        sizeValue,
        clampedValue,
        l10n,
      );
    }
  }

  Widget _buildLinear(
    Color progressColor,
    Color trackColor,
    double height,
    double? value,
    VoloLocalizations l10n,
  ) => Semantics(
    // WCAG 4.1.3: liveRegion for dynamic progress updates
    liveRegion: true,
    value: value != null ? '${(value * 100).round()}%' : null,
    label: value == null ? l10n.progressLoading : null,
    child: SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: Stack(
          children: [
            // Track
            Container(color: trackColor),
            // Progress
            if (value != null)
              FractionallySizedBox(
                widthFactor: value,
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
              )
            else
              // The block sweeps the real width of the bar.
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.hasBoundedWidth
                        ? constraints.maxWidth
                        : 200.0;
                    return AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) => Stack(
                        children: [
                          Positioned(
                            left: _animation.value * (width + 100) - 100,
                            child: Container(
                              width: 100,
                              height: height,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    trackColor,
                                    progressColor,
                                    trackColor,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    ),
  );

  Widget _buildCircular(
    Color progressColor,
    Color trackColor,
    double size,
    double? value,
    VoloLocalizations l10n,
  ) {
    final strokeWidth = size / 8;

    return Semantics(
      // WCAG 4.1.3: liveRegion for dynamic progress updates
      liveRegion: true,
      value: value != null ? '${(value * 100).round()}%' : null,
      label: value == null ? l10n.progressLoading : null,
      child: SizedBox(
        width: size,
        height: size,
        child: value != null
            ? CustomPaint(
                painter: _CircularProgressPainter(
                  value: value,
                  progressColor: progressColor,
                  trackColor: trackColor,
                  strokeWidth: strokeWidth,
                ),
              )
            : AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => Transform.rotate(
                  angle: _animation.value * 2 * math.pi,
                  child: CustomPaint(
                    painter: _CircularProgressPainter(
                      value: 0.25,
                      progressColor: progressColor,
                      trackColor: trackColor,
                      strokeWidth: strokeWidth,
                      indeterminate: true,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

// CONSTRAINT: CustomPainter for circular progress — Flutter has no built-in
// circular progress widget outside Material. Using Canvas.drawArc gives
// precise control over stroke cap, track visibility, and sweep angle.
class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({
    required this.value,
    required this.progressColor,
    required this.trackColor,
    required this.strokeWidth,
    this.indeterminate = false,
  });

  final double value;
  final Color progressColor;
  final Color trackColor;
  final double strokeWidth;
  final bool indeterminate;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    if (!indeterminate) {
      final trackPaint = Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawCircle(center, radius, trackPaint);
    }

    // Progress
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * value;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  // CONSTRAINT: shouldRepaint must compare all visual fields — returning
  // false unconditionally causes stale rendering when theme changes or
  // progress value updates. Every field that affects paint output must
  // be compared.
  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) =>
      value != oldDelegate.value ||
      progressColor != oldDelegate.progressColor ||
      trackColor != oldDelegate.trackColor ||
      strokeWidth != oldDelegate.strokeWidth;
}
