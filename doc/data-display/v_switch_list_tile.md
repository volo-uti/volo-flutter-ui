# VSwitchListTile

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VSwitchListTile

Tile with a switch that toggles when the whole row is tapped.

The switch sits at the end by default, at the start with
[VSwitchListTile.leading], and inside a bordered card with
[VSwitchListTile.card].

```dart
VSwitchListTile(
  title: const Text('Location Services'),
  subtitle: const Text('Allow the app to use location data'),
  secondary: const Icon(Icons.location_on),
  value: locationEnabled,
  onChanged: (v) => setState(() => locationEnabled = v),
)
```

### Constructors

#### `VSwitchListTile`

Creates a tile with the switch at the end.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Primary content, typically a [Text]; styled with the tile's title style. |
| `value` | `bool` |  | yes | Whether the switch is on. |
| `subtitle` | `Widget?` |  |  | Secondary content below [title], typically a [Text]. |
| `onChanged` | `void Function(bool)?` |  |  | Called with the next value when the tile is tapped; null disables it. |
| `secondary` | `Widget?` |  |  | Widget on the side opposite the switch, such as an icon. |
| `selected` | `bool` | `false` |  | Whether the tile is drawn as the current selection. |
| `enabled` | `bool` | `true` |  | Whether the tile reacts to input; false dims it and ignores taps. |
| `contentPadding` | `EdgeInsets?` |  |  | Padding around the content. |
| `activeColor` | `Color?` |  |  | Track color while on; overridden by [VSwitchListTileStyle.activeColor]. |
| `style` | `VSwitchListTileStyle?` |  |  | Per-instance style override merged over the theme's [VSwitchListTileStyle]. |

#### `VSwitchListTile.leading`

Creates a tile with the switch at the start.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Primary content, typically a [Text]; styled with the tile's title style. |
| `value` | `bool` |  | yes | Whether the switch is on. |
| `subtitle` | `Widget?` |  |  | Secondary content below [title], typically a [Text]. |
| `onChanged` | `void Function(bool)?` |  |  | Called with the next value when the tile is tapped; null disables it. |
| `secondary` | `Widget?` |  |  | Widget on the side opposite the switch, such as an icon. |
| `selected` | `bool` | `false` |  | Whether the tile is drawn as the current selection. |
| `enabled` | `bool` | `true` |  | Whether the tile reacts to input; false dims it and ignores taps. |
| `contentPadding` | `EdgeInsets?` |  |  | Padding around the content. |
| `activeColor` | `Color?` |  |  | Track color while on; overridden by [VSwitchListTileStyle.activeColor]. |
| `style` | `VSwitchListTileStyle?` |  |  | Per-instance style override merged over the theme's [VSwitchListTileStyle]. |

#### `VSwitchListTile.card`

Creates a bordered card tile with the switch at the end.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Primary content, typically a [Text]; styled with the tile's title style. |
| `value` | `bool` |  | yes | Whether the switch is on. |
| `subtitle` | `Widget?` |  |  | Secondary content below [title], typically a [Text]. |
| `onChanged` | `void Function(bool)?` |  |  | Called with the next value when the tile is tapped; null disables it. |
| `secondary` | `Widget?` |  |  | Widget on the side opposite the switch, such as an icon. |
| `selected` | `bool` | `false` |  | Whether the tile is drawn as the current selection. |
| `enabled` | `bool` | `true` |  | Whether the tile reacts to input; false dims it and ignores taps. |
| `contentPadding` | `EdgeInsets?` |  |  | Padding around the content. |
| `activeColor` | `Color?` |  |  | Track color while on; overridden by [VSwitchListTileStyle.activeColor]. |
| `style` | `VSwitchListTileStyle?` |  |  | Per-instance style override merged over the theme's [VSwitchListTileStyle]. |

## VSwitchListTileStyle

Style override for [VSwitchListTile].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VSwitchListTileStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `activeColor` | `Color?` |  |  | Switch active color. |

### Members

| Member | Description |
|---|---|
| `VSwitchListTileStyle copyWith({Color? backgroundColor, Color? foregroundColor, BorderRadius? borderRadius, EdgeInsets? padding, Color? activeColor})` | Creates a copy with only the specified properties changed. |
