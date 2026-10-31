# VPageIndicator

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VPageIndicator

Dots, number or lines that show the current position in a short page set.

Use it for carousels, onboarding flows and galleries. Unlike
[VPagination], it is mostly visual; [onPageChanged] makes it tappable.

## Basic Usage:

```dart
VPageIndicator.dots(
  total: 5,
  current: 2,
)
```

## Variants:

- [VPageIndicator.dots] - Dot style indicator (● ○ ○)
- [VPageIndicator.number] - Number style indicator (2 / 5)
- [VPageIndicator.line] - Line style indicator (━━━ ─── ───)

## Customized Dots:

```dart
VPageIndicator.dots(
  total: 5,
  current: 2,
  size: 10,
  activeSize: 14,
  spacing: 8,
  activeColor: Color(0xFF2563EB),
  inactiveColor: Color(0xFF9CA3AF),
  borderColor: Color(0xFF2563EB),
  borderWidth: 1,
)
```

## Number Style:

```dart
VPageIndicator.number(
  total: 5,
  current: 2,
  separator: VPageIndicatorSeparator.of,  // "2 of 5"
)
```

## Line Style (Instagram Stories):

```dart
VPageIndicator.line(
  total: 5,
  current: 2,
  lineHeight: 3,
  lineSpacing: 4,
)
```

## With Tap Interaction:

```dart
VPageIndicator.dots(
  total: 5,
  current: _currentPage,
  onPageChanged: (index) => _controller.jumpToPage(index),
)
```

See also:

- [VCarousel], carousel component
- [VPagination], list/table page navigation

### Constructors

#### `VPageIndicator.dots`

Dot style indicator.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `total` | `int` |  | yes | Number of pages. |
| `current` | `int` |  | yes | Current page index (zero-based). |
| `onPageChanged` | `void Function(int)?` |  |  | Called with the zero-based page the user taps; the widget is not interactive when null. |
| `size` | `double` | `8` |  | Diameter of an inactive dot. |
| `activeSize` | `double?` |  |  | Diameter of the active dot; [size] when null. |
| `spacing` | `double` | `6` |  | Gap between dots. |
| `activeColor` | `Color?` |  |  | Fill color of the active dot or lines up to the current page. |
| `inactiveColor` | `Color?` |  |  | Fill color of inactive dots and the lines after the current page. |
| `borderColor` | `Color?` |  |  | Border color of an inactive dot; its fill color when null. |
| `activeBorderColor` | `Color?` |  |  | Border color of the active dot; its fill color when null. |
| `borderWidth` | `double` | `0` |  | Border width of an inactive dot; 0 draws none. |
| `activeBorderWidth` | `double?` |  |  | Border width of the active dot; [borderWidth] when null. |
| `expandActive` | `bool` | `true` |  | Whether the active dot stretches into a pill. |
| `animationDuration` | `Duration` | `const Duration(milliseconds: 200)` |  | Duration of the active-page transition. |
| `style` | `VPageIndicatorThemeStyle?` |  |  | Overrides the theme's [VPageIndicatorThemeStyle] for this indicator. |

#### `VPageIndicator.number`

Number style indicator.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `total` | `int` |  | yes | Number of pages. |
| `current` | `int` |  | yes | Current page index (zero-based). |
| `onPageChanged` | `void Function(int)?` |  |  | Called with the zero-based page the user taps; the widget is not interactive when null. |
| `separator` | `VPageIndicatorSeparator` | `VPageIndicatorSeparator.slash` |  | Text drawn between the current page and the total. |
| `textStyle` | `TextStyle?` |  |  | Text style of the separator and the total; muted body text when null. |
| `activeTextStyle` | `TextStyle?` |  |  | Text style of the current page number; semibold body text when null. |
| `animationDuration` | `Duration` | `const Duration(milliseconds: 200)` |  | Duration of the active-page transition. |
| `style` | `VPageIndicatorThemeStyle?` |  |  | Overrides the theme's [VPageIndicatorThemeStyle] for this indicator. |

#### `VPageIndicator.line`

Line style indicator (Instagram Stories style).

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `total` | `int` |  | yes | Number of pages. |
| `current` | `int` |  | yes | Current page index (zero-based). |
| `onPageChanged` | `void Function(int)?` |  |  | Called with the zero-based page the user taps; the widget is not interactive when null. |
| `lineHeight` | `double` | `3` |  | Thickness of each line. |
| `lineSpacing` | `double` | `4` |  | Gap between lines. |
| `activeColor` | `Color?` |  |  | Fill color of the active dot or lines up to the current page. |
| `inactiveColor` | `Color?` |  |  | Fill color of inactive dots and the lines after the current page. |
| `animationDuration` | `Duration` | `const Duration(milliseconds: 200)` |  | Duration of the active-page transition. |
| `style` | `VPageIndicatorThemeStyle?` |  |  | Overrides the theme's [VPageIndicatorThemeStyle] for this indicator. |

## VPageIndicatorStyle

Look of a [VPageIndicator]: dots, a number or lines.

### Values

| Value | Description |
|---|---|
| `dots` | Dot style (● ○ ○ ○). |
| `number` | Number style (2 / 5). |
| `line` | Line style (━━━ ─── ───). |

## VPageIndicatorSeparator

Number style separator.

### Values

| Value | Description |
|---|---|
| `slash` | Slash (2 / 5). |
| `of` | of (2 of 5). |
| `dash` | Dash (2 - 5). |
| `pipe` | Pipe (2 \| 5). |

## VPageIndicatorThemeStyle

Style override for [VPageIndicator].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VPageIndicatorThemeStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `activeColor` | `Color?` |  |  | Active dot color. |
| `inactiveColor` | `Color?` |  |  | Inactive dot color. |
| `activeSize` | `double?` |  |  | Active dot size. |
| `inactiveSize` | `double?` |  |  | Inactive dot size. |

### Members

| Member | Description |
|---|---|
| `VPageIndicatorThemeStyle copyWith({Color? activeColor, Color? inactiveColor, double? activeSize, double? inactiveSize})` | Creates a copy with only the specified properties changed. |
