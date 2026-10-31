import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VAccordion', () {
    testWidgets('creates default accordion', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAccordion(
              children: [
                VAccordionItem(
                  title: Text('Section 1'),
                  content: Text('Content 1'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(VAccordion), findsOneWidget);
      expect(find.text('Section 1'), findsOneWidget);
    });

    testWidgets('multiple items', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAccordion(
              children: [
                VAccordionItem(
                  title: Text('Section 1'),
                  content: Text('Content 1'),
                ),
                VAccordionItem(
                  title: Text('Section 2'),
                  content: Text('Content 2'),
                ),
                VAccordionItem(
                  title: Text('Section 3'),
                  content: Text('Content 3'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Section 1'), findsOneWidget);
      expect(find.text('Section 2'), findsOneWidget);
      expect(find.text('Section 3'), findsOneWidget);
    });

    testWidgets('expands on tap', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAccordion(
              children: [
                VAccordionItem(
                  title: Text('Section 1'),
                  content: Text('Content 1'),
                ),
              ],
            ),
          ),
        ),
      );

      // Expands on tap
      await tester.tap(find.text('Section 1'));
      await tester.pumpAndSettle();

      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('only one opens when allowMultiple=false', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAccordion(
              children: [
                VAccordionItem(
                  title: Text('Section 1'),
                  content: Text('Content 1'),
                ),
                VAccordionItem(
                  title: Text('Section 2'),
                  content: Text('Content 2'),
                ),
              ],
            ),
          ),
        ),
      );

      // Tap first
      await tester.tap(find.text('Section 1'));
      await tester.pumpAndSettle();

      // Tap second - first closes
      await tester.tap(find.text('Section 2'));
      await tester.pumpAndSettle();

      expect(find.byType(VAccordion), findsOneWidget);
    });

    testWidgets('multiple open when allowMultiple=true', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAccordion(
              allowMultiple: true,
              children: [
                VAccordionItem(
                  title: Text('Section 1'),
                  content: Text('Content 1'),
                ),
                VAccordionItem(
                  title: Text('Section 2'),
                  content: Text('Content 2'),
                ),
              ],
            ),
          ),
        ),
      );

      // Tap first
      await tester.tap(find.text('Section 1'));
      await tester.pumpAndSettle();

      // Tap second - both open
      await tester.tap(find.text('Section 2'));
      await tester.pumpAndSettle();

      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Content 2'), findsOneWidget);
    });

    testWidgets('initialExpanded configuration', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAccordion(
              initialExpanded: [0],
              children: [
                VAccordionItem(
                  title: Text('Section 1'),
                  content: Text('Content 1'),
                ),
                VAccordionItem(
                  title: Text('Section 2'),
                  content: Text('Content 2'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('separated variant', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAccordion.separated(
              children: [
                VAccordionItem(
                  title: Text('Section 1'),
                  content: Text('Content 1'),
                ),
                VAccordionItem(
                  title: Text('Section 2'),
                  content: Text('Content 2'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(VAccordion), findsOneWidget);
    });

    testWidgets('bordered variant', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAccordion.bordered(
              children: [
                VAccordionItem(
                  title: Text('Section 1'),
                  content: Text('Content 1'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(VAccordion), findsOneWidget);
    });

    testWidgets('disabled item', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAccordion(
              children: [
                VAccordionItem(
                  title: Text('Disabled'),
                  content: Text('Content'),
                  enabled: false,
                ),
              ],
            ),
          ),
        ),
      );

      // Does not open on tap
      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();

      expect(find.byType(VAccordion), findsOneWidget);
    });

    testWidgets('onExpansionChanged reports the sorted expanded indices', (
      tester,
    ) async {
      final calls = <List<int>>[];
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VAccordion(
              allowMultiple: true,
              onExpansionChanged: calls.add,
              children: const [
                VAccordionItem(title: Text('A'), content: Text('a')),
                VAccordionItem(title: Text('B'), content: Text('b')),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();

      expect(calls, [
        [1],
        [0, 1],
        [0],
      ]);
    });

    testWidgets('disabled item does not call onExpansionChanged', (
      tester,
    ) async {
      var calls = 0;
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VAccordion(
              onExpansionChanged: (_) => calls++,
              children: const [
                VAccordionItem(
                  title: Text('Off'),
                  content: Text('hidden'),
                  enabled: false,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Off'));
      await tester.pumpAndSettle();

      expect(calls, 0);
    });

    testWidgets('displays subtitle', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAccordion(
              children: [
                VAccordionItem(
                  title: Text('Title'),
                  subtitle: Text('Subtitle'),
                  content: Text('Content'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
    });

    // ── FocusTraversalGroup ──────────────────────────────────────────

    testWidgets('wraps content in FocusTraversalGroup', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAccordion(
              children: [
                VAccordionItem(
                  title: Text('Section 1'),
                  content: Text('Content 1'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(VAccordion),
          matching: find.byType(FocusTraversalGroup),
        ),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('leading icon', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VAccordion(
              children: [
                VAccordionItem(
                  title: Text('Section'),
                  leading: Icon(Icons.help),
                  content: Text('Content'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Icon), findsWidgets);
    });

    group('theme override', () {
      testWidgets('theme componentOverrides applies to accordion', (
        tester,
      ) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VAccordionStyle(backgroundColor: Color(0xFFFF0000)),
              ]),
            ),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: VAccordion(
                children: [
                  VAccordionItem(
                    title: Text('Section 1'),
                    content: Text('Content 1'),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(VAccordion), findsOneWidget);
      });
    });
  });

  group('VAccordion state and keyboard', () {
    Widget host(VAccordion accordion) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SingleChildScrollView(child: accordion),
      ),
    );

    // Height factors of the content areas, in order: 1 is open, 0 is closed.
    List<double> factors(WidgetTester tester) => tester
        .widgetList<Align>(
          find.descendant(
            of: find.byType(VAccordion),
            matching: find.byType(Align),
          ),
        )
        .where((a) => a.heightFactor != null)
        .map((a) => a.heightFactor!)
        .toList();

    VAccordionItem item(String n, {Object? id, Widget? content}) =>
        VAccordionItem(
          id: id,
          title: Text('Section $n'),
          content: content ?? Text('Content $n'),
        );

    testWidgets('initialExpanded opens one item in single mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          VAccordion(
            initialExpanded: const [0, 1],
            children: [item('1'), item('2'), item('3')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(factors(tester), [1.0, 0.0, 0.0]);
    });

    testWidgets('initialExpanded keeps several items in multiple mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          VAccordion(
            allowMultiple: true,
            initialExpanded: const [0, 2, 9],
            children: [item('1'), item('2'), item('3')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(factors(tester), [1.0, 0.0, 1.0]);
    });

    testWidgets('expanded state follows the item id when items are removed', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          VAccordion(
            initialExpanded: const [0],
            children: [
              item('a', id: 'a'),
              item('b', id: 'b'),
              item('c', id: 'c'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(factors(tester), [1.0, 0.0, 0.0]);

      await tester.pumpWidget(
        host(
          VAccordion(
            initialExpanded: const [0],
            children: [
              item('b', id: 'b'),
              item('c', id: 'c'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(factors(tester), [0.0, 0.0]);
    });

    testWidgets('Enter and Space toggle a focused header', (tester) async {
      await tester.pumpWidget(host(VAccordion(children: [item('1')])));
      Focus.of(tester.element(find.text('Section 1'))).requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(factors(tester), [1.0]);

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(factors(tester), [0.0]);
    });

    testWidgets('collapsed content cannot take focus', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        host(
          VAccordion(
            children: [
              item(
                '1',
                content: Focus(focusNode: node, child: const Text('Inner')),
              ),
            ],
          ),
        ),
      );

      node.requestFocus();
      await tester.pump();

      expect(node.hasFocus, isFalse);
    });
  });
}
