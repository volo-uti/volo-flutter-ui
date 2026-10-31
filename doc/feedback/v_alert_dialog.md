# VAlertDialog

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VAlertDialog

Modal dialog that asks the user to confirm or cancel before going on.

Unlike [VDialog], a tap on the barrier does not close it unless
`barrierDismissible` is set. Both buttons close the dialog after calling
their callback.

```dart
VAlertDialog.show<void>(
  context,
  title: const Text('Delete item'),
  description: const Text('This cannot be undone.'),
  confirmText: 'Delete',
  cancelText: 'Cancel',
  destructive: true,
  onConfirm: deleteItem,
);
```

### Constructors

#### `VAlertDialog`

Creates an alert dialog; use [show] to display it in a route.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `description` | `Widget` |  | yes | Message body of the dialog. |
| `title` | `Widget?` |  |  | Heading shown above [description], in the large title style. |
| `cancelText` | `String?` |  |  | Label of the cancel button; no cancel button is shown when null. |
| `confirmText` | `String?` |  |  | Label of the confirm button; defaults to "OK". |
| `onCancel` | `void Function()?` |  |  | Called when the cancel button is pressed, right after the dialog closes.<br>The dialog is popped first, so a callback may push another route or open another dialog without that route being popped in its place. |
| `onConfirm` | `void Function()?` |  |  | Called when the confirm button is pressed, right after the dialog closes.<br>The dialog is popped first, so a callback may push another route or open another dialog without that route being popped in its place. |
| `destructive` | `bool` | `false` |  | Whether the confirm button uses the destructive color. |
| `style` | `VAlertDialogStyle?` |  |  | Style override. |

### Members

| Member | Description |
|---|---|
| `static Future<T?> show<T>(BuildContext context, {required Widget description, Widget? title, String? cancelText, String? confirmText, void Function()? onCancel, void Function()? onConfirm, bool destructive = false, bool barrierDismissible = false})` | Shows an alert dialog above the current route.<br>Returns a future that completes when the dialog closes. When [barrierDismissible] is true a barrier tap closes it. |
| `static void close<T>(BuildContext context, [T? result])` | Closes the topmost route, returning [result] to the [show] future. |

## VAlertDialogStyle

Style override for [VAlertDialog].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VAlertDialogStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `elevation` | `double?` |  |  | Elevation (shadow depth). |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `titleStyle` | `TextStyle?` |  |  | Title text style. |

### Members

| Member | Description |
|---|---|
| `VAlertDialogStyle copyWith({Color? backgroundColor, Color? foregroundColor, BorderRadius? borderRadius, double? elevation, EdgeInsets? padding, TextStyle? titleStyle})` | Creates a copy with only the specified properties changed. |
