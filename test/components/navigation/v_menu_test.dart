import 'package:flutter/material.dart' show Icons;
import 'package:flutter/semantics.dart';
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
        data: const MediaQueryData(size: Size(800, 800)),
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (_) =>
                  Align(alignment: Alignment.topCenter, child: child),
            ),
          ],
        ),
      ),
    ),
  );

  group('VMenu', () {
    testWidgets('renders trigger', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VMenu(
            trigger: const Text('Menu'),
            items: [VMenuItem(child: const Text('Edit'), onTap: () {})],
          ),
        ),
      );

      expect(find.text('Menu'), findsOneWidget);
    });

    testWidgets('opens menu on tap', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VMenu(
            trigger: const Text('Menu'),
            items: [
              VMenuItem(child: const Text('Edit'), onTap: () {}),
              VMenuItem(child: const Text('Delete'), onTap: () {}),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Menu'));
      await tester.pump();

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('calls onTap when item is tapped', (tester) async {
      var editTapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VMenu(
            trigger: const Text('Menu'),
            items: [
              VMenuItem(
                child: const Text('Edit'),
                onTap: () => editTapped = true,
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      expect(editTapped, isTrue);
    });

    testWidgets('renders with leading icon', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VMenu(
            trigger: const Text('Menu'),
            items: [
              VMenuItem(
                child: const Text('Edit'),
                leading: const Icon(Icons.edit),
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Menu'));
      await tester.pump();

      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('renders divider', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VMenu(
            trigger: const Text('Menu'),
            items: [
              VMenuItem(child: const Text('Edit'), onTap: () {}),
              const VMenuDivider(),
              VMenuItem(child: const Text('Delete'), onTap: () {}),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Menu'));
      await tester.pump();

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('disabled item does not trigger onTap', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          VMenu(
            trigger: const Text('Menu'),
            items: [
              VMenuItem(
                child: const Text('Disabled'),
                onTap: () => tapped = true,
                enabled: false,
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Menu'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });

    testWidgets('closes menu on backdrop tap', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VMenu(
            trigger: const Text('Menu'),
            items: [VMenuItem(child: const Text('Edit'), onTap: () {})],
          ),
        ),
      );

      await tester.tap(find.text('Menu'));
      await tester.pump();

      expect(find.text('Edit'), findsOneWidget);

      // Tap outside to close
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();

      expect(find.text('Edit'), findsNothing);
    });

    testWidgets('plain Text child takes the themed menu text style', (
      tester,
    ) async {
      final theme = VThemeData.light();
      await tester.pumpWidget(
        buildTestWidget(
          VMenu(
            trigger: const Text('Menu'),
            items: [VMenuItem(child: const Text('Edit'), onTap: () {})],
          ),
        ),
      );
      await tester.tap(find.text('Menu'));
      await tester.pumpAndSettle();

      final style = tester
          .widget<RichText>(
            find.descendant(
              of: find.text('Edit'),
              matching: find.byType(RichText),
            ),
          )
          .text
          .style!;
      expect(style.fontSize, theme.typography.bodyMedium.fontSize);
      expect(style.color, theme.colors.popoverForeground);
    });

    testWidgets('arrow keys move and Enter activates the item', (tester) async {
      final taps = <String>[];
      await tester.pumpWidget(
        buildTestWidget(
          VMenu(
            trigger: const Text('Menu'),
            items: [
              VMenuItem(child: const Text('One'), onTap: () => taps.add('one')),
              VMenuItem(
                child: const Text('Skipped'),
                enabled: false,
                onTap: () => taps.add('skipped'),
              ),
              VMenuItem(
                child: const Text('Three'),
                onTap: () => taps.add('three'),
              ),
            ],
          ),
        ),
      );
      await tester.tap(find.text('Menu'));
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(taps, ['three']);
      expect(find.text('Three'), findsNothing);
    });

    testWidgets('Escape closes the menu', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VMenu(
            trigger: const Text('Menu'),
            items: [VMenuItem(child: const Text('Edit'), onTap: () {})],
          ),
        ),
      );
      await tester.tap(find.text('Menu'));
      await tester.pumpAndSettle();
      expect(find.text('Edit'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Edit'), findsNothing);
    });
  });

  group('VMenu regressions', () {
    // The menu's own focus node, the first Focus under the VMenu.
    void focusTrigger(WidgetTester tester) {
      tester
          .widget<Focus>(
            find
                .descendant(
                  of: find.byType(VMenu),
                  matching: find.byType(Focus),
                )
                .first,
          )
          .focusNode!
          .requestFocus();
    }

    Widget menuWithButton(VoidCallback onTriggerPressed) => buildTestWidget(
      SizedBox(
        width: 200,
        child: VMenu(
          trigger: VButton(
            onPressed: onTriggerPressed,
            child: const Text('Options'),
          ),
          items: [VMenuItem(onTap: () {}, child: const Text('Edit'))],
        ),
      ),
    );

    testWidgets('Enter on the focused trigger opens the menu', (tester) async {
      var triggerPressed = 0;
      await tester.pumpWidget(menuWithButton(() => triggerPressed++));

      focusTrigger(tester);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      await tester.pump();

      expect(find.text('Edit'), findsOneWidget);
      expect(triggerPressed, 0);
    });

    testWidgets('Arrow Down on the focused trigger opens the menu', (
      tester,
    ) async {
      await tester.pumpWidget(menuWithButton(() {}));

      focusTrigger(tester);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.pump();

      expect(find.text('Edit'), findsOneWidget);
    });

    testWidgets('the trigger is one labelled button that opens the menu', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var triggerPressed = 0;
      await tester.pumpWidget(menuWithButton(() => triggerPressed++));

      // Exactly one node can be tapped, and it carries the trigger's label.
      final tappable = find.semantics.byAction(SemanticsAction.tap);
      final nodes = tappable.evaluate().toList();
      expect(nodes, hasLength(1));
      expect(nodes.single.getSemanticsData().label, contains('Options'));

      tester.semantics.tap(tappable);
      await tester.pump();
      await tester.pump();

      expect(find.text('Edit'), findsOneWidget);
      expect(triggerPressed, 0);
      handle.dispose();
    });

    testWidgets('bottomStart opens at the start edge in RTL', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(800, 800)),
              child: Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (_) => Align(
                      alignment: Alignment.topCenter,
                      child: VMenu(
                        trigger: const SizedBox(
                          width: 100,
                          height: 30,
                          child: Text('Options'),
                        ),
                        items: [
                          VMenuItem(onTap: () {}, child: const Text('Edit')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final triggerRect = tester.getRect(find.byType(VMenu));
      await tester.tap(find.text('Options'));
      await tester.pump();
      await tester.pump();

      // The menu is anchored to the trigger's right (start) edge, so it
      // extends to the left of the trigger.
      final menuRect = tester.getRect(
        find.ancestor(
          of: find.text('Edit'),
          matching: find.byType(IntrinsicWidth),
        ),
      );
      expect(menuRect.right, triggerRect.right);
      expect(menuRect.left, lessThan(triggerRect.left));
    });
  });
}
