import 'package:flutter/material.dart' show Icons;
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
}
