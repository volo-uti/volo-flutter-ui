import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VFormField].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VFormFieldStyle implements VComponentStyle {
  const VFormFieldStyle({
    this.labelStyle,
    this.helperStyle,
    this.errorStyle,
    this.spacing,
  });

  /// Text style of the generated header's label.
  ///
  /// Wins over the theme's `VFormHeaderStyle.titleStyle`.
  final TextStyle? labelStyle;

  /// Text style of the generated footer's helper text.
  ///
  /// Wins over the theme's `VFormFooterStyle.helperStyle`.
  final TextStyle? helperStyle;

  /// Text style of the generated footer's error text.
  ///
  /// Wins over the theme's `VFormFooterStyle.errorStyle`.
  final TextStyle? errorStyle;

  /// Spacing between label, field, and helper/error.
  final double? spacing;

  /// Creates a copy with only the specified properties changed.
  VFormFieldStyle copyWith({
    TextStyle? labelStyle,
    TextStyle? helperStyle,
    TextStyle? errorStyle,
    double? spacing,
  }) => VFormFieldStyle(
    labelStyle: labelStyle ?? this.labelStyle,
    helperStyle: helperStyle ?? this.helperStyle,
    errorStyle: errorStyle ?? this.errorStyle,
    spacing: spacing ?? this.spacing,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VFormFieldStyle merge(VFormFieldStyle? other) {
    if (other == null) return this;
    return VFormFieldStyle(
      labelStyle: other.labelStyle ?? labelStyle,
      helperStyle: other.helperStyle ?? helperStyle,
      errorStyle: other.errorStyle ?? errorStyle,
      spacing: other.spacing ?? spacing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VFormFieldStyle &&
        other.labelStyle == labelStyle &&
        other.helperStyle == helperStyle &&
        other.errorStyle == errorStyle &&
        other.spacing == spacing;
  }

  @override
  int get hashCode => Object.hash(labelStyle, helperStyle, errorStyle, spacing);
}
