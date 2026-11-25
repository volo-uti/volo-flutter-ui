# VFormField, VFormValueField

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VFormField

Wraps a control with a label above and helper or error text below.

Composes [VFormHeader], the control and [VFormFooter].

**Basic Usage:**

```dart
VFormField(
  label: 'Email',
  required: true,
  helper: 'Enter your company email',
  child: VFormBody(
    child: EditableText(...),
  ),
)
```

**With Error State:**

```dart
VFormField(
  label: 'Password',
  error: true,
  errorText: 'Must be at least 8 characters',
  child: VFormBody(...),
)
```

See also:
- [VTextField] - Single-line text input
- [VTextArea] - Multi-line text input

### Constructors

#### `VFormField`

Creates a form field.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | The control to wrap, usually a [VFormBody]. |
| `header` | `Widget?` |  |  | Replaces the generated [VFormHeader]. |
| `footer` | `Widget?` |  |  | Replaces the generated [VFormFooter]. |
| `label` | `String?` |  |  | Label text shown above the control. |
| `more` | `String?` |  |  | Note shown at the right end of the label row. |
| `required` | `bool` | `false` |  | Whether to show [requiredMark] after the label. |
| `requiredMark` | `String` | `'*'` |  | Character shown after the label when [required] is true. |
| `tooltip` | `Widget?` |  |  | Widget shown next to the label, typically a help icon. |
| `floatingLabel` | `bool` | `false` |  | Whether the label floats over the top edge of the control. |
| `helper` | `String?` |  |  | Helper text shown below the control. |
| `error` | `bool` | `false` |  | Whether to show [errorText] in the destructive color. |
| `errorText` | `String?` |  |  | Error message, shown when [error] is true. |
| `success` | `bool` | `false` |  | Whether to show [successText] in the success color. |
| `successText` | `String?` |  |  | Success message, shown when [success] is true. |
| `extra` | `String?` |  |  | Note that stays visible below the message. |
| `counter` | `Widget?` |  |  | Replaces the generated `current/max` counter. |
| `maxLength` | `int?` |  |  | Character limit; when set, a counter is shown. |
| `currentLength` | `int` | `0` |  | Characters entered so far, used by the generated counter. |
| `style` | `VFormFieldStyle?` |  |  | Style override merged over the theme's [VFormFieldStyle]. |

## VFormValueField

Form field that keeps its value in the enclosing form and shows its error.

Registers with the nearest [Form] (a [VForm] or a widgets `Form`), so
`validate`, `save` and `reset` on the form's state reach it. [builder]
draws the control from the field state: read `state.value` and call
`state.didChange` when the user changes it. The label row and the message
row come from [VFormField]; after a failed validation the message row shows
the [validator] text in place of [helper].

```dart
VFormValueField<int>(
  label: 'Guests',
  initialValue: 1,
  validator: (v) => (v ?? 0) < 1 ? 'Add at least one guest' : null,
  onSaved: (v) => guests = v,
  builder: (state) => VNumberStepper(
    value: state.value ?? 1,
    onChanged: state.didChange,
  ),
)
```

See also:
- [VFormField] - The same frame for a value kept outside a form
- [VForm] - Validates and saves its fields together

### Constructors

#### `VFormValueField`

Creates a form field that draws its control with [builder].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `builder` | `Widget Function(FormFieldState<T>)` |  | yes |  |
| `initialValue` | `T?` |  |  |  |
| `validator` | `String? Function(T?)?` |  |  |  |
| `onSaved` | `void Function(T?)?` |  |  |  |
| `enabled` | `bool` | `true` |  |  |
| `autovalidateMode` | `AutovalidateMode?` |  |  |  |
| `label` | `String?` |  |  |  |
| `more` | `String?` |  |  |  |
| `required` | `bool` | `false` |  |  |
| `requiredMark` | `String` | `'*'` |  |  |
| `tooltip` | `Widget?` |  |  |  |
| `floatingLabel` | `bool` | `false` |  |  |
| `helper` | `String?` |  |  |  |
| `extra` | `String?` |  |  |  |
| `style` | `VFormFieldStyle?` |  |  |  |

## VFormFieldStyle

Style override for [VFormField].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VFormFieldStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `labelStyle` | `TextStyle?` |  |  | Text style of the generated header's label.<br>Wins over the theme's `VFormHeaderStyle.titleStyle`. |
| `helperStyle` | `TextStyle?` |  |  | Text style of the generated footer's helper text.<br>Wins over the theme's `VFormFooterStyle.helperStyle`. |
| `errorStyle` | `TextStyle?` |  |  | Text style of the generated footer's error text.<br>Wins over the theme's `VFormFooterStyle.errorStyle`. |
| `spacing` | `double?` |  |  | Spacing between label, field, and helper/error. |

### Members

| Member | Description |
|---|---|
| `VFormFieldStyle copyWith({TextStyle? labelStyle, TextStyle? helperStyle, TextStyle? errorStyle, double? spacing})` | Creates a copy with only the specified properties changed. |
