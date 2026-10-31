# VIconButton

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VIconButton

Round button that shows a single icon, optionally toggling between two.

Set [VIconButton.isSelected] to make it a toggle.

**Basic Usage:**

```dart
VIconButton(
  icon: Icon(Icons.search),
  onPressed: () {},
)
```

**Variants:**

- [VIconButton] - Default (transparent background)
- [VIconButton.filled] - Filled background
- [VIconButton.outlined] - Bordered
- [VIconButton.filledTonal] - Tonal filled

**Toggle State:**

```dart
VIconButton(
  icon: Icon(Icons.favorite_border),
  selectedIcon: Icon(Icons.favorite),
  isSelected: isFavorite,
  onPressed: () => setState(() => isFavorite = !isFavorite),
)
```

### Constructors

#### `VIconButton`

Creates an icon button with a transparent background.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `icon` | `Widget` |  | yes | Icon shown in the button; plain `Icon` children take the button's color and size. |
| `onPressed` | `void Function()?` |  |  | Called when the button is tapped; `null` renders it disabled. |
| `selectedIcon` | `Widget?` |  |  | Icon shown instead of [icon] while [isSelected] is true. |
| `isSelected` | `bool?` |  |  | Whether the toggle is on; `null` means the button is not a toggle. |
| `tooltip` | `String?` |  |  | Label announced by screen readers. |
| `size` | `VIconButtonSize` | `VIconButtonSize.md` |  | Diameter preset of the button. |
| `color` | `VButtonColor` | `VButtonColor.primary` |  | Color role of the button. |
| `loading` | `bool` | `false` |  | Whether a spinner replaces the icon and presses are blocked. |
| `enabled` | `bool` | `true` |  | Whether the button reacts to input; `false` dims it and blocks presses. |
| `style` | `VIconButtonStyle?` |  |  | Per-instance style override merged over the theme's [VIconButtonStyle]. |

#### `VIconButton.filled`

Creates an icon button with a filled background.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `icon` | `Widget` |  | yes | Icon shown in the button; plain `Icon` children take the button's color and size. |
| `onPressed` | `void Function()?` |  |  | Called when the button is tapped; `null` renders it disabled. |
| `selectedIcon` | `Widget?` |  |  | Icon shown instead of [icon] while [isSelected] is true. |
| `isSelected` | `bool?` |  |  | Whether the toggle is on; `null` means the button is not a toggle. |
| `tooltip` | `String?` |  |  | Label announced by screen readers. |
| `size` | `VIconButtonSize` | `VIconButtonSize.md` |  | Diameter preset of the button. |
| `color` | `VButtonColor` | `VButtonColor.primary` |  | Color role of the button. |
| `loading` | `bool` | `false` |  | Whether a spinner replaces the icon and presses are blocked. |
| `enabled` | `bool` | `true` |  | Whether the button reacts to input; `false` dims it and blocks presses. |
| `style` | `VIconButtonStyle?` |  |  | Per-instance style override merged over the theme's [VIconButtonStyle]. |

#### `VIconButton.outlined`

Creates an icon button with a border.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `icon` | `Widget` |  | yes | Icon shown in the button; plain `Icon` children take the button's color and size. |
| `onPressed` | `void Function()?` |  |  | Called when the button is tapped; `null` renders it disabled. |
| `selectedIcon` | `Widget?` |  |  | Icon shown instead of [icon] while [isSelected] is true. |
| `isSelected` | `bool?` |  |  | Whether the toggle is on; `null` means the button is not a toggle. |
| `tooltip` | `String?` |  |  | Label announced by screen readers. |
| `size` | `VIconButtonSize` | `VIconButtonSize.md` |  | Diameter preset of the button. |
| `color` | `VButtonColor` | `VButtonColor.primary` |  | Color role of the button. |
| `loading` | `bool` | `false` |  | Whether a spinner replaces the icon and presses are blocked. |
| `enabled` | `bool` | `true` |  | Whether the button reacts to input; `false` dims it and blocks presses. |
| `style` | `VIconButtonStyle?` |  |  | Per-instance style override merged over the theme's [VIconButtonStyle]. |

#### `VIconButton.filledTonal`

Creates an icon button with a tonal background.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `icon` | `Widget` |  | yes | Icon shown in the button; plain `Icon` children take the button's color and size. |
| `onPressed` | `void Function()?` |  |  | Called when the button is tapped; `null` renders it disabled. |
| `selectedIcon` | `Widget?` |  |  | Icon shown instead of [icon] while [isSelected] is true. |
| `isSelected` | `bool?` |  |  | Whether the toggle is on; `null` means the button is not a toggle. |
| `tooltip` | `String?` |  |  | Label announced by screen readers. |
| `size` | `VIconButtonSize` | `VIconButtonSize.md` |  | Diameter preset of the button. |
| `color` | `VButtonColor` | `VButtonColor.primary` |  | Color role of the button. |
| `loading` | `bool` | `false` |  | Whether a spinner replaces the icon and presses are blocked. |
| `enabled` | `bool` | `true` |  | Whether the button reacts to input; `false` dims it and blocks presses. |
| `style` | `VIconButtonStyle?` |  |  | Per-instance style override merged over the theme's [VIconButtonStyle]. |

## VIconButtonSize

Icon button size.

### Values

| Value | Description |
|---|---|
| `xs` | Extra small (24px). |
| `sm` | Small (32px). |
| `md` | Medium (40px). |
| `lg` | Large (48px). |
| `xl` | Extra large (56px). |

## VIconButtonStyle

Style override for [VIconButton].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VIconButtonStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text / icon foreground color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `overlayColor` | `Color?` |  |  | Press / hover overlay color. |
| `iconColor` | `Color?` |  |  | Icon tint color. |
| `iconSize` | `double?` |  |  | Icon size. |

### Members

| Member | Description |
|---|---|
| `VIconButtonStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, BorderRadius? borderRadius, EdgeInsets? padding, Color? overlayColor, Color? iconColor, double? iconSize})` | Creates a copy with only the specified properties changed. |
