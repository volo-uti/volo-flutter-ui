# VLabel

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VLabel

Label for a form field with an optional required mark.

Plain `Text` children are drawn in the label's size and weight.

```dart
VLabel(
  required: true,
  child: Text('Password'),
)
```

See also:

- [VFormField] - Complete form field wrapper with label, input, and footer.

### Constructors

#### `VLabel`

Creates a label around [child].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content of the label; plain `Text` takes the label style. |
| `required` | `bool` | `false` |  | Whether the required mark is shown after [child]. |
| `size` | `VLabelSize` | `VLabelSize.md` |  | Font size preset. |
| `requiredMark` | `String` | `'*'` |  | Text of the required mark. |
| `style` | `VLabelStyle?` |  |  | Per-instance style override merged over the theme's [VLabelStyle]. |

## VLabelSize

Label size.

### Values

| Value | Description |
|---|---|
| `sm` | Small size. |
| `md` | Medium size (default). |
| `lg` | Large size. |

## VLabelStyle

Style override for [VLabel].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VLabelStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `textStyle` | `TextStyle?` |  |  | Text style. |
| `requiredColor` | `Color?` |  |  | Required indicator color. |

### Members

| Member | Description |
|---|---|
| `VLabelStyle copyWith({Color? foregroundColor, TextStyle? textStyle, Color? requiredColor})` | Creates a copy with only the specified properties changed. |
