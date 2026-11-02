import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_calendar/v_calendar.dart'
    show VSelectableDayPredicate;
import 'package:volo_flutter_ui/src/components/inputs/v_calendar/v_calendar_style.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_form_field/v_form_field.dart';
import 'package:volo_flutter_ui/src/components/surfaces/v_popover/v_popover.dart';
import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_date_picker_style.dart';

part 'v_date_picker_calendar.dart';

/// Date picker size.
///
/// Specifies the size of [VDatePicker]:
/// - [sm] - Small size (height 40px)
/// - [md] - Medium size (height 48px) - default
/// - [lg] - Large size (height 56px)
enum VDatePickerSize {
  /// Small size.
  sm,

  /// Medium size (default).
  md,

  /// Large size.
  lg,
}

/// Form field that opens a popover to pick a date, time, date and time, or range.
///
/// **Variants:**
///
/// - [VDatePicker.date] - Date selection (year/month/day)
/// - [VDatePicker.time] - Time selection (hour/minute)
/// - [VDatePicker.dateTime] - Date+time selection
/// - [VDatePicker.range] - Date range selection (start-end)
///
/// **Date Picker:**
///
/// ```dart
/// VDatePicker.date(
///   value: selectedDate,
///   onChanged: (date) => setState(() => selectedDate = date),
///   placeholder: 'Select date',
/// )
/// ```
///
/// **Time Picker:**
///
/// ```dart
/// VDatePicker.time(
///   timeValue: selectedTime,
///   onTimeChanged: (time) => setState(() => selectedTime = time),
///   use24HourFormat: true,
/// )
/// ```
class VDatePicker extends StatefulWidget {
  /// Date selection.
  const VDatePicker.date({
    super.key,
    this.value,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.label,
    this.more,
    this.tooltip,
    this.required = false,
    this.requiredMark = '*',
    this.placeholder,
    this.helper,
    this.error = false,
    this.errorText,
    this.success = false,
    this.successText,
    this.extra,
    this.size,
    this.enabled = true,
    this.readOnly = false,
    this.fullWidth = false,
    this.style,
  }) : _mode = _DatePickerMode.date,
       timeValue = null,
       onTimeChanged = null,
       rangeValue = null,
       onRangeChanged = null,
       use24HourFormat = true,
       minuteInterval = 1;

  /// Time selection.
  const VDatePicker.time({
    super.key,
    this.timeValue,
    this.onTimeChanged,
    this.use24HourFormat = true,
    this.minuteInterval = 1,
    this.label,
    this.more,
    this.tooltip,
    this.required = false,
    this.requiredMark = '*',
    this.placeholder,
    this.helper,
    this.error = false,
    this.errorText,
    this.success = false,
    this.successText,
    this.extra,
    this.size,
    this.enabled = true,
    this.readOnly = false,
    this.fullWidth = false,
    this.style,
  }) : _mode = _DatePickerMode.time,
       value = null,
       onChanged = null,
       rangeValue = null,
       onRangeChanged = null,
       firstDate = null,
       lastDate = null,
       selectableDayPredicate = null;

  /// Date+time selection.
  const VDatePicker.dateTime({
    super.key,
    this.value,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.use24HourFormat = true,
    this.minuteInterval = 1,
    this.label,
    this.more,
    this.tooltip,
    this.required = false,
    this.requiredMark = '*',
    this.placeholder,
    this.helper,
    this.error = false,
    this.errorText,
    this.success = false,
    this.successText,
    this.extra,
    this.size,
    this.enabled = true,
    this.readOnly = false,
    this.fullWidth = false,
    this.style,
  }) : _mode = _DatePickerMode.dateTime,
       timeValue = null,
       onTimeChanged = null,
       rangeValue = null,
       onRangeChanged = null;

  /// Date range selection.
  const VDatePicker.range({
    super.key,
    this.rangeValue,
    this.onRangeChanged,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.label,
    this.more,
    this.tooltip,
    this.required = false,
    this.requiredMark = '*',
    this.placeholder,
    this.helper,
    this.error = false,
    this.errorText,
    this.success = false,
    this.successText,
    this.extra,
    this.size,
    this.enabled = true,
    this.readOnly = false,
    this.fullWidth = false,
    this.style,
  }) : _mode = _DatePickerMode.range,
       value = null,
       onChanged = null,
       timeValue = null,
       onTimeChanged = null,
       use24HourFormat = true,
       minuteInterval = 1;

  final _DatePickerMode _mode;

  /// Selected date in date and dateTime modes.
  final DateTime? value;

  /// Called with the chosen date (and time in dateTime mode).
  final ValueChanged<DateTime?>? onChanged;

  /// Selected time in time mode.
  final VTimeOfDay? timeValue;

  /// Called with the chosen time.
  final ValueChanged<VTimeOfDay?>? onTimeChanged;

  /// Selected range in range mode.
  final VDateTimeRange? rangeValue;

  /// Called with the completed range once both ends are chosen.
  final ValueChanged<VDateTimeRange?>? onRangeChanged;

  /// Earliest selectable date.
  final DateTime? firstDate;

  /// Latest selectable date.
  final DateTime? lastDate;

  /// Returns whether a day can be selected, e.g. to block weekends.
  final VSelectableDayPredicate? selectableDayPredicate;

  /// Whether times show as 24-hour instead of with AM/PM.
  final bool use24HourFormat;

  /// Step in minutes when the minute spinner is tapped.
  final int minuteInterval;

  /// Label text shown above the field.
  final String? label;

  /// Note shown at the right end of the label row.
  final String? more;

  /// Widget shown next to the label, typically a help icon.
  final Widget? tooltip;

  /// Whether to show [requiredMark] after the label.
  final bool required;

  /// Character shown after the label when [required] is true.
  final String requiredMark;

  /// Text shown while nothing is selected.
  final String? placeholder;

  /// Helper text shown below the field.
  final String? helper;

  /// Whether the field shows the error border and [errorText].
  final bool error;

  /// Error message, shown when [error] is true.
  final String? errorText;

  /// Whether the field shows [successText].
  final bool success;

  /// Success message, shown when [success] is true.
  final String? successText;

  /// Note that stays visible below the message.
  final String? extra;

  /// Height preset; defaults to medium.
  final VDatePickerSize? size;

  /// Whether the picker opens and accepts input. When false it is dimmed.
  final bool enabled;

  /// Whether the value is shown but the popover cannot be opened.
  final bool readOnly;

  /// Whether the field stretches to the available width.
  final bool fullWidth;

  /// Style override.
  final VDatePickerStyle? style;

  @override
  State<VDatePicker> createState() => _VDatePickerState();
}

enum _DatePickerMode { date, time, dateTime, range }
