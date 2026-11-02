# VSnackbar

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VSnackbar

Temporary message bar anchored to the bottom of the screen.

Shown with [show]; snackbars shown while another is visible wait in a queue
and appear one after another. Call [clear] before [show] to replace the
visible one instead. It hides itself after [duration].

```dart
VSnackbar.show(
  context,
  VSnackbar(
    content: const Text('Item deleted.'),
    semanticLabel: 'Item deleted.',
    action: VSnackbarAction(label: 'Undo', onPressed: undoDelete),
  ),
);
```

Types: [VSnackbar] (neutral), [VSnackbar.success], [VSnackbar.error],
[VSnackbar.warning] and [VSnackbar.info]. [showSuccess] and [showError]
show a plain message in one call.

See also:

 * [VToast], a centered message that replaces the previous one
 * [VAlert], an inline message

### Constructors

#### `VSnackbar`

Default snackbar.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `content` | `Widget` |  | yes | Message shown in the bar, usually a [Text]. |
| `action` | `VSnackbarAction?` |  |  | Text button shown after [content]. |
| `duration` | `Duration?` |  |  | How long the snackbar stays; defaults to [VAnimations.snackbar].<br>[Duration.zero] keeps it until [hide] or [clear] is called. |
| `behavior` | `VSnackbarBehavior` | `VSnackbarBehavior.fixed` |  | Whether the bar is fixed to the bottom edge or floats above content. |
| `width` | `double?` |  |  | Width of the bar when [behavior] is floating. |
| `padding` | `EdgeInsets?` |  |  | Padding inside the bar; defaults to the theme's large spacing. |
| `margin` | `EdgeInsets?` |  |  | Margin around the bar when [behavior] is floating. |
| `shape` | `ShapeBorder?` |  |  | Border shape; defaults to a rounded rectangle when floating. |
| `backgroundColor` | `Color?` |  |  | Fill color; defaults to the color of the snackbar type. |
| `dismissDirection` | `DismissDirection?` |  |  | Swipe direction that hides the snackbar; swiping is off when null. |
| `onVisible` | `void Function()?` |  |  | Called right after the snackbar is inserted into the overlay. |
| `semanticLabel` | `String?` |  |  | Text announced by screen readers when the snackbar appears. |
| `style` | `VSnackbarStyle?` |  |  | Style override. |

#### `VSnackbar.success`

Success snackbar.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `content` | `Widget` |  | yes | Message shown in the bar, usually a [Text]. |
| `action` | `VSnackbarAction?` |  |  | Text button shown after [content]. |
| `duration` | `Duration?` |  |  | How long the snackbar stays; defaults to [VAnimations.snackbar].<br>[Duration.zero] keeps it until [hide] or [clear] is called. |
| `behavior` | `VSnackbarBehavior` | `VSnackbarBehavior.fixed` |  | Whether the bar is fixed to the bottom edge or floats above content. |
| `width` | `double?` |  |  | Width of the bar when [behavior] is floating. |
| `padding` | `EdgeInsets?` |  |  | Padding inside the bar; defaults to the theme's large spacing. |
| `margin` | `EdgeInsets?` |  |  | Margin around the bar when [behavior] is floating. |
| `shape` | `ShapeBorder?` |  |  | Border shape; defaults to a rounded rectangle when floating. |
| `backgroundColor` | `Color?` |  |  | Fill color; defaults to the color of the snackbar type. |
| `dismissDirection` | `DismissDirection?` |  |  | Swipe direction that hides the snackbar; swiping is off when null. |
| `onVisible` | `void Function()?` |  |  | Called right after the snackbar is inserted into the overlay. |
| `semanticLabel` | `String?` |  |  | Text announced by screen readers when the snackbar appears. |
| `style` | `VSnackbarStyle?` |  |  | Style override. |

#### `VSnackbar.error`

Error snackbar.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `content` | `Widget` |  | yes | Message shown in the bar, usually a [Text]. |
| `action` | `VSnackbarAction?` |  |  | Text button shown after [content]. |
| `duration` | `Duration?` |  |  | How long the snackbar stays; defaults to [VAnimations.snackbar].<br>[Duration.zero] keeps it until [hide] or [clear] is called. |
| `behavior` | `VSnackbarBehavior` | `VSnackbarBehavior.fixed` |  | Whether the bar is fixed to the bottom edge or floats above content. |
| `width` | `double?` |  |  | Width of the bar when [behavior] is floating. |
| `padding` | `EdgeInsets?` |  |  | Padding inside the bar; defaults to the theme's large spacing. |
| `margin` | `EdgeInsets?` |  |  | Margin around the bar when [behavior] is floating. |
| `shape` | `ShapeBorder?` |  |  | Border shape; defaults to a rounded rectangle when floating. |
| `backgroundColor` | `Color?` |  |  | Fill color; defaults to the color of the snackbar type. |
| `dismissDirection` | `DismissDirection?` |  |  | Swipe direction that hides the snackbar; swiping is off when null. |
| `onVisible` | `void Function()?` |  |  | Called right after the snackbar is inserted into the overlay. |
| `semanticLabel` | `String?` |  |  | Text announced by screen readers when the snackbar appears. |
| `style` | `VSnackbarStyle?` |  |  | Style override. |

