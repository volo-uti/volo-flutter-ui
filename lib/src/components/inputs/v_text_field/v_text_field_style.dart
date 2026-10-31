import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VTextField].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VTextFieldStyle implements VComponentStyle {
  const VTextFieldStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.focusBorderColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.cursorColor,
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

  /// Input text style.
  final TextStyle? textStyle;

  /// Hint text style.
  final TextStyle? hintStyle;

  /// Label text style.
  final TextStyle? labelStyle;

  /// Cursor color.
  final Color? cursorColor;

  /// Creates a copy with only the specified properties changed.
  VTextFieldStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    Color? focusBorderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    Color? cursorColor,
  }) => VTextFieldStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    focusBorderColor: focusBorderColor ?? this.focusBorderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    textStyle: textStyle ?? this.textStyle,
    hintStyle: hintStyle ?? this.hintStyle,
    labelStyle: labelStyle ?? this.labelStyle,
    cursorColor: cursorColor ?? this.cursorColor,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VTextFieldStyle merge(VTextFieldStyle? other) {
    if (other == null) return this;
    return VTextFieldStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      focusBorderColor: other.focusBorderColor ?? focusBorderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      textStyle: other.textStyle ?? textStyle,
      hintStyle: other.hintStyle ?? hintStyle,
      labelStyle: other.labelStyle ?? labelStyle,
      cursorColor: other.cursorColor ?? cursorColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VTextFieldStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.focusBorderColor == focusBorderColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.hintStyle == hintStyle &&
        other.labelStyle == labelStyle &&
        other.cursorColor == cursorColor;
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
    hintStyle,
    labelStyle,
    cursorColor,
  );
}
