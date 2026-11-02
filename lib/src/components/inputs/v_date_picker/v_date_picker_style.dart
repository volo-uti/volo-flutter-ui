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

  /// Color of the picked value in the trigger; wins over the color of [textStyle].
  ///
  /// The placeholder keeps the muted color. An instance style wins over the
  /// theme override.
  final Color? foregroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border color of the trigger while it has keyboard focus.
  ///
  /// The border is then 2px wide. The disabled and error colors win over it;
  /// defaults to the focus ring color token. An instance style wins over the
  /// theme override.
  final Color? focusBorderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Text style of the trigger, merged over the body type style at the size's font size.
  ///
  /// An instance style wins over the theme override.
  final TextStyle? textStyle;

  /// Colors and corners of the calendar in the popover, as on a [VCalendar].
  ///
  /// The selected, today and day colors default to the same tokens as
  /// [VCalendar]. Its backgroundColor and borderRadius shape the calendar
  /// panel, which has no fill of its own when null. The theme's
  /// [VCalendarStyle] does not reach it, and an instance style's
  /// calendarStyle replaces the theme override's as a whole.
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
