import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VBadge', () {
    testWidgets('creates default badge', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBadge(label: Text('New')),
          ),
        ),
      );

      expect(find.byType(VBadge), findsOneWidget);
      expect(find.text('New'), findsOneWidget);
    });

    testWidgets('primary badge', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBadge.primary(label: Text('Important')),
          ),
        ),
      );

      expect(find.byType(VBadge), findsOneWidget);
    });

    testWidgets('destructive badge', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBadge.destructive(label: Text('Error')),
          ),
        ),
      );

      expect(find.byType(VBadge), findsOneWidget);
    });

    testWidgets('outline badge', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBadge.outline(label: Text('Outlined')),
          ),
        ),
      );

      expect(find.byType(VBadge), findsOneWidget);
    });

    testWidgets('semanticLabel replaces the text for screen readers', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBadge(label: Text('5'), semanticLabel: '5 unread'),
          ),
        ),
      );

      expect(find.bySemanticsLabel('5 unread'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('invisible badge renders nothing', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBadge(label: Text('5'), invisible: true),
          ),
        ),
      );

      expect(find.text('5'), findsNothing);
    });

    testWidgets('count shows the number, capped at max', (tester) async {
      Future<void> pump(VBadge badge) => tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(textDirection: TextDirection.ltr, child: badge),
        ),
      );

      await pump(VBadge.count(count: 5));
      expect(find.text('5'), findsOneWidget);

      await pump(VBadge.count(count: 120));
      expect(find.text('99+'), findsOneWidget);

      await pump(VBadge.count(count: 12, max: 9));
      expect(find.text('9+'), findsOneWidget);

      await pump(VBadge.count(count: 99));
      expect(find.text('99'), findsOneWidget);
    });

    testWidgets('count clamps negative counts and a max below 1', (
      tester,
    ) async {
      Future<void> pump(VBadge badge) => tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(textDirection: TextDirection.ltr, child: badge),
        ),
      );

      await pump(VBadge.count(count: -5));
      expect(find.text('0'), findsOneWidget);

      await pump(VBadge.count(count: 5, max: -1));
      expect(find.text('1+'), findsOneWidget);
      expect(find.text('-1+'), findsNothing);
    });

    testWidgets('renders with each size', (tester) async {
      for (final size in VBadgeSize.values) {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VBadge(label: const Text('Test'), size: size),
            ),
          ),
        );

        expect(find.byType(VBadge), findsOneWidget);
      }
    });

    testWidgets('supports Widget child', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VBadge(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.check, size: 12), Text('Done')],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(VBadge), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
    });

    group('theme override', () {
      testWidgets('theme componentOverrides applies to badge', (tester) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VBadgeStyle(backgroundColor: Color(0xFFFF0000)),
              ]),
            ),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: VBadge(label: Text('New')),
            ),
          ),
        );

        expect(find.byType(VBadge), findsOneWidget);
      });
    });
  });
}
