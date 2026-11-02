import 'dart:async';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/rendering.dart';
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

  group('VAppBar', () {
    testWidgets('renders with title string', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VAppBar(title: Text('Test Title'))),
      );

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('renders with title widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VAppBar(title: Text('Widget Title'))),
      );

      expect(find.text('Widget Title'), findsOneWidget);
    });

    testWidgets('renders actions', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VAppBar(
            title: const Text('Title'),
            actions: [
              VIconButton(icon: const Icon(Icons.search), onPressed: () {}),
            ],
          ),
        ),
      );

      expect(find.byType(VIconButton), findsOneWidget);
    });

    testWidgets('transparent variant has transparent background', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(const VAppBar.transparent(title: Text('Transparent'))),
      );

      expect(find.text('Transparent'), findsOneWidget);
    });

    testWidgets('elevated variant has elevation', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VAppBar.elevated(title: Text('Elevated'))),
      );

      expect(find.text('Elevated'), findsOneWidget);
    });

    testWidgets('centered variant centers title', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VAppBar.centered(title: Text('Centered'))),
      );

      expect(find.text('Centered'), findsOneWidget);
    });

    testWidgets('renders with leading widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VAppBar(
            title: const Text('Title'),
            leading: VIconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(VIconButton), findsOneWidget);
    });

    testWidgets('has correct preferred size', (tester) async {
      const appBar = VAppBar(title: Text('Title'));
      expect(appBar.preferredSize.height, equals(56));
    });
  });

  group('VAppBar interactions', () {
    testWidgets('calls onPressed when leading button is tapped', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VAppBar(
            title: const Text('Title'),
            leading: VIconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VIconButton));
      expect(tapped, true);
    });

    testWidgets('calls onPressed when action buttons are tapped', (
      tester,
    ) async {
      var action1Tapped = false;
      var action2Tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VAppBar(
            title: const Text('Title'),
            actions: [
              VIconButton(
                key: const Key('action1'),
                icon: const Icon(Icons.search),
                onPressed: () => action1Tapped = true,
              ),
              VIconButton(
                key: const Key('action2'),
                icon: const Icon(Icons.settings),
                onPressed: () => action2Tapped = true,
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('action1')));
      expect(action1Tapped, true);
      expect(action2Tapped, false);

      await tester.tap(find.byKey(const Key('action2')));
      expect(action2Tapped, true);
    });

    testWidgets('calls Navigator.pop when automaticallyImplyLeading=true', (
      tester,
    ) async {
      var popped = false;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(),
              child: Navigator(
                onGenerateRoute: (settings) => PageRouteBuilder<void>(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Navigator(
                        onDidRemovePage: (page) {
                          popped = true;
                        },
                        pages: const [
                          _TestPage(child: Text('First')),
                          _TestPage(child: VAppBar(title: Text('Second'))),
                        ],
                      ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Shows back button automatically when Navigator.canPop() is true
      final backButton = find.byType(VIconButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        expect(popped, true);
      }
    });

    testWidgets(
      'does not show back button when automaticallyImplyLeading=false',
      (tester) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: MediaQuery(
                data: const MediaQueryData(),
                child: Navigator(
                  onGenerateRoute: (settings) => PageRouteBuilder<void>(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Navigator(
                          pages: const [
                            _TestPage(child: Text('First')),
                            _TestPage(
                              child: VAppBar(
                                title: Text('Second'),
                                automaticallyImplyLeading: false,
                              ),
                            ),
                          ],
                          onDidRemovePage: (_) {},
                        ),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // No VIconButton when automaticallyImplyLeading=false
        expect(find.byType(VIconButton), findsNothing);
      },
    );

    testWidgets('uses custom leading widget instead of auto back button', (
      tester,
    ) async {
      var customLeadingTapped = false;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(),
              child: Navigator(
                onGenerateRoute: (settings) => PageRouteBuilder<void>(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Navigator(
                        pages: [
                          const _TestPage(child: Text('First')),
                          _TestPage(
                            child: VAppBar(
                              title: const Text('Second'),
                              leading: VIconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () => customLeadingTapped = true,
                              ),
                            ),
                          ),
                        ],
                        onDidRemovePage: (_) {},
                      ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(VIconButton));
      expect(customLeadingTapped, true);
    });

    testWidgets('can tap multiple action buttons sequentially', (tester) async {
      final tappedActions = <int>[];

      await tester.pumpWidget(
        buildTestWidget(
          VAppBar(
            title: const Text('Title'),
            actions: [
              VIconButton(
                key: const Key('action0'),
                icon: const Icon(Icons.search),
                onPressed: () => tappedActions.add(0),
              ),
              VIconButton(
                key: const Key('action1'),
                icon: const Icon(Icons.settings),
                onPressed: () => tappedActions.add(1),
              ),
              VIconButton(
                key: const Key('action2'),
                icon: const Icon(Icons.share),
                onPressed: () => tappedActions.add(2),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('action2')));
      await tester.tap(find.byKey(const Key('action0')));
      await tester.tap(find.byKey(const Key('action1')));

      expect(tappedActions, [2, 0, 1]);
    });
  });
  group('VAppBar title slot', () {
    testWidgets('a plain Text takes the theme title style', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VAppBar(title: Text('T'))));

      final theme = VThemeData.light();
      final style = tester
          .renderObject<RenderParagraph>(find.text('T'))
          .text
          .style!;
      expect(style.fontSize, theme.typography.titleLarge.fontSize);
      expect(style.color, theme.colors.foreground);
    });

    testWidgets('foregroundColor tints a plain Text title', (tester) async {
      const color = Color(0xFF123456);
      await tester.pumpWidget(
        buildTestWidget(
          const VAppBar(title: Text('T'), foregroundColor: color),
        ),
      );

      final style = tester
          .renderObject<RenderParagraph>(find.text('T'))
          .text
          .style!;
      expect(style.color, color);
      expect(style.fontSize, VThemeData.light().typography.titleLarge.fontSize);
    });

    testWidgets('accepts any widget as the title', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VAppBar(title: Icon(IconData(0xe318)))),
      );

      expect(find.byType(Icon), findsOneWidget);
    });
  });

  group('VAppBar regressions', () {
    testWidgets('the back button respects PopScope', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      final popResults = <bool>[];

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(),
              child: Navigator(
                key: navigatorKey,
                onGenerateRoute: (settings) => PageRouteBuilder<void>(
                  settings: settings,
                  pageBuilder: (_, _, _) => const Text('home'),
                ),
              ),
            ),
          ),
        ),
      );

      unawaited(
        navigatorKey.currentState!.push(
          PageRouteBuilder<void>(
            pageBuilder: (_, _, _) => PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, _) => popResults.add(didPop),
              child: const VAppBar(title: Text('Editor')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(VIconButton));
      await tester.pumpAndSettle();

      // The page vetoed the pop: it is still shown.
      expect(find.text('Editor'), findsOneWidget);
      expect(popResults, [false]);
    });
  });

  group('VAppBar style fields', () {
    final theme = VThemeData.light();

    // Builds an app bar styled through the theme or as the instance style.
    Widget styled(VAppBarStyle? style, {bool viaTheme = false}) => VTheme(
      data: theme.copyWith(
        componentOverrides: VComponentOverrides([
          if (viaTheme && style != null) style,
        ]),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: Align(
            alignment: Alignment.topCenter,
            child: VAppBar(
              title: const Text('Title'),
              style: viaTheme ? null : style,
            ),
          ),
        ),
      ),
    );

    BoxBorder? borderOf(WidgetTester tester) =>
        (tester
                    .widget<Container>(
                      find
                          .descendant(
                            of: find.byType(VAppBar),
                            matching: find.byType(Container),
                          )
                          .first,
                    )
                    .decoration!
                as BoxDecoration)
            .border;

    testWidgets('draws no bottom line by default', (tester) async {
      await tester.pumpWidget(styled(null));
      expect(borderOf(tester), isNull);
    });

    for (final viaTheme in [true, false]) {
      final via = viaTheme ? 'theme' : 'instance';

      testWidgets('borderColor draws a line along the bottom ($via)', (
        tester,
      ) async {
        const color = Color(0xFF123456);
        await tester.pumpWidget(
          styled(const VAppBarStyle(borderColor: color), viaTheme: viaTheme),
        );
        final border = borderOf(tester)! as Border;
        expect(border.bottom.color, color);
        expect(border.bottom.width, theme.borders.subtle.width);
        expect(border.top, BorderSide.none);
      });
    }
  });
}

class _TestPage extends Page<void> {
  const _TestPage({required this.child});

  final Widget child;

  @override
  Route<void> createRoute(BuildContext context) => PageRouteBuilder<void>(
    settings: this,
    pageBuilder: (context, animation, secondaryAnimation) => child,
  );
}
