# VFormHeader

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VFormHeader

Label row above a form control, with required mark, tooltip and side note.

[VFormField] builds one for you; use it directly only to label a custom control.

**Basic Usage:**

```dart
VFormHeader(
  label: 'Email',
  required: true,
  child: VFormBody(...),
)
```

**With Tooltip:**

```dart
VFormHeader(
  label: 'Password',
  tooltip: Text('?'),
  child: VFormBody(...),
)
```

See also:
- [VFormField] - Header + Body + Footer composition

### Constructors

#### `VFormHeader`

Creates a form header.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | The control the label belongs to. |
| `label` | `String?` |  |  | Label text. No header is drawn when null.<br>A label too long for the row wraps onto more lines. |
| `more` | `String?` |  |  | Note shown at the right end of the label row. |
| `required` | `bool` | `false` |  | Whether to show [requiredMark] after the label. |
| `requiredMark` | `String` | `'*'` |  | Character shown after the label when [required] is true. |
| `tooltip` | `Widget?` |  |  | Widget shown next to the label, typically a help icon. |
| `floatingLabel` | `bool` | `false` |  | Whether the label floats over the top edge of [child] instead of sitting above it. |
| `style` | `VFormHeaderStyle?` |  |  | Style override merged over the theme's [VFormHeaderStyle]. |

## VFormHeaderStyle

Style override for [VFormHeader].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VFormHeaderStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `titleStyle` | `TextStyle?` |  |  | Text style of the label; replaces the label medium type style.<br>Its color wins over the foreground color. |
| `subtitleStyle` | `TextStyle?` |  |  | Text style of the side note; replaces the label small type style.<br>Its color wins over the muted foreground color. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |

### Members

| Member | Description |
|---|---|
| `VFormHeaderStyle copyWith({TextStyle? titleStyle, TextStyle? subtitleStyle, EdgeInsets? padding})` | Creates a copy with only the specified properties changed. |