#### `VSnackbar.warning`

Warning snackbar.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `content` | `Widget` |  | yes | Message shown in the bar, usually a [Text]. |
| `action` | `VSnackbarAction?` |  |  | Text button shown after [content]. |
| `duration` | `Duration?` |  |  | How long the snackbar stays; defaults to [VAnimations.snackbar].<br>[Duration.zero] keeps it until [hide] or [clear] is called. |
| `behavior` | `VSnackbarBehavior` | `VSnackbarBehavior.fixed` |  | Whether the bar is fixed to the bottom edge or floats above content. |
| `width` | `double?` |  |  | Width of the bar when [behavior] is floating. |
| `padding` | `EdgeInsets?` |  |  | Padding inside the bar; defaults to the theme's large spacing. |
| `margin` | `EdgeInsets?` |  |  | Margin around the bar when [behavior] is floating. |
| `shape` | `ShapeBorder?` |  |  | Border shape; defaults to a rounded rectangle when floating. |
| `backgroundColor` | `Color?` |  |  | Fill color; defaults to the color of the snackbar type. |
| `dismissDirection` | `DismissDirection?` |  |  | Swipe direction that hides the snackbar; swiping is off when null. |
| `onVisible` | `void Function()?` |  |  | Called right after the snackbar is inserted into the overlay. |
| `semanticLabel` | `String?` |  |  | Text announced by screen readers when the snackbar appears. |
| `style` | `VSnackbarStyle?` |  |  | Style override. |

#### `VSnackbar.info`

Info snackbar.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `content` | `Widget` |  | yes | Message shown in the bar, usually a [Text]. |
| `action` | `VSnackbarAction?` |  |  | Text button shown after [content]. |
| `duration` | `Duration?` |  |  | How long the snackbar stays; defaults to [VAnimations.snackbar].<br>[Duration.zero] keeps it until [hide] or [clear] is called. |
| `behavior` | `VSnackbarBehavior` | `VSnackbarBehavior.fixed` |  | Whether the bar is fixed to the bottom edge or floats above content. |
| `width` | `double?` |  |  | Width of the bar when [behavior] is floating. |
| `padding` | `EdgeInsets?` |  |  | Padding inside the bar; defaults to the theme's large spacing. |
| `margin` | `EdgeInsets?` |  |  | Margin around the bar when [behavior] is floating. |
| `shape` | `ShapeBorder?` |  |  | Border shape; defaults to a rounded rectangle when floating. |
| `backgroundColor` | `Color?` |  |  | Fill color; defaults to the color of the snackbar type. |
| `dismissDirection` | `DismissDirection?` |  |  | Swipe direction that hides the snackbar; swiping is off when null. |
| `onVisible` | `void Function()?` |  |  | Called right after the snackbar is inserted into the overlay. |
| `semanticLabel` | `String?` |  |  | Text announced by screen readers when the snackbar appears. |
| `style` | `VSnackbarStyle?` |  |  | Style override. |

### Members

| Member | Description |
|---|---|
| `static void show(BuildContext context, VSnackbar snackbar)` | Shows [snackbar], or queues it while another one is visible.<br>To replace the visible snackbar instead of waiting for it, call [clear] first; it hides the visible one and drops the queue. |
| `static void showSuccess(BuildContext context, String message)` | Shows a success snackbar with the plain text [message]. |
| `static void showError(BuildContext context, String message)` | Shows an error snackbar with the plain text [message]. |
| `static void hide(BuildContext context)` | Hides the visible snackbar and shows the next queued one. |
| `static void clear(BuildContext context)` | Drops all queued snackbars and hides the visible one. |

## VSnackbarAction

Text button shown at the end of a [VSnackbar], such as "Undo".

### Constructors

#### `VSnackbarAction`

Creates an action that calls [onPressed] when [label] is tapped.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `String` |  | yes | Text of the action. |
| `onPressed` | `void Function()` |  | yes | Called when the action is tapped; the snackbar hides right after. |
| `textColor` | `Color?` |  |  | Color of [label]; the snackbar's text color when null. |

## VSnackbarBehavior

Snackbar display behavior.

Controls whether the snackbar is anchored to the bottom ([fixed])
or floats above content ([floating]).

### Values

| Value | Description |
|---|---|
| `fixed` | Fixed to the bottom of the screen. |
| `floating` | Floats above content with margin. |

## VSnackbarStyle

Style override for [VSnackbar].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VSnackbarStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `textStyle` | `TextStyle?` |  |  | Text style. |
| `actionColor` | `Color?` |  |  | Action button color. |

### Members

| Member | Description |
|---|---|
| `VSnackbarStyle copyWith({Color? backgroundColor, Color? foregroundColor, BorderRadius? borderRadius, EdgeInsets? padding, TextStyle? textStyle, Color? actionColor})` | Creates a copy with only the specified properties changed. |
