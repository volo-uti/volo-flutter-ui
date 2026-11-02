import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VFormHeader', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('creates VFormHeader', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VFormHeader(label: 'Label', child: Container())),
      );

      expect(find.text('Label'), findsOneWidget);
    });

    testWidgets('shows only child when label is null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VFormHeader(child: Text('child'))),
      );

      expect(find.text('child'), findsOneWidget);
    });

    testWidgets('shows required indicator when required=true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VFormHeader(label: 'Label', required: true, child: Container()),
        ),
      );

      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('custom requiredMark', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VFormHeader(
            label: 'Label',
            required: true,
            requiredMark: '(required)',
            child: Container(),
          ),
        ),
      );

      expect(find.text('(required)'), findsOneWidget);
    });

    testWidgets('displays more', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VFormHeader(label: 'Label', more: 'Optional', child: Container()),
        ),
      );

      expect(find.text('Optional'), findsOneWidget);
    });

    testWidgets('displays tooltip', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VFormHeader(
            label: 'Label',
            tooltip: const Text('?'),
            child: Container(),
          ),
        ),
      );

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('the color of titleStyle and subtitleStyle is drawn', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          VFormHeader(
            label: 'Label',
            more: 'Optional',
            style: const VFormHeaderStyle(
              titleStyle: TextStyle(color: Color(0xFF654321)),
              subtitleStyle: TextStyle(color: Color(0xFF123456)),
            ),
            child: Container(),
          ),
        ),
      );

      expect(
        tester.widget<Text>(find.text('Label')).style!.color,
        const Color(0xFF654321),
      );
      expect(
        tester.widget<Text>(find.text('Optional')).style!.color,
        const Color(0xFF123456),
      );
    });

    testWidgets('a long label wraps at 320 wide and 2x text', (tester) async {
      tester.view
        ..physicalSize = const Size(320, 640)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      const label = 'Mailing address for paper statements and notices';
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 640),
            textScaler: TextScaler.linear(2),
          ),
          child: buildTestWidget(
            VFormHeader(
              label: label,
              required: true,
              tooltip: const SizedBox(width: 16, height: 16),
              more: 'Optional',
              child: Container(height: 40),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final theme = VThemeData.light();
      final labelRect = tester.getRect(find.text(label));
      // Two or more lines of the scaled label font.
      expect(
        labelRect.height,
        greaterThanOrEqualTo(2 * 2 * theme.typography.labelMedium.fontSize!),
      );
      // The required mark and the side note stay on the row, inside the screen.
      final markRect = tester.getRect(find.text('*'));
      expect(markRect.left, greaterThanOrEqualTo(labelRect.right));
      expect(markRect.top, greaterThanOrEqualTo(labelRect.top));
      expect(markRect.bottom, lessThanOrEqualTo(labelRect.bottom));
      final moreRect = tester.getRect(find.text('Optional'));
      expect(moreRect.left, greaterThan(markRect.right));
      expect(moreRect.right, lessThanOrEqualTo(320));
    });

    testWidgets('a short label keeps the side note at the row end', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          Center(
            child: SizedBox(
              width: 300,
              child: VFormHeader(
                label: 'Name',
                more: 'Optional',
                child: Container(height: 40),
              ),
            ),
          ),
        ),
      );

      expect(
        tester.getTopRight(find.text('Optional')).dx,
        tester.getTopRight(find.byType(VFormHeader)).dx,
      );
    });
  });
}
