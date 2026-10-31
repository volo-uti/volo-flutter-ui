# VButton

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VButton

Button with filled, outlined, text, ghost, icon and link variants.

Pass any widget as `child`; plain `Text` and `Icon` children are styled for you.

**Basic Usage:**

```dart
VButton(
  onPressed: () {},
  child: Text('Save'),
)
```

**Variants:**

- [VButton] - Default button (filled background)
- [VButton.outlined] - Outlined button
- [VButton.text] - Text button without background
- [VButton.ghost] - Ghost button (transparent, accent hover)
- [VButton.icon] - Square icon button
- [VButton.link] - Underlined link style

**With Icon:**

```dart
VButton(
  onPressed: () {},
  leading: Icon(Icons.download),
  child: Text('Download'),
)
```

**Loading State:**

```dart
VButton(
  onPressed: () {},
  loading: true,
  child: Text('Saving...'),
)
```

### Constructors

#### `VButton`

Creates a filled button.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content of the button; a plain `Text` or `Icon` picks up the button's color, size and weight. |
| `onPressed` | `void Function()?` |  |  | Called when the button is tapped; `null` renders it disabled. |
| `onLongPress` | `void Function()?` |  |  | Called when the button is long-pressed; falls back to showing [tooltip]. |
| `leading` | `Widget?` |  |  | Widget shown before [child], typically an icon. |
| `trailing` | `Widget?` |  |  | Widget shown after [child], typically an icon. |
| `color` | `VButtonColor` | `VButtonColor.primary` |  | Color role of the button. |
| `size` | `VButtonSize` | `VButtonSize.md` |  | Height and text size preset. |
| `corner` | `VButtonCorner` | `VButtonCorner.rounded` |  | Corner radius style. |
| `align` | `VButtonAlign` | `VButtonAlign.center` |  | Horizontal alignment of the content inside the button. |
| `leadingGap` | `double?` |  |  | Gap between [leading] and [child]; defaults to the size's spacing token. |
| `trailingGap` | `double?` |  |  | Gap between [child] and [trailing]; defaults to the size's spacing token. |
| `fullWidth` | `bool` | `false` |  | Whether the button stretches to the full available width. |
| `enabled` | `bool` | `true` |  | Whether the button reacts to input; `false` dims it and blocks presses. |
| `loading` | `bool` | `false` |  | Whether a loading indicator is shown and presses are blocked. |
| `loadingIndicator` | `Widget?` |  |  | Replaces the default spinner while [loading] is true. |
| `loadingPosition` | `VButtonLoadingPosition` | `VButtonLoadingPosition.center` |  | Where the loading indicator appears relative to [child]. |
| `tooltip` | `String?` |  |  | Text shown in a floating label on long press. |
| `semanticLabel` | `String?` |  |  | Label announced by screen readers instead of the child's own text. |
| `style` | `VButtonStyle?` |  |  | Per-instance style override merged over the theme's [VButtonStyle]. |

#### `VButton.outlined`

Creates an outlined button.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content of the button; a plain `Text` or `Icon` picks up the button's color, size and weight. |
| `onPressed` | `void Function()?` |  |  | Called when the button is tapped; `null` renders it disabled. |
| `onLongPress` | `void Function()?` |  |  | Called when the button is long-pressed; falls back to showing [tooltip]. |
| `leading` | `Widget?` |  |  | Widget shown before [child], typically an icon. |
| `trailing` | `Widget?` |  |  | Widget shown after [child], typically an icon. |
| `color` | `VButtonColor` | `VButtonColor.primary` |  | Color role of the button. |
| `size` | `VButtonSize` | `VButtonSize.md` |  | Height and text size preset. |
| `corner` | `VButtonCorner` | `VButtonCorner.rounded` |  | Corner radius style. |
| `align` | `VButtonAlign` | `VButtonAlign.center` |  | Horizontal alignment of the content inside the button. |
| `leadingGap` | `double?` |  |  | Gap between [leading] and [child]; defaults to the size's spacing token. |
| `trailingGap` | `double?` |  |  | Gap between [child] and [trailing]; defaults to the size's spacing token. |
| `fullWidth` | `bool` | `false` |  | Whether the button stretches to the full available width. |
| `enabled` | `bool` | `true` |  | Whether the button reacts to input; `false` dims it and blocks presses. |
| `loading` | `bool` | `false` |  | Whether a loading indicator is shown and presses are blocked. |
| `loadingIndicator` | `Widget?` |  |  | Replaces the default spinner while [loading] is true. |
| `loadingPosition` | `VButtonLoadingPosition` | `VButtonLoadingPosition.center` |  | Where the loading indicator appears relative to [child]. |
| `tooltip` | `String?` |  |  | Text shown in a floating label on long press. |
| `semanticLabel` | `String?` |  |  | Label announced by screen readers instead of the child's own text. |
| `style` | `VButtonStyle?` |  |  | Per-instance style override merged over the theme's [VButtonStyle]. |

