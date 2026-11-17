import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child, {VThemeData? theme}) => VTheme(
    data: theme ?? VThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  // A 320 x 640 test screen, so the narrow width is the screen's own.
  void usePhoneView(WidgetTester tester) {
    tester.view
      ..physicalSize = const Size(320, 640)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  // A phone-width box with doubled text, as the large-text setting gives.
  Widget largeText(Widget child, {double height = 640}) => MediaQuery(
    data: MediaQueryData(
      size: Size(320, height),
      textScaler: const TextScaler.linear(2),
    ),
    child: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: 320, height: height, child: child),
    ),
  );

  // The icon, not the overscroll glow of the scroll view.
  final iconPaint = find.descendant(
    of: find.byType(IconTheme),
    matching: find.byType(CustomPaint),
  );

  const longTitle = 'Nothing has been saved to this collection yet';
  const longDescription =
      'Entries you capture with the camera appear here, newest first, '
      'and you can sort or filter them once there are a few of them.';

  group('VEmptyState', () {
    testWidgets('shows the icon, title, description and action', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          VEmptyState(
            icon: VIcons.list(size: 48),
            title: 'No entries yet',
            description: 'Entries you save appear here.',
            action: VButton(onPressed: () {}, child: const Text('Add entry')),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.text('No entries yet'), findsOneWidget);
      expect(find.text('Entries you save appear here.'), findsOneWidget);
      expect(find.text('Add entry'), findsOneWidget);
    });

    testWidgets('shows only the title when nothing else is given', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(const VEmptyState(title: 'No entries yet')),
      );

      expect(find.text('No entries yet'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(find.byType(VButton), findsNothing);
    });

    testWidgets('the title is a heading for screen readers', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestWidget(
          const VEmptyState(
            title: 'No entries yet',
            description: 'Entries you save appear here.',
          ),
        ),
      );

      expect(
        tester.getSemantics(find.text('No entries yet')),
        isSemantics(label: 'No entries yet', isHeader: true),
      );
      expect(
        tester.getSemantics(find.text('Entries you save appear here.')),
        isNot(isSemantics(isHeader: true)),
      );
      handle.dispose();
    });

    testWidgets('centers the content in the space it gets', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 400,
              height: 600,
              child: VEmptyState(title: 'No entries yet'),
            ),
          ),
        ),
      );

      final center = tester.getCenter(find.text('No entries yet'));
      expect(center.dx, moreOrLessEquals(200, epsilon: 1));
      expect(center.dy, moreOrLessEquals(300, epsilon: 1));
    });

    testWidgets('an icon without a color takes the muted foreground', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(VEmptyState(icon: VIcons.list(), title: 'Empty')),
      );

      expect(
        iconPaint,
        paints..circle(color: VThemeData.light().colors.mutedForeground),
      );
    });

    testWidgets('the instance style wins over the theme override', (
      tester,
    ) async {
      const themeColor = Color(0xFF00AA00);
      const instanceColor = Color(0xFF0000AA);
      final theme = VThemeData.light().copyWith(
        componentOverrides: const VComponentOverrides([
          VEmptyStateStyle(
            iconColor: themeColor,
            titleStyle: TextStyle(color: themeColor),
          ),
        ]),
      );

      await tester.pumpWidget(
        buildTestWidget(
          VEmptyState(icon: VIcons.list(), title: 'Empty'),
          theme: theme,
        ),
      );
      expect(iconPaint, paints..circle(color: themeColor));
      expect(tester.widget<Text>(find.text('Empty')).style?.color, themeColor);

      await tester.pumpWidget(
        buildTestWidget(
          VEmptyState(
            icon: VIcons.list(),
            title: 'Empty',
            style: const VEmptyStateStyle(iconColor: instanceColor),
          ),
          theme: theme,
        ),
      );
      expect(iconPaint, paints..circle(color: instanceColor));
      // Fields the instance style leaves null still come from the theme.
      expect(tester.widget<Text>(find.text('Empty')).style?.color, themeColor);
    });

    testWidgets('large text in a narrow box does not overflow', (tester) async {
      usePhoneView(tester);
      await tester.pumpWidget(
        buildTestWidget(
          largeText(
            VEmptyState(
              icon: VIcons.cloud(size: 48),
              title: longTitle,
              description: longDescription,
              // A short label: the test font draws every letter a full em
              // wide, so a long one would overflow the button itself.
              action: VButton(onPressed: () {}, child: const Text('Add')),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text(longTitle), findsOneWidget);
    });

    testWidgets('scrolls instead of overflowing in a short box', (
      tester,
    ) async {
      usePhoneView(tester);
      await tester.pumpWidget(
        buildTestWidget(
          largeText(
            height: 200,
            VEmptyState(
              icon: VIcons.cloud(size: 48),
              title: longTitle,
              description: longDescription,
              action: VButton(onPressed: () {}, child: const Text('Add')),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      await tester.drag(find.text(longTitle), const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('inside a scroll view it keeps its natural height', (
      tester,
    ) async {
      usePhoneView(tester);
      await tester.pumpWidget(
        buildTestWidget(
          largeText(
            ListView(
              children: const [
                VEmptyState(title: longTitle, description: longDescription),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(SingleChildScrollView), findsNothing);
      expect(find.text(longDescription), findsOneWidget);
    });
  });

  group('VEmptyState gaps', () {
    const icon = SizedBox(key: Key('i'), width: 10, height: 10);
    const action = SizedBox(key: Key('act'), width: 10, height: 10);

    Future<List<double>> gaps(
      WidgetTester tester, {
      VEmptyStateStyle? style,
      VThemeData? theme,
    }) async {
      await tester.pumpWidget(
        buildTestWidget(
          Align(
            child: VEmptyState(
              icon: icon,
              title: 'Title',
              description: 'Desc',
              action: action,
              style: style,
            ),
          ),
          theme: theme,
        ),
      );
      final i = tester.getRect(find.byKey(const Key('i')));
      final t = tester.getRect(find.text('Title'));
      final d = tester.getRect(find.text('Desc'));
      final a = tester.getRect(find.byKey(const Key('act')));
      return [t.top - i.bottom, d.top - t.bottom, a.top - d.bottom];
    }

    testWidgets('defaults keep the theme spacing', (tester) async {
      final s = VThemeData.light().spacing;
      expect(await gaps(tester), [s.lg, s.sm, s.xl]);
    });

    testWidgets('instance style sets the gaps', (tester) async {
      expect(
        await gaps(
          tester,
          style: const VEmptyStateStyle(
            iconGap: 1,
            descriptionGap: 2,
            actionGap: 3,
          ),
        ),
        [1, 2, 3],
      );
    });

    testWidgets('theme override sets the gaps', (tester) async {
      final theme = VThemeData.light().copyWith(
        componentOverrides: const VComponentOverrides([
          VEmptyStateStyle(iconGap: 5, actionGap: 7),
        ]),
      );
      final s = VThemeData.light().spacing;
      expect(await gaps(tester, theme: theme), [5, s.sm, 7]);
    });

    test('style copyWith, merge and equality cover the gaps', () {
      const a = VEmptyStateStyle(iconGap: 1, descriptionGap: 2, actionGap: 3);
      expect(a.copyWith(iconGap: 9).iconGap, 9);
      expect(a.merge(const VEmptyStateStyle(actionGap: 8)).actionGap, 8);
      expect(a.merge(const VEmptyStateStyle(actionGap: 8)).iconGap, 1);
      expect(
        a,
        const VEmptyStateStyle(iconGap: 1, descriptionGap: 2, actionGap: 3),
      );
      expect(a == a.copyWith(descriptionGap: 4), isFalse);
      expect(a.hashCode == a.copyWith(actionGap: 4).hashCode, isFalse);
    });
  });
}
