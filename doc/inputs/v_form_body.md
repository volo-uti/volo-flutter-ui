# VFormBody

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VFormBody

Bordered box that frames a form control, with leading and trailing slots.

[VFormField] wraps one around its child; use it directly for custom controls.

**Basic Usage:**

```dart
VFormBody(
  child: EditableText(...),
)
```

**With Leading/Trailing:**

```dart
VFormBody(
  leading: Text('\$'),
  trailing: Text('USD'),
  child: EditableText(...),
)
```

**Types:** [VFormBodyType.outlined], [VFormBodyType.filled], [VFormBodyType.underline]

See also:
- [VFormField] - Header + Body + Footer composition

### Constructors

#### `VFormBody`

Creates a form body.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | The control drawn inside the box. |
| `leading` | `Widget?` |  |  | Widget shown before [child]. |
| `trailing` | `Widget?` |  |  | Widget shown after [child]. |
| `type` | `VFormBodyType` | `VFormBodyType.outlined` |  | Visual type: outlined, filled or underline. |
| `color` | `VFormBodyColor` | `VFormBodyColor.primary` |  | Accent color used for focus and borders. |
| `size` | `VFormBodySize` | `VFormBodySize.md` |  | Minimum height preset; the box grows with the text scale. |
| `corner` | `VFormBodyCorner` | `VFormBodyCorner.rounded` |  | Corner shape.<br>[VFormBodyCorner.rounded] takes [VFormBodyStyle.borderRadius] when one is set. |
| `fullWidth` | `bool` | `false` |  | Whether the box stretches to the available width. |
| `enabled` | `bool` | `true` |  | Whether the body accepts pointer input. When false it is dimmed and ignores taps. |
| `readOnly` | `bool` | `false` |  | Whether the box is drawn in its read-only look. |
| `focused` | `bool` | `false` |  | Whether the box is drawn with its focus ring. |
| `error` | `bool` | `false` |  | Whether the box is drawn with the error border. |
| `success` | `bool` | `false` |  | Whether the box is drawn with the success border. |
| `style` | `VFormBodyStyle?` |  |  | Style override merged over the theme's [VFormBodyStyle]. |

## VFormBodyType

Form body type.

### Values

| Value | Description |
|---|---|
| `outlined` | Border only. |
| `filled` | Filled background. |
| `underline` | Bottom border only. |

## VFormBodyColor

Form body color.

### Values

| Value | Description |
|---|---|
| `primary` | Primary color. |
| `secondary` | Secondary color. |
| `destructive` | Destructive/delete color. |

## VFormBodySize

Form body size.

### Values

| Value | Description |
|---|---|
| `sm` | Small size (32px). |
| `md` | Medium size (40px). |
| `lg` | Large size (48px). |

## VFormBodyCorner

Form body corner.

### Values

| Value | Description |
|---|---|
| `square` | Square corners. |
| `rounded` | Rounded corners (default). |
| `pill` | Pill shape. |

## VFormBodyStyle

Style override for [VFormBody].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VFormBodyStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `spacing` | `double?` |  |  | Gap between the leading or trailing slot and the child.<br>Defaults to the small spacing token. |
| `padding` | `EdgeInsets?` |  |  | Padding inside the box; defaults to the size's horizontal padding. |
| `backgroundColor` | `Color?` |  |  | Fill color of the box.<br>Defaults to a muted tint for the filled type and to none otherwise. |
| `borderColor` | `Color?` |  |  | Border color while the box is not focused.<br>The disabled, error and success colors win over it; defaults to the input color token. |
| `focusBorderColor` | `Color?` |  |  | Border color while the box is focused.<br>The disabled, error and success colors win over it; defaults to the accent color of `color`. |
| `borderRadius` | `BorderRadius?` |  |  | Corner radius of a rounded box.<br>A square or pill `corner` wins over it; defaults to the size's radius token. |

### Members

| Member | Description |
|---|---|
| `VFormBodyStyle copyWith({double? spacing, EdgeInsets? padding, Color? backgroundColor, Color? borderColor, Color? focusBorderColor, BorderRadius? borderRadius})` | Creates a copy with only the specified properties changed. |
