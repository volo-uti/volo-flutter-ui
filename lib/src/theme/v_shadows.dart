import 'package:flutter/widgets.dart';

import 'v_shadows.generated.dart';

/// Elevation shadow scale from xs to glow.
///
/// Defines consistent shadow styles used throughout the app.
/// Uses a 6-level scale: xs, sm, md, lg, xl, glow.
@immutable
class VShadows {
  /// Creates shadow tokens.
  const VShadows({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.glow,
  });

  /// Interpolates between two shadow systems (for animations).
  VShadows.lerp(VShadows a, VShadows b, double t)
    : xs = BoxShadow.lerpList(a.xs, b.xs, t)!,
      sm = BoxShadow.lerpList(a.sm, b.sm, t)!,
      md = BoxShadow.lerpList(a.md, b.md, t)!,
      lg = BoxShadow.lerpList(a.lg, b.lg, t)!,
      xl = BoxShadow.lerpList(a.xl, b.xl, t)!,
      glow = BoxShadow.lerpList(a.glow, b.glow, t)!;

  /// Extra-small shadow (blur: 2px, offset: 0,1).
  final List<BoxShadow> xs;

  /// Small shadow (blur: 4px, offset: 0,2).
  final List<BoxShadow> sm;

  /// Medium shadow (blur: 8px, offset: 0,4).
  final List<BoxShadow> md;

  /// Large shadow (blur: 16px, offset: 0,8).
  final List<BoxShadow> lg;

  /// Extra-large shadow (blur: 24px, offset: 0,12).
  final List<BoxShadow> xl;

  /// Emphasis glow effect (blur: 20px, offset: 0,0).
  final List<BoxShadow> glow;

  /// Light mode shadows.
  ///
  /// Values sourced from DTCG tokens via [VShadowsDefaults].
  static final VShadows light = VShadows(
    xs: VShadowsDefaults.light.xs,
    sm: VShadowsDefaults.light.sm,
    md: VShadowsDefaults.light.md,
    lg: VShadowsDefaults.light.lg,
    xl: VShadowsDefaults.light.xl,
    glow: VShadowsDefaults.light.glow,
  );

  /// Dark mode shadows.
  ///
  /// Values sourced from DTCG tokens via [VShadowsDefaults].
  static final VShadows dark = VShadows(
    xs: VShadowsDefaults.dark.xs,
    sm: VShadowsDefaults.dark.sm,
    md: VShadowsDefaults.dark.md,
    lg: VShadowsDefaults.dark.lg,
    xl: VShadowsDefaults.dark.xl,
    glow: VShadowsDefaults.dark.glow,
  );

  /// Creates a copy with only the specified properties changed.
  VShadows copyWith({
    List<BoxShadow>? xs,
    List<BoxShadow>? sm,
    List<BoxShadow>? md,
    List<BoxShadow>? lg,
    List<BoxShadow>? xl,
    List<BoxShadow>? glow,
  }) => VShadows(
    xs: xs ?? this.xs,
    sm: sm ?? this.sm,
    md: md ?? this.md,
    lg: lg ?? this.lg,
    xl: xl ?? this.xl,
    glow: glow ?? this.glow,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VShadows) return false;
    return _listEquals(other.xs, xs) &&
        _listEquals(other.sm, sm) &&
        _listEquals(other.md, md) &&
        _listEquals(other.lg, lg) &&
        _listEquals(other.xl, xl) &&
        _listEquals(other.glow, glow);
  }

  bool _listEquals(List<BoxShadow> a, List<BoxShadow> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(xs),
    Object.hashAll(sm),
    Object.hashAll(md),
    Object.hashAll(lg),
    Object.hashAll(xl),
    Object.hashAll(glow),
  );
}
