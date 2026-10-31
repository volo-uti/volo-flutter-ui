# VGrid

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VGrid

Scrollable grid by column count, tile width or delegate.

A [GridView] with one [spacing] value for both axes, built through
[VGrid.count], [VGrid.extent] or [VGrid.custom].

## Basic Usage:

3-column fixed grid:

```dart
VGrid.count(
  crossAxisCount: 3,
  spacing: 8,
  children: [
    Container(color: Colors.red),
    Container(color: Colors.green),
    Container(color: Colors.blue),
  ],
)
```

## Variants:

- [VGrid.count] - Fixed column count grid
- [VGrid.extent] - Max column width grid
- [VGrid.custom] - Custom delegate grid

## Extent Grid:

Responsive grid based on max width:

```dart
VGrid.extent(
  maxCrossAxisExtent: 150,
  spacing: 16,
  childAspectRatio: 1.5,
  children: productCards,
)
```

## Custom Delegate:

Grid using a custom delegate:

```dart
VGrid.custom(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
  ),
  children: items,
)
```

See also:

- [GridView], Flutter built-in grid widget
- [SliverGridDelegate], grid layout delegate

### Constructors

#### `VGrid.count`

Fixed column count grid.

```dart
VGrid.count(
  crossAxisCount: 4,
  spacing: 8,
  children: items,
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Tiles laid out in the grid. |
| `crossAxisCount` | `int` |  | yes |  |
| `mainAxisSpacing` | `double?` |  |  | Gap between rows; falls back to [spacing] when null. |
| `crossAxisSpacing` | `double?` |  |  | Gap between columns; falls back to [spacing] when null. |
| `spacing` | `double?` |  |  | Gap between rows and columns, unless the axis value is set; defaults to 0. |
| `childAspectRatio` | `double` | `1.0` |  | Width divided by height of each tile; ignored by [mainAxisExtent]. |
| `mainAxisExtent` | `double?` |  |  | Fixed tile extent along the main axis, replacing [childAspectRatio]. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Space around the whole grid. |
| `scrollDirection` | `Axis` | `Axis.vertical` |  | Axis the grid scrolls along. |
| `shrinkWrap` | `bool` | `false` |  | Whether the grid is as tall as its tiles instead of filling its parent. |
| `physics` | `ScrollPhysics?` |  |  | How the grid reacts to user scrolling. |
| `primary` | `bool?` |  |  | Whether this grid uses the primary scroll controller. |
| `reverse` | `bool` | `false` |  | Whether tiles start from the opposite end of the scroll axis. |
| `style` | `VGridStyle?` |  |  | Overrides the theme style, for example the spacing. |

#### `VGrid.extent`

Max column width grid.

Column count adjusts automatically based on screen size.

```dart
VGrid.extent(
  maxCrossAxisExtent: 200,
  spacing: 12,
  children: items,
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Tiles laid out in the grid. |
| `maxCrossAxisExtent` | `double` |  | yes |  |
| `mainAxisSpacing` | `double?` |  |  | Gap between rows; falls back to [spacing] when null. |
| `crossAxisSpacing` | `double?` |  |  | Gap between columns; falls back to [spacing] when null. |
| `spacing` | `double?` |  |  | Gap between rows and columns, unless the axis value is set; defaults to 0. |
| `childAspectRatio` | `double` | `1.0` |  | Width divided by height of each tile; ignored by [mainAxisExtent]. |
| `mainAxisExtent` | `double?` |  |  | Fixed tile extent along the main axis, replacing [childAspectRatio]. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Space around the whole grid. |
| `scrollDirection` | `Axis` | `Axis.vertical` |  | Axis the grid scrolls along. |
| `shrinkWrap` | `bool` | `false` |  | Whether the grid is as tall as its tiles instead of filling its parent. |
| `physics` | `ScrollPhysics?` |  |  | How the grid reacts to user scrolling. |
| `primary` | `bool?` |  |  | Whether this grid uses the primary scroll controller. |
| `reverse` | `bool` | `false` |  | Whether tiles start from the opposite end of the scroll axis. |
| `style` | `VGridStyle?` |  |  | Overrides the theme style, for example the spacing. |

#### `VGrid.custom`

Custom delegate grid.

Directly specify a [SliverGridDelegate] for complex layouts.

```dart
VGrid.custom(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
  ),
  children: items,
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Tiles laid out in the grid. |
| `gridDelegate` | `SliverGridDelegate` |  | yes |  |
| `mainAxisSpacing` | `double?` |  |  | Gap between rows; falls back to [spacing] when null. |
| `crossAxisSpacing` | `double?` |  |  | Gap between columns; falls back to [spacing] when null. |
| `spacing` | `double?` |  |  | Gap between rows and columns, unless the axis value is set; defaults to 0. |
| `childAspectRatio` | `double` | `1.0` |  | Width divided by height of each tile; ignored by [mainAxisExtent]. |
| `mainAxisExtent` | `double?` |  |  | Fixed tile extent along the main axis, replacing [childAspectRatio]. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Space around the whole grid. |
| `scrollDirection` | `Axis` | `Axis.vertical` |  | Axis the grid scrolls along. |
| `shrinkWrap` | `bool` | `false` |  | Whether the grid is as tall as its tiles instead of filling its parent. |
| `physics` | `ScrollPhysics?` |  |  | How the grid reacts to user scrolling. |
| `primary` | `bool?` |  |  | Whether this grid uses the primary scroll controller. |
| `reverse` | `bool` | `false` |  | Whether tiles start from the opposite end of the scroll axis. |
| `style` | `VGridStyle?` |  |  | Overrides the theme style, for example the spacing. |

## VGridStyle

Style override for [VGrid].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VGridStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `spacing` | `double?` |  |  | Spacing between grid items. |

### Members

| Member | Description |
|---|---|
| `VGridStyle copyWith({double? spacing})` | Creates a copy with only the specified properties changed. |
