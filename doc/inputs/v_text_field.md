# VTextField

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VTextField

Single-line text input with label, helper text, validation and built-in variants.

For several lines use VTextArea.

**Basic Usage:**

```dart
VTextField(
  name: 'email',
  label: 'Email',
  placeholder: 'example@email.com',
  onChanged: (value) {},
)
```

**Variants:**

- [VTextField] - Default text field
- [VTextField.email] - Email input (keyboard optimized)
- [VTextField.password] - Password input (show/hide toggle)
- [VTextField.search] - Search input (search icon, clear button)
- [VTextField.number] - Number input (numeric keyboard)
- [VTextField.phone] - Phone number input (phone keyboard)
- [VTextField.url] - URL input (URL keyboard)

**Password Field:**

```dart
VTextField.password(
  name: 'password',
  label: 'Password',
  placeholder: 'Enter your password',
)
```

### Constructors

#### `VTextField`

Default text field.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `name` | `String` |  | yes | Name that identifies the field within its form and in debug logs. |
| `value` | `String` | `''` |  | Initial text, ignored when [controller] is given. |
| `controller` | `TextEditingController?` |  |  | Controller for the text; the field creates one when null. |
| `focusNode` | `FocusNode?` |  |  | Focus node; the field creates one when null. |
| `onChanged` | `void Function(String)?` |  |  | Called with the new text on every edit. |
| `onSaved` | `void Function(String?)?` |  |  | Called with the text when the enclosing [VForm] saves. |
| `onSubmitted` | `void Function(String)?` |  |  | Called with the text when the user submits. |
| `label` | `String?` |  |  | Label text shown above the field. |
| `more` | `String?` |  |  | Note shown at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Widget shown next to the label, typically a help icon. |
| `placeholder` | `String?` |  |  | Hint text shown while the field is empty. |
| `helper` | `String?` |  |  | Helper text shown below the field. |
| `error` | `bool` | `false` |  | Whether the field shows the error border and [errorText]. |
| `errorText` | `String?` |  |  | Error message, shown when [error] is true or [validator] fails. |
| `success` | `bool` | `false` |  | Whether the field shows the success border and [successText]. |
| `successText` | `String?` |  |  | Success message, shown when [success] is true. |
| `extra` | `String?` |  |  | Note that stays visible below the message. |
| `leading` | `Widget?` |  |  | Widget shown before the text. |
| `suffix` | `String?` |  |  | Text shown after the input, such as a unit. |
| `trailing` | `Widget?` |  |  | Widget shown after the input and its built-in buttons. |
| `type` | `VFormBodyType` | `VFormBodyType.outlined` |  | Visual type: outlined, filled or underline. |
| `color` | `VFormBodyColor` | `VFormBodyColor.primary` |  | Accent color used for focus and borders. |
| `size` | `VFormBodySize` | `VFormBodySize.md` |  | Height preset. |
| `corner` | `VFormBodyCorner` | `VFormBodyCorner.rounded` |  | Corner shape. |
| `fullWidth` | `bool` | `false` |  | Whether the field stretches to the available width. |
| `clearable` | `bool` | `false` |  | Whether a clear button appears while the field has text. |
| `autofocus` | `bool` | `false` |  | Whether the field takes focus when first built. |
| `maxLength` | `int?` |  |  | Maximum number of characters; also shows a `current/max` counter. |
| `enabled` | `bool` | `true` |  | Whether the field accepts input. When false it is dimmed and ignores taps. |
| `readOnly` | `bool` | `false` |  | Whether the text can be selected but not edited. |
| `loading` | `bool` | `false` |  | Whether a spinner is shown in the trailing area. |
| `required` | `bool` | `false` |  | Whether to show [requiredMark] after the label. |
| `requiredMark` | `String` | `'*'` |  | Character shown after the label when [required] is true. |
| `floatingLabel` | `bool` | `false` |  | Whether the label floats over the top edge of the field. |
| `validator` | `String? Function(String?)?` |  |  | Returns an error message for invalid text, or null; run by the enclosing [VForm]. |
| `inputFormatters` | `List<TextInputFormatter>?` |  |  | Formatters applied to the text as the user types. |
| `textInputAction` | `TextInputAction?` |  |  | Action button shown on the software keyboard. |
| `obscureText` | `bool` | `false` |  | Whether the text is hidden, as for passwords. |
| `keyboardType` | `TextInputType?` |  |  | Keyboard layout to request. |
| `semanticLabel` | `String?` |  |  | Accessibility label. |
| `style` | `VTextFieldStyle?` |  |  | Style override. |

