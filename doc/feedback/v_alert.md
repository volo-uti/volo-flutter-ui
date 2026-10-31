# VAlert

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VAlert

Inline box that shows an info, success, warning or error message.

Stays in the layout where it is placed; use [VSnackbar] or [VToast] for
messages that appear on top of the screen.

```dart
VAlert.success(
  title: Text('Saved'),
  description: Text('Your changes have been saved.'),
  onClose: () => setState(() => showAlert = false),
)
```

Types: [VAlert] (neutral), [VAlert.info], [VAlert.success],
[VAlert.warning] and [VAlert.error]; [variant] changes the fill.

See also:

 * [VToast], for temporary feedback messages
 * [VSnackbar], for bottom screen notifications

### Constructors

#### `VAlert`

Neutral alert.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `description` | `Widget` |  | yes | Message body, in the muted body style. |
| `title` | `Widget?` |  |  | Heading shown above [description], in the semibold title style. |
| `icon` | `Widget?` |  |  | Replaces the icon that matches the alert type. |
| `action` | `Widget?` |  |  | Widget shown below [description], usually a button. |
| `onClose` | `void Function()?` |  |  | Called when the close button is tapped; the button is hidden when null.<br>The alert does not remove itself, so the caller must stop building it. |
| `semanticLabel` | `String?` |  |  | Screen reader label for the whole alert; announced as the alert text. |
| `variant` | `VAlertVariant` | `VAlertVariant.standard` |  | Appearance variant.<br>Controls the visual style: - [VAlertVariant.standard] - Light tinted background (default) - [VAlertVariant.filled] - Solid colored background with white text - [VAlertVariant.outlined] - Transparent background with colored border |
| `style` | `VAlertStyle?` |  |  | Style override. |

#### `VAlert.info`

Info alert.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `description` | `Widget` |  | yes | Message body, in the muted body style. |
| `title` | `Widget?` |  |  | Heading shown above [description], in the semibold title style. |
| `icon` | `Widget?` |  |  | Replaces the icon that matches the alert type. |
| `action` | `Widget?` |  |  | Widget shown below [description], usually a button. |
| `onClose` | `void Function()?` |  |  | Called when the close button is tapped; the button is hidden when null.<br>The alert does not remove itself, so the caller must stop building it. |
| `semanticLabel` | `String?` |  |  | Screen reader label for the whole alert; announced as the alert text. |
| `variant` | `VAlertVariant` | `VAlertVariant.standard` |  | Appearance variant.<br>Controls the visual style: - [VAlertVariant.standard] - Light tinted background (default) - [VAlertVariant.filled] - Solid colored background with white text - [VAlertVariant.outlined] - Transparent background with colored border |
| `style` | `VAlertStyle?` |  |  | Style override. |

#### `VAlert.success`

Success alert.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `description` | `Widget` |  | yes | Message body, in the muted body style. |
| `title` | `Widget?` |  |  | Heading shown above [description], in the semibold title style. |
| `icon` | `Widget?` |  |  | Replaces the icon that matches the alert type. |
| `action` | `Widget?` |  |  | Widget shown below [description], usually a button. |
| `onClose` | `void Function()?` |  |  | Called when the close button is tapped; the button is hidden when null.<br>The alert does not remove itself, so the caller must stop building it. |
| `semanticLabel` | `String?` |  |  | Screen reader label for the whole alert; announced as the alert text. |
| `variant` | `VAlertVariant` | `VAlertVariant.standard` |  | Appearance variant.<br>Controls the visual style: - [VAlertVariant.standard] - Light tinted background (default) - [VAlertVariant.filled] - Solid colored background with white text - [VAlertVariant.outlined] - Transparent background with colored border |
| `style` | `VAlertStyle?` |  |  | Style override. |

#### `VAlert.warning`

Warning alert.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `description` | `Widget` |  | yes | Message body, in the muted body style. |
| `title` | `Widget?` |  |  | Heading shown above [description], in the semibold title style. |
| `icon` | `Widget?` |  |  | Replaces the icon that matches the alert type. |
| `action` | `Widget?` |  |  | Widget shown below [description], usually a button. |
| `onClose` | `void Function()?` |  |  | Called when the close button is tapped; the button is hidden when null.<br>The alert does not remove itself, so the caller must stop building it. |
| `semanticLabel` | `String?` |  |  | Screen reader label for the whole alert; announced as the alert text. |
| `variant` | `VAlertVariant` | `VAlertVariant.standard` |  | Appearance variant.<br>Controls the visual style: - [VAlertVariant.standard] - Light tinted background (default) - [VAlertVariant.filled] - Solid colored background with white text - [VAlertVariant.outlined] - Transparent background with colored border |
| `style` | `VAlertStyle?` |  |  | Style override. |

#### `VAlert.error`

Error alert.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `description` | `Widget` |  | yes | Message body, in the muted body style. |
| `title` | `Widget?` |  |  | Heading shown above [description], in the semibold title style. |
| `icon` | `Widget?` |  |  | Replaces the icon that matches the alert type. |
| `action` | `Widget?` |  |  | Widget shown below [description], usually a button. |
| `onClose` | `void Function()?` |  |  | Called when the close button is tapped; the button is hidden when null.<br>The alert does not remove itself, so the caller must stop building it. |
| `semanticLabel` | `String?` |  |  | Screen reader label for the whole alert; announced as the alert text. |
| `variant` | `VAlertVariant` | `VAlertVariant.standard` |  | Appearance variant.<br>Controls the visual style: - [VAlertVariant.standard] - Light tinted background (default) - [VAlertVariant.filled] - Solid colored background with white text - [VAlertVariant.outlined] - Transparent background with colored border |
| `style` | `VAlertStyle?` |  |  | Style override. |

## VAlertVariant

Alert appearance variant.

Controls the visual style of [VAlert]:
- [standard] - Light background with colored border (default)
- [filled] - Solid colored background with white text
- [outlined] - Transparent background with colored border only

### Values

| Value | Description |
|---|---|
| `filled` | Filled style: solid colored background with white text. |
| `outlined` | Outlined style: transparent background with colored border. |
| `standard` | Standard style: light tinted background (default). |

## VAlertStyle

Style override for [VAlert].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VAlertStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `iconColor` | `Color?` |  |  | Icon tint color. |
| `titleStyle` | `TextStyle?` |  |  | Title text style. |

### Members

| Member | Description |
|---|---|
| `VAlertStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, BorderRadius? borderRadius, EdgeInsets? padding, Color? iconColor, TextStyle? titleStyle})` | Creates a copy with only the specified properties changed. |
