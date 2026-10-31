# v_theme

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VTheme

Provides [VThemeData] and localizations to descendants.

Read the data with [VTheme.of] and [VTheme.maybeOf].
```dart
VTheme(
  data: VThemeData.light(),
  child: MyApp(),
)
```

### Constructors

#### `VTheme`

Creates a theme that applies [data] to [child].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `data` | `VThemeData` |  | yes | Theme data that descendants read through [VTheme.of]. |
| `child` | `Widget` |  | yes |  |
| `localizations` | `VoloLocalizations` | `const VoloLocalizationsEn()` |  | Strings that widgets show or announce, English by default. |

### Members

| Member | Description |
|---|---|
| `static VThemeData of(BuildContext context)` | Retrieves the current theme data.<br>Throws an assert error if no VTheme is found. |
| `static VThemeData? maybeOf(BuildContext context)` | Retrieves the current theme data (nullable).<br>Returns null if no VTheme is found. |
| `static Widget merge({required VThemeData Function(VThemeData) overrides, required Widget child})` | Merges overrides into the nearest ancestor [VTheme].<br>Reads the current theme via [VTheme.of], applies [overrides], and wraps [child] with a new [VTheme] containing the result. |

## VThemeExtension

Shortcuts such as `context.vColors` for reading the theme.

```dart
final theme = context.vTheme;
final colors = context.vTheme.colors;
```

### Members

| Member | Description |
|---|---|
| `VThemeData get vTheme` | Current theme data. |
| `VColors get vColors` | Current theme colors (shortcut access). |
| `VTypography get vTypography` | Current theme typography (shortcut access). |
| `VSizes get vSizes` | Current theme sizes (shortcut access). |
| `VShadows get vShadows` | Current theme shadows (shortcut access). |
| `VSpacing get vSpacing` | Current theme spacing (shortcut access). |
| `VRadius get vRadius` | Current theme radius (shortcut access). |
| `VAnimations get vAnimations` | Current theme animations (shortcut access). |
| `VBorders get vBorders` | Current theme borders (shortcut access). |
| `VGradients get vGradients` | Current theme gradients (shortcut access). |
| `VoloLocalizations get vLocalizations` | Current localizations (shortcut access). |
