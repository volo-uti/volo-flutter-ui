# VButtonGroupScope, VButtonGroup

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VButtonGroupScope

Inherited scope that makes a [VButtonGroupData] visible to descendants.

### Constructors

#### `VButtonGroupScope`

Creates a scope exposing [data] to [child].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `data` | `VButtonGroupData` |  | yes | Data exposed to descendants. |
| `child` | `Widget` |  | yes |  |

### Members

| Member | Description |
|---|---|
| `static VButtonGroupData? maybeOf(BuildContext context)` | Returns the data from the nearest [VButtonGroupScope]. |

## VButtonGroup

Row or column of [VButton]s joined into one segmented control.

Gives the buttons connected corner radii and a shared size.

```dart
VButtonGroup(
  children: [
    VButton(onPressed: () {}, child: Text('Left')),
    VButton(onPressed: () {}, child: Text('Center')),
    VButton(onPressed: () {}, child: Text('Right')),
  ],
)
```

### Constructors

#### `VButtonGroup`

Creates a button group.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Buttons in display order. |
| `orientation` | `VButtonGroupOrientation` | `VButtonGroupOrientation.horizontal` |  | Direction of the layout. |
| `size` | `VButtonSize?` |  |  | Size shared by all child buttons. |
| `spacing` | `double` | `0` |  | Gap between buttons; zero keeps them connected. |
| `style` | `VButtonGroupStyle?` |  |  | Style override merged over the theme's [VButtonGroupStyle]. |

## VButtonGroupData

Size and corner radius a [VButtonGroup] hands down to each child [VButton].

### Constructors

#### `VButtonGroupData`

Creates the data a group shares with one of its buttons.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `size` | `VButtonSize?` |  |  | Button size shared across the entire group. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius computed based on position within the group (first/middle/last). |

## VButtonGroupOrientation

Direction in which a [VButtonGroup] lays out its buttons.

### Values

| Value | Description |
|---|---|
| `horizontal` | Horizontal layout (default). |
| `vertical` | Vertical layout. |

## VButtonGroupStyle

Style override for [VButtonGroup].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VButtonGroupStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `spacing` | `double?` |  |  | Spacing between buttons. |

### Members

| Member | Description |
|---|---|
| `VButtonGroupStyle copyWith({Color? borderColor, BorderRadius? borderRadius, double? spacing})` | Creates a copy with only the specified properties changed. |
