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
    this.minWidth,
  });

  /// Fill color of the trigger.
  final Color? backgroundColor;

  /// Color of the picked value in the trigger; wins over the color of [textStyle].
  ///
  /// The placeholder keeps the muted color.
  final Color? foregroundColor;

  /// Border color of the trigger while it is not focused.
  ///
  /// The disabled and error colors win over it.
  final Color? borderColor;

  /// Border color of the trigger while it has keyboard focus.
  ///
  /// The disabled and error colors win over it; defaults to the focus ring
  /// color token.
  final Color? focusBorderColor;

  /// Corner radius of the trigger; defaults to the size's radius token.
  final BorderRadius? borderRadius;

  /// Padding inside the trigger; defaults to the size's horizontal padding.
  final EdgeInsets? padding;

  /// Text style of the trigger, merged over the body type style at the size's font size.
  final TextStyle? textStyle;

  /// Background color of the dropdown panel; defaults to the popover color.
  final Color? dropdownBackgroundColor;

  /// Corner radius of the dropdown panel; defaults to the popover radius.
  final BorderRadius? dropdownBorderRadius;

  /// Minimum width of the trigger when it is not full width.
  ///
  /// Defaults to a width that grows with the size.
  final double? minWidth;

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
    double? minWidth,
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
    minWidth: minWidth ?? this.minWidth,
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
      minWidth: other.minWidth ?? minWidth,
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
        other.dropdownBorderRadius == dropdownBorderRadius &&
        other.minWidth == minWidth;
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
    minWidth,
  );
}
