import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VButtonGroup].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VButtonGroupStyle implements VComponentStyle {
  const VButtonGroupStyle({this.borderColor, this.borderRadius, this.spacing});

  /// Border color every button in the group draws.
  ///
  /// A button's own instance style wins over it; it wins over the theme's
  /// `VButtonStyle.borderColor` and the variant's border.
  final Color? borderColor;

  /// Outer corner radius of the group; inner corners stay square.
  ///
  /// Defaults to the size's radius token. It wins over a button's own corner.
  final BorderRadius? borderRadius;

  /// Gap between buttons; the group's `spacing` argument wins over it.
  final double? spacing;

  /// Creates a copy with only the specified properties changed.
  VButtonGroupStyle copyWith({
    Color? borderColor,
    BorderRadius? borderRadius,
    double? spacing,
  }) => VButtonGroupStyle(
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    spacing: spacing ?? this.spacing,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VButtonGroupStyle merge(VButtonGroupStyle? other) {
    if (other == null) return this;
    return VButtonGroupStyle(
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      spacing: other.spacing ?? spacing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VButtonGroupStyle &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.spacing == spacing;
  }

  @override
  int get hashCode => Object.hash(borderColor, borderRadius, spacing);
}
