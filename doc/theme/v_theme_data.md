# v_theme_data

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VThemeData

Design tokens and overrides for one brightness.

Start from [VThemeData.light] or [VThemeData.dark], change tokens with
[copyWith], and blend two themes with [VThemeData.lerp].

```dart
final theme = VThemeData.light().copyWith(
  colors: VColors.light.copyWith(primary: const Color(0xFF0057D9)),
);
final halfway = VThemeData.lerp(VThemeData.light(), theme, 0.5);
```

### Constructors

#### `VThemeData`

Creates theme data from every token set.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `brightness` | `Brightness` |  | yes | Brightness mode (light / dark). |
| `colors` | `VColors` |  | yes | Color system. |
| `typography` | `VTypography` |  | yes | Typography system. |
| `spacing` | `VSpacing` |  | yes | Spacing system. |
| `radius` | `VRadius` |  | yes | Border radius system. |
| `shadows` | `VShadows` |  | yes | Shadow system. |
| `animations` | `VAnimations` |  | yes | Animation system. |
| `sizes` | `VSizes` |  | yes | Component size system. |
| `borders` | `VBorders` |  | yes | Border system. |
| `gradients` | `VGradients` |  | yes | Gradient system. |
| `componentOverrides` | `VComponentOverrides` | `VComponentOverrides.empty` |  | Component-level style overrides (Level 3 cascade). |

#### `VThemeData.light`

Volo brand theme - light mode (default).

#### `VThemeData.dark`

Volo brand theme - dark mode.

#### `VThemeData.lerp`

Interpolates between themes [a] and [b] at [t] from 0 to 1.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `a` | `VThemeData` |  | yes |  |
| `b` | `VThemeData` |  | yes |  |
| `t` | `double` |  | yes |  |

### Members

| Member | Description |
|---|---|
| `bool get isDark` | Whether the theme is dark mode. |
| `bool get isLight` | Whether the theme is light mode. |
| `VThemeData copyWith({Brightness? brightness, VColors? colors, VTypography? typography, VSpacing? spacing, VRadius? radius, VShadows? shadows, VAnimations? animations, VSizes? sizes, VBorders? borders, VGradients? gradients, VComponentOverrides? componentOverrides})` | Creates a copy with only the specified properties changed. |
