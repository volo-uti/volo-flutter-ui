# VTooltip

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VTooltip

Small overlay that explains a widget on hover or long press.

Pass plain text as [message], or a widget as [richMessage] for icons and
styled text. Exactly one of the two is required.

```dart
VTooltip(
  message: 'Copy to clipboard',
  position: VTooltipPosition.bottom,
  waitDuration: Duration(milliseconds: 200),
  child: Icon(IconData(0xe14d, fontFamily: 'MaterialIcons')),
)
```

See also:

- [VTooltipPosition], where the tooltip appears.

### Constructors

#### `VTooltip`

Creates a tooltip from [message] or [richMessage].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Widget the tooltip describes. |
| `message` | `String?` |  |  | Plain text of the tooltip; also announced by screen readers. |
| `richMessage` | `Widget?` |  |  | Widget shown instead of [message], for icons or styled text. |
| `position` | `VTooltipPosition` | `VTooltipPosition.top` |  | Side of [child] the tooltip appears on. |
| `waitDuration` | `Duration` | `const Duration(milliseconds: 500)` |  | Time the pointer must rest on [child] before the tooltip shows. |
| `showDuration` | `Duration` | `const Duration(milliseconds: 1500)` |  | Time the tooltip stays visible before hiding on its own. |
| `maxWidth` | `double?` |  |  | Maximum width constraint for the tooltip. |
| `style` | `VTooltipStyle?` |  |  | Per-instance style override merged over the theme style. |

## VTooltipPosition

Tooltip position.

### Values

| Value | Description |
|---|---|
| `top` | Top. |
| `bottom` | Bottom. |
| `left` | Left. |
| `right` | Right. |

## VTooltipStyle

Style override for [VTooltip].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VTooltipStyle`

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
| `VTooltipStyle copyWith({Color? backgroundColor, Color? foregroundColor, BorderRadius? borderRadius, EdgeInsets? padding, TextStyle? textStyle})` | Creates a copy with only the specified properties changed. |
