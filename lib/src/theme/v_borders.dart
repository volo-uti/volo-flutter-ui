import 'package:flutter/widgets.dart';

import 'v_borders.generated.dart';

/// Color and width of one border.
///
/// Defines a border with color and width.
@immutable
class VBorderStyle {
  /// Creates a border style.
  const VBorderStyle({required this.color, required this.width});

  /// Interpolates between two border styles.
  VBorderStyle.lerp(VBorderStyle a, VBorderStyle b, double t)
    : color = Color.lerp(a.color, b.color, t)!,
      width = a.width + (b.width - a.width) * t;

  /// Border color.
  final Color color;

  /// Border width.
  final double width;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VBorderStyle &&
        other.color == color &&
        other.width == width;
  }

  @override
  int get hashCode => Object.hash(color, width);
}

/// Default, strong and subtle border styles.
///
/// Defines consistent border styles used throughout the app.
@immutable
class VBorders {
  /// Creates border tokens.
  const VBorders({
    required this.defaultBorder,
    required this.strong,
    required this.subtle,
  });

  /// Interpolates between two border systems (for animations).
  VBorders.lerp(VBorders a, VBorders b, double t)
    : defaultBorder = VBorderStyle.lerp(a.defaultBorder, b.defaultBorder, t),
      strong = VBorderStyle.lerp(a.strong, b.strong, t),
      subtle = VBorderStyle.lerp(a.subtle, b.subtle, t);

  /// Default border (input, card edge).
  final VBorderStyle defaultBorder;

  /// Strong border (focus ring, emphasis).
  final VBorderStyle strong;

  /// Subtle border (divider, separator).
  final VBorderStyle subtle;

  /// Light mode borders.
  ///
  /// Values sourced from DTCG tokens via [VBordersDefaults].
  static final VBorders light = VBorders(
    defaultBorder: VBorderStyle(
      color: VBordersDefaults.light.defaultBorder.color,
      width: VBordersDefaults.light.defaultBorder.width,
    ),
    strong: VBorderStyle(
      color: VBordersDefaults.light.strong.color,
      width: VBordersDefaults.light.strong.width,
    ),
    subtle: VBorderStyle(
      color: VBordersDefaults.light.subtle.color,
      width: VBordersDefaults.light.subtle.width,
    ),
  );

  /// Dark mode borders.
  ///
  /// Values sourced from DTCG tokens via [VBordersDefaults].
  static final VBorders dark = VBorders(
    defaultBorder: VBorderStyle(
      color: VBordersDefaults.dark.defaultBorder.color,
      width: VBordersDefaults.dark.defaultBorder.width,
    ),
    strong: VBorderStyle(
      color: VBordersDefaults.dark.strong.color,
      width: VBordersDefaults.dark.strong.width,
    ),
    subtle: VBorderStyle(
      color: VBordersDefaults.dark.subtle.color,
      width: VBordersDefaults.dark.subtle.width,
    ),
  );

  /// Creates a copy with only the specified properties changed.
  VBorders copyWith({
    VBorderStyle? defaultBorder,
    VBorderStyle? strong,
    VBorderStyle? subtle,
  }) => VBorders(
    defaultBorder: defaultBorder ?? this.defaultBorder,
    strong: strong ?? this.strong,
    subtle: subtle ?? this.subtle,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VBorders &&
        other.defaultBorder == defaultBorder &&
        other.strong == strong &&
        other.subtle == subtle;
  }

  @override
  int get hashCode => Object.hash(defaultBorder, strong, subtle);
}
