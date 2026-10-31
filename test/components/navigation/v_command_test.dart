import 'package:flutter/services.dart';
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

  group('VCommand', () {
    testWidgets('default rendering', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand(
            children: [
              VCommandInput(),
              VCommandList(
                children: [
                  VCommandItem(value: 'test', child: Text('Test Item')),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.byType(VCommand), findsOneWidget);
    });

    testWidgets('VCommandInput rendering', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand(
            children: [
              VCommandInput(placeholder: 'Search...'),
              VCommandList(children: []),
            ],
          ),
        ),
      );

      expect(find.byType(VCommand), findsOneWidget);
    });

    testWidgets('VCommandItem rendering', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand(
            children: [
              VCommandInput(),
              VCommandList(
                children: [
                  VCommandItem(value: 'calendar', child: Text('Calendar')),
                  VCommandItem(value: 'settings', child: Text('Settings')),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('VCommandGroup rendering', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand(
            children: [
              VCommandInput(),
              VCommandList(
                children: [
                  VCommandGroup(
                    heading: 'Suggestions',
                    children: [
                      VCommandItem(value: 'calendar', child: Text('Calendar')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.text('Suggestions'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
    });

    testWidgets('VCommandItem selection callback', (tester) async {
      var selected = false;

      await tester.pumpWidget(
        buildTestWidget(
          VCommand(
            children: [
              const VCommandInput(),
              VCommandList(
                children: [
                  VCommandItem(
                    value: 'test',
                    onTap: () => selected = true,
                    child: const Text('Test'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Test'));
      await tester.pump();

      expect(selected, isTrue);
    });

    testWidgets('VCommandItem disabled state', (tester) async {
      var selected = false;

      await tester.pumpWidget(
        buildTestWidget(
          VCommand(
            children: [
              const VCommandInput(),
              VCommandList(
                children: [
                  VCommandItem(
                    value: 'test',
                    enabled: false,
                    onTap: () => selected = true,
                    child: const Text('Disabled'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      // Disabled item should not be visible in filtered list
      expect(find.text('Disabled'), findsNothing);
      expect(selected, isFalse);
    });

    testWidgets('VCommandShortcut rendering', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand(
            children: [
              VCommandInput(),
              VCommandList(
                children: [
                  VCommandItem(
                    value: 'test',
                    trailing: VCommandShortcut(keys: ['⌘', 'K']),
                    child: Text('Test'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.text('⌘'), findsOneWidget);
      expect(find.text('K'), findsOneWidget);
    });

    testWidgets('VCommandSeparator rendering', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand(
            children: [
              VCommandInput(),
              VCommandList(
                children: [
                  VCommandItem(value: 'item1', child: Text('Item 1')),
                  VCommandSeparator(),
                  VCommandItem(value: 'item2', child: Text('Item 2')),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('VCommandItem with leading', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand(
            children: [
              VCommandInput(),
              VCommandList(
                children: [
                  VCommandItem(
                    value: 'test',
                    leading: Text('🔍'),
                    child: Text('Search'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.text('🔍'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('loading state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand(
            loading: true,
            children: [
              VCommandInput(),
              VCommandList(children: []),
            ],
          ),
        ),
      );

      expect(find.byType(VCommand), findsOneWidget);
    });
  });

  group('VCommand.dialog', () {
    testWidgets('hidden when open=false', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand.dialog(
            children: [
              VCommandInput(),
              VCommandList(children: []),
            ],
          ),
        ),
      );

      // Dialog should be empty when closed
      expect(find.byType(VCommand), findsOneWidget);
    });

    testWidgets('shown when open=true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand.dialog(
            open: true,
            children: [
              VCommandInput(),
              VCommandList(
                children: [VCommandItem(value: 'test', child: Text('Test'))],
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('close by tapping background', (tester) async {
      var isOpen = true;

      await tester.pumpWidget(
        buildTestWidget(
          VCommand.dialog(
            open: isOpen,
            onOpenChanged: (open) => isOpen = open,
            children: const [
              VCommandInput(),
              VCommandList(children: []),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on overlay background
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();

      expect(isOpen, isFalse);
    });
  });

  group('VCommandEmpty', () {
    testWidgets('displays empty state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand(
            children: [
              VCommandInput(),
              VCommandList(
                children: [VCommandEmpty(child: Text('No results'))],
              ),
            ],
          ),
        ),
      );

      expect(find.text('No results'), findsOneWidget);
    });
  });

  group('VCommandItemData', () {
    test('default constructor', () {
      const data = VCommandItemData(
        value: 'test',
        keywords: ['keyword1', 'keyword2'],
      );

      expect(data.value, 'test');
      expect(data.keywords, ['keyword1', 'keyword2']);
      expect(data.enabled, true);
    });

    test('onTap callback', () {
      var called = false;
      final data = VCommandItemData(value: 'test', onTap: () => called = true);

      data.onTap?.call();
      expect(called, isTrue);
    });

    testWidgets('plain Text child takes the themed palette text style', (
      tester,
    ) async {
      final theme = VThemeData.light();
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand(
            children: [
              VCommandInput(),
              VCommandList(
                children: [VCommandItem(value: 'a', child: Text('Alpha'))],
              ),
            ],
          ),
        ),
      );

      final style = tester
          .widget<RichText>(
            find.descendant(
              of: find.text('Alpha'),
              matching: find.byType(RichText),
            ),
          )
          .text
          .style!;
      expect(style.fontSize, theme.typography.bodyMedium.fontSize);
      expect(style.color, theme.colors.foreground);
    });

    testWidgets('arrow keys move the highlight and Enter selects', (
      tester,
    ) async {
      final taps = <String>[];
      await tester.pumpWidget(
        buildTestWidget(
          VCommand(
            children: [
              const VCommandInput(),
              VCommandList(
                children: [
                  VCommandItem(
                    value: 'a',
                    onTap: () => taps.add('a'),
                    child: const Text('Alpha'),
                  ),
                  VCommandItem(
                    value: 'b',
                    onTap: () => taps.add('b'),
                    child: const Text('Beta'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(taps, ['b', 'a']);
    });

    testWidgets('Escape asks the dialog to close via onOpenChanged', (
      tester,
    ) async {
      bool? requested;
      await tester.pumpWidget(
        buildTestWidget(
          VCommand.dialog(
            open: true,
            onOpenChanged: (open) => requested = open,
            children: const [
              VCommandInput(),
              VCommandList(children: []),
            ],
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      expect(requested, isFalse);
    });

    testWidgets('disabled item is not run by Enter', (tester) async {
      var ran = false;
      await tester.pumpWidget(
        buildTestWidget(
          VCommand(
            children: [
              const VCommandInput(),
              VCommandList(
                children: [
                  VCommandItem(
                    value: 'a',
                    enabled: false,
                    onTap: () => ran = true,
                    child: const Text('Alpha'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(ran, isFalse);
    });

    testWidgets('placeholder shows while the field is empty', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand(
            placeholder: 'Search commands',
            children: [
              VCommandInput(),
              VCommandList(
                children: [VCommandItem(value: 'a', child: Text('Alpha'))],
              ),
            ],
          ),
        ),
      );
      expect(find.text('Search commands'), findsOneWidget);

      await tester.enterText(find.byType(EditableText), 'al');
      await tester.pump();

      expect(find.text('Search commands'), findsNothing);
    });

    testWidgets('VCommandInput.placeholder wins over VCommand.placeholder', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand(
            placeholder: 'Outer',
            children: [
              VCommandInput(placeholder: 'Inner'),
              VCommandList(children: []),
            ],
          ),
        ),
      );

      expect(find.text('Inner'), findsOneWidget);
      expect(find.text('Outer'), findsNothing);
    });
  });

  group('VCommand regressions', () {
    testWidgets('scrolls the highlighted row into view', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 400,
              height: 200,
              child: VCommand(
                children: [
                  const VCommandInput(),
                  VCommandList(
                    children: [
                      for (var i = 0; i < 30; i++)
                        VCommandItem(value: 'item $i', child: Text('Item $i')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      for (var i = 0; i < 20; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        await tester.pump();
      }
      await tester.pumpAndSettle();

      final top = tester.getTopLeft(find.text('Item 20')).dy;
      expect(top, inInclusiveRange(0, 200));
    });

    testWidgets('a disabled item stays hidden while searching', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand(
            children: [
              VCommandInput(),
              VCommandList(
                children: [
                  VCommandItem(value: 'alpha', child: Text('alpha')),
                  VCommandItem(
                    value: 'alpine',
                    enabled: false,
                    child: Text('alpine'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      await tester.pump();

      await tester.enterText(find.byType(EditableText), 'alp');
      await tester.pump();

      expect(find.text('alpha'), findsOneWidget);
      expect(find.text('alpine'), findsNothing);
    });

    testWidgets('holding an arrow key keeps moving the highlight', (
      tester,
    ) async {
      final chosen = <String>[];
      await tester.pumpWidget(
        buildTestWidget(
          VCommand(
            children: [
              const VCommandInput(),
              VCommandList(
                children: [
                  for (var i = 1; i <= 4; i++)
                    VCommandItem(
                      value: 'item$i',
                      onTap: () => chosen.add('item$i'),
                      child: Text('item$i'),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyRepeatEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyRepeatEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      expect(chosen, ['item4']);
    });

    testWidgets('the input falls back to the localized placeholder', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VCommand(
            children: [
              VCommandInput(),
              VCommandList(
                children: [VCommandItem(value: 'a', child: Text('a'))],
              ),
            ],
          ),
        ),
      );

      expect(find.text('Search...'), findsOneWidget);
    });
  });
}
