# VToggleButton, VToggleButtonGroup

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VToggleButton

Standalone on/off button that is drawn selected while [isSelected] is true.

Without [onChanged] the button is disabled. For a set of related toggles
use [VToggleButtonGroup].

```dart
VToggleButton(
  isSelected: isBold,
  onChanged: (value) => setState(() => isBold = value),
  child: const Icon(Icons.format_bold),
)
```

### Constructors

#### `VToggleButton`

Creates a toggle button showing [child].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `isSelected` | `bool` |  | yes | Whether the button is on and drawn selected. |
| `child` | `Widget` |  | yes | Content of the button; inherits the button's text and icon style. |
| `name` | `String?` |  |  | Key identifying this button in debug logs. |
| `onChanged` | `void Function(bool)?` |  |  | Called with the new state when the user taps the button. |
| `enabled` | `bool` | `true` |  | Whether the button reacts to input. |
| `type` | `VToggleButtonType` | `VToggleButtonType.ghost` |  | Look of the button while it is off. |
| `size` | `VToggleButtonSize?` |  |  | Button size; defaults to medium. |
| `style` | `VToggleButtonStyle?` |  |  | Style override merged over the theme's [VToggleButtonStyle]. |

## VToggleButtonGroup

Segmented row of [VToggleButtonItem]s selecting one value or several.

Each option is a focus stop that Enter or Space toggles. Screen readers hear
a button that is selected in a single-choice group or toggled with
[allowMultiple].

```dart
VToggleButtonGroup<String>(
  value: viewMode,
  items: [
    VToggleButtonItem(
      value: 'grid',
      label: Text('Grid'),
      icon: Icon(Icons.grid_view),
    ),
    VToggleButtonItem(
      value: 'list',
      label: Text('List'),
      icon: Icon(Icons.list),
    ),
  ],
  onChanged: (mode) => setState(() => viewMode = mode),
)
```

### Constructors

#### `VToggleButtonGroup`

Creates a toggle group; set [allowMultiple] to select several values.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `items` | `List<VToggleButtonItem<T>>` |  | yes | Options of the group, in display order. |
| `name` | `String?` |  |  | Key identifying this group in debug logs. |
| `value` | `T?` |  |  | Selected value when [allowMultiple] is false. |
| `values` | `List<T>` | `const []` |  | Selected values when [allowMultiple] is true. |
| `onChanged` | `void Function(T?)?` |  |  | Called with the new value (or `null` when deselected) in single mode. |
| `onValuesChanged` | `void Function(List<T>)?` |  |  | Called with the new list in multiple mode. |
| `allowMultiple` | `bool` | `false` |  | Whether several options can be selected at once. |
| `allowEmpty` | `bool` | `true` |  | Whether the last selected option can be deselected. |
| `type` | `VToggleButtonType` | `VToggleButtonType.ghost` |  | Look of the unselected options. |
| `size` | `VToggleButtonSize?` |  |  | Option height, text size and icon size; defaults to medium. |
| `fullWidth` | `bool` | `false` |  | Whether the group fills the available width. |
| `style` | `VToggleButtonStyle?` |  |  | Style override merged over the theme's [VToggleButtonStyle].<br>The same style a single [VToggleButton] reads: its colors and padding apply to each option, its borderRadius and borderColor to the group. |

## VToggleButtonType

Visual style of a [VToggleButton] or [VToggleButtonGroup] while unselected.

### Values

| Value | Description |
|---|---|
| `filled` | Filled background. |
| `ghost` | No background (default). |
| `outlined` | Bordered style. |

## VToggleButtonSize

Five-step size of a [VToggleButton] or [VToggleButtonGroup].

### Values

| Value | Description |
|---|---|
| `xs` | Extra small (24px). |
| `sm` | Small (32px). |
| `md` | Medium (40px) - default. |
| `lg` | Large (48px). |
| `xl` | Extra large (56px). |

## VToggleButtonItem

One option of a [VToggleButtonGroup], shown as an [icon] or a [label].

### Constructors

#### `VToggleButtonItem`

Creates a toggle button option.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `T` |  | yes | Value reported when this option is selected. |
| `label` | `Widget` |  | yes | Content of the option; replaced by [icon] when one is given. |
| `icon` | `Widget?` |  |  | Icon shown instead of [label]. |
| `enabled` | `bool` | `true` |  | Whether this option reacts to input. |
| `semanticLabel` | `String?` |  |  | Name screen readers announce for this option.<br>Defaults to the text of a `Text` [label] when [icon] replaces it, and to the label's own semantics otherwise. |

## VToggleButtonStyle

Style override for [VToggleButton] and [VToggleButtonGroup].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VToggleButtonStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background of an unselected button or group option, hovered or not. |
| `foregroundColor` | `Color?` |  |  | Text and icon color of an unselected button or group option. |
| `selectedBackgroundColor` | `Color?` |  |  | Background of a selected button or group option. |
| `selectedForegroundColor` | `Color?` |  |  | Text and icon color of a selected button or group option. |
| `borderColor` | `Color?` |  |  | Border color of a single button, or of the outline around a group. |
| `borderRadius` | `BorderRadius?` |  |  | Corner radius of a single button, or of the outer corners of a group. |
| `padding` | `EdgeInsets?` |  |  | Padding inside a single button or a group option. |

### Members

| Member | Description |
|---|---|
| `VToggleButtonStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? selectedBackgroundColor, Color? selectedForegroundColor, Color? borderColor, BorderRadius? borderRadius, EdgeInsets? padding})` | Creates a copy with only the specified properties changed. |
