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
| `displayLarge` | `TextStyle` |  | yes |  |
| `displayMedium` | `TextStyle` |  | yes |  |
| `displaySmall` | `TextStyle` |  | yes |  |
| `headlineLarge` | `TextStyle` |  | yes |  |
| `headlineMedium` | `TextStyle` |  | yes |  |
| `headlineSmall` | `TextStyle` |  | yes |  |
| `titleLarge` | `TextStyle` |  | yes |  |
| `titleMedium` | `TextStyle` |  | yes |  |
| `titleSmall` | `TextStyle` |  | yes |  |
| `bodyLarge` | `TextStyle` |  | yes |  |
| `bodyMedium` | `TextStyle` |  | yes |  |
| `bodySmall` | `TextStyle` |  | yes |  |
| `labelLarge` | `TextStyle` |  | yes |  |
| `labelMedium` | `TextStyle` |  | yes |  |
| `labelSmall` | `TextStyle` |  | yes |  |
| `fontFamily` | `String?` |  |  | Default font family.<br>Every text style of this typography and every text under the theme that names no family of its own uses it. When `null`, Flutter uses the platform's default system font. |
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
| `TextStyle get displayLarge` | Display large (57px, Bold). |
| `TextStyle get displayMedium` | Display medium (45px, Bold). |
| `TextStyle get displaySmall` | Display small (36px, Bold). |
| `TextStyle get headlineLarge` | Headline large (32px, Bold). |
| `TextStyle get headlineMedium` | Headline medium (28px, Bold) - page title. |
| `TextStyle get headlineSmall` | Headline small (24px, SemiBold) - section title. |
| `TextStyle get titleLarge` | Title large (22px, SemiBold) - card title. |
| `TextStyle get titleMedium` | Title medium (16px, SemiBold) - subtitle. |
| `TextStyle get titleSmall` | Title small (14px, SemiBold) - label. |
| `TextStyle get bodyLarge` | Body large (16px, Regular). |
| `TextStyle get bodyMedium` | Body medium (14px, Regular) - default text. |
| `TextStyle get bodySmall` | Body small (12px, Regular) - secondary text. |
| `TextStyle get labelLarge` | Label large (14px, Medium) - button text. |
| `TextStyle get labelMedium` | Label medium (12px, Medium) - badge text. |
| `TextStyle get labelSmall` | Label small (11px, Medium) - caption. |
| `VTypography copyWith({String? fontFamily, String? fontFamilyMono, TextStyle? displayLarge, TextStyle? displayMedium, TextStyle? displaySmall, TextStyle? headlineLarge, TextStyle? headlineMedium, TextStyle? headlineSmall, TextStyle? titleLarge, TextStyle? titleMedium, TextStyle? titleSmall, TextStyle? bodyLarge, TextStyle? bodyMedium, TextStyle? bodySmall, TextStyle? labelLarge, TextStyle? labelMedium, TextStyle? labelSmall})` | Creates a copy with only the specified properties changed. |
