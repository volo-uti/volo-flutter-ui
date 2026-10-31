# VSettingTile

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VSettingTile

Row for a settings screen: a plain item, a navigation link, a switch or a checkbox.

Pick the variant with a named constructor: [VSettingTile.simple],
[VSettingTile.navigation], [VSettingTile.switchTile] or
[VSettingTile.checkbox]. The toggle variants flip on a tap anywhere on the
row and report the new value through `onChanged`.

```dart
VSettingTile.switchTile(
  leading: const Icon(Icons.notifications),
  title: const Text('Notifications'),
  subtitle: const Text('Receive push notifications'),
  value: notifications,
  onChanged: (v) => setState(() => notifications = v),
)
```

### Constructors

#### `VSettingTile.simple`

Creates a plain item with an optional [trailing] widget.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Setting name, typically a [Text]. |
| `subtitle` | `Widget?` |  |  | Description below [title], typically a [Text]. |
| `leading` | `Widget?` |  |  | Widget before the text, such as an icon. |
| `trailing` | `Widget?` |  |  | Custom widget at the end; only the simple variant shows it. |
| `onTap` | `void Function()?` |  |  | Called when the row is tapped; only the simple and navigation variants use it. |
| `enabled` | `bool` | `true` |  | Whether the row reacts to input; false dims it and ignores taps. |
| `style` | `VSettingTileStyle?` |  |  | Per-instance style override merged over the theme's [VSettingTileStyle]. |

#### `VSettingTile.navigation`

Creates a link row with an optional [value] label and a chevron.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Setting name, typically a [Text]. |
| `onTap` | `void Function()?` |  | yes | Called when the row is tapped; only the simple and navigation variants use it. |
| `subtitle` | `Widget?` |  |  | Description below [title], typically a [Text]. |
| `leading` | `Widget?` |  |  | Widget before the text, such as an icon. |
| `value` | `String?` |  |  | Current value shown before the chevron; only the navigation variant shows it. |
| `enabled` | `bool` | `true` |  | Whether the row reacts to input; false dims it and ignores taps. |
| `style` | `VSettingTileStyle?` |  |  | Per-instance style override merged over the theme's [VSettingTileStyle]. |

#### `VSettingTile.switchTile`

Creates a row with a switch at the end.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Setting name, typically a [Text]. |
| `value` | `bool` |  | yes | Current value shown before the chevron; only the navigation variant shows it. |
| `subtitle` | `Widget?` |  |  | Description below [title], typically a [Text]. |
| `leading` | `Widget?` |  |  | Widget before the text, such as an icon. |
| `onChanged` | `void Function(bool)?` |  |  |  |
| `enabled` | `bool` | `true` |  | Whether the row reacts to input; false dims it and ignores taps. |
| `style` | `VSettingTileStyle?` |  |  | Per-instance style override merged over the theme's [VSettingTileStyle]. |

#### `VSettingTile.checkbox`

Creates a row with a checkbox at the end.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Setting name, typically a [Text]. |
| `value` | `bool` |  | yes | Current value shown before the chevron; only the navigation variant shows it. |
| `subtitle` | `Widget?` |  |  | Description below [title], typically a [Text]. |
| `leading` | `Widget?` |  |  | Widget before the text, such as an icon. |
| `onChanged` | `void Function(bool)?` |  |  |  |
| `enabled` | `bool` | `true` |  | Whether the row reacts to input; false dims it and ignores taps. |
| `style` | `VSettingTileStyle?` |  |  | Per-instance style override merged over the theme's [VSettingTileStyle]. |

## VSettingTileStyle

Style override for [VSettingTile].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VSettingTileStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |

### Members

| Member | Description |
|---|---|
| `VSettingTileStyle copyWith({Color? backgroundColor, Color? foregroundColor, BorderRadius? borderRadius, EdgeInsets? padding})` | Creates a copy with only the specified properties changed. |
