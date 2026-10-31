import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VFab', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    testWidgets('creates VFab', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VFab(icon: const Text('➕'), onPressed: () {})),
      );

      expect(find.text('➕'), findsOneWidget);
    });

    testWidgets('VFab.small', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VFab.small(icon: const Text('➕'), onPressed: () {})),
      );

      expect(find.text('➕'), findsOneWidget);
    });

    testWidgets('VFab.large', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VFab.large(icon: const Text('➕'), onPressed: () {})),
      );

      expect(find.text('➕'), findsOneWidget);
    });

    testWidgets('VFab.extended', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VFab.extended(
            icon: const Text('➕'),
            label: const Text('Add'),
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('➕'), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('invokes onPressed callback', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VFab(icon: const Text('➕'), onPressed: () => tapped = true),
        ),
      );

      await tester.tap(find.text('➕'));
      expect(tapped, true);
    });

    testWidgets('disabled when onPressed=null', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VFab(icon: Text('➕'))));

      expect(find.text('➕'), findsOneWidget);
    });

    testWidgets('ignores tap when enabled=false', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VFab(
            icon: const Text('➕'),
            onPressed: () => tapped = true,
            enabled: false,
          ),
        ),
      );

      await tester.tap(find.text('➕'));
      expect(tapped, false);
    });
  });
}
