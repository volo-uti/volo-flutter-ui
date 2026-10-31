# VLoadingSpinner

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VLoadingSpinner

Rotating arc that shows an operation is in progress, without a known end.

One rotation takes [VAnimations.verySlow] from the current theme.

```dart
VLoadingSpinner(color: VTheme.of(context).colors.primary, size: 16)
```

### Constructors

#### `VLoadingSpinner`

Creates an arc-based loading spinner.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `color` | `Color` |  | yes | Color of the active arc; the track uses the same color at 30% opacity. |
| `size` | `double?` |  |  | Width and height of the spinner; fills the parent constraints when null. |
| `strokeWidth` | `double?` |  |  | Arc thickness; one twelfth of the width when null. |
| `style` | `VLoadingSpinnerStyle?` |  |  | Style override. |

## VLoadingSpinnerStyle

Style override for [VLoadingSpinner].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VLoadingSpinnerStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `color` | `Color?` |  |  | Spinner color. |
| `strokeWidth` | `double?` |  |  | Stroke width. |

### Members

| Member | Description |
|---|---|
| `VLoadingSpinnerStyle copyWith({Color? color, double? strokeWidth})` | Creates a copy with only the specified properties changed. |
