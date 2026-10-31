# VCheckListTile

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VCheckListTile

Tile with a checkbox that toggles when the whole row is tapped.

The checkbox sits at the end by default, at the start with
[VCheckListTile.leading], and inside a bordered card with
[VCheckListTile.card]. With [tristate] the value cycles through false,
true and null.

```dart
VCheckListTile(
  title: const Text('Receive notifications'),
  subtitle: const Text('Get the latest news'),
  secondary: const Icon(Icons.notifications),
  value: isChecked,
  onChanged: (v) => setState(() => isChecked = v ?? false),
)
```

### Constructors

#### `VCheckListTile`

Creates a tile with the checkbox at the end.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Primary content, typically a [Text]; styled with the tile's title style. |
| `value` | `bool?` |  | yes | Whether the box is checked; null means indeterminate when [tristate]. |
| `subtitle` | `Widget?` |  |  | Secondary content below [title], typically a [Text]. |
| `onChanged` | `void Function(bool?)?` |  |  | Called with the next value when the tile is tapped; null disables it. |
| `secondary` | `Widget?` |  |  | Widget on the side opposite the checkbox, such as an icon. |
| `selected` | `bool` | `false` |  | Whether the tile is drawn as the current selection. |
| `enabled` | `bool` | `true` |  | Whether the tile reacts to input; false dims it and ignores taps. |
| `tristate` | `bool` | `false` |  | Whether taps cycle through false, true and null instead of two states. |
| `contentPadding` | `EdgeInsets?` |  |  | Padding around the content. |
| `style` | `VCheckListTileStyle?` |  |  | Per-instance style override merged over the theme's [VCheckListTileStyle]. |

#### `VCheckListTile.leading`

Creates a tile with the checkbox at the start.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Primary content, typically a [Text]; styled with the tile's title style. |
| `value` | `bool?` |  | yes | Whether the box is checked; null means indeterminate when [tristate]. |
| `subtitle` | `Widget?` |  |  | Secondary content below [title], typically a [Text]. |
| `onChanged` | `void Function(bool?)?` |  |  | Called with the next value when the tile is tapped; null disables it. |
| `secondary` | `Widget?` |  |  | Widget on the side opposite the checkbox, such as an icon. |
| `selected` | `bool` | `false` |  | Whether the tile is drawn as the current selection. |
| `enabled` | `bool` | `true` |  | Whether the tile reacts to input; false dims it and ignores taps. |
| `tristate` | `bool` | `false` |  | Whether taps cycle through false, true and null instead of two states. |
| `contentPadding` | `EdgeInsets?` |  |  | Padding around the content. |
| `style` | `VCheckListTileStyle?` |  |  | Per-instance style override merged over the theme's [VCheckListTileStyle]. |

#### `VCheckListTile.card`

Creates a bordered card tile with the checkbox at the end.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Primary content, typically a [Text]; styled with the tile's title style. |
| `value` | `bool?` |  | yes | Whether the box is checked; null means indeterminate when [tristate]. |
| `subtitle` | `Widget?` |  |  | Secondary content below [title], typically a [Text]. |
| `onChanged` | `void Function(bool?)?` |  |  | Called with the next value when the tile is tapped; null disables it. |
| `secondary` | `Widget?` |  |  | Widget on the side opposite the checkbox, such as an icon. |
| `selected` | `bool` | `false` |  | Whether the tile is drawn as the current selection. |
| `enabled` | `bool` | `true` |  | Whether the tile reacts to input; false dims it and ignores taps. |
| `tristate` | `bool` | `false` |  | Whether taps cycle through false, true and null instead of two states. |
| `contentPadding` | `EdgeInsets?` |  |  | Padding around the content. |
| `style` | `VCheckListTileStyle?` |  |  | Per-instance style override merged over the theme's [VCheckListTileStyle]. |

## VCheckListTileStyle

Style override for [VCheckListTile].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VCheckListTileStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `activeColor` | `Color?` |  |  | Checkbox active color. |

### Members

| Member | Description |
|---|---|
| `VCheckListTileStyle copyWith({Color? backgroundColor, Color? foregroundColor, BorderRadius? borderRadius, EdgeInsets? padding, Color? activeColor})` | Creates a copy with only the specified properties changed. |
