# VLink

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VLink

Inline link that underlines on hover and reports taps.

Plain `Text` children are drawn in the link color with the chosen
underline behavior.

```dart
VLink(
  onTap: () => launchUrl(Uri.parse('https://example.com')),
  child: Text('Learn more'),
)
```

See also:

- [VButton.link] - Link-style button variant.

### Constructors

#### `VLink`

Creates a link around [child].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content of the link; plain `Text` takes the link color and underline. |
| `onTap` | `void Function()?` |  |  | Called when the link is tapped; `null` renders it inert. |
| `underline` | `VLinkUnderline` | `VLinkUnderline.always` |  | When the underline is drawn. |
| `color` | `VLinkColor` | `VLinkColor.primary` |  | Color role of the link. |
| `semanticLabel` | `String?` |  |  | Label announced by screen readers instead of the child's own text. |
| `style` | `VLinkStyle?` |  |  | Per-instance style override merged over the theme's [VLinkStyle]. |

## VLinkUnderline

Link underline behavior.

### Values

| Value | Description |
|---|---|
| `always` | Always show underline. |
| `hover` | Show underline on hover (default). |
| `none` | Never show underline. |

## VLinkColor

Link color variant.

### Values

| Value | Description |
|---|---|
| `primary` | Primary color (default). |
| `secondary` | Secondary/muted color. |
| `inherit` | Inherit from parent. |

## VLinkStyle

Style override for [VLink].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VLinkStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `hoverColor` | `Color?` |  |  | Color on hover. |
| `visitedColor` | `Color?` |  |  | Color for visited links. |
| `textStyle` | `TextStyle?` |  |  | Text style. |

### Members

| Member | Description |
|---|---|
| `VLinkStyle copyWith({Color? foregroundColor, Color? hoverColor, Color? visitedColor, TextStyle? textStyle})` | Creates a copy with only the specified properties changed. |
