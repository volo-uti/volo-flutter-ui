# VBox

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VBox

Box with padding, color, border or shadow around a child.

A [Container] whose defaults come from [VTheme] and from the variant:
the default box is transparent, [VBox.card], [VBox.outlined] and
[VBox.elevated] add the card color, a border or a shadow.

## Basic Usage:

Default transparent box:

```dart
VBox(
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
)
```

## Variants:

- [VBox.new] - Default transparent box
- [VBox.card] - Card background + border
- [VBox.outlined] - Transparent background + border
- [VBox.elevated] - Card background + shadow

## Card Style Box:

Card style box:

```dart
VBox.card(
  padding: EdgeInsets.all(16),
  child: Column(
    children: [
      Text('Card Title'),
      Text('Card content goes here'),
    ],
  ),
)
```

## Elevated Box:

Box with shadow effect:

```dart
VBox.elevated(
  padding: EdgeInsets.all(24),
  borderRadius: BorderRadius.circular(16),
  child: Text('Elevated content'),
)
```

See also:

- [VSection], section container with header/footer
- [VStack], layout that arranges children in one direction

### Constructors

#### `VBox`

Transparent box with no border or shadow.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget?` |  |  | Content placed inside the box. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Inner padding. |
| `margin` | `EdgeInsetsGeometry?` |  |  | Outer margin. |
| `color` | `Color?` |  |  | Background color; defaults to the variant color. |
| `border` | `BoxBorder?` |  |  | Border; defaults to the variant border. |
| `borderRadius` | `BorderRadiusGeometry?` |  |  | Corner radius; defaults to `theme.radius.card` for the variants. |
| `boxShadow` | `List<BoxShadow>?` |  |  | Shadows; defaults to the variant shadow. |
| `width` | `double?` |  |  | Fixed width of the box. |
| `height` | `double?` |  |  | Fixed height of the box. |
| `constraints` | `BoxConstraints?` |  |  | Extra size constraints applied to the box. |
| `alignment` | `AlignmentGeometry?` |  |  | How [child] is aligned inside the box. |
| `clipBehavior` | `Clip` | `Clip.none` |  | How [child] is clipped to the box shape (the variants default to [Clip.antiAlias]). |
| `style` | `VBoxStyle?` |  |  | Overrides the theme style for this box. |

#### `VBox.card`

Box with the card background color and a border.

```dart
VBox.card(
  padding: EdgeInsets.all(16),
  child: Text('Card content'),
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget?` |  |  | Content placed inside the box. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Inner padding. |
| `margin` | `EdgeInsetsGeometry?` |  |  | Outer margin. |
| `color` | `Color?` |  |  | Background color; defaults to the variant color. |
| `border` | `BoxBorder?` |  |  | Border; defaults to the variant border. |
| `borderRadius` | `BorderRadiusGeometry?` |  |  | Corner radius; defaults to `theme.radius.card` for the variants. |
| `boxShadow` | `List<BoxShadow>?` |  |  | Shadows; defaults to the variant shadow. |
| `width` | `double?` |  |  | Fixed width of the box. |
| `height` | `double?` |  |  | Fixed height of the box. |
| `constraints` | `BoxConstraints?` |  |  | Extra size constraints applied to the box. |
| `alignment` | `AlignmentGeometry?` |  |  | How [child] is aligned inside the box. |
| `clipBehavior` | `Clip` | `Clip.antiAlias` |  | How [child] is clipped to the box shape (the variants default to [Clip.antiAlias]). |
| `style` | `VBoxStyle?` |  |  | Overrides the theme style for this box. |

#### `VBox.outlined`

Box with a border and a transparent background.

```dart
VBox.outlined(
  padding: EdgeInsets.all(12),
  borderRadius: BorderRadius.circular(8),
  child: Text('Outlined content'),
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget?` |  |  | Content placed inside the box. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Inner padding. |
| `margin` | `EdgeInsetsGeometry?` |  |  | Outer margin. |
| `color` | `Color?` |  |  | Background color; defaults to the variant color. |
| `border` | `BoxBorder?` |  |  | Border; defaults to the variant border. |
| `borderRadius` | `BorderRadiusGeometry?` |  |  | Corner radius; defaults to `theme.radius.card` for the variants. |
| `boxShadow` | `List<BoxShadow>?` |  |  | Shadows; defaults to the variant shadow. |
| `width` | `double?` |  |  | Fixed width of the box. |
| `height` | `double?` |  |  | Fixed height of the box. |
| `constraints` | `BoxConstraints?` |  |  | Extra size constraints applied to the box. |
| `alignment` | `AlignmentGeometry?` |  |  | How [child] is aligned inside the box. |
| `clipBehavior` | `Clip` | `Clip.antiAlias` |  | How [child] is clipped to the box shape (the variants default to [Clip.antiAlias]). |
| `style` | `VBoxStyle?` |  |  | Overrides the theme style for this box. |

#### `VBox.elevated`

Box with the card background color and a shadow.

```dart
VBox.elevated(
  padding: EdgeInsets.all(20),
  child: Text('Elevated content'),
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget?` |  |  | Content placed inside the box. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Inner padding. |
| `margin` | `EdgeInsetsGeometry?` |  |  | Outer margin. |
| `color` | `Color?` |  |  | Background color; defaults to the variant color. |
| `border` | `BoxBorder?` |  |  | Border; defaults to the variant border. |
| `borderRadius` | `BorderRadiusGeometry?` |  |  | Corner radius; defaults to `theme.radius.card` for the variants. |
| `boxShadow` | `List<BoxShadow>?` |  |  | Shadows; defaults to the variant shadow. |
| `width` | `double?` |  |  | Fixed width of the box. |
| `height` | `double?` |  |  | Fixed height of the box. |
| `constraints` | `BoxConstraints?` |  |  | Extra size constraints applied to the box. |
| `alignment` | `AlignmentGeometry?` |  |  | How [child] is aligned inside the box. |
| `clipBehavior` | `Clip` | `Clip.antiAlias` |  | How [child] is clipped to the box shape (the variants default to [Clip.antiAlias]). |
| `style` | `VBoxStyle?` |  |  | Overrides the theme style for this box. |

## VBoxStyle

Style override for [VBox].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VBoxStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |

### Members

| Member | Description |
|---|---|
| `VBoxStyle copyWith({Color? backgroundColor, Color? borderColor, BorderRadius? borderRadius, EdgeInsets? padding})` | Creates a copy with only the specified properties changed. |
