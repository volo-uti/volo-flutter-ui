import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VSelect].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VSelectStyle implements VComponentStyle {
  const VSelectStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.focusBorderColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.dropdownBackgroundColor,
    this.dropdownBorderRadius,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border color when focused.
  final Color? focusBorderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Text style.
  final TextStyle? textStyle;

  /// Dropdown menu background color.
  final Color? dropdownBackgroundColor;

  /// Dropdown menu border radius.
  final BorderRadius? dropdownBorderRadius;

  /// Creates a copy with only the specified properties changed.
  VSelectStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    Color? focusBorderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    TextStyle? textStyle,
    Color? dropdownBackgroundColor,
    BorderRadius? dropdownBorderRadius,
  }) => VSelectStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    focusBorderColor: focusBorderColor ?? this.focusBorderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    textStyle: textStyle ?? this.textStyle,
    dropdownBackgroundColor:
        dropdownBackgroundColor ?? this.dropdownBackgroundColor,
    dropdownBorderRadius: dropdownBorderRadius ?? this.dropdownBorderRadius,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VSelectStyle merge(VSelectStyle? other) {
    if (other == null) return this;
    return VSelectStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      focusBorderColor: other.focusBorderColor ?? focusBorderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      textStyle: other.textStyle ?? textStyle,
      dropdownBackgroundColor:
          other.dropdownBackgroundColor ?? dropdownBackgroundColor,
      dropdownBorderRadius: other.dropdownBorderRadius ?? dropdownBorderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VSelectStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.focusBorderColor == focusBorderColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.dropdownBackgroundColor == dropdownBackgroundColor &&
        other.dropdownBorderRadius == dropdownBorderRadius;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderColor,
    focusBorderColor,
    borderRadius,
    padding,
    textStyle,
    dropdownBackgroundColor,
    dropdownBorderRadius,
  );
}
