import 'package:flutter/widgets.dart';

import 'v_radius.generated.dart';

/// Corner radius scale from none to full.
///
/// Defines consistent border radius values used throughout the app.
@immutable
class VRadius {
  /// Creates radius tokens.
  const VRadius({
    required this.none,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.card,
    required this.xl,
    required this.full,
  });

  /// Interpolates between two radius systems (for animations).
  VRadius.lerp(VRadius a, VRadius b, double t)
    : none = a.none + (b.none - a.none) * t,
      xs = a.xs + (b.xs - a.xs) * t,
      sm = a.sm + (b.sm - a.sm) * t,
      md = a.md + (b.md - a.md) * t,
      lg = a.lg + (b.lg - a.lg) * t,
      card = a.card + (b.card - a.card) * t,
      xl = a.xl + (b.xl - a.xl) * t,
      full = a.full + (b.full - a.full) * t;

  /// 0px - Square corners.
  final double none;

  /// 2px - Extra small elements (select item, tag).
  final double xs;

  /// 4px - Small elements (badge, chip).
  final double sm;

  /// 8px - Medium elements (button, input).
  final double md;

  /// 12px - Large elements (modal).
  final double lg;

  /// 16px - Card.
  final double card;

  /// 20px - Extra large (pill tabs, large containers).
  final double xl;

  /// 9999px - Fully rounded (avatar, switch).
  final double full;

  /// Default radius values.
  ///
  /// Values sourced from DTCG tokens via [VRadiusDefaults].
  static final VRadius defaults = VRadius(
    none: VRadiusDefaults.defaults.none,
    xs: VRadiusDefaults.defaults.xs,
    sm: VRadiusDefaults.defaults.sm,
    md: VRadiusDefaults.defaults.md,
    lg: VRadiusDefaults.defaults.lg,
    card: VRadiusDefaults.defaults.card,
    xl: VRadiusDefaults.defaults.xl,
    full: VRadiusDefaults.defaults.full,
  );

  /// Returns BorderRadius.circular(none).
  BorderRadius get noneRadius => BorderRadius.circular(none);

  /// Returns BorderRadius.circular(xs).
  BorderRadius get xsRadius => BorderRadius.circular(xs);

  /// Returns BorderRadius.circular(sm).
  BorderRadius get smRadius => BorderRadius.circular(sm);

  /// Returns BorderRadius.circular(md).
  BorderRadius get mdRadius => BorderRadius.circular(md);

  /// Returns BorderRadius.circular(lg).
  BorderRadius get lgRadius => BorderRadius.circular(lg);

  /// Returns BorderRadius.circular(card).
  BorderRadius get cardRadius => BorderRadius.circular(card);

  /// Returns BorderRadius.circular(xl).
  BorderRadius get xlRadius => BorderRadius.circular(xl);

  /// Returns BorderRadius.circular(full).
  BorderRadius get fullRadius => BorderRadius.circular(full);

  /// Creates a copy with only the specified properties changed.
  VRadius copyWith({
    double? none,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? card,
    double? xl,
    double? full,
  }) => VRadius(
    none: none ?? this.none,
    xs: xs ?? this.xs,
    sm: sm ?? this.sm,
    md: md ?? this.md,
    lg: lg ?? this.lg,
    card: card ?? this.card,
    xl: xl ?? this.xl,
    full: full ?? this.full,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VRadius &&
        other.none == none &&
        other.xs == xs &&
        other.sm == sm &&
        other.md == md &&
        other.lg == lg &&
        other.card == card &&
        other.xl == xl &&
        other.full == full;
  }

  @override
  int get hashCode => Object.hash(none, xs, sm, md, lg, card, xl, full);
}
