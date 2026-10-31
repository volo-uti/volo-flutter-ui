# VSwitch

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VSwitch

Animated on/off switch with an optional label, also available with I/O marks.

Without [onChanged] the switch is disabled.

```dart
VSwitch(
  value: isOn,
  onChanged: (value) => setState(() => isOn = value),
  label: const Text('Dark mode'),
  sublabel: const Text('Display the screen in dark colors'),
)
```

### Constructors

#### `VSwitch`

Creates a plain switch.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `bool` |  | yes | Whether the switch is on. |
| `name` | `String?` |  |  | Key identifying this switch in debug logs. |
| `onChanged` | `void Function(bool)?` |  |  | Called with the new state when the user toggles the switch. |
| `label` | `Widget?` |  |  | Content shown beside the switch; inherits the label text style. |
| `sublabel` | `Widget?` |  |  | Secondary content below [label]; inherits the muted text style. |
| `enabled` | `bool` | `true` |  | Whether the switch reacts to input. |
| `activeColor` | `Color?` |  |  | Track color while on; defaults to the theme primary color. |
| `size` | `VWidgetSize` | `VWidgetSize.md` |  | Size (sm/md/lg). |
| `style` | `VSwitchStyle?` |  |  | Style override merged over the theme's [VSwitchStyle]. |

#### `VSwitch.labeled`

Creates a switch with I/O marks drawn inside the track.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `bool` |  | yes | Whether the switch is on. |
| `name` | `String?` |  |  | Key identifying this switch in debug logs. |
| `onChanged` | `void Function(bool)?` |  |  | Called with the new state when the user toggles the switch. |
| `label` | `Widget?` |  |  | Content shown beside the switch; inherits the label text style. |
| `sublabel` | `Widget?` |  |  | Secondary content below [label]; inherits the muted text style. |
| `enabled` | `bool` | `true` |  | Whether the switch reacts to input. |
| `activeColor` | `Color?` |  |  | Track color while on; defaults to the theme primary color. |
| `size` | `VWidgetSize` | `VWidgetSize.md` |  | Size (sm/md/lg). |
| `style` | `VSwitchStyle?` |  |  | Style override merged over the theme's [VSwitchStyle]. |

### Members

| Member | Description |
|---|---|
| `bool isLabeled` | Whether the I/O marks are drawn inside the track. |

## VSwitchStyle

Style override for [VSwitch].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VSwitchStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `activeTrackColor` | `Color?` |  |  | Track color when active. |
| `inactiveTrackColor` | `Color?` |  |  | Track color when inactive. |
| `thumbColor` | `Color?` |  |  | Thumb color (inactive state). |
| `activeThumbColor` | `Color?` |  |  | Thumb color when active. |

### Members

| Member | Description |
|---|---|
| `VSwitchStyle copyWith({Color? activeTrackColor, Color? inactiveTrackColor, Color? thumbColor, Color? activeThumbColor})` | Creates a copy with only the specified properties changed. |
