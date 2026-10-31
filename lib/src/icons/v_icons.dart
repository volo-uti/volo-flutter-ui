import 'dart:math' show pi;

import 'package:flutter/widgets.dart';

/// Vector icons drawn in code, no asset files.
///
/// Provides CustomPaint-based icons that do not depend on MaterialIcons font.
/// All icons scale to the specified [size] and render in the specified [color].
///
/// ```dart
/// VIcons.close(size: 16, color: theme.colors.foreground)
/// ```
class VIcons {
  VIcons._();

  // ===== Navigation =====

  /// Left chevron (<).
  static Widget chevronLeft({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawChevronLeft);

  /// Right chevron (>).
  static Widget chevronRight({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawChevronRight);

  /// Up chevron (^).
  static Widget chevronUp({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawChevronUp);

  /// Down chevron (v).
  static Widget chevronDown({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawChevronDown);

  /// Back arrow with stem.
  static Widget arrowBack({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawArrowBack);

  /// Upward arrow with stem.
  static Widget arrowUp({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawArrowUp);

  /// Downward arrow with stem.
  static Widget arrowDown({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawArrowDown);

  /// First page (|<).
  static Widget firstPage({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawFirstPage);

  /// Last page (>|).
  static Widget lastPage({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawLastPage);

  // ===== Action =====

  /// Close / dismiss (X).
  static Widget close({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawClose);

  /// Checkmark.
  static Widget check({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawCheck);

  /// Search / magnifying glass.
  static Widget search({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawSearch);

  /// Refresh / reload.
  static Widget refresh({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawRefresh);

  /// Edit / pencil.
  static Widget edit({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawEdit);

  // ===== Status =====

  /// Info circle (outlined).
  static Widget info({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawInfo);

  /// Success check in filled circle.
  static Widget checkCircle({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawCheckCircle);

  /// Error X in filled circle.
  static Widget error({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawError);

  /// Warning triangle with exclamation.
  static Widget warning({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawWarning);

  /// Priority high (exclamation mark).
  static Widget priorityHigh({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawPriorityHigh);

  // ===== Object =====

  /// Person silhouette.
  static Widget person({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawPerson);

  /// Calendar.
  static Widget calendar({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawCalendar);

  /// Eye open (visibility).
  static Widget visibility({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawVisibility);

  /// Eye closed (visibility off).
  static Widget visibilityOff({required Color color, double size = 24}) =>
      _icon(size: size, color: color, draw: _drawVisibilityOff);

  // ===== Internal =====

  static Widget _icon({
    required double size,
    required Color color,
    required void Function(Canvas, Size, Paint) draw,
  }) => SizedBox.square(
    dimension: size,
    child: CustomPaint(
      painter: _VIconPainter(color: color, draw: draw),
    ),
  );
}

// ---------------------------------------------------------------------------
// Painter
// ---------------------------------------------------------------------------

class _VIconPainter extends CustomPainter {
  const _VIconPainter({required this.color, required this.draw});

  final Color color;
  final void Function(Canvas, Size, Paint) draw;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    draw(canvas, size, paint);
  }

  @override
  bool shouldRepaint(covariant _VIconPainter old) =>
      color != old.color || draw != old.draw;
}

// ---------------------------------------------------------------------------
// Draw functions — Navigation
// ---------------------------------------------------------------------------

void _drawChevronLeft(Canvas c, Size s, Paint p) {
  final path = Path()
    ..moveTo(s.width * 0.62, s.height * 0.25)
    ..lineTo(s.width * 0.38, s.height * 0.5)
    ..lineTo(s.width * 0.62, s.height * 0.75);
  c.drawPath(path, p);
}

void _drawChevronRight(Canvas c, Size s, Paint p) {
  final path = Path()
    ..moveTo(s.width * 0.38, s.height * 0.25)
    ..lineTo(s.width * 0.62, s.height * 0.5)
    ..lineTo(s.width * 0.38, s.height * 0.75);
  c.drawPath(path, p);
}

void _drawChevronUp(Canvas c, Size s, Paint p) {
  final path = Path()
    ..moveTo(s.width * 0.25, s.height * 0.62)
    ..lineTo(s.width * 0.5, s.height * 0.38)
    ..lineTo(s.width * 0.75, s.height * 0.62);
  c.drawPath(path, p);
}

void _drawChevronDown(Canvas c, Size s, Paint p) {
  final path = Path()
    ..moveTo(s.width * 0.25, s.height * 0.38)
    ..lineTo(s.width * 0.5, s.height * 0.62)
    ..lineTo(s.width * 0.75, s.height * 0.38);
  c.drawPath(path, p);
}

void _drawArrowBack(Canvas c, Size s, Paint p) {
  final path = Path()
    ..moveTo(s.width * 0.45, s.height * 0.25)
    ..lineTo(s.width * 0.2, s.height * 0.5)
    ..lineTo(s.width * 0.45, s.height * 0.75);
  c
    ..drawPath(path, p)
    ..drawLine(
      Offset(s.width * 0.2, s.height * 0.5),
      Offset(s.width * 0.8, s.height * 0.5),
      p,
    );
}

void _drawArrowUp(Canvas c, Size s, Paint p) {
  final path = Path()
    ..moveTo(s.width * 0.3, s.height * 0.4)
    ..lineTo(s.width * 0.5, s.height * 0.2)
    ..lineTo(s.width * 0.7, s.height * 0.4);
  c
    ..drawPath(path, p)
    ..drawLine(
      Offset(s.width * 0.5, s.height * 0.2),
      Offset(s.width * 0.5, s.height * 0.8),
      p,
    );
}

void _drawArrowDown(Canvas c, Size s, Paint p) {
  final path = Path()
    ..moveTo(s.width * 0.3, s.height * 0.6)
    ..lineTo(s.width * 0.5, s.height * 0.8)
    ..lineTo(s.width * 0.7, s.height * 0.6);
  c
    ..drawPath(path, p)
    ..drawLine(
      Offset(s.width * 0.5, s.height * 0.2),
      Offset(s.width * 0.5, s.height * 0.8),
      p,
    );
}

void _drawFirstPage(Canvas c, Size s, Paint p) {
  c.drawLine(
    Offset(s.width * 0.28, s.height * 0.25),
    Offset(s.width * 0.28, s.height * 0.75),
    p,
  );
  final path = Path()
    ..moveTo(s.width * 0.68, s.height * 0.25)
    ..lineTo(s.width * 0.42, s.height * 0.5)
    ..lineTo(s.width * 0.68, s.height * 0.75);
  c.drawPath(path, p);
}

void _drawLastPage(Canvas c, Size s, Paint p) {
  c.drawLine(
    Offset(s.width * 0.72, s.height * 0.25),
    Offset(s.width * 0.72, s.height * 0.75),
    p,
  );
  final path = Path()
    ..moveTo(s.width * 0.32, s.height * 0.25)
    ..lineTo(s.width * 0.58, s.height * 0.5)
    ..lineTo(s.width * 0.32, s.height * 0.75);
  c.drawPath(path, p);
}

// ---------------------------------------------------------------------------
// Draw functions — Action
// ---------------------------------------------------------------------------

void _drawClose(Canvas c, Size s, Paint p) {
  final m = s.width * 0.28;
  c
    ..drawLine(Offset(m, m), Offset(s.width - m, s.height - m), p)
    ..drawLine(Offset(s.width - m, m), Offset(m, s.height - m), p);
}

void _drawCheck(Canvas c, Size s, Paint p) {
  final path = Path()
    ..moveTo(s.width * 0.2, s.height * 0.5)
    ..lineTo(s.width * 0.42, s.height * 0.72)
    ..lineTo(s.width * 0.8, s.height * 0.28);
  c.drawPath(path, p);
}

void _drawSearch(Canvas c, Size s, Paint p) {
  final center = Offset(s.width * 0.42, s.height * 0.42);
  final radius = s.width * 0.22;
  c
    ..drawCircle(center, radius, p)
    ..drawLine(
      Offset(s.width * 0.57, s.height * 0.57),
      Offset(s.width * 0.78, s.height * 0.78),
      p,
    );
}

void _drawRefresh(Canvas c, Size s, Paint p) {
  final rect = Rect.fromCenter(
    center: Offset(s.width * 0.5, s.height * 0.5),
    width: s.width * 0.56,
    height: s.height * 0.56,
  );
  c.drawArc(rect, -pi / 2, pi * 1.67, false, p);
  // Arrow head
  final path = Path()
    ..moveTo(s.width * 0.4, s.height * 0.2)
    ..lineTo(s.width * 0.5, s.height * 0.22)
    ..lineTo(s.width * 0.48, s.height * 0.32);
  c.drawPath(path, p);
}

void _drawEdit(Canvas c, Size s, Paint p) {
  final path = Path()
    ..moveTo(s.width * 0.72, s.height * 0.18)
    ..lineTo(s.width * 0.82, s.height * 0.28)
    ..lineTo(s.width * 0.35, s.height * 0.75)
    ..lineTo(s.width * 0.22, s.height * 0.78)
    ..lineTo(s.width * 0.25, s.height * 0.65)
    ..close();
  c.drawPath(path, p);
}

// ---------------------------------------------------------------------------
// Draw functions — Status
// ---------------------------------------------------------------------------

void _drawInfo(Canvas c, Size s, Paint p) {
  c
    ..drawCircle(Offset(s.width * 0.5, s.height * 0.5), s.width * 0.36, p)
    ..drawCircle(
      Offset(s.width * 0.5, s.height * 0.33),
      s.width * 0.04,
      Paint()
        ..color = p.color
        ..style = PaintingStyle.fill,
    )
    ..drawLine(
      Offset(s.width * 0.5, s.height * 0.44),
      Offset(s.width * 0.5, s.height * 0.7),
      p,
    );
}

void _drawCheckCircle(Canvas c, Size s, Paint p) {
  c.drawCircle(
    Offset(s.width * 0.5, s.height * 0.5),
    s.width * 0.38,
    Paint()
      ..color = p.color
      ..style = PaintingStyle.fill,
  );
  final cp = Paint()
    ..color = const Color(0xFFFFFFFF)
    ..style = PaintingStyle.stroke
    ..strokeWidth = p.strokeWidth
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  final path = Path()
    ..moveTo(s.width * 0.3, s.height * 0.5)
    ..lineTo(s.width * 0.44, s.height * 0.64)
    ..lineTo(s.width * 0.7, s.height * 0.36);
  c.drawPath(path, cp);
}

void _drawError(Canvas c, Size s, Paint p) {
  c.drawCircle(
    Offset(s.width * 0.5, s.height * 0.5),
    s.width * 0.38,
    Paint()
      ..color = p.color
      ..style = PaintingStyle.fill,
  );
  final xp = Paint()
    ..color = const Color(0xFFFFFFFF)
    ..style = PaintingStyle.stroke
    ..strokeWidth = p.strokeWidth
    ..strokeCap = StrokeCap.round;
  final m = s.width * 0.35;
  final e = s.width * 0.65;
  c
    ..drawLine(Offset(m, m), Offset(e, e), xp)
    ..drawLine(Offset(e, m), Offset(m, e), xp);
}

void _drawWarning(Canvas c, Size s, Paint p) {
  final triangle = Path()
    ..moveTo(s.width * 0.5, s.height * 0.15)
    ..lineTo(s.width * 0.12, s.height * 0.82)
    ..lineTo(s.width * 0.88, s.height * 0.82)
    ..close();
  c.drawPath(
    triangle,
    Paint()
      ..color = p.color
      ..style = PaintingStyle.fill,
  );
  final wp = Paint()
    ..color = const Color(0xFFFFFFFF)
    ..style = PaintingStyle.stroke
    ..strokeWidth = p.strokeWidth * 1.2
    ..strokeCap = StrokeCap.round;
  c
    ..drawLine(
      Offset(s.width * 0.5, s.height * 0.38),
      Offset(s.width * 0.5, s.height * 0.58),
      wp,
    )
    ..drawCircle(
      Offset(s.width * 0.5, s.height * 0.7),
      s.width * 0.035,
      Paint()
        ..color = const Color(0xFFFFFFFF)
        ..style = PaintingStyle.fill,
    );
}

void _drawPriorityHigh(Canvas c, Size s, Paint p) {
  c
    ..drawLine(
      Offset(s.width * 0.5, s.height * 0.18),
      Offset(s.width * 0.5, s.height * 0.62),
      p,
    )
    ..drawCircle(
      Offset(s.width * 0.5, s.height * 0.78),
      s.width * 0.05,
      Paint()
        ..color = p.color
        ..style = PaintingStyle.fill,
    );
}

// ---------------------------------------------------------------------------
// Draw functions — Object
// ---------------------------------------------------------------------------

void _drawPerson(Canvas c, Size s, Paint p) {
  c.drawCircle(
    Offset(s.width * 0.5, s.height * 0.3),
    s.width * 0.16,
    p,
  ); // head
  final body = Path()
    ..moveTo(s.width * 0.2, s.height * 0.82)
    ..quadraticBezierTo(
      s.width * 0.2,
      s.height * 0.52,
      s.width * 0.5,
      s.height * 0.52,
    )
    ..quadraticBezierTo(
      s.width * 0.8,
      s.height * 0.52,
      s.width * 0.8,
      s.height * 0.82,
    );
  c.drawPath(body, p);
}

void _drawCalendar(Canvas c, Size s, Paint p) {
  final rect = RRect.fromRectAndRadius(
    Rect.fromLTWH(
      s.width * 0.15,
      s.height * 0.2,
      s.width * 0.7,
      s.height * 0.65,
    ),
    Radius.circular(s.width * 0.06),
  );
  c
    ..drawRRect(rect, p)
    ..drawLine(
      Offset(s.width * 0.15, s.height * 0.4),
      Offset(s.width * 0.85, s.height * 0.4),
      p,
    )
    ..drawLine(
      Offset(s.width * 0.35, s.height * 0.15),
      Offset(s.width * 0.35, s.height * 0.28),
      p,
    )
    ..drawLine(
      Offset(s.width * 0.65, s.height * 0.15),
      Offset(s.width * 0.65, s.height * 0.28),
      p,
    );
}

void _drawVisibility(Canvas c, Size s, Paint p) {
  final eye = Path()
    ..moveTo(s.width * 0.08, s.height * 0.5)
    ..quadraticBezierTo(
      s.width * 0.5,
      s.height * 0.15,
      s.width * 0.92,
      s.height * 0.5,
    )
    ..quadraticBezierTo(
      s.width * 0.5,
      s.height * 0.85,
      s.width * 0.08,
      s.height * 0.5,
    );
  c
    ..drawPath(eye, p)
    ..drawCircle(Offset(s.width * 0.5, s.height * 0.5), s.width * 0.12, p);
}

void _drawVisibilityOff(Canvas c, Size s, Paint p) {
  final eye = Path()
    ..moveTo(s.width * 0.08, s.height * 0.5)
    ..quadraticBezierTo(
      s.width * 0.5,
      s.height * 0.15,
      s.width * 0.92,
      s.height * 0.5,
    )
    ..quadraticBezierTo(
      s.width * 0.5,
      s.height * 0.85,
      s.width * 0.08,
      s.height * 0.5,
    );
  c
    ..drawPath(eye, p)
    ..drawCircle(Offset(s.width * 0.5, s.height * 0.5), s.width * 0.12, p)
    ..drawLine(
      Offset(s.width * 0.18, s.height * 0.82),
      Offset(s.width * 0.82, s.height * 0.18),
      p,
    );
}
