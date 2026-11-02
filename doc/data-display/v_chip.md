# VChip, VChipGroup

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VChip

Compact pill for a tag, a filter toggle or a removable input value.

The default and [VChip.outlined] chips fire [onTap], [VChip.filter] toggles
through [onSelected], and [VChip.input] shows a delete icon for [onDeleted].
A chip with none of these callbacks is a plain label: it takes no taps or
focus, is not dimmed and is not announced as a button.

The chip is at least as tall as its [size] and grows with its label, so
large text and wrapped labels fit; its ends stay round at any height.

```dart
VChip.filter(
  label: Text('Flutter'),
  leading: Icon(IconData(0xe047, fontFamily: 'MaterialIcons')),
  selected: isSelected,
  onSelected: (value) => setState(() => isSelected = value),
)
```

See also:

- [VChipGroup], which manages several filter chips as one group.
- [VChipItem], the item description used by the group.
- [VChipSize], the chip sizes.

### Constructors

#### `VChip`

Filled chip with a muted background.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `Widget` |  | yes | Content of the chip, usually a short [Text].<br>Font size and color come from the chip, so a plain [Text] needs no style. The label stays on one line and ends with an ellipsis, unless the [Text] sets its own `maxLines`. |
| `leading` | `Widget?` |  |  | Widget shown before the label, such as an icon. |
| `onTap` | `void Function()?` |  |  | Called when the chip is tapped; only on the default and outlined chips. |
| `enabled` | `bool` | `true` |  | Whether the chip reacts to taps and focus; false dims it. |
| `size` | `VChipSize` | `VChipSize.md` |  | Minimum height and padding preset of the chip. |
| `style` | `VChipStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VChip.outlined`

Transparent chip with a border.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `Widget` |  | yes | Content of the chip, usually a short [Text].<br>Font size and color come from the chip, so a plain [Text] needs no style. The label stays on one line and ends with an ellipsis, unless the [Text] sets its own `maxLines`. |
| `leading` | `Widget?` |  |  | Widget shown before the label, such as an icon. |
| `onTap` | `void Function()?` |  |  | Called when the chip is tapped; only on the default and outlined chips. |
| `enabled` | `bool` | `true` |  | Whether the chip reacts to taps and focus; false dims it. |
| `size` | `VChipSize` | `VChipSize.md` |  | Minimum height and padding preset of the chip. |
| `style` | `VChipStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VChip.filter`

Chip that toggles between selected and unselected.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `Widget` |  | yes | Content of the chip, usually a short [Text].<br>Font size and color come from the chip, so a plain [Text] needs no style. The label stays on one line and ends with an ellipsis, unless the [Text] sets its own `maxLines`. |
| `leading` | `Widget?` |  |  | Widget shown before the label, such as an icon. |
| `selected` | `bool` | `false` |  | Whether the filter chip is selected; always false on other variants. |
| `onSelected` | `void Function(bool)?` |  |  | Called with the new selection when a filter chip is tapped. |
| `enabled` | `bool` | `true` |  | Whether the chip reacts to taps and focus; false dims it. |
| `size` | `VChipSize` | `VChipSize.md` |  | Minimum height and padding preset of the chip. |
| `style` | `VChipStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VChip.input`

Chip with a delete icon for removable values.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `Widget` |  | yes | Content of the chip, usually a short [Text].<br>Font size and color come from the chip, so a plain [Text] needs no style. The label stays on one line and ends with an ellipsis, unless the [Text] sets its own `maxLines`. |
| `leading` | `Widget?` |  |  | Widget shown before the label, such as an icon. |
| `onDeleted` | `void Function()?` |  |  | Called when the delete icon of an input chip is tapped.<br>The delete icon is only shown when this is set. |
| `enabled` | `bool` | `true` |  | Whether the chip reacts to taps and focus; false dims it. |
| `size` | `VChipSize` | `VChipSize.md` |  | Minimum height and padding preset of the chip. |
| `style` | `VChipStyle?` |  |  | Per-instance style override merged over the theme style. |

## VChipGroup

Wrapping row of filter chips that reports the selected values as a list.

```dart
VChipGroup<String>(
  items: [
    VChipItem(value: 'flutter', label: Text('Flutter')),
    VChipItem(value: 'dart', label: Text('Dart')),
  ],
  values: selectedTags,
  onChanged: (values) => setState(() => selectedTags = values),
)
```

### Constructors

#### `VChipGroup`

Creates a group of filter chips.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `items` | `List<VChipItem<T>>` |  | yes | Items to render, one filter chip each. |
| `values` | `List<T>` | `const []` |  | Values of the currently selected items. |
| `onChanged` | `void Function(List<T>)?` |  |  | Called with the new list of selected values after a chip is toggled.<br>When null, the chips show the selection but take no taps or focus. |
| `allowMultiple` | `bool` | `true` |  | Whether several chips can be selected at once; false keeps one. |
| `size` | `VChipSize` | `VChipSize.md` |  | Size of every chip in the group. |
| `spacing` | `double` | `8` |  | Horizontal spacing between chips. |
| `runSpacing` | `double` | `8` |  | Vertical spacing between rows of chips. |

## VChipSize

Minimum height presets for a [VChip].

A chip grows taller than its preset when its label needs more room, such
as with large text or a label that wraps.

### Values

| Value | Description |
|---|---|
| `xs` | Extra small size (24px minimum height). |
| `sm` | Small size (24px minimum height). |
| `md` | Medium size (32px minimum height). |
| `lg` | Large size (40px minimum height). |
| `xl` | Extra large size (48px minimum height). |

## VChipItem

One selectable entry of a [VChipGroup].

```dart
VChipItem(value: 'flutter', label: Text('Flutter'))
```

### Constructors

#### `VChipItem`

Creates an item with a value and a label.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `T` |  | yes | Value reported by [VChipGroup.onChanged] while this item is selected. |
| `label` | `Widget` |  | yes | Content of the chip built from this item, usually a short [Text]. |
| `leading` | `Widget?` |  |  | Widget shown before the label, such as an icon. |

## VChipStyle

Style override for [VChip].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VChipStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color.<br>Wins over the color of [textStyle]. |
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `textStyle` | `TextStyle?` |  |  | Label text style merged over the chip default, so only the fields it sets change.<br>The default is the size preset's font size and line height 1.15 in the variant's foreground color. An instance style's text style replaces the theme override's. |
| `deleteIconColor` | `Color?` |  |  | Delete icon color. |

### Members

| Member | Description |
|---|---|
| `VChipStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, BorderRadius? borderRadius, EdgeInsets? padding, TextStyle? textStyle, Color? deleteIconColor})` | Creates a copy with only the specified properties changed. |
