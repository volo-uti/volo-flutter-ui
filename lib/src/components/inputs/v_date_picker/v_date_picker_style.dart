import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_calendar/v_calendar_style.dart';
import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VDatePicker].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VDatePickerStyle implements VComponentStyle {
  const VDatePickerStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.focusBorderColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.calendarStyle,
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

  /// Nested calendar style override.
  final VCalendarStyle? calendarStyle;

  /// Creates a copy with only the specified properties changed.
  VDatePickerStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    Color? focusBorderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    TextStyle? textStyle,
    VCalendarStyle? calendarStyle,
  }) => VDatePickerStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    focusBorderColor: focusBorderColor ?? this.focusBorderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    textStyle: textStyle ?? this.textStyle,
    calendarStyle: calendarStyle ?? this.calendarStyle,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VDatePickerStyle merge(VDatePickerStyle? other) {
    if (other == null) return this;
    return VDatePickerStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      focusBorderColor: other.focusBorderColor ?? focusBorderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      textStyle: other.textStyle ?? textStyle,
      calendarStyle: other.calendarStyle ?? calendarStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VDatePickerStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.focusBorderColor == focusBorderColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.calendarStyle == calendarStyle;
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
    calendarStyle,
  );
}
