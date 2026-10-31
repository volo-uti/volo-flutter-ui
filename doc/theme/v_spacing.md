# v_spacing

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VSpacing

Spacing scale on a 4px base grid.

Defines consistent spacing values used throughout the app.
Uses 4px as the base unit.

### Constructors

#### `VSpacing`

Creates spacing tokens.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `xxs` | `double` |  | yes | 2px - Fine adjustment within icons. |
| `xs` | `double` |  | yes | 4px - Extra small spacing. |
| `sm` | `double` |  | yes | 8px - Default spacing between elements. |
| `md` | `double` |  | yes | 12px - Card inner spacing. |
| `lg` | `double` |  | yes | 16px - Default spacing between sections. |
| `xl` | `double` |  | yes | 20px - Spacing between large elements. |
| `xxl` | `double` |  | yes | 24px - Page padding. |
| `xxxl` | `double` |  | yes | 32px - Section separator. |
| `fourXL` | `double` |  | yes | 40px - 4xl spacing. |
| `fiveXL` | `double` |  | yes | 48px - 5xl spacing. |
| `sixXL` | `double` |  | yes | 64px - 6xl spacing. |

#### `VSpacing.lerp`

Interpolates between two spacing systems (for animations).

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `a` | `VSpacing` |  | yes |  |
| `b` | `VSpacing` |  | yes |  |
| `t` | `double` |  | yes |  |

### Members

| Member | Description |
|---|---|
| `static VSpacing defaults` | Default spacing values.<br>Values sourced from DTCG tokens via [VSpacingDefaults]. |
| `VSpacing copyWith({double? xxs, double? xs, double? sm, double? md, double? lg, double? xl, double? xxl, double? xxxl, double? fourXL, double? fiveXL, double? sixXL})` | Creates a copy with only the specified properties changed. |
