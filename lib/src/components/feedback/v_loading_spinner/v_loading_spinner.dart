import 'dart:async' show unawaited;
import 'dart:math' show pi;

import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_loading_spinner_style.dart';

/// Rotating arc that shows an operation is in progress, without a known end.
///
/// One rotation takes [VAnimations.verySlow] from the current theme.
///
/// ```dart
/// VLoadingSpinner(color: VTheme.of(context).colors.primary, size: 16)
/// ```
class VLoadingSpinner extends StatefulWidget {
  /// Creates an arc-based loading spinner.
  const VLoadingSpinner({
    required this.color,
    this.size,
    this.strokeWidth,
    this.style,
    super.key,
  });

  /// Style override.
  final VLoadingSpinnerStyle? style;

  /// Color of the active arc; the track uses the same color at 30% opacity.
  final Color color;

  /// Width and height of the spinner; fills the parent constraints when null.
  final double? size;

  /// Arc thickness; one twelfth of the width when null.
  final double? strokeWidth;

  @override
  State<VLoadingSpinner> createState() => _VLoadingSpinnerState();
}

class _VLoadingSpinnerState extends State<VLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      // Fallback until didChangeDependencies sets theme duration.
      duration: VAnimations.defaults.verySlow,
    );
    unawaited(_controller.repeat());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.duration = VTheme.of(context).animations.verySlow;
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
    final themeStyle = theme.componentOverrides.get<VLoadingSpinnerStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    final effectiveColor = resolvedStyle?.color ?? widget.color;
    final effectiveStrokeWidth =
        resolvedStyle?.strokeWidth ?? widget.strokeWidth;

    Widget spinner = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) =>
          Transform.rotate(angle: _controller.value * 2 * pi, child: child),
      child: CustomPaint(
        painter: _SpinnerPainter(
          color: effectiveColor,
          strokeWidth: effectiveStrokeWidth,
        ),
      ),
    );

    if (widget.size != null) {
      spinner = SizedBox.square(dimension: widget.size, child: spinner);
    }

    return Semantics(
      label: VoloLocalizations.of(context).progressLoading,
      child: spinner,
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter({required this.color, this.strokeWidth});

  final Color color;
  final double? strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final sw = strokeWidth ?? size.width / 12;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - sw) / 2;

    // Background circle.
    canvas.drawCircle(center, radius, paint);

    // Active arc (120 degrees).
    paint.color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      pi * 2 / 3,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter old) =>
      color != old.color || strokeWidth != old.strokeWidth;
}
