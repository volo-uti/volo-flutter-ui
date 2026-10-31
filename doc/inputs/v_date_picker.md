# VDatePicker

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VDatePicker

Form field that opens a popover to pick a date, time, date and time, or range.

**Variants:**

- [VDatePicker.date] - Date selection (year/month/day)
- [VDatePicker.time] - Time selection (hour/minute)
- [VDatePicker.dateTime] - Date+time selection
- [VDatePicker.range] - Date range selection (start-end)

**Date Picker:**

```dart
VDatePicker.date(
  value: selectedDate,
  onChanged: (date) => setState(() => selectedDate = date),
  placeholder: 'Select date',
)
```

**Time Picker:**

```dart
VDatePicker.time(
  timeValue: selectedTime,
  onTimeChanged: (time) => setState(() => selectedTime = time),
  use24HourFormat: true,
)
```

### Constructors

#### `VDatePicker.date`

Date selection.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `DateTime?` |  |  | Selected date in date and dateTime modes. |
| `onChanged` | `void Function(DateTime?)?` |  |  | Called with the chosen date (and time in dateTime mode). |
| `firstDate` | `DateTime?` |  |  | Earliest selectable date. |
| `lastDate` | `DateTime?` |  |  | Latest selectable date. |
| `selectableDayPredicate` | `bool Function(DateTime)?` |  |  | Returns whether a day can be selected, e.g. to block weekends. |
| `label` | `String?` |  |  | Label text shown above the field. |
| `more` | `String?` |  |  | Note shown at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Widget shown next to the label, typically a help icon. |
| `required` | `bool` | `false` |  | Whether to show [requiredMark] after the label. |
| `requiredMark` | `String` | `'*'` |  | Character shown after the label when [required] is true. |
| `placeholder` | `String?` |  |  | Text shown while nothing is selected. |
| `helper` | `String?` |  |  | Helper text shown below the field. |
| `error` | `bool` | `false` |  | Whether the field shows the error border and [errorText]. |
| `errorText` | `String?` |  |  | Error message, shown when [error] is true. |
| `success` | `bool` | `false` |  | Whether the field shows [successText]. |
| `successText` | `String?` |  |  | Success message, shown when [success] is true. |
| `extra` | `String?` |  |  | Note that stays visible below the message. |
| `size` | `VDatePickerSize?` |  |  | Height preset; defaults to medium. |
| `enabled` | `bool` | `true` |  | Whether the picker opens and accepts input. When false it is dimmed. |
| `readOnly` | `bool` | `false` |  | Whether the value is shown but the popover cannot be opened. |
| `fullWidth` | `bool` | `false` |  | Whether the field stretches to the available width. |
| `style` | `VDatePickerStyle?` |  |  | Style override. |

#### `VDatePicker.time`

Time selection.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `timeValue` | `VTimeOfDay?` |  |  | Selected time in time mode. |
| `onTimeChanged` | `void Function(VTimeOfDay?)?` |  |  | Called with the chosen time. |
| `use24HourFormat` | `bool` | `true` |  | Whether times show as 24-hour instead of with AM/PM. |
| `minuteInterval` | `int` | `1` |  | Step in minutes when the minute spinner is tapped. |
| `label` | `String?` |  |  | Label text shown above the field. |
| `more` | `String?` |  |  | Note shown at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Widget shown next to the label, typically a help icon. |
| `required` | `bool` | `false` |  | Whether to show [requiredMark] after the label. |
| `requiredMark` | `String` | `'*'` |  | Character shown after the label when [required] is true. |
| `placeholder` | `String?` |  |  | Text shown while nothing is selected. |
| `helper` | `String?` |  |  | Helper text shown below the field. |
| `error` | `bool` | `false` |  | Whether the field shows the error border and [errorText]. |
| `errorText` | `String?` |  |  | Error message, shown when [error] is true. |
| `success` | `bool` | `false` |  | Whether the field shows [successText]. |
| `successText` | `String?` |  |  | Success message, shown when [success] is true. |
| `extra` | `String?` |  |  | Note that stays visible below the message. |
| `size` | `VDatePickerSize?` |  |  | Height preset; defaults to medium. |
| `enabled` | `bool` | `true` |  | Whether the picker opens and accepts input. When false it is dimmed. |
| `readOnly` | `bool` | `false` |  | Whether the value is shown but the popover cannot be opened. |
| `fullWidth` | `bool` | `false` |  | Whether the field stretches to the available width. |
| `style` | `VDatePickerStyle?` |  |  | Style override. |

#### `VDatePicker.dateTime`

