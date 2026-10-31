# VCheckbox, VCheckboxGroup

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VCheckbox

Tri-state checkbox with an optional label, also available as a bordered card.

A `null` [value] shows the indeterminate state. Tapping a checked box reports
`false`; any other state reports `true`. Without [onChanged] the checkbox is disabled.

```dart
VCheckbox(
  value: isChecked,
  onChanged: (value) => setState(() => isChecked = value),
  label: const Text('I agree'),
)
```

### Constructors

#### `VCheckbox`

Creates a plain checkbox.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `bool?` |  | yes | Check state; `null` means indeterminate. |
| `name` | `String?` |  |  | Key identifying this checkbox in debug logs. |
| `onChanged` | `void Function(bool?)?` |  |  | Called with the new state when the user toggles the checkbox. |
| `label` | `Widget?` |  |  | Content shown next to the box; inherits the label text style. |
| `sublabel` | `Widget?` |  |  | Secondary content below [label]; inherits the muted text style. |
| `enabled` | `bool` | `true` |  | Whether the checkbox reacts to input. |
| `size` | `VWidgetSize` | `VWidgetSize.md` |  | Size (sm: 16, md: 20, lg: 24). |
| `style` | `VCheckboxStyle?` |  |  | Style override merged over the theme's [VCheckboxStyle]. |

#### `VCheckbox.card`

Creates a checkbox wrapped in a bordered card.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `bool?` |  | yes | Check state; `null` means indeterminate. |
| `name` | `String?` |  |  | Key identifying this checkbox in debug logs. |
| `onChanged` | `void Function(bool?)?` |  |  | Called with the new state when the user toggles the checkbox. |
| `label` | `Widget?` |  |  | Content shown next to the box; inherits the label text style. |
| `sublabel` | `Widget?` |  |  | Secondary content below [label]; inherits the muted text style. |
| `enabled` | `bool` | `true` |  | Whether the checkbox reacts to input. |
| `size` | `VWidgetSize` | `VWidgetSize.md` |  | Size (sm: 16, md: 20, lg: 24). |
| `style` | `VCheckboxStyle?` |  |  | Style override merged over the theme's [VCheckboxStyle]. |

## VCheckboxGroup

Group of [VCheckbox]es that reports the selected values as a `List<T>`.

```dart
VCheckboxGroup<String>(
  options: [
    VCheckboxItem(value: 'email', label: Text('Email')),
    VCheckboxItem(value: 'sms', label: Text('SMS')),
    VCheckboxItem(value: 'push', label: Text('Push')),
  ],
  values: selectedValues,
  onChanged: (v) => setState(() => selectedValues = v),
)
```

### Constructors

#### `VCheckboxGroup`

Creates a checkbox group for multi-select.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `options` | `List<VCheckboxItem<T>>` |  | yes | Checkbox option items. |
| `values` | `List<T>` |  | yes | Currently selected values. |
| `onChanged` | `void Function(List<T>)?` |  |  | Called with the new selection when any option is toggled. |
| `orientation` | `Axis` | `Axis.vertical` |  | Layout orientation. |
| `size` | `VWidgetSize` | `VWidgetSize.md` |  | Size for all checkboxes in the group. |
| `enabled` | `bool` | `true` |  | Whether the whole group reacts to input. |
| `spacing` | `double?` |  |  | Spacing between items.<br>Defaults to `theme.spacing.sm` when null. |

## VWidgetSize

Three-step size for the checkbox, radio and switch family.

Used by [VCheckbox], [VRadio], [VSwitch] and others.

### Values

| Value | Description |
|---|---|
| `sm` | Small size. |
| `md` | Medium size (default). |
| `lg` | Large size. |

## VCheckboxItem

One option of a [VCheckboxGroup], carrying its value, label and enabled flag.

```dart
VCheckboxItem(value: 'email', label: Text('Email notifications'))
```

### Constructors

#### `VCheckboxItem`

Creates a checkbox option item.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `T` |  | yes | Value reported in the group's selection when this option is checked. |
| `label` | `Widget` |  | yes | Content shown next to the checkbox. |
| `sublabel` | `Widget?` |  |  | Secondary content below [label]. |
| `enabled` | `bool` | `true` |  | Whether this individual option reacts to input. |

## VCheckboxStyle

Style override for [VCheckbox].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VCheckboxStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `activeColor` | `Color?` |  |  | Fill color when checked. |
| `checkColor` | `Color?` |  |  | Check mark color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |

### Members

| Member | Description |
|---|---|
| `VCheckboxStyle copyWith({Color? activeColor, Color? checkColor, Color? borderColor, BorderRadius? borderRadius})` | Creates a copy with only the specified properties changed. |
