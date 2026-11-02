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

  /// Fill color of the field's box.
  final Color? backgroundColor;

  /// Color of the typed text; wins over the color of [textStyle].
  final Color? foregroundColor;

  /// Border color of the box while it is not focused.
  ///
  /// The disabled, error and success colors win over it.
  final Color? borderColor;

  /// Border color of the box while it is focused.
  ///
  /// The disabled, error and success colors win over it.
  final Color? focusBorderColor;

  /// Corner radius of a rounded box; a square or pill `corner` wins over it.
  final BorderRadius? borderRadius;

  /// Padding inside the box; defaults to the size's horizontal padding.
  final EdgeInsets? padding;

  /// Text style of the typed text; replaces the size's body type style.
  final TextStyle? textStyle;

  /// Text style of the placeholder; defaults to [textStyle].
  ///
  /// Its color wins over the muted placeholder color.
  final TextStyle? hintStyle;

  /// Text style of the label above the field.
  ///
  /// Replaces the label medium type style; its color wins over the foreground
  /// color.
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
