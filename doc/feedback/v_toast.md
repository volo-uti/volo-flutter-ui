# VToast

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VToast

Short message that floats at the top or bottom center of the screen.

Shown with [show]; a new toast replaces the visible one. It hides itself
after [duration] and can be swiped away while [dismissible] is true.

```dart
VToast.show(
  context,
  VToast.success(
    message: const Text('Upload complete'),
    semanticLabel: 'Upload complete',
    position: VToastPosition.top,
  ),
);
```

Types: [VToast] (neutral), [VToast.success], [VToast.error],
[VToast.warning] and [VToast.info]. [showSuccess], [showError],
[showWarning] and [showInfo] show a plain message in one call.

See also:

 * [VSnackbar], a full-width bar with a queue
 * [VAlert], an inline message

### Constructors

#### `VToast`

Default toast.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `message` | `Widget` |  | yes | Message shown in the toast, usually a [Text]. |
| `position` | `VToastPosition` | `VToastPosition.bottom` |  | Whether the toast sits at the top or the bottom of the screen. |
| `duration` | `Duration?` |  |  | How long the toast stays; defaults to [VAnimations.toast].<br>[Duration.zero] keeps it until [dismiss] is called. |
| `action` | `VToastAction?` |  |  | Text button shown after [message]. |
| `dismissible` | `bool` | `true` |  | Whether the toast can be swiped away. |
| `semanticLabel` | `String?` |  |  | Text announced by screen readers for the toast. |
| `style` | `VToastStyle?` |  |  | Style override. |

#### `VToast.success`

Success toast.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `message` | `Widget` |  | yes | Message shown in the toast, usually a [Text]. |
| `position` | `VToastPosition` | `VToastPosition.bottom` |  | Whether the toast sits at the top or the bottom of the screen. |
| `duration` | `Duration?` |  |  | How long the toast stays; defaults to [VAnimations.toast].<br>[Duration.zero] keeps it until [dismiss] is called. |
| `action` | `VToastAction?` |  |  | Text button shown after [message]. |
| `dismissible` | `bool` | `true` |  | Whether the toast can be swiped away. |
| `semanticLabel` | `String?` |  |  | Text announced by screen readers for the toast. |
| `style` | `VToastStyle?` |  |  | Style override. |

#### `VToast.error`

Error toast.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `message` | `Widget` |  | yes | Message shown in the toast, usually a [Text]. |
| `position` | `VToastPosition` | `VToastPosition.bottom` |  | Whether the toast sits at the top or the bottom of the screen. |
| `duration` | `Duration?` |  |  | How long the toast stays; defaults to [VAnimations.toast].<br>[Duration.zero] keeps it until [dismiss] is called. |
| `action` | `VToastAction?` |  |  | Text button shown after [message]. |
| `dismissible` | `bool` | `true` |  | Whether the toast can be swiped away. |
| `semanticLabel` | `String?` |  |  | Text announced by screen readers for the toast. |
| `style` | `VToastStyle?` |  |  | Style override. |

#### `VToast.warning`

Warning toast.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `message` | `Widget` |  | yes | Message shown in the toast, usually a [Text]. |
| `position` | `VToastPosition` | `VToastPosition.bottom` |  | Whether the toast sits at the top or the bottom of the screen. |
| `duration` | `Duration?` |  |  | How long the toast stays; defaults to [VAnimations.toast].<br>[Duration.zero] keeps it until [dismiss] is called. |
| `action` | `VToastAction?` |  |  | Text button shown after [message]. |
| `dismissible` | `bool` | `true` |  | Whether the toast can be swiped away. |
| `semanticLabel` | `String?` |  |  | Text announced by screen readers for the toast. |
| `style` | `VToastStyle?` |  |  | Style override. |

#### `VToast.info`

Info toast.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `message` | `Widget` |  | yes | Message shown in the toast, usually a [Text]. |
| `position` | `VToastPosition` | `VToastPosition.bottom` |  | Whether the toast sits at the top or the bottom of the screen. |
| `duration` | `Duration?` |  |  | How long the toast stays; defaults to [VAnimations.toast].<br>[Duration.zero] keeps it until [dismiss] is called. |
| `action` | `VToastAction?` |  |  | Text button shown after [message]. |
| `dismissible` | `bool` | `true` |  | Whether the toast can be swiped away. |
| `semanticLabel` | `String?` |  |  | Text announced by screen readers for the toast. |
| `style` | `VToastStyle?` |  |  | Style override. |

### Members

| Member | Description |
|---|---|
| `static void show(BuildContext context, VToast toast)` | Shows [toast], replacing the toast that is visible. |
| `static void showSuccess(BuildContext context, String message)` | Shows a success toast with the plain text [message]. |
| `static void showError(BuildContext context, String message)` | Shows an error toast with the plain text [message]. |
| `static void showWarning(BuildContext context, String message)` | Shows a warning toast with the plain text [message]. |
| `static void showInfo(BuildContext context, String message)` | Shows an info toast with the plain text [message]. |
| `static void dismiss(BuildContext context)` | Hides the visible toast. |

## VToastPosition

Toast position.

Specifies the display position of [VToast]:
- [top] - Top of the screen
- [bottom] - Bottom of the screen (default)

### Values

| Value | Description |
|---|---|
| `top` | Top of the screen. |
| `bottom` | Bottom of the screen (default). |

## VToastAction

Text button shown at the end of a [VToast], such as "Undo".

### Constructors

#### `VToastAction`

Creates an action that calls [onPressed] when [label] is tapped.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `String` |  | yes | Text of the action. |
| `onPressed` | `void Function()` |  | yes | Called when the action is tapped. |

## VToastStyle

Style override for [VToast].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VToastStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `textStyle` | `TextStyle?` |  |  | Text style. |

### Members

| Member | Description |
|---|---|
| `VToastStyle copyWith({Color? backgroundColor, Color? foregroundColor, BorderRadius? borderRadius, EdgeInsets? padding, TextStyle? textStyle})` | Creates a copy with only the specified properties changed. |
