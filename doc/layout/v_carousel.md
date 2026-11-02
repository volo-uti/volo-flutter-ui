# VCarousel

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VCarousel

Swipeable slides with indicator, auto-play and arrow keys.

A [PageView] of [children] that also pages by tapping a slide, by the
indicator dots and by Left, Right, Home and End. [onPageChanged] reports
the visible slide. With [loop] false, auto-play and arrow keys stop at the
last slide.

## Basic Usage:

Default carousel (80% viewport):

```dart
VCarousel(
  height: 200,
  children: [
    Image.network('https://example.com/image1.jpg'),
    Image.network('https://example.com/image2.jpg'),
    Image.network('https://example.com/image3.jpg'),
  ],
)
```

## Variants:

- [VCarousel.new] - Default carousel (80% viewport, peek on both sides)
- [VCarousel.fullWidth] - Full width carousel (100% viewport)
- [VCarousel.card] - Card gallery carousel (85% viewport)
- [VCarousel.hero] - Hero banner carousel (auto-play, loop)

## Full Width Banner:

Full width banner carousel:

```dart
VCarousel.fullWidth(
  height: 300,
  autoPlay: true,
  loop: true,
  children: [
    Container(color: Colors.red),
    Container(color: Colors.green),
    Container(color: Colors.blue),
  ],
)
```

## Hero Banner:

Auto-playing hero banner:

```dart
VCarousel.hero(
  height: 250,
  autoPlayInterval: Duration(seconds: 5),
  children: [
    Image.network('https://example.com/hero1.jpg', fit: BoxFit.cover),
    Image.network('https://example.com/hero2.jpg', fit: BoxFit.cover),
  ],
)
```

## Custom Indicator:

```dart
VCarousel(
  height: 200,
  indicatorBuilder: (context, total, current) {
    return VPageIndicator.number(
      total: total,
      current: current,
    );
  },
  children: [...],
)
```

See also:

- [VCarouselIndicatorPosition], indicator position options
- [VPageIndicator], custom indicator
- [PageController], controller for page control
- [VCarouselIndicatorBuilder], signature of [indicatorBuilder]

### Constructors

#### `VCarousel`

Default carousel (80% viewport).

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Slides, one per page; an empty list renders nothing. |
| `controller` | `PageController?` |  |  | Controls the visible page; the carousel creates its own when null. |
| `onPageChanged` | `void Function(int)?` |  |  | Called with the zero-based index when the visible slide changes. |
| `autoPlay` | `bool` | `false` |  | Whether slides advance on their own every [autoPlayInterval]. |
| `autoPlayInterval` | `Duration` | `const Duration(seconds: 3)` |  | Time between automatic slide changes. |
| `height` | `double?` |  |  | Fixed height; wins over [aspectRatio] and defaults to 200 when both are null. |
| `aspectRatio` | `double?` |  |  | Width divided by height, used when [height] is null. |
| `viewportFraction` | `double` | `0.8` |  | Share of the width one slide takes; below 1 the neighbours peek in. |
| `padEnds` | `bool` | `true` |  | Whether the first and last slide are centered by padding the ends. |
| `showIndicator` | `bool` | `true` |  | Whether the page indicator is shown. |
| `indicatorPosition` | `VCarouselIndicatorPosition` | `VCarouselIndicatorPosition.bottom` |  | Where the page indicator is drawn. |
| `indicatorBuilder` | `Widget Function(BuildContext, int, int)?` |  |  | Builds the page indicator instead of the default dots.<br>If not provided, default [VPageIndicator.dots] is used. |
| `loop` | `bool` | `false` |  | Whether auto-play and arrow keys wrap from the last slide to the first. |
| `pageSpacing` | `double` | `8` |  | Horizontal gap between slides. |
| `style` | `VCarouselStyle?` |  |  | Overrides the theme style, for example the indicator colors. |

#### `VCarousel.fullWidth`

Full width carousel (100% viewport).

Uses full width without peek on sides.

