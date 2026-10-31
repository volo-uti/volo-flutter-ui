# v_typography

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VTypography

Font families and the Material 3 text style scale.

Defines text styles used throughout the app.
Based on the Material Design 3 type scale.

### Constructors

#### `VTypography`

Creates typography tokens.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `displayLarge` | `TextStyle` |  | yes | Display large (57px, Bold). |
| `displayMedium` | `TextStyle` |  | yes | Display medium (45px, Bold). |
| `displaySmall` | `TextStyle` |  | yes | Display small (36px, Bold). |
| `headlineLarge` | `TextStyle` |  | yes | Headline large (32px, Bold). |
| `headlineMedium` | `TextStyle` |  | yes | Headline medium (28px, Bold) - page title. |
| `headlineSmall` | `TextStyle` |  | yes | Headline small (24px, SemiBold) - section title. |
| `titleLarge` | `TextStyle` |  | yes | Title large (22px, SemiBold) - card title. |
| `titleMedium` | `TextStyle` |  | yes | Title medium (16px, SemiBold) - subtitle. |
| `titleSmall` | `TextStyle` |  | yes | Title small (14px, SemiBold) - label. |
| `bodyLarge` | `TextStyle` |  | yes | Body large (16px, Regular). |
| `bodyMedium` | `TextStyle` |  | yes | Body medium (14px, Regular) - default text. |
| `bodySmall` | `TextStyle` |  | yes | Body small (12px, Regular) - secondary text. |
| `labelLarge` | `TextStyle` |  | yes | Label large (14px, Medium) - button text. |
| `labelMedium` | `TextStyle` |  | yes | Label medium (12px, Medium) - badge text. |
| `labelSmall` | `TextStyle` |  | yes | Label small (11px, Medium) - caption. |
| `fontFamily` | `String?` |  |  | Default font family.<br>When `null`, Flutter uses the platform's default system font. |
| `fontFamilyMono` | `String?` |  |  | Monospace font family (for code and numbers).<br>When `null`, Flutter uses the platform's default monospace font. |

#### `VTypography.lerp`

Interpolates between two typographies (for animations).

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `a` | `VTypography` |  | yes |  |
| `b` | `VTypography` |  | yes |  |
| `t` | `double` |  | yes |  |

### Members

| Member | Description |
|---|---|
| `static VTypography defaults` | Default typography values.<br>[fontFamily] and [fontFamilyMono] are null (platform default system font). TextStyle values are sourced from DTCG tokens via [VTypographyDefaults]. |
| `VTypography copyWith({String? fontFamily, String? fontFamilyMono, TextStyle? displayLarge, TextStyle? displayMedium, TextStyle? displaySmall, TextStyle? headlineLarge, TextStyle? headlineMedium, TextStyle? headlineSmall, TextStyle? titleLarge, TextStyle? titleMedium, TextStyle? titleSmall, TextStyle? bodyLarge, TextStyle? bodyMedium, TextStyle? bodySmall, TextStyle? labelLarge, TextStyle? labelMedium, TextStyle? labelSmall})` | Creates a copy with only the specified properties changed. |
