import 'package:flutter/widgets.dart';

import 'v_sizes.generated.dart';

/// Height, padding, font and icon size of one size step.
///
/// Defines height, padding, font size, icon size, and spacing for each component.
@immutable
class VComponentSize {
  /// Creates a size step.
  const VComponentSize({
    required this.height,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.fontSize,
    required this.iconSize,
    required this.spacing,
    required this.borderRadius,
  });

  /// Interpolates between two sizes (for animations).
  VComponentSize.lerp(VComponentSize a, VComponentSize b, double t)
    : height = a.height + (b.height - a.height) * t,
      paddingHorizontal =
          a.paddingHorizontal + (b.paddingHorizontal - a.paddingHorizontal) * t,
      paddingVertical =
          a.paddingVertical + (b.paddingVertical - a.paddingVertical) * t,
      fontSize = a.fontSize + (b.fontSize - a.fontSize) * t,
      iconSize = a.iconSize + (b.iconSize - a.iconSize) * t,
      spacing = a.spacing + (b.spacing - a.spacing) * t,
      borderRadius = a.borderRadius + (b.borderRadius - a.borderRadius) * t;

  /// Component height.
  final double height;

  /// Horizontal padding.
  final double paddingHorizontal;

  /// Vertical padding.
  final double paddingVertical;

  /// Font size.
  final double fontSize;

  /// Icon size.
  final double iconSize;

  /// Spacing between elements.
  final double spacing;

  /// Border radius.
  final double borderRadius;

  /// Returns padding as EdgeInsets.
  EdgeInsets get padding => EdgeInsets.symmetric(
    horizontal: paddingHorizontal,
    vertical: paddingVertical,
  );

  /// Creates a copy with only the specified properties changed.
  VComponentSize copyWith({
    double? height,
    double? paddingHorizontal,
    double? paddingVertical,
    double? fontSize,
    double? iconSize,
    double? spacing,
    double? borderRadius,
  }) => VComponentSize(
    height: height ?? this.height,
    paddingHorizontal: paddingHorizontal ?? this.paddingHorizontal,
    paddingVertical: paddingVertical ?? this.paddingVertical,
    fontSize: fontSize ?? this.fontSize,
    iconSize: iconSize ?? this.iconSize,
    spacing: spacing ?? this.spacing,
    borderRadius: borderRadius ?? this.borderRadius,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VComponentSize &&
        other.height == height &&
        other.paddingHorizontal == paddingHorizontal &&
        other.paddingVertical == paddingVertical &&
        other.fontSize == fontSize &&
        other.iconSize == iconSize &&
        other.spacing == spacing &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(
    height,
    paddingHorizontal,
    paddingVertical,
    fontSize,
    iconSize,
    spacing,
    borderRadius,
  );
}

/// Component size steps from xs to xl.
///
/// Provides five sizes: xs, sm, md (default), lg, xl.
@immutable
class VSizes {
  /// Creates size tokens.
  const VSizes({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  /// Interpolates between two size systems (for animations).
  VSizes.lerp(VSizes a, VSizes b, double t)
    : xs = VComponentSize.lerp(a.xs, b.xs, t),
      sm = VComponentSize.lerp(a.sm, b.sm, t),
      md = VComponentSize.lerp(a.md, b.md, t),
      lg = VComponentSize.lerp(a.lg, b.lg, t),
      xl = VComponentSize.lerp(a.xl, b.xl, t);

  /// Extra small size (height: 24px).
  final VComponentSize xs;

  /// Small size (height: 32px).
  final VComponentSize sm;

  /// Medium size (height: 40px) - default.
  final VComponentSize md;

  /// Large size (height: 48px).
  final VComponentSize lg;

  /// Extra large size (height: 56px).
  final VComponentSize xl;

  /// Default size values.
  ///
  /// Values sourced from DTCG tokens via [VSizesDefaults].
  static final VSizes defaults = VSizes(
    xs: VComponentSize(
      height: VSizesDefaults.defaults.xs.height,
      paddingHorizontal: VSizesDefaults.defaults.xs.paddingHorizontal,
      paddingVertical: VSizesDefaults.defaults.xs.paddingVertical,
      fontSize: VSizesDefaults.defaults.xs.fontSize,
      iconSize: VSizesDefaults.defaults.xs.iconSize,
      spacing: VSizesDefaults.defaults.xs.spacing,
      borderRadius: VSizesDefaults.defaults.xs.borderRadius,
    ),
    sm: VComponentSize(
      height: VSizesDefaults.defaults.sm.height,
      paddingHorizontal: VSizesDefaults.defaults.sm.paddingHorizontal,
      paddingVertical: VSizesDefaults.defaults.sm.paddingVertical,
      fontSize: VSizesDefaults.defaults.sm.fontSize,
      iconSize: VSizesDefaults.defaults.sm.iconSize,
      spacing: VSizesDefaults.defaults.sm.spacing,
      borderRadius: VSizesDefaults.defaults.sm.borderRadius,
    ),
    md: VComponentSize(
      height: VSizesDefaults.defaults.md.height,
      paddingHorizontal: VSizesDefaults.defaults.md.paddingHorizontal,
      paddingVertical: VSizesDefaults.defaults.md.paddingVertical,
      fontSize: VSizesDefaults.defaults.md.fontSize,
      iconSize: VSizesDefaults.defaults.md.iconSize,
      spacing: VSizesDefaults.defaults.md.spacing,
      borderRadius: VSizesDefaults.defaults.md.borderRadius,
    ),
    lg: VComponentSize(
      height: VSizesDefaults.defaults.lg.height,
      paddingHorizontal: VSizesDefaults.defaults.lg.paddingHorizontal,
      paddingVertical: VSizesDefaults.defaults.lg.paddingVertical,
      fontSize: VSizesDefaults.defaults.lg.fontSize,
      iconSize: VSizesDefaults.defaults.lg.iconSize,
      spacing: VSizesDefaults.defaults.lg.spacing,
      borderRadius: VSizesDefaults.defaults.lg.borderRadius,
    ),
    xl: VComponentSize(
      height: VSizesDefaults.defaults.xl.height,
      paddingHorizontal: VSizesDefaults.defaults.xl.paddingHorizontal,
      paddingVertical: VSizesDefaults.defaults.xl.paddingVertical,
      fontSize: VSizesDefaults.defaults.xl.fontSize,
      iconSize: VSizesDefaults.defaults.xl.iconSize,
      spacing: VSizesDefaults.defaults.xl.spacing,
      borderRadius: VSizesDefaults.defaults.xl.borderRadius,
    ),
  );

  /// Creates a copy with only the specified properties changed.
  VSizes copyWith({
    VComponentSize? xs,
    VComponentSize? sm,
    VComponentSize? md,
    VComponentSize? lg,
    VComponentSize? xl,
  }) => VSizes(
    xs: xs ?? this.xs,
    sm: sm ?? this.sm,
    md: md ?? this.md,
    lg: lg ?? this.lg,
    xl: xl ?? this.xl,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VSizes &&
        other.xs == xs &&
        other.sm == sm &&
        other.md == md &&
        other.lg == lg &&
        other.xl == xl;
  }

  @override
  int get hashCode => Object.hash(xs, sm, md, lg, xl);
}