#### `VButton.text`

Creates a text button without background.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content of the button; a plain `Text` or `Icon` picks up the button's color, size and weight. |
| `onPressed` | `void Function()?` |  |  | Called when the button is tapped; `null` renders it disabled. |
| `onLongPress` | `void Function()?` |  |  | Called when the button is long-pressed; falls back to showing [tooltip]. |
| `leading` | `Widget?` |  |  | Widget shown before [child], typically an icon. |
| `trailing` | `Widget?` |  |  | Widget shown after [child], typically an icon. |
| `color` | `VButtonColor` | `VButtonColor.primary` |  | Color role of the button. |
| `size` | `VButtonSize` | `VButtonSize.md` |  | Height and text size preset. |
| `corner` | `VButtonCorner` | `VButtonCorner.rounded` |  | Corner radius style. |
| `align` | `VButtonAlign` | `VButtonAlign.center` |  | Horizontal alignment of the content inside the button. |
| `leadingGap` | `double?` |  |  | Gap between [leading] and [child]; defaults to the size's spacing token. |
| `trailingGap` | `double?` |  |  | Gap between [child] and [trailing]; defaults to the size's spacing token. |
| `fullWidth` | `bool` | `false` |  | Whether the button stretches to the full available width. |
| `enabled` | `bool` | `true` |  | Whether the button reacts to input; `false` dims it and blocks presses. |
| `loading` | `bool` | `false` |  | Whether a loading indicator is shown and presses are blocked. |
| `loadingIndicator` | `Widget?` |  |  | Replaces the default spinner while [loading] is true. |
| `loadingPosition` | `VButtonLoadingPosition` | `VButtonLoadingPosition.center` |  | Where the loading indicator appears relative to [child]. |
| `tooltip` | `String?` |  |  | Text shown in a floating label on long press. |
| `semanticLabel` | `String?` |  |  | Label announced by screen readers instead of the child's own text. |
| `style` | `VButtonStyle?` |  |  | Per-instance style override merged over the theme's [VButtonStyle]. |

#### `VButton.icon`

Creates a square button sized for an icon child.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content of the button; a plain `Text` or `Icon` picks up the button's color, size and weight. |
| `onPressed` | `void Function()?` |  |  | Called when the button is tapped; `null` renders it disabled. |
| `onLongPress` | `void Function()?` |  |  | Called when the button is long-pressed; falls back to showing [tooltip]. |
| `leading` | `Widget?` |  |  | Widget shown before [child], typically an icon. |
| `trailing` | `Widget?` |  |  | Widget shown after [child], typically an icon. |
| `color` | `VButtonColor` | `VButtonColor.primary` |  | Color role of the button. |
| `size` | `VButtonSize` | `VButtonSize.md` |  | Height and text size preset. |
| `corner` | `VButtonCorner` | `VButtonCorner.rounded` |  | Corner radius style. |
| `align` | `VButtonAlign` | `VButtonAlign.center` |  | Horizontal alignment of the content inside the button. |
| `leadingGap` | `double?` |  |  | Gap between [leading] and [child]; defaults to the size's spacing token. |
| `trailingGap` | `double?` |  |  | Gap between [child] and [trailing]; defaults to the size's spacing token. |
| `fullWidth` | `bool` | `false` |  | Whether the button stretches to the full available width. |
| `enabled` | `bool` | `true` |  | Whether the button reacts to input; `false` dims it and blocks presses. |
| `loading` | `bool` | `false` |  | Whether a loading indicator is shown and presses are blocked. |
| `loadingIndicator` | `Widget?` |  |  | Replaces the default spinner while [loading] is true. |
| `loadingPosition` | `VButtonLoadingPosition` | `VButtonLoadingPosition.center` |  | Where the loading indicator appears relative to [child]. |
| `tooltip` | `String?` |  |  | Text shown in a floating label on long press. |
| `semanticLabel` | `String?` |  |  | Label announced by screen readers instead of the child's own text. |
| `style` | `VButtonStyle?` |  |  | Per-instance style override merged over the theme's [VButtonStyle]. |

#### `VButton.ghost`

