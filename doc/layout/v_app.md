# VApp

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VApp

App root with [VTheme] that follows system brightness.

Use it instead of `MaterialApp` so descendants can read tokens through
[VTheme.of]. [themeMode] picks between [theme] and [darkTheme]; Navigator,
routes and locale are passed through to [WidgetsApp].

## Basic Usage:

```dart
VApp(
  home: MyHomePage(),
)
```

## With Themes:

Custom light/dark themes:

```dart
VApp(
  theme: VThemeData.light().copyWith(
    colors: myBrandColors,
  ),
  darkTheme: VThemeData.dark().copyWith(
    colors: myBrandDarkColors,
  ),
  themeMode: VAppThemeMode.system,
  home: MyHomePage(),
)
```

## With Router:

Named routes:

```dart
VApp(
  initialRoute: '/home',
  routes: {
    '/home': (context) => HomePage(),
    '/settings': (context) => SettingsPage(),
  },
)
```

See also:

- [VTheme], theme provider InheritedWidget
- [VThemeData], complete theme data
- [VAppThemeMode], theme mode options

### Constructors

#### `VApp`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `home` | `Widget?` |  |  | The widget for the default route of the app. |
| `theme` | `VThemeData?` |  |  | The light theme data.<br>Defaults to [VThemeData.light] if not provided. |
| `darkTheme` | `VThemeData?` |  |  | The dark theme data.<br>Defaults to [VThemeData.dark] if not provided. |
| `themeMode` | `VAppThemeMode` | `VAppThemeMode.system` |  | Determines which theme to use.<br>Defaults to [VAppThemeMode.system]. |
| `title` | `String` | `''` |  | A one-line description used by the device to identify the app. |
| `debugShowCheckedModeBanner` | `bool` | `false` |  | Whether to show the debug banner. |
| `navigatorKey` | `GlobalKey<NavigatorState>?` |  |  | A key for the [Navigator]. |
| `builder` | `Widget Function(BuildContext, Widget?)?` |  |  | A builder that wraps the entire widget tree. |
| `onGenerateRoute` | `Route<dynamic>? Function(RouteSettings)?` |  |  | Route generation callback. |
| `onUnknownRoute` | `Route<dynamic>? Function(RouteSettings)?` |  |  | Unknown route callback. |
| `initialRoute` | `String?` |  |  | The name of the first route to show. |
| `routes` | `Map<String, Widget Function(BuildContext)>` | `const <String, WidgetBuilder>{}` |  | The application's top-level routing table. |
| `navigatorObservers` | `List<NavigatorObserver>` | `const <NavigatorObserver>[]` |  | Observers for the [Navigator]. |
| `locale` | `Locale?` |  |  | The initial locale for this app. |
| `color` | `Color?` |  |  | The primary color for the application.<br>Used by the OS to identify the app (e.g., task switcher). |

## VAppThemeMode

Theme mode for [VApp].

Determines which theme to use based on system or explicit setting.

### Values

| Value | Description |
|---|---|
| `system` | Follow system brightness setting. |
| `light` | Always use light theme. |
| `dark` | Always use dark theme. |

## VAppStyle

Style override for [VApp].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VAppStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color for the app. |
| `foregroundColor` | `Color?` |  |  | Default text/foreground color. |

### Members

| Member | Description |
|---|---|
| `VAppStyle copyWith({Color? backgroundColor, Color? foregroundColor})` | Creates a copy with only the specified properties changed. |
