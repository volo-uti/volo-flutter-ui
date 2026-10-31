# VForm

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VForm

Vertical stack of form fields that validates and saves them together.

Wraps Flutter's [Form] with spacing and focus traversal.

**Basic Usage:**

```dart
final formKey = GlobalKey<FormState>();

VForm(
  formKey: formKey,
  children: [
    VTextField(name: 'name', label: 'Name'),
    VTextField.email(name: 'email', label: 'Email'),
  ],
)
```

**With Validation:**

```dart
VForm(
  autoValidateMode: VFormAutoValidateMode.onUserInteraction,
  children: [
    VTextField.email(
      name: 'email',
      label: 'Email',
      required: true,
      validator: (v) => (v ?? '').contains('@') ? null : 'Invalid email',
    ),
  ],
)
```

See also:

- [VFormField] - Form field wrapper with label, input, and footer.
- [VFormBody] - Input body area.

### Constructors

#### `VForm`

Creates a form wrapper.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Fields and other widgets stacked vertically. |
| `formKey` | `GlobalKey<FormState>?` |  |  | Key to call `validate()`, `save()` or `reset()` on; the form keeps its own when null. |
| `onChanged` | `void Function()?` |  |  | Called when any field in the form changes. |
| `autoValidateMode` | `VFormAutoValidateMode` | `VFormAutoValidateMode.disabled` |  | When fields validate themselves without an explicit submit. |
| `spacing` | `double?` |  |  | Gap between children; defaults to the theme's large spacing. |
| `style` | `VFormStyle?` |  |  | Style override. |

## VFormAutoValidateMode

When the fields of a [VForm] validate themselves.

### Values

| Value | Description |
|---|---|
| `disabled` | No automatic validation. |
| `always` | Validate on every change. |
| `onUserInteraction` | Validate on user interaction. |

## VFormStyle

Style override for [VForm].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VFormStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `spacing` | `double?` |  |  | Spacing between form fields. |

### Members

| Member | Description |
|---|---|
| `VFormStyle copyWith({double? spacing})` | Creates a copy with only the specified properties changed. |
