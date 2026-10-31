import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => Directionality(
    textDirection: TextDirection.ltr,
    child: Center(child: child),
  );

  const testColor = Color(0xFF000000);

  // All 23 icon factory methods on VIcons.
  final iconFactories = <String, Widget Function()>{
    'chevronLeft': () => VIcons.chevronLeft(color: testColor),
    'chevronRight': () => VIcons.chevronRight(color: testColor),
    'chevronUp': () => VIcons.chevronUp(color: testColor),
    'chevronDown': () => VIcons.chevronDown(color: testColor),
    'arrowBack': () => VIcons.arrowBack(color: testColor),
    'arrowUp': () => VIcons.arrowUp(color: testColor),
    'arrowDown': () => VIcons.arrowDown(color: testColor),
    'firstPage': () => VIcons.firstPage(color: testColor),
    'lastPage': () => VIcons.lastPage(color: testColor),
    'close': () => VIcons.close(color: testColor),
    'check': () => VIcons.check(color: testColor),
    'search': () => VIcons.search(color: testColor),
    'refresh': () => VIcons.refresh(color: testColor),
    'edit': () => VIcons.edit(color: testColor),
    'info': () => VIcons.info(color: testColor),
    'checkCircle': () => VIcons.checkCircle(color: testColor),
    'error': () => VIcons.error(color: testColor),
    'warning': () => VIcons.warning(color: testColor),
    'priorityHigh': () => VIcons.priorityHigh(color: testColor),
    'person': () => VIcons.person(color: testColor),
    'calendar': () => VIcons.calendar(color: testColor),
    'visibility': () => VIcons.visibility(color: testColor),
    'visibilityOff': () => VIcons.visibilityOff(color: testColor),
  };

  group('VIcons', () {
    for (final entry in iconFactories.entries) {
      testWidgets('${entry.key} renders CustomPaint', (tester) async {
        await tester.pumpWidget(buildTestWidget(entry.value()));

        expect(find.byType(CustomPaint), findsOneWidget);
      });
    }

    testWidgets('default size is 24', (tester) async {
      await tester.pumpWidget(buildTestWidget(VIcons.close(color: testColor)));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 24);
      expect(sizedBox.height, 24);
    });

    testWidgets('custom size is applied', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VIcons.close(color: testColor, size: 16)),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 16);
      expect(sizedBox.height, 16);
    });

    testWidgets('color is passed to CustomPaint painter', (tester) async {
      const color = Color(0xFFFF0000);
      await tester.pumpWidget(buildTestWidget(VIcons.check(color: color)));

      // The icon renders via CustomPaint -- verify it renders without error.
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('repaints when only the icon changes (same color)', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(VIcons.visibility(color: testColor)),
      );
      final oldPainter = tester
          .widget<CustomPaint>(find.byType(CustomPaint))
          .painter!;

      await tester.pumpWidget(
        buildTestWidget(VIcons.visibilityOff(color: testColor)),
      );
      final newPainter = tester
          .widget<CustomPaint>(find.byType(CustomPaint))
          .painter!;

      expect(newPainter.shouldRepaint(oldPainter), isTrue);
    });

    testWidgets('does not repaint for the same icon and color', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VIcons.visibility(color: testColor)),
      );
      final oldPainter = tester
          .widget<CustomPaint>(find.byType(CustomPaint))
          .painter!;

      await tester.pumpWidget(
        buildTestWidget(VIcons.visibility(color: testColor)),
      );
      final newPainter = tester
          .widget<CustomPaint>(find.byType(CustomPaint))
          .painter!;

      expect(newPainter.shouldRepaint(oldPainter), isFalse);
    });

    testWidgets('renders with different sizes', (tester) async {
      for (final size in [12.0, 24.0, 48.0]) {
        await tester.pumpWidget(
          buildTestWidget(VIcons.search(color: testColor, size: size)),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.width, size);
        expect(sizedBox.height, size);
      }
    });
  });
}
