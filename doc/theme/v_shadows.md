# v_shadows

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VShadows

Elevation shadow scale from xs to glow.

Defines consistent shadow styles used throughout the app.
Uses a 6-level scale: xs, sm, md, lg, xl, glow.

### Constructors

#### `VShadows`

Creates shadow tokens.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `xs` | `List<BoxShadow>` |  | yes | Extra-small shadow (blur: 2px, offset: 0,1). |
| `sm` | `List<BoxShadow>` |  | yes | Small shadow (blur: 4px, offset: 0,2). |
| `md` | `List<BoxShadow>` |  | yes | Medium shadow (blur: 8px, offset: 0,4). |
| `lg` | `List<BoxShadow>` |  | yes | Large shadow (blur: 16px, offset: 0,8). |
| `xl` | `List<BoxShadow>` |  | yes | Extra-large shadow (blur: 24px, offset: 0,12). |
| `glow` | `List<BoxShadow>` |  | yes | Emphasis glow effect (blur: 20px, offset: 0,0). |

#### `VShadows.lerp`

Interpolates between two shadow systems (for animations).

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `a` | `VShadows` |  | yes |  |
| `b` | `VShadows` |  | yes |  |
| `t` | `double` |  | yes |  |

### Members

| Member | Description |
|---|---|
| `static VShadows light` | Light mode shadows.<br>Values sourced from DTCG tokens via [VShadowsDefaults]. |
| `static VShadows dark` | Dark mode shadows.<br>Values sourced from DTCG tokens via [VShadowsDefaults]. |
| `VShadows copyWith({List<BoxShadow>? xs, List<BoxShadow>? sm, List<BoxShadow>? md, List<BoxShadow>? lg, List<BoxShadow>? xl, List<BoxShadow>? glow})` | Creates a copy with only the specified properties changed. |
