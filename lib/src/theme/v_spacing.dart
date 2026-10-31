import 'package:flutter/widgets.dart';

import 'v_spacing.generated.dart';

/// Spacing scale on a 4px base grid.
///
/// Defines consistent spacing values used throughout the app.
/// Uses 4px as the base unit.
@immutable
class VSpacing {
  /// Creates spacing tokens.
  const VSpacing({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.fourXL,
    required this.fiveXL,
    required this.sixXL,
  });

  /// Interpolates between two spacing systems (for animations).
  VSpacing.lerp(VSpacing a, VSpacing b, double t)
    : xxs = a.xxs + (b.xxs - a.xxs) * t,
      xs = a.xs + (b.xs - a.xs) * t,
      sm = a.sm + (b.sm - a.sm) * t,
      md = a.md + (b.md - a.md) * t,
      lg = a.lg + (b.lg - a.lg) * t,
      xl = a.xl + (b.xl - a.xl) * t,
      xxl = a.xxl + (b.xxl - a.xxl) * t,
      xxxl = a.xxxl + (b.xxxl - a.xxxl) * t,
      fourXL = a.fourXL + (b.fourXL - a.fourXL) * t,
      fiveXL = a.fiveXL + (b.fiveXL - a.fiveXL) * t,
      sixXL = a.sixXL + (b.sixXL - a.sixXL) * t;

  /// 2px - Fine adjustment within icons.
  final double xxs;

  /// 4px - Extra small spacing.
  final double xs;

  /// 8px - Default spacing between elements.
  final double sm;

  /// 12px - Card inner spacing.
  final double md;

  /// 16px - Default spacing between sections.
  final double lg;

  /// 20px - Spacing between large elements.
  final double xl;

  /// 24px - Page padding.
  final double xxl;

  /// 32px - Section separator.
  final double xxxl;

  /// 40px - 4xl spacing.
  final double fourXL;

  /// 48px - 5xl spacing.
  final double fiveXL;

  /// 64px - 6xl spacing.
  final double sixXL;

  /// Default spacing values.
  ///
  /// Values sourced from DTCG tokens via [VSpacingDefaults].
  static final VSpacing defaults = VSpacing(
    xxs: VSpacingDefaults.defaults.xxs,
    xs: VSpacingDefaults.defaults.xs,
    sm: VSpacingDefaults.defaults.sm,
    md: VSpacingDefaults.defaults.md,
    lg: VSpacingDefaults.defaults.lg,
    xl: VSpacingDefaults.defaults.xl,
    xxl: VSpacingDefaults.defaults.xxl,
    xxxl: VSpacingDefaults.defaults.xxxl,
    fourXL: VSpacingDefaults.defaults.fourXL,
    fiveXL: VSpacingDefaults.defaults.fiveXL,
    sixXL: VSpacingDefaults.defaults.sixXL,
  );

  /// Creates a copy with only the specified properties changed.
  VSpacing copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
    double? fourXL,
    double? fiveXL,
    double? sixXL,
  }) => VSpacing(
    xxs: xxs ?? this.xxs,
    xs: xs ?? this.xs,
    sm: sm ?? this.sm,
    md: md ?? this.md,
    lg: lg ?? this.lg,
    xl: xl ?? this.xl,
    xxl: xxl ?? this.xxl,
    xxxl: xxxl ?? this.xxxl,
    fourXL: fourXL ?? this.fourXL,
    fiveXL: fiveXL ?? this.fiveXL,
    sixXL: sixXL ?? this.sixXL,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VSpacing &&
        other.xxs == xxs &&
        other.xs == xs &&
        other.sm == sm &&
        other.md == md &&
        other.lg == lg &&
        other.xl == xl &&
        other.xxl == xxl &&
        other.xxxl == xxxl &&
        other.fourXL == fourXL &&
        other.fiveXL == fiveXL &&
        other.sixXL == sixXL;
  }

  @override
  int get hashCode => Object.hashAll([
    xxs,
    xs,
    sm,
    md,
    lg,
    xl,
    xxl,
    xxxl,
    fourXL,
    fiveXL,
    sixXL,
  ]);
}