```dart
VCarousel.fullWidth(
  height: 300,
  children: bannerWidgets,
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Slides, one per page; an empty list renders nothing. |
| `controller` | `PageController?` |  |  | Controls the visible page; the carousel creates its own when null. |
| `onPageChanged` | `void Function(int)?` |  |  | Called with the zero-based index when the visible slide changes. |
| `autoPlay` | `bool` | `false` |  | Whether slides advance on their own every [autoPlayInterval]. |
| `autoPlayInterval` | `Duration` | `const Duration(seconds: 3)` |  | Time between automatic slide changes. |
| `height` | `double?` |  |  | Fixed height; wins over [aspectRatio] and defaults to 200 when both are null. |
| `aspectRatio` | `double?` |  |  | Width divided by height, used when [height] is null. |
| `showIndicator` | `bool` | `true` |  | Whether the page indicator is shown. |
| `indicatorPosition` | `VCarouselIndicatorPosition` | `VCarouselIndicatorPosition.bottom` |  | Where the page indicator is drawn. |
| `indicatorBuilder` | `Widget Function(BuildContext, int, int)?` |  |  | Builds the page indicator instead of the default dots.<br>If not provided, default [VPageIndicator.dots] is used. |
| `loop` | `bool` | `false` |  | Whether auto-play and arrow keys wrap from the last slide to the first. |
| `pageSpacing` | `double` | `0` |  | Horizontal gap between slides. |
| `style` | `VCarouselStyle?` |  |  | Overrides the theme style, for example the indicator colors. |

#### `VCarousel.card`

Card gallery carousel (85% viewport).

Next/previous cards are slightly visible on both sides.

```dart
VCarousel.card(
  height: 200,
  children: cardWidgets,
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Slides, one per page; an empty list renders nothing. |
| `controller` | `PageController?` |  |  | Controls the visible page; the carousel creates its own when null. |
| `onPageChanged` | `void Function(int)?` |  |  | Called with the zero-based index when the visible slide changes. |
| `autoPlay` | `bool` | `false` |  | Whether slides advance on their own every [autoPlayInterval]. |
| `autoPlayInterval` | `Duration` | `const Duration(seconds: 3)` |  | Time between automatic slide changes. |
| `height` | `double?` |  |  | Fixed height; wins over [aspectRatio] and defaults to 200 when both are null. |
| `aspectRatio` | `double?` |  |  | Width divided by height, used when [height] is null. |
| `showIndicator` | `bool` | `true` |  | Whether the page indicator is shown. |
| `indicatorPosition` | `VCarouselIndicatorPosition` | `VCarouselIndicatorPosition.bottom` |  | Where the page indicator is drawn. |
| `indicatorBuilder` | `Widget Function(BuildContext, int, int)?` |  |  | Builds the page indicator instead of the default dots.<br>If not provided, default [VPageIndicator.dots] is used. |
| `loop` | `bool` | `false` |  | Whether auto-play and arrow keys wrap from the last slide to the first. |
| `pageSpacing` | `double` | `12` |  | Horizontal gap between slides. |
| `style` | `VCarouselStyle?` |  |  | Overrides the theme style, for example the indicator colors. |

#### `VCarousel.hero`

Hero banner carousel.

Auto-play and infinite loop are enabled by default.
Overlay indicator is displayed.

```dart
VCarousel.hero(
  height: 250,
  children: heroImages,
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Slides, one per page; an empty list renders nothing. |
| `controller` | `PageController?` |  |  | Controls the visible page; the carousel creates its own when null. |
| `onPageChanged` | `void Function(int)?` |  |  | Called with the zero-based index when the visible slide changes. |
| `autoPlay` | `bool` | `true` |  | Whether slides advance on their own every [autoPlayInterval]. |
| `autoPlayInterval` | `Duration` | `const Duration(seconds: 5)` |  | Time between automatic slide changes. |
| `height` | `double?` |  |  | Fixed height; wins over [aspectRatio] and defaults to 200 when both are null. |
| `aspectRatio` | `double?` |  |  | Width divided by height, used when [height] is null. |
| `showIndicator` | `bool` | `true` |  | Whether the page indicator is shown. |
| `indicatorPosition` | `VCarouselIndicatorPosition` | `VCarouselIndicatorPosition.overlay` |  | Where the page indicator is drawn. |
| `indicatorBuilder` | `Widget Function(BuildContext, int, int)?` |  |  | Builds the page indicator instead of the default dots.<br>If not provided, default [VPageIndicator.dots] is used. |
| `loop` | `bool` | `true` |  | Whether auto-play and arrow keys wrap from the last slide to the first. |
| `pageSpacing` | `double` | `0` |  | Horizontal gap between slides. |
| `style` | `VCarouselStyle?` |  |  | Overrides the theme style, for example the indicator colors. |

## VCarouselIndicatorBuilder

Builds a custom page indicator for [VCarousel].

[total] is the slide count and [current] the zero-based visible slide.

```dart
typedef VCarouselIndicatorBuilder = Widget Function(BuildContext, int, int);
```

## VCarouselIndicatorPosition

Where [VCarousel] draws its page indicator.

### Values

| Value | Description |
|---|---|
| `bottom` | Bottom inside the carousel. |
| `belowCarousel` | Below the carousel. |
| `overlay` | Overlay on the carousel. |
| `none` | Hidden. |

## VCarouselStyle

Style override for [VCarousel].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VCarouselStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Fill behind each slide; none when null.<br>It shows around a slide child that does not fill its page. An instance style wins over the theme override. |
| `borderRadius` | `BorderRadius?` |  |  | Corner radius each slide is clipped to; square when null.<br>[VCarousel.pageSpacing] stays outside the clip. An instance style wins over the theme override. |
| `indicatorActiveColor` | `Color?` |  |  | Active indicator dot color. |
| `indicatorInactiveColor` | `Color?` |  |  | Inactive indicator dot color. |

### Members

| Member | Description |
|---|---|
| `VCarouselStyle copyWith({Color? backgroundColor, BorderRadius? borderRadius, Color? indicatorActiveColor, Color? indicatorInactiveColor})` | Creates a copy with only the specified properties changed. |
