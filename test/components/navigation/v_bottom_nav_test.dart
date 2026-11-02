import 'package:flutter/material.dart' show Icons;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(data: const MediaQueryData(), child: child),
    ),
  );

  final testItems = [
    const VBottomNavItem(key: 'home', icon: Icon(Icons.home), label: 'Home'),
    const VBottomNavItem(
      key: 'search',
      icon: Icon(Icons.search),
      label: 'Search',
    ),
    const VBottomNavItem(
      key: 'profile',
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  group('VBottomNav', () {
    testWidgets('renders items', (tester) async {
      await tester.pumpWidget(buildTestWidget(VBottomNav(items: testItems)));

      // In default variant, only selected item shows label
      expect(find.text('Home'), findsOneWidget);
      expect(find.byType(VBottomNav), findsOneWidget);
    });

    testWidgets('shows selected item label', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VBottomNav(items: testItems, selectedIndex: 1)),
      );

      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('calls onTap when item is tapped', (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(
        buildTestWidget(
          VBottomNav.labeled(
            items: testItems,
            onTap: (index) => tappedIndex = index,
          ),
        ),
      );

      // In labeled variant, all labels are displayed
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      expect(tappedIndex, equals(1));
    });

    testWidgets('labeled variant shows all labels', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VBottomNav.labeled(items: testItems)),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('renders with badge', (tester) async {
      final itemsWithBadge = [
        VBottomNavItem(
          key: 'home',
          icon: const Icon(Icons.home),
          label: 'Home',
          badge: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFFF0000),
              shape: BoxShape.circle,
            ),
          ),
        ),
        const VBottomNavItem(
          key: 'search',
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        const VBottomNavItem(
          key: 'profile',
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];

      await tester.pumpWidget(
        buildTestWidget(VBottomNav(items: itemsWithBadge)),
      );

      expect(find.byType(VBottomNav), findsOneWidget);
    });
  });

  group('VBottomNav callbacks', () {
    testWidgets('onTap reports the tapped index', (tester) async {
      int? tapped;
      await tester.pumpWidget(
        buildTestWidget(VBottomNav(items: testItems, onTap: (i) => tapped = i)),
      );
      await tester.tap(find.byType(GestureDetector).at(1));

      expect(tapped, 1);
    });
  });

  group('VBottomNav regressions', () {
    testWidgets('Enter and Space activate a focused destination', (
      tester,
    ) async {
      int? tapped;
      await tester.pumpWidget(
        buildTestWidget(
          VBottomNav.labeled(
            items: testItems,
            onTap: (index) => tapped = index,
          ),
        ),
      );

      Focus.of(tester.element(find.text('Search'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(tapped, 1);

      Focus.of(tester.element(find.text('Profile'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(tapped, 2);
    });

    testWidgets('grows with the safe-area inset and larger text', (
      tester,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(
                size: Size(400, 800),
                padding: EdgeInsets.only(bottom: 34),
                textScaler: TextScaler.linear(1.6),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: VBottomNav.labeled(items: testItems),
              ),
            ),
          ),
        ),
      );

      // No RenderFlex overflow is reported, and the inset is added to the bar.
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(VBottomNav)).height,
        greaterThanOrEqualTo(80 + 34),
      );
    });
  });

  group('VBottomNav long labels', () {
    testWidgets('shrink to fit four tabs at 320 wide and 2x text', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(320, 640)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final handle = tester.ensureSemantics();
      const labels = [
        'Notifications',
        'Subscriptions',
        'Downloads',
        'Settings',
      ];

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(
                size: Size(320, 640),
                textScaler: TextScaler.linear(2),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: VBottomNav.labeled(
                  items: [
                    for (final label in labels)
                      VBottomNavItem(
                        key: label,
                        icon: const Icon(Icons.home),
                        label: label,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final tabWidth = 320 / labels.length;
      for (final label in labels) {
        final paragraph = tester.renderObject<RenderParagraph>(
          find.text(label),
        );
        expect(paragraph.didExceedMaxLines, isFalse, reason: label);
        // The whole label is drawn, scaled into its tab.
        final drawn = tester.getRect(find.text(label));
        expect(drawn.width, lessThanOrEqualTo(tabWidth + 0.01), reason: label);
        expect(find.bySemanticsLabel(label), findsOneWidget, reason: label);
      }
      handle.dispose();
    });

    testWidgets('a label that fits keeps its size', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          Align(
            alignment: Alignment.bottomCenter,
            child: VBottomNav.labeled(items: testItems),
          ),
        ),
      );

      final paragraph = tester.renderObject<RenderParagraph>(find.text('Home'));
      expect(tester.getSize(find.text('Home')), paragraph.size);
    });
  });

  group('VBottomNav accessibility and style', () {
    const red = Color(0xFFFF0000);
    const green = Color(0xFF00FF00);

    testWidgets('announces each label once', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestWidget(VBottomNav.labeled(items: testItems)),
      );

      expect(find.bySemanticsLabel('Home'), findsOneWidget);
      expect(find.bySemanticsLabel('Search'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('draws no indicator unless indicatorColor is set', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(VBottomNav(items: testItems)));

      expect(find.byType(ColoredBox), findsNothing);
    });

    testWidgets('draws a 4px bar on the top edge of the selected item only', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          VBottomNav(
            items: testItems,
            selectedIndex: 1,
            style: const VBottomNavStyle(indicatorColor: red),
          ),
        ),
      );

      final bar = find.byWidgetPredicate(
        (w) => w is ColoredBox && w.color == red,
      );
      expect(bar, findsOneWidget);
      expect(tester.getSize(bar).height, 4);
      expect(
        tester.getTopLeft(bar).dy,
        tester.getTopLeft(find.byType(VBottomNav)).dy,
      );
      final itemWidth = tester.getSize(find.byType(VBottomNav)).width / 3;
      expect(tester.getSize(bar).width, closeTo(itemWidth, 0.5));
      expect(tester.getTopLeft(bar).dx, closeTo(itemWidth, 0.5));
    });

    testWidgets('indicatorHeight sets the bar thickness', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VBottomNav(
            items: testItems,
            style: const VBottomNavStyle(
              indicatorColor: red,
              indicatorHeight: 6,
            ),
          ),
        ),
      );

      final bar = find.byWidgetPredicate(
        (w) => w is ColoredBox && w.color == red,
      );
      expect(tester.getSize(bar).height, 6);
    });

    testWidgets('borderColor draws a line on the top edge of the bar', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          VBottomNav(
            items: testItems,
            style: const VBottomNavStyle(borderColor: green),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is DecoratedBox &&
              w.decoration is BoxDecoration &&
              (w.decoration as BoxDecoration).border?.top.color == green,
        ),
        findsOneWidget,
      );
    });

    test('style merges and compares the indicator fields', () {
      const base = VBottomNavStyle(indicatorColor: red);
      final merged = base.merge(const VBottomNavStyle(indicatorHeight: 6));

      expect(merged.indicatorColor, red);
      expect(merged.indicatorHeight, 6);
      expect(base.copyWith(indicatorHeight: 6), merged);
      expect(base.copyWith(indicatorHeight: 6).hashCode, merged.hashCode);
      expect(base == merged, isFalse);
    });
  });
}
