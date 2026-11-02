# VFab

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VFab

Floating button for the primary action of a screen, in round and extended forms.

**Basic Usage:**

```dart
VFab(
  icon: Icon(Icons.add),
  onPressed: () {},
)
```

**Variants:**

- [VFab] - Default (56x56)
- [VFab.small] - Small size (40x40)
- [VFab.large] - Large size (96x96)
- [VFab.extended] - With text label

**Extended FAB:**

```dart
VFab.extended(
  icon: Icon(Icons.add),
  label: Text('New item'),
  onPressed: () {},
)
```

### Constructors

#### `VFab`

Creates a 56x56 FAB.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `icon` | `Widget?` |  | yes | Icon shown in the FAB; plain `Icon` children take the foreground color. |
| `onPressed` | `void Function()?` |  |  | Called when the FAB is tapped; `null` renders it disabled. |
| `tooltip` | `String?` |  |  | Label announced by screen readers. |
| `backgroundColor` | `Color?` |  |  | Fill color; defaults to the primary color. |
| `foregroundColor` | `Color?` |  |  | Icon and label color; defaults to the primary foreground color. |
| `elevation` | `double?` |  |  | Shadow depth in logical pixels; defaults to the theme's medium shadow.<br>When set it wins over [VFabStyle.shadows]. |
| `heroTag` | `Object?` |  |  | Tag that makes the FAB a [Hero] across route transitions. |
| `enabled` | `bool` | `true` |  | Whether the FAB reacts to input; `false` dims it and blocks presses. |
| `style` | `VFabStyle?` |  |  | Per-instance style override merged over the theme's [VFabStyle]. |

#### `VFab.small`

Creates a 40x40 FAB.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `icon` | `Widget?` |  | yes | Icon shown in the FAB; plain `Icon` children take the foreground color. |
| `onPressed` | `void Function()?` |  |  | Called when the FAB is tapped; `null` renders it disabled. |
| `tooltip` | `String?` |  |  | Label announced by screen readers. |
| `backgroundColor` | `Color?` |  |  | Fill color; defaults to the primary color. |
| `foregroundColor` | `Color?` |  |  | Icon and label color; defaults to the primary foreground color. |
| `elevation` | `double?` |  |  | Shadow depth in logical pixels; defaults to the theme's medium shadow.<br>When set it wins over [VFabStyle.shadows]. |
| `heroTag` | `Object?` |  |  | Tag that makes the FAB a [Hero] across route transitions. |
| `enabled` | `bool` | `true` |  | Whether the FAB reacts to input; `false` dims it and blocks presses. |
| `style` | `VFabStyle?` |  |  | Per-instance style override merged over the theme's [VFabStyle]. |

#### `VFab.large`

Creates a 96x96 FAB.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `icon` | `Widget?` |  | yes | Icon shown in the FAB; plain `Icon` children take the foreground color. |
| `onPressed` | `void Function()?` |  |  | Called when the FAB is tapped; `null` renders it disabled. |
| `tooltip` | `String?` |  |  | Label announced by screen readers. |
| `backgroundColor` | `Color?` |  |  | Fill color; defaults to the primary color. |
| `foregroundColor` | `Color?` |  |  | Icon and label color; defaults to the primary foreground color. |
| `elevation` | `double?` |  |  | Shadow depth in logical pixels; defaults to the theme's medium shadow.<br>When set it wins over [VFabStyle.shadows]. |
| `heroTag` | `Object?` |  |  | Tag that makes the FAB a [Hero] across route transitions. |
| `enabled` | `bool` | `true` |  | Whether the FAB reacts to input; `false` dims it and blocks presses. |
| `style` | `VFabStyle?` |  |  | Per-instance style override merged over the theme's [VFabStyle]. |

#### `VFab.extended`

Creates a pill-shaped FAB with an icon and a text label.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `icon` | `Widget?` |  |  | Icon shown in the FAB; plain `Icon` children take the foreground color. |
| `label` | `Widget?` |  |  | Text shown next to [icon] in the extended FAB. |
| `onPressed` | `void Function()?` |  |  | Called when the FAB is tapped; `null` renders it disabled. |
| `tooltip` | `String?` |  |  | Label announced by screen readers. |
| `backgroundColor` | `Color?` |  |  | Fill color; defaults to the primary color. |
| `foregroundColor` | `Color?` |  |  | Icon and label color; defaults to the primary foreground color. |
| `elevation` | `double?` |  |  | Shadow depth in logical pixels; defaults to the theme's medium shadow.<br>When set it wins over [VFabStyle.shadows]. |
| `heroTag` | `Object?` |  |  | Tag that makes the FAB a [Hero] across route transitions. |
| `enabled` | `bool` | `true` |  | Whether the FAB reacts to input; `false` dims it and blocks presses. |
| `style` | `VFabStyle?` |  |  | Per-instance style override merged over the theme's [VFabStyle]. |

## VFabStyle

Style override for [VFab].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VFabStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text / icon foreground color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `shadows` | `List<BoxShadow>?` |  |  | Shadows under the FAB; the theme's medium shadow, large while pressed, when null.<br>The list replaces both, and an empty list draws none. [VFab.elevation] wins over it, and an instance style wins over the theme override. |
| `overlayColor` | `Color?` |  |  | Color laid over the fill while the FAB is hovered or pressed; none when null.<br>An instance style wins over the theme override. |
| `iconColor` | `Color?` |  |  | Color of the icon; the FAB's foreground color when null.<br>The label keeps the foreground color. An instance style wins over the theme override. |

### Members

| Member | Description |
|---|---|
| `VFabStyle copyWith({Color? backgroundColor, Color? foregroundColor, BorderRadius? borderRadius, List<BoxShadow>? shadows, Color? overlayColor, Color? iconColor})` | Creates a copy with only the specified properties changed. |
