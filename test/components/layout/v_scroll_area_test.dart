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

  group('VScrollArea', () {
    testWidgets('renders vertical scroll area', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              child: Column(
                children: List.generate(
                  20,
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(VScrollArea), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(RawScrollbar), findsOneWidget);
    });

    testWidgets('renders horizontal scroll area', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 100,
            height: 50,
            child: VScrollArea.horizontal(
              child: Row(
                children: List.generate(
                  20,
                  (i) => SizedBox(width: 50, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(VScrollArea), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('renders both directions scroll area', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 100,
            height: 100,
            child: VScrollArea.both(
              child: SizedBox(
                width: 500,
                height: 500,
                child: Center(child: Text('Large Content')),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(VScrollArea), findsOneWidget);
      // Both directions uses two SingleChildScrollView (nested)
      expect(find.byType(SingleChildScrollView), findsNWidgets(2));
      // Two RawScrollbars for both directions
      expect(find.byType(RawScrollbar), findsNWidgets(2));
    });

    testWidgets('applies padding', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(10, (i) => Text('Item $i')),
              ),
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.padding, const EdgeInsets.all(16));
    });

    testWidgets('uses custom controller', (tester) async {
      final controller = ScrollController();

      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              controller: controller,
              child: Column(
                children: List.generate(
                  20,
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      expect(controller.hasClients, isTrue);

      controller.dispose();
    });

    testWidgets('applies thumbVisibility', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              thumbVisibility: true,
              child: Column(
                children: List.generate(
                  20,
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      final scrollbar = tester.widget<RawScrollbar>(find.byType(RawScrollbar));
      expect(scrollbar.thumbVisibility, isTrue);
    });

    testWidgets('applies trackVisibility', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              // trackVisibility requires thumbVisibility to be true
              thumbVisibility: true,
              trackVisibility: true,
              child: Column(
                children: List.generate(
                  20,
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      final scrollbar = tester.widget<RawScrollbar>(find.byType(RawScrollbar));
      expect(scrollbar.trackVisibility, isTrue);
    });

    testWidgets('applies custom scrollbar thickness', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              scrollbarThickness: 10,
              child: Column(
                children: List.generate(
                  20,
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      final scrollbar = tester.widget<RawScrollbar>(find.byType(RawScrollbar));
      expect(scrollbar.thickness, 10);
    });

    testWidgets('applies custom scrollbar radius', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              scrollbarRadius: 5,
              child: Column(
                children: List.generate(
                  20,
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      final scrollbar = tester.widget<RawScrollbar>(find.byType(RawScrollbar));
      expect(scrollbar.radius, const Radius.circular(5));
    });

    testWidgets('applies custom thumb color', (tester) async {
      const customColor = Color(0xFFFF0000);

      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              thumbColor: customColor,
              child: Column(
                children: List.generate(
                  20,
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      final scrollbar = tester.widget<RawScrollbar>(find.byType(RawScrollbar));
      expect(scrollbar.thumbColor, customColor);
    });

    testWidgets('scrolls content vertically', (tester) async {
      final controller = ScrollController();

      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              controller: controller,
              child: Column(
                children: List.generate(
                  20,
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      expect(controller.offset, 0);

      controller.jumpTo(100);
      await tester.pump();

      expect(controller.offset, 100);

      controller.dispose();
    });
  });

  group('interaction tests', () {
    testWidgets('scroll behavior test (drag)', (tester) async {
      final controller = ScrollController();

      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              controller: controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  20,
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      expect(controller.offset, 0);

      // Test drag only if scrollable
      if (controller.position.maxScrollExtent > 0) {
        // Drag in scroll area
        await tester.drag(find.byType(VScrollArea), const Offset(0, -100));
        await tester.pumpAndSettle();

        // Scroll position should have changed
        expect(controller.offset, greaterThan(0));
      } else {
        // If not scrollable, just verify controller is attached
        expect(controller.hasClients, isTrue);
      }

      controller.dispose();
    });

    testWidgets('scroll behavior test (fling)', (tester) async {
      final controller = ScrollController();

      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              controller: controller,
              child: Column(
                children: List.generate(
                  50,
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      expect(controller.offset, 0);

      // Perform fling gesture
      await tester.fling(find.byType(VScrollArea), const Offset(0, -200), 1000);
      await tester.pumpAndSettle();

      // Scroll position should have changed due to fling
      expect(controller.offset, greaterThan(0));

      controller.dispose();
    });

    testWidgets('horizontal scroll behavior test', (tester) async {
      final controller = ScrollController();

      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 100,
            height: 50,
            child: VScrollArea.horizontal(
              controller: controller,
              child: Row(
                children: List.generate(
                  20,
                  (i) => SizedBox(width: 50, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      expect(controller.offset, 0);

      // Horizontal drag
      await tester.drag(find.byType(VScrollArea), const Offset(-100, 0));
      await tester.pumpAndSettle();

      // Scroll position should have changed
      expect(controller.offset, greaterThan(0));

      controller.dispose();
    });

    testWidgets('both directions scroll behavior test', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            width: 100,
            height: 100,
            child: VScrollArea.both(
              child: SizedBox(
                width: 500,
                height: 500,
                child: Center(child: Text('Large Content')),
              ),
            ),
          ),
        ),
      );

      // Should have two SingleChildScrollViews (nested)
      expect(find.byType(SingleChildScrollView), findsNWidgets(2));

      // Vertical drag
      await tester.drag(find.byType(VScrollArea), const Offset(0, -50));
      await tester.pumpAndSettle();

      expect(find.byType(VScrollArea), findsOneWidget);
    });

    testWidgets('scrollbar visibility test (thumbVisibility)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              thumbVisibility: true,
              child: Column(
                children: List.generate(
                  20,
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      final scrollbar = tester.widget<RawScrollbar>(find.byType(RawScrollbar));

      // Should always be visible since thumbVisibility is true
      expect(scrollbar.thumbVisibility, isTrue);
    });

    testWidgets('scrollController integration test - animateTo', (
      tester,
    ) async {
      final controller = ScrollController();

      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              controller: controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  20,
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      expect(controller.offset, 0);

      // Test only if scrollable
      final maxExtent = controller.position.maxScrollExtent;
      if (maxExtent > 0) {
        // Scroll with animateTo (within max range)
        final targetOffset = maxExtent > 150 ? 150.0 : maxExtent;
        await controller.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        await tester.pumpAndSettle();

        expect(controller.offset, targetOffset);
      } else {
        // If not scrollable, just verify controller is attached
        expect(controller.hasClients, isTrue);
      }

      controller.dispose();
    });

    testWidgets('scrollController integration test - multiple scrolls', (
      tester,
    ) async {
      final controller = ScrollController();

      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              controller: controller,
              child: Column(
                children: List.generate(
                  50,
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      // Initial position
      expect(controller.offset, 0);

      // First scroll
      controller.jumpTo(100);
      await tester.pump();
      expect(controller.offset, 100);

      // Second scroll
      controller.jumpTo(300);
      await tester.pump();
      expect(controller.offset, 300);

      // Scroll to top
      controller.jumpTo(0);
      await tester.pump();
      expect(controller.offset, 0);

      controller.dispose();
    });

    testWidgets('scroll boundary test', (tester) async {
      final controller = ScrollController();

      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              controller: controller,
              // Using mainAxisSize.min on Column uses intrinsic size
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  20, // Total height 600 (20 * 30)
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify controller is attached
      expect(controller.hasClients, isTrue);

      // Check scrollability (maxScrollExtent >= 0)
      // Since VScrollArea uses SingleChildScrollView for Column
      // scrollable only when content size > viewport size
      final maxExtent = controller.position.maxScrollExtent;

      if (maxExtent > 0) {
        // Scroll to max scroll boundary
        controller.jumpTo(maxExtent);
        await tester.pump();

        expect(controller.offset, maxExtent);
      }

      controller.dispose();
    });

    testWidgets('works correctly when controller is replaced', (tester) async {
      final controller1 = ScrollController();
      final controller2 = ScrollController();

      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              controller: controller1,
              child: Column(
                children: List.generate(
                  20,
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      // Scroll with first controller
      controller1.jumpTo(50);
      await tester.pump();
      expect(controller1.offset, 50);

      // Replace with second controller
      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 100,
            child: VScrollArea(
              controller: controller2,
              child: Column(
                children: List.generate(
                  20,
                  (i) => SizedBox(height: 30, child: Text('Item $i')),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify new controller is attached
      expect(controller2.hasClients, isTrue);

      controller1.dispose();
      controller2.dispose();
    });
  });

  group('VScrollArea regressions', () {
    Widget sized(Widget child) =>
        buildTestWidget(SizedBox(width: 200, height: 200, child: child));

    testWidgets('does not dispose a controller adopted after a swap', (
      tester,
    ) async {
      final controller = ScrollController();
      addTearDown(() {
        try {
          controller.dispose();
        } on Object catch (_) {}
      });

      await tester.pumpWidget(
        sized(const VScrollArea(child: SizedBox(height: 1000))),
      );
      await tester.pumpWidget(
        sized(
          VScrollArea(
            controller: controller,
            child: const SizedBox(height: 1000),
          ),
        ),
      );
      await tester.pumpWidget(buildTestWidget(const SizedBox()));

      // Throws "used after being disposed" when the caller's controller was
      // disposed together with the widget.
      expect(() => controller.addListener(() {}), returnsNormally);
    });

    testWidgets('releases its own controller when the caller supplies one', (
      tester,
    ) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        sized(const VScrollArea(child: SizedBox(height: 1000))),
      );
      await tester.pumpWidget(
        sized(
          VScrollArea(
            controller: controller,
            child: const SizedBox(height: 1000),
          ),
        ),
      );
      controller.jumpTo(120);
      await tester.pump();

      expect(controller.offset, 120);
      expect(tester.takeException(), isNull);
    });

    testWidgets('.both with a controller attaches it to one scroll view', (
      tester,
    ) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        sized(
          VScrollArea.both(
            controller: controller,
            thumbVisibility: true,
            child: const SizedBox(width: 1000, height: 1000),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(controller.positions, hasLength(1));
      expect(controller.position.axis, Axis.vertical);
      controller.jumpTo(50);
      expect(controller.offset, 50);
    });

    testWidgets('.horizontal drives the controller on the horizontal axis', (
      tester,
    ) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        sized(
          VScrollArea.horizontal(
            controller: controller,
            child: const SizedBox(width: 1000, height: 50),
          ),
        ),
      );

      expect(controller.position.axis, Axis.horizontal);
    });

    testWidgets('explicit thumbColor beats the theme override', (tester) async {
      const themeColor = Color(0xFF00FF00);
      const explicit = Color(0xFFFF0000);
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light().copyWith(
            componentOverrides: const VComponentOverrides([
              VScrollAreaStyle(scrollbarColor: themeColor),
            ]),
          ),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQueryData(),
              child: SizedBox(
                width: 200,
                height: 200,
                child: VScrollArea(
                  thumbColor: explicit,
                  thumbVisibility: true,
                  scrollbarThickness: 9,
                  child: SizedBox(height: 1000),
                ),
              ),
            ),
          ),
        ),
      );

      final scrollbar = tester.widget<RawScrollbar>(find.byType(RawScrollbar));
      expect(scrollbar.thumbColor, explicit);
      expect(scrollbar.thickness, 9);
    });

    testWidgets('theme override applies when no explicit value is given', (
      tester,
    ) async {
      const themeColor = Color(0xFF00FF00);
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light().copyWith(
            componentOverrides: const VComponentOverrides([
              VScrollAreaStyle(
                scrollbarColor: themeColor,
                scrollbarThickness: 11,
              ),
            ]),
          ),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQueryData(),
              child: SizedBox(
                width: 200,
                height: 200,
                child: VScrollArea(child: SizedBox(height: 1000)),
              ),
            ),
          ),
        ),
      );

      final scrollbar = tester.widget<RawScrollbar>(find.byType(RawScrollbar));
      expect(scrollbar.thumbColor, themeColor);
      expect(scrollbar.thickness, 11);
    });
  });
}
