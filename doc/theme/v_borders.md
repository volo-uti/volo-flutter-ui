# v_borders

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VBorderStyle

Color and width of one border.

Defines a border with color and width.

### Constructors

#### `VBorderStyle`

Creates a border style.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `color` | `Color` |  | yes | Border color. |
| `width` | `double` |  | yes | Border width. |

#### `VBorderStyle.lerp`

Interpolates between two border styles.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `a` | `VBorderStyle` |  | yes |  |
| `b` | `VBorderStyle` |  | yes |  |
| `t` | `double` |  | yes |  |

## VBorders

Default, strong and subtle border styles.

Defines consistent border styles used throughout the app.

### Constructors

#### `VBorders`

Creates border tokens.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `defaultBorder` | `VBorderStyle` |  | yes | Default border (input, card edge). |
| `strong` | `VBorderStyle` |  | yes | Strong border (focus ring, emphasis). |
| `subtle` | `VBorderStyle` |  | yes | Subtle border (divider, separator). |

#### `VBorders.lerp`

Interpolates between two border systems (for animations).

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `a` | `VBorders` |  | yes |  |
| `b` | `VBorders` |  | yes |  |
| `t` | `double` |  | yes |  |

### Members

| Member | Description |
|---|---|
| `static VBorders light` | Light mode borders.<br>Values sourced from DTCG tokens via [VBordersDefaults]. |
| `static VBorders dark` | Dark mode borders.<br>Values sourced from DTCG tokens via [VBordersDefaults]. |
| `VBorders copyWith({VBorderStyle? defaultBorder, VBorderStyle? strong, VBorderStyle? subtle})` | Creates a copy with only the specified properties changed. |
