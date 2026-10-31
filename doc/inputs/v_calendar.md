# VCalendar

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VCalendar

Month grid for picking one date, a range or several dates, with event dots.


**Variants:**

- [VCalendar] - Single date selection
- [VCalendar.range] - Date range selection
- [VCalendar.multiple] - Multiple date selection

**Basic Usage:**

```dart
VCalendar(
  value: selectedDate,
  onChanged: (date) => setState(() => selectedDate = date),
)
```

**With Events:**

```dart
VCalendar(
  value: selectedDate,
  onChanged: (date) => setState(() => selectedDate = date),
  events: [
    VCalendarEvent(id: '1', date: DateTime(2024, 12, 25), title: 'Christmas'),
  ],
)
```

### Constructors

#### `VCalendar`

Single date selection.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `DateTime?` |  |  | Selected date in single mode. |
| `onChanged` | `void Function(DateTime?)?` |  |  | Called with the tapped date, or null when the selected date is tapped again. |
| `initialMonth` | `DateTime?` |  |  | Month shown first; defaults to the selected date or today. |
| `firstDate` | `DateTime?` |  |  | Earliest selectable date. |
| `lastDate` | `DateTime?` |  |  | Latest selectable date. |
| `selectableDayPredicate` | `bool Function(DateTime)?` |  |  | Returns whether a day can be selected, e.g. to block weekends. |
| `events` | `List<VCalendarEvent>?` |  |  | Events drawn as dots under their days. |
| `showWeekNumbers` | `bool` | `false` |  | Whether a week-number column is shown. |
| `showOutsideDays` | `bool` | `true` |  | Whether days of the neighboring months fill the grid edges. |
| `weekStartsOnMonday` | `bool` | `false` |  | Whether weeks start on Monday instead of Sunday. |
| `enabled` | `bool` | `true` |  | Whether dates can be selected. When false the grid is dimmed and ignores taps. |
| `style` | `VCalendarStyle?` |  |  | Style override. |

#### `VCalendar.range`

Date range selection.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `rangeValue` | `VDateTimeRange?` |  |  | Selected range in range mode. |
| `onRangeChanged` | `void Function(VDateTimeRange?)?` |  |  | Called with the completed range once both ends are chosen. |
| `initialMonth` | `DateTime?` |  |  | Month shown first; defaults to the selected date or today. |
| `firstDate` | `DateTime?` |  |  | Earliest selectable date. |
| `lastDate` | `DateTime?` |  |  | Latest selectable date. |
| `selectableDayPredicate` | `bool Function(DateTime)?` |  |  | Returns whether a day can be selected, e.g. to block weekends. |
| `events` | `List<VCalendarEvent>?` |  |  | Events drawn as dots under their days. |
| `showWeekNumbers` | `bool` | `false` |  | Whether a week-number column is shown. |
| `showOutsideDays` | `bool` | `true` |  | Whether days of the neighboring months fill the grid edges. |
| `weekStartsOnMonday` | `bool` | `false` |  | Whether weeks start on Monday instead of Sunday. |
| `enabled` | `bool` | `true` |  | Whether dates can be selected. When false the grid is dimmed and ignores taps. |
| `style` | `VCalendarStyle?` |  |  | Style override. |

#### `VCalendar.multiple`

Multiple date selection.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `values` | `List<DateTime>?` |  |  | Selected dates in multiple mode. |
| `onValuesChanged` | `void Function(List<DateTime>)?` |  |  | Called with the updated list when a date is toggled. |
| `maxSelections` | `int?` |  |  | Most dates that can be selected at once; null for no limit. |
| `initialMonth` | `DateTime?` |  |  | Month shown first; defaults to the selected date or today. |
| `firstDate` | `DateTime?` |  |  | Earliest selectable date. |
| `lastDate` | `DateTime?` |  |  | Latest selectable date. |
| `selectableDayPredicate` | `bool Function(DateTime)?` |  |  | Returns whether a day can be selected, e.g. to block weekends. |
| `events` | `List<VCalendarEvent>?` |  |  | Events drawn as dots under their days. |
| `showWeekNumbers` | `bool` | `false` |  | Whether a week-number column is shown. |
| `showOutsideDays` | `bool` | `true` |  | Whether days of the neighboring months fill the grid edges. |
| `weekStartsOnMonday` | `bool` | `false` |  | Whether weeks start on Monday instead of Sunday. |
| `enabled` | `bool` | `true` |  | Whether dates can be selected. When false the grid is dimmed and ignores taps. |
| `style` | `VCalendarStyle?` |  |  | Style override. |

## VSelectableDayPredicate

Returns whether a day can be selected in a calendar or date picker.

```dart
typedef VSelectableDayPredicate = bool Function(DateTime);
```

## VCalendarEvent

Dated event shown as a colored dot under its day in [VCalendar].

```dart
VCalendarEvent(
  id: '1',
  date: DateTime(2024, 12, 25),
  title: 'Christmas',
  color: const Color(0xFFEF4444),
)
```

### Constructors

#### `VCalendarEvent`

Creates a calendar event.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `id` | `String` |  | yes | Identifier that, with [date], defines equality. |
| `date` | `DateTime` |  | yes | Day the dot is drawn under. |
| `title` | `String?` |  |  | Short description of the event. |
| `color` | `Color?` |  |  | Dot color; defaults to the theme's primary color. |
| `data` | `Object?` |  |  | Arbitrary payload carried with the event, not used by the calendar. |

## VCalendarStyle

Style override for [VCalendar].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VCalendarStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `selectedColor` | `Color?` |  |  | Selected date background color. |
| `selectedForegroundColor` | `Color?` |  |  | Selected date foreground color. |
| `todayColor` | `Color?` |  |  | Today indicator color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |

### Members

| Member | Description |
|---|---|
| `VCalendarStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? selectedColor, Color? selectedForegroundColor, Color? todayColor, BorderRadius? borderRadius})` | Creates a copy with only the specified properties changed. |
