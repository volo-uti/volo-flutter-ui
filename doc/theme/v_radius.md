# v_radius

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VRadius

Corner radius scale from none to full.

Defines consistent border radius values used throughout the app.

### Constructors

#### `VRadius`

Creates radius tokens.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `none` | `double` |  | yes | 0px - Square corners. |
| `xs` | `double` |  | yes | 2px - Extra small elements (select item, tag). |
| `sm` | `double` |  | yes | 4px - Small elements (badge, chip). |
| `md` | `double` |  | yes | 8px - Medium elements (button, input). |
| `lg` | `double` |  | yes | 12px - Large elements (modal). |
| `card` | `double` |  | yes | 16px - Card. |
| `xl` | `double` |  | yes | 20px - Extra large (pill tabs, large containers). |
| `full` | `double` |  | yes | 9999px - Fully rounded (avatar, switch). |

#### `VRadius.lerp`

Interpolates between two radius systems (for animations).

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `a` | `VRadius` |  | yes |  |
| `b` | `VRadius` |  | yes |  |
| `t` | `double` |  | yes |  |

### Members

| Member | Description |
|---|---|
| `static VRadius defaults` | Default radius values.<br>Values sourced from DTCG tokens via [VRadiusDefaults]. |
| `BorderRadius get noneRadius` | Returns BorderRadius.circular(none). |
| `BorderRadius get xsRadius` | Returns BorderRadius.circular(xs). |
| `BorderRadius get smRadius` | Returns BorderRadius.circular(sm). |
| `BorderRadius get mdRadius` | Returns BorderRadius.circular(md). |
| `BorderRadius get lgRadius` | Returns BorderRadius.circular(lg). |
| `BorderRadius get cardRadius` | Returns BorderRadius.circular(card). |
| `BorderRadius get xlRadius` | Returns BorderRadius.circular(xl). |
| `BorderRadius get fullRadius` | Returns BorderRadius.circular(full). |
| `VRadius copyWith({double? none, double? xs, double? sm, double? md, double? lg, double? card, double? xl, double? full})` | Creates a copy with only the specified properties changed. |
