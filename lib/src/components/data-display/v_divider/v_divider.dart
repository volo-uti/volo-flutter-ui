import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_divider_style.dart';

/// Thin horizontal or vertical line that separates groups of content.
///
/// [VDivider.bold] doubles the thickness, [VDivider.dashed] draws dashes and
/// [VDivider.label] centers a label between two lines.
///
/// ```dart
/// Column(
///   children: [
///     Text('Account'),
///     VDivider(indent: 16),
///     VDivider.label(Text('or')),
///   ],
/// )
/// ```
class VDivider extends StatelessWidget {
  /// Line of the given [thickness], 1px by default.
  const VDivider({
    super.key,
    this.direction = Axis.horizontal,
    this.thickness = 1,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
    this.style,
  }) : _variant = _VDividerVariant.normal,
       label = null;

  /// Line 2px thick.
  const VDivider.bold({
    super.key,
    this.direction = Axis.horizontal,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
    this.style,
  }) : _variant = _VDividerVariant.bold,
       thickness = 2,
       label = null;

  /// Dashed line.
  const VDivider.dashed({
    super.key,
    this.direction = Axis.horizontal,
    this.thickness = 1,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
    this.style,
  }) : _variant = _VDividerVariant.dashed,
       label = null;

  /// Horizontal line interrupted by a centered [label].
  const VDivider.label(
    this.label, {
    super.key,
    this.thickness = 1,
    this.color,
    this.style,
  }) : _variant = _VDividerVariant.label,
       direction = Axis.horizontal,
       indent = 0,
       endIndent = 0;

  /// Length of one dash of [VDivider.dashed].
  static const kDashWidth = 4.0;

  /// Gap between two dashes of [VDivider.dashed].
  static const kDashSpace = 4.0;

  final _VDividerVariant _variant;

  /// Axis the line runs along.
  final Axis direction;

  /// Line thickness in logical pixels.
  final double thickness;

  /// Line color; falls back to the border color of the theme.
  final Color? color;

  /// Empty space before the line.
  final double indent;

  /// Empty space after the line.
  final double endIndent;

  /// Widget centered between the two lines of [VDivider.label].
  final Widget? label;

  /// Per-instance style override merged over the theme style.
  final VDividerStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VDividerStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;
    final colors = theme.colors;

    final lineColor = resolvedStyle?.color ?? color ?? colors.border;
    final resolvedThickness = resolvedStyle?.thickness ?? thickness;
    final resolvedIndent = resolvedStyle?.indent ?? indent;

    // WHY: ExcludeSemantics on the lines of every divider variant — they are
    // purely decorative and should not be announced by screen readers. This prevents
    // "separator" noise in a11y traversal.
    if (_variant == _VDividerVariant.label) {
      // The lines are decoration, but the label ("OR", a date) is content.
      final line = ExcludeSemantics(
        child: Container(height: resolvedThickness, color: lineColor),
      );
      return Row(
        children: [
          Expanded(child: line),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.lg),
            child: DefaultTextStyle.merge(
              style: theme.typography.bodySmall.copyWith(
                color: colors.mutedForeground,
              ),
              child: label ?? const SizedBox.shrink(),
            ),
          ),
          Expanded(child: line),
        ],
      );
    }

    if (_variant == _VDividerVariant.dashed) {
      return ExcludeSemantics(
        child: _DashedDivider(
          direction: direction,
          thickness: resolvedThickness,
          color: lineColor,
          indent: resolvedIndent,
          endIndent: endIndent,
        ),
      );
    }

    if (direction == Axis.horizontal) {
      return ExcludeSemantics(
        child: Container(
          margin: EdgeInsets.only(left: resolvedIndent, right: endIndent),
          height: resolvedThickness,
          color: lineColor,
        ),
      );
    } else {
      return ExcludeSemantics(
        child: Container(
          margin: EdgeInsets.only(top: resolvedIndent, bottom: endIndent),
          width: resolvedThickness,
          color: lineColor,
        ),
      );
    }
  }
}

enum _VDividerVariant { normal, bold, dashed, label }

class _DashedDivider extends StatelessWidget {
  const _DashedDivider({
    required this.direction,
    required this.thickness,
    required this.color,
    required this.indent,
    required this.endIndent,
  });

  final Axis direction;
  final double thickness;
  final Color color;
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _DashedLinePainter(
      direction: direction,
      thickness: thickness,
      color: color,
      indent: indent,
      endIndent: endIndent,
    ),
    size: direction == Axis.horizontal
        ? Size(double.infinity, thickness)
        : Size(thickness, double.infinity),
  );
}

// WHY: CustomPainter for dashed lines — Flutter has no built-in dashed border
// or divider. Canvas drawLine in a loop is the standard approach; the dash
// pattern (4px on / 4px off) is a common dashed-line convention.
class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({
    required this.direction,
    required this.thickness,
    required this.color,
    required this.indent,
    required this.endIndent,
  });

  final Axis direction;
  final double thickness;
  final Color color;
  final double indent;
  final double endIndent;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    const dashWidth = VDivider.kDashWidth;
    const dashSpace = VDivider.kDashSpace;

    if (direction == Axis.horizontal) {
      var startX = indent;
      final endX = size.width - endIndent;
      final y = size.height / 2;

      while (startX < endX) {
        canvas.drawLine(
          Offset(startX, y),
          Offset((startX + dashWidth).clamp(0, endX), y),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    } else {
      var startY = indent;
      final endY = size.height - endIndent;
      final x = size.width / 2;

      while (startY < endY) {
        canvas.drawLine(
          Offset(x, startY),
          Offset(x, (startY + dashWidth).clamp(0, endY)),
          paint,
        );
        startY += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.direction != direction ||
      oldDelegate.thickness != thickness ||
      oldDelegate.color != color ||
      oldDelegate.indent != indent ||
      oldDelegate.endIndent != endIndent;
}
