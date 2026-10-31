# VSelect

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VSelect

Dropdown that picks one option, or several with [VSelect.multiple].

Opens a popover list below the trigger, optionally searchable, and can
carry its own label, helper and error text.

```dart
VSelect<String>(
  value: selected,
  onChanged: (v) => setState(() => selected = v),
  items: [
    VSelectItem(value: 'ko', label: 'Korean'),
    VSelectItem(value: 'en', label: 'English'),
  ],
)
```

### Constructors

#### `VSelect`

Creates a select that picks one [value].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `items` | `List<VSelectItem<T>>` |  | yes | Options offered in the dropdown. |
| `name` | `String?` |  |  | Key identifying this select in debug logs. |
| `value` | `T?` |  |  | Picked value of a single select; `null` shows [placeholder]. |
| `onChanged` | `void Function(T?)?` |  |  | Called with the picked value in a single select. |
| `placeholder` | `String?` |  |  | Text shown in the trigger while nothing is picked. |
| `label` | `String?` |  |  | Label above the field. |
| `more` | `String?` |  |  | Secondary text at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Help widget shown next to the label. |
| `required` | `bool` | `false` |  | Whether the label carries the [requiredMark]. |
| `requiredMark` | `String` | `'*'` |  | Character appended to the label when [required]. |
| `helper` | `String?` |  |  | Helper text below the field. |
| `error` | `bool` | `false` |  | Whether the field is drawn in the error state. |
| `errorText` | `String?` |  |  | Message below the field while [error] is set. |
| `success` | `bool` | `false` |  | Whether the field is drawn in the success state. |
| `successText` | `String?` |  |  | Message below the field while [success] is set. |
| `extra` | `String?` |  |  | Note below the field that is always visible. |
| `size` | `VSelectSize?` |  |  | Trigger size; defaults to medium. |
| `enabled` | `bool` | `true` |  | Whether the select reacts to input. |
| `readOnly` | `bool` | `false` |  | Whether the dropdown is blocked from opening while the value stays visible. |
| `loading` | `bool` | `false` |  | Whether a spinner replaces the chevron. |
| `fullWidth` | `bool` | `false` |  | Whether the trigger fills the available width. |
| `searchable` | `bool` | `false` |  | Whether the dropdown shows a search box that filters options by label. |
| `popoverPosition` | `VPopoverPosition` | `VPopoverPosition.bottomEnd` |  | Where the dropdown opens relative to the trigger. |
| `matchTriggerWidth` | `bool` | `true` |  | Whether the dropdown is as wide as the trigger. |
| `style` | `VSelectStyle?` |  |  | Style override merged over the theme's [VSelectStyle]. |

#### `VSelect.multiple`

Creates a select that picks several [values], up to [maxSelection].

```dart
VSelect<String>.multiple(
  values: selectedList,
  onValuesChanged: (v) => setState(() => selectedList = v),
  items: items,
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `items` | `List<VSelectItem<T>>` |  | yes | Options offered in the dropdown. |
| `name` | `String?` |  |  | Key identifying this select in debug logs. |
| `values` | `List<T>` | `const []` |  | Picked values of a [VSelect.multiple]. |
| `onValuesChanged` | `void Function(List<T>)?` |  |  | Called with the new list when [VSelect.multiple] toggles an option. |
| `maxSelection` | `int?` |  |  | Largest number of values a [VSelect.multiple] accepts; unlimited if `null`. |
| `placeholder` | `String?` |  |  | Text shown in the trigger while nothing is picked. |
| `label` | `String?` |  |  | Label above the field. |
| `more` | `String?` |  |  | Secondary text at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Help widget shown next to the label. |
| `required` | `bool` | `false` |  | Whether the label carries the [requiredMark]. |
| `requiredMark` | `String` | `'*'` |  | Character appended to the label when [required]. |
| `helper` | `String?` |  |  | Helper text below the field. |
| `error` | `bool` | `false` |  | Whether the field is drawn in the error state. |
| `errorText` | `String?` |  |  | Message below the field while [error] is set. |
| `success` | `bool` | `false` |  | Whether the field is drawn in the success state. |
| `successText` | `String?` |  |  | Message below the field while [success] is set. |
| `extra` | `String?` |  |  | Note below the field that is always visible. |
| `size` | `VSelectSize?` |  |  | Trigger size; defaults to medium. |
| `enabled` | `bool` | `true` |  | Whether the select reacts to input. |
| `readOnly` | `bool` | `false` |  | Whether the dropdown is blocked from opening while the value stays visible. |
| `loading` | `bool` | `false` |  | Whether a spinner replaces the chevron. |
| `fullWidth` | `bool` | `false` |  | Whether the trigger fills the available width. |
| `searchable` | `bool` | `false` |  | Whether the dropdown shows a search box that filters options by label. |
| `popoverPosition` | `VPopoverPosition` | `VPopoverPosition.bottomEnd` |  | Where the dropdown opens relative to the trigger. |
| `matchTriggerWidth` | `bool` | `true` |  | Whether the dropdown is as wide as the trigger. |
| `style` | `VSelectStyle?` |  |  | Style override merged over the theme's [VSelectStyle]. |

## VSelectSize

Three-step size of a [VSelect] trigger and its option rows.

### Values

| Value | Description |
|---|---|
| `sm` | Small size. |
| `md` | Medium size (default). |
| `lg` | Large size. |

## VSelectItem

One option of a [VSelect], with a value, a text label and an optional icon.

### Constructors

#### `VSelectItem`

Creates a select item.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `T` |  | yes | Value reported when this option is picked. |
| `label` | `String` |  | yes | Text shown in the option row and, once picked, in the trigger. |
| `leading` | `Widget?` |  |  | Widget shown before [label] in the option row. |
| `enabled` | `bool` | `true` |  | Whether this option can be picked. |

## VSelectStyle

Style override for [VSelect].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VSelectStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `focusBorderColor` | `Color?` |  |  | Border color when focused. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `textStyle` | `TextStyle?` |  |  | Text style. |
| `dropdownBackgroundColor` | `Color?` |  |  | Dropdown menu background color. |
| `dropdownBorderRadius` | `BorderRadius?` |  |  | Dropdown menu border radius. |

### Members

| Member | Description |
|---|---|
| `VSelectStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, Color? focusBorderColor, BorderRadius? borderRadius, EdgeInsets? padding, TextStyle? textStyle, Color? dropdownBackgroundColor, BorderRadius? dropdownBorderRadius})` | Creates a copy with only the specified properties changed. |
