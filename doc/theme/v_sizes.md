# v_sizes

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VComponentSize

Height, padding, font and icon size of one size step.

Defines height, padding, font size, icon size, and spacing for each component.

### Constructors

#### `VComponentSize`

Creates a size step.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `height` | `double` |  | yes | Component height. |
| `paddingHorizontal` | `double` |  | yes | Horizontal padding. |
| `paddingVertical` | `double` |  | yes | Vertical padding. |
| `fontSize` | `double` |  | yes | Font size. |
| `iconSize` | `double` |  | yes | Icon size. |
| `spacing` | `double` |  | yes | Spacing between elements. |
| `borderRadius` | `double` |  | yes | Border radius. |

#### `VComponentSize.lerp`

Interpolates between two sizes (for animations).

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `a` | `VComponentSize` |  | yes |  |
| `b` | `VComponentSize` |  | yes |  |
| `t` | `double` |  | yes |  |

### Members

| Member | Description |
|---|---|
| `EdgeInsets get padding` | Returns padding as EdgeInsets. |
| `VComponentSize copyWith({double? height, double? paddingHorizontal, double? paddingVertical, double? fontSize, double? iconSize, double? spacing, double? borderRadius})` | Creates a copy with only the specified properties changed. |

## VSizes

Component size steps from xs to xl.

Provides five sizes: xs, sm, md (default), lg, xl.

### Constructors

#### `VSizes`

Creates size tokens.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `xs` | `VComponentSize` |  | yes | Extra small size (height: 24px). |
| `sm` | `VComponentSize` |  | yes | Small size (height: 32px). |
| `md` | `VComponentSize` |  | yes | Medium size (height: 40px) - default. |
| `lg` | `VComponentSize` |  | yes | Large size (height: 48px). |
| `xl` | `VComponentSize` |  | yes | Extra large size (height: 56px). |

#### `VSizes.lerp`

Interpolates between two size systems (for animations).

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `a` | `VSizes` |  | yes |  |
| `b` | `VSizes` |  | yes |  |
| `t` | `double` |  | yes |  |

### Members

| Member | Description |
|---|---|
| `static VSizes defaults` | Default size values.<br>Values sourced from DTCG tokens via [VSizesDefaults]. |
| `VSizes copyWith({VComponentSize? xs, VComponentSize? sm, VComponentSize? md, VComponentSize? lg, VComponentSize? xl})` | Creates a copy with only the specified properties changed. |
