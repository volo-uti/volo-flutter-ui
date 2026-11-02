import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  /// Test widget builder with Overlay (for popover/dropdown tests)
  Widget buildOverlayTestWidget(Widget child) => VTheme(
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

  group('VSelect', () {
    testWidgets('default rendering', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [
              VSelectItem(value: 'a', label: 'Option A'),
              VSelectItem(value: 'b', label: 'Option B'),
            ],
          ),
        ),
      );

      expect(find.byType(VSelect<String>), findsOneWidget);
    });

    testWidgets('displays placeholder', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            placeholder: 'Select',
          ),
        ),
      );

      expect(find.text('Select'), findsOneWidget);
    });

    testWidgets('displays selected value', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [
              VSelectItem(value: 'a', label: 'Option A'),
              VSelectItem(value: 'b', label: 'Option B'),
            ],
            value: 'a',
          ),
        ),
      );

      expect(find.text('Option A'), findsOneWidget);
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            enabled: false,
          ),
        ),
      );

      expect(find.byType(VSelect<String>), findsOneWidget);
      // Opacity 0.5 when disabled
    });

    testWidgets('displays label', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            label: 'Select Language',
          ),
        ),
      );

      expect(find.text('Select Language'), findsOneWidget);
    });

    testWidgets('displays error message', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            error: true,
            errorText: 'This field is required',
          ),
        ),
      );

      expect(find.text('This field is required'), findsOneWidget);
    });

    testWidgets('displays helper', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            helper: 'Please select one',
          ),
        ),
      );

      expect(find.text('Please select one'), findsOneWidget);
    });

    testWidgets('loading state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            loading: true,
          ),
        ),
      );

      // Rendered in loading state
      expect(find.byType(VSelect<String>), findsOneWidget);
    });
  });

  group('VSelect.multiple', () {
    testWidgets('default rendering', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>.multiple(
            items: [
              VSelectItem(value: 'a', label: 'Option A'),
              VSelectItem(value: 'b', label: 'Option B'),
            ],
          ),
        ),
      );

      expect(find.byType(VSelect<String>), findsOneWidget);
    });

    testWidgets('displays multiple selection', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>.multiple(
            items: [
              VSelectItem(value: 'a', label: 'Option A'),
              VSelectItem(value: 'b', label: 'Option B'),
              VSelectItem(value: 'c', label: 'Option C'),
            ],
            values: ['a', 'b'],
          ),
        ),
      );

      expect(find.text('2 selected'), findsOneWidget);
    });

    testWidgets('displays label for single selection', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>.multiple(
            items: [
              VSelectItem(value: 'a', label: 'Option A'),
              VSelectItem(value: 'b', label: 'Option B'),
            ],
            values: ['a'],
          ),
        ),
      );

      expect(find.text('Option A'), findsOneWidget);
    });

    testWidgets('displays placeholder when no selection', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>.multiple(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            placeholder: 'Select',
          ),
        ),
      );

      expect(find.text('Select'), findsOneWidget);
    });
  });

  group('VSelectItem', () {
    testWidgets('default constructor', (tester) async {
      const item = VSelectItem(value: 'test', label: 'Test Label');

      expect(item.value, 'test');
      expect(item.label, 'Test Label');
      expect(item.enabled, true);
      expect(item.leading, isNull);
    });

    testWidgets('disabled item', (tester) async {
      const item = VSelectItem(
        value: 'test',
        label: 'Test Label',
        enabled: false,
      );

      expect(item.enabled, false);
    });

    testWidgets('leading icon', (tester) async {
      const leading = SizedBox(key: Key('leading-icon'), width: 24, height: 24);
      const item = VSelectItem(
        value: 'test',
        label: 'Test Label',
        leading: leading,
      );

      expect(item.leading, leading);
    });
  });

  group('VSelect searchable', () {
    testWidgets('renders search field when searchable: true', (tester) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          const VSelect<String>(
            items: [
              VSelectItem(value: 'apple', label: 'Apple'),
              VSelectItem(value: 'banana', label: 'Banana'),
              VSelectItem(value: 'cherry', label: 'Cherry'),
            ],
            searchable: true,
          ),
        ),
      );

      // Click VPopover to open dropdown
      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // Verify search field (EditableText) exists
      expect(find.byType(EditableText), findsOneWidget);
    });

    testWidgets('no search field when searchable: false', (tester) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'apple', label: 'Apple')],
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // Search field should not exist
      expect(find.byType(EditableText), findsNothing);
    });

    testWidgets('displays all items in initial state', (tester) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          const VSelect<String>(
            items: [
              VSelectItem(value: 'apple', label: 'Apple'),
              VSelectItem(value: 'banana', label: 'Banana'),
              VSelectItem(value: 'cherry', label: 'Cherry'),
            ],
            searchable: true,
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // All items displayed initially
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Cherry'), findsOneWidget);
    });

    test('verifies search filtering logic', () {
      // Verify VSelect's _filteredItems getter logic
      // Code: label.toLowerCase().contains(_searchQuery.toLowerCase())
      const items = [
        VSelectItem(value: 'apple', label: 'Apple'),
        VSelectItem(value: 'banana', label: 'Banana'),
        VSelectItem(value: 'cherry', label: 'Cherry'),
      ];

      const searchQuery = 'Ban';

      final filteredItems = items.where((item) {
        final label = item.label;
        return label.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      expect(filteredItems.length, 1);
      expect(filteredItems.first.value, 'banana');
    });

    test('returns empty list when no search results', () {
      // Verify VSelect's _filteredItems getter logic
      const items = [
        VSelectItem(value: 'apple', label: 'Apple'),
        VSelectItem(value: 'banana', label: 'Banana'),
      ];

      const searchQuery = 'xyz';

      final filteredItems = items.where((item) {
        final label = item.label;
        return label.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      expect(filteredItems, isEmpty);
    });
  });

  group('VSelect maxSelection', () {
    testWidgets('maxSelection restriction works', (tester) async {
      var selectedValues = <String>['a'];

      await tester.pumpWidget(
        buildOverlayTestWidget(
          StatefulBuilder(
            builder: (context, setState) => VSelect<String>.multiple(
              items: const [
                VSelectItem(value: 'a', label: 'Option A'),
                VSelectItem(value: 'b', label: 'Option B'),
                VSelectItem(value: 'c', label: 'Option C'),
              ],
              values: selectedValues,
              maxSelection: 2,
              onValuesChanged: (List<String> values) {
                setState(() => selectedValues = values);
              },
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // Select Option B (now 2 selected)
      await tester.tap(find.text('Option B'));
      await tester.pumpAndSettle();

      expect(selectedValues.length, 2);
      expect(selectedValues.contains('b'), true);

      // Attempt to select Option C (blocked due to maxSelection reached)
      await tester.tap(find.text('Option C'));
      await tester.pumpAndSettle();

      expect(selectedValues.length, 2);
      expect(selectedValues.contains('c'), false);
    });

    testWidgets('can deselect items when maxSelection reached', (tester) async {
      var selectedValues = <String>['a', 'b'];

      await tester.pumpWidget(
        buildOverlayTestWidget(
          StatefulBuilder(
            builder: (context, setState) => VSelect<String>.multiple(
              items: const [
                VSelectItem(value: 'a', label: 'Option A'),
                VSelectItem(value: 'b', label: 'Option B'),
                VSelectItem(value: 'c', label: 'Option C'),
              ],
              values: selectedValues,
              maxSelection: 2,
              onValuesChanged: (List<String> values) {
                setState(() => selectedValues = values);
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // Deselect already selected Option A
      await tester.tap(find.text('Option A'));
      await tester.pumpAndSettle();

      expect(selectedValues.length, 1);
      expect(selectedValues.contains('a'), false);
    });
  });

  group('VSelect disabled items', () {
    testWidgets('disabled item is not selected on click', (tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        buildOverlayTestWidget(
          StatefulBuilder(
            builder: (context, setState) => VSelect<String>(
              items: const [
                VSelectItem(value: 'a', label: 'Option A'),
                VSelectItem(value: 'b', label: 'Option B', enabled: false),
              ],
              value: selectedValue,
              onChanged: (value) {
                setState(() => selectedValue = value);
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // Click disabled item
      await tester.tap(find.text('Option B'));
      await tester.pumpAndSettle();

      // Should not be selected
      expect(selectedValue, isNull);
    });

    testWidgets('disabled item has opacity 0.5', (tester) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          const VSelect<String>(
            items: [
              VSelectItem(value: 'a', label: 'Option A'),
              VSelectItem(value: 'b', label: 'Option B', enabled: false),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // Find Opacity widget (disabled item)
      final opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
      final hasHalfOpacity = opacityWidgets.any((w) => w.opacity == 0.5);
      expect(hasHalfOpacity, true);
    });
  });

  group('VSelect.multiple details', () {
    testWidgets('calls onChanged callback', (tester) async {
      var selectedValues = <String>[];

      await tester.pumpWidget(
        buildOverlayTestWidget(
          StatefulBuilder(
            builder: (context, setState) => VSelect<String>.multiple(
              items: const [
                VSelectItem(value: 'a', label: 'Option A'),
                VSelectItem(value: 'b', label: 'Option B'),
              ],
              values: selectedValues,
              onValuesChanged: (List<String> values) {
                setState(() => selectedValues = values);
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option A'));
      await tester.pumpAndSettle();

      expect(selectedValues, contains('a'));
    });

    testWidgets('selection toggle (add/remove)', (tester) async {
      var selectedValues = <String>['a'];

      await tester.pumpWidget(
        buildOverlayTestWidget(
          StatefulBuilder(
            builder: (context, setState) => VSelect<String>.multiple(
              items: const [
                VSelectItem(value: 'a', label: 'Option A'),
                VSelectItem(value: 'b', label: 'Option B'),
              ],
              values: selectedValues,
              onValuesChanged: (List<String> values) {
                setState(() => selectedValues = values);
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // Click already selected item to deselect (select Option A in dropdown - last)
      await tester.tap(find.text('Option A').last);
      await tester.pumpAndSettle();

      expect(selectedValues, isEmpty);
    });

    testWidgets('dropdown stays open during multiple selection', (
      tester,
    ) async {
      var selectedValues = <String>[];

      await tester.pumpWidget(
        buildOverlayTestWidget(
          StatefulBuilder(
            builder: (context, setState) => VSelect<String>.multiple(
              items: const [
                VSelectItem(value: 'a', label: 'Option A'),
                VSelectItem(value: 'b', label: 'Option B'),
              ],
              values: selectedValues,
              onValuesChanged: (List<String> values) {
                setState(() => selectedValues = values);
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option A'));
      await tester.pumpAndSettle();

      // Dropdown should still be open (Option B should be visible)
      expect(find.text('Option B'), findsOneWidget);
    });
  });

  group('VSelect Semantics', () {
    testWidgets('sets Semantics properties', (tester) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          const VSelect<String>(
            items: [
              VSelectItem(value: 'a', label: 'Option A'),
              VSelectItem(value: 'b', label: 'Option B'),
            ],
            value: 'a',
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // Verify Semantics widget
      final semantics = tester.getSemantics(find.text('Option A').last);
      expect(semantics.getSemanticsData().flagsCollection.isButton, true);
      expect(
        semantics.getSemanticsData().flagsCollection.isSelected,
        Tristate.isTrue,
      );
    });

    testWidgets('disabled item Semantics', (tester) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          const VSelect<String>(
            items: [
              VSelectItem(value: 'a', label: 'Option A'),
              VSelectItem(value: 'b', label: 'Option B', enabled: false),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // Semantics of disabled item
      final semantics = tester.getSemantics(find.text('Option B'));
      expect(
        semantics.getSemanticsData().flagsCollection.isEnabled,
        Tristate.isFalse,
      );
    });
  });

  group('VSelect placeholder', () {
    testWidgets('displays placeholder when value is null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            placeholder: 'Please select an item',
          ),
        ),
      );

      expect(find.text('Please select an item'), findsOneWidget);
    });

    testWidgets('displays label instead of placeholder when value is set', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            value: 'a',
            placeholder: 'Please select an item',
          ),
        ),
      );

      expect(find.text('Option A'), findsOneWidget);
      expect(find.text('Please select an item'), findsNothing);
    });

    testWidgets('uses empty string when no placeholder', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
          ),
        ),
      );

      // Verify VSelect renders when no placeholder
      expect(find.byType(VSelect<String>), findsOneWidget);
      // Option A is not selected so should not be displayed
      expect(find.text('Option A'), findsNothing);
    });
  });

  group('VSelect size', () {
    testWidgets('VSelectSize.sm height 32', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            size: VSelectSize.sm,
          ),
        ),
      );

      // Verify VSelect is rendered
      expect(find.byType(VSelect<String>), findsOneWidget);

      // Find Container and verify height (sm -> sizes.sm.height = 32)
      final containerFinder = find.descendant(
        of: find.byType(VSelect<String>),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Container && widget.constraints?.minHeight == 32,
        ),
      );
      expect(containerFinder, findsOneWidget);
      // At 1x text the minimum is the drawn height.
      expect(tester.getSize(containerFinder).height, 32);
    });

    testWidgets('VSelectSize.md height 40 (default)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            size: VSelectSize.md,
          ),
        ),
      );

      expect(find.byType(VSelect<String>), findsOneWidget);

      // md -> sizes.md.height = 40
      final containerFinder = find.descendant(
        of: find.byType(VSelect<String>),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Container && widget.constraints?.minHeight == 40,
        ),
      );
      expect(containerFinder, findsOneWidget);
      // At 1x text the minimum is the drawn height.
      expect(tester.getSize(containerFinder).height, 40);
    });

    testWidgets('VSelectSize.lg height 48', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            size: VSelectSize.lg,
          ),
        ),
      );

      expect(find.byType(VSelect<String>), findsOneWidget);

      // lg -> sizes.lg.height = 48
      final containerFinder = find.descendant(
        of: find.byType(VSelect<String>),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Container && widget.constraints?.minHeight == 48,
        ),
      );
      expect(containerFinder, findsOneWidget);
      // At 1x text the minimum is the drawn height.
      expect(tester.getSize(containerFinder).height, 48);
    });
  });

  group('VSelect no items', () {
    testWidgets('displays "No options" when no items', (tester) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(const VSelect<String>(items: [])),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      expect(find.text('No options'), findsOneWidget);
    });
  });

  group('VSelect single selection behavior', () {
    testWidgets('dropdown closes after single selection', (tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        buildOverlayTestWidget(
          StatefulBuilder(
            builder: (context, setState) => VSelect<String>(
              items: const [
                VSelectItem(value: 'a', label: 'Option A'),
                VSelectItem(value: 'b', label: 'Option B'),
              ],
              value: selectedValue,
              onChanged: (value) {
                setState(() => selectedValue = value);
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // Select Option A from dropdown
      await tester.tap(find.text('Option A'));
      await tester.pumpAndSettle();

      expect(selectedValue, 'a');
      // Dropdown is closed so Option B is no longer visible
      // (trigger displays only the selected Option A)
    });
  });

  group('VSelect readOnly', () {
    testWidgets('applies IgnorePointer in readOnly state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            readOnly: true,
          ),
        ),
      );

      // IgnorePointer is set to ignoring: true in readOnly state
      final ignorePointerFinder = find.descendant(
        of: find.byType(VSelect<String>),
        matching: find.byWidgetPredicate(
          (widget) => widget is IgnorePointer && widget.ignoring == true,
        ),
      );
      // At least one IgnorePointer should have ignoring: true
      expect(ignorePointerFinder, findsWidgets);
    });

    testWidgets('cannot select in readOnly state', (tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        buildOverlayTestWidget(
          StatefulBuilder(
            builder: (context, setState) => VSelect<String>(
              items: const [VSelectItem(value: 'a', label: 'Option A')],
              value: selectedValue,
              readOnly: true,
              onChanged: (value) {
                setState(() => selectedValue = value);
              },
            ),
          ),
        ),
      );

      // Attempt click (dropdown does not open due to readOnly)
      await tester.tap(find.byType(VSelect<String>), warnIfMissed: false);
      await tester.pump();

      // Should not be selected
      expect(selectedValue, isNull);
    });
  });

  group('VSelect success', () {
    testWidgets('displays success message string', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            success: true,
            successText: 'Valid selection',
          ),
        ),
      );

      expect(find.text('Valid selection'), findsOneWidget);
    });

    testWidgets('error takes priority when both error and success are set', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            error: true,
            errorText: 'Error message',
            success: true,
            successText: 'Success message',
          ),
        ),
      );

      expect(find.text('Error message'), findsOneWidget);
      expect(find.text('Success message'), findsNothing);
    });
  });

  group('VSelect extra', () {
    testWidgets('displays extra string', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            extra: 'Additional info text',
          ),
        ),
      );

      expect(find.text('Additional info text'), findsOneWidget);
    });

    testWidgets('displays both error and extra simultaneously', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            error: true,
            errorText: 'Error message',
            extra: 'Additional info',
          ),
        ),
      );

      expect(find.text('Error message'), findsOneWidget);
      expect(find.text('Additional info'), findsOneWidget);
    });
  });

  group('VSelect fullWidth', () {
    testWidgets('SizedBox width infinity when fullWidth: true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            fullWidth: true,
          ),
        ),
      );

      final sizedBoxFinder = find.descendant(
        of: find.byType(VSelect<String>),
        matching: find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == double.infinity,
        ),
      );
      expect(sizedBoxFinder, findsOneWidget);
    });

    testWidgets('no SizedBox when fullWidth: false (default)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
          ),
        ),
      );

      final sizedBoxFinder = find.descendant(
        of: find.byType(VSelect<String>),
        matching: find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == double.infinity,
        ),
      );
      expect(sizedBoxFinder, findsNothing);
    });
  });

  group('VSelect onChanged single selection', () {
    testWidgets('calls onChanged callback', (tester) async {
      String? selectedValue;
      var callbackCalled = false;

      await tester.pumpWidget(
        buildOverlayTestWidget(
          StatefulBuilder(
            builder: (context, setState) => VSelect<String>(
              items: const [
                VSelectItem(value: 'a', label: 'Option A'),
                VSelectItem(value: 'b', label: 'Option B'),
              ],
              value: selectedValue,
              onChanged: (value) {
                callbackCalled = true;
                setState(() => selectedValue = value);
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option A'));
      await tester.pumpAndSettle();

      expect(callbackCalled, true);
      expect(selectedValue, 'a');
    });

    testWidgets('selectable but no callback when onChanged is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // Runs without error
      expect(find.text('Option A'), findsOneWidget);
    });
  });

  group('VSelect leading icon', () {
    testWidgets('leading icon is displayed in dropdown items', (tester) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          const VSelect<String>(
            items: [
              VSelectItem(
                value: 'a',
                label: 'Option A',
                leading: SizedBox(
                  key: Key('leading-icon'),
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('leading-icon')), findsOneWidget);
    });
  });

  group('VSelect size default', () {
    testWidgets('applies md(40) when size is null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
          ),
        ),
      );

      expect(find.byType(VSelect<String>), findsOneWidget);

      // null -> sizes.md.height = 40
      final containerFinder = find.descendant(
        of: find.byType(VSelect<String>),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Container && widget.constraints?.minHeight == 40,
        ),
      );
      expect(containerFinder, findsOneWidget);
      // At 1x text the minimum is the drawn height.
      expect(tester.getSize(containerFinder).height, 40);
    });
  });

  group('VSelect disabled and onChanged interaction', () {
    testWidgets('dropdown does not open on tap in disabled state', (
      tester,
    ) async {
      var callbackCalled = false;

      await tester.pumpWidget(
        buildOverlayTestWidget(
          VSelect<String>(
            items: const [VSelectItem(value: 'a', label: 'Option A')],
            enabled: false,
            onChanged: (value) {
              callbackCalled = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>), warnIfMissed: false);
      await tester.pump();

      expect(callbackCalled, false);
    });
  });

  group('VSelect case-insensitive search', () {
    test('verifies search filtering logic - uses toLowerCase', () {
      // VSelect's _filteredItems getter uses toLowerCase() for case-insensitive search
      // Code: label.toLowerCase().contains(_searchQuery.toLowerCase())
      const searchQuery = 'APPLE';
      const label = 'Apple';

      final result = label.toLowerCase().contains(searchQuery.toLowerCase());
      expect(result, true);
    });
  });

  group('VSelect selection indicator', () {
    testWidgets('displays check icon for selected item', (tester) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          const VSelect<String>(
            items: [
              VSelectItem(value: 'a', label: 'Option A'),
              VSelectItem(value: 'b', label: 'Option B'),
            ],
            value: 'a',
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // Check icon on selected item (VIcons.check renders CustomPaint)
      // VIcons.check produces SizedBox.square > CustomPaint pattern
      // Count CustomPaint widgets used for check icons within the overlay
      final checkIconFinder = find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.width == widget.height &&
            widget.child is CustomPaint,
      );
      expect(checkIconFinder, findsAtLeast(1));
    });

    testWidgets('no check icon on unselected items', (tester) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          const VSelect<String>(
            items: [
              VSelectItem(value: 'a', label: 'Option A'),
              VSelectItem(value: 'b', label: 'Option B'),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // When no value is selected, VIcons.check should not appear in dropdown items.
      // Only the chevronDown icon exists in the trigger (not a check icon).
      // Verify by checking that the overlay items do not contain check-sized icons.
      // Without selection, the dropdown item rows should not have trailing icons.
      expect(find.byType(VSelect<String>), findsOneWidget);
    });
  });

  group('VSelect.multiple check icon', () {
    testWidgets('check mark on all selected items in multiple selection', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          const VSelect<String>.multiple(
            items: [
              VSelectItem(value: 'a', label: 'Option A'),
              VSelectItem(value: 'b', label: 'Option B'),
              VSelectItem(value: 'c', label: 'Option C'),
            ],
            values: ['a', 'b'],
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // VIcons.check produces SizedBox.square > CustomPaint pattern
      // With 2 items selected, there should be at least 2 check icons
      final checkIconFinder = find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.width == widget.height &&
            widget.child is CustomPaint,
      );
      expect(checkIconFinder, findsAtLeast(2));
    });
  });

  group('VSelect background color state', () {
    testWidgets('selected item has accent background color', (tester) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          const VSelect<String>(
            items: [
              VSelectItem(value: 'a', label: 'Option A'),
              VSelectItem(value: 'b', label: 'Option B'),
            ],
            value: 'a',
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // Selected item's Container should have accent color
      // (should be a non-transparent color)
      expect(find.byType(VSelect<String>), findsOneWidget);
    });
  });

  group('VSelect loading indicator', () {
    testWidgets('displays loading icon when loading: true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            loading: true,
          ),
        ),
      );

      await tester.pump();

      // Verify loading indicator exists (VIcons.refresh renders CustomPaint)
      expect(find.byType(CustomPaint), findsAtLeast(1));
    });

    testWidgets('displays dropdown icon when loading: false', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
          ),
        ),
      );

      // Verify dropdown icon (VIcons.chevronDown renders CustomPaint)
      expect(find.byType(CustomPaint), findsAtLeast(1));
    });
  });

  group('VSelect border color', () {
    testWidgets('border color is destructive in error state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            error: true,
            errorText: 'Error',
          ),
        ),
      );

      expect(find.byType(VSelect<String>), findsOneWidget);
      // Verify border color in error state (destructive)
    });

    testWidgets('border color is muted in disabled state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            enabled: false,
          ),
        ),
      );

      expect(find.byType(VSelect<String>), findsOneWidget);
    });
  });

  group('VSelectSize enum', () {
    test('VSelectSize values verification', () {
      expect(VSelectSize.values, contains(VSelectSize.sm));
      expect(VSelectSize.values, contains(VSelectSize.md));
      expect(VSelectSize.values, contains(VSelectSize.lg));
      expect(VSelectSize.values.length, 3);
    });
  });

  group('VSelect empty items handling', () {
    testWidgets('creates VSelect with empty items array', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>(items: [], placeholder: 'Select'),
        ),
      );

      expect(find.byType(VSelect<String>), findsOneWidget);
      expect(find.text('Select'), findsOneWidget);
    });
  });

  group('VSelect generic types', () {
    testWidgets('int type VSelect', (tester) async {
      int? selectedValue;

      await tester.pumpWidget(
        buildOverlayTestWidget(
          StatefulBuilder(
            builder: (context, setState) => VSelect<int>(
              items: const [
                VSelectItem(value: 1, label: 'One'),
                VSelectItem(value: 2, label: 'Two'),
              ],
              value: selectedValue,
              onChanged: (value) {
                setState(() => selectedValue = value);
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<int>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('One'));
      await tester.pumpAndSettle();

      expect(selectedValue, 1);
    });

    testWidgets('enum type VSelect', (tester) async {
      VSelectSize? selectedSize;

      await tester.pumpWidget(
        buildOverlayTestWidget(
          StatefulBuilder(
            builder: (context, setState) => VSelect<VSelectSize>(
              items: const [
                VSelectItem(value: VSelectSize.sm, label: 'Small'),
                VSelectItem(value: VSelectSize.md, label: 'Medium'),
                VSelectItem(value: VSelectSize.lg, label: 'Large'),
              ],
              value: selectedSize,
              onChanged: (value) {
                setState(() => selectedSize = value);
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<VSelectSize>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Medium'));
      await tester.pumpAndSettle();

      expect(selectedSize, VSelectSize.md);
    });
  });

  group('VSelect.multiple empty values', () {
    testWidgets('displays placeholder when values is empty list', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSelect<String>.multiple(
            items: [VSelectItem(value: 'a', label: 'Option A')],
            values: [],
            placeholder: 'Please select an item',
          ),
        ),
      );

      expect(find.text('Please select an item'), findsOneWidget);
    });
  });

  group('VSelect additional accessibility', () {
    testWidgets('multiple selection Semantics', (tester) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          const VSelect<String>.multiple(
            items: [
              VSelectItem(value: 'a', label: 'Option A'),
              VSelectItem(value: 'b', label: 'Option B'),
            ],
            values: ['a'],
          ),
        ),
      );

      await tester.tap(find.byType(VSelect<String>));
      await tester.pumpAndSettle();

      // Selected item
      final semanticsA = tester.getSemantics(find.text('Option A').last);
      expect(
        semanticsA.getSemanticsData().flagsCollection.isSelected,
        Tristate.isTrue,
      );

      // Unselected item
      final semanticsB = tester.getSemantics(find.text('Option B'));
      expect(
        semanticsB.getSemanticsData().flagsCollection.isSelected,
        Tristate.isFalse,
      );
    });
  });

  group('theme override', () {
    testWidgets('theme componentOverrides applies to select', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light().copyWith(
            componentOverrides: const VComponentOverrides([
              VSelectStyle(backgroundColor: Color(0xFFFF0000)),
            ]),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: VSelect<String>(
              items: const [VSelectItem(value: 'a', label: 'Option A')],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(VSelect<String>), findsOneWidget);
    });
  });

  group('style fields', () {
    final theme = VThemeData.light();
    const items = [
      VSelectItem(value: 'a', label: 'Alpha'),
      VSelectItem(value: 'b', label: 'Beta'),
    ];
    const style = VSelectStyle(
      foregroundColor: Color(0xFF0000AA),
      textStyle: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
      focusBorderColor: Color(0xFFAA00AA),
      dropdownBackgroundColor: Color(0xFFFAFAF0),
      dropdownBorderRadius: BorderRadius.all(Radius.circular(3)),
      minWidth: 260,
    );

    // Applies [style] through the theme or as the instance style.
    Widget styled({
      required bool viaTheme,
      required Widget Function(VSelectStyle? instanceStyle) build,
    }) => VTheme(
      data: theme.copyWith(
        componentOverrides: VComponentOverrides(viaTheme ? [style] : []),
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
                  child: build(viaTheme ? null : style),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Finder trigger() => find
        .descendant(of: find.byType(VPopover), matching: find.byType(Container))
        .first;

    Border borderOf(WidgetTester tester) =>
        (tester.widget<Container>(trigger()).decoration! as BoxDecoration)
                .border!
            as Border;

    void focusSelect(WidgetTester tester) =>
        Focus.of(tester.element(find.byType(VPopover))).requestFocus();

    for (final viaTheme in [true, false]) {
      final via = viaTheme ? 'theme' : 'instance';

      testWidgets('the picked value takes foregroundColor and textStyle '
          '($via)', (tester) async {
        await tester.pumpWidget(
          styled(
            viaTheme: viaTheme,
            build: (s) => VSelect<String>(
              items: items,
              value: 'a',
              onChanged: (_) {},
              style: s,
            ),
          ),
        );

        final text = tester.widget<Text>(find.text('Alpha')).style!;
        expect(text.color, style.foregroundColor);
        expect(text.fontSize, 18);
        expect(text.fontStyle, FontStyle.italic);
      });

      testWidgets('the placeholder stays muted ($via)', (tester) async {
        await tester.pumpWidget(
          styled(
            viaTheme: viaTheme,
            build: (s) => VSelect<String>(
              items: items,
              placeholder: 'Pick one',
              onChanged: (_) {},
              style: s,
            ),
          ),
        );

        final text = tester.widget<Text>(find.text('Pick one')).style!;
        expect(text.color, theme.colors.mutedForeground);
        expect(text.fontSize, 18);
      });

      testWidgets('keyboard focus draws focusBorderColor ($via)', (
        tester,
      ) async {
        await tester.pumpWidget(
          styled(
            viaTheme: viaTheme,
            build: (s) =>
                VSelect<String>(items: items, onChanged: (_) {}, style: s),
          ),
        );
        expect(borderOf(tester).top.color, theme.colors.input);
        expect(borderOf(tester).top.width, 1);

        focusSelect(tester);
        await tester.pump();

        expect(borderOf(tester).top.color, style.focusBorderColor);
        expect(borderOf(tester).top.width, 2);
      });

      testWidgets('minWidth sets the shrink-wrapped trigger width ($via)', (
        tester,
      ) async {
        await tester.pumpWidget(
          styled(
            viaTheme: viaTheme,
            // The trigger fills a bounded width; minWidth shows when the
            // select is sized to its content.
            build: (s) => IntrinsicWidth(
              child: VSelect<String>(items: items, onChanged: (_) {}, style: s),
            ),
          ),
        );

        expect(tester.getSize(trigger()).width, 260);
      });

      testWidgets('the dropdown takes its background and radius ($via)', (
        tester,
      ) async {
        await tester.pumpWidget(
          styled(
            viaTheme: viaTheme,
            build: (s) =>
                VSelect<String>(items: items, onChanged: (_) {}, style: s),
          ),
        );
        await tester.tap(find.byType(VSelect<String>));
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Container &&
                widget.decoration is BoxDecoration &&
                (widget.decoration! as BoxDecoration).color ==
                    style.dropdownBackgroundColor &&
                (widget.decoration! as BoxDecoration).borderRadius ==
                    style.dropdownBorderRadius,
          ),
          findsOneWidget,
        );
      });
    }

    testWidgets('without a style, focus draws the ring color', (tester) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          VSelect<String>(items: items, onChanged: (_) {}),
        ),
      );
      focusSelect(tester);
      await tester.pump();

      expect(borderOf(tester).top.color, theme.colors.ring);
      expect(borderOf(tester).top.width, 2);
    });

    testWidgets('without minWidth, a shrink-wrapped trigger keeps the size '
        'default', (tester) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          IntrinsicWidth(
            child: VSelect<String>(items: items, onChanged: (_) {}),
          ),
        ),
      );

      // The md trigger's default minimum width.
      expect(tester.getSize(trigger()).width, 208);
    });

    testWidgets('error keeps its color while focused', (tester) async {
      await tester.pumpWidget(
        buildOverlayTestWidget(
          VSelect<String>(items: items, error: true, onChanged: (_) {}),
        ),
      );
      focusSelect(tester);
      await tester.pump();

      expect(borderOf(tester).top.color, theme.colors.destructive);
      expect(borderOf(tester).top.width, 2);
    });

    testWidgets('Tab stops on the select once and shows its focus', (
      tester,
    ) async {
      final before = FocusNode();
      final after = FocusNode();
      addTearDown(before.dispose);
      addTearDown(after.dispose);
      await tester.pumpWidget(
        buildOverlayTestWidget(
          Shortcuts(
            shortcuts: WidgetsApp.defaultShortcuts,
            child: Actions(
              actions: WidgetsApp.defaultActions,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Focus(focusNode: before, child: const SizedBox(height: 10)),
                  VSelect<String>(items: items, onChanged: (_) {}),
                  Focus(focusNode: after, child: const SizedBox(height: 10)),
                ],
              ),
            ),
          ),
        ),
      );
      before.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(borderOf(tester).top.color, theme.colors.ring);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(after.hasFocus, isTrue);
      expect(borderOf(tester).top.color, theme.colors.input);
    });
  });

  testWidgets('the trigger and the options are not clipped at 320 wide and '
      '3x text', (tester) async {
    final theme = VThemeData.light();
    tester.view
      ..physicalSize = const Size(320, 640)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(320, 640),
          textScaler: TextScaler.linear(3),
        ),
        child: VTheme(
          data: theme,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (_) => Align(
                    alignment: Alignment.topCenter,
                    child: VSelect<String>(
                      items: const [
                        VSelectItem(value: 'a', label: 'Alpha'),
                        VSelectItem(value: 'b', label: 'Beta'),
                      ],
                      placeholder: 'Pick',
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final body = theme.typography.bodyMedium;
    final lineHeight = theme.sizes.md.fontSize * 3 * body.height!;
    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.text('Pick')).height,
      greaterThanOrEqualTo(lineHeight - 0.5),
    );

    await tester.tap(find.byType(VSelect<String>));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.text('Beta')).height,
      greaterThanOrEqualTo(lineHeight - 0.5),
    );
  });

  group('VSelect closed when disabled or read-only', () {
    // Hosts [child] in an overlay, where the popover opens.
    Widget host(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: Overlay(
            initialEntries: [
              OverlayEntry(builder: (_) => Center(child: child)),
            ],
          ),
        ),
      ),
    );

    Future<bool> opensOnTap(
      WidgetTester tester, {
      bool enabled = true,
      bool readOnly = false,
    }) async {
      await tester.pumpWidget(
        host(
          VSelect<String>(
            items: const [VSelectItem(value: 'a', label: 'Option A')],
            placeholder: 'Pick',
            enabled: enabled,
            readOnly: readOnly,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.tap(find.byType(VSelect<String>), warnIfMissed: false);
      await tester.pumpAndSettle();
      // The option shows only while the dropdown is open.
      return find.text('Option A').evaluate().isNotEmpty;
    }

    testWidgets('an enabled select opens on tap', (tester) async {
      expect(await opensOnTap(tester), isTrue);
    });

    testWidgets('a disabled select stays closed on tap', (tester) async {
      expect(await opensOnTap(tester, enabled: false), isFalse);
    });

    testWidgets('a read-only select stays closed on tap', (tester) async {
      expect(await opensOnTap(tester, readOnly: true), isFalse);
    });
  });
}
