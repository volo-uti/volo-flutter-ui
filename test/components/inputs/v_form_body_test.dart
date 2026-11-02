import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VFormBody', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('creates VFormBody', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VFormBody(child: Text('Content'))),
      );

      expect(find.text('Content'), findsOneWidget);
    });

    group('type', () {
      testWidgets('type=outlined', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VFormBody(child: Text('outlined'))),
        );

        expect(find.text('outlined'), findsOneWidget);
      });

      testWidgets('type=filled', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VFormBody(type: VFormBodyType.filled, child: Text('filled')),
          ),
        );

        expect(find.text('filled'), findsOneWidget);
      });

      testWidgets('type=underline', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VFormBody(
              type: VFormBodyType.underline,
              child: Text('underline'),
            ),
          ),
        );

        expect(find.text('underline'), findsOneWidget);
      });
    });

    group('size', () {
      testWidgets('size=sm', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VFormBody(size: VFormBodySize.sm, child: Text('Small')),
          ),
        );

        expect(find.text('Small'), findsOneWidget);
      });

      testWidgets('size=lg', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VFormBody(size: VFormBodySize.lg, child: Text('Large')),
          ),
        );

        expect(find.text('Large'), findsOneWidget);
      });
    });

    testWidgets('displays leading', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VFormBody(leading: Text('Front'), child: Text('Content')),
        ),
      );

      expect(find.text('Front'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('displays trailing', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VFormBody(trailing: Text('Back'), child: Text('Content')),
        ),
      );

      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('opacity 50% when enabled=false', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VFormBody(enabled: false, child: Text('Disabled')),
        ),
      );

      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, 0.5);
    });

    testWidgets('error and success change the border color', (tester) async {
      Color? borderColor(Widget body) {
        final box = tester
            .widgetList<Container>(find.byType(Container))
            .map((c) => c.decoration)
            .whereType<BoxDecoration>()
            .map((d) => d.border)
            .whereType<Border>()
            .first;
        return box.top.color;
      }

      final colors = VThemeData.light().colors;

      await tester.pumpWidget(
        buildTestWidget(const VFormBody(error: true, child: Text('x'))),
      );
      expect(borderColor(const Text('x')), colors.destructive);

      await tester.pumpWidget(
        buildTestWidget(const VFormBody(success: true, child: Text('x'))),
      );
      expect(borderColor(const Text('x')), colors.success);
    });

    testWidgets('fullWidth=true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Center(
            child: SizedBox(
              width: 300,
              child: VFormBody(fullWidth: true, child: Text('Full')),
            ),
          ),
        ),
      );

      expect(find.text('Full'), findsOneWidget);
    });

    group('style fields', () {
      final theme = VThemeData.light();
      const style = VFormBodyStyle(
        backgroundColor: Color(0xFFFAFAF0),
        borderColor: Color(0xFF00AA00),
        focusBorderColor: Color(0xFF0000AA),
        borderRadius: BorderRadius.all(Radius.circular(3)),
        spacing: 20,
      );

      // Applies [style] through the theme or as the instance style.
      Widget styled({
        required bool viaTheme,
        required Widget Function(VFormBodyStyle? instanceStyle) build,
      }) => VTheme(
        data: theme.copyWith(
          componentOverrides: VComponentOverrides(viaTheme ? [style] : []),
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(width: 300, child: build(viaTheme ? null : style)),
          ),
        ),
      );

      BoxDecoration decorationOf(WidgetTester tester) =>
          tester
                  .widget<Container>(
                    find
                        .descendant(
                          of: find.byType(VFormBody),
                          matching: find.byType(Container),
                        )
                        .first,
                  )
                  .decoration!
              as BoxDecoration;

      for (final viaTheme in [true, false]) {
        final via = viaTheme ? 'theme' : 'instance';

        testWidgets('draws backgroundColor, borderColor, borderRadius ($via)', (
          tester,
        ) async {
          await tester.pumpWidget(
            styled(
              viaTheme: viaTheme,
              build: (s) => VFormBody(style: s, child: const Text('x')),
            ),
          );

          final decoration = decorationOf(tester);
          expect(decoration.color, style.backgroundColor);
          expect((decoration.border! as Border).top.color, style.borderColor);
          expect(decoration.borderRadius, style.borderRadius);
        });

        testWidgets('draws focusBorderColor while focused ($via)', (
          tester,
        ) async {
          await tester.pumpWidget(
            styled(
              viaTheme: viaTheme,
              build: (s) =>
                  VFormBody(style: s, focused: true, child: const Text('x')),
            ),
          );

          final border = decorationOf(tester).border! as Border;
          expect(border.top.color, style.focusBorderColor);
          expect(border.top.width, 2);
        });

        testWidgets('error and a square corner win over the style ($via)', (
          tester,
        ) async {
          await tester.pumpWidget(
            styled(
              viaTheme: viaTheme,
              build: (s) => VFormBody(
                style: s,
                error: true,
                corner: VFormBodyCorner.square,
                child: const Text('x'),
              ),
            ),
          );

          final decoration = decorationOf(tester);
          expect(
            (decoration.border! as Border).top.color,
            theme.colors.destructive,
          );
          expect(decoration.borderRadius, BorderRadius.zero);
        });

        testWidgets('spacing separates the slots from the child ($via)', (
          tester,
        ) async {
          await tester.pumpWidget(
            styled(
              viaTheme: viaTheme,
              build: (s) => VFormBody(
                style: s,
                leading: const Text('L'),
                trailing: const Text('T'),
                child: const Text('x'),
              ),
            ),
          );

          expect(
            tester.getTopLeft(find.text('x')).dx -
                tester.getTopRight(find.text('L')).dx,
            20,
          );
          expect(
            tester.getTopLeft(find.text('T')).dx -
                tester.getTopRight(find.byType(Expanded)).dx,
            20,
          );
        });
      }

      testWidgets('without a style, the tokens draw the box', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VFormBody(leading: Text('L'), child: Text('x')),
          ),
        );

        final decoration = decorationOf(tester);
        expect(decoration.color, isNull);
        expect((decoration.border! as Border).top.color, theme.colors.input);
        expect(
          decoration.borderRadius,
          BorderRadius.circular(theme.sizes.md.borderRadius),
        );
        expect(
          tester.getTopLeft(find.text('x')).dx -
              tester.getTopRight(find.text('L')).dx,
          theme.spacing.sm,
        );
      });
    });
  });
}
