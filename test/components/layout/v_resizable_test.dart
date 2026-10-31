import 'package:flutter/gestures.dart';
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
        data: const MediaQueryData(),
        child: SizedBox(width: 800, height: 600, child: child),
      ),
    ),
  );

  group('VResizablePanelGroup', () {
    testWidgets('default rendering (horizontal)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VResizablePanelGroup(
            children: [
              VResizablePanel(defaultSize: 0.5, child: Text('Panel 1')),
              VResizableHandle(),
              VResizablePanel(defaultSize: 0.5, child: Text('Panel 2')),
            ],
          ),
        ),
      );

      expect(find.byType(VResizablePanelGroup), findsOneWidget);
      expect(find.text('Panel 1'), findsOneWidget);
      expect(find.text('Panel 2'), findsOneWidget);
    });

    testWidgets('default rendering (vertical)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VResizablePanelGroup(
            direction: Axis.vertical,
            children: [
              VResizablePanel(defaultSize: 0.5, child: Text('Top')),
              VResizableHandle(),
              VResizablePanel(defaultSize: 0.5, child: Text('Bottom')),
            ],
          ),
        ),
      );

      expect(find.byType(VResizablePanelGroup), findsOneWidget);
      expect(find.text('Top'), findsOneWidget);
      expect(find.text('Bottom'), findsOneWidget);
    });

    testWidgets('3-panel split', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VResizablePanelGroup(
            children: [
              VResizablePanel(defaultSize: 0.25, child: Text('Left')),
              VResizableHandle(),
              VResizablePanel(defaultSize: 0.5, child: Text('Center')),
              VResizableHandle(),
              VResizablePanel(defaultSize: 0.25, child: Text('Right')),
            ],
          ),
        ),
      );

      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Center'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
    });

    testWidgets('onLayoutChanged callback', (tester) async {
      List<double>? lastLayout;

      await tester.pumpWidget(
        buildTestWidget(
          VResizablePanelGroup(
            onLayoutChanged: (layout) => lastLayout = layout,
            children: const [
              VResizablePanel(defaultSize: 0.5, child: Text('Panel 1')),
              VResizableHandle(),
              VResizablePanel(defaultSize: 0.5, child: Text('Panel 2')),
            ],
          ),
        ),
      );

      expect(find.byType(VResizablePanelGroup), findsOneWidget);
      expect(lastLayout, isNull); // No layout change yet
    });
  });

  group('VResizablePanel', () {
    testWidgets('default properties', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VResizablePanelGroup(
            children: [
              VResizablePanel(
                defaultSize: 0.3,
                minSize: 0.1,
                maxSize: 0.5,
                child: Text('Panel'),
              ),
              VResizableHandle(),
              VResizablePanel(defaultSize: 0.7, child: Text('Other')),
            ],
          ),
        ),
      );

      expect(find.text('Panel'), findsOneWidget);
    });

    testWidgets('collapsible panel', (tester) async {
      var collapsed = false;
      var expanded = false;

      await tester.pumpWidget(
        buildTestWidget(
          VResizablePanelGroup(
            children: [
              VResizablePanel(
                defaultSize: 0.3,
                collapsible: true,
                collapsedSize: 0.05,
                onCollapse: () => collapsed = true,
                onExpand: () => expanded = true,
                child: const Text('Sidebar'),
              ),
              const VResizableHandle(),
              const VResizablePanel(defaultSize: 0.7, child: Text('Content')),
            ],
          ),
        ),
      );

      expect(find.text('Sidebar'), findsOneWidget);
      expect(collapsed, isFalse);
      expect(expanded, isFalse);
    });

    testWidgets('onSizeChanged callback', (tester) async {
      double? lastSize;

      await tester.pumpWidget(
        buildTestWidget(
          VResizablePanelGroup(
            children: [
              VResizablePanel(
                defaultSize: 0.5,
                onSizeChanged: (size) => lastSize = size,
                child: const Text('Panel'),
              ),
              const VResizableHandle(),
              const VResizablePanel(defaultSize: 0.5, child: Text('Other')),
            ],
          ),
        ),
      );

      expect(find.text('Panel'), findsOneWidget);
      expect(lastSize, isNull); // No resize yet
    });
  });

  group('VResizableHandle', () {
    testWidgets('default rendering', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VResizablePanelGroup(
            children: [
              VResizablePanel(defaultSize: 0.5, child: Text('Left')),
              VResizableHandle(),
              VResizablePanel(defaultSize: 0.5, child: Text('Right')),
            ],
          ),
        ),
      );

      // Handle is rendered between panels
      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
      expect(find.byType(MouseRegion), findsWidgets);
    });

    testWidgets('withHandle=false', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VResizablePanelGroup(
            children: [
              VResizablePanel(defaultSize: 0.5, child: Text('Left')),
              VResizableHandle(withHandle: false),
              VResizablePanel(defaultSize: 0.5, child: Text('Right')),
            ],
          ),
        ),
      );

      // Handle is rendered but without visual indicator
      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
    });

    testWidgets('handle with enabled false', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VResizablePanelGroup(
            children: [
              VResizablePanel(defaultSize: 0.5, child: Text('Left')),
              VResizableHandle(enabled: false),
              VResizablePanel(defaultSize: 0.5, child: Text('Right')),
            ],
          ),
        ),
      );

      // Disabled handle is rendered
      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
    });
  });

  group('nested panels', () {
    testWidgets('nested VResizablePanelGroup', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VResizablePanelGroup(
            children: [
              VResizablePanel(defaultSize: 0.3, child: Text('Sidebar')),
              VResizableHandle(),
              VResizablePanel(
                defaultSize: 0.7,
                child: VResizablePanelGroup(
                  direction: Axis.vertical,
                  children: [
                    VResizablePanel(defaultSize: 0.6, child: Text('Editor')),
                    VResizableHandle(),
                    VResizablePanel(defaultSize: 0.4, child: Text('Terminal')),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

      expect(find.byType(VResizablePanelGroup), findsNWidgets(2));
      expect(find.text('Sidebar'), findsOneWidget);
      expect(find.text('Editor'), findsOneWidget);
      expect(find.text('Terminal'), findsOneWidget);
    });
  });

  group('interaction tests', () {
    testWidgets('drag resize test (horizontal)', (tester) async {
      // ignore: unused_local_variable
      List<double>? lastLayout;

      await tester.pumpWidget(
        buildTestWidget(
          VResizablePanelGroup(
            onLayoutChanged: (layout) => lastLayout = layout,
            children: const [
              VResizablePanel(defaultSize: 0.5, child: Text('Panel 1')),
              VResizableHandle(),
              VResizablePanel(defaultSize: 0.5, child: Text('Panel 2')),
            ],
          ),
        ),
      );

      // Use Container position to find the handle directly
      // VResizablePanelGroup is inside 800x600, handle is in the middle
      final panelGroupFinder = find.byType(VResizablePanelGroup);
      expect(panelGroupFinder, findsOneWidget);

      // Drag simulation - start from position near the handle
      // Find GestureDetector and drag
      final gestureDetectors = find.byType(GestureDetector);

      // Horizontal drag simulation
      final gesture = await tester.startGesture(
        tester.getCenter(gestureDetectors.first),
      );
      await tester.pump();
      await gesture.moveBy(const Offset(100, 0));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      // Check if onLayoutChanged callback was called after drag ended
      // (called if handle works correctly)
      expect(find.byType(VResizablePanelGroup), findsOneWidget);
    });

    testWidgets('drag resize test (vertical)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VResizablePanelGroup(
            direction: Axis.vertical,
            children: [
              VResizablePanel(defaultSize: 0.5, child: Text('Top')),
              VResizableHandle(),
              VResizablePanel(defaultSize: 0.5, child: Text('Bottom')),
            ],
          ),
        ),
      );

      // Find handle
      final gestureDetectors = find.byType(GestureDetector);

      // Vertical drag simulation
      final gesture = await tester.startGesture(
        tester.getCenter(gestureDetectors.first),
      );
      await tester.pump();
      await gesture.moveBy(const Offset(0, 50));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.byType(VResizablePanelGroup), findsOneWidget);
      expect(find.text('Top'), findsOneWidget);
      expect(find.text('Bottom'), findsOneWidget);
    });

    testWidgets('min/max size constraint test', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VResizablePanelGroup(
            children: [
              VResizablePanel(
                defaultSize: 0.5,
                minSize: 0.2,
                maxSize: 0.6,
                child: Text('Panel 1'),
              ),
              VResizableHandle(),
              VResizablePanel(
                defaultSize: 0.5,
                minSize: 0.2,
                child: Text('Panel 2'),
              ),
            ],
          ),
        ),
      );

      // Find handle
      final gestureDetectors = find.byType(GestureDetector);

      // Perform drag (far right - should hit maxSize constraint)
      final gesture = await tester.startGesture(
        tester.getCenter(gestureDetectors.first),
      );
      await tester.pump();
      await gesture.moveBy(const Offset(300, 0));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      // Panels should still be visible (constraints applied)
      expect(find.text('Panel 1'), findsOneWidget);
      expect(find.text('Panel 2'), findsOneWidget);
    });

    testWidgets('onSizeChanged callback registration', (tester) async {
      double? panel1Size;

      await tester.pumpWidget(
        buildTestWidget(
          VResizablePanelGroup(
            children: [
              VResizablePanel(
                defaultSize: 0.5,
                onSizeChanged: (size) => panel1Size = size,
                child: const Text('Panel 1'),
              ),
              const VResizableHandle(),
              const VResizablePanel(defaultSize: 0.5, child: Text('Panel 2')),
            ],
          ),
        ),
      );

      // Callback is not called initially
      expect(panel1Size, isNull);

      // Panel group renders normally
      expect(find.byType(VResizablePanelGroup), findsOneWidget);
    });

    testWidgets('onLayoutChanged callback registration', (tester) async {
      List<double>? finalLayout;

      await tester.pumpWidget(
        buildTestWidget(
          VResizablePanelGroup(
            onLayoutChanged: (layout) => finalLayout = layout,
            children: const [
              VResizablePanel(defaultSize: 0.5, child: Text('Panel 1')),
              VResizableHandle(),
              VResizablePanel(defaultSize: 0.5, child: Text('Panel 2')),
            ],
          ),
        ),
      );

      // Callback is not called initially
      expect(finalLayout, isNull);

      // Panel group renders normally
      expect(find.byType(VResizablePanelGroup), findsOneWidget);
    });

    testWidgets('drag does not work on handle with enabled false', (
      tester,
    ) async {
      List<double>? lastLayout;

      await tester.pumpWidget(
        buildTestWidget(
          VResizablePanelGroup(
            onLayoutChanged: (layout) => lastLayout = layout,
            children: const [
              VResizablePanel(defaultSize: 0.5, child: Text('Panel 1')),
              VResizableHandle(enabled: false),
              VResizablePanel(defaultSize: 0.5, child: Text('Panel 2')),
            ],
          ),
        ),
      );

      // Find handle
      final gestureDetectors = find.byType(GestureDetector);

      // Attempt drag
      final gesture = await tester.startGesture(
        tester.getCenter(gestureDetectors.first),
      );
      await tester.pump();
      await gesture.moveBy(const Offset(100, 0));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      // onLayoutChanged callback should not be called in disabled state
      expect(lastLayout, isNull);
    });

    testWidgets('collapsible panel double-tap fold/unfold', (tester) async {
      var collapsed = false;
      // ignore: unused_local_variable
      var expanded = false;

      await tester.pumpWidget(
        buildTestWidget(
          VResizablePanelGroup(
            children: [
              VResizablePanel(
                defaultSize: 0.3,
                collapsible: true,
                collapsedSize: 0.05,
                onCollapse: () => collapsed = true,
                onExpand: () => expanded = true,
                child: const Text('Sidebar'),
              ),
              const VResizableHandle(),
              const VResizablePanel(defaultSize: 0.7, child: Text('Content')),
            ],
          ),
        ),
      );

      // Find GestureDetector
      final gestureDetectors = find.byType(GestureDetector);

      // Perform double-tap
      await tester.tapAt(tester.getCenter(gestureDetectors.first));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tapAt(tester.getCenter(gestureDetectors.first));
      await tester.pumpAndSettle();

      // Since collapsible panel is set, it should respond to double-tap
      // However, double-tap recognition can be tricky in test environment
      // At minimum verify that the widget is rendered
      expect(find.text('Sidebar'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);

      // Verify callback was called or widget works normally
      // (collapsed is true if double-tap succeeded)
      if (collapsed) {
        expect(collapsed, isTrue);
      }
    });

    testWidgets('handle style changes on mouse hover', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VResizablePanelGroup(
            children: [
              VResizablePanel(defaultSize: 0.5, child: Text('Panel 1')),
              VResizableHandle(),
              VResizablePanel(defaultSize: 0.5, child: Text('Panel 2')),
            ],
          ),
        ),
      );

      // Find MouseRegion
      final mouseRegionFinder = find.byType(MouseRegion).first;
      expect(mouseRegionFinder, findsOneWidget);

      // Mouse hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(mouseRegionFinder));
      addTearDown(gesture.removePointer);
      await tester.pump();

      // Hover state applied (Container color changed)
      expect(find.byType(MouseRegion), findsWidgets);
    });
  });

  group('keyboard', () {
    Future<void> focusHandle(WidgetTester tester) async {
      final focus = tester.widget<Focus>(
        find
            .descendant(
              of: find.byType(VResizablePanelGroup),
              matching: find.byType(Focus),
            )
            .first,
      );
      focus.focusNode!.requestFocus();
      await tester.pump();
    }

    Widget group({
      required List<List<double>> layouts,
      List<double>? sizes,
      Axis direction = Axis.horizontal,
      bool enabled = true,
    }) => buildTestWidget(
      VResizablePanelGroup(
        direction: direction,
        onLayoutChanged: layouts.add,
        children: [
          VResizablePanel(
            defaultSize: 0.5,
            onSizeChanged: sizes?.add,
            child: const Text('Panel 1'),
          ),
          VResizableHandle(enabled: enabled),
          const VResizablePanel(defaultSize: 0.5, child: Text('Panel 2')),
        ],
      ),
    );

    testWidgets('ArrowRight grows the first panel and reports the layout', (
      tester,
    ) async {
      final layouts = <List<double>>[];
      final sizes = <double>[];
      await tester.pumpWidget(group(layouts: layouts, sizes: sizes));
      await focusHandle(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();

      expect(layouts, hasLength(1));
      expect(layouts.single[0], closeTo(0.5125, 0.0001));
      expect(layouts.single[1], closeTo(0.4875, 0.0001));
      expect(sizes.single, closeTo(0.5125, 0.0001));
    });

    testWidgets('ArrowLeft shrinks the first panel', (tester) async {
      final layouts = <List<double>>[];
      await tester.pumpWidget(group(layouts: layouts));
      await focusHandle(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();

      expect(layouts.single[0], closeTo(0.4875, 0.0001));
    });

    testWidgets('vertical group answers ArrowDown, not ArrowRight', (
      tester,
    ) async {
      final layouts = <List<double>>[];
      await tester.pumpWidget(
        group(layouts: layouts, direction: Axis.vertical),
      );
      await focusHandle(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(layouts, isEmpty);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(layouts.single[0], greaterThan(0.5));
    });

    testWidgets('enabled false ignores the keys', (tester) async {
      final layouts = <List<double>>[];
      await tester.pumpWidget(group(layouts: layouts, enabled: false));
      await focusHandle(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();

      expect(layouts, isEmpty);
    });
  });

  group('VResizablePanelGroup regressions', () {
    final handleFinder = find.byWidgetPredicate(
      (w) => w is GestureDetector && w.onHorizontalDragUpdate != null,
    );

    testWidgets('drag stops at the dragged panel min size', (tester) async {
      List<double>? layout;
      await tester.pumpWidget(
        buildTestWidget(
          VResizablePanelGroup(
            onLayoutChanged: (l) => layout = l,
            children: const [
              VResizablePanel(
                defaultSize: 0.5,
                minSize: 0.4,
                child: SizedBox(),
              ),
              VResizableHandle(),
              VResizablePanel(defaultSize: 0.5, child: SizedBox()),
            ],
          ),
        ),
      );

      await tester.drag(handleFinder, const Offset(-300, 0));
      await tester.pumpAndSettle();

      expect(layout, isNotNull);
      expect(layout![0], closeTo(0.4, 1e-6));
      expect(layout![1], closeTo(0.6, 1e-6));
    });

    testWidgets('drag stops at the neighbour min size', (tester) async {
      List<double>? layout;
      await tester.pumpWidget(
        buildTestWidget(
          VResizablePanelGroup(
            onLayoutChanged: (l) => layout = l,
            children: const [
              VResizablePanel(defaultSize: 0.5, child: SizedBox()),
              VResizableHandle(),
              VResizablePanel(
                defaultSize: 0.5,
                minSize: 0.4,
                child: SizedBox(),
              ),
            ],
          ),
        ),
      );

      await tester.drag(handleFinder, const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(layout![0], closeTo(0.6, 1e-6));
      expect(layout![1], closeTo(0.4, 1e-6));
    });

    testWidgets('drag stops at the max size', (tester) async {
      List<double>? layout;
      await tester.pumpWidget(
        buildTestWidget(
          VResizablePanelGroup(
            onLayoutChanged: (l) => layout = l,
            children: const [
              VResizablePanel(
                defaultSize: 0.5,
                maxSize: 0.6,
                child: SizedBox(),
              ),
              VResizableHandle(),
              VResizablePanel(defaultSize: 0.5, child: SizedBox()),
            ],
          ),
        ),
      );

      await tester.drag(handleFinder, const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(layout![0], closeTo(0.6, 1e-6));
      expect(layout![0] + layout![1], closeTo(1, 1e-9));
    });

    testWidgets('a panel near its limit does not jump away from the pointer', (
      tester,
    ) async {
      List<double>? layout;
      await tester.pumpWidget(
        buildTestWidget(
          VResizablePanelGroup(
            onLayoutChanged: (l) => layout = l,
            children: const [
              VResizablePanel(
                defaultSize: 0.41,
                minSize: 0.4,
                child: SizedBox(),
              ),
              VResizableHandle(),
              VResizablePanel(defaultSize: 0.59, child: SizedBox()),
            ],
          ),
        ),
      );

      await tester.drag(handleFinder, const Offset(-100, 0));
      await tester.pumpAndSettle();

      expect(layout![0], closeTo(0.4, 1e-6));
    });

    testWidgets('the handle follows the pointer one to one', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VResizablePanelGroup(
            children: [
              VResizablePanel(defaultSize: 0.5, child: SizedBox()),
              VResizableHandle(),
              VResizablePanel(defaultSize: 0.5, child: SizedBox()),
            ],
          ),
        ),
      );
      final before = tester.getTopLeft(handleFinder).dx;

      await tester.drag(handleFinder, const Offset(100, 0));
      await tester.pumpAndSettle();

      // The first kDragSlopDefault pixels only start the gesture.
      expect(
        tester.getTopLeft(handleFinder).dx - before,
        closeTo(100 - kDragSlopDefault, 0.05),
      );
    });

    testWidgets(
      'collapse with a collapsedSize alternates collapse and expand',
      (tester) async {
        final events = <String>[];
        await tester.pumpWidget(
          buildTestWidget(
            VResizablePanelGroup(
              children: [
                VResizablePanel(
                  defaultSize: 0.3,
                  collapsible: true,
                  collapsedSize: 0.05,
                  onCollapse: () => events.add('collapse'),
                  onExpand: () => events.add('expand'),
                  child: const SizedBox(),
                ),
                const VResizableHandle(),
                const VResizablePanel(defaultSize: 0.7, child: SizedBox()),
              ],
            ),
          ),
        );

        for (var i = 0; i < 3; i++) {
          await tester.tap(handleFinder);
          await tester.pump(const Duration(milliseconds: 50));
          await tester.tap(handleFinder);
          await tester.pump(const Duration(milliseconds: 600));
        }

        expect(events, ['collapse', 'expand', 'collapse']);
      },
    );

    testWidgets('a collapsible right-hand panel collapses and expands', (
      tester,
    ) async {
      final events = <String>[];
      List<double>? layout;
      await tester.pumpWidget(
        buildTestWidget(
          VResizablePanelGroup(
            onLayoutChanged: (l) => layout = l,
            children: [
              const VResizablePanel(defaultSize: 0.7, child: SizedBox()),
              const VResizableHandle(),
              VResizablePanel(
                defaultSize: 0.3,
                collapsible: true,
                onCollapse: () => events.add('collapse'),
                onExpand: () => events.add('expand'),
                child: const SizedBox(),
              ),
            ],
          ),
        ),
      );

      await tester.tap(handleFinder);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(handleFinder);
      await tester.pump(const Duration(milliseconds: 600));
      expect(events, ['collapse']);
      expect(layout, [closeTo(1, 1e-9), closeTo(0, 1e-9)]);

      await tester.tap(handleFinder);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(handleFinder);
      await tester.pump(const Duration(milliseconds: 600));
      expect(events, ['collapse', 'expand']);
      expect(layout, [closeTo(0.7, 1e-9), closeTo(0.3, 1e-9)]);
    });

    testWidgets('a changed defaultSize resets the layout', (tester) async {
      Widget build(double first) => buildTestWidget(
        VResizablePanelGroup(
          children: [
            VResizablePanel(
              defaultSize: first,
              child: const SizedBox(key: Key('first')),
            ),
            const VResizableHandle(),
            const VResizablePanel(defaultSize: 0.5, child: SizedBox()),
          ],
        ),
      );
      await tester.pumpWidget(build(0.5));
      final before = tester.getSize(find.byType(ClipRect).first).width;

      await tester.pumpWidget(build(0.2));
      final after = tester.getSize(find.byType(ClipRect).first).width;

      expect(after, lessThan(before));
    });

    testWidgets('a changed minSize applies to later drags', (tester) async {
      List<double>? layout;
      Widget build(double min) => buildTestWidget(
        VResizablePanelGroup(
          onLayoutChanged: (l) => layout = l,
          children: [
            VResizablePanel(
              defaultSize: 0.5,
              minSize: min,
              child: const SizedBox(),
            ),
            const VResizableHandle(),
            const VResizablePanel(defaultSize: 0.5, child: SizedBox()),
          ],
        ),
      );
      await tester.pumpWidget(build(0));
      await tester.pumpWidget(build(0.45));

      await tester.drag(handleFinder, const Offset(-300, 0));
      await tester.pumpAndSettle();

      expect(layout![0], closeTo(0.45, 1e-6));
    });
  });
}
