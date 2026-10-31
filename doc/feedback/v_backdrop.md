# VBackdrop

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VBackdrop

Full-size scrim that dims the content behind a modal surface.

Fills its parent and reports taps, so it usually sits at the bottom of a
[Stack] under a dialog or drawer.

```dart
Stack(
  children: [
    VBackdrop(onTap: () => setState(() => open = false)),
    const Center(child: Text('Modal content')),
  ],
)
```

### Constructors

#### `VBackdrop`

Creates a backdrop filled with [color] at [opacity].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `onTap` | `void Function()?` |  |  | Called when the backdrop is tapped, typically to close the surface above. |
| `color` | `Color?` |  |  | Scrim color; defaults to the theme's scrim color. |
| `opacity` | `double` | `0.5` |  | Opacity applied to the scrim color, from 0 to 1. |
| `style` | `VBackdropStyle?` |  |  | Style override. |

## VBackdropStyle

Style override for [VBackdrop].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VBackdropStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `color` | `Color?` |  |  | Backdrop overlay color. |

### Members

| Member | Description |
|---|---|
| `VBackdropStyle copyWith({Color? color})` | Creates a copy with only the specified properties changed. |
