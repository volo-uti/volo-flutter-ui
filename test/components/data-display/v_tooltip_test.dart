import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VTooltip', () {
    testWidgets('creates default tooltip', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VTooltip(message: 'More Info', child: Text('Hover')),
          ),
        ),
      );

      expect(find.byType(VTooltip), findsOneWidget);
      expect(find.text('Hover'), findsOneWidget);
    });

    testWidgets('creates with each position', (tester) async {
      for (final position in VTooltipPosition.values) {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VTooltip(
                message: 'Info',
                position: position,
                child: const Text('Target'),
              ),
            ),
          ),
        );

        expect(find.byType(VTooltip), findsOneWidget);
      }
    });

    test('requires exactly one of message and richMessage', () {
      expect(() => VTooltip(child: const Text('x')), throwsAssertionError);
      expect(
        () => VTooltip(
          message: 'a',
          richMessage: const Text('b'),
          child: const Text('x'),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('supports richMessage', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VTooltip(
              richMessage: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.help, size: 16),
                  SizedBox(width: 4),
                  Text('Widget Message'),
                ],
              ),
              child: Text('Target'),
            ),
          ),
        ),
      );

      expect(find.byType(VTooltip), findsOneWidget);
    });

    testWidgets('waitDuration setting', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VTooltip(
              message: 'Info',
              waitDuration: Duration(milliseconds: 1000),
              child: Text('Target'),
            ),
          ),
        ),
      );

      expect(find.byType(VTooltip), findsOneWidget);
    });

    testWidgets('showDuration setting', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VTooltip(
              message: 'Info',
              showDuration: Duration(milliseconds: 3000),
              child: Text('Target'),
            ),
          ),
        ),
      );

      expect(find.byType(VTooltip), findsOneWidget);
    });

    testWidgets('child renders correctly', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VTooltip(
              message: 'Info',
              child: SizedBox(
                width: 100,
                height: 50,
                child: Center(child: Text('Button')),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Button'), findsOneWidget);
    });
  });

  group('VTooltip Interactions', () {
    testWidgets('shows tooltip on hover', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => const Center(
                    child: VTooltip(
                      message: 'Tooltip Message',
                      waitDuration: Duration(milliseconds: 100),
                      showDuration: Duration(seconds: 10),
                      child: Text('Hover Target'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Initial state: tooltip is not visible
      expect(find.text('Tooltip Message'), findsNothing);

      // Start mouse hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Hover Target')));
      await tester.pump();

      // Wait for waitDuration
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      // Tooltip is shown
      expect(find.text('Tooltip Message'), findsOneWidget);
    });

    testWidgets('tooltip disappears on hover exit', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => const Center(
                    child: VTooltip(
                      message: 'Tooltip Message',
                      waitDuration: Duration(milliseconds: 100),
                      showDuration: Duration(seconds: 10),
                      child: Text('Hover Target'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Mouse hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Hover Target')));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.text('Tooltip Message'), findsOneWidget);

      // Mouse hover exit
      await gesture.moveTo(Offset.zero);
      await tester.pumpAndSettle();

      // Tooltip disappears
      expect(find.text('Tooltip Message'), findsNothing);
    });

    testWidgets('shows tooltip on long press', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => const Center(
                    child: VTooltip(
                      message: 'Tooltip Message',
                      waitDuration: Duration(milliseconds: 100),
                      showDuration: Duration(seconds: 10),
                      child: Text('Long Press Target'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Initial state
      expect(find.text('Tooltip Message'), findsNothing);

      // Start long press
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Long Press Target')),
      );

      // Wait for long press (500ms+)
      await tester.pump(const Duration(milliseconds: 600));

      // Wait for waitDuration
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      // Tooltip is shown
      expect(find.text('Tooltip Message'), findsOneWidget);

      // End long press
      await gesture.up();
      await tester.pumpAndSettle();

      // Tooltip disappears
      expect(find.text('Tooltip Message'), findsNothing);
    });

    testWidgets('shows above when position=top', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => const Center(
                    child: VTooltip(
                      message: 'Top Tooltip',
                      waitDuration: Duration(milliseconds: 100),
                      showDuration: Duration(seconds: 10),
                      child: SizedBox(
                        width: 100,
                        height: 50,
                        child: Center(child: Text('Target')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Mouse hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Target')));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      // Tooltip is shown
      expect(find.text('Top Tooltip'), findsOneWidget);

      // Verify position: tooltip should be above the target
      final targetCenter = tester.getCenter(find.text('Target'));
      final tooltipCenter = tester.getCenter(find.text('Top Tooltip'));
      expect(tooltipCenter.dy, lessThan(targetCenter.dy));
    });

    testWidgets('shows below when position=bottom', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => const Center(
                    child: VTooltip(
                      message: 'Bottom Tooltip',
                      position: VTooltipPosition.bottom,
                      waitDuration: Duration(milliseconds: 100),
                      showDuration: Duration(seconds: 10),
                      child: SizedBox(
                        width: 100,
                        height: 50,
                        child: Center(child: Text('Target')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Mouse hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Target')));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      // Tooltip is shown
      expect(find.text('Bottom Tooltip'), findsOneWidget);

      // Verify position: tooltip should be below the target
      final targetCenter = tester.getCenter(find.text('Target'));
      final tooltipCenter = tester.getCenter(find.text('Bottom Tooltip'));
      expect(tooltipCenter.dy, greaterThan(targetCenter.dy));
    });

    testWidgets('shows to the left when position=left', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => const Center(
                    child: VTooltip(
                      message: 'Left Tooltip',
                      position: VTooltipPosition.left,
                      waitDuration: Duration(milliseconds: 100),
                      showDuration: Duration(seconds: 10),
                      child: SizedBox(
                        width: 100,
                        height: 50,
                        child: Center(child: Text('Target')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Mouse hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Target')));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      // Tooltip is shown
      expect(find.text('Left Tooltip'), findsOneWidget);

      // Verify position: tooltip should be to the left of the target
      final targetCenter = tester.getCenter(find.text('Target'));
      final tooltipCenter = tester.getCenter(find.text('Left Tooltip'));
      expect(tooltipCenter.dx, lessThan(targetCenter.dx));
    });

    testWidgets('shows to the right when position=right', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => const Center(
                    child: VTooltip(
                      message: 'Right Tooltip',
                      position: VTooltipPosition.right,
                      waitDuration: Duration(milliseconds: 100),
                      showDuration: Duration(seconds: 10),
                      child: SizedBox(
                        width: 100,
                        height: 50,
                        child: Center(child: Text('Target')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Mouse hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Target')));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      // Tooltip is shown
      expect(find.text('Right Tooltip'), findsOneWidget);

      // Verify position: tooltip should be to the right of the target
      final targetCenter = tester.getCenter(find.text('Target'));
      final tooltipCenter = tester.getCenter(find.text('Right Tooltip'));
      expect(tooltipCenter.dx, greaterThan(targetCenter.dx));
    });

    testWidgets('automatically disappears after showDuration', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => const Center(
                    child: VTooltip(
                      message: 'Auto Dismiss Tooltip',
                      waitDuration: Duration(milliseconds: 100),
                      showDuration: Duration(milliseconds: 500),
                      child: Text('Target'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Mouse hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Target')));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.text('Auto Dismiss Tooltip'), findsOneWidget);

      // Wait for showDuration (while mouse is still hovering)
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      // Tooltip automatically disappears
      expect(find.text('Auto Dismiss Tooltip'), findsNothing);
    });
  });

  group('lifecycle', () {
    final show = ValueNotifier<bool>(true);
    Widget host() => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => Center(
                child: ValueListenableBuilder<bool>(
                  valueListenable: show,
                  builder: (context, visible, _) => visible
                      ? const VTooltip(
                          message: 'Leaky',
                          waitDuration: Duration(milliseconds: 100),
                          showDuration: Duration(seconds: 10),
                          child: Text('Target'),
                        )
                      : const SizedBox(),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    setUp(() => show.value = true);

    testWidgets('removes its overlay entry when disposed while open', (
      tester,
    ) async {
      await tester.pumpWidget(host());
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.text('Target')));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.text('Leaky'), findsOneWidget);

      show.value = false;
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Leaky'), findsNothing);
    });

    testWidgets('keeps the tooltip when the pointer re-enters while it fades', (
      tester,
    ) async {
      await tester.pumpWidget(host());
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      final target = tester.getCenter(find.text('Target'));
      await gesture.moveTo(target);
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.text('Leaky'), findsOneWidget);

      // Leave (starts the fade-out), then re-enter and long-press to show again.
      await gesture.moveTo(Offset.zero);
      await tester.pump(const Duration(milliseconds: 20));
      final press = await tester.startGesture(target);
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      expect(find.text('Leaky'), findsOneWidget);
      await press.up();
    });
  });

  group('theme override', () {
    testWidgets('theme componentOverrides applies to tooltip', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light().copyWith(
            componentOverrides: const VComponentOverrides([
              VTooltipStyle(backgroundColor: Color(0xFFFF0000)),
            ]),
          ),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VTooltip(message: 'Info', child: Text('Target')),
          ),
        ),
      );

      expect(find.byType(VTooltip), findsOneWidget);
    });
  });
}