#### `VTextField.email`

Email input field.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `name` | `String` |  | yes | Name that identifies the field within its form and in debug logs. |
| `value` | `String` | `''` |  | Initial text, ignored when [controller] is given. |
| `controller` | `TextEditingController?` |  |  | Controller for the text; the field creates one when null. |
| `focusNode` | `FocusNode?` |  |  | Focus node; the field creates one when null. |
| `onChanged` | `void Function(String)?` |  |  | Called with the new text on every edit. |
| `onSaved` | `void Function(String?)?` |  |  | Called with the text when the enclosing [VForm] saves. |
| `onSubmitted` | `void Function(String)?` |  |  | Called with the text when the user submits. |
| `label` | `String?` |  |  | Label text shown above the field. |
| `more` | `String?` |  |  | Note shown at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Widget shown next to the label, typically a help icon. |
| `placeholder` | `String?` |  |  | Hint text shown while the field is empty. |
| `helper` | `String?` |  |  | Helper text shown below the field. |
| `error` | `bool` | `false` |  | Whether the field shows the error border and [errorText]. |
| `errorText` | `String?` |  |  | Error message, shown when [error] is true or [validator] fails. |
| `success` | `bool` | `false` |  | Whether the field shows the success border and [successText]. |
| `successText` | `String?` |  |  | Success message, shown when [success] is true. |
| `extra` | `String?` |  |  | Note that stays visible below the message. |
| `leading` | `Widget?` |  |  | Widget shown before the text. |
| `suffix` | `String?` |  |  | Text shown after the input, such as a unit. |
| `trailing` | `Widget?` |  |  | Widget shown after the input and its built-in buttons. |
| `type` | `VFormBodyType` | `VFormBodyType.outlined` |  | Visual type: outlined, filled or underline. |
| `color` | `VFormBodyColor` | `VFormBodyColor.primary` |  | Accent color used for focus and borders. |
| `size` | `VFormBodySize` | `VFormBodySize.md` |  | Height preset. |
| `corner` | `VFormBodyCorner` | `VFormBodyCorner.rounded` |  | Corner shape. |
| `fullWidth` | `bool` | `false` |  | Whether the field stretches to the available width. |
| `clearable` | `bool` | `false` |  | Whether a clear button appears while the field has text. |
| `autofocus` | `bool` | `false` |  | Whether the field takes focus when first built. |
| `maxLength` | `int?` |  |  | Maximum number of characters; also shows a `current/max` counter. |
| `enabled` | `bool` | `true` |  | Whether the field accepts input. When false it is dimmed and ignores taps. |
| `readOnly` | `bool` | `false` |  | Whether the text can be selected but not edited. |
| `loading` | `bool` | `false` |  | Whether a spinner is shown in the trailing area. |
| `required` | `bool` | `false` |  | Whether to show [requiredMark] after the label. |
| `requiredMark` | `String` | `'*'` |  | Character shown after the label when [required] is true. |
| `floatingLabel` | `bool` | `false` |  | Whether the label floats over the top edge of the field. |
| `validator` | `String? Function(String?)?` |  |  | Returns an error message for invalid text, or null; run by the enclosing [VForm]. |
| `inputFormatters` | `List<TextInputFormatter>?` |  |  | Formatters applied to the text as the user types. |
| `textInputAction` | `TextInputAction?` |  |  | Action button shown on the software keyboard. |
| `semanticLabel` | `String?` |  |  | Accessibility label. |
| `style` | `VTextFieldStyle?` |  |  | Style override. |

#### `VTextField.password`

