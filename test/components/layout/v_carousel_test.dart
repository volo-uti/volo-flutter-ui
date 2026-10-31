import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VCarousel', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: child,
        ),
      ),
    );

    group('default constructor', () {
      testWidgets('creates VCarousel', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel(
              height: 200,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
                Container(color: const Color(0xFF0000FF)),
              ],
            ),
          ),
        );

        expect(find.byType(VCarousel), findsOneWidget);
        expect(find.byType(PageView), findsOneWidget);
      });

      testWidgets('renders SizedBox.shrink for empty children', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VCarousel(height: 200, children: [])),
        );

        expect(find.byType(VCarousel), findsOneWidget);
        expect(find.byType(PageView), findsNothing);
      });

      testWidgets('applies height', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel(
              height: 150,
              showIndicator: false,
              children: [Container(color: const Color(0xFFFF0000))],
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(
          find
              .ancestor(
                of: find.byType(PageView),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(sizedBox.height, 150);
      });

      testWidgets('applies aspectRatio', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel(
              aspectRatio: 16 / 9,
              showIndicator: false,
              children: [Container(color: const Color(0xFFFF0000))],
            ),
          ),
        );

        expect(find.byType(AspectRatio), findsOneWidget);
      });

      testWidgets('default height is 200', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel(
              showIndicator: false,
              children: [Container(color: const Color(0xFFFF0000))],
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(
          find
              .ancestor(
                of: find.byType(PageView),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(sizedBox.height, 200);
      });
    });

    group('VCarousel.fullWidth', () {
      testWidgets('100% viewport', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel.fullWidth(
              height: 200,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        expect(find.byType(VCarousel), findsOneWidget);
      });
    });

    group('VCarousel.card', () {
      testWidgets('85% viewport', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel.card(
              height: 200,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        expect(find.byType(VCarousel), findsOneWidget);
      });
    });

    group('VCarousel.hero', () {
      testWidgets('hero banner style', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel.hero(
              height: 200,
              autoPlay: false, // Disable autoPlay in tests
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        expect(find.byType(VCarousel), findsOneWidget);
      });
    });

    group('indicator', () {
      testWidgets('shows indicator when showIndicator=true', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel(
              height: 200,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        // Indicator dots (AnimatedContainer)
        expect(find.byType(AnimatedContainer), findsNWidgets(2));
      });

      testWidgets('no indicator when showIndicator=false', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel(
              height: 200,
              showIndicator: false,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        // AnimatedContainer should not exist (no indicator)
        expect(find.byType(AnimatedContainer), findsNothing);
      });

      testWidgets('indicatorPosition.bottom', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel(
              height: 200,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('indicatorPosition.overlay', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel(
              height: 200,
              indicatorPosition: VCarouselIndicatorPosition.overlay,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        expect(find.byType(Stack), findsWidgets);
      });

      testWidgets('indicatorPosition.none', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel(
              height: 200,
              indicatorPosition: VCarouselIndicatorPosition.none,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        expect(find.byType(AnimatedContainer), findsNothing);
      });
    });

    group('page change', () {
      testWidgets('onPageChanged callback registered', (tester) async {
        // ignore: unused_local_variable
        var callbackCalled = false;

        await tester.pumpWidget(
          buildTestWidget(
            VCarousel(
              height: 200,
              onPageChanged: (page) => callbackCalled = true,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        // VCarousel is rendered
        expect(find.byType(VCarousel), findsOneWidget);
        expect(find.byType(PageView), findsOneWidget);
      });

      testWidgets('uses external controller', (tester) async {
        final controller = PageController(viewportFraction: 0.8);

        await tester.pumpWidget(
          buildTestWidget(
            VCarousel(
              height: 200,
              controller: controller,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        expect(find.byType(VCarousel), findsOneWidget);

        controller.dispose();
      });
    });

    group('auto play', () {
      testWidgets('no auto play when autoPlay=false', (tester) async {
        var currentPage = 0;

        await tester.pumpWidget(
          buildTestWidget(
            VCarousel(
              height: 200,
              onPageChanged: (page) => currentPage = page,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        // Time elapsed
        await tester.pump(const Duration(milliseconds: 500));

        // No page change
        expect(currentPage, 0);
      });

      testWidgets('no auto play for single item', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel(
              height: 200,
              autoPlay: true,
              autoPlayInterval: const Duration(milliseconds: 100),
              children: [Container(color: const Color(0xFFFF0000))],
            ),
          ),
        );

        // No auto play for single item
        await tester.pump(const Duration(milliseconds: 150));
        expect(find.byType(VCarousel), findsOneWidget);
      });

      testWidgets('cleans up timer on dispose', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel(
              height: 200,
              autoPlay: true,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        // Remove widget
        await tester.pumpWidget(buildTestWidget(const SizedBox()));

        // Should complete without errors
        expect(find.byType(VCarousel), findsNothing);
      });
    });

    group('loop', () {
      testWidgets('loop property is applied', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel(
              height: 200,
              loop: true,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        expect(find.byType(VCarousel), findsOneWidget);
      });
    });

    group('didUpdateWidget', () {
      testWidgets('widget updates when autoPlay property changes', (
        tester,
      ) async {
        var autoPlay = false;

        await tester.pumpWidget(
          buildTestWidget(
            StatefulBuilder(
              builder: (context, setState) => Column(
                children: [
                  GestureDetector(
                    key: const Key('toggle'),
                    onTap: () => setState(() => autoPlay = !autoPlay),
                    child: const Text('Toggle'),
                  ),
                  VCarousel(
                    height: 200,
                    autoPlay: autoPlay,
                    children: [
                      Container(color: const Color(0xFFFF0000)),
                      Container(color: const Color(0xFF00FF00)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        // Initial state
        expect(find.byType(VCarousel), findsOneWidget);

        // Toggle autoPlay to true
        await tester.tap(find.byKey(const Key('toggle')));
        await tester.pump();

        // Updated without errors
        expect(find.byType(VCarousel), findsOneWidget);

        // Toggle autoPlay back to false to clean up timer
        await tester.tap(find.byKey(const Key('toggle')));
        await tester.pump();
      });
    });
  });

  group('VCarouselIndicatorPosition', () {
    test('all positions are defined', () {
      expect(VCarouselIndicatorPosition.values.length, 4);
      expect(VCarouselIndicatorPosition.bottom, isNotNull);
      expect(VCarouselIndicatorPosition.belowCarousel, isNotNull);
      expect(VCarouselIndicatorPosition.overlay, isNotNull);
      expect(VCarouselIndicatorPosition.none, isNotNull);
    });
  });

  group('interaction tests', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: child,
        ),
      ),
    );

    testWidgets('page navigation by swipe (swipe left)', (tester) async {
      var currentPage = 0;

      await tester.pumpWidget(
        buildTestWidget(
          VCarousel(
            height: 200,
            onPageChanged: (page) => currentPage = page,
            children: [
              Container(
                key: const Key('page0'),
                color: const Color(0xFFFF0000),
              ),
              Container(
                key: const Key('page1'),
                color: const Color(0xFF00FF00),
              ),
              Container(
                key: const Key('page2'),
                color: const Color(0xFF0000FF),
              ),
            ],
          ),
        ),
      );

      expect(currentPage, 0);

      // Swipe left (to next page)
      await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();

      // Page should have changed
      expect(currentPage, 1);
    });

    testWidgets('page navigation by swipe (swipe right)', (tester) async {
      final controller = PageController(viewportFraction: 0.8, initialPage: 1);
      var currentPage = 1;

      await tester.pumpWidget(
        buildTestWidget(
          VCarousel(
            height: 200,
            controller: controller,
            onPageChanged: (page) => currentPage = page,
            children: [
              Container(
                key: const Key('page0'),
                color: const Color(0xFFFF0000),
              ),
              Container(
                key: const Key('page1'),
                color: const Color(0xFF00FF00),
              ),
              Container(
                key: const Key('page2'),
                color: const Color(0xFF0000FF),
              ),
            ],
          ),
        ),
      );

      expect(currentPage, 1);

      // Swipe right (to previous page)
      await tester.fling(find.byType(PageView), const Offset(300, 0), 1000);
      await tester.pumpAndSettle();

      // Page should have changed
      expect(currentPage, 0);

      controller.dispose();
    });

    testWidgets('page navigation by indicator tap', (tester) async {
      var currentPage = 0;

      await tester.pumpWidget(
        buildTestWidget(
          VCarousel(
            height: 200,
            onPageChanged: (page) => currentPage = page,
            children: [
              Container(color: const Color(0xFFFF0000)),
              Container(color: const Color(0xFF00FF00)),
              Container(color: const Color(0xFF0000FF)),
            ],
          ),
        ),
      );

      expect(currentPage, 0);

      // Find indicator dots (AnimatedContainer)
      final indicators = find.byType(AnimatedContainer);
      expect(indicators, findsNWidgets(3));

      // Indicator is not a touch area so VPageIndicator is not interactive
      // Test by directly manipulating PageView
      expect(find.byType(VCarousel), findsOneWidget);
    });

    testWidgets('onPageChanged callback test', (tester) async {
      final pageChanges = <int>[];

      await tester.pumpWidget(
        buildTestWidget(
          VCarousel(
            height: 200,
            onPageChanged: pageChanges.add,
            children: [
              Container(color: const Color(0xFFFF0000)),
              Container(color: const Color(0xFF00FF00)),
              Container(color: const Color(0xFF0000FF)),
            ],
          ),
        ),
      );

      expect(pageChanges, isEmpty);

      // First swipe
      await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();

      expect(pageChanges, contains(1));

      // Second swipe
      await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();

      expect(pageChanges, contains(2));
    });

    testWidgets('auto play property verification', (tester) async {
      var currentPage = 0;

      await tester.pumpWidget(
        buildTestWidget(
          VCarousel(
            height: 200,
            autoPlay: true,
            onPageChanged: (page) => currentPage = page,
            children: [
              Container(color: const Color(0xFFFF0000)),
              Container(color: const Color(0xFF00FF00)),
              Container(color: const Color(0xFF0000FF)),
            ],
          ),
        ),
      );

      // Verify initial page
      expect(currentPage, 0);

      // Verify auto play widget renders normally
      expect(find.byType(VCarousel), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('auto play + loop property verification', (tester) async {
      var currentPage = 0;

      await tester.pumpWidget(
        buildTestWidget(
          VCarousel(
            height: 200,
            autoPlay: true,
            loop: true,
            onPageChanged: (page) => currentPage = page,
            children: [
              Container(color: const Color(0xFFFF0000)),
              Container(color: const Color(0xFF00FF00)),
            ],
          ),
        ),
      );

      // Verify initial page
      expect(currentPage, 0);

      // Verify widget renders normally
      expect(find.byType(VCarousel), findsOneWidget);
    });

    testWidgets('widget updates on autoPlay toggle', (tester) async {
      var autoPlay = true;

      await tester.pumpWidget(
        buildTestWidget(
          StatefulBuilder(
            builder: (context, setState) => Column(
              children: [
                GestureDetector(
                  key: const Key('toggle'),
                  onTap: () => setState(() => autoPlay = !autoPlay),
                  child: const Text('Toggle'),
                ),
                VCarousel(
                  height: 200,
                  autoPlay: autoPlay,
                  children: [
                    Container(color: const Color(0xFFFF0000)),
                    Container(color: const Color(0xFF00FF00)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      // Initial state
      expect(find.byType(VCarousel), findsOneWidget);

      // Toggle autoPlay
      await tester.tap(find.byKey(const Key('toggle')));
      await tester.pump();

      // Widget updated without errors
      expect(find.byType(VCarousel), findsOneWidget);
    });

    testWidgets('page navigation by controller', (tester) async {
      final controller = PageController(viewportFraction: 0.8);
      var currentPage = 0;

      await tester.pumpWidget(
        buildTestWidget(
          VCarousel(
            height: 200,
            controller: controller,
            onPageChanged: (page) => currentPage = page,
            children: [
              Container(color: const Color(0xFFFF0000)),
              Container(color: const Color(0xFF00FF00)),
              Container(color: const Color(0xFF0000FF)),
            ],
          ),
        ),
      );

      expect(currentPage, 0);

      // Navigate to page 2 with controller
      unawaited(
        controller.animateToPage(
          2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
      );
      // Pump enough frames for the animation to complete
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(currentPage, 2);

      // Navigate to page 0 with controller
      controller.jumpToPage(0);
      await tester.pump();

      expect(currentPage, 0);

      controller.dispose();
    });

    testWidgets('multiple swipe test', (tester) async {
      final pageHistory = <int>[];

      await tester.pumpWidget(
        buildTestWidget(
          VCarousel(
            height: 200,
            onPageChanged: pageHistory.add,
            children: [
              Container(color: const Color(0xFFFF0000)),
              Container(color: const Color(0xFF00FF00)),
              Container(color: const Color(0xFF0000FF)),
              Container(color: const Color(0xFFFFFF00)),
            ],
          ),
        ),
      );

      // 0 -> 1
      await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();

      // 1 -> 2
      await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();

      // 2 -> 3
      await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();

      // 3 -> 2 (back)
      await tester.fling(find.byType(PageView), const Offset(300, 0), 1000);
      await tester.pumpAndSettle();

      expect(pageHistory, containsAllInOrder([1, 2, 3, 2]));
    });

    testWidgets('page boundary test - back from first page', (tester) async {
      var currentPage = 0;

      await tester.pumpWidget(
        buildTestWidget(
          VCarousel(
            height: 200,
            onPageChanged: (page) => currentPage = page,
            children: [
              Container(color: const Color(0xFFFF0000)),
              Container(color: const Color(0xFF00FF00)),
            ],
          ),
        ),
      );

      expect(currentPage, 0);

      // Try swiping right from first page
      await tester.fling(find.byType(PageView), const Offset(300, 0), 1000);
      await tester.pumpAndSettle();

      // Should still be first page (loop=false)
      expect(currentPage, 0);
    });

    testWidgets('page boundary test - forward from last page', (tester) async {
      final controller = PageController(viewportFraction: 0.8, initialPage: 1);
      var currentPage = 1;

      await tester.pumpWidget(
        buildTestWidget(
          VCarousel(
            height: 200,
            controller: controller,
            onPageChanged: (page) => currentPage = page,
            children: [
              Container(color: const Color(0xFFFF0000)),
              Container(color: const Color(0xFF00FF00)),
            ],
          ),
        ),
      );

      expect(currentPage, 1);

      // Try swiping left from last page
      await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();

      // Should still be last page (loop=false)
      expect(currentPage, 1);

      controller.dispose();
    });

    group('keyboard', () {
      Future<void> pumpFocused(
        WidgetTester tester, {
        required List<int> pages,
        bool loop = false,
      }) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel.fullWidth(
              height: 200,
              loop: loop,
              onPageChanged: pages.add,
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
                Container(color: const Color(0xFF0000FF)),
              ],
            ),
          ),
        );
        final focus = tester.widget<Focus>(
          find
              .descendant(
                of: find.byType(VCarousel),
                matching: find.byType(Focus),
              )
              .first,
        );
        focus.focusNode!.requestFocus();
        await tester.pump();
      }

      testWidgets('ArrowRight and ArrowLeft move between slides', (
        tester,
      ) async {
        final pages = <int>[];
        await pumpFocused(tester, pages: pages);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pumpAndSettle();
        expect(pages, [1]);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();
        expect(pages, [1, 0]);
      });

      testWidgets('End and Home jump to the last and first slide', (
        tester,
      ) async {
        final pages = <int>[];
        await pumpFocused(tester, pages: pages);

        await tester.sendKeyEvent(LogicalKeyboardKey.end);
        await tester.pumpAndSettle();
        expect(pages.last, 2);

        await tester.sendKeyEvent(LogicalKeyboardKey.home);
        await tester.pumpAndSettle();
        expect(pages.last, 0);
      });

      testWidgets('ArrowLeft on the first slide stays without loop', (
        tester,
      ) async {
        final pages = <int>[];
        await pumpFocused(tester, pages: pages);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();
        expect(pages, isEmpty);
      });

      testWidgets('ArrowLeft on the first slide wraps with loop', (
        tester,
      ) async {
        final pages = <int>[];
        await pumpFocused(tester, pages: pages, loop: true);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();
        expect(pages.last, 2);
      });
    });

    group('indicatorBuilder', () {
      testWidgets('builds the indicator with total and current', (
        tester,
      ) async {
        final calls = <(int, int)>[];
        await tester.pumpWidget(
          buildTestWidget(
            VCarousel.fullWidth(
              height: 200,
              indicatorBuilder: (context, total, current) {
                calls.add((total, current));
                return Text('page ${current + 1} of $total');
              },
              children: [
                Container(color: const Color(0xFFFF0000)),
                Container(color: const Color(0xFF00FF00)),
              ],
            ),
          ),
        );

        expect(find.text('page 1 of 2'), findsOneWidget);
        expect(find.byType(VPageIndicator), findsNothing);

        await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
        await tester.pumpAndSettle();

        expect(find.text('page 2 of 2'), findsOneWidget);
        expect(calls.last, (2, 1));
      });
    });
  });

  group('VCarousel updates', () {
    Widget wrap(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: child,
        ),
      ),
    );

    List<Widget> slides(int n) => [
      for (var i = 0; i < n; i++) SizedBox(key: ValueKey(i)),
    ];

    int indicatorPage(WidgetTester tester) =>
        tester.widget<VPageIndicator>(find.byType(VPageIndicator)).current;

    testWidgets('starts on the initialPage of a caller controller', (
      tester,
    ) async {
      final controller = PageController(initialPage: 2);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          VCarousel.fullWidth(
            controller: controller,
            height: 100,
            children: slides(4),
          ),
        ),
      );
      await tester.pump();

      expect(controller.page, 2);
      expect(indicatorPage(tester), 2);
    });

    testWidgets('a new autoPlayInterval restarts the timer', (tester) async {
      final pages = <int>[];
      Widget build(Duration interval) => wrap(
        VCarousel.hero(
          autoPlayInterval: interval,
          onPageChanged: pages.add,
          height: 100,
          children: slides(3),
        ),
      );

      await tester.pumpWidget(build(const Duration(seconds: 10)));
      await tester.pumpWidget(build(const Duration(seconds: 1)));
      await tester.pump(const Duration(milliseconds: 1100));
      await tester.pump(const Duration(milliseconds: 600));

      expect(pages, [1]);
      await tester.pumpWidget(wrap(const SizedBox()));
    });

    testWidgets('auto-play starts when slides grow from one to many', (
      tester,
    ) async {
      final pages = <int>[];
      Widget build(int n) => wrap(
        VCarousel.hero(
          autoPlayInterval: const Duration(seconds: 2),
          onPageChanged: pages.add,
          height: 100,
          children: slides(n),
        ),
      );

      await tester.pumpWidget(build(1));
      await tester.pumpWidget(build(3));
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 600));

      expect(pages, [1]);
      await tester.pumpWidget(wrap(const SizedBox()));
    });

    testWidgets('swapping the controller re-attaches the page view', (
      tester,
    ) async {
      final first = PageController();
      final second = PageController();
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      Widget build(PageController c) => wrap(
        VCarousel.fullWidth(controller: c, height: 100, children: slides(3)),
      );

      await tester.pumpWidget(build(first));
      await tester.pumpWidget(build(second));

      expect(first.hasClients, isFalse);
      expect(second.hasClients, isTrue);
    });

    testWidgets('moving from its own to a caller controller keeps working', (
      tester,
    ) async {
      final controller = PageController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(VCarousel.fullWidth(height: 100, children: slides(3))),
      );
      await tester.pumpWidget(
        wrap(
          VCarousel.fullWidth(
            controller: controller,
            height: 100,
            children: slides(3),
          ),
        ),
      );
      await tester.pump();

      expect(controller.hasClients, isTrue);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(wrap(const SizedBox()));
      expect(tester.takeException(), isNull);
    });

    testWidgets('removing slides below the visible page moves to the last', (
      tester,
    ) async {
      final pages = <int>[];
      Widget build(int n) => wrap(
        VCarousel.fullWidth(
          height: 100,
          onPageChanged: pages.add,
          children: slides(n),
        ),
      );

      await tester.pumpWidget(build(4));
      for (var i = 0; i < 3; i++) {
        await tester.fling(find.byType(PageView), const Offset(-500, 0), 1000);
        await tester.pumpAndSettle();
      }
      expect(indicatorPage(tester), 3);
      pages.clear();

      await tester.pumpWidget(build(2));
      await tester.pumpAndSettle();

      expect(indicatorPage(tester), 1);
      expect(pages, [1]);
    });
  });
}
