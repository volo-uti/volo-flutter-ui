import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  group('VAlert', () {
    testWidgets('renders default variant', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VAlert(description: Text('Default alert'))),
      );

      expect(find.text('Default alert'), findsOneWidget);
    });

    testWidgets('renders info variant', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VAlert.info(description: Text('Info alert'))),
      );

      expect(find.text('Info alert'), findsOneWidget);
    });

    testWidgets('renders success variant', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VAlert.success(description: Text('Success alert')),
        ),
      );

      expect(find.text('Success alert'), findsOneWidget);
    });

    testWidgets('renders warning variant', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VAlert.warning(description: Text('Warning alert')),
        ),
      );

      expect(find.text('Warning alert'), findsOneWidget);
    });

    testWidgets('renders destructive variant', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VAlert.error(description: Text('Error alert'))),
      );

      expect(find.text('Error alert'), findsOneWidget);
    });

    testWidgets('renders with title', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VAlert(
            title: Text('Alert Title'),
            description: Text('Alert content'),
          ),
        ),
      );

      expect(find.text('Alert Title'), findsOneWidget);
      expect(find.text('Alert content'), findsOneWidget);
    });

    testWidgets('renders with widget description', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VAlert(
            description: Column(children: [Text('Line 1'), Text('Line 2')]),
          ),
        ),
      );

      expect(find.text('Line 1'), findsOneWidget);
      expect(find.text('Line 2'), findsOneWidget);
    });

    testWidgets('calls onClose when the close button is tapped', (
      tester,
    ) async {
      var closed = 0;

      await tester.pumpWidget(
        buildTestWidget(
          VAlert(
            description: const Text('Closable alert'),
            onClose: () => closed++,
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(closed, 1);
    });

    testWidgets('styles Text title and description from theme tokens', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VAlert(
            title: Text('Styled title'),
            description: Text('Styled description'),
          ),
        ),
      );

      TextStyle styleOf(String text) => tester
          .widget<RichText>(
            find.descendant(
              of: find.text(text),
              matching: find.byType(RichText),
            ),
          )
          .text
          .style!;

      final theme = VThemeData.light();
      final title = styleOf('Styled title');
      expect(title.color, theme.colors.foreground);
      expect(title.fontSize, theme.typography.bodyMedium.fontSize);
      expect(title.fontWeight, FontWeight.w600);
      final description = styleOf('Styled description');
      expect(description.color, theme.colors.mutedForeground);
      expect(description.fontSize, theme.typography.bodySmall.fontSize);
    });

    testWidgets('hides the close button without onClose', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VAlert(description: Text('Plain alert'))),
      );

      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('exposes semanticLabel to screen readers', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VAlert.error(
            description: Text('Failed'),
            semanticLabel: 'Save failed',
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == 'Save failed',
        ),
        findsOneWidget,
      );
    });

    group('theme override', () {
      testWidgets('theme componentOverrides applies to alert', (tester) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VAlertStyle(backgroundColor: Color(0xFFFF0000)),
              ]),
            ),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: VAlert(description: Text('Test alert')),
            ),
          ),
        );

        expect(find.byType(VAlert), findsOneWidget);
      });
    });
  });

  group('VAlert regressions', () {
    testWidgets('the close button has a label and a tap action', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var closed = 0;
      await tester.pumpWidget(
        buildTestWidget(
          VAlert(description: const Text('Heads up'), onClose: () => closed++),
        ),
      );

      tester.semantics.tap(find.semantics.byLabel(RegExp('Close')));
      expect(closed, 1);
      handle.dispose();
    });

    testWidgets('Enter on the focused close button closes the alert', (
      tester,
    ) async {
      var closed = 0;
      await tester.pumpWidget(
        buildTestWidget(
          VAlert(description: const Text('Heads up'), onClose: () => closed++),
        ),
      );

      Focus.of(
        tester.element(
          find.descendant(
            of: find.byType(VAlert),
            matching: find.byType(GestureDetector),
          ),
        ),
      ).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      expect(closed, 1);
    });
  });
}
