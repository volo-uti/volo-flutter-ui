import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VIconButton', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('creates VIconButton', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VIconButton(icon: const Text('🔍'), onPressed: () {})),
      );

      expect(find.text('🔍'), findsOneWidget);
    });

    testWidgets('VIconButton.filled', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VIconButton.filled(icon: const Text('➕'), onPressed: () {}),
        ),
      );

      expect(find.text('➕'), findsOneWidget);
    });

    testWidgets('VIconButton.outlined', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VIconButton.outlined(icon: const Text('⚙'), onPressed: () {}),
        ),
      );

      expect(find.text('⚙'), findsOneWidget);
    });

    testWidgets('invokes onPressed callback', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VIconButton(icon: const Text('🔍'), onPressed: () => tapped = true),
        ),
      );

      await tester.tap(find.text('🔍'));
      expect(tapped, true);
    });

    testWidgets('ignores tap when enabled=false', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VIconButton(
            icon: const Text('🔍'),
            onPressed: () => tapped = true,
            enabled: false,
          ),
        ),
      );

      await tester.tap(find.text('🔍'));
      expect(tapped, false);
    });

    testWidgets('selected toggle', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VIconButton(
            icon: const Text('♡'),
            selectedIcon: const Text('❤'),
            isSelected: true,
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('❤'), findsOneWidget);
    });

    group('theme override', () {
      testWidgets('theme componentOverrides applies to icon button', (
        tester,
      ) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VIconButtonStyle(backgroundColor: Color(0xFFFF0000)),
              ]),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VIconButton(icon: const Text('X'), onPressed: () {}),
            ),
          ),
        );

        expect(find.byType(VIconButton), findsOneWidget);
      });
    });
  });
}
