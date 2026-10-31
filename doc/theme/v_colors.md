# v_colors

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VColors

Semantic color roles for one brightness.

Defines semantic colors used throughout the app.
Each color is categorized by its purpose.

### Constructors

#### `VColors`

Creates a color set.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `background` | `Color` |  | yes | Page background color. |
| `foreground` | `Color` |  | yes | Default text color. |
| `primary` | `Color` |  | yes | Primary action color (main CTA). |
| `primaryForeground` | `Color` |  | yes | Text color on primary. |
| `secondary` | `Color` |  | yes | Secondary action color. |
| `secondaryForeground` | `Color` |  | yes | Text color on secondary. |
| `tertiary` | `Color` |  | yes | Tertiary action color. |
| `tertiaryForeground` | `Color` |  | yes | Text color on tertiary. |
| `muted` | `Color` |  | yes | Muted area color (background, placeholder). |
| `mutedForeground` | `Color` |  | yes | Muted text color (hint, supplementary text). |
| `accent` | `Color` |  | yes | Accent color (hover, selected state). |
| `accentForeground` | `Color` |  | yes | Text color on accent. |
| `destructive` | `Color` |  | yes | Destructive action color (delete, warning). |
| `destructiveForeground` | `Color` |  | yes | Text color on destructive. |
| `success` | `Color` |  | yes | Success status color. |
| `successForeground` | `Color` |  | yes | Text color on success. |
| `warning` | `Color` |  | yes | Warning status color. |
| `warningForeground` | `Color` |  | yes | Text color on warning. |
| `error` | `Color` |  | yes | Error status color. |
| `errorForeground` | `Color` |  | yes | Text color on error. |
| `info` | `Color` |  | yes | Info status color. |
| `infoForeground` | `Color` |  | yes | Text color on info. |
| `border` | `Color` |  | yes | Default border color. |
| `input` | `Color` |  | yes | Input field border color. |
| `ring` | `Color` |  | yes | Focus ring color. |
| `card` | `Color` |  | yes | Card background color. |
| `cardForeground` | `Color` |  | yes | Card text color. |
| `popover` | `Color` |  | yes | Popover background color. |
| `popoverForeground` | `Color` |  | yes | Popover text color. |
| `disabled` | `Color` |  | yes | Disabled element color. |
| `disabledForeground` | `Color` |  | yes | Text color on disabled. |
| `scrim` | `Color` |  | yes | Modal/dialog backdrop overlay color. |

#### `VColors.lerp`

Interpolates between two color systems (for animations).

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `a` | `VColors` |  | yes |  |
| `b` | `VColors` |  | yes |  |
| `t` | `double` |  | yes |  |

### Members

| Member | Description |
|---|---|
| `static Color transparent` | Fully transparent color.<br>Use instead of `Color(0x00000000)` for consistency and token compliance. |
| `static VColors light` | Light mode colors.<br>Values sourced from DTCG tokens via [VColorsDefaults]. |
| `static VColors dark` | Dark mode colors.<br>Values sourced from DTCG tokens via [VColorsDefaults]. |
| `VColors copyWith({Color? background, Color? foreground, Color? primary, Color? primaryForeground, Color? secondary, Color? secondaryForeground, Color? tertiary, Color? tertiaryForeground, Color? muted, Color? mutedForeground, Color? accent, Color? accentForeground, Color? destructive, Color? destructiveForeground, Color? success, Color? successForeground, Color? warning, Color? warningForeground, Color? error, Color? errorForeground, Color? info, Color? infoForeground, Color? border, Color? input, Color? ring, Color? card, Color? cardForeground, Color? popover, Color? popoverForeground, Color? disabled, Color? disabledForeground, Color? scrim})` | Creates a copy with only the specified properties changed. |
