# VFormFooter

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VFormFooter

Message row below a form control: helper, error or success text plus a counter.

[VFormField] builds one for you; use it directly only to annotate a custom control.

**Basic Usage:**

```dart
VFormFooter(
  helper: 'Enter your email',
  child: VFormBody(...),
)
```

**With Counter:**

```dart
VFormFooter(
  maxLength: 100,
  currentLength: text.length,
  child: VFormBody(...),
)
```

See also:
- [VFormField] - Header + Body + Footer composition

### Constructors

#### `VFormFooter`

Creates a form footer.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | The control the footer belongs to. |
| `helper` | `String?` |  |  | Helper text shown when no error or success message is active. |
| `error` | `bool` | `false` |  | Whether to show [errorText] in the destructive color. |
| `errorText` | `String?` |  |  | Error message, shown when [error] is true. |
| `success` | `bool` | `false` |  | Whether to show [successText] in the success color. |
| `successText` | `String?` |  |  | Success message, shown when [success] is true. |
| `extra` | `String?` |  |  | Note that stays visible below the message. |
| `counter` | `Widget?` |  |  | Replaces the generated `current/max` counter. |
| `maxLength` | `int?` |  |  | Character limit; when set, a `current/max` counter is generated. |
| `currentLength` | `int` | `0` |  | Characters entered so far, used by the generated counter. |
| `style` | `VFormFooterStyle?` |  |  | Style override merged over the theme's [VFormFooterStyle]. |

## VFormFooterStyle

Style override for [VFormFooter].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VFormFooterStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `padding` | `EdgeInsets?` |  |  | Padding around the message rows; defaults to a small gap above them. |
| `spacing` | `double?` |  |  | Gap above the extra note; defaults to the smallest spacing token. |
| `helperStyle` | `TextStyle?` |  |  | Text style of the helper text, merged over the label small type style.<br>Its color wins over the muted foreground color. |
| `errorStyle` | `TextStyle?` |  |  | Text style of the error text, merged over the label small type style.<br>Its color wins over the destructive color. |

### Members

| Member | Description |
|---|---|
| `VFormFooterStyle copyWith({EdgeInsets? padding, double? spacing, TextStyle? helperStyle, TextStyle? errorStyle})` | Creates a copy with only the specified properties changed. |
