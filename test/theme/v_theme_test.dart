import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VTheme', () {
    testWidgets('of() returns theme from context', (tester) async {
      late VThemeData capturedTheme;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Builder(
            builder: (context) {
              capturedTheme = VTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedTheme.isLight, true);
    });

    testWidgets('maybeOf() returns null when no theme exists', (tester) async {
      VThemeData? capturedTheme;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            capturedTheme = VTheme.maybeOf(context);
            return const SizedBox();
          },
        ),
      );

      expect(capturedTheme, isNull);
    });

    testWidgets('children rebuild when theme changes', (tester) async {
      var buildCount = 0;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Builder(
            builder: (context) {
              buildCount++;
              VTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(buildCount, 1);

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.dark(),
          child: Builder(
            builder: (context) {
              buildCount++;
              VTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(buildCount, 2);
    });

    testWidgets('nested VTheme uses the nearest theme', (tester) async {
      late VThemeData innerTheme;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: VTheme(
            data: VThemeData.dark(),
            child: Builder(
              builder: (context) {
                innerTheme = VTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(innerTheme.isDark, true);
    });

    testWidgets('merge() overrides parent theme', (tester) async {
      late VThemeData capturedTheme;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: VTheme.merge(
            overrides: (parent) => parent.copyWith(brightness: Brightness.dark),
            child: Builder(
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

    testWidgets('merge() preserves non-overridden properties', (tester) async {
      final parentTheme = VThemeData.light();
      late VThemeData capturedTheme;

      await tester.pumpWidget(
        VTheme(
          data: parentTheme,
          child: VTheme.merge(
            overrides: (parent) => parent.copyWith(brightness: Brightness.dark),
            child: Builder(
              builder: (context) {
                capturedTheme = VTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // Brightness overridden
      expect(capturedTheme.isDark, true);
      // Other properties preserved
      expect(capturedTheme.spacing, parentTheme.spacing);
      expect(capturedTheme.radius, parentTheme.radius);
      expect(capturedTheme.typography, parentTheme.typography);
    });

    testWidgets('merge() can be nested', (tester) async {
      late VThemeData capturedTheme;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: VTheme.merge(
            overrides: (parent) => parent.copyWith(brightness: Brightness.dark),
            child: VTheme.merge(
              overrides: (parent) => parent.copyWith(colors: VColors.light),
              child: Builder(
                builder: (context) {
                  capturedTheme = VTheme.of(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      // Inner merge uses the outer merge result as parent
      expect(capturedTheme.isDark, true);
      expect(capturedTheme.colors, VColors.light);
    });
  });
}
