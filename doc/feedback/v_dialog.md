# VDialog

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VDialog

Modal dialog with a title, content and a row of actions.

Built with [VDialog.alert] (one button), [VDialog.confirm] (cancel and
confirm) or [VDialog.custom] (your own actions), and shown with [show].
A tap on the barrier or Escape closes it while `barrierDismissible` is true.

```dart
VDialog.show<void>(
  context,
  VDialog.confirm(
    title: const Text('Delete item'),
    content: const Text('This action cannot be undone.'),
    confirmText: 'Delete',
    destructive: true,
    onConfirm: deleteItem,
  ),
);
```

See also:

 * [VAlertDialog], for a dialog that must be answered
 * [VAlert], for inline alert messages

### Constructors

#### `VDialog.alert`

Dialog with a single confirm button.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `content` | `Widget` |  | yes | Main body of the dialog. |
| `title` | `Widget?` |  |  | Heading shown above [content], in the large title style. |
| `confirmText` | `String?` |  |  | Label of the confirm button; defaults to the localized "Confirm". |
| `onConfirm` | `void Function()?` |  |  | Called when the confirm button is pressed, right after the dialog closes.<br>The dialog is popped first, so a callback may push another route or open another dialog without that route being popped in its place. |
| `barrierDismissible` | `bool` | `true` |  | Whether a barrier tap or Escape closes the dialog. |
| `barrierColor` | `Color?` |  |  | Barrier color; defaults to the theme's scrim color. |
| `actionsAlignment` | `VDialogActionsAlignment` | `VDialogActionsAlignment.end` |  | Horizontal alignment of the action row. |
| `actionsExpanded` | `bool` | `false` |  | Whether each action stretches to share the row width equally. |
| `semanticLabel` | `String?` |  |  | Screen reader name of the dialog route; defaults to "Dialog". |
| `style` | `VDialogStyle?` |  |  | Style override. |

#### `VDialog.confirm`

Dialog with cancel and confirm buttons.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `content` | `Widget` |  | yes | Main body of the dialog. |
| `title` | `Widget?` |  |  | Heading shown above [content], in the large title style. |
| `cancelText` | `String?` |  |  | Label of the cancel button; defaults to the localized "Cancel". |
| `confirmText` | `String?` |  |  | Label of the confirm button; defaults to the localized "Confirm". |
| `onCancel` | `void Function()?` |  |  | Called when the cancel button is pressed, right after the dialog closes.<br>The dialog is popped first, so a callback may push another route or open another dialog without that route being popped in its place. |
| `onConfirm` | `void Function()?` |  |  | Called when the confirm button is pressed, right after the dialog closes.<br>The dialog is popped first, so a callback may push another route or open another dialog without that route being popped in its place. |
| `destructive` | `bool` | `false` |  | Whether the confirm button uses the destructive color. |
| `barrierDismissible` | `bool` | `true` |  | Whether a barrier tap or Escape closes the dialog. |
| `barrierColor` | `Color?` |  |  | Barrier color; defaults to the theme's scrim color. |
| `actionsAlignment` | `VDialogActionsAlignment` | `VDialogActionsAlignment.end` |  | Horizontal alignment of the action row. |
| `actionsExpanded` | `bool` | `false` |  | Whether each action stretches to share the row width equally. |
| `semanticLabel` | `String?` |  |  | Screen reader name of the dialog route; defaults to "Dialog". |
| `style` | `VDialogStyle?` |  |  | Style override. |

#### `VDialog.custom`

Custom dialog.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `content` | `Widget` |  | yes | Main body of the dialog. |
| `title` | `Widget?` |  |  | Heading shown above [content], in the large title style. |
| `actions` | `List<Widget>?` |  |  | Buttons shown by [VDialog.custom], in order. |
| `barrierDismissible` | `bool` | `true` |  | Whether a barrier tap or Escape closes the dialog. |
| `barrierColor` | `Color?` |  |  | Barrier color; defaults to the theme's scrim color. |
| `actionsAlignment` | `VDialogActionsAlignment` | `VDialogActionsAlignment.end` |  | Horizontal alignment of the action row. |
| `actionsExpanded` | `bool` | `false` |  | Whether each action stretches to share the row width equally. |
| `semanticLabel` | `String?` |  |  | Screen reader name of the dialog route; defaults to "Dialog". |
| `style` | `VDialogStyle?` |  |  | Style override. |

### Members

| Member | Description |
|---|---|
| `static Future<T?> show<T>(BuildContext context, VDialog dialog)` | Shows [dialog] above the current route and returns its result. |
| `static void close<T>(BuildContext context, [T? result])` | Closes the topmost route, returning [result] to the [show] future. |

## VDialogActionsAlignment

Dialog button alignment.

### Values

| Value | Description |
|---|---|
| `start` | Left aligned. |
| `center` | Center aligned. |
| `end` | Right aligned (default). |

## VDialogStyle

Style override for [VDialog].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VDialogStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `shadows` | `List<BoxShadow>?` |  |  | Shadows around the dialog panel; the theme's large shadow when null.<br>An empty list draws no shadow. An instance style wins over the theme override. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `titleStyle` | `TextStyle?` |  |  | Title text style. |

### Members

| Member | Description |
|---|---|
| `VDialogStyle copyWith({Color? backgroundColor, Color? foregroundColor, BorderRadius? borderRadius, List<BoxShadow>? shadows, EdgeInsets? padding, TextStyle? titleStyle})` | Creates a copy with only the specified properties changed. |
