import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(
          size: Size(400, 1000),
          padding: EdgeInsets.only(top: 44, bottom: 34),
        ),
        child: child,
      ),
    ),
  );

  group('VScaffold', () {
    testWidgets('renders body', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VScaffold(body: Text('Body Content'))),
      );

      expect(find.text('Body Content'), findsOneWidget);
    });

    testWidgets('renders with app bar', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VScaffold(
            appBar: VAppBar(title: Text('Title')),
            body: Text('Body Content'),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Body Content'), findsOneWidget);
    });

    testWidgets('renders with bottom navigation bar', (tester) async {
      final items = [
        const VBottomNavItem(
          key: 'home',
          icon: Icon(Icons.home),
          label: 'Home',
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
        buildTestWidget(
          VScaffold(
            body: const Text('Body Content'),
            bottomNavigationBar: VBottomNav.labeled(items: items),
          ),
        ),
      );

      expect(find.text('Body Content'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('renders with FAB', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VScaffold(
            body: const Text('Body Content'),
            floatingActionButton: VFab(
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Body Content'), findsOneWidget);
      expect(find.byType(VFab), findsOneWidget);
    });

    testWidgets('renders with drawer', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VScaffold(
            body: Text('Body Content'),
            drawer: VDrawer(child: Text('Drawer Content')),
          ),
        ),
      );

      expect(find.text('Body Content'), findsOneWidget);
      // Drawer is closed by default
      expect(find.text('Drawer Content'), findsNothing);
    });

    testWidgets('uses custom background color', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VScaffold(
            body: Text('Body Content'),
            backgroundColor: Color(0xFFFF0000),
          ),
        ),
      );

      expect(find.byType(VScaffold), findsOneWidget);
    });

    testWidgets('respects extendBody', (tester) async {
      final items = [
        const VBottomNavItem(
          key: 'home',
          icon: Icon(Icons.home),
          label: 'Home',
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
        buildTestWidget(
          VScaffold(
            extendBody: true,
            body: const Text('Body Content'),
            bottomNavigationBar: VBottomNav.labeled(items: items),
          ),
        ),
      );

      expect(find.text('Body Content'), findsOneWidget);
    });

    testWidgets('FAB location centerFloat works', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VScaffold(
            body: const Text('Body Content'),
            floatingActionButton: VFab(
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
            floatingActionButtonLocation: VFabLocation.centerFloat,
          ),
        ),
      );

      expect(find.byType(VFab), findsOneWidget);
    });
  });

  group('VScaffold regressions', () {
    void useSurface(WidgetTester tester) {
      tester.view
        ..physicalSize = const Size(400, 800)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }

    const items = [
      VBottomNavItem(key: 'a', icon: SizedBox(), label: 'a'),
      VBottomNavItem(key: 'b', icon: SizedBox(), label: 'b'),
      VBottomNavItem(key: 'c', icon: SizedBox(), label: 'c'),
    ];

    Widget frame(
      Widget child, {
      EdgeInsets padding = const EdgeInsets.only(top: 40, bottom: 30),
    }) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(size: const Size(400, 800), padding: padding),
          child: child,
        ),
      ),
    );

    Widget scaffold({
      bool nav = true,
      bool extendBody = false,
      Widget? fab,
      VFabLocation location = VFabLocation.endFloat,
    }) => VScaffold(
      appBar: const VAppBar(title: Text('t')),
      extendBody: extendBody,
      floatingActionButton: fab,
      floatingActionButtonLocation: location,
      bottomNavigationBar: nav ? VBottomNav(items: items, onTap: (_) {}) : null,
      body: const SizedBox.expand(key: Key('body')),
    );

    testWidgets('body ends exactly where the bottom nav starts', (
      tester,
    ) async {
      useSurface(tester);
      await tester.pumpWidget(frame(scaffold()));

      final body = tester.getRect(find.byKey(const Key('body')));
      final nav = tester.getRect(find.byType(VBottomNav));
      expect(body.bottom, nav.top);
      expect(nav.bottom, 800 - 30);
    });

    testWidgets('body is not shrunk by a nav height constant', (tester) async {
      useSurface(tester);
      await tester.pumpWidget(frame(scaffold(nav: false)));
      final without = tester.getSize(find.byKey(const Key('body'))).height;

      await tester.pumpWidget(frame(scaffold()));
      final withNav = tester.getSize(find.byKey(const Key('body'))).height;
      final navHeight = tester.getSize(find.byType(VBottomNav)).height;

      expect(withNav, closeTo(without - navHeight, 0.01));
    });

    testWidgets('system insets are applied once to the bars', (tester) async {
      useSurface(tester);
      await tester.pumpWidget(frame(scaffold(), padding: EdgeInsets.zero));
      final plainBar = tester.getSize(find.byType(VAppBar)).height;
      final plainNav = tester.getSize(find.byType(VBottomNav)).height;

      await tester.pumpWidget(frame(scaffold()));
      final bar = tester.getRect(find.byType(VAppBar));
      final nav = tester.getSize(find.byType(VBottomNav));

      expect(bar.top, 40);
      expect(bar.height, plainBar);
      expect(nav.height, plainNav);
    });

    testWidgets('the body does not see the padding the scaffold consumed', (
      tester,
    ) async {
      useSurface(tester);
      EdgeInsets? seen;
      await tester.pumpWidget(
        frame(
          VScaffold(
            appBar: const VAppBar(title: Text('t')),
            body: Builder(
              builder: (context) {
                seen = MediaQuery.paddingOf(context);
                return const SizedBox.expand();
              },
            ),
          ),
        ),
      );

      expect(seen, EdgeInsets.zero);
    });

    testWidgets('a floating FAB sits one gap above the nav', (tester) async {
      useSurface(tester);
      final lg = VThemeData.light().spacing.lg;
      const fab = SizedBox(key: Key('fab'), width: 40, height: 40);

      await tester.pumpWidget(frame(scaffold(fab: fab)));
      var nav = tester.getRect(find.byType(VBottomNav));
      expect(tester.getRect(find.byKey(const Key('fab'))).bottom, nav.top - lg);

      await tester.pumpWidget(frame(scaffold(fab: fab, extendBody: true)));
      nav = tester.getRect(find.byType(VBottomNav));
      expect(nav.bottom, 800 - 30);
      expect(tester.getRect(find.byKey(const Key('fab'))).bottom, nav.top - lg);
    });

    testWidgets('FAB locations keep their horizontal alignment', (
      tester,
    ) async {
      useSurface(tester);
      final lg = VThemeData.light().spacing.lg;
      const fab = SizedBox(key: Key('fab'), width: 40, height: 40);

      await tester.pumpWidget(frame(scaffold(fab: fab)));
      expect(tester.getRect(find.byKey(const Key('fab'))).right, 400 - lg);

      await tester.pumpWidget(
        frame(scaffold(fab: fab, location: VFabLocation.startFloat)),
      );
      expect(tester.getRect(find.byKey(const Key('fab'))).left, lg);

      await tester.pumpWidget(
        frame(scaffold(fab: fab, location: VFabLocation.centerDocked)),
      );
      expect(tester.getRect(find.byKey(const Key('fab'))).center.dx, 200);
    });

    testWidgets('a wide drawer starts fully off screen', (tester) async {
      useSurface(tester);
      late BuildContext inner;
      await tester.pumpWidget(
        frame(
          VScaffold(
            drawer: const VDrawer(child: SizedBox()),
            body: Builder(
              builder: (context) {
                inner = context;
                return const SizedBox.expand();
              },
            ),
          ),
          padding: EdgeInsets.zero,
        ),
      );

      VScaffold.openDrawer(inner);
      await tester.pump();

      final drawer = tester.getRect(find.byType(VDrawer));
      expect(drawer.width, greaterThan(304));
      expect(drawer.right, lessThanOrEqualTo(0.01));

      await tester.pumpAndSettle();
      expect(tester.getRect(find.byType(VDrawer)).left, 0);
    });

    testWidgets('closing the start drawer leaves an open end drawer alone', (
      tester,
    ) async {
      useSurface(tester);
      late BuildContext inner;
      await tester.pumpWidget(
        frame(
          VScaffold(
            drawer: const VDrawer(child: SizedBox()),
            endDrawer: const VDrawer(child: SizedBox()),
            body: Builder(
              builder: (context) {
                inner = context;
                return const SizedBox.expand();
              },
            ),
          ),
          padding: EdgeInsets.zero,
        ),
      );

      VScaffold.openEndDrawer(inner);
      await tester.pumpAndSettle();
      VScaffold.closeDrawer(inner);
      await tester.pumpAndSettle();

      expect(find.byType(VDrawer), findsOneWidget);
      expect(tester.getRect(find.byType(VDrawer)).right, 400);
    });
  });

  group('VScaffold style fields', () {
    final theme = VThemeData.light();
    const color = Color(0xFF123456);

    // Builds a scaffold styled through the theme or as the instance style.
    Widget styled(
      VScaffoldStyle? style, {
      bool viaTheme = false,
      Color? backgroundColor,
    }) => VTheme(
      data: theme.copyWith(
        componentOverrides: VComponentOverrides([
          if (viaTheme && style != null) style,
        ]),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: VScaffold(
            backgroundColor: backgroundColor,
            style: viaTheme ? null : style,
            body: const Text('Body'),
          ),
        ),
      ),
    );

    Color? screenColor(WidgetTester tester) => tester
        .widget<Container>(
          find
              .descendant(
                of: find.byType(VScaffold),
                matching: find.byType(Container),
              )
              .first,
        )
        .color;

    testWidgets('defaults to the theme background', (tester) async {
      await tester.pumpWidget(styled(null));
      expect(screenColor(tester), theme.colors.background);
    });

    for (final viaTheme in [true, false]) {
      final via = viaTheme ? 'theme' : 'instance';

      testWidgets('backgroundColor fills the screen ($via)', (tester) async {
        await tester.pumpWidget(
          styled(
            const VScaffoldStyle(backgroundColor: color),
            viaTheme: viaTheme,
          ),
        );
        expect(screenColor(tester), color);
      });

      testWidgets('the backgroundColor argument wins over the style ($via)', (
        tester,
      ) async {
        const argument = Color(0xFF654321);
        await tester.pumpWidget(
          styled(
            const VScaffoldStyle(backgroundColor: color),
            viaTheme: viaTheme,
            backgroundColor: argument,
          ),
        );
        expect(screenColor(tester), argument);
      });
    }

    testWidgets('an instance style wins over the theme override', (
      tester,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: theme.copyWith(
            componentOverrides: const VComponentOverrides([
              VScaffoldStyle(backgroundColor: Color(0xFFFF0000)),
            ]),
          ),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQueryData(size: Size(400, 800)),
              child: VScaffold(
                style: VScaffoldStyle(backgroundColor: color),
                body: Text('Body'),
              ),
            ),
          ),
        ),
      );
      expect(screenColor(tester), color);
    });
  });
}