Password input field.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `name` | `String` |  | yes | Name that identifies the field within its form and in debug logs. |
| `value` | `String` | `''` |  | Initial text, ignored when [controller] is given. |
| `controller` | `TextEditingController?` |  |  | Controller for the text; the field creates one when null. |
| `focusNode` | `FocusNode?` |  |  | Focus node; the field creates one when null. |
| `onChanged` | `void Function(String)?` |  |  | Called with the new text on every edit. |
| `onSaved` | `void Function(String?)?` |  |  | Called with the text when the enclosing [VForm] saves. |
| `onSubmitted` | `void Function(String)?` |  |  | Called with the text when the user submits. |
| `label` | `String?` |  |  | Label text shown above the field. |
| `more` | `String?` |  |  | Note shown at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Widget shown next to the label, typically a help icon. |
| `placeholder` | `String?` |  |  | Hint text shown while the field is empty. |
| `helper` | `String?` |  |  | Helper text shown below the field. |
| `error` | `bool` | `false` |  | Whether the field shows the error border and [errorText]. |
| `errorText` | `String?` |  |  | Error message, shown when [error] is true or [validator] fails. |
| `success` | `bool` | `false` |  | Whether the field shows the success border and [successText]. |
| `successText` | `String?` |  |  | Success message, shown when [success] is true. |
| `extra` | `String?` |  |  | Note that stays visible below the message. |
| `leading` | `Widget?` |  |  | Widget shown before the text. |
| `suffix` | `String?` |  |  | Text shown after the input, such as a unit. |
| `trailing` | `Widget?` |  |  | Widget shown after the input and its built-in buttons. |
| `type` | `VFormBodyType` | `VFormBodyType.outlined` |  | Visual type: outlined, filled or underline. |
| `color` | `VFormBodyColor` | `VFormBodyColor.primary` |  | Accent color used for focus and borders. |
| `size` | `VFormBodySize` | `VFormBodySize.md` |  | Height preset. |
| `corner` | `VFormBodyCorner` | `VFormBodyCorner.rounded` |  | Corner shape. |
| `fullWidth` | `bool` | `false` |  | Whether the field stretches to the available width. |
| `clearable` | `bool` | `false` |  | Whether a clear button appears while the field has text. |
| `autofocus` | `bool` | `false` |  | Whether the field takes focus when first built. |
| `maxLength` | `int?` |  |  | Maximum number of characters; also shows a `current/max` counter. |
| `enabled` | `bool` | `true` |  | Whether the field accepts input. When false it is dimmed and ignores taps. |
| `readOnly` | `bool` | `false` |  | Whether the text can be selected but not edited. |
| `loading` | `bool` | `false` |  | Whether a spinner is shown in the trailing area. |
| `required` | `bool` | `false` |  | Whether to show [requiredMark] after the label. |
| `requiredMark` | `String` | `'*'` |  | Character shown after the label when [required] is true. |
| `floatingLabel` | `bool` | `false` |  | Whether the label floats over the top edge of the field. |
| `validator` | `String? Function(String?)?` |  |  | Returns an error message for invalid text, or null; run by the enclosing [VForm]. |
| `inputFormatters` | `List<TextInputFormatter>?` |  |  | Formatters applied to the text as the user types. |
| `textInputAction` | `TextInputAction?` |  |  | Action button shown on the software keyboard. |
| `semanticLabel` | `String?` |  |  | Accessibility label. |
| `style` | `VTextFieldStyle?` |  |  | Style override. |

#### `VTextField.search`

