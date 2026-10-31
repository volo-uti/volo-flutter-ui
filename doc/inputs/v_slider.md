# VSlider

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VSlider

Draggable slider for one value, or two with [VSlider.range].

Supports tap-to-jump, keyboard steps and optional [divisions]. Without a
change callback the slider is disabled.

```dart
VSlider(
  value: volume,
  onChanged: (value) => setState(() => volume = value),
)
```

### Constructors

#### `VSlider`

Creates a slider for a single [value].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `double` |  | yes | Current value of a single slider; unused by [VSlider.range]. |
| `name` | `String?` |  |  | Key identifying this slider in debug logs. |
| `onChanged` | `void Function(double)?` |  |  | Called with the new value while a single slider moves. |
| `onChangeStart` | `void Function(double)?` |  |  | Called with the grabbed thumb's value when a drag starts. |
| `onChangeEnd` | `void Function(double)?` |  |  | Called with the released thumb's value when a drag ends. |
| `min` | `double` | `0.0` |  | Lowest selectable value. |
| `max` | `double` | `100.0` |  | Highest selectable value. |
| `divisions` | `int?` |  |  | Number of equal steps between [min] and [max]; continuous when `null`. |
| `showLabel` | `bool` | `false` |  | Whether a bubble with the current value is drawn above each thumb. |
| `enabled` | `bool` | `true` |  | Whether the slider reacts to input. |
| `style` | `VSliderStyle?` |  |  | Style override merged over the theme's [VSliderStyle]. |

#### `VSlider.range`

Creates a slider with two thumbs selecting [values].

```dart
VSlider.range(
  values: RangeValues(20, 80),
  onRangeChanged: (values) {},
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `values` | `RangeValues` |  | yes |  |
| `name` | `String?` |  |  | Key identifying this slider in debug logs. |
| `onRangeChanged` | `void Function(RangeValues)?` |  |  | Called with the new range while a [VSlider.range] moves. |
| `onChangeStart` | `void Function(double)?` |  |  | Called with the grabbed thumb's value when a drag starts. |
| `onChangeEnd` | `void Function(double)?` |  |  | Called with the released thumb's value when a drag ends. |
| `min` | `double` | `0.0` |  | Lowest selectable value. |
| `max` | `double` | `100.0` |  | Highest selectable value. |
| `divisions` | `int?` |  |  | Number of equal steps between [min] and [max]; continuous when `null`. |
| `showLabel` | `bool` | `false` |  | Whether a bubble with the current value is drawn above each thumb. |
| `enabled` | `bool` | `true` |  | Whether the slider reacts to input. |
| `style` | `VSliderStyle?` |  |  | Style override merged over the theme's [VSliderStyle]. |

### Members

| Member | Description |
|---|---|
| `RangeValues? rangeValues` | Selected range of a [VSlider.range]; `null` for a single slider. |

## RangeValues

Start and end of the range selected by [VSlider.range].

### Constructors

#### `RangeValues`

Creates a range from [start] to [end].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `start` | `double` |  | yes | Lower bound of the range. |
| `end` | `double` |  | yes | Upper bound of the range. |

## VSliderStyle

Style override for [VSlider].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VSliderStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `activeColor` | `Color?` |  |  | Active track color. |
| `inactiveColor` | `Color?` |  |  | Inactive track color. |
| `thumbColor` | `Color?` |  |  | Thumb color. |
| `trackHeight` | `double?` |  |  | Track height. |

### Members

| Member | Description |
|---|---|
| `VSliderStyle copyWith({Color? activeColor, Color? inactiveColor, Color? thumbColor, double? trackHeight})` | Creates a copy with only the specified properties changed. |
