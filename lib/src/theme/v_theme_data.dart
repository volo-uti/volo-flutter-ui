import 'package:flutter/widgets.dart';

import 'v_animations.dart';
import 'v_borders.dart';
import 'v_colors.dart';
import 'v_component_overrides.dart';
import 'v_gradients.dart';
import 'v_radius.dart';
import 'v_shadows.dart';
import 'v_sizes.dart';
import 'v_spacing.dart';
import 'v_typography.dart';

// WHY: 9 token types (colors, typography, spacing, radius, shadows,
// animations, sizes, borders, gradients) mirror the DTCG spec categories.
// This 1:1 mapping enables automated gen_tokens.dart → Dart code generation
// from a single JSON source.
/// Design tokens and overrides for one brightness.
///
/// Start from [VThemeData.light] or [VThemeData.dark], change tokens with
/// [copyWith], and blend two themes with [VThemeData.lerp].
///
/// ```dart
/// final theme = VThemeData.light().copyWith(
///   colors: VColors.light.copyWith(primary: const Color(0xFF0057D9)),
/// );
/// final halfway = VThemeData.lerp(VThemeData.light(), theme, 0.5);
/// ```
@immutable
class VThemeData {
  /// Creates theme data from every token set.
  const VThemeData({
    required this.brightness,
    required this.colors,
    required this.typography,
    required this.spacing,
    required this.radius,
    required this.shadows,
    required this.animations,
    required this.sizes,
    required this.borders,
    required this.gradients,
    this.componentOverrides = VComponentOverrides.empty,
  });

  /// Volo brand theme - light mode (default).
  factory VThemeData.light() => VThemeData(
    brightness: Brightness.light,
    colors: VColors.light,
    typography: VTypography.defaults,
    spacing: VSpacing.defaults,
    radius: VRadius.defaults,
    shadows: VShadows.light,
    animations: VAnimations.defaults,
    sizes: VSizes.defaults,
    borders: VBorders.light,
    gradients: VGradients.defaults,
  );

  /// Volo brand theme - dark mode.
  factory VThemeData.dark() => VThemeData(
    brightness: Brightness.dark,
    colors: VColors.dark,
    typography: VTypography.defaults,
    spacing: VSpacing.defaults,
    radius: VRadius.defaults,
    shadows: VShadows.dark,
    animations: VAnimations.defaults,
    sizes: VSizes.defaults,
    borders: VBorders.dark,
    gradients: VGradients.defaults,
  );

  // WHY: Named constructor lerp enables AnimatedVTheme to smoothly
  // interpolate all 9 token types during theme transitions. Brightness
  // snaps at t=0.5 because there is no meaningful midpoint between
  // light and dark.
  /// Interpolates between themes [a] and [b] at [t] from 0 to 1.
  VThemeData.lerp(VThemeData a, VThemeData b, double t)
    : brightness = t < 0.5 ? a.brightness : b.brightness,
      colors = VColors.lerp(a.colors, b.colors, t),
      typography = VTypography.lerp(a.typography, b.typography, t),
      spacing = VSpacing.lerp(a.spacing, b.spacing, t),
      radius = VRadius.lerp(a.radius, b.radius, t),
      shadows = VShadows.lerp(a.shadows, b.shadows, t),
      animations = VAnimations.lerp(a.animations, b.animations, t),
      sizes = VSizes.lerp(a.sizes, b.sizes, t),
      borders = VBorders.lerp(a.borders, b.borders, t),
      gradients = VGradients.lerp(a.gradients, b.gradients, t),
      componentOverrides = t < 0.5
          ? a.componentOverrides
          : b.componentOverrides;

  /// Brightness mode (light / dark).
  final Brightness brightness;

  /// Color system.
  final VColors colors;

  /// Typography system.
  final VTypography typography;

  /// Spacing system.
  final VSpacing spacing;

  /// Border radius system.
  final VRadius radius;

  /// Shadow system.
  final VShadows shadows;

  /// Animation system.
  final VAnimations animations;

  /// Component size system.
  final VSizes sizes;

  /// Border system.
  final VBorders borders;

  /// Gradient system.
  final VGradients gradients;

  // WHY: componentOverrides is the Level 3 cascade — sits between global
  // tokens (L1-L2) and per-instance style (L4). This lets consumers set
  // "all VButtons are red" at the theme level without touching each widget.
  /// Component-level style overrides (Level 3 cascade).
  final VComponentOverrides componentOverrides;

  /// Whether the theme is dark mode.
  bool get isDark => brightness == Brightness.dark;

  /// Whether the theme is light mode.
  bool get isLight => brightness == Brightness.light;

  // WHY: copyWith pattern (not freezed) — keeps the library dependency-free
  // and avoids code generation complexity. Each token class is @immutable,
  // so consumers compose overrides without mutation risk.
  /// Creates a copy with only the specified properties changed.
  VThemeData copyWith({
    Brightness? brightness,
    VColors? colors,
    VTypography? typography,
    VSpacing? spacing,
    VRadius? radius,
    VShadows? shadows,
    VAnimations? animations,
    VSizes? sizes,
    VBorders? borders,
    VGradients? gradients,
    VComponentOverrides? componentOverrides,
  }) => VThemeData(
    brightness: brightness ?? this.brightness,
    colors: colors ?? this.colors,
    typography: typography ?? this.typography,
    spacing: spacing ?? this.spacing,
    radius: radius ?? this.radius,
    shadows: shadows ?? this.shadows,
    animations: animations ?? this.animations,
    sizes: sizes ?? this.sizes,
    borders: borders ?? this.borders,
    gradients: gradients ?? this.gradients,
    componentOverrides: componentOverrides ?? this.componentOverrides,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VThemeData &&
        other.brightness == brightness &&
        other.colors == colors &&
        other.typography == typography &&
        other.spacing == spacing &&
        other.radius == radius &&
        other.shadows == shadows &&
        other.animations == animations &&
        other.sizes == sizes &&
        other.borders == borders &&
        other.gradients == gradients &&
        other.componentOverrides == componentOverrides;
  }

  @override
  int get hashCode => Object.hash(
    brightness,
    colors,
    typography,
    spacing,
    radius,
    shadows,
    animations,
    sizes,
    borders,
    gradients,
    componentOverrides,
  );
}