Search input field.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `name` | `String` |  | yes | Name that identifies the field within its form and in debug logs. |
| `value` | `String` | `''` |  | Initial text, ignored when [controller] is given. |
| `controller` | `TextEditingController?` |  |  | Controller for the text; the field creates one when null. |
| `focusNode` | `FocusNode?` |  |  | Focus node; the field creates one when null. |
| `onChanged` | `void Function(String)?` |  |  | Called with the new text on every edit. |
| `onSaved` | `void Function(String?)?` |  |  | Called with the text when the enclosing [VForm] saves. |
| `onSubmitted` | `void Function(String)?` |  |  | Called with the text when the user submits. |
| `label` | `String?` |  |  | Label text shown above the field. |
| `more` | `String?` |  |  | Note shown at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Widget shown next to the label, typically a help icon. |
| `placeholder` | `String?` |  |  | Hint text shown while the field is empty. |
| `helper` | `String?` |  |  | Helper text shown below the field. |
| `error` | `bool` | `false` |  | Whether the field shows the error border and [errorText]. |
| `errorText` | `String?` |  |  | Error message, shown when [error] is true or [validator] fails. |
| `success` | `bool` | `false` |  | Whether the field shows the success border and [successText]. |
| `successText` | `String?` |  |  | Success message, shown when [success] is true. |
| `extra` | `String?` |  |  | Note that stays visible below the message. |
| `leading` | `Widget?` |  |  | Widget shown before the text. |
| `suffix` | `String?` |  |  | Text shown after the input, such as a unit. |
| `trailing` | `Widget?` |  |  | Widget shown after the input and its built-in buttons. |
| `type` | `VFormBodyType` | `VFormBodyType.outlined` |  | Visual type: outlined, filled or underline. |
| `color` | `VFormBodyColor` | `VFormBodyColor.primary` |  | Accent color used for focus and borders. |
| `size` | `VFormBodySize` | `VFormBodySize.md` |  | Height preset. |
| `corner` | `VFormBodyCorner` | `VFormBodyCorner.rounded` |  | Corner shape. |
| `fullWidth` | `bool` | `false` |  | Whether the field stretches to the available width. |
| `clearable` | `bool` | `false` |  | Whether a clear button appears while the field has text. |
| `autofocus` | `bool` | `false` |  | Whether the field takes focus when first built. |
| `maxLength` | `int?` |  |  | Maximum number of characters; also shows a `current/max` counter. |
| `enabled` | `bool` | `true` |  | Whether the field accepts input. When false it is dimmed and ignores taps. |
| `readOnly` | `bool` | `false` |  | Whether the text can be selected but not edited. |
| `loading` | `bool` | `false` |  | Whether a spinner is shown in the trailing area. |
| `required` | `bool` | `false` |  | Whether to show [requiredMark] after the label. |
| `requiredMark` | `String` | `'*'` |  | Character shown after the label when [required] is true. |
| `floatingLabel` | `bool` | `false` |  | Whether the label floats over the top edge of the field. |
| `validator` | `String? Function(String?)?` |  |  | Returns an error message for invalid text, or null; run by the enclosing [VForm]. |
| `inputFormatters` | `List<TextInputFormatter>?` |  |  | Formatters applied to the text as the user types. |
| `textInputAction` | `TextInputAction?` | `TextInputAction.search` |  | Action button shown on the software keyboard. |
| `semanticLabel` | `String?` |  |  | Accessibility label. |
| `style` | `VTextFieldStyle?` |  |  | Style override. |

#### `VTextField.number`

Number input field.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `name` | `String` |  | yes | Name that identifies the field within its form and in debug logs. |
| `value` | `String` | `''` |  | Initial text, ignored when [controller] is given. |
| `controller` | `TextEditingController?` |  |  | Controller for the text; the field creates one when null. |
| `focusNode` | `FocusNode?` |  |  | Focus node; the field creates one when null. |
| `onChanged` | `void Function(String)?` |  |  | Called with the new text on every edit. |
| `onSaved` | `void Function(String?)?` |  |  | Called with the text when the enclosing [VForm] saves. |
| `onSubmitted` | `void Function(String)?` |  |  | Called with the text when the user submits. |
| `label` | `String?` |  |  | Label text shown above the field. |
| `more` | `String?` |  |  | Note shown at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Widget shown next to the label, typically a help icon. |
| `placeholder` | `String?` |  |  | Hint text shown while the field is empty. |
| `helper` | `String?` |  |  | Helper text shown below the field. |
| `error` | `bool` | `false` |  | Whether the field shows the error border and [errorText]. |
| `errorText` | `String?` |  |  | Error message, shown when [error] is true or [validator] fails. |
| `success` | `bool` | `false` |  | Whether the field shows the success border and [successText]. |
| `successText` | `String?` |  |  | Success message, shown when [success] is true. |
| `extra` | `String?` |  |  | Note that stays visible below the message. |
| `leading` | `Widget?` |  |  | Widget shown before the text. |
| `suffix` | `String?` |  |  | Text shown after the input, such as a unit. |
| `trailing` | `Widget?` |  |  | Widget shown after the input and its built-in buttons. |
| `type` | `VFormBodyType` | `VFormBodyType.outlined` |  | Visual type: outlined, filled or underline. |
| `color` | `VFormBodyColor` | `VFormBodyColor.primary` |  | Accent color used for focus and borders. |
| `size` | `VFormBodySize` | `VFormBodySize.md` |  | Height preset. |
| `corner` | `VFormBodyCorner` | `VFormBodyCorner.rounded` |  | Corner shape. |
| `fullWidth` | `bool` | `false` |  | Whether the field stretches to the available width. |
| `clearable` | `bool` | `false` |  | Whether a clear button appears while the field has text. |
| `autofocus` | `bool` | `false` |  | Whether the field takes focus when first built. |
| `maxLength` | `int?` |  |  | Maximum number of characters; also shows a `current/max` counter. |
| `enabled` | `bool` | `true` |  | Whether the field accepts input. When false it is dimmed and ignores taps. |
| `readOnly` | `bool` | `false` |  | Whether the text can be selected but not edited. |
| `loading` | `bool` | `false` |  | Whether a spinner is shown in the trailing area. |
| `required` | `bool` | `false` |  | Whether to show [requiredMark] after the label. |
| `requiredMark` | `String` | `'*'` |  | Character shown after the label when [required] is true. |
| `floatingLabel` | `bool` | `false` |  | Whether the label floats over the top edge of the field. |
| `validator` | `String? Function(String?)?` |  |  | Returns an error message for invalid text, or null; run by the enclosing [VForm]. |
| `inputFormatters` | `List<TextInputFormatter>?` |  |  | Formatters applied to the text as the user types. |
| `textInputAction` | `TextInputAction?` |  |  | Action button shown on the software keyboard. |
| `semanticLabel` | `String?` |  |  | Accessibility label. |
| `style` | `VTextFieldStyle?` |  |  | Style override. |

