import 'package:flutter/material.dart' show Icons;
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
}
