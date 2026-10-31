# VSkeleton

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VSkeleton

Animated gray placeholder that mimics the shape of content while it loads.

Use [VSkeleton.rectangular], [VSkeleton.text] or [VSkeleton.circular].

```dart
Row(
  children: [
    VSkeleton.circular(size: 48),
    SizedBox(width: 12),
    Expanded(child: VSkeleton.text(lines: 2)),
  ],
)
```

See also:

 * [VProgress], progress indicator

### Constructors

#### `VSkeleton.rectangular`

Rectangular block placeholder.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `width` | `double?` |  |  | Width in logical pixels; fills the available width when null. |
| `height` | `double` | `16` |  | Height of a rectangular skeleton; text lines are always 14 pixels high. |
| `borderRadius` | `BorderRadius?` |  |  | Corner radius of a rectangular skeleton. Defaults to the theme's small radius. |
| `animation` | `VSkeletonAnimation` | `VSkeletonAnimation.pulse` |  | Animation effect. Defaults to [VSkeletonAnimation.pulse]. |
| `style` | `VSkeletonStyle?` |  |  | Style override. |

#### `VSkeleton.text`

Placeholder for one or more lines of text.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `width` | `double?` |  |  | Width in logical pixels; fills the available width when null. |
| `lines` | `int` | `1` |  | Number of lines in a text skeleton; the last one is shorter. |
| `spacing` | `double` | `8` |  | Vertical gap between text lines. |
| `animation` | `VSkeletonAnimation` | `VSkeletonAnimation.pulse` |  | Animation effect. Defaults to [VSkeletonAnimation.pulse]. |
| `style` | `VSkeletonStyle?` |  |  | Style override. |

#### `VSkeleton.circular`

Round placeholder, for avatars and icons.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `size` | `double` | `40` |  | Diameter of a circular skeleton. |
| `animation` | `VSkeletonAnimation` | `VSkeletonAnimation.pulse` |  | Animation effect. Defaults to [VSkeletonAnimation.pulse]. |
| `style` | `VSkeletonStyle?` |  |  | Style override. |

## VSkeletonAnimation

Animation effect of a [VSkeleton]: pulse (default), wave or none.

### Values

| Value | Description |
|---|---|
| `wave` | Light band sweeping across the block. |
| `pulse` | Opacity fading in and out (default). |
| `none` | No animation. |

## VSkeletonStyle

Style override for [VSkeleton].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VSkeletonStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `baseColor` | `Color?` |  |  | Base shimmer color. |
| `highlightColor` | `Color?` |  |  | Highlight shimmer color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |

### Members

| Member | Description |
|---|---|
| `VSkeletonStyle copyWith({Color? baseColor, Color? highlightColor, BorderRadius? borderRadius})` | Creates a copy with only the specified properties changed. |
