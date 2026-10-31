# VScrollArea

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VScrollArea

Scrollable area with a themed, fading scrollbar.

Wraps [child] in a [SingleChildScrollView] and a [RawScrollbar] styled from
[VTheme]. Use [VScrollArea.horizontal] or [VScrollArea.both] for other
directions. Share a [controller] to read or drive the scroll offset.

**Basic Usage:**

```dart
VScrollArea(
  child: Column(
    children: List.generate(50, (i) => VListTile(title: Text('Item $i'))),
  ),
)
```

**Variants:**

- [VScrollArea] - Vertical scroll (default)
- [VScrollArea.horizontal] - Horizontal scroll
- [VScrollArea.both] - Bidirectional scroll

**With Controller:**

```dart
final controller = ScrollController();

VScrollArea(
  controller: controller,
  thumbVisibility: true,
  child: Column(children: rows),
)
```

### Constructors

#### `VScrollArea`

Creates a scroll area that scrolls vertically.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content that scrolls; it is not itself a scroll view. |
| `controller` | `ScrollController?` |  |  | Controls the scroll offset; drives the vertical axis in [VScrollArea.both]. |
| `padding` | `EdgeInsets?` |  |  | Space around [child] inside the scrolling area. |
| `scrollbarThickness` | `double?` |  |  | Scrollbar width in logical pixels; defaults to 6. |
| `scrollbarRadius` | `double?` |  |  | Corner radius of the scrollbar thumb; defaults to 3. |
| `thumbVisibility` | `bool` | `false` |  | Whether the thumb stays visible instead of fading out. |
| `trackVisibility` | `bool` | `false` |  | Whether the track behind the thumb is drawn. |
| `thumbColor` | `Color?` |  |  | Thumb color; defaults to a translucent muted foreground. |
| `trackColor` | `Color?` |  |  | Track color, shown only while [trackVisibility] is true. |
| `style` | `VScrollAreaStyle?` |  |  | Overrides the theme style, for example thickness, radius and color. |

#### `VScrollArea.horizontal`

Creates a scroll area that scrolls horizontally.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content that scrolls; it is not itself a scroll view. |
| `controller` | `ScrollController?` |  |  | Controls the scroll offset; drives the vertical axis in [VScrollArea.both]. |
| `padding` | `EdgeInsets?` |  |  | Space around [child] inside the scrolling area. |
| `scrollbarThickness` | `double?` |  |  | Scrollbar width in logical pixels; defaults to 6. |
| `scrollbarRadius` | `double?` |  |  | Corner radius of the scrollbar thumb; defaults to 3. |
| `thumbVisibility` | `bool` | `false` |  | Whether the thumb stays visible instead of fading out. |
| `trackVisibility` | `bool` | `false` |  | Whether the track behind the thumb is drawn. |
| `thumbColor` | `Color?` |  |  | Thumb color; defaults to a translucent muted foreground. |
| `trackColor` | `Color?` |  |  | Track color, shown only while [trackVisibility] is true. |
| `style` | `VScrollAreaStyle?` |  |  | Overrides the theme style, for example thickness, radius and color. |

#### `VScrollArea.both`

Creates a scroll area that scrolls both ways, with two scrollbars.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content that scrolls; it is not itself a scroll view. |
| `controller` | `ScrollController?` |  |  | Controls the scroll offset; drives the vertical axis in [VScrollArea.both]. |
| `padding` | `EdgeInsets?` |  |  | Space around [child] inside the scrolling area. |
| `scrollbarThickness` | `double?` |  |  | Scrollbar width in logical pixels; defaults to 6. |
| `scrollbarRadius` | `double?` |  |  | Corner radius of the scrollbar thumb; defaults to 3. |
| `thumbVisibility` | `bool` | `false` |  | Whether the thumb stays visible instead of fading out. |
| `trackVisibility` | `bool` | `false` |  | Whether the track behind the thumb is drawn. |
| `thumbColor` | `Color?` |  |  | Thumb color; defaults to a translucent muted foreground. |
| `trackColor` | `Color?` |  |  | Track color, shown only while [trackVisibility] is true. |
| `style` | `VScrollAreaStyle?` |  |  | Overrides the theme style, for example thickness, radius and color. |

## VScrollAreaStyle

Style override for [VScrollArea].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VScrollAreaStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `scrollbarColor` | `Color?` |  |  | Scrollbar thumb color. |
| `scrollbarRadius` | `BorderRadius?` |  |  | Scrollbar corner radius. |
| `scrollbarThickness` | `double?` |  |  | Scrollbar thickness. |

### Members

| Member | Description |
|---|---|
| `VScrollAreaStyle copyWith({Color? scrollbarColor, BorderRadius? scrollbarRadius, double? scrollbarThickness})` | Creates a copy with only the specified properties changed. |
