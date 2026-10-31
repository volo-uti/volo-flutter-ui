import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: child,
      ),
    ),
  );

  group('VDrawer', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VDrawer(child: Text('Drawer Content'))),
      );

      expect(find.text('Drawer Content'), findsOneWidget);
    });

    testWidgets('renders with header', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VDrawer(header: Text('Header'), child: Text('Content')),
        ),
      );

      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('renders with footer', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VDrawer(footer: Text('Footer'), child: Text('Content')),
        ),
      );

      expect(find.text('Footer'), findsOneWidget);
    });

    testWidgets('end variant renders', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VDrawer.end(child: Text('End Drawer'))),
      );

      expect(find.text('End Drawer'), findsOneWidget);
    });

    testWidgets('persistent variant renders', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VDrawer.persistent(child: Text('Persistent Drawer')),
        ),
      );

      expect(find.text('Persistent Drawer'), findsOneWidget);
    });

    testWidgets('respects custom width', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VDrawer(width: 250, child: Text('Custom Width'))),
      );

      expect(find.text('Custom Width'), findsOneWidget);
    });

    testWidgets('has semantic label', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VDrawer(
            semanticLabel: 'Navigation Menu',
            child: Text('Content'),
          ),
        ),
      );

      // Verify the drawer renders with semanticLabel property
      final drawer = tester.widget<VDrawer>(find.byType(VDrawer));
      expect(drawer.semanticLabel, equals('Navigation Menu'));
    });
  });

  group('VDrawer interactions', () {
    testWidgets('calls onTap when item in drawer is tapped', (tester) async {
      var itemTapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VDrawer(
            child: Column(
              children: [
                GestureDetector(
                  key: const Key('drawer-item'),
                  onTap: () => itemTapped = true,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Menu Item'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('drawer-item')));
      expect(itemTapped, true);
    });

    testWidgets('can tap multiple items in drawer', (tester) async {
      final tappedItems = <int>[];

      await tester.pumpWidget(
        buildTestWidget(
          VDrawer(
            child: Column(
              children: [
                GestureDetector(
                  key: const Key('item-0'),
                  onTap: () => tappedItems.add(0),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Home'),
                  ),
                ),
                GestureDetector(
                  key: const Key('item-1'),
                  onTap: () => tappedItems.add(1),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Settings'),
                  ),
                ),
                GestureDetector(
                  key: const Key('item-2'),
                  onTap: () => tappedItems.add(2),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('item-1')));
      await tester.tap(find.byKey(const Key('item-0')));
      await tester.tap(find.byKey(const Key('item-2')));

      expect(tappedItems, [1, 0, 2]);
    });

    testWidgets('calls callback when footer button is tapped', (tester) async {
      var footerTapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VDrawer(
            footer: GestureDetector(
              key: const Key('footer-button'),
              onTap: () => footerTapped = true,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Logout'),
              ),
            ),
            child: const Text('Content'),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('footer-button')));
      expect(footerTapped, true);
    });

    testWidgets('calls callback when header button is tapped', (tester) async {
      var headerTapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VDrawer(
            header: GestureDetector(
              key: const Key('header-button'),
              onTap: () => headerTapped = true,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('User Profile'),
              ),
            ),
            child: const Text('Content'),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('header-button')));
      expect(headerTapped, true);
    });

    testWidgets('tap drawer item using VButton', (tester) async {
      var buttonTapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VDrawer(
            child: Column(
              children: [
                VButton(
                  key: const Key('drawer-button'),
                  onPressed: () => buttonTapped = true,
                  child: const Text('Dashboard'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('drawer-button')));
      expect(buttonTapped, true);
    });

    testWidgets('tap item in end variant drawer', (tester) async {
      var itemTapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VDrawer.end(
            child: Column(
              children: [
                GestureDetector(
                  key: const Key('end-drawer-item'),
                  onTap: () => itemTapped = true,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Notifications'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('end-drawer-item')));
      expect(itemTapped, true);
    });

    testWidgets('tap item in persistent variant drawer', (tester) async {
      var itemTapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VDrawer.persistent(
            child: Column(
              children: [
                GestureDetector(
                  key: const Key('persistent-item'),
                  onTap: () => itemTapped = true,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Menu'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('persistent-item')));
      expect(itemTapped, true);
    });

    testWidgets('open/close state change', (tester) async {
      var isOpen = false;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(800, 600)),
              child: StatefulBuilder(
                builder: (context, setState) => Row(
                  children: [
                    if (isOpen)
                      VDrawer(
                        child: Column(
                          children: [
                            GestureDetector(
                              key: const Key('close-button'),
                              onTap: () => setState(() => isOpen = false),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Center(
                        child: GestureDetector(
                          key: const Key('open-button'),
                          onTap: () => setState(() => isOpen = true),
                          child: const Text('Open Drawer'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Drawer is closed
      expect(find.byType(VDrawer), findsNothing);

      // Open drawer
      await tester.tap(find.byKey(const Key('open-button')));
      await tester.pumpAndSettle();

      expect(find.byType(VDrawer), findsOneWidget);

      // Close drawer
      await tester.tap(find.byKey(const Key('close-button')));
      await tester.pumpAndSettle();

      expect(find.byType(VDrawer), findsNothing);
    });

    testWidgets('scrollable drawer content', (tester) async {
      final tappedItems = <int>[];

      await tester.pumpWidget(
        buildTestWidget(
          VDrawer(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  20,
                  (index) => GestureDetector(
                    key: Key('scroll-item-$index'),
                    onTap: () => tappedItems.add(index),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Item $index'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap first item
      await tester.tap(find.byKey(const Key('scroll-item-0')));
      expect(tappedItems.contains(0), true);

      // Tap second item
      await tester.tap(find.byKey(const Key('scroll-item-1')));
      expect(tappedItems.contains(1), true);

      // Verify tap order
      expect(tappedItems, [0, 1]);
    });
  });

  group('VDrawer onClose', () {
    testWidgets('Escape calls onClose', (tester) async {
      var closed = 0;
      await tester.pumpWidget(
        buildTestWidget(
          VDrawer(onClose: () => closed++, child: const Text('Content')),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);

      expect(closed, 1);
    });
  });

  group('VDrawer regressions', () {
    testWidgets('a persistent drawer does not take focus from the page', (
      tester,
    ) async {
      final fieldFocus = FocusNode();
      addTearDown(fieldFocus.dispose);

      await tester.pumpWidget(
        buildTestWidget(
          Row(
            children: [
              const VDrawer.persistent(child: Text('Menu')),
              Expanded(
                child: Focus(
                  focusNode: fieldFocus,
                  autofocus: true,
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(fieldFocus.hasFocus, isTrue);
    });

    testWidgets('a drawer with onClose still receives Escape', (tester) async {
      var closed = 0;
      await tester.pumpWidget(
        buildTestWidget(
          VDrawer(onClose: () => closed++, child: const Text('Menu')),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);

      expect(closed, 1);
    });

    testWidgets('the end drawer rounds the corners that face the content', (
      tester,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: MediaQueryData(size: Size(800, 600)),
              child: VDrawer.end(child: Text('Menu')),
            ),
          ),
        ),
      );

      final box = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(VDrawer),
              matching: find.byType(Container),
            )
            .first,
      );
      final radius = (box.decoration! as BoxDecoration).borderRadius!.resolve(
        TextDirection.rtl,
      );
      // The start side of an RTL layout is the right side.
      expect(radius.topRight.x, greaterThan(0));
      expect(radius.topLeft.x, 0);
    });
  });
}
