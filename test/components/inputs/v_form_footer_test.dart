import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VFormFooter', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('creates VFormFooter', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VFormFooter(helper: 'Helper', child: Text('Content')),
        ),
      );

      expect(find.text('Helper'), findsOneWidget);
    });

    testWidgets('shows only child when all messages are null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VFormFooter(child: Text('Content only'))),
      );

      expect(find.text('Content only'), findsOneWidget);
    });

    group('message priority', () {
      testWidgets('error > success > helper', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VFormFooter(
              helper: 'Helper',
              success: true,
              successText: 'Success',
              error: true,
              errorText: 'Error',
              child: Container(),
            ),
          ),
        );

        // Only error should be displayed.
        expect(find.text('Error'), findsOneWidget);
        expect(find.text('Success'), findsNothing);
        expect(find.text('Helper'), findsNothing);
      });

      testWidgets('success > helper', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VFormFooter(
              helper: 'Helper',
              success: true,
              successText: 'Success',
              child: Container(),
            ),
          ),
        );

        expect(find.text('Success'), findsOneWidget);
        expect(find.text('Helper'), findsNothing);
      });
    });

    testWidgets('auto-generates maxLength counter', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VFormFooter(maxLength: 100, currentLength: 25, child: Container()),
        ),
      );

      expect(find.text('25/100'), findsOneWidget);
    });

    testWidgets('custom counter', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VFormFooter(
            counter: const Text('Custom Counter'),
            child: Container(),
          ),
        ),
      );

      expect(find.text('Custom Counter'), findsOneWidget);
    });

    testWidgets('displays extra', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VFormFooter(
            helper: 'Helper',
            extra: 'Additional info',
            child: Container(),
          ),
        ),
      );

      expect(find.text('Additional info'), findsOneWidget);
    });

    group('style fields', () {
      final theme = VThemeData.light();
      const style = VFormFooterStyle(
        helperStyle: TextStyle(fontSize: 15, color: Color(0xFF00AA00)),
        errorStyle: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
      );

      // Applies [style] through the theme or as the instance style.
      Widget styled({required bool viaTheme, required Widget child}) => VTheme(
        data: theme.copyWith(
          componentOverrides: VComponentOverrides(viaTheme ? [style] : []),
        ),
        child: Directionality(textDirection: TextDirection.ltr, child: child),
      );

      TextStyle styleOf(WidgetTester tester, String text) =>
          tester.widget<Text>(find.text(text)).style!;

      for (final viaTheme in [true, false]) {
        final via = viaTheme ? 'theme' : 'instance';

        testWidgets('helperStyle styles the helper text ($via)', (
          tester,
        ) async {
          await tester.pumpWidget(
            styled(
              viaTheme: viaTheme,
              child: VFormFooter(
                helper: 'Help',
                style: viaTheme ? null : style,
                child: const SizedBox(),
              ),
            ),
          );

          final help = styleOf(tester, 'Help');
          expect(help.fontSize, 15);
          expect(help.color, const Color(0xFF00AA00));
          // Fields the style leaves out come from the label small style.
          expect(help.height, theme.typography.labelSmall.height);
        });

        testWidgets('errorStyle styles the error text ($via)', (tester) async {
          await tester.pumpWidget(
            styled(
              viaTheme: viaTheme,
              child: VFormFooter(
                error: true,
                errorText: 'Wrong',
                style: viaTheme ? null : style,
                child: const SizedBox(),
              ),
            ),
          );

          final error = styleOf(tester, 'Wrong');
          expect(error.fontSize, 16);
          expect(error.fontStyle, FontStyle.italic);
          // Without its own color the error keeps the destructive color.
          expect(error.color, theme.colors.destructive);
        });
      }

      testWidgets('without a style, the tokens draw the messages', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            const Column(
              children: [
                VFormFooter(helper: 'Help', child: SizedBox()),
                VFormFooter(error: true, errorText: 'Wrong', child: SizedBox()),
              ],
            ),
          ),
        );

        final help = styleOf(tester, 'Help');
        expect(help.fontSize, theme.typography.labelSmall.fontSize);
        expect(help.color, theme.colors.mutedForeground);
        expect(styleOf(tester, 'Wrong').color, theme.colors.destructive);
      });
    });
  });
}
