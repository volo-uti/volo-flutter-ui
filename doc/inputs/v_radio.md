# VRadio

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VRadio

Single-selection radio button, or a whole group via [VRadio.group].

A radio is selected when its [value] equals [groupValue]. Without
[onChanged] it is disabled.

```dart
VRadio<String>(
  value: 'option1',
  groupValue: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  label: const Text('Option 1'),
)
```

### Constructors

#### `VRadio`

Creates a single radio button.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `T?` |  | yes | Value this radio stands for; `null` in group mode. |
| `groupValue` | `T?` |  |  | Currently selected value of the radio set. |
| `onChanged` | `void Function(T?)?` |  |  | Called with the picked value when an unselected radio is tapped. |
| `label` | `Widget?` |  |  | Content shown next to the radio; unused in group mode. |
| `sublabel` | `Widget?` |  |  | Secondary content below [label]; unused in group mode. |
| `enabled` | `bool` | `true` |  | Whether the radio (or the whole group) reacts to input. |
| `size` | `VWidgetSize` | `VWidgetSize.md` |  | Size (sm: 16, md: 20, lg: 24). |
| `style` | `VRadioStyle?` |  |  | Style override merged over the theme's [VRadioStyle]. |

#### `VRadio.group`

Creates a vertical or horizontal group of radios from [options].

```dart
VRadio<String>.group(
  options: [
    VRadioItem(value: 'a', label: Text('Option A')),
    VRadioItem(value: 'b', label: Text('Option B')),
  ],
  groupValue: selected,
  onChanged: (v) => setState(() => selected = v),
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `options` | `List<VRadioItem<T>>` |  | yes | Options of the group; `null` for a single radio. |
| `groupValue` | `T?` |  | yes | Currently selected value of the radio set. |
| `onChanged` | `void Function(T?)?` |  |  | Called with the picked value when an unselected radio is tapped. |
| `orientation` | `Axis?` | `Axis.vertical` |  | Layout direction in group mode. |
| `size` | `VWidgetSize` | `VWidgetSize.md` |  | Size (sm: 16, md: 20, lg: 24). |
| `enabled` | `bool` | `true` |  | Whether the radio (or the whole group) reacts to input. |
| `spacing` | `double?` |  |  | Spacing between items in group mode.<br>Defaults to `theme.spacing.sm` when null. |
| `style` | `VRadioStyle?` |  |  | Style override merged over the theme's [VRadioStyle]. |

## VRadioItem

One option of a [VRadio.group], carrying its value, label and enabled flag.

```dart
VRadioItem(value: 'email', label: Text('Email'))
```

### Constructors

#### `VRadioItem`

Creates a radio option item.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `T` |  | yes | Value reported by the group when this option is picked. |
| `label` | `Widget` |  | yes | Content shown next to the radio. |
| `sublabel` | `Widget?` |  |  | Secondary content below [label]. |
| `enabled` | `bool` | `true` |  | Whether this individual option reacts to input. |

## VRadioStyle

Style override for [VRadio].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VRadioStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `activeColor` | `Color?` |  |  | Fill color when selected. |
| `dotColor` | `Color?` |  |  | Inner dot color. |
| `borderColor` | `Color?` |  |  | Border color. |

### Members

| Member | Description |
|---|---|
| `VRadioStyle copyWith({Color? activeColor, Color? dotColor, Color? borderColor})` | Creates a copy with only the specified properties changed. |
