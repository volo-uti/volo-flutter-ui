# VListTile

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VListTile

Tile with leading, title, subtitle and trailing slots for list rows.

Comes in default (56), [VListTile.dense] (48) and [VListTile.threeLine]
(88) heights. Taps and long presses are reported through [onTap] and
[onLongPress]; the tile is inert while [enabled] is false.

```dart
VListTile(
  leading: const Icon(Icons.person),
  title: const Text('Profile'),
  subtitle: const Text('Manage account information'),
  trailing: const Icon(Icons.chevron_right),
  selected: page == Page.profile,
  onTap: () => navigateToProfile(),
)
```

### Constructors

#### `VListTile`

Creates a 56px tile (72px with a subtitle).

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Primary content, typically a [Text]; styled with the tile's title style. |
| `subtitle` | `Widget?` |  |  | Secondary content below [title], typically a [Text]. |
| `leading` | `Widget?` |  |  | Widget before the text, such as an icon or avatar. |
| `trailing` | `Widget?` |  |  | Widget after the text, such as a chevron or a switch. |
| `onTap` | `void Function()?` |  |  | Called when the tile is tapped; the tile does not react to taps when null. |
| `onLongPress` | `void Function()?` |  |  | Called when the tile is long pressed. |
| `selected` | `bool` | `false` |  | Whether the tile is drawn as the current selection. |
| `enabled` | `bool` | `true` |  | Whether the tile reacts to input; false dims it and ignores taps. |
| `contentPadding` | `EdgeInsets?` |  |  | Padding around the content; defaults to the horizontal large spacing. |
| `tileColor` | `Color?` |  |  | Background color when not selected, hovered or pressed. |
| `selectedTileColor` | `Color?` |  |  | Background color while [selected]. |
| `style` | `VListTileStyle?` |  |  | Per-instance style override merged over the theme's [VListTileStyle]. |

#### `VListTile.dense`

Creates a compact 48px tile.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Primary content, typically a [Text]; styled with the tile's title style. |
| `subtitle` | `Widget?` |  |  | Secondary content below [title], typically a [Text]. |
| `leading` | `Widget?` |  |  | Widget before the text, such as an icon or avatar. |
| `trailing` | `Widget?` |  |  | Widget after the text, such as a chevron or a switch. |
| `onTap` | `void Function()?` |  |  | Called when the tile is tapped; the tile does not react to taps when null. |
| `onLongPress` | `void Function()?` |  |  | Called when the tile is long pressed. |
| `selected` | `bool` | `false` |  | Whether the tile is drawn as the current selection. |
| `enabled` | `bool` | `true` |  | Whether the tile reacts to input; false dims it and ignores taps. |
| `contentPadding` | `EdgeInsets?` |  |  | Padding around the content; defaults to the horizontal large spacing. |
| `tileColor` | `Color?` |  |  | Background color when not selected, hovered or pressed. |
| `selectedTileColor` | `Color?` |  |  | Background color while [selected]. |
| `style` | `VListTileStyle?` |  |  | Per-instance style override merged over the theme's [VListTileStyle]. |

#### `VListTile.threeLine`

Creates an 88px tile whose title and subtitle wrap to two lines.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Primary content, typically a [Text]; styled with the tile's title style. |
| `subtitle` | `Widget?` |  |  | Secondary content below [title], typically a [Text]. |
| `leading` | `Widget?` |  |  | Widget before the text, such as an icon or avatar. |
| `trailing` | `Widget?` |  |  | Widget after the text, such as a chevron or a switch. |
| `onTap` | `void Function()?` |  |  | Called when the tile is tapped; the tile does not react to taps when null. |
| `onLongPress` | `void Function()?` |  |  | Called when the tile is long pressed. |
| `selected` | `bool` | `false` |  | Whether the tile is drawn as the current selection. |
| `enabled` | `bool` | `true` |  | Whether the tile reacts to input; false dims it and ignores taps. |
| `contentPadding` | `EdgeInsets?` |  |  | Padding around the content; defaults to the horizontal large spacing. |
| `tileColor` | `Color?` |  |  | Background color when not selected, hovered or pressed. |
| `selectedTileColor` | `Color?` |  |  | Background color while [selected]. |
| `style` | `VListTileStyle?` |  |  | Per-instance style override merged over the theme's [VListTileStyle]. |

## VListTileStyle

Style override for [VListTile].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VListTileStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `selectedColor` | `Color?` |  |  | Selected state color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `titleStyle` | `TextStyle?` |  |  | Title text style. |
| `subtitleStyle` | `TextStyle?` |  |  | Subtitle text style. |

### Members

| Member | Description |
|---|---|
| `VListTileStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? selectedColor, BorderRadius? borderRadius, EdgeInsets? padding, TextStyle? titleStyle, TextStyle? subtitleStyle})` | Creates a copy with only the specified properties changed. |
