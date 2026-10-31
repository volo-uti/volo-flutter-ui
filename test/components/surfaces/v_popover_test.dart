import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VPopover', () {
    testWidgets('creates default popover', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VPopover(
              content: Text('Popover Content'),
              child: Text('Trigger'),
            ),
          ),
        ),
      );

      expect(find.byType(VPopover), findsOneWidget);
      expect(find.text('Trigger'), findsOneWidget);
    });

    testWidgets('shows popover on tap', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => const VPopover(
                    content: Text('Popover Content'),
                    child: Text('Trigger'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Popover Content'), findsOneWidget);
    });

    testWidgets('creates for each position', (tester) async {
      for (final position in VPopoverPosition.values) {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VPopover(
                content: const Text('Content'),
                position: position,
                child: const Text('Trigger'),
              ),
            ),
          ),
        );

        expect(find.byType(VPopover), findsOneWidget);
      }
    });

    testWidgets('uses controller', (tester) async {
      final controller = VPopoverController();

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => VPopover(
                    controller: controller,
                    content: const Text('Popover Content'),
                    child: const Text('Trigger'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(controller.isOpen, isFalse);

      controller.show();
      await tester.pumpAndSettle();
      expect(controller.isOpen, isTrue);

      controller.hide();
      await tester.pumpAndSettle();
      expect(controller.isOpen, isFalse);

      controller.dispose();
    });

    testWidgets('toggle behavior', (tester) async {
      final controller = VPopoverController();

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => VPopover(
                    controller: controller,
                    content: const Text('Popover Content'),
                    child: const Text('Trigger'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      controller.toggle();
      await tester.pumpAndSettle();
      expect(controller.isOpen, isTrue);

      controller.toggle();
      await tester.pumpAndSettle();
      expect(controller.isOpen, isFalse);

      controller.dispose();
    });

    testWidgets('custom offset', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VPopover(
              content: Text('Content'),
              offset: Offset(0, 16),
              child: Text('Trigger'),
            ),
          ),
        ),
      );

      expect(find.byType(VPopover), findsOneWidget);
    });

    testWidgets('barrierDismissible option', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VPopover(
              content: Text('Content'),
              barrierDismissible: false,
              child: Text('Trigger'),
            ),
          ),
        ),
      );

      expect(find.byType(VPopover), findsOneWidget);
    });
  });

  group('VPopover Interactions', () {
    testWidgets('opens and closes popover by tapping', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => const Center(
                    child: VPopover(
                      content: Text('Popover Content'),
                      child: Text('Trigger'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Initial state: popover content is not visible
      expect(find.text('Popover Content'), findsNothing);

      // Tap trigger -> popover opens
      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsOneWidget);

      // Tap trigger again -> popover closes
      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsNothing);
    });

    testWidgets('closes by tapping outside when barrierDismissible=true', (
      tester,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => const Center(
                    child: VPopover(
                      content: Text('Popover Content'),
                      child: Text('Trigger'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Open popover
      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsOneWidget);

      // Tap outside (barrier) -> popover closes
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsNothing);
    });

    testWidgets(
      'does not close by tapping outside when barrierDismissible=false',
      (tester) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (context) => const Center(
                      child: VPopover(
                        content: Text('Popover Content'),
                        barrierDismissible: false,
                        child: Text('Trigger'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Open popover
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();
        expect(find.text('Popover Content'), findsOneWidget);

        // Tap outside -> popover does not close
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();
        expect(find.text('Popover Content'), findsOneWidget);
      },
    );

    testWidgets('opens popover with controller.show()', (tester) async {
      final controller = VPopoverController();

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => Center(
                    child: VPopover(
                      controller: controller,
                      triggerOnTap: false,
                      content: const Text('Popover Content'),
                      child: const Text('Trigger'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Initial state
      expect(find.text('Popover Content'), findsNothing);
      expect(controller.isOpen, isFalse);

      // Call controller.show()
      controller.show();
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsOneWidget);
      expect(controller.isOpen, isTrue);

      controller.dispose();
    });

    testWidgets('closes popover with controller.hide()', (tester) async {
      final controller = VPopoverController();

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => Center(
                    child: VPopover(
                      controller: controller,
                      triggerOnTap: false,
                      content: const Text('Popover Content'),
                      child: const Text('Trigger'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Open popover
      controller.show();
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsOneWidget);

      // Call controller.hide()
      controller.hide();
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsNothing);
      expect(controller.isOpen, isFalse);

      controller.dispose();
    });

    testWidgets('opens and closes popover with controller.toggle()', (
      tester,
    ) async {
      final controller = VPopoverController();

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => Center(
                    child: VPopover(
                      controller: controller,
                      triggerOnTap: false,
                      content: const Text('Popover Content'),
                      child: const Text('Trigger'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Open with toggle
      controller.toggle();
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsOneWidget);
      expect(controller.isOpen, isTrue);

      // Close with toggle
      controller.toggle();
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsNothing);
      expect(controller.isOpen, isFalse);

      controller.dispose();
    });
  });

  group('VPopoverController', () {
    test('initial state isOpen=false', () {
      final controller = VPopoverController();
      expect(controller.isOpen, isFalse);
      controller.dispose();
    });

    test('isOpen=true after show() call', () {
      final controller = VPopoverController()..show();
      expect(controller.isOpen, isTrue);
      controller.dispose();
    });

    test('isOpen=false after hide() call', () {
      final controller = VPopoverController()
        ..show()
        ..hide();
      expect(controller.isOpen, isFalse);
      controller.dispose();
    });

    test('state toggles on toggle() call', () {
      final controller = VPopoverController();
      expect(controller.isOpen, isFalse);
      controller.toggle();
      expect(controller.isOpen, isTrue);
      controller.toggle();
      expect(controller.isOpen, isFalse);
      controller.dispose();
    });

    test('listener invocation', () {
      final controller = VPopoverController();
      var callCount = 0;
      controller
        ..addListener(() => callCount++)
        ..show();
      expect(callCount, 1);

      controller.hide();
      expect(callCount, 2);

      controller.dispose();
    });
  });

  group('VPopover lifecycle', () {
    Widget host(
      Widget Function(BuildContext) builder, {
      TextDirection direction = TextDirection.ltr,
    }) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: direction,
        child: Overlay(initialEntries: [OverlayEntry(builder: builder)]),
      ),
    );

    testWidgets('removes its overlay and barrier when disposed while open', (
      tester,
    ) async {
      final controller = VPopoverController();
      final show = ValueNotifier<bool>(true);
      var taps = 0;
      await tester.pumpWidget(
        host(
          (context) => Column(
            children: [
              GestureDetector(
                onTap: () => taps++,
                child: const SizedBox(
                  width: 100,
                  height: 40,
                  child: Text('Below'),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: show,
                builder: (context, visible, _) => visible
                    ? VPopover(
                        controller: controller,
                        content: const Text('POPC'),
                        child: const Text('Trigger'),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
      controller.show();
      await tester.pumpAndSettle();
      expect(find.text('POPC'), findsOneWidget);

      show.value = false;
      await tester.pumpAndSettle();

      expect(find.text('POPC'), findsNothing);
      await tester.tap(find.text('Below'));
      expect(taps, 1);
    });

    testWidgets('shows again when reopened during the close animation', (
      tester,
    ) async {
      final controller = VPopoverController();
      await tester.pumpWidget(
        host(
          (context) => VPopover(
            controller: controller,
            content: const Text('POPC'),
            child: const Text('Trigger'),
          ),
        ),
      );
      controller.show();
      await tester.pumpAndSettle();
      controller.hide();
      await tester.pump(const Duration(milliseconds: 20));
      controller.show();
      await tester.pumpAndSettle();

      expect(controller.isOpen, isTrue);
      expect(find.text('POPC'), findsOneWidget);
    });

    testWidgets('works after the controller changes from external to null', (
      tester,
    ) async {
      final controller = VPopoverController();
      final current = ValueNotifier<VPopoverController?>(controller);
      await tester.pumpWidget(
        host(
          (context) => ValueListenableBuilder<VPopoverController?>(
            valueListenable: current,
            builder: (context, c, _) => VPopover(
              controller: c,
              content: const Text('POPC'),
              child: const Text('Trigger'),
            ),
          ),
        ),
      );
      current.value = null;
      await tester.pump();

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();

      expect(find.text('POPC'), findsOneWidget);
    });

    testWidgets('bottomStart aligns with the right edge in RTL', (
      tester,
    ) async {
      final controller = VPopoverController();
      await tester.pumpWidget(
        host(
          direction: TextDirection.rtl,
          (context) => Center(
            child: VPopover(
              controller: controller,
              position: VPopoverPosition.bottomStart,
              offset: Offset.zero,
              style: const VPopoverStyle(padding: EdgeInsets.zero),
              content: const SizedBox(key: Key('pop'), width: 100, height: 20),
              child: const SizedBox(key: Key('trigger'), width: 40, height: 20),
            ),
          ),
        ),
      );
      controller.show();
      await tester.pumpAndSettle();

      expect(
        tester.getTopRight(find.byKey(const Key('pop'))).dx,
        closeTo(tester.getTopRight(find.byKey(const Key('trigger'))).dx, 0.5),
      );
    });

    testWidgets('Enter on the focused trigger toggles the popover', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          (context) =>
              const VPopover(content: Text('POPC'), child: Text('Trigger')),
        ),
      );
      final stack = find.descendant(
        of: find.byType(VPopover),
        matching: find.byType(Stack),
      );
      Focus.of(tester.element(stack.first)).requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.text('POPC'), findsOneWidget);
    });
  });
}
