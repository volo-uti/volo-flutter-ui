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
  });
}
