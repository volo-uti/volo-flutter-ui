# VListTile

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VListTile

Tile with leading, title, subtitle and trailing slots for list rows.

Comes in default (56), [VListTile.dense] (48) and [VListTile.threeLine]
(88) minimum heights, and grows with its content. Taps and long presses are
reported through [onTap] and [onLongPress]; the tile is inert while
[enabled] is false. [VListTileStyle] sets the leading slot width, the gaps
beside the text and the minimum height.

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

Creates a tile at least 56px tall (72px with a subtitle).

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Primary content, typically a [Text]; styled with the tile's title style.<br>It ends with an ellipsis after one line, or two on a three-line tile. A [Text] that sets its own `maxLines` keeps it; `maxLines: null` falls back to the tile's limit, so give a number. |
| `subtitle` | `Widget?` |  |  | Secondary content below [title], typically a [Text].<br>Lines are limited as for [title]. |
| `leading` | `Widget?` |  |  | Widget before the text, such as an icon or avatar. |
| `trailing` | `Widget?` |  |  | Widget after the text, such as a chevron or a switch.<br>It takes its natural width and does not shrink, so wrap a long one in a `ConstrainedBox(constraints: BoxConstraints(maxWidth: ...))` to bound it. |
| `onTap` | `void Function()?` |  |  | Called when the tile is tapped; the tile does not react to taps when null. |
| `onLongPress` | `void Function()?` |  |  | Called when the tile is long pressed. |
| `selected` | `bool` | `false` |  | Whether the tile is drawn as the current selection. |
| `enabled` | `bool` | `true` |  | Whether the tile reacts to input; false dims it and ignores taps. |
| `contentPadding` | `EdgeInsets?` |  |  | Padding around the content; defaults to the horizontal large spacing. |
| `tileColor` | `Color?` |  |  | Background color when not selected, hovered or pressed. |
| `selectedTileColor` | `Color?` |  |  | Background color while [selected]. |
| `style` | `VListTileStyle?` |  |  | Per-instance style override merged over the theme's [VListTileStyle]. |

#### `VListTile.dense`

Creates a compact tile at least 48px tall.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Primary content, typically a [Text]; styled with the tile's title style.<br>It ends with an ellipsis after one line, or two on a three-line tile. A [Text] that sets its own `maxLines` keeps it; `maxLines: null` falls back to the tile's limit, so give a number. |
| `subtitle` | `Widget?` |  |  | Secondary content below [title], typically a [Text].<br>Lines are limited as for [title]. |
| `leading` | `Widget?` |  |  | Widget before the text, such as an icon or avatar. |
| `trailing` | `Widget?` |  |  | Widget after the text, such as a chevron or a switch.<br>It takes its natural width and does not shrink, so wrap a long one in a `ConstrainedBox(constraints: BoxConstraints(maxWidth: ...))` to bound it. |
| `onTap` | `void Function()?` |  |  | Called when the tile is tapped; the tile does not react to taps when null. |
| `onLongPress` | `void Function()?` |  |  | Called when the tile is long pressed. |
| `selected` | `bool` | `false` |  | Whether the tile is drawn as the current selection. |
| `enabled` | `bool` | `true` |  | Whether the tile reacts to input; false dims it and ignores taps. |
| `contentPadding` | `EdgeInsets?` |  |  | Padding around the content; defaults to the horizontal large spacing. |
| `tileColor` | `Color?` |  |  | Background color when not selected, hovered or pressed. |
| `selectedTileColor` | `Color?` |  |  | Background color while [selected]. |
| `style` | `VListTileStyle?` |  |  | Per-instance style override merged over the theme's [VListTileStyle]. |

#### `VListTile.threeLine`

Creates a tile at least 88px tall whose title and subtitle wrap to two lines.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Primary content, typically a [Text]; styled with the tile's title style.<br>It ends with an ellipsis after one line, or two on a three-line tile. A [Text] that sets its own `maxLines` keeps it; `maxLines: null` falls back to the tile's limit, so give a number. |
| `subtitle` | `Widget?` |  |  | Secondary content below [title], typically a [Text].<br>Lines are limited as for [title]. |
| `leading` | `Widget?` |  |  | Widget before the text, such as an icon or avatar. |
| `trailing` | `Widget?` |  |  | Widget after the text, such as a chevron or a switch.<br>It takes its natural width and does not shrink, so wrap a long one in a `ConstrainedBox(constraints: BoxConstraints(maxWidth: ...))` to bound it. |
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
| `leadingWidth` | `double?` |  |  | Width of the leading slot; defaults to the medium size step height (40).<br>The slot is at least as tall as the medium size step and centers the leading widget. An instance style wins over the theme override. |
| `leadingGap` | `double?` |  |  | Gap between the leading slot and the text; defaults to large spacing (16).<br>An instance style wins over the theme override. |
| `trailingGap` | `double?` |  |  | Gap between the text and the trailing widget; defaults to large spacing.<br>An instance style wins over the theme override. |
| `minHeight` | `double?` |  |  | Minimum tile height that replaces the variant's own minimum.<br>The variant minimums are 56 (72 with a subtitle), 48 for dense and 88 for three-line tiles. The tile still grows with its content. An instance style wins over the theme override. |

### Members

| Member | Description |
|---|---|
| `VListTileStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? selectedColor, BorderRadius? borderRadius, EdgeInsets? padding, TextStyle? titleStyle, TextStyle? subtitleStyle, double? leadingWidth, double? leadingGap, double? trailingGap, double? minHeight})` | Creates a copy with only the specified properties changed. |
