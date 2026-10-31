import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('AnimatedVTheme', () {
    testWidgets('provides theme to descendants', (tester) async {
      late VThemeData capturedTheme;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedVTheme(
            data: VThemeData.light(),
            child: Builder(
              builder: (context) {
                capturedTheme = VTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedTheme.isLight, true);
    });

    testWidgets('animates between themes', (tester) async {
      late VThemeData capturedTheme;

      final lightTheme = VThemeData.light();
      final darkTheme = VThemeData.dark();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedVTheme(
            data: lightTheme,
            child: Builder(
              builder: (context) {
                capturedTheme = VTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedTheme.isLight, true);

      // Switch to dark theme
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedVTheme(
            data: darkTheme,
            child: Builder(
              builder: (context) {
                capturedTheme = VTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // At t=0, brightness still light (< 0.5)
      expect(capturedTheme.isLight, true);

      // Pump to midpoint
      await tester.pump(const Duration(milliseconds: 100));

      // Pump past midpoint
      await tester.pump(const Duration(milliseconds: 101));
      expect(capturedTheme.isDark, true);

      // Complete animation
      await tester.pumpAndSettle();
      expect(capturedTheme.isDark, true);
    });

    testWidgets('uses custom duration', (tester) async {
      late VThemeData capturedTheme;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedVTheme(
            data: VThemeData.light(),
            duration: const Duration(milliseconds: 500),
            child: Builder(
              builder: (context) {
                capturedTheme = VTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // Switch to dark
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedVTheme(
            data: VThemeData.dark(),
            duration: const Duration(milliseconds: 500),
            child: Builder(
              builder: (context) {
                capturedTheme = VTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // At 200ms (< 50% of 500ms), still light
      await tester.pump(const Duration(milliseconds: 200));
      expect(capturedTheme.isLight, true);

      // At 300ms (> 50%), dark
      await tester.pump(const Duration(milliseconds: 100));
      expect(capturedTheme.isDark, true);

      await tester.pumpAndSettle();
    });

    testWidgets('uses custom curve', (tester) async {
      late VThemeData capturedTheme;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedVTheme(
            data: VThemeData.light(),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Builder(
              builder: (context) {
                capturedTheme = VTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedTheme.isLight, true);

      // Switch to dark with easeInOut
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedVTheme(
            data: VThemeData.dark(),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Builder(
              builder: (context) {
                capturedTheme = VTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(capturedTheme.isDark, true);
    });

    testWidgets('calls onEnd when animation completes', (tester) async {
      var onEndCalled = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedVTheme(
            data: VThemeData.light(),
            onEnd: () => onEndCalled = true,
            child: const SizedBox(),
          ),
        ),
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedVTheme(
            data: VThemeData.dark(),
            onEnd: () => onEndCalled = true,
            child: const SizedBox(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(onEndCalled, true);
    });

    testWidgets('interpolates color values during animation', (tester) async {
      late VThemeData capturedTheme;
      final lightTheme = VThemeData.light();
      final darkTheme = VThemeData.dark();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedVTheme(
            data: lightTheme,
            child: Builder(
              builder: (context) {
                capturedTheme = VTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      final initialBackground = capturedTheme.colors.background;

      // Switch to dark
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedVTheme(
            data: darkTheme,
            child: Builder(
              builder: (context) {
                capturedTheme = VTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // At midpoint, colors should be interpolated (different from start and end)
      await tester.pump(const Duration(milliseconds: 100));
      final midBackground = capturedTheme.colors.background;

      // The midpoint background should differ from start
      // (if light and dark backgrounds are different)
      if (lightTheme.colors.background != darkTheme.colors.background) {
        expect(midBackground, isNot(equals(initialBackground)));
      }

      await tester.pumpAndSettle();
      expect(capturedTheme.colors.background, darkTheme.colors.background);
    });
  });

  group('VThemeDataTween', () {
    test('lerp at 0.0 returns begin', () {
      final light = VThemeData.light();
      final dark = VThemeData.dark();
      final tween = VThemeDataTween(begin: light, end: dark);

      final result = tween.lerp(0);

      expect(result.brightness, light.brightness);
    });

    test('lerp at 1.0 returns end', () {
      final light = VThemeData.light();
      final dark = VThemeData.dark();
      final tween = VThemeDataTween(begin: light, end: dark);

      final result = tween.lerp(1);

      expect(result.brightness, dark.brightness);
    });

    test('lerp at 0.5 interpolates', () {
      final light = VThemeData.light();
      final dark = VThemeData.dark();
      final tween = VThemeDataTween(begin: light, end: dark);

      final result = tween.lerp(0.5);

      // Brightness snaps at 0.5 — at exactly 0.5, t < 0.5 is false, so dark
      expect(result.brightness, dark.brightness);
    });

    test('lerp at 0.49 keeps begin brightness', () {
      final light = VThemeData.light();
      final dark = VThemeData.dark();
      final tween = VThemeDataTween(begin: light, end: dark);

      final result = tween.lerp(0.49);

      expect(result.brightness, light.brightness);
    });
  });
}
