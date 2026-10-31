# VResizablePanelGroup, VResizablePanel, VResizableHandle

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VResizablePanelGroup

Split layout with panels resized by drag or arrow keys.

Lay out [VResizablePanel]s with a [VResizableHandle] between each pair.
Panel sizes are ratios that always sum to 1. [onLayoutChanged] reports all
ratios after a drag or key press, and each panel reports its own through
[VResizablePanel.onSizeChanged].

**Basic Usage:**

```dart
VResizablePanelGroup(
  direction: Axis.horizontal,
  children: [
    VResizablePanel(
      defaultSize: 0.3,
      child: Sidebar(),
    ),
    VResizableHandle(),
    VResizablePanel(
      defaultSize: 0.7,
      child: MainContent(),
    ),
  ],
)
```

**Vertical Layout:**

```dart
VResizablePanelGroup(
  direction: Axis.vertical,
  children: [
    VResizablePanel(defaultSize: 0.6, child: Editor()),
    VResizableHandle(),
    VResizablePanel(defaultSize: 0.4, child: Terminal()),
  ],
)
```

**With Constraints:**

```dart
VResizablePanelGroup(
  children: [
    VResizablePanel(
      defaultSize: 0.25,
      minSize: 0.15,
      maxSize: 0.4,
      child: Sidebar(),
    ),
    VResizableHandle(),
    VResizablePanel(
      defaultSize: 0.75,
      minSize: 0.6,
      child: Content(),
    ),
  ],
)
```

### Constructors

#### `VResizablePanelGroup`

Creates a resizable panel group.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | [VResizablePanel]s separated by [VResizableHandle]s, in order. |
| `direction` | `Axis` | `Axis.horizontal` |  | Axis the panels are laid out along. |
| `onLayoutChanged` | `void Function(List<double>)?` |  |  | Called with every panel ratio after a drag ends or a key press resizes. |
| `style` | `VResizableStyle?` |  |  | Overrides the theme style, for example the handle size and colors. |

## VResizablePanel

One panel of a [VResizablePanelGroup] with a size ratio and limits.

```dart
VResizablePanel(
  defaultSize: 0.3,
  minSize: 0.2,
  collapsible: true,
  onSizeChanged: (ratio) => debugPrint('sidebar $ratio'),
  child: Sidebar(),
)
```

### Constructors

#### `VResizablePanel`

Creates a resizable panel.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content of the panel, clipped to its bounds. |
| `defaultSize` | `double` |  | yes | Initial share of the group between 0 and 1; shares are normalised to sum 1. |
| `minSize` | `double` | `0.0` |  | Smallest share the panel can be dragged to. |
| `maxSize` | `double` | `1.0` |  | Largest share the panel can be dragged to. |
| `collapsible` | `bool` | `false` |  | Whether double-tapping the neighbouring handle collapses and expands it. |
| `collapsedSize` | `double` | `0.0` |  | Share the panel keeps while collapsed. |
| `onCollapse` | `void Function()?` |  |  | Called when the panel is collapsed. |
| `onExpand` | `void Function()?` |  |  | Called when the panel is expanded again. |
| `onSizeChanged` | `void Function(double)?` |  |  | Called with the new share while a handle next to the panel moves. |

## VResizableHandle

Draggable divider between two [VResizablePanel]s in a group.

Drag it, press the arrow keys while it has focus, or double-tap it to
collapse a collapsible panel. It renders nothing outside a
[VResizablePanelGroup].

```dart
VResizableHandle(withHandle: false, enabled: !locked)
```

### Constructors

#### `VResizableHandle`

Creates a resize handle.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `withHandle` | `bool` | `true` |  | Whether a small grip is drawn in the middle of the handle. |
| `enabled` | `bool` | `true` |  | Whether the handle reacts to drag, keys and double-tap. |

## VResizableStyle

Style override for [VResizable].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VResizableStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `handleColor` | `Color?` |  |  | Resize handle color. |
| `handleSize` | `double?` |  |  | Resize handle size. |
| `borderColor` | `Color?` |  |  | Border color. |

### Members

| Member | Description |
|---|---|
| `VResizableStyle copyWith({Color? handleColor, double? handleSize, Color? borderColor})` | Creates a copy with only the specified properties changed. |