#### `VTextField.phone`

Phone number input field.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `name` | `String` |  | yes | Name that identifies the field within its form and in debug logs. |
| `value` | `String` | `''` |  | Initial text, ignored when [controller] is given. |
| `controller` | `TextEditingController?` |  |  | Controller for the text; the field creates one when null. |
| `focusNode` | `FocusNode?` |  |  | Focus node; the field creates one when null. |
| `onChanged` | `void Function(String)?` |  |  | Called with the new text on every edit. |
| `onSaved` | `void Function(String?)?` |  |  | Called with the text when the enclosing [VForm] saves. |
| `onSubmitted` | `void Function(String)?` |  |  | Called with the text when the user submits. |
| `label` | `String?` |  |  | Label text shown above the field. |
| `more` | `String?` |  |  | Note shown at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Widget shown next to the label, typically a help icon. |
| `placeholder` | `String?` |  |  | Hint text shown while the field is empty. |
| `helper` | `String?` |  |  | Helper text shown below the field. |
| `error` | `bool` | `false` |  | Whether the field shows the error border and [errorText]. |
| `errorText` | `String?` |  |  | Error message, shown when [error] is true or [validator] fails. |
| `success` | `bool` | `false` |  | Whether the field shows the success border and [successText]. |
| `successText` | `String?` |  |  | Success message, shown when [success] is true. |
| `extra` | `String?` |  |  | Note that stays visible below the message. |
| `leading` | `Widget?` |  |  | Widget shown before the text. |
| `suffix` | `String?` |  |  | Text shown after the input, such as a unit. |
| `trailing` | `Widget?` |  |  | Widget shown after the input and its built-in buttons. |
| `type` | `VFormBodyType` | `VFormBodyType.outlined` |  | Visual type: outlined, filled or underline. |
| `color` | `VFormBodyColor` | `VFormBodyColor.primary` |  | Accent color used for focus and borders. |
| `size` | `VFormBodySize` | `VFormBodySize.md` |  | Height preset. |
| `corner` | `VFormBodyCorner` | `VFormBodyCorner.rounded` |  | Corner shape. |
| `fullWidth` | `bool` | `false` |  | Whether the field stretches to the available width. |
| `clearable` | `bool` | `false` |  | Whether a clear button appears while the field has text. |
| `autofocus` | `bool` | `false` |  | Whether the field takes focus when first built. |
| `maxLength` | `int?` |  |  | Maximum number of characters; also shows a `current/max` counter. |
| `enabled` | `bool` | `true` |  | Whether the field accepts input. When false it is dimmed and ignores taps. |
| `readOnly` | `bool` | `false` |  | Whether the text can be selected but not edited. |
| `loading` | `bool` | `false` |  | Whether a spinner is shown in the trailing area. |
| `required` | `bool` | `false` |  | Whether to show [requiredMark] after the label. |
| `requiredMark` | `String` | `'*'` |  | Character shown after the label when [required] is true. |
| `floatingLabel` | `bool` | `false` |  | Whether the label floats over the top edge of the field. |
| `validator` | `String? Function(String?)?` |  |  | Returns an error message for invalid text, or null; run by the enclosing [VForm]. |
| `inputFormatters` | `List<TextInputFormatter>?` |  |  | Formatters applied to the text as the user types. |
| `textInputAction` | `TextInputAction?` |  |  | Action button shown on the software keyboard. |
| `semanticLabel` | `String?` |  |  | Accessibility label. |
| `style` | `VTextFieldStyle?` |  |  | Style override. |

