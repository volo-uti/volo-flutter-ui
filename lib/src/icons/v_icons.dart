import 'dart:math' show cos, pi, sin;

import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_theme.dart';

/// Vector icons drawn in code, no asset files.
///
/// Provides CustomPaint-based icons that do not depend on MaterialIcons font.
/// All icons scale to the given `size` and are drawn on a 24-unit grid with a
/// stroke of `size / 12`, round caps and round joins.
///
/// The `color` comes first from the argument, then from the nearest
/// [IconTheme] (so an icon inside a `VButton` or a `VBottomNav` item follows
/// that widget's foreground and selected colors), then from the theme's
/// foreground color.
///
/// ```dart
/// VIcons.close(size: 16, color: theme.colors.foreground)
/// VIcons.settings() // IconTheme color, else the theme foreground
/// ```
class VIcons {
  VIcons._();

  // ===== Navigation =====

  /// Left chevron (<).
  static Widget chevronLeft({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawChevronLeft);

  /// Right chevron (>).
  static Widget chevronRight({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawChevronRight);

  /// Up chevron (^).
  static Widget chevronUp({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawChevronUp);

  /// Down chevron (v).
  static Widget chevronDown({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawChevronDown);

  /// Back arrow with stem.
  static Widget arrowBack({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawArrowBack);

  /// Upward arrow with stem.
  static Widget arrowUp({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawArrowUp);

  /// Downward arrow with stem.
  static Widget arrowDown({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawArrowDown);

  /// First page (|<).
  static Widget firstPage({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawFirstPage);

  /// Last page (>|).
  static Widget lastPage({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawLastPage);

  /// Solid triangle pointing down, for a dropdown trigger.
  static Widget arrowDropDown({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawArrowDropDown);

  /// Square with an arrow leaving its corner, for a link that opens elsewhere.
  static Widget openInNew({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawOpenInNew);

  // ===== Action =====

  /// Close / dismiss (X).
  static Widget close({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawClose);

  /// Checkmark.
  static Widget check({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawCheck);

  /// Search / magnifying glass.
  static Widget search({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawSearch);

  /// Refresh / reload.
  static Widget refresh({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawRefresh);

  /// Edit / pencil.
  static Widget edit({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawEdit);

  /// Gear, for settings.
  static Widget settings({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawSettings);

  /// Crosshair around a dot, for "my location".
  static Widget location({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawLocation);

  /// Play triangle in an outlined circle.
  static Widget playCircle({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawPlayCircle);

  // ===== Status =====

  /// Info circle (outlined).
  static Widget info({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawInfo);

  /// Success check in filled circle.
  static Widget checkCircle({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawCheckCircle);

  /// Error X in filled circle.
  static Widget error({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawError);

  /// Warning triangle with exclamation.
  static Widget warning({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawWarning);

  /// Priority high (exclamation mark).
  static Widget priorityHigh({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawPriorityHigh);

  // ===== Object =====

  /// Person silhouette.
  static Widget person({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawPerson);

  /// Calendar.
  static Widget calendar({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawCalendar);

  /// Eye open (visibility).
  static Widget visibility({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawVisibility);

  /// Eye closed (visibility off).
  static Widget visibilityOff({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawVisibilityOff);

  /// Camera body with a lens.
  static Widget camera({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawCamera);

  /// Bulleted list.
  static Widget list({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawList);

  /// Cloud outline.
  static Widget cloud({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawCloud);

  /// Clock face with hands.
  static Widget clock({Color? color, double size = 24}) =>
      _VIcon(size: size, color: color, draw: _drawClock);
}

// ---------------------------------------------------------------------------
// Widget and painter
// ---------------------------------------------------------------------------

typedef _Draw = void Function(Canvas c, Size s, Paint p);

// WHY: A widget instead of a bare SizedBox — the color fallback reads the
// IconTheme and the VTheme, which needs a BuildContext.
class _VIcon extends StatelessWidget {
  const _VIcon({required this.size, required this.color, required this.draw});

  final double size;
  final Color? color;
  final _Draw draw;

  @override
  Widget build(BuildContext context) {
    // IconTheme.of falls back to black when no IconTheme is above, so the
    // inherited widget is read directly to tell "none" from "black".
    final resolved =
        color ??
        context.dependOnInheritedWidgetOfExactType<IconTheme>()?.data.color ??
        VTheme.of(context).colors.foreground;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _VIconPainter(color: resolved, draw: draw),
      ),
    );
  }
}

class _VIconPainter extends CustomPainter {
  const _VIconPainter({required this.color, required this.draw});

  final Color color;
  final _Draw draw;

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

// ---------------------------------------------------------------------------
// Draw functions — added icons
// ---------------------------------------------------------------------------

Paint _fill(Paint p) => Paint()
  ..color = p.color
  ..style = PaintingStyle.fill;

void _drawArrowDropDown(Canvas c, Size s, Paint p) {
  final triangle = Path()
    ..moveTo(s.width * 0.32, s.height * 0.42)
    ..lineTo(s.width * 0.68, s.height * 0.42)
    ..lineTo(s.width * 0.5, s.height * 0.6)
    ..close();
  // The stroke rounds the corners of the filled triangle.
  c
    ..drawPath(triangle, _fill(p))
    ..drawPath(triangle, p);
}

void _drawOpenInNew(Canvas c, Size s, Paint p) {
  final box = Path()
    ..moveTo(s.width * 0.46, s.height * 0.2)
    ..lineTo(s.width * 0.2, s.height * 0.2)
    ..lineTo(s.width * 0.2, s.height * 0.8)
    ..lineTo(s.width * 0.8, s.height * 0.8)
    ..lineTo(s.width * 0.8, s.height * 0.54);
  final head = Path()
    ..moveTo(s.width * 0.6, s.height * 0.2)
    ..lineTo(s.width * 0.8, s.height * 0.2)
    ..lineTo(s.width * 0.8, s.height * 0.4);
  c
    ..drawPath(box, p)
    ..drawPath(head, p)
    ..drawLine(
      Offset(s.width * 0.48, s.height * 0.52),
      Offset(s.width * 0.8, s.height * 0.2),
      p,
    );
}

void _drawSettings(Canvas c, Size s, Paint p) {
  // Eight teeth: a flat top at the outer radius, straight flanks down to the
  // root circle.
  const teeth = 8;
  final center = Offset(s.width * 0.5, s.height * 0.5);
  final outer = s.width * 0.4;
  final inner = s.width * 0.29;
  const step = 2 * pi / teeth;
  const topHalf = step * 0.17;
  const rootHalf = step * 0.29;
  Offset at(double r, double a) => center + Offset(cos(a) * r, sin(a) * r);
  final gear = Path();
  for (var i = 0; i < teeth; i++) {
    final a = i * step - pi / 2;
    final from = at(inner, a - rootHalf);
    if (i == 0) {
      gear.moveTo(from.dx, from.dy);
    } else {
      gear.lineTo(from.dx, from.dy);
    }
    final t1 = at(outer, a - topHalf);
    final t2 = at(outer, a + topHalf);
    final r2 = at(inner, a + rootHalf);
    gear
      ..lineTo(t1.dx, t1.dy)
      ..lineTo(t2.dx, t2.dy)
      ..lineTo(r2.dx, r2.dy);
  }
  gear.close();
  c
    ..drawPath(gear, p)
    ..drawCircle(center, s.width * 0.11, p);
}

void _drawLocation(Canvas c, Size s, Paint p) {
  final center = Offset(s.width * 0.5, s.height * 0.5);
  c
    ..drawCircle(center, s.width * 0.28, p)
    ..drawCircle(center, s.width * 0.09, _fill(p))
    ..drawLine(
      Offset(s.width * 0.5, s.height * 0.1),
      Offset(s.width * 0.5, s.height * 0.22),
      p,
    )
    ..drawLine(
      Offset(s.width * 0.5, s.height * 0.78),
      Offset(s.width * 0.5, s.height * 0.9),
      p,
    )
    ..drawLine(
      Offset(s.width * 0.1, s.height * 0.5),
      Offset(s.width * 0.22, s.height * 0.5),
      p,
    )
    ..drawLine(
      Offset(s.width * 0.78, s.height * 0.5),
      Offset(s.width * 0.9, s.height * 0.5),
      p,
    );
}

void _drawPlayCircle(Canvas c, Size s, Paint p) {
  final triangle = Path()
    ..moveTo(s.width * 0.43, s.height * 0.36)
    ..lineTo(s.width * 0.64, s.height * 0.5)
    ..lineTo(s.width * 0.43, s.height * 0.64)
    ..close();
  c
    ..drawCircle(Offset(s.width * 0.5, s.height * 0.5), s.width * 0.36, p)
    ..drawPath(triangle, _fill(p))
    ..drawPath(triangle, p);
}

void _drawCamera(Canvas c, Size s, Paint p) {
  final body = RRect.fromRectAndRadius(
    Rect.fromLTRB(
      s.width * 0.14,
      s.height * 0.3,
      s.width * 0.86,
      s.height * 0.8,
    ),
    Radius.circular(s.width * 0.07),
  );
  final hump = Path()
    ..moveTo(s.width * 0.34, s.height * 0.3)
    ..lineTo(s.width * 0.4, s.height * 0.2)
    ..lineTo(s.width * 0.6, s.height * 0.2)
    ..lineTo(s.width * 0.66, s.height * 0.3);
  c
    ..drawRRect(body, p)
    ..drawPath(hump, p)
    ..drawCircle(Offset(s.width * 0.5, s.height * 0.55), s.width * 0.13, p);
}

void _drawList(Canvas c, Size s, Paint p) {
  final dot = _fill(p);
  for (final y in const [0.28, 0.5, 0.72]) {
    c
      ..drawCircle(Offset(s.width * 0.2, s.height * y), s.width * 0.05, dot)
      ..drawLine(
        Offset(s.width * 0.36, s.height * y),
        Offset(s.width * 0.82, s.height * y),
        p,
      );
  }
}

void _drawCloud(Canvas c, Size s, Paint p) {
  // The outline of three bumps on a flat base, joined with a path union.
  Rect circle(double x, double y, double r) => Rect.fromCircle(
    center: Offset(s.width * x, s.height * y),
    radius: s.width * r,
  );
  final left = Path()..addOval(circle(0.28, 0.61, 0.15));
  final top = Path()..addOval(circle(0.46, 0.45, 0.21));
  final right = Path()..addOval(circle(0.7, 0.59, 0.17));
  final base = Path()
    ..addRect(
      Rect.fromLTRB(
        s.width * 0.28,
        s.height * 0.59,
        s.width * 0.7,
        s.height * 0.76,
      ),
    );
  final cloud = Path.combine(
    PathOperation.union,
    Path.combine(
      PathOperation.union,
      Path.combine(PathOperation.union, left, top),
      right,
    ),
    base,
  );
  c.drawPath(cloud, p);
}

void _drawClock(Canvas c, Size s, Paint p) {
  final hands = Path()
    ..moveTo(s.width * 0.5, s.height * 0.28)
    ..lineTo(s.width * 0.5, s.height * 0.5)
    ..lineTo(s.width * 0.65, s.height * 0.6);
  c
    ..drawCircle(Offset(s.width * 0.5, s.height * 0.5), s.width * 0.36, p)
    ..drawPath(hands, p);
}
