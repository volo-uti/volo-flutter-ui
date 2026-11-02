import 'dart:ui' show Tristate;

import 'package:flutter/material.dart' show Icons;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VChip', () {
    testWidgets('creates default chip', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VChip(label: Text('Tag')),
          ),
        ),
      );

      expect(find.byType(VChip), findsOneWidget);
      expect(find.text('Tag'), findsOneWidget);
    });

    testWidgets('outlined chip', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VChip.outlined(label: Text('Outlined')),
          ),
        ),
      );

      expect(find.byType(VChip), findsOneWidget);
    });

    testWidgets('filter chip selection state change', (tester) async {
      var selected = false;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => VTheme(
            data: VThemeData.light(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VChip.filter(
                label: const Text('Filter'),
                selected: selected,
                onSelected: (value) {
                  setState(() => selected = value);
                },
              ),
            ),
          ),
        ),
      );

      expect(selected, isFalse);
      await tester.tap(find.byType(VChip));
      await tester.pump();
      expect(selected, isTrue);
    });

    testWidgets('input chip delete callback', (tester) async {
      var deleted = false;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VChip.input(
              label: const Text('Deletable'),
              onDeleted: () => deleted = true,
            ),
          ),
        ),
      );

      // Tap the delete button (close icon)
      await tester.tap(find.bySemanticsLabel('Delete'));
      expect(deleted, isTrue);
    });

    testWidgets('disabled state', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VChip(
              label: const Text('Disabled'),
              enabled: false,
              onTap: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VChip));
      expect(pressed, isFalse);
    });

    testWidgets('tap callback fires when enabled', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VChip(label: const Text('Tap'), onTap: () => taps++),
          ),
        ),
      );

      await tester.tap(find.byType(VChip));
      expect(taps, 1);
    });

    testWidgets('disabled filter chip does not select', (tester) async {
      var changed = false;

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VChip.filter(
              label: const Text('Filter'),
              enabled: false,
              onSelected: (_) => changed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VChip));
      expect(changed, isFalse);
    });

    testWidgets('disabled input chip hides the delete action', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VChip.input(
              label: const Text('Deletable'),
              enabled: false,
              onDeleted: () {},
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Delete'), findsNothing);
    });

    testWidgets('leading icon', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VChip(label: Text('Icon'), leading: Icon(Icons.person)),
          ),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('renders with each size', (tester) async {
      for (final size in VChipSize.values) {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VChip(label: const Text('Test'), size: size),
            ),
          ),
        );

        expect(find.byType(VChip), findsOneWidget);
      }
    });
  });

  group('VChipGroup', () {
    testWidgets('creates default group', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: VChipGroup<String>(
              items: [
                VChipItem(value: 'a', label: Text('A')),
                VChipItem(value: 'b', label: Text('B')),
                VChipItem(value: 'c', label: Text('C')),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(VChipGroup<String>), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('multiple selection', (tester) async {
      var selected = <String>[];

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => VTheme(
            data: VThemeData.light(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VChipGroup<String>(
                values: selected,
                onChanged: (values) {
                  setState(() => selected = values);
                },
                items: const [
                  VChipItem(value: 'a', label: Text('A')),
                  VChipItem(value: 'b', label: Text('B')),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('A'));
      await tester.pump();
      expect(selected, contains('a'));

      await tester.tap(find.text('B'));
      await tester.pump();
      expect(selected, contains('b'));
      expect(selected.length, 2);
    });

    testWidgets('single selection', (tester) async {
      var selected = <String>[];

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => VTheme(
            data: VThemeData.light(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VChipGroup<String>(
                values: selected,
                allowMultiple: false,
                onChanged: (values) {
                  setState(() => selected = values);
                },
                items: const [
                  VChipItem(value: 'a', label: Text('A')),
                  VChipItem(value: 'b', label: Text('B')),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('A'));
      await tester.pump();
      expect(selected, ['a']);

      await tester.tap(find.text('B'));
      await tester.pump();
      expect(selected, ['b']);
    });
  });

  group('keyboard activation', () {
    testWidgets('Enter and Space press a focused chip', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: VChip(label: const Text('Tag'), onTap: () => taps++),
            ),
          ),
        ),
      );
      Focus.of(tester.element(find.text('Tag'))).requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);

      expect(taps, 2);
    });
  });

  group('VChip large text', () {
    testWidgets('a two-line label grows the chip at 2x text and 320 wide', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(320, 640)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQueryData(
                size: Size(320, 640),
                textScaler: TextScaler.linear(2),
              ),
              child: Center(
                child: VChip(label: Text('Long chip label', maxLines: 2)),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final paragraph = tester.renderObject<RenderParagraph>(
        find.text('Long chip label'),
      );
      expect(paragraph.didExceedMaxLines, isFalse);
      // The label gets the height its two lines need, so nothing is clipped.
      expect(
        paragraph.size.height,
        moreOrLessEquals(paragraph.getMaxIntrinsicHeight(paragraph.size.width)),
      );
      final chip = tester.getRect(find.byType(VChip));
      final text = tester.getRect(find.text('Long chip label'));
      // Two lines of text no longer fit in the 32px md preset.
      expect(text.height, greaterThan(32));
      expect(chip.top, lessThanOrEqualTo(text.top));
      expect(chip.bottom, greaterThanOrEqualTo(text.bottom));
    });

    testWidgets('a label without maxLines stays on one line', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 120,
                child: VChip(label: Text('A label far too long for the chip')),
              ),
            ),
          ),
        ),
      );

      final paragraph = tester.renderObject<RenderParagraph>(
        find.text('A label far too long for the chip'),
      );
      expect(paragraph.didExceedMaxLines, isTrue);
      expect(tester.getSize(find.byType(VChip)).height, 32);
    });
  });

  group('VChip without callbacks', () {
    Widget frame(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: child),
      ),
    );

    testWidgets('has no tap action or button flag and is not dimmed', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(frame(const VChip(label: Text('Tag'))));

      final data = tester.getSemantics(find.text('Tag')).getSemanticsData();
      expect(data.label, 'Tag');
      expect(data.flagsCollection.isButton, isFalse);
      expect(data.flagsCollection.isFocused, Tristate.none);
      expect(data.hasAction(SemanticsAction.tap), isFalse);
      expect(
        find.descendant(of: find.byType(VChip), matching: find.byType(Focus)),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byType(VChip),
          matching: find.byType(GestureDetector),
        ),
        findsNothing,
      );
      final opacity = tester.widget<Opacity>(
        find.descendant(of: find.byType(VChip), matching: find.byType(Opacity)),
      );
      expect(opacity.opacity, 1.0);
      handle.dispose();
    });

    testWidgets('a filter chip shows its selection without a button', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        frame(const VChip.filter(label: Text('Dart'), selected: true)),
      );

      final data = tester.getSemantics(find.text('Dart')).getSemanticsData();
      expect(data.flagsCollection.isButton, isFalse);
      expect(data.flagsCollection.isToggled, Tristate.none);
      expect(data.flagsCollection.isSelected, Tristate.isTrue);
      expect(data.hasAction(SemanticsAction.tap), isFalse);
      handle.dispose();
    });

    testWidgets('a group without onChanged holds inert chips', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        frame(
          const VChipGroup<String>(
            items: [VChipItem(value: 'a', label: Text('A'))],
            values: ['a'],
          ),
        ),
      );

      final data = tester.getSemantics(find.text('A')).getSemanticsData();
      expect(data.flagsCollection.isButton, isFalse);
      expect(data.hasAction(SemanticsAction.tap), isFalse);
      handle.dispose();
    });

    testWidgets('a chip with a callback stays a focusable button', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var taps = 0;
      await tester.pumpWidget(
        frame(VChip(label: const Text('Tag'), onTap: () => taps++)),
      );

      final data = tester.getSemantics(find.text('Tag')).getSemanticsData();
      expect(data.flagsCollection.isButton, isTrue);
      expect(data.flagsCollection.isEnabled, Tristate.isTrue);
      expect(data.hasAction(SemanticsAction.tap), isTrue);
      expect(
        find.descendant(of: find.byType(VChip), matching: find.byType(Focus)),
        findsOneWidget,
      );
      await tester.tap(find.byType(VChip));
      expect(taps, 1);
      handle.dispose();
    });

    testWidgets('a filter chip with onSelected stays a toggle button', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        frame(
          VChip.filter(
            label: const Text('Dart'),
            selected: true,
            onSelected: (_) {},
          ),
        ),
      );

      final data = tester.getSemantics(find.text('Dart')).getSemanticsData();
      expect(data.flagsCollection.isButton, isTrue);
      expect(data.flagsCollection.isToggled, Tristate.isTrue);
      expect(data.hasAction(SemanticsAction.tap), isTrue);
      handle.dispose();
    });

    testWidgets('an input chip with onDeleted stays a button', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        frame(VChip.input(label: const Text('Value'), onDeleted: () {})),
      );

      final data = tester.getSemantics(find.text('Value')).getSemanticsData();
      expect(data.flagsCollection.isButton, isTrue);
      expect(find.bySemanticsLabel('Delete'), findsOneWidget);
      handle.dispose();
    });
  });

  group('VChipStyle.textStyle', () {
    testWidgets('lays over the defaults from the theme or the instance', (
      tester,
    ) async {
      TextStyle labelOf(String text) =>
          tester.renderObject<RenderParagraph>(find.text(text)).text.style!;
      const red = Color(0xFFFF0000);
      const green = Color(0xFF00FF00);
      final light = VThemeData.light();

      await tester.pumpWidget(
        VTheme(
          data: light.copyWith(
            componentOverrides: const VComponentOverrides([
              VChipStyle(
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ]),
          ),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              children: [
                VChip(label: Text('Theme')),
                VChip(
                  label: Text('Instance'),
                  style: VChipStyle(textStyle: TextStyle(color: red)),
                ),
                VChip(
                  label: Text('Foreground'),
                  style: VChipStyle(
                    foregroundColor: green,
                    textStyle: TextStyle(color: red, letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // The theme's text style changes size and weight; the rest stays.
      final theme = labelOf('Theme');
      expect(theme.fontSize, 20);
      expect(theme.fontWeight, FontWeight.w700);
      expect(theme.height, 1.15);
      expect(theme.color, light.colors.foreground);

      // An instance text style replaces the theme's and keeps the defaults.
      final instance = labelOf('Instance');
      expect(instance.color, red);
      expect(instance.fontSize, light.sizes.sm.fontSize);
      expect(instance.fontWeight, isNull);

      // foregroundColor wins over the text style color.
      final foreground = labelOf('Foreground');
      expect(foreground.color, green);
      expect(foreground.letterSpacing, 1);
    });
  });
}
