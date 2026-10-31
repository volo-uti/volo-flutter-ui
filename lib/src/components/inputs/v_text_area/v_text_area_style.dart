import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VTextArea].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VTextAreaStyle implements VComponentStyle {
  const VTextAreaStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.focusBorderColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.hintStyle,
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

  /// Creates a copy with only the specified properties changed.
  VTextAreaStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    Color? focusBorderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    TextStyle? textStyle,
    TextStyle? hintStyle,
  }) => VTextAreaStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    focusBorderColor: focusBorderColor ?? this.focusBorderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    textStyle: textStyle ?? this.textStyle,
    hintStyle: hintStyle ?? this.hintStyle,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VTextAreaStyle merge(VTextAreaStyle? other) {
    if (other == null) return this;
    return VTextAreaStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      focusBorderColor: other.focusBorderColor ?? focusBorderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      textStyle: other.textStyle ?? textStyle,
      hintStyle: other.hintStyle ?? hintStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VTextAreaStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.focusBorderColor == focusBorderColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.hintStyle == hintStyle;
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
  );
}
