import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

/// A router with one page, built by [pageBuilder].
class _OnePageRouterDelegate extends RouterDelegate<Object>
    with ChangeNotifier {
  _OnePageRouterDelegate(this.pageBuilder);

  final WidgetBuilder pageBuilder;

  @override
  Widget build(BuildContext context) => Navigator(
    pages: [_PlainPage(child: Builder(builder: pageBuilder))],
    onDidRemovePage: (_) {},
  );

  @override
  Future<bool> popRoute() => SynchronousFuture(false);

  @override
  Future<void> setNewRoutePath(Object configuration) =>
      SynchronousFuture<void>(null);
}

/// A page shown with a plain [PageRouteBuilder].
class _PlainPage extends Page<void> {
  const _PlainPage({required this.child});

  final Widget child;

  @override
  Route<void> createRoute(BuildContext context) => PageRouteBuilder<void>(
    settings: this,
    pageBuilder: (context, _, _) => child,
  );
}

RouterConfig<Object> _routerConfig(WidgetBuilder pageBuilder) =>
    RouterConfig(routerDelegate: _OnePageRouterDelegate(pageBuilder));

void main() {
  group('VApp', () {
    testWidgets('renders home widget', (tester) async {
      await tester.pumpWidget(
        const VApp(home: Text('Home', textDirection: TextDirection.ltr)),
      );

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('provides VTheme to descendants', (tester) async {
      late VThemeData capturedTheme;

      await tester.pumpWidget(
        VApp(
          home: Builder(
            builder: (context) {
              capturedTheme = VTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedTheme.isLight, true);
    });

    testWidgets('applies custom light theme', (tester) async {
      final customTheme = VThemeData.light().copyWith(
        brightness: Brightness.light,
      );
      late VThemeData capturedTheme;

      await tester.pumpWidget(
        VApp(
          theme: customTheme,
          themeMode: VAppThemeMode.light,
          home: Builder(
            builder: (context) {
              capturedTheme = VTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedTheme.isLight, true);
      expect(capturedTheme, customTheme);
    });

    testWidgets('applies dark theme when themeMode is dark', (tester) async {
      late VThemeData capturedTheme;

      await tester.pumpWidget(
        VApp(
          themeMode: VAppThemeMode.dark,
          home: Builder(
            builder: (context) {
              capturedTheme = VTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedTheme.isDark, true);
    });

    testWidgets('applies custom dark theme', (tester) async {
      final customDarkTheme = VThemeData.dark();
      late VThemeData capturedTheme;

      await tester.pumpWidget(
        VApp(
          darkTheme: customDarkTheme,
          themeMode: VAppThemeMode.dark,
          home: Builder(
            builder: (context) {
              capturedTheme = VTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedTheme.isDark, true);
      expect(capturedTheme, customDarkTheme);
    });

    testWidgets('system mode follows platform brightness', (tester) async {
      late VThemeData capturedTheme;

      // Light brightness (default in test environment)
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(),
          child: VApp(home: SizedBox()),
        ),
      );

      // Default platformBrightness is light
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: VApp(
            home: Builder(
              builder: (context) {
                capturedTheme = VTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedTheme.isLight, true);

      // Dark brightness
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.dark),
          child: VApp(
            home: Builder(
              builder: (context) {
                capturedTheme = VTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedTheme.isDark, true);
    });

    testWidgets('debug banner is hidden by default', (tester) async {
      await tester.pumpWidget(
        const VApp(home: Text('Test', textDirection: TextDirection.ltr)),
      );

      // debugShowCheckedModeBanner defaults to false
      final app = tester.widget<VApp>(find.byType(VApp));
      expect(app.debugShowCheckedModeBanner, false);
    });

    testWidgets('uses named routes', (tester) async {
      await tester.pumpWidget(
        VApp(
          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            '/': (context) =>
                const Text('Route Home', textDirection: TextDirection.ltr),
          },
        ),
      );

      expect(find.text('Route Home'), findsOneWidget);
    });

    testWidgets('applies title', (tester) async {
      await tester.pumpWidget(const VApp(title: 'My App', home: SizedBox()));

      final app = tester.widget<VApp>(find.byType(VApp));
      expect(app.title, 'My App');
    });
  });

  group('VApp.router', () {
    testWidgets('shows the page of the router config', (tester) async {
      await tester.pumpWidget(
        VApp.router(
          routerConfig: _routerConfig(
            (context) =>
                const Text('Router page', textDirection: TextDirection.ltr),
          ),
        ),
      );

      expect(find.text('Router page'), findsOneWidget);
      expect(find.byType(WidgetsApp), findsOneWidget);
    });

    testWidgets('provides VTheme to the router pages', (tester) async {
      VThemeData? capturedTheme;
      await tester.pumpWidget(
        VApp.router(
          routerConfig: _routerConfig((context) {
            capturedTheme = VTheme.of(context);
            return const SizedBox();
          }),
        ),
      );

      expect(capturedTheme?.isLight, true);
    });

    testWidgets('system mode follows platform brightness', (tester) async {
      VThemeData? capturedTheme;
      final config = _routerConfig((context) {
        capturedTheme = VTheme.of(context);
        return const SizedBox();
      });
      Widget app(Brightness brightness) => MediaQuery(
        data: MediaQueryData(platformBrightness: brightness),
        child: VApp.router(routerConfig: config),
      );

      await tester.pumpWidget(app(Brightness.light));
      expect(capturedTheme?.isLight, true);

      await tester.pumpWidget(app(Brightness.dark));
      expect(capturedTheme?.isDark, true);
    });

    testWidgets('themeMode picks the given light or dark theme', (
      tester,
    ) async {
      final light = VThemeData.light();
      final dark = VThemeData.dark();
      VThemeData? capturedTheme;
      final config = _routerConfig((context) {
        capturedTheme = VTheme.of(context);
        return const SizedBox();
      });

      await tester.pumpWidget(
        VApp.router(
          routerConfig: config,
          theme: light,
          darkTheme: dark,
          themeMode: VAppThemeMode.dark,
        ),
      );
      expect(capturedTheme, dark);

      await tester.pumpWidget(
        VApp.router(
          routerConfig: config,
          theme: light,
          darkTheme: dark,
          themeMode: VAppThemeMode.light,
        ),
      );
      expect(capturedTheme, light);
    });

    testWidgets('passes builder, title and locale to WidgetsApp', (
      tester,
    ) async {
      await tester.pumpWidget(
        VApp.router(
          routerConfig: _routerConfig(
            (context) => Text(
              Localizations.localeOf(context).toLanguageTag(),
              textDirection: TextDirection.ltr,
            ),
          ),
          title: 'Router app',
          locale: const Locale('en', 'US'),
          builder: (context, child) => Column(
            children: [
              const Text('Shell', textDirection: TextDirection.ltr),
              Expanded(child: child!),
            ],
          ),
        ),
      );

      expect(find.text('Shell'), findsOneWidget);
      expect(find.text('en-US'), findsOneWidget);
      final app = tester.widget<WidgetsApp>(find.byType(WidgetsApp));
      expect(app.title, 'Router app');
      expect(app.routerConfig, isNotNull);
      expect(app.debugShowCheckedModeBanner, false);
    });
  });

  group('VAppThemeMode', () {
    test('has three modes', () {
      expect(VAppThemeMode.values.length, 3);
      expect(VAppThemeMode.values, contains(VAppThemeMode.system));
      expect(VAppThemeMode.values, contains(VAppThemeMode.light));
      expect(VAppThemeMode.values, contains(VAppThemeMode.dark));
    });
  });
}
