# VDivider

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VDivider

Thin horizontal or vertical line that separates groups of content.

[VDivider.bold] doubles the thickness, [VDivider.dashed] draws dashes and
[VDivider.label] centers a label between two lines.

```dart
Column(
  children: [
    Text('Account'),
    VDivider(indent: 16),
    VDivider.label(Text('or')),
  ],
)
```

### Constructors

#### `VDivider`

Line of the given [thickness], 1px by default.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `direction` | `Axis` | `Axis.horizontal` |  | Axis the line runs along. |
| `thickness` | `double` | `1` |  | Line thickness in logical pixels. |
| `color` | `Color?` |  |  | Line color; falls back to the border color of the theme. |
| `indent` | `double` | `0` |  | Empty space before the line. |
| `endIndent` | `double` | `0` |  | Empty space after the line. |
| `style` | `VDividerStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VDivider.bold`

Line 2px thick.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `direction` | `Axis` | `Axis.horizontal` |  | Axis the line runs along. |
| `color` | `Color?` |  |  | Line color; falls back to the border color of the theme. |
| `indent` | `double` | `0` |  | Empty space before the line. |
| `endIndent` | `double` | `0` |  | Empty space after the line. |
| `style` | `VDividerStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VDivider.dashed`

Dashed line.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `direction` | `Axis` | `Axis.horizontal` |  | Axis the line runs along. |
| `thickness` | `double` | `1` |  | Line thickness in logical pixels. |
| `color` | `Color?` |  |  | Line color; falls back to the border color of the theme. |
| `indent` | `double` | `0` |  | Empty space before the line. |
| `endIndent` | `double` | `0` |  | Empty space after the line. |
| `style` | `VDividerStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VDivider.label`

Horizontal line interrupted by a centered [label].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `Widget?` |  | yes | Widget centered between the two lines of [VDivider.label]. |
| `thickness` | `double` | `1` |  | Line thickness in logical pixels. |
| `color` | `Color?` |  |  | Line color; falls back to the border color of the theme. |
| `style` | `VDividerStyle?` |  |  | Per-instance style override merged over the theme style. |

### Members

| Member | Description |
|---|---|
| `static double kDashWidth` | Length of one dash of [VDivider.dashed]. |
| `static double kDashSpace` | Gap between two dashes of [VDivider.dashed]. |

## VDividerStyle

Style override for [VDivider].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VDividerStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `color` | `Color?` |  |  | Divider color. |
| `thickness` | `double?` |  |  | Divider thickness. |
| `indent` | `double?` |  |  | Indent from the edges. |

### Members

| Member | Description |
|---|---|
| `VDividerStyle copyWith({Color? color, double? thickness, double? indent})` | Creates a copy with only the specified properties changed. |
