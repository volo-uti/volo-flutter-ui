# VProgress

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VProgress

Bar or ring that shows how far an operation has come, or that it is still running.

Pass a `value` from 0.0 to 1.0 for determinate progress, or leave it null
for an endless animation. Use [VProgress.linear] or [VProgress.circular].

```dart
VProgress.linear(value: 0.6, size: VProgressSize.lg)
```

See also:

 * [VSkeleton], content loading placeholder
 * [VStepper], step-by-step progress indicator

### Constructors

#### `VProgress.linear`

Horizontal progress bar.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `double?` |  |  | Completed fraction from 0.0 to 1.0, or null for an endless animation. |
| `size` | `VProgressSize` | `VProgressSize.md` |  | Thickness of the bar or diameter of the ring. |
| `color` | `Color?` |  |  | Color of the filled part. Defaults to the theme's primary color. |
| `backgroundColor` | `Color?` |  |  | Color of the unfilled track. Defaults to the theme's muted color. |
| `style` | `VProgressStyle?` |  |  | Style override. |

#### `VProgress.circular`

Circular progress ring.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `double?` |  |  | Completed fraction from 0.0 to 1.0, or null for an endless animation. |
| `size` | `VProgressSize` | `VProgressSize.md` |  | Thickness of the bar or diameter of the ring. |
| `color` | `Color?` |  |  | Color of the filled part. Defaults to the theme's primary color. |
| `backgroundColor` | `Color?` |  |  | Color of the unfilled track. Defaults to the theme's muted color. |
| `style` | `VProgressStyle?` |  |  | Style override. |

## VProgressSize

Progress bar size.

Specifies the size of [VProgress]:
- [sm] - Small size (linear: 4px, circular: 24px)
- [md] - Medium size (linear: 8px, circular: 40px) - default
- [lg] - Large size (linear: 12px, circular: 56px)

### Values

| Value | Description |
|---|---|
| `sm` | Small size. |
| `md` | Medium size (default). |
| `lg` | Large size. |

## VProgressStyle

Style override for [VProgress].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VProgressStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `activeColor` | `Color?` |  |  | Active progress color. |
| `inactiveColor` | `Color?` |  |  | Inactive track color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `trackHeight` | `double?` |  |  | Track height. |

### Members

| Member | Description |
|---|---|
| `VProgressStyle copyWith({Color? activeColor, Color? inactiveColor, BorderRadius? borderRadius, double? trackHeight})` | Creates a copy with only the specified properties changed. |