Creates a transparent button that shows the accent color on hover.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content of the button; a plain `Text` or `Icon` picks up the button's color, size and weight. |
| `onPressed` | `void Function()?` |  |  | Called when the button is tapped; `null` renders it disabled. |
| `onLongPress` | `void Function()?` |  |  | Called when the button is long-pressed; falls back to showing [tooltip]. |
| `leading` | `Widget?` |  |  | Widget shown before [child], typically an icon. |
| `trailing` | `Widget?` |  |  | Widget shown after [child], typically an icon. |
| `color` | `VButtonColor` | `VButtonColor.primary` |  | Color role of the button. |
| `size` | `VButtonSize` | `VButtonSize.md` |  | Height and text size preset. |
| `corner` | `VButtonCorner` | `VButtonCorner.rounded` |  | Corner radius style. |
| `align` | `VButtonAlign` | `VButtonAlign.center` |  | Horizontal alignment of the content inside the button. |
| `leadingGap` | `double?` |  |  | Gap between [leading] and [child]; defaults to the size's spacing token. |
| `trailingGap` | `double?` |  |  | Gap between [child] and [trailing]; defaults to the size's spacing token. |
| `fullWidth` | `bool` | `false` |  | Whether the button stretches to the full available width. |
| `enabled` | `bool` | `true` |  | Whether the button reacts to input; `false` dims it and blocks presses. |
| `loading` | `bool` | `false` |  | Whether a loading indicator is shown and presses are blocked. |
| `loadingIndicator` | `Widget?` |  |  | Replaces the default spinner while [loading] is true. |
| `loadingPosition` | `VButtonLoadingPosition` | `VButtonLoadingPosition.center` |  | Where the loading indicator appears relative to [child]. |
| `tooltip` | `String?` |  |  | Text shown in a floating label on long press. |
| `semanticLabel` | `String?` |  |  | Label announced by screen readers instead of the child's own text. |
| `style` | `VButtonStyle?` |  |  | Per-instance style override merged over the theme's [VButtonStyle]. |

#### `VButton.link`

Creates an underlined link-style button.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content of the button; a plain `Text` or `Icon` picks up the button's color, size and weight. |
| `onPressed` | `void Function()?` |  |  | Called when the button is tapped; `null` renders it disabled. |
| `onLongPress` | `void Function()?` |  |  | Called when the button is long-pressed; falls back to showing [tooltip]. |
| `leading` | `Widget?` |  |  | Widget shown before [child], typically an icon. |
| `trailing` | `Widget?` |  |  | Widget shown after [child], typically an icon. |
| `color` | `VButtonColor` | `VButtonColor.primary` |  | Color role of the button. |
| `size` | `VButtonSize` | `VButtonSize.md` |  | Height and text size preset. |
| `corner` | `VButtonCorner` | `VButtonCorner.rounded` |  | Corner radius style. |
| `align` | `VButtonAlign` | `VButtonAlign.center` |  | Horizontal alignment of the content inside the button. |
| `leadingGap` | `double?` |  |  | Gap between [leading] and [child]; defaults to the size's spacing token. |
| `trailingGap` | `double?` |  |  | Gap between [child] and [trailing]; defaults to the size's spacing token. |
| `fullWidth` | `bool` | `false` |  | Whether the button stretches to the full available width. |
| `enabled` | `bool` | `true` |  | Whether the button reacts to input; `false` dims it and blocks presses. |
| `loading` | `bool` | `false` |  | Whether a loading indicator is shown and presses are blocked. |
| `loadingIndicator` | `Widget?` |  |  | Replaces the default spinner while [loading] is true. |
| `loadingPosition` | `VButtonLoadingPosition` | `VButtonLoadingPosition.center` |  | Where the loading indicator appears relative to [child]. |
| `tooltip` | `String?` |  |  | Text shown in a floating label on long press. |
| `semanticLabel` | `String?` |  |  | Label announced by screen readers instead of the child's own text. |
| `style` | `VButtonStyle?` |  |  | Per-instance style override merged over the theme's [VButtonStyle]. |

## VButtonSize

Button size.

### Values

| Value | Description |
|---|---|
| `xs` | Extra small size (24px). |
| `sm` | Small size (32px). |
| `md` | Medium size (40px). |
| `lg` | Large size (48px). |
| `xl` | Extra large size (56px). |

## VButtonCorner

Button corner style.

### Values

| Value | Description |
|---|---|
| `square` | Square corners. |
| `rounded` | Rounded corners (default). |
| `pill` | Pill shape. |
| `circle` | Circle (for square buttons). |

## VButtonColor

Button color.

### Values

| Value | Description |
|---|---|
| `primary` | Primary color. |
| `secondary` | Secondary color. |
| `tertiary` | Tertiary color. |
| `destructive` | Destructive/delete color. |

## VButtonLoadingPosition

Loading indicator position.

### Values

| Value | Description |
|---|---|
| `center` | Center (hides child). |
| `start` | Start (leading position). |
| `end` | End (trailing position). |

## VButtonAlign

Button alignment.

### Values

| Value | Description |
|---|---|
| `left` | Left alignment. |
| `center` | Center alignment (default). |
| `right` | Right alignment. |

## VButtonStyle

Style override for [VButton].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VButtonStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text / icon foreground color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `textStyle` | `TextStyle?` |  |  | Text style. |
| `iconColor` | `Color?` |  |  | Icon tint color. |
| `gap` | `double?` |  |  | Gap between icon and label. |

### Members

| Member | Description |
|---|---|
| `VButtonStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, BorderRadius? borderRadius, EdgeInsets? padding, TextStyle? textStyle, Color? iconColor, double? gap})` | Creates a copy with only the specified properties changed. |
