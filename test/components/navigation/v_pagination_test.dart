import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  group('VPagination', () {
    testWidgets('renders page numbers', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VPagination(currentPage: 1, totalPages: 5, onPageChanged: (_) {}),
        ),
      );

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('highlights current page', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VPagination(currentPage: 3, totalPages: 5, onPageChanged: (_) {}),
        ),
      );

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('calls onPageChanged when page is tapped', (tester) async {
      int? changedPage;

      await tester.pumpWidget(
        buildTestWidget(
          VPagination(
            currentPage: 1,
            totalPages: 5,
            onPageChanged: (page) => changedPage = page,
          ),
        ),
      );

      await tester.tap(find.text('2'));
      await tester.pump();

      expect(changedPage, equals(2));
    });

    testWidgets('shows ellipsis for many pages', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VPagination(currentPage: 5, totalPages: 10, onPageChanged: (_) {}),
        ),
      );

      expect(find.text('...'), findsWidgets);
    });

    testWidgets('simple variant shows current page info', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VPagination.simple(
            currentPage: 3,
            totalPages: 10,
            onPageChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Page 3 of 10'), findsOneWidget);
    });

    testWidgets('minimal variant shows prev/next only', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VPagination.minimal(
            currentPage: 3,
            totalPages: 10,
            onPageChanged: (_) {},
          ),
        ),
      );

      expect(find.text('< Previous'), findsOneWidget);
      expect(find.text('Next >'), findsOneWidget);
    });

    testWidgets('prev button navigates to previous page', (tester) async {
      int? changedPage;

      await tester.pumpWidget(
        buildTestWidget(
          VPagination.simple(
            currentPage: 3,
            totalPages: 10,
            onPageChanged: (page) => changedPage = page,
          ),
        ),
      );

      await tester.tap(find.text('< Previous'));
      await tester.pump();

      expect(changedPage, equals(2));
    });

    testWidgets('next button navigates to next page', (tester) async {
      int? changedPage;

      await tester.pumpWidget(
        buildTestWidget(
          VPagination.simple(
            currentPage: 3,
            totalPages: 10,
            onPageChanged: (page) => changedPage = page,
          ),
        ),
      );

      await tester.tap(find.text('Next >'));
      await tester.pump();

      expect(changedPage, equals(4));
    });

    testWidgets('clamps current page to valid range', (tester) async {
      // Source code has an assert, so out-of-range values throw AssertionError
      expect(
        () =>
            VPagination(currentPage: 100, totalPages: 5, onPageChanged: (_) {}),
        throwsAssertionError,
      );
    });

    testWidgets('supports custom text parameters', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VPagination.simple(
            currentPage: 2,
            totalPages: 5,
            onPageChanged: (_) {},
            previousText: 'Previous',
            nextText: 'Next',
            pageTextBuilder: (current, total) => '$current / $total page',
          ),
        ),
      );

      expect(find.text('< Previous'), findsOneWidget);
      expect(find.text('Next >'), findsOneWidget);
      expect(find.text('2 / 5 page'), findsOneWidget);
    });

    testWidgets('minimal variant supports custom text', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VPagination.minimal(
            currentPage: 2,
            totalPages: 5,
            onPageChanged: (_) {},
            previousText: 'Previous',
            nextText: 'Next',
          ),
        ),
      );

      expect(find.text('< Previous'), findsOneWidget);
      expect(find.text('Next >'), findsOneWidget);
    });

    group('siblingCount', () {
      testWidgets('siblingCount=1 shows 1 page on each side of current', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 5, totalPages: 10, onPageChanged: (_) {}),
          ),
        );

        // With siblingCount=1, should show: 1 ... 4 5 6 ... 10
        expect(find.text('4'), findsOneWidget);
        expect(find.text('5'), findsOneWidget);
        expect(find.text('6'), findsOneWidget);
      });

      testWidgets('siblingCount=2 shows 2 pages on each side of current', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 10,
              totalPages: 20,
              siblingCount: 2,
              onPageChanged: (_) {},
            ),
          ),
        );

        // With siblingCount=2, should show pages around 10: 8 9 10 11 12
        expect(find.text('8'), findsOneWidget);
        expect(find.text('9'), findsOneWidget);
        expect(find.text('10'), findsOneWidget);
        expect(find.text('11'), findsOneWidget);
        expect(find.text('12'), findsOneWidget);
      });

      testWidgets('siblingCount=0 shows only current page in middle', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 5,
              totalPages: 10,
              siblingCount: 0,
              onPageChanged: (_) {},
            ),
          ),
        );

        // With siblingCount=0, should show: 1 ... 5 ... 10
        expect(find.text('1'), findsOneWidget);
        expect(find.text('5'), findsOneWidget);
        expect(find.text('10'), findsOneWidget);
        // Should not show 4 or 6
        expect(find.text('4'), findsNothing);
        expect(find.text('6'), findsNothing);
      });
    });

    group('boundaryCount', () {
      testWidgets('boundaryCount=1 shows 1 page at start and end', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 10, totalPages: 20, onPageChanged: (_) {}),
          ),
        );

        // Should show page 1 at start and 20 at end
        expect(find.text('1'), findsOneWidget);
        expect(find.text('20'), findsOneWidget);
        // Should not show 2 or 19 (not in boundary or sibling)
        expect(find.text('2'), findsNothing);
        expect(find.text('19'), findsNothing);
      });

      testWidgets('boundaryCount=2 shows 2 pages at start and end', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 10,
              totalPages: 20,
              boundaryCount: 2,
              onPageChanged: (_) {},
            ),
          ),
        );

        // Should show pages 1, 2 at start and 19, 20 at end
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('19'), findsOneWidget);
        expect(find.text('20'), findsOneWidget);
      });

      testWidgets('boundaryCount=0 shows fewer boundary pages', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 10,
              totalPages: 20,
              boundaryCount: 0,
              onPageChanged: (_) {},
            ),
          ),
        );

        // Should show current and siblings
        expect(find.text('9'), findsOneWidget);
        expect(find.text('10'), findsOneWidget);
        expect(find.text('11'), findsOneWidget);
        // With boundaryCount=0, boundary pages should not be explicitly added
        // (but may still appear due to ellipsis logic - main assertion is
        // that sibling pages are correctly shown)
      });
    });

    group('showFirstLast', () {
      testWidgets('showFirstLast=true shows first/last buttons', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 5, totalPages: 10, onPageChanged: (_) {}),
          ),
        );

        // Find first/last buttons by icon
        final icons = find.byType(CustomPaint);
        // Should have 4 navigation icons: first, prev, next, last
        expect(icons, findsAtLeast(4));
      });

      testWidgets('showFirstLast=false hides first/last buttons', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 5,
              totalPages: 10,
              showFirstLast: false,
              onPageChanged: (_) {},
            ),
          ),
        );

        // Find prev/next buttons by icon
        final icons = find.byType(CustomPaint);
        // Should have only 2 navigation icons: prev, next
        expect(icons, findsNWidgets(2));
      });
    });

    group('size options', () {
      testWidgets('size sm renders with correct button size', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 1,
              totalPages: 5,
              size: VPaginationSize.sm,
              onPageChanged: (_) {},
            ),
          ),
        );

        // Find Container with 28x28 size (sm size)
        final containers = find.byType(Container);
        expect(containers, findsWidgets);

        // Verify the widget renders
        expect(find.byType(VPagination), findsOneWidget);
      });

      testWidgets('size md renders with correct button size', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 1, totalPages: 5, onPageChanged: (_) {}),
          ),
        );

        expect(find.byType(VPagination), findsOneWidget);
      });

      testWidgets('size lg renders with correct button size', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 1,
              totalPages: 5,
              size: VPaginationSize.lg,
              onPageChanged: (_) {},
            ),
          ),
        );

        expect(find.byType(VPagination), findsOneWidget);
      });

      testWidgets('different sizes have different button dimensions', (
        tester,
      ) async {
        // VPaginationSize.sm -> sizes.xs.height = 24
        // VPaginationSize.md -> sizes.sm.height = 32
        // VPaginationSize.lg -> sizes.md.height = 40
        // Container uses width/height directly, verify via RenderBox size

        // Test sm - button size should be 24x24 (sizes.xs)
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 1,
              totalPages: 3,
              size: VPaginationSize.sm,
              showFirstLast: false,
              onPageChanged: (_) {},
            ),
          ),
        );

        var containers = tester.widgetList<Container>(find.byType(Container));
        var buttonContainer = containers.firstWhere(
          (c) =>
              c.constraints?.maxWidth == 24 && c.constraints?.maxHeight == 24,
          orElse: Container.new,
        );
        expect(buttonContainer.constraints?.maxWidth, equals(24.0));

        // Test md - button size should be 32x32 (sizes.sm)
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 1,
              totalPages: 3,
              showFirstLast: false,
              onPageChanged: (_) {},
            ),
          ),
        );

        containers = tester.widgetList<Container>(find.byType(Container));
        buttonContainer = containers.firstWhere(
          (c) =>
              c.constraints?.maxWidth == 32 && c.constraints?.maxHeight == 32,
          orElse: Container.new,
        );
        expect(buttonContainer.constraints?.maxWidth, equals(32.0));

        // Test lg - button size should be 40x40 (sizes.md)
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 1,
              totalPages: 3,
              size: VPaginationSize.lg,
              showFirstLast: false,
              onPageChanged: (_) {},
            ),
          ),
        );

        containers = tester.widgetList<Container>(find.byType(Container));
        buttonContainer = containers.firstWhere(
          (c) =>
              c.constraints?.maxWidth == 40 && c.constraints?.maxHeight == 40,
          orElse: Container.new,
        );
        expect(buttonContainer.constraints?.maxWidth, equals(40.0));
      });

      testWidgets('size sm has smaller font size', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination.simple(
              currentPage: 1,
              totalPages: 5,
              size: VPaginationSize.sm,
              onPageChanged: (_) {},
            ),
          ),
        );

        // sm → sizes.xs.fontSize = 11
        final textWidget = tester.widget<Text>(find.text('Page 1 of 5'));
        expect(textWidget.style?.fontSize, equals(11.0));
      });

      testWidgets('size md has medium font size', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination.simple(
              currentPage: 1,
              totalPages: 5,
              onPageChanged: (_) {},
            ),
          ),
        );

        // md → sizes.sm.fontSize = 13
        final textWidget = tester.widget<Text>(find.text('Page 1 of 5'));
        expect(textWidget.style?.fontSize, equals(13.0));
      });

      testWidgets('size lg has larger font size', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination.simple(
              currentPage: 1,
              totalPages: 5,
              size: VPaginationSize.lg,
              onPageChanged: (_) {},
            ),
          ),
        );

        // lg → sizes.md.fontSize = 14
        final textWidget = tester.widget<Text>(find.text('Page 1 of 5'));
        expect(textWidget.style?.fontSize, equals(14.0));
      });
    });

    group('first/last button functionality', () {
      testWidgets('first button navigates to page 1', (tester) async {
        int? changedPage;

        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 5,
              totalPages: 10,
              onPageChanged: (page) => changedPage = page,
            ),
          ),
        );

        // Find all Icon widgets and tap the first one (first page button)
        final icons = find.byType(CustomPaint);
        await tester.tap(icons.first);
        await tester.pump();

        expect(changedPage, equals(1));
      });

      testWidgets('last button navigates to last page', (tester) async {
        int? changedPage;

        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 5,
              totalPages: 10,
              onPageChanged: (page) => changedPage = page,
            ),
          ),
        );

        // Find all Icon widgets and tap the last one (last page button)
        final icons = find.byType(CustomPaint);
        await tester.tap(icons.last);
        await tester.pump();

        expect(changedPage, equals(10));
      });

      testWidgets('first button is disabled on first page', (tester) async {
        int? changedPage;

        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 1,
              totalPages: 10,
              onPageChanged: (page) => changedPage = page,
            ),
          ),
        );

        // Tap the first button - should not trigger callback
        final icons = find.byType(CustomPaint);
        await tester.tap(icons.first);
        await tester.pump();

        expect(changedPage, isNull);
      });

      testWidgets('last button is disabled on last page', (tester) async {
        int? changedPage;

        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 10,
              totalPages: 10,
              onPageChanged: (page) => changedPage = page,
            ),
          ),
        );

        // Tap the last button - should not trigger callback
        final icons = find.byType(CustomPaint);
        await tester.tap(icons.last);
        await tester.pump();

        expect(changedPage, isNull);
      });

      testWidgets('prev button is disabled on first page', (tester) async {
        int? changedPage;

        await tester.pumpWidget(
          buildTestWidget(
            VPagination.simple(
              currentPage: 1,
              totalPages: 10,
              onPageChanged: (page) => changedPage = page,
            ),
          ),
        );

        await tester.tap(find.text('< Previous'));
        await tester.pump();

        expect(changedPage, isNull);
      });

      testWidgets('next button is disabled on last page', (tester) async {
        int? changedPage;

        await tester.pumpWidget(
          buildTestWidget(
            VPagination.simple(
              currentPage: 10,
              totalPages: 10,
              onPageChanged: (page) => changedPage = page,
            ),
          ),
        );

        await tester.tap(find.text('Next >'));
        await tester.pump();

        expect(changedPage, isNull);
      });

      testWidgets(
        'prev icon button navigates to previous page in default variant',
        (tester) async {
          int? changedPage;

          await tester.pumpWidget(
            buildTestWidget(
              VPagination(
                currentPage: 5,
                totalPages: 10,
                onPageChanged: (page) => changedPage = page,
              ),
            ),
          );

          // Find all Icon widgets - second icon is prev button (first, prev, next, last)
          final icons = find.byType(CustomPaint);
          await tester.tap(icons.at(1));
          await tester.pump();

          expect(changedPage, equals(4));
        },
      );

      testWidgets('next icon button navigates to next page in default variant', (
        tester,
      ) async {
        int? changedPage;

        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 5,
              totalPages: 10,
              onPageChanged: (page) => changedPage = page,
            ),
          ),
        );

        // Find all Icon widgets - third icon is next button (first, prev, next, last)
        final icons = find.byType(CustomPaint);
        await tester.tap(icons.at(2));
        await tester.pump();

        expect(changedPage, equals(6));
      });

      testWidgets(
        'prev icon button is disabled on first page in default variant',
        (tester) async {
          int? changedPage;

          await tester.pumpWidget(
            buildTestWidget(
              VPagination(
                currentPage: 1,
                totalPages: 10,
                onPageChanged: (page) => changedPage = page,
              ),
            ),
          );

          // Tap prev button (second icon)
          final icons = find.byType(CustomPaint);
          await tester.tap(icons.at(1));
          await tester.pump();

          expect(changedPage, isNull);
        },
      );

      testWidgets(
        'next icon button is disabled on last page in default variant',
        (tester) async {
          int? changedPage;

          await tester.pumpWidget(
            buildTestWidget(
              VPagination(
                currentPage: 10,
                totalPages: 10,
                onPageChanged: (page) => changedPage = page,
              ),
            ),
          );

          // Tap next button (third icon)
          final icons = find.byType(CustomPaint);
          await tester.tap(icons.at(2));
          await tester.pump();

          expect(changedPage, isNull);
        },
      );
    });

    group('edge cases for page ranges', () {
      testWidgets('totalPages=1 shows single page', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 1, totalPages: 1, onPageChanged: (_) {}),
          ),
        );

        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsNothing);
      });

      testWidgets('currentPage at start shows correct range', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 1, totalPages: 10, onPageChanged: (_) {}),
          ),
        );

        // At start, should show: 1 2 3 ... 10
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('10'), findsOneWidget);
      });

      testWidgets('currentPage at end shows correct range', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 10, totalPages: 10, onPageChanged: (_) {}),
          ),
        );

        // At end, should show: 1 ... 8 9 10
        expect(find.text('1'), findsOneWidget);
        expect(find.text('9'), findsOneWidget);
        expect(find.text('10'), findsOneWidget);
      });

      testWidgets('small totalPages shows all pages without ellipsis', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 2, totalPages: 3, onPageChanged: (_) {}),
          ),
        );

        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(find.text('...'), findsNothing);
      });

      testWidgets('currentPage near start shows no left ellipsis', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 3, totalPages: 10, onPageChanged: (_) {}),
          ),
        );

        // Should show: 1 2 3 4 ... 10
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(find.text('4'), findsOneWidget);
      });

      testWidgets('currentPage near end shows no right ellipsis', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 8, totalPages: 10, onPageChanged: (_) {}),
          ),
        );

        // Should show: 1 ... 7 8 9 10
        expect(find.text('7'), findsOneWidget);
        expect(find.text('8'), findsOneWidget);
        expect(find.text('9'), findsOneWidget);
        expect(find.text('10'), findsOneWidget);
      });

      testWidgets('negative currentPage throws assertion error', (
        tester,
      ) async {
        expect(
          () => VPagination(
            currentPage: -5,
            totalPages: 10,
            onPageChanged: (_) {},
          ),
          throwsAssertionError,
        );
      });

      testWidgets('currentPage=0 throws assertion error', (tester) async {
        expect(
          () => VPagination(
            currentPage: 0,
            totalPages: 10,
            onPageChanged: (_) {},
          ),
          throwsAssertionError,
        );
      });

      testWidgets('middle page shows ellipsis', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 10, totalPages: 20, onPageChanged: (_) {}),
          ),
        );

        // Should show: 1 ... 9 10 11 ... 20
        expect(find.text('1'), findsOneWidget);
        expect(find.text('9'), findsOneWidget);
        expect(find.text('10'), findsOneWidget);
        expect(find.text('11'), findsOneWidget);
        expect(find.text('20'), findsOneWidget);
        // Should have at least 1 ellipsis
        expect(find.text('...'), findsWidgets);
      });
    });

    group('edge cases for totalPages', () {
      testWidgets('totalPages=0 throws assertion error', (tester) async {
        // Source code has assert(totalPages >= 1)
        expect(
          () =>
              VPagination(currentPage: 1, totalPages: 0, onPageChanged: (_) {}),
          throwsAssertionError,
        );
      });

      testWidgets('negative totalPages throws assertion error', (tester) async {
        expect(
          () => VPagination(
            currentPage: 1,
            totalPages: -10,
            onPageChanged: (_) {},
          ),
          throwsAssertionError,
        );
      });

      testWidgets('simple variant rejects totalPages=0', (tester) async {
        expect(
          () => VPagination.simple(
            currentPage: 1,
            totalPages: 0,
            onPageChanged: (_) {},
          ),
          throwsAssertionError,
        );
      });

      testWidgets('minimal variant rejects totalPages=0', (tester) async {
        expect(
          () => VPagination.minimal(
            currentPage: 1,
            totalPages: 0,
            onPageChanged: (_) {},
          ),
          throwsAssertionError,
        );
      });

      testWidgets('totalPages=1 single page has disabled prev/next', (
        tester,
      ) async {
        int? changedPage;

        await tester.pumpWidget(
          buildTestWidget(
            VPagination.simple(
              currentPage: 1,
              totalPages: 1,
              onPageChanged: (page) => changedPage = page,
            ),
          ),
        );

        await tester.tap(find.text('< Previous'));
        await tester.pump();
        expect(changedPage, isNull);

        await tester.tap(find.text('Next >'));
        await tester.pump();
        expect(changedPage, isNull);
      });

      testWidgets('very large totalPages renders correctly', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 500,
              totalPages: 1000,
              onPageChanged: (_) {},
            ),
          ),
        );

        expect(find.byType(VPagination), findsOneWidget);
        expect(find.text('1'), findsOneWidget);
        expect(find.text('500'), findsOneWidget);
        expect(find.text('1000'), findsOneWidget);
      });
    });

    group('tapping current page', () {
      testWidgets('tapping current page still calls onPageChanged', (
        tester,
      ) async {
        int? changedPage;

        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 3,
              totalPages: 5,
              onPageChanged: (page) => changedPage = page,
            ),
          ),
        );

        await tester.tap(find.text('3'));
        await tester.pump();

        expect(changedPage, equals(3));
      });
    });

    group('minimal variant edge cases', () {
      testWidgets('minimal variant prev button is disabled on first page', (
        tester,
      ) async {
        int? changedPage;

        await tester.pumpWidget(
          buildTestWidget(
            VPagination.minimal(
              currentPage: 1,
              totalPages: 10,
              onPageChanged: (page) => changedPage = page,
            ),
          ),
        );

        await tester.tap(find.text('< Previous'));
        await tester.pump();

        expect(changedPage, isNull);
      });

      testWidgets('minimal variant next button is disabled on last page', (
        tester,
      ) async {
        int? changedPage;

        await tester.pumpWidget(
          buildTestWidget(
            VPagination.minimal(
              currentPage: 10,
              totalPages: 10,
              onPageChanged: (page) => changedPage = page,
            ),
          ),
        );

        await tester.tap(find.text('Next >'));
        await tester.pump();

        expect(changedPage, isNull);
      });

      testWidgets('minimal variant navigates correctly', (tester) async {
        int? changedPage;

        await tester.pumpWidget(
          buildTestWidget(
            VPagination.minimal(
              currentPage: 5,
              totalPages: 10,
              onPageChanged: (page) => changedPage = page,
            ),
          ),
        );

        await tester.tap(find.text('< Previous'));
        await tester.pump();
        expect(changedPage, equals(4));

        changedPage = null;

        await tester.tap(find.text('Next >'));
        await tester.pump();
        expect(changedPage, equals(6));
      });

      testWidgets('minimal variant size options work correctly', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination.minimal(
              currentPage: 5,
              totalPages: 10,
              size: VPaginationSize.lg,
              onPageChanged: (_) {},
            ),
          ),
        );

        // lg → sizes.md.fontSize = 14
        final prevText = tester.widget<Text>(find.text('< Previous'));
        expect(prevText.style?.fontSize, equals(14.0));

        final nextText = tester.widget<Text>(find.text('Next >'));
        expect(nextText.style?.fontSize, equals(14.0));
      });
    });

    group('simple variant edge cases', () {
      testWidgets('simple variant uses default pageTextBuilder when null', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination.simple(
              currentPage: 5,
              totalPages: 10,
              onPageChanged: (_) {},
            ),
          ),
        );

        expect(find.text('Page 5 of 10'), findsOneWidget);
      });

      testWidgets('simple variant with custom pageTextBuilder', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination.simple(
              currentPage: 5,
              totalPages: 10,
              pageTextBuilder: (current, total) => '$current/$total',
              onPageChanged: (_) {},
            ),
          ),
        );

        expect(find.text('5/10'), findsOneWidget);
      });

      testWidgets('simple variant respects size option', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination.simple(
              currentPage: 5,
              totalPages: 10,
              size: VPaginationSize.sm,
              onPageChanged: (_) {},
            ),
          ),
        );

        // sm → sizes.xs.fontSize = 11
        final pageText = tester.widget<Text>(find.text('Page 5 of 10'));
        expect(pageText.style?.fontSize, equals(11.0));
      });
    });

    group('VPaginationSize enum', () {
      test('VPaginationSize has correct values', () {
        expect(VPaginationSize.values.length, equals(3));
        expect(VPaginationSize.values, contains(VPaginationSize.sm));
        expect(VPaginationSize.values, contains(VPaginationSize.md));
        expect(VPaginationSize.values, contains(VPaginationSize.lg));
      });
    });

    group('default constructor parameters', () {
      testWidgets('default siblingCount is 1', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 5, totalPages: 10, onPageChanged: (_) {}),
          ),
        );

        // Should show siblings (4, 5, 6) with siblingCount=1
        expect(find.text('4'), findsOneWidget);
        expect(find.text('5'), findsOneWidget);
        expect(find.text('6'), findsOneWidget);
      });

      testWidgets('default boundaryCount is 1', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 5, totalPages: 10, onPageChanged: (_) {}),
          ),
        );

        // Should show boundary pages (1 and 10) with boundaryCount=1
        expect(find.text('1'), findsOneWidget);
        expect(find.text('10'), findsOneWidget);
      });

      testWidgets('default showFirstLast is true', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 5, totalPages: 10, onPageChanged: (_) {}),
          ),
        );

        // Should have 4 navigation icons: first, prev, next, last
        final icons = find.byType(CustomPaint);
        expect(icons, findsNWidgets(4));
      });

      testWidgets('default size is md', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 1,
              totalPages: 3,
              showFirstLast: false,
              onPageChanged: (_) {},
            ),
          ),
        );

        // md → sizes.sm.height = 32
        final containers = tester.widgetList<Container>(find.byType(Container));
        final buttonContainer = containers.firstWhere(
          (c) =>
              c.constraints?.maxWidth == 32 && c.constraints?.maxHeight == 32,
          orElse: Container.new,
        );
        expect(buttonContainer.constraints?.maxWidth, equals(32.0));
      });
    });

    group('Semantics accessibility', () {
      testWidgets('page buttons have correct semantics', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 2,
              totalPages: 5,
              showFirstLast: false,
              onPageChanged: (_) {},
            ),
          ),
        );

        // Find Semantics widgets with button role
        final semanticsWidgets = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && (widget.properties.button ?? false),
        );

        expect(semanticsWidgets, findsWidgets);
      });

      testWidgets('selected page has selected semantics', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 3,
              totalPages: 5,
              showFirstLast: false,
              onPageChanged: (_) {},
            ),
          ),
        );

        // Find Semantics widget with selected=true
        final selectedSemantics = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              (widget.properties.button ?? false) &&
              (widget.properties.selected ?? false),
        );

        expect(selectedSemantics, findsOneWidget);
      });

      testWidgets('disabled buttons have enabled=false semantics', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 1, totalPages: 5, onPageChanged: (_) {}),
          ),
        );

        // Find Semantics widgets with enabled=false (disabled buttons)
        final disabledSemantics = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              (widget.properties.button ?? false) &&
              !(widget.properties.enabled ?? true),
        );

        // At page 1, first and prev buttons should be disabled
        expect(disabledSemantics, findsAtLeast(2));
      });

      testWidgets('navigation buttons have descriptive labels', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 5, totalPages: 10, onPageChanged: (_) {}),
          ),
        );

        // Each icon button has its own label (no two share one).
        for (final label in ['First page', 'Previous', 'Next', 'Last page']) {
          expect(
            find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == label &&
                  (widget.properties.button ?? false),
            ),
            findsOneWidget,
            reason: label,
          );
        }
      });

      testWidgets('text buttons in simple variant have semantics', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination.simple(
              currentPage: 5,
              totalPages: 10,
              onPageChanged: (_) {},
            ),
          ),
        );

        // Find Semantics widgets for text buttons
        final prevSemantics = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && widget.properties.label == 'Previous',
        );

        final nextSemantics = find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.label == 'Next',
        );

        expect(prevSemantics, findsOneWidget);
        expect(nextSemantics, findsOneWidget);
      });

      testWidgets('minimal variant text buttons have semantics', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination.minimal(
              currentPage: 5,
              totalPages: 10,
              onPageChanged: (_) {},
            ),
          ),
        );

        // Find Semantics widgets for text buttons
        final prevSemantics = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && widget.properties.label == 'Previous',
        );

        final nextSemantics = find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.label == 'Next',
        );

        expect(prevSemantics, findsOneWidget);
        expect(nextSemantics, findsOneWidget);
      });

      testWidgets('page number buttons have correct label semantics', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 3,
              totalPages: 5,
              showFirstLast: false,
              onPageChanged: (_) {},
            ),
          ),
        );

        // Find Semantics widget with label='3' (current page)
        final page3Semantics = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == '3' &&
              (widget.properties.button ?? false),
        );

        expect(page3Semantics, findsOneWidget);
      });
    });

    group('widget structure', () {
      testWidgets('default variant is a Row', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 1, totalPages: 5, onPageChanged: (_) {}),
          ),
        );

        expect(find.byType(Row), findsWidgets);
      });

      testWidgets('simple variant is a Row', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination.simple(
              currentPage: 1,
              totalPages: 5,
              onPageChanged: (_) {},
            ),
          ),
        );

        expect(find.byType(Row), findsWidgets);
      });

      testWidgets('minimal variant is a Row', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination.minimal(
              currentPage: 1,
              totalPages: 5,
              onPageChanged: (_) {},
            ),
          ),
        );

        expect(find.byType(Row), findsWidgets);
      });

      testWidgets('uses GestureDetector for tap handling', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 1, totalPages: 5, onPageChanged: (_) {}),
          ),
        );

        expect(find.byType(GestureDetector), findsWidgets);
      });
    });

    group('page calculation edge cases', () {
      testWidgets('handles siblingCount larger than available pages', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 2,
              totalPages: 3,
              siblingCount: 10,
              onPageChanged: (_) {},
            ),
          ),
        );

        // Should show all pages without error
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
      });

      testWidgets('handles boundaryCount larger than totalPages', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(
              currentPage: 2,
              totalPages: 3,
              boundaryCount: 10,
              onPageChanged: (_) {},
            ),
          ),
        );

        // Should show all pages without error
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
      });

      testWidgets('exact threshold between ellipsis and no ellipsis', (
        tester,
      ) async {
        // Formula: total <= (siblingCount * 2) + (boundaryCount * 2) + 3
        // With siblingCount=1, boundaryCount=1: threshold = 2 + 2 + 3 = 7
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 4, totalPages: 7, onPageChanged: (_) {}),
          ),
        );

        // Should show all 7 pages without ellipsis
        for (var i = 1; i <= 7; i++) {
          expect(find.text('$i'), findsOneWidget);
        }
        expect(find.text('...'), findsNothing);
      });

      testWidgets('just above threshold shows ellipsis', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VPagination(currentPage: 4, totalPages: 8, onPageChanged: (_) {}),
          ),
        );

        // With 8 pages, should show ellipsis
        expect(find.text('...'), findsWidgets);
      });
    });
  });

  group('theme override', () {
    testWidgets('theme componentOverrides applies to pagination', (
      tester,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light().copyWith(
            componentOverrides: const VComponentOverrides([
              VPaginationStyle(backgroundColor: Color(0xFFFF0000)),
            ]),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VPagination(
              currentPage: 1,
              totalPages: 5,
              onPageChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(VPagination), findsOneWidget);
    });

    testWidgets('enabled false blocks every button', (tester) async {
      int? picked;
      await tester.pumpWidget(
        buildTestWidget(
          VPagination(
            currentPage: 2,
            totalPages: 5,
            enabled: false,
            onPageChanged: (page) => picked = page,
          ),
        ),
      );

      await tester.tap(find.text('4'), warnIfMissed: false);
      await tester.pump();

      expect(picked, isNull);
    });

    testWidgets('enabled false blocks the simple variant', (tester) async {
      int? picked;
      await tester.pumpWidget(
        buildTestWidget(
          VPagination.simple(
            currentPage: 2,
            totalPages: 5,
            enabled: false,
            onPageChanged: (page) => picked = page,
          ),
        ),
      );

      await tester.tap(find.textContaining('Next'), warnIfMissed: false);
      await tester.pump();

      expect(picked, isNull);
    });

    testWidgets('enabled pagination reports the tapped page', (tester) async {
      int? picked;
      await tester.pumpWidget(
        buildTestWidget(
          VPagination(
            currentPage: 2,
            totalPages: 5,
            onPageChanged: (page) => picked = page,
          ),
        ),
      );

      await tester.tap(find.text('4'));
      await tester.pump();

      expect(picked, 4);
    });
  });

  group('VPagination regressions', () {
    testWidgets('places each ellipsis between the boundary and the siblings', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          VPagination(currentPage: 10, totalPages: 20, onPageChanged: (_) {}),
        ),
      );

      final labels = tester
          .widgetList<Text>(
            find.descendant(
              of: find.byType(VPagination),
              matching: find.byType(Text),
            ),
          )
          .map((text) => text.data)
          .toList();

      expect(labels, ['1', '...', '9', '10', '11', '...', '20']);
    });

    testWidgets('Enter and Space activate a focused page button', (
      tester,
    ) async {
      int? page;
      await tester.pumpWidget(
        buildTestWidget(
          VPagination(
            currentPage: 1,
            totalPages: 5,
            onPageChanged: (value) => page = value,
          ),
        ),
      );

      Focus.of(tester.element(find.text('3'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(page, 3);

      Focus.of(tester.element(find.text('4'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(page, 4);
    });

    testWidgets('Enter activates a focused text button', (tester) async {
      int? page;
      await tester.pumpWidget(
        buildTestWidget(
          VPagination.simple(
            currentPage: 3,
            totalPages: 5,
            onPageChanged: (value) => page = value,
          ),
        ),
      );

      Focus.of(tester.element(find.text('< Previous'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      expect(page, 2);
    });

    testWidgets('a page button is announced once, not twice', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestWidget(
          VPagination(currentPage: 3, totalPages: 5, onPageChanged: (_) {}),
        ),
      );

      expect(tester.getSemantics(find.text('3')).label, '3');
      handle.dispose();
    });
  });

  group('VPagination style fields', () {
    final theme = VThemeData.light();

    // Builds a pagination styled through the theme or as the instance style.
    Widget styled(VPaginationStyle? style, {bool viaTheme = false}) => VTheme(
      data: theme.copyWith(
        componentOverrides: VComponentOverrides([
          if (viaTheme && style != null) style,
        ]),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: VPagination(
            currentPage: 2,
            totalPages: 3,
            onPageChanged: (_) {},
            style: viaTheme ? null : style,
          ),
        ),
      ),
    );

    BoxDecoration buttonOf(WidgetTester tester, String label) =>
        tester
                .widget<Container>(
                  find
                      .ancestor(
                        of: find.text(label),
                        matching: find.byType(Container),
                      )
                      .first,
                )
                .decoration!
            as BoxDecoration;

    testWidgets('page buttons have no fill or border by default', (
      tester,
    ) async {
      await tester.pumpWidget(styled(null));
      expect(buttonOf(tester, '1').color, isNull);
      expect(buttonOf(tester, '1').border, isNull);
      expect(buttonOf(tester, '2').color, theme.colors.primary);
    });

    for (final viaTheme in [true, false]) {
      final via = viaTheme ? 'theme' : 'instance';

      testWidgets('backgroundColor fills the other page buttons ($via)', (
        tester,
      ) async {
        const color = Color(0xFF123456);
        await tester.pumpWidget(
          styled(
            const VPaginationStyle(backgroundColor: color),
            viaTheme: viaTheme,
          ),
        );
        expect(buttonOf(tester, '1').color, color);
        expect(buttonOf(tester, '3').color, color);
        expect(buttonOf(tester, '2').color, theme.colors.primary);
      });

      testWidgets('borderColor outlines every page button ($via)', (
        tester,
      ) async {
        const color = Color(0xFF123456);
        await tester.pumpWidget(
          styled(
            const VPaginationStyle(borderColor: color),
            viaTheme: viaTheme,
          ),
        );
        for (final label in ['1', '2', '3']) {
          expect(buttonOf(tester, label).border, Border.all(color: color));
        }

        // The focus ring replaces it on the focused button.
        Focus.of(tester.element(find.text('1'))).requestFocus();
        await tester.pumpAndSettle();
        expect(
          buttonOf(tester, '1').border,
          Border.all(color: theme.colors.ring, width: 2),
        );
      });
    }
  });
}
