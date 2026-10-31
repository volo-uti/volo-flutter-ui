# VHoverCard

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VHoverCard

Card with rich content that opens when the pointer rests on its trigger.

On touch devices a tap toggles the card instead.

```dart
VHoverCard(
  position: VHoverCardPosition.bottomStart,
  openDelay: Duration(milliseconds: 500),
  content: Row(
    spacing: 12,
    children: [
      VAvatar.text('JD'),
      Text('@johndoe'),
    ],
  ),
  child: Text('@johndoe'),
)
```

See also:

- [VHoverCardPosition], where the card appears.

### Constructors

#### `VHoverCard`

Creates a hover card.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Widget that opens the card when hovered or tapped. |
| `content` | `Widget` |  | yes | Content shown inside the card. |
| `openDelay` | `Duration` | `const Duration(milliseconds: 700)` |  | Time the pointer must rest on [child] before the card opens. |
| `closeDelay` | `Duration` | `const Duration(milliseconds: 300)` |  | Time after the pointer leaves before the card closes. |
| `position` | `VHoverCardPosition` | `VHoverCardPosition.bottom` |  | Side and alignment of the card relative to [child]. |
| `offset` | `Offset` | `const Offset(0, 8)` |  | Shift of the card from its anchor; `dy` is the distance away from [child]. |
| `enabled` | `bool` | `true` |  | Whether hovering or tapping opens the card. |
| `style` | `VHoverCardStyle?` |  |  | Per-instance style override merged over the theme style. |

## VHoverCardPosition

Side and alignment of a [VHoverCard] relative to its trigger.

### Values

| Value | Description |
|---|---|
| `top` | Top. |
| `topStart` | Top start. |
| `topEnd` | Top end. |
| `bottom` | Bottom. |
| `bottomStart` | Bottom start. |
| `bottomEnd` | Bottom end. |
| `left` | Left. |
| `leftStart` | Left start. |
| `leftEnd` | Left end. |
| `right` | Right. |
| `rightStart` | Right start. |
| `rightEnd` | Right end. |

## VHoverCardStyle

Style override for [VHoverCard].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VHoverCardStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `elevation` | `double?` |  |  | Elevation (shadow depth). |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |

### Members

| Member | Description |
|---|---|
| `VHoverCardStyle copyWith({Color? backgroundColor, Color? borderColor, BorderRadius? borderRadius, double? elevation, EdgeInsets? padding})` | Creates a copy with only the specified properties changed. |
