import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

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

  group('VAppThemeMode', () {
    test('has three modes', () {
      expect(VAppThemeMode.values.length, 3);
      expect(VAppThemeMode.values, contains(VAppThemeMode.system));
      expect(VAppThemeMode.values, contains(VAppThemeMode.light));
      expect(VAppThemeMode.values, contains(VAppThemeMode.dark));
    });
  });
}
