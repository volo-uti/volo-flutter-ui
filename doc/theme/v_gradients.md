# v_gradients

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VGradients

Brand and surface gradients.

Defines consistent gradient styles used throughout the app.

### Constructors

#### `VGradients`

Creates gradient tokens.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `brand` | `LinearGradient` |  | yes | Brand gradient (indigo to cyan, for hero sections). |
| `surface` | `LinearGradient` |  | yes | Surface gradient (subtle background variation). |

#### `VGradients.lerp`

Interpolates between two gradient systems (for animations).

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `a` | `VGradients` |  | yes |  |
| `b` | `VGradients` |  | yes |  |
| `t` | `double` |  | yes |  |

### Members

| Member | Description |
|---|---|
| `static VGradients defaults` | Default gradients.<br>Values sourced from DTCG tokens via [VGradientsDefaults]. |
| `VGradients copyWith({LinearGradient? brand, LinearGradient? surface})` | Creates a copy with only the specified properties changed. |
