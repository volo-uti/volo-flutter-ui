# VStack

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VStack

Row or column with a fixed gap between children.

[VStack.horizontal] builds a [Row] and [VStack.vertical] a [Column]; both
insert [spacing] between neighbours. Unlike Flutter's `Stack`, children do
not overlap. An empty list renders nothing.

## Basic Usage:

Vertical stack:

```dart
VStack.vertical(
  spacing: 8,
  children: [
    Text('Item 1'),
    Text('Item 2'),
    Text('Item 3'),
  ],
)
```

## Variants:

- [VStack.horizontal] - Horizontal stack (Row-based)
- [VStack.vertical] - Vertical stack (Column-based)

## Horizontal Stack:

Horizontal stack:

```dart
VStack.horizontal(
  spacing: 16,
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.settings),
  ],
)
```

## With Alignment:

Stack with alignment:

```dart
VStack.vertical(
  spacing: 12,
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: [
    Text('Title', style: TextStyle(fontSize: 20)),
    Text('Subtitle', style: TextStyle(fontSize: 14)),
    Text('Description'),
  ],
)
```

See also:

- [Row], Flutter built-in horizontal layout
- [Column], Flutter built-in vertical layout
- [VBox], single child container

### Constructors

#### `VStack.horizontal`

Horizontal stack (Row-based).

Arranges children horizontally using [Row].

```dart
VStack.horizontal(
  spacing: 8,
  children: [Widget1(), Widget2()],
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Widgets laid out in order. |
| `spacing` | `double?` |  |  | Gap between neighbouring children, in logical pixels; defaults to 0. |
| `mainAxisAlignment` | `MainAxisAlignment` | `MainAxisAlignment.start` |  | How children are placed along the main axis. |
| `crossAxisAlignment` | `CrossAxisAlignment` | `CrossAxisAlignment.center` |  | How children are placed across the main axis. |
| `mainAxisSize` | `MainAxisSize` | `MainAxisSize.max` |  | Whether to fill the main axis or shrink to the children. |
| `textDirection` | `TextDirection?` |  |  | Order of horizontal children, for right-to-left layouts. |
| `verticalDirection` | `VerticalDirection` | `VerticalDirection.down` |  | Order of vertical children, top to bottom or reversed. |
| `style` | `VStackStyle?` |  |  | Overrides the theme style, for example the spacing. |

#### `VStack.vertical`

Vertical stack (Column-based).

Arranges children vertically using [Column].

```dart
VStack.vertical(
  spacing: 8,
  children: [Widget1(), Widget2()],
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Widgets laid out in order. |
| `spacing` | `double?` |  |  | Gap between neighbouring children, in logical pixels; defaults to 0. |
| `mainAxisAlignment` | `MainAxisAlignment` | `MainAxisAlignment.start` |  | How children are placed along the main axis. |
| `crossAxisAlignment` | `CrossAxisAlignment` | `CrossAxisAlignment.center` |  | How children are placed across the main axis. |
| `mainAxisSize` | `MainAxisSize` | `MainAxisSize.max` |  | Whether to fill the main axis or shrink to the children. |
| `textDirection` | `TextDirection?` |  |  | Order of horizontal children, for right-to-left layouts. |
| `verticalDirection` | `VerticalDirection` | `VerticalDirection.down` |  | Order of vertical children, top to bottom or reversed. |
| `style` | `VStackStyle?` |  |  | Overrides the theme style, for example the spacing. |

## VStackStyle

Style override for [VStack].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VStackStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `spacing` | `double?` |  |  | Spacing between children. |

### Members

| Member | Description |
|---|---|
| `VStackStyle copyWith({double? spacing})` | Creates a copy with only the specified properties changed. |
