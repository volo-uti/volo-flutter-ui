import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_theme.dart';
import 'package:volo_flutter_ui/src/theme/v_theme_data.dart';

/// Theme mode for [VApp].
///
/// Determines which theme to use based on system or explicit setting.
enum VAppThemeMode {
  /// Follow system brightness setting.
  system,

  /// Always use light theme.
  light,

  /// Always use dark theme.
  dark,
}

// WHY: WidgetsApp instead of MaterialApp — Zero Material dependency is a
// core architectural principle. WidgetsApp provides Navigator, routes,
// and basic app shell without pulling in Material's ThemeData, ColorScheme,
// or ink/ripple effects. Compatible with go_router/auto_route via
// WidgetsApp.router (not used here yet, planned for v1.0+).
/// {@template v_app}
/// App root with [VTheme] that follows system brightness.
///
/// Use it instead of `MaterialApp` so descendants can read tokens through
/// [VTheme.of]. [themeMode] picks between [theme] and [darkTheme]; Navigator,
/// routes and locale are passed through to [WidgetsApp].
///
/// ## Basic Usage:
///
/// ```dart
/// VApp(
///   home: MyHomePage(),
/// )
/// ```
///
/// ## With Themes:
///
/// Custom light/dark themes:
///
/// ```dart
/// VApp(
///   theme: VThemeData.light().copyWith(
///     colors: myBrandColors,
///   ),
///   darkTheme: VThemeData.dark().copyWith(
///     colors: myBrandDarkColors,
///   ),
///   themeMode: VAppThemeMode.system,
///   home: MyHomePage(),
/// )
/// ```
///
/// ## With Router:
///
/// Named routes:
///
/// ```dart
/// VApp(
///   initialRoute: '/home',
///   routes: {
///     '/home': (context) => HomePage(),
///     '/settings': (context) => SettingsPage(),
///   },
/// )
/// ```
///
/// See also:
///
/// - [VTheme], theme provider InheritedWidget
/// - [VThemeData], complete theme data
/// - [VAppThemeMode], theme mode options
/// {@endtemplate}
class VApp extends StatelessWidget {
  /// {@macro v_app}
  const VApp({
    super.key,
    this.home,
    this.theme,
    this.darkTheme,
    this.themeMode = VAppThemeMode.system,
    this.title = '',
    this.debugShowCheckedModeBanner = false,
    this.navigatorKey,
    this.builder,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.initialRoute,
    this.routes = const <String, WidgetBuilder>{},
    this.navigatorObservers = const <NavigatorObserver>[],
    this.locale,
    this.color,
  });

  /// The widget for the default route of the app.
  final Widget? home;

  /// The light theme data.
  ///
  /// Defaults to [VThemeData.light] if not provided.
  final VThemeData? theme;

  /// The dark theme data.
  ///
  /// Defaults to [VThemeData.dark] if not provided.
  final VThemeData? darkTheme;

  /// Determines which theme to use.
  ///
  /// Defaults to [VAppThemeMode.system].
  final VAppThemeMode themeMode;

  /// A one-line description used by the device to identify the app.
  final String title;

  /// Whether to show the debug banner.
  final bool debugShowCheckedModeBanner;

  /// A key for the [Navigator].
  final GlobalKey<NavigatorState>? navigatorKey;

  /// A builder that wraps the entire widget tree.
  final TransitionBuilder? builder;

  /// Route generation callback.
  final RouteFactory? onGenerateRoute;

  /// Unknown route callback.
  final RouteFactory? onUnknownRoute;

  /// The name of the first route to show.
  final String? initialRoute;

  /// The application's top-level routing table.
  final Map<String, WidgetBuilder> routes;

  /// Observers for the [Navigator].
  final List<NavigatorObserver> navigatorObservers;

  /// The initial locale for this app.
  final Locale? locale;

  /// The primary color for the application.
  ///
  /// Used by the OS to identify the app (e.g., task switcher).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final effectiveTheme = switch (themeMode) {
      VAppThemeMode.light => theme ?? VThemeData.light(),
      VAppThemeMode.dark => darkTheme ?? VThemeData.dark(),
      VAppThemeMode.system =>
        brightness == Brightness.dark
            ? (darkTheme ?? VThemeData.dark())
            : (theme ?? VThemeData.light()),
    };

    return VTheme(
      data: effectiveTheme,
      child: WidgetsApp(
        navigatorKey: navigatorKey,
        home: home,
        title: title,
        color: color ?? effectiveTheme.colors.primary,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        builder: builder,
        onGenerateRoute: onGenerateRoute,
        onUnknownRoute: onUnknownRoute,
        initialRoute: initialRoute,
        routes: routes,
        navigatorObservers: navigatorObservers,
        locale: locale,
        // CONSTRAINT: WidgetsApp requires pageRouteBuilder — unlike MaterialApp
        // which defaults to MaterialPageRoute, we must provide our own.
        // PageRouteBuilder gives full control over transition animations.
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
            PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  builder(context),
            ),
      ),
    );
  }
}