#### `VTextField.url`

URL input field.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `name` | `String` |  | yes | Name that identifies the field within its form and in debug logs. |
| `value` | `String` | `''` |  | Initial text, ignored when [controller] is given. |
| `controller` | `TextEditingController?` |  |  | Controller for the text; the field creates one when null. |
| `focusNode` | `FocusNode?` |  |  | Focus node; the field creates one when null. |
| `onChanged` | `void Function(String)?` |  |  | Called with the new text on every edit. |
| `onSaved` | `void Function(String?)?` |  |  | Called with the text when the enclosing [VForm] saves. |
| `onSubmitted` | `void Function(String)?` |  |  | Called with the text when the user submits. |
| `label` | `String?` |  |  | Label text shown above the field. |
| `more` | `String?` |  |  | Note shown at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Widget shown next to the label, typically a help icon. |
| `placeholder` | `String?` |  |  | Hint text shown while the field is empty. |
| `helper` | `String?` |  |  | Helper text shown below the field. |
| `error` | `bool` | `false` |  | Whether the field shows the error border and [errorText]. |
| `errorText` | `String?` |  |  | Error message, shown when [error] is true or [validator] fails. |
| `success` | `bool` | `false` |  | Whether the field shows the success border and [successText]. |
| `successText` | `String?` |  |  | Success message, shown when [success] is true. |
| `extra` | `String?` |  |  | Note that stays visible below the message. |
| `leading` | `Widget?` |  |  | Widget shown before the text. |
| `suffix` | `String?` |  |  | Text shown after the input, such as a unit. |
| `trailing` | `Widget?` |  |  | Widget shown after the input and its built-in buttons. |
| `type` | `VFormBodyType` | `VFormBodyType.outlined` |  | Visual type: outlined, filled or underline. |
| `color` | `VFormBodyColor` | `VFormBodyColor.primary` |  | Accent color used for focus and borders. |
| `size` | `VFormBodySize` | `VFormBodySize.md` |  | Height preset. |
| `corner` | `VFormBodyCorner` | `VFormBodyCorner.rounded` |  | Corner shape. |
| `fullWidth` | `bool` | `false` |  | Whether the field stretches to the available width. |
| `clearable` | `bool` | `false` |  | Whether a clear button appears while the field has text. |
| `autofocus` | `bool` | `false` |  | Whether the field takes focus when first built. |
| `maxLength` | `int?` |  |  | Maximum number of characters; also shows a `current/max` counter. |
| `enabled` | `bool` | `true` |  | Whether the field accepts input. When false it is dimmed and ignores taps. |
| `readOnly` | `bool` | `false` |  | Whether the text can be selected but not edited. |
| `loading` | `bool` | `false` |  | Whether a spinner is shown in the trailing area. |
| `required` | `bool` | `false` |  | Whether to show [requiredMark] after the label. |
| `requiredMark` | `String` | `'*'` |  | Character shown after the label when [required] is true. |
| `floatingLabel` | `bool` | `false` |  | Whether the label floats over the top edge of the field. |
| `validator` | `String? Function(String?)?` |  |  | Returns an error message for invalid text, or null; run by the enclosing [VForm]. |
| `inputFormatters` | `List<TextInputFormatter>?` |  |  | Formatters applied to the text as the user types. |
| `textInputAction` | `TextInputAction?` |  |  | Action button shown on the software keyboard. |
| `semanticLabel` | `String?` |  |  | Accessibility label. |
| `style` | `VTextFieldStyle?` |  |  | Style override. |

## VTextFieldStyle

Style override for [VTextField].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VTextFieldStyle`

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
| `labelStyle` | `TextStyle?` |  |  | Label text style. |
| `cursorColor` | `Color?` |  |  | Cursor color. |

### Members

| Member | Description |
|---|---|
| `VTextFieldStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, Color? focusBorderColor, BorderRadius? borderRadius, EdgeInsets? padding, TextStyle? textStyle, TextStyle? hintStyle, TextStyle? labelStyle, Color? cursorColor})` | Creates a copy with only the specified properties changed. |
