# VNumberStepper

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VNumberStepper

Plus and minus buttons around a whole number.

The buttons step it within a range, and the widget keeps no value of its
own: [onChanged] reports `value ± step`,
clamped to [min] and [max], and the parent passes it back as [value]. A
button turns off at its end of the range. Screen readers see one node with
the value and increase and decrease actions.

```dart
VNumberStepper(
  value: quantity,
  min: 1,
  max: 9,
  semanticLabel: 'Quantity',
  onChanged: (v) => setState(() => quantity = v),
)
```

Inside a form, draw it from a [VFormValueField] to validate and save it.

### Constructors

#### `VNumberStepper`

Creates a number stepper.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `int` |  | yes | Current value. |
| `onChanged` | `void Function(int)?` |  | yes | Called with the new value; `null` turns both buttons off. |
| `min` | `int` | `0` |  | Smallest value; the minus button turns off at it. |
| `max` | `int?` |  |  | Largest value, or `null` for no limit; the plus button turns off at it. |
| `step` | `int` | `1` |  | Amount one press adds or takes away. |
| `enabled` | `bool` | `true` |  | Whether the buttons react; false turns both off. |
| `size` | `VNumberStepperSize` | `VNumberStepperSize.md` |  | Size of both buttons. |
| `semanticLabel` | `String?` |  |  | Label screen readers announce with the value, such as 'Quantity'. |
| `style` | `VNumberStepperStyle?` |  |  | Style override merged over the theme's [VNumberStepperStyle]. |

## VNumberStepperSize

Number stepper size; it sets the size of both buttons.

### Values

| Value | Description |
|---|---|
| `xs` | Extra small. |
| `sm` | Small. |
| `md` | Medium. |
| `lg` | Large. |
| `xl` | Extra large. |

## VNumberStepperStyle

Style override for [VNumberStepper].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VNumberStepperStyle`

Creates a number stepper style.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `textStyle` | `TextStyle?` |  |  | Text style of the value. |
| `foregroundColor` | `Color?` |  |  | Color of the value text. |
| `spacing` | `double?` |  |  | Gap between each button and the value. |
| `valueMinWidth` | `double?` |  |  | Minimum width of the value, so the buttons stay put as the digits change. |
| `buttonStyle` | `VIconButtonStyle?` |  |  | Style passed to both buttons. |

### Members

| Member | Description |
|---|---|
| `VNumberStepperStyle copyWith({TextStyle? textStyle, Color? foregroundColor, double? spacing, double? valueMinWidth, VIconButtonStyle? buttonStyle})` | Creates a copy with only the specified properties changed. |
