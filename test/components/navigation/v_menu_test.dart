import 'dart:ui' show Tristate;

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

  group('VMenuController', () {
    late VMenuController controller;
    setUp(() => controller = VMenuController());
    tearDown(() => controller.dispose());

    Widget menu({VMenuController? using, Key? key}) => VMenu(
      key: key,
      controller: using ?? controller,
      trigger: const Text('Menu'),
      items: [VMenuItem(child: const Text('Edit'), onTap: () {})],
    );

    testWidgets('show and hide open and close the menu', (tester) async {
      await tester.pumpWidget(buildTestWidget(menu()));
      expect(find.text('Edit'), findsNothing);

      controller.show();
      await tester.pump();
      expect(find.text('Edit'), findsOneWidget);
      expect(controller.isOpen, isTrue);

      controller.hide();
      await tester.pump();
      expect(find.text('Edit'), findsNothing);

      controller.toggle();
      await tester.pump();
      expect(find.text('Edit'), findsOneWidget);
      controller.toggle();
      await tester.pump();
      expect(find.text('Edit'), findsNothing);
    });

    testWidgets('the trigger announces the state the controller sets', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(buildTestWidget(menu()));
      SemanticsData trigger() =>
          tester.getSemantics(find.text('Menu')).getSemanticsData();
      expect(trigger().flagsCollection.isExpanded, Tristate.isFalse);

      controller.show();
      await tester.pump();
      expect(trigger().flagsCollection.isExpanded, Tristate.isTrue);
      handle.dispose();
    });

    testWidgets('taps, items, Escape and the backdrop update it', (
      tester,
    ) async {
      final heard = <bool>[];
      controller.addListener(() => heard.add(controller.isOpen));
      await tester.pumpWidget(buildTestWidget(menu()));

      await tester.tap(find.text('Menu'));
      await tester.pump();
      expect(controller.isOpen, isTrue);
      await tester.tap(find.text('Edit'));
      await tester.pump();
      expect(controller.isOpen, isFalse);

      await tester.tap(find.text('Menu'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(controller.isOpen, isFalse);

      await tester.tap(find.text('Menu'));
      await tester.pump();
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      expect(controller.isOpen, isFalse);
      expect(find.text('Edit'), findsNothing);

      expect(heard, [true, false, true, false, true, false]);
    });

    testWidgets('a controller opened before the menu opens it after a frame', (
      tester,
    ) async {
      controller.show();
      await tester.pumpWidget(buildTestWidget(menu()));
      expect(tester.takeException(), isNull);
      await tester.pump();

      expect(find.text('Edit'), findsOneWidget);
    });

    testWidgets('show during a build waits for the frame', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) {
              controller.show();
              return menu();
            },
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      await tester.pump();

      expect(find.text('Edit'), findsOneWidget);
    });

    // The shared host keeps its first overlay entry, so this one swaps the
    // child through a notifier instead.
    Future<ValueNotifier<Widget>> host(
      WidgetTester tester,
      Widget first,
    ) async {
      final child = ValueNotifier<Widget>(first);
      addTearDown(child.dispose);
      await tester.pumpWidget(
        buildTestWidget(
          ValueListenableBuilder<Widget>(
            valueListenable: child,
            builder: (_, value, _) => value,
          ),
        ),
      );
      return child;
    }

    testWidgets('a menu removed while open leaves the controller closed', (
      tester,
    ) async {
      final child = await host(tester, menu(key: const Key('a')));
      controller.show();
      await tester.pump();
      expect(find.text('Edit'), findsOneWidget);

      child.value = const SizedBox();
      await tester.pump();
      // The entry removed while the menu unmounts leaves on the next frame.
      await tester.pump();
      expect(controller.isOpen, isFalse);
      expect(find.text('Edit'), findsNothing);

      // The controller can open the next menu it drives.
      child.value = menu(key: const Key('b'));
      await tester.pump();
      controller.show();
      await tester.pump();
      expect(find.text('Edit'), findsOneWidget);
    });

    testWidgets('a new controller takes over', (tester) async {
      final other = VMenuController();
      addTearDown(other.dispose);
      final child = await host(tester, menu());
      controller.show();
      await tester.pump();

      child.value = menu(using: other);
      await tester.pump();
      await tester.pump();
      expect(find.text('Edit'), findsNothing);
      expect(controller.isOpen, isFalse);

      controller.show();
      await tester.pump();
      expect(find.text('Edit'), findsNothing);

      other.show();
      await tester.pump();
      expect(find.text('Edit'), findsOneWidget);
    });

    testWidgets('keys reach the menu after Enter or a reopen', (tester) async {
      var edits = 0;
      await tester.pumpWidget(
        buildTestWidget(
          VMenu(
            controller: controller,
            trigger: const Text('Menu'),
            items: [VMenuItem(child: const Text('Edit'), onTap: () => edits++)],
          ),
        ),
      );

      // Open from the focused trigger, then pick the item with keys.
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
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(edits, 1);
      expect(controller.isOpen, isFalse);

      // Reopened by tap, Escape still closes it.
      await tester.tap(find.text('Menu'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Edit'), findsNothing);
      expect(controller.isOpen, isFalse);
    });
  });

  group('VMenuStyle panel', () {
    BoxDecoration panelOf(WidgetTester tester) {
      final container = tester.widget<Container>(
        find
            .ancestor(of: find.text('Edit'), matching: find.byType(Container))
            .last,
      );
      return container.decoration! as BoxDecoration;
    }

    Future<void> open(WidgetTester tester, {VMenuStyle? style}) async {
      await tester.pumpWidget(
        buildTestWidget(
          VMenu(
            style: style,
            trigger: const Text('Menu'),
            items: [VMenuItem(child: const Text('Edit'), onTap: () {})],
          ),
        ),
      );
      await tester.tap(find.text('Menu'));
      await tester.pump();
    }

    testWidgets('defaults to 180 wide, a 1px border and the large shadow', (
      tester,
    ) async {
      await open(tester);

      final panel = panelOf(tester);
      expect((panel.border! as Border).top.width, 1);
      expect(panel.boxShadow, VThemeData.light().shadows.lg);
      expect(
        tester
            .getSize(
              find
                  .ancestor(
                    of: find.text('Edit'),
                    matching: find.byType(Container),
                  )
                  .last,
            )
            .width,
        greaterThanOrEqualTo(180),
      );
    });

    testWidgets('style sets the minimum width, border width and shadows', (
      tester,
    ) async {
      const shadow = BoxShadow(blurRadius: 3);
      await open(
        tester,
        style: const VMenuStyle(
          minWidth: 320,
          borderWidth: 2,
          shadows: [shadow],
        ),
      );

      final panel = panelOf(tester);
      expect((panel.border! as Border).top.width, 2);
      expect(panel.boxShadow, [shadow]);
      expect(
        tester
            .getSize(
              find
                  .ancestor(
                    of: find.text('Edit'),
                    matching: find.byType(Container),
                  )
                  .last,
            )
            .width,
        greaterThanOrEqualTo(320),
      );
    });

    testWidgets('an empty shadow list draws no shadow', (tester) async {
      await open(tester, style: const VMenuStyle(shadows: []));

      expect(panelOf(tester).boxShadow, isEmpty);
    });

    testWidgets('a theme override applies and an instance style wins', (
      tester,
    ) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light().copyWith(
            componentOverrides: const VComponentOverrides([
              VMenuStyle(borderWidth: 3, minWidth: 240),
            ]),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(800, 800)),
              child: Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (_) => Align(
                      alignment: Alignment.topCenter,
                      child: VMenu(
                        style: const VMenuStyle(borderWidth: 2),
                        trigger: const Text('Menu'),
                        items: [
                          VMenuItem(child: const Text('Edit'), onTap: () {}),
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
      await tester.tap(find.text('Menu'));
      await tester.pump();

      expect((panelOf(tester).border! as Border).top.width, 2);
      final panel = find
          .ancestor(of: find.text('Edit'), matching: find.byType(Container))
          .last;
      expect(tester.getSize(panel).width, greaterThanOrEqualTo(240));
    });
  });
}
