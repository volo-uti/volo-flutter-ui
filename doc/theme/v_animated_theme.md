# v_animated_theme

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## AnimatedVTheme

Animates a [VTheme] when its [data] changes.

Interpolates between theme data using [VThemeData.lerp] for
smooth transitions when theme changes.

## Basic Usage:

Animated theme switching:

```dart
AnimatedVTheme(
  data: isDark ? VThemeData.dark() : VThemeData.light(),
  duration: Duration(milliseconds: 300),
  child: MyApp(),
)
```

## Custom Curve:

With easing curve:

```dart
AnimatedVTheme(
  data: themeData,
  duration: Duration(milliseconds: 500),
  curve: Curves.easeInOut,
  child: MyApp(),
)
```

See also:

- [VTheme], the static theme provider
- [VThemeData], complete theme data with lerp support
- [VThemeDataTween], the tween used for interpolation

### Constructors

#### `AnimatedVTheme`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `data` | `VThemeData` |  | yes | The theme data to animate towards. |
| `child` | `Widget` |  | yes | The widget subtree that receives the animated theme. |
| `duration` | `Duration` | `const Duration(milliseconds: 200)` |  |  |
| `curve` | `Curve` | `Curves.linear` |  |  |
| `onEnd` | `void Function()?` |  |  |  |
| `localizations` | `VoloLocalizations?` |  |  | Strings for descendants; defaults to the enclosing theme's, else English. |

## VThemeDataTween

Tween that interpolates between two [VThemeData] values.

Uses [VThemeData.lerp] for smooth theme transitions.

```dart
final tween = VThemeDataTween(
  begin: VThemeData.light(),
  end: VThemeData.dark(),
);
final midTheme = tween.lerp(0.5);
```

### Constructors

#### `VThemeDataTween`

Creates a [VThemeDataTween].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `begin` | `VThemeData?` |  |  |  |
| `end` | `VThemeData?` |  |  |  |