Date+time selection.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `DateTime?` |  |  | Selected date in date and dateTime modes. |
| `onChanged` | `void Function(DateTime?)?` |  |  | Called with the chosen date (and time in dateTime mode). |
| `firstDate` | `DateTime?` |  |  | Earliest selectable date. |
| `lastDate` | `DateTime?` |  |  | Latest selectable date. |
| `selectableDayPredicate` | `bool Function(DateTime)?` |  |  | Returns whether a day can be selected, e.g. to block weekends. |
| `use24HourFormat` | `bool` | `true` |  | Whether times show as 24-hour instead of with AM/PM. |
| `minuteInterval` | `int` | `1` |  | Step in minutes when the minute spinner is tapped. |
| `label` | `String?` |  |  | Label text shown above the field. |
| `more` | `String?` |  |  | Note shown at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Widget shown next to the label, typically a help icon. |
| `required` | `bool` | `false` |  | Whether to show [requiredMark] after the label. |
| `requiredMark` | `String` | `'*'` |  | Character shown after the label when [required] is true. |
| `placeholder` | `String?` |  |  | Text shown while nothing is selected. |
| `helper` | `String?` |  |  | Helper text shown below the field. |
| `error` | `bool` | `false` |  | Whether the field shows the error border and [errorText]. |
| `errorText` | `String?` |  |  | Error message, shown when [error] is true. |
| `success` | `bool` | `false` |  | Whether the field shows [successText]. |
| `successText` | `String?` |  |  | Success message, shown when [success] is true. |
| `extra` | `String?` |  |  | Note that stays visible below the message. |
| `size` | `VDatePickerSize?` |  |  | Height preset; defaults to medium. |
| `enabled` | `bool` | `true` |  | Whether the picker opens and accepts input. When false it is dimmed. |
| `readOnly` | `bool` | `false` |  | Whether the value is shown but the popover cannot be opened. |
| `fullWidth` | `bool` | `false` |  | Whether the field stretches to the available width. |
| `style` | `VDatePickerStyle?` |  |  | Style override. |

#### `VDatePicker.range`

Date range selection.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `rangeValue` | `VDateTimeRange?` |  |  | Selected range in range mode. |
| `onRangeChanged` | `void Function(VDateTimeRange?)?` |  |  | Called with the completed range once both ends are chosen. |
| `firstDate` | `DateTime?` |  |  | Earliest selectable date. |
| `lastDate` | `DateTime?` |  |  | Latest selectable date. |
| `selectableDayPredicate` | `bool Function(DateTime)?` |  |  | Returns whether a day can be selected, e.g. to block weekends. |
| `label` | `String?` |  |  | Label text shown above the field. |
| `more` | `String?` |  |  | Note shown at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Widget shown next to the label, typically a help icon. |
| `required` | `bool` | `false` |  | Whether to show [requiredMark] after the label. |
| `requiredMark` | `String` | `'*'` |  | Character shown after the label when [required] is true. |
| `placeholder` | `String?` |  |  | Text shown while nothing is selected. |
| `helper` | `String?` |  |  | Helper text shown below the field. |
| `error` | `bool` | `false` |  | Whether the field shows the error border and [errorText]. |
| `errorText` | `String?` |  |  | Error message, shown when [error] is true. |
| `success` | `bool` | `false` |  | Whether the field shows [successText]. |
| `successText` | `String?` |  |  | Success message, shown when [success] is true. |
| `extra` | `String?` |  |  | Note that stays visible below the message. |
| `size` | `VDatePickerSize?` |  |  | Height preset; defaults to medium. |
| `enabled` | `bool` | `true` |  | Whether the picker opens and accepts input. When false it is dimmed. |
| `readOnly` | `bool` | `false` |  | Whether the value is shown but the popover cannot be opened. |
| `fullWidth` | `bool` | `false` |  | Whether the field stretches to the available width. |
| `style` | `VDatePickerStyle?` |  |  | Style override. |

## VDatePickerSize

Date picker size.

Specifies the size of [VDatePicker]:
- [sm] - Small size (height 40px)
- [md] - Medium size (height 48px) - default
- [lg] - Large size (height 56px)

### Values

| Value | Description |
|---|---|
| `sm` | Small size. |
| `md` | Medium size (default). |
| `lg` | Large size. |

## VTimeOfDay

Hour and minute of a day, used by time mode of [VDatePicker].

### Constructors

#### `VTimeOfDay`

Creates a time of day.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `hour` | `int` |  | yes | Hour in 24-hour format, 0 to 23. |
| `minute` | `int` |  | yes | Minute, 0 to 59. |

#### `VTimeOfDay.now`

Current time.

#### `VTimeOfDay.fromDateTime`

Extracts time from a DateTime.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `time` | `DateTime` |  | yes |  |

### Members

| Member | Description |
|---|---|
| `int get hourOfPeriod` | Hour in 12-hour format. |
| `VDayPeriod get period` | Half of the day a [VTimeOfDay] falls in. |

## VDayPeriod

Half of the day a [VTimeOfDay] falls in.

### Values

| Value | Description |
|---|---|
| `am` |  |
| `pm` |  |

## VDateTimeRange

Inclusive range between two dates.

### Constructors

#### `VDateTimeRange`

Creates a date range.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `start` | `DateTime` |  | yes | Start date. |
| `end` | `DateTime` |  | yes | End date. |

### Members

| Member | Description |
|---|---|
| `Duration get duration` | Duration (in days). |

## VDatePickerStyle

Style override for [VDatePicker].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VDatePickerStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `focusBorderColor` | `Color?` |  |  | Border color when focused. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `textStyle` | `TextStyle?` |  |  | Text style. |
| `calendarStyle` | `VCalendarStyle?` |  |  | Nested calendar style override. |

### Members

| Member | Description |
|---|---|
| `VDatePickerStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, Color? focusBorderColor, BorderRadius? borderRadius, EdgeInsets? padding, TextStyle? textStyle, VCalendarStyle? calendarStyle})` | Creates a copy with only the specified properties changed. |
