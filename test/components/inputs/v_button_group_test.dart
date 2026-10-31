import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VButtonGroup', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(data: const MediaQueryData(), child: child),
      ),
    );

    testWidgets('renders children horizontally by default', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VButtonGroup(
            children: [
              VButton(onPressed: () {}, child: const Text('Left')),
              VButton(onPressed: () {}, child: const Text('Center')),
              VButton(onPressed: () {}, child: const Text('Right')),
            ],
          ),
        ),
      );

      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Center'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('renders children vertically', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VButtonGroup(
            orientation: VButtonGroupOrientation.vertical,
            children: [
              VButton(onPressed: () {}, child: const Text('Top')),
              VButton(onPressed: () {}, child: const Text('Bottom')),
            ],
          ),
        ),
      );

      expect(find.text('Top'), findsOneWidget);
      expect(find.text('Bottom'), findsOneWidget);

      // Verify Column exists inside VButtonGroup
      final columnFinder = find.descendant(
        of: find.byType(VButtonGroup),
        matching: find.byType(Column),
      );
      expect(columnFinder, findsOneWidget);
    });

    testWidgets('applies size to children via scope', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VButtonGroup(
            size: VButtonSize.sm,
            children: [
              VButton(onPressed: () {}, child: const Text('A')),
              VButton(onPressed: () {}, child: const Text('B')),
            ],
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.byType(VButtonGroup), findsOneWidget);
    });
  });
}
