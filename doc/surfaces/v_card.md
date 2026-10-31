# VCard, VCardHeader, VCardFooter

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VCard

Raised or outlined container that groups related content, optionally tappable.

```dart
VCard(
  onTap: () => debugPrint('opened'),
  child: Column(
    children: [
      VCardHeader(
        title: Text('Title'),
        description: Text('A description for this card.'),
      ),
      Text('Card body content.'),
      VCardFooter(
        children: [
          VButton.outlined(onPressed: () {}, child: Text('Cancel')),
          VButton(onPressed: () {}, child: Text('Confirm')),
        ],
      ),
    ],
  ),
)
```

**Variants:**

- [VCard] - Default. Elevated with shadow (floating effect)
- [VCard.outlined] - Outlined. Border only (flat style)
- [VCard.elevated] - Same as default. Floating effect with shadow

**Tappable Card:**

```dart
VCard(
  onTap: () => print('Card tapped'),
  child: VCardHeader(
    title: Text('Tappable Card'),
    description: Text('Tap to perform an action.'),
  ),
)
```

**Elevated Card:**

```dart
VCard.elevated(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('A card with shadow.'),
  ),
)
```

See also:

- [VCardHeader], the title area at the top of the card
- [VCardFooter], the button area at the bottom of the card
- [VSheet], an overlay that slides from the screen edge

### Constructors

#### `VCard`

Creates a default card with shadow for a floating effect.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content shown inside the card. |
| `padding` | `EdgeInsets?` |  |  | Inner padding. Defaults to the theme's large spacing on every side. |
| `borderRadius` | `BorderRadius?` |  |  | Corner radius. Defaults to the theme's large radius. |
| `onTap` | `void Function()?` |  |  | Called when the card is tapped; setting it makes the card pressable. |
| `onLongPress` | `void Function()?` |  |  | Called when the card is long-pressed; setting it makes the card pressable. |
| `style` | `VCardStyle?` |  |  | Style override. |

#### `VCard.outlined`

Outlined card.

A flat-style card with border only.
The transparent background gives a lightweight appearance.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content shown inside the card. |
| `padding` | `EdgeInsets?` |  |  | Inner padding. Defaults to the theme's large spacing on every side. |
| `borderRadius` | `BorderRadius?` |  |  | Corner radius. Defaults to the theme's large radius. |
| `onTap` | `void Function()?` |  |  | Called when the card is tapped; setting it makes the card pressable. |
| `onLongPress` | `void Function()?` |  |  | Called when the card is long-pressed; setting it makes the card pressable. |
| `style` | `VCardStyle?` |  |  | Style override. |

#### `VCard.elevated`

Elevated card.

A card with shadow for a floating effect.
The shadow grows larger on hover.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content shown inside the card. |
| `padding` | `EdgeInsets?` |  |  | Inner padding. Defaults to the theme's large spacing on every side. |
| `borderRadius` | `BorderRadius?` |  |  | Corner radius. Defaults to the theme's large radius. |
| `onTap` | `void Function()?` |  |  | Called when the card is tapped; setting it makes the card pressable. |
| `onLongPress` | `void Function()?` |  |  | Called when the card is long-pressed; setting it makes the card pressable. |
| `style` | `VCardStyle?` |  |  | Style override. |

## VCardHeader

Title area at the top of a [VCard], with an optional description and action.

```dart
VCardHeader(
  title: Text('Settings'),
  description: Text('Manage app settings.'),
  action: VIconButton(
    icon: Icon(Icons.more_vert),
    onPressed: () {},
  ),
)
```

See also:

- [VCard], a container that groups related content
- [VCardFooter], the button area at the bottom of the card

### Constructors

#### `VCardHeader`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Heading of the card, usually a [Text]. |
| `description` | `Widget?` |  |  | Smaller line shown below [title]. |
| `action` | `Widget?` |  |  | Widget at the end of the header, typically an icon button or menu. |

## VCardFooter

Row of buttons at the bottom of a [VCard], spaced evenly and right-aligned.

```dart
VCardFooter(
  children: [
    VButton.outlined(onPressed: () {}, child: Text('Cancel')),
    VButton(onPressed: () {}, child: Text('Confirm')),
  ],
)
```

See also:

- [VCard], a container that groups related content
- [VCardHeader], the title area at the top of the card

### Constructors

#### `VCardFooter`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Buttons shown in the footer, separated by a small gap. |
| `alignment` | `MainAxisAlignment` | `MainAxisAlignment.end` |  | Horizontal alignment of [children]. Defaults to the end edge. |

## VCardStyle

Style override for [VCard].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VCardStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `elevation` | `double?` |  |  | Elevation (shadow depth). |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |

### Members

| Member | Description |
|---|---|
| `VCardStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, BorderRadius? borderRadius, double? elevation, EdgeInsets? padding})` | Creates a copy with only the specified properties changed. |
