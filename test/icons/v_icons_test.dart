import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: child),
    ),
  );

  const testColor = Color(0xFF000000);

  // All 32 icon factory methods on VIcons.
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
    'camera': () => VIcons.camera(color: testColor),
    'list': () => VIcons.list(color: testColor),
    'cloud': () => VIcons.cloud(color: testColor),
    'clock': () => VIcons.clock(color: testColor),
    'settings': () => VIcons.settings(color: testColor),
    'location': () => VIcons.location(color: testColor),
    'openInNew': () => VIcons.openInNew(color: testColor),
    'playCircle': () => VIcons.playCircle(color: testColor),
    'arrowDropDown': () => VIcons.arrowDropDown(color: testColor),
  };

  group('VIcons', () {
    for (final entry in iconFactories.entries) {
      testWidgets('${entry.key} renders CustomPaint', (tester) async {
        await tester.pumpWidget(buildTestWidget(entry.value()));

        expect(find.byType(CustomPaint), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('the added icons paint only in the given color', (
      tester,
    ) async {
      const color = Color(0xFF00AA00);
      // Paint keeps its color in float32, so compare the 32-bit values.
      const draws = {#drawPath, #drawCircle, #drawLine, #drawRRect};
      final added = <Widget>[
        VIcons.camera(color: color),
        VIcons.list(color: color),
        VIcons.cloud(color: color),
        VIcons.clock(color: color),
        VIcons.settings(color: color),
        VIcons.location(color: color),
        VIcons.openInNew(color: color),
        VIcons.playCircle(color: color),
        VIcons.arrowDropDown(color: color),
      ];
      for (final icon in added) {
        await tester.pumpWidget(buildTestWidget(icon));
        expect(
          find.byType(CustomPaint),
          paints..everything(
            (method, args) =>
                !draws.contains(method) ||
                (args.last as Paint).color.toARGB32() == color.toARGB32(),
          ),
        );
      }
    });

    testWidgets('without a color, uses the IconTheme color', (tester) async {
      const iconThemeColor = Color(0xFFAA0000);
      await tester.pumpWidget(
        buildTestWidget(
          IconTheme(
            data: const IconThemeData(color: iconThemeColor),
            child: VIcons.clock(),
          ),
        ),
      );

      expect(find.byType(CustomPaint), paints..circle(color: iconThemeColor));
    });

    testWidgets('a given color wins over the IconTheme color', (tester) async {
      const color = Color(0xFF0000AA);
      await tester.pumpWidget(
        buildTestWidget(
          IconTheme(
            data: const IconThemeData(color: Color(0xFFAA0000)),
            child: VIcons.clock(color: color),
          ),
        ),
      );

      expect(find.byType(CustomPaint), paints..circle(color: color));
    });

    testWidgets('without a color or IconTheme, uses the theme foreground', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(VIcons.clock()));

      expect(
        find.byType(CustomPaint),
        paints..circle(color: VThemeData.light().colors.foreground),
      );
    });

    testWidgets('follows the selected and unselected VBottomNav colors', (
      tester,
    ) async {
      const selected = Color(0xFF00AA00);
      const unselected = Color(0xFF888888);
      Widget icon(String key, Widget child) =>
          KeyedSubtree(key: ValueKey(key), child: child);
      await tester.pumpWidget(
        buildTestWidget(
          VBottomNav(
            selectedItemColor: selected,
            unselectedItemColor: unselected,
            items: [
              VBottomNavItem(
                key: 'clock',
                icon: icon('clock', VIcons.clock()),
                label: 'Clock',
              ),
              VBottomNavItem(
                key: 'list',
                icon: icon('list', VIcons.list()),
                label: 'List',
              ),
              VBottomNavItem(
                key: 'cloud',
                icon: icon('cloud', VIcons.cloud()),
                label: 'Cloud',
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      Finder paintOf(String key) => find.descendant(
        of: find.byKey(ValueKey(key)),
        matching: find.byType(CustomPaint),
      );
      expect(paintOf('clock'), paints..circle(color: selected));
      expect(paintOf('list'), paints..circle(color: unselected));
    });

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
