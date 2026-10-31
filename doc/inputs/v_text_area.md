# VTextArea

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VTextArea

Multi-line text input with label, helper text and optional character counter.

For a single line use VTextField.

**Basic Usage:**

```dart
VTextArea(
  label: 'Content',
  placeholder: 'Enter content',
  onChanged: (value) {},
)
```

**With Line Limits:**

```dart
VTextArea(
  label: 'Memo',
  minLines: 3,
  maxLines: 10,
  maxLength: 500,
  showCounter: true,
)
```

See also:
- [VTextField] - Single-line text input

### Constructors

#### `VTextArea`

Creates a text area.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `controller` | `TextEditingController?` |  |  | Controller for the text; the field creates one when null. |
| `focusNode` | `FocusNode?` |  |  | Focus node; the field creates one when null. |
| `label` | `String?` |  |  | Label text shown above the field. |
| `more` | `String?` |  |  | Note shown at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Widget shown next to the label, typically a help icon. |
| `placeholder` | `String?` |  |  | Hint text shown while the field is empty. |
| `helper` | `String?` |  |  | Helper text shown below the field. |
| `error` | `bool` | `false` |  | Whether the field shows [errorText] and the error border. |
| `errorText` | `String?` |  |  | Error message, shown when [error] is true. |
| `success` | `bool` | `false` |  | Whether the field shows [successText] and the success border. |
| `successText` | `String?` |  |  | Success message, shown when [success] is true. |
| `extra` | `String?` |  |  | Note that stays visible below the message. |
| `minLines` | `int` | `3` |  | Minimum number of lines. |
| `maxLines` | `int?` |  |  | Maximum number of lines (null for unlimited). |
| `maxLength` | `int?` |  |  | Maximum character count. |
| `showCounter` | `bool` | `false` |  | Whether to show a `current/max` counter below the field. |
| `enabled` | `bool` | `true` |  | Whether the text area accepts input. When false it is dimmed and ignores taps. |
| `readOnly` | `bool` | `false` |  | Whether the text can be selected but not edited. |
| `fullWidth` | `bool` | `false` |  | Whether the field stretches to the available width. |
| `required` | `bool` | `false` |  | Whether to show [requiredMark] after the label. |
| `requiredMark` | `String` | `'*'` |  | Character shown after the label when [required] is true. |
| `onChanged` | `void Function(String)?` |  |  | Called with the new text on every edit. |
| `onSubmitted` | `void Function(String)?` |  |  | Called with the text when the user submits. |
| `semanticLabel` | `String?` |  |  | Accessibility label. |
| `style` | `VTextAreaStyle?` |  |  | Style override. |

## VTextAreaStyle

Style override for [VTextArea].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VTextAreaStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `focusBorderColor` | `Color?` |  |  | Border color when focused. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `textStyle` | `TextStyle?` |  |  | Input text style. |
| `hintStyle` | `TextStyle?` |  |  | Hint text style. |

### Members

| Member | Description |
|---|---|
| `VTextAreaStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, Color? focusBorderColor, BorderRadius? borderRadius, EdgeInsets? padding, TextStyle? textStyle, TextStyle? hintStyle})` | Creates a copy with only the specified properties changed. |
