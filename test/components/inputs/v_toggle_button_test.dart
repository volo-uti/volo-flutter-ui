import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VToggleButton', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    // ── Selected / Unselected state ──────────────────────────────────

    group('selection state', () {
      testWidgets('renders in selected state', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: true,
              onChanged: (_) {},
              child: const Text('Bold'),
            ),
          ),
        );

        expect(find.text('Bold'), findsOneWidget);

        // Selected → accent background
        // Note: first AnimatedContainer is the focus ring wrapper (no color),
        // the inner one has the actual background color.
        final theme = VThemeData.light();
        final container = tester
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .last;
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, theme.colors.accent);
      });

      testWidgets('renders in unselected state', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              child: const Text('Bold'),
            ),
          ),
        );

        expect(find.text('Bold'), findsOneWidget);

        // Unselected ghost → transparent background
        final container = tester
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .last;
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, const Color(0x00000000));
      });
    });

    // ── onPressedChange callback ───────────────────────────────────────

    group('onPressedChange callback', () {
      testWidgets('fires with toggled value (false → true)', (tester) async {
        bool? received;

        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (value) => received = value,
              child: const Text('Toggle'),
            ),
          ),
        );

        await tester.tap(find.text('Toggle'));
        expect(received, isTrue);
      });

      testWidgets('fires with toggled value (true → false)', (tester) async {
        bool? received;

        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: true,
              onChanged: (value) => received = value,
              child: const Text('Toggle'),
            ),
          ),
        );

        await tester.tap(find.text('Toggle'));
        expect(received, isFalse);
      });
    });

    // ── Disabled state ───────────────────────────────────────────────

    group('disabled state', () {
      testWidgets('applies opacity 0.5 when disabled', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              enabled: false,
              child: const Text('Disabled'),
            ),
          ),
        );

        final opacities = tester.widgetList<Opacity>(find.byType(Opacity));
        final hasHalfOpacity = opacities.any((o) => o.opacity == 0.5);
        expect(hasHalfOpacity, isTrue);
      });

      testWidgets('applies opacity 1.0 when enabled', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              child: const Text('Enabled'),
            ),
          ),
        );

        final opacities = tester.widgetList<Opacity>(find.byType(Opacity));
        final hasFullOpacity = opacities.any((o) => o.opacity == 1.0);
        expect(hasFullOpacity, isTrue);
      });

      testWidgets('does not fire callback when disabled', (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) => tapped = true,
              enabled: false,
              child: const Text('Disabled'),
            ),
          ),
        );

        await tester.tap(find.text('Disabled'));
        expect(tapped, isFalse);
      });

      testWidgets('does not fire callback when onPressedChange is null', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VToggleButton(isSelected: false, child: Text('No CB')),
          ),
        );

        // Should render without error, tap should not throw
        await tester.tap(find.text('No CB'));
        expect(find.text('No CB'), findsOneWidget);
      });
    });

    // ── VToggleButtonType variants ───────────────────────────────────

    group('type variants', () {
      testWidgets('filled type uses muted background when unselected', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              type: VToggleButtonType.filled,
              child: const Text('Filled'),
            ),
          ),
        );

        final theme = VThemeData.light();
        final container = tester
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .last;
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, theme.colors.muted);
      });

      testWidgets('ghost type uses transparent background when unselected', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              child: const Text('Ghost'),
            ),
          ),
        );

        final container = tester
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .last;
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, const Color(0x00000000));
      });

      testWidgets('outlined type renders border when unselected', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              type: VToggleButtonType.outlined,
              child: const Text('Outlined'),
            ),
          ),
        );

        final theme = VThemeData.light();
        final container = tester
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .last;
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.border, isNotNull);
        final border = decoration.border! as Border;
        expect(border.top.color, theme.colors.border);
      });

      testWidgets('selected state overrides type to accent background', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: true,
              onChanged: (_) {},
              type: VToggleButtonType.outlined,
              child: const Text('Selected Outlined'),
            ),
          ),
        );

        final theme = VThemeData.light();
        final container = tester
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .last;
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, theme.colors.accent);
        // No border when selected
        expect(decoration.border, isNull);
      });
    });

    // ── VToggleButtonSize variants ───────────────────────────────────

    group('size variants', () {
      testWidgets('sm size applies small height', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              size: VToggleButtonSize.sm,
              child: const Text('Small'),
            ),
          ),
        );

        final theme = VThemeData.light();
        // The inner AnimatedContainer (.last) uses explicit height param
        final container = tester
            .widgetList<AnimatedContainer>(
              find.descendant(
                of: find.byType(VToggleButton),
                matching: find.byType(AnimatedContainer),
              ),
            )
            .last;
        expect(container.decoration, isNotNull);
        expect(container.constraints?.maxHeight, theme.sizes.sm.height);
      });

      testWidgets('md size applies medium height (default)', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              child: const Text('Medium'),
            ),
          ),
        );

        final theme = VThemeData.light();
        final container = tester
            .widgetList<AnimatedContainer>(
              find.descendant(
                of: find.byType(VToggleButton),
                matching: find.byType(AnimatedContainer),
              ),
            )
            .last;
        expect(container.constraints?.maxHeight, theme.sizes.md.height);
      });

      testWidgets('lg size applies large height', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              size: VToggleButtonSize.lg,
              child: const Text('Large'),
            ),
          ),
        );

        final theme = VThemeData.light();
        final container = tester
            .widgetList<AnimatedContainer>(
              find.descendant(
                of: find.byType(VToggleButton),
                matching: find.byType(AnimatedContainer),
              ),
            )
            .last;
        expect(container.constraints?.maxHeight, theme.sizes.lg.height);
      });
    });

    // ── Hover state ──────────────────────────────────────────────────

    group('hover state', () {
      testWidgets('hover changes style on mouse enter', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              child: const Text('Hover Me'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        // Move into the widget
        await gesture.moveTo(tester.getCenter(find.text('Hover Me')));
        await tester.pump();

        // Ghost unselected + hovered → accent background
        final theme = VThemeData.light();
        final container = tester
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .last;
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, theme.colors.accent);
      });

      testWidgets('hover reverts style on mouse exit', (tester) async {
        // Wrap in Center so the widget is not at (0,0)
        await tester.pumpWidget(
          buildTestWidget(
            Center(
              child: VToggleButton(
                isSelected: false,
                onChanged: (_) {},
                child: const Text('Hover Me'),
              ),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        // Enter — move into the widget center
        await gesture.moveTo(tester.getCenter(find.text('Hover Me')));
        await tester.pumpAndSettle();

        // Exit — move to top-left corner, clearly outside the centered widget
        await gesture.moveTo(Offset.zero);
        await tester.pumpAndSettle();

        final container = tester
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .last;
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, const Color(0x00000000));
      });

      testWidgets('hover does not change style when disabled', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              enabled: false,
              type: VToggleButtonType.filled,
              child: const Text('Disabled Hover'),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        // Capture initial background (inner AnimatedContainer)
        final initialContainer = tester
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .last;
        final initialDecoration = initialContainer.decoration! as BoxDecoration;
        final initialColor = initialDecoration.color;

        // Hover
        await gesture.moveTo(tester.getCenter(find.text('Disabled Hover')));
        await tester.pump();

        // Should remain unchanged
        final hoveredContainer = tester
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .last;
        final hoveredDecoration = hoveredContainer.decoration! as BoxDecoration;
        expect(hoveredDecoration.color, initialColor);
      });
    });

    // ── Press animation (scale down) ─────────────────────────────────

    group('press animation', () {
      testWidgets('has AnimatedBuilder and Transform.scale infrastructure', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              child: const Text('Animated'),
            ),
          ),
        );

        // AnimatedBuilder wraps the Transform.scale for press animation
        expect(
          find.descendant(
            of: find.byType(VToggleButton),
            matching: find.byType(AnimatedBuilder),
          ),
          findsOneWidget,
        );

        // Transform.scale exists inside the AnimatedBuilder
        expect(
          find.descendant(
            of: find.byType(VToggleButton),
            matching: find.byType(Transform),
          ),
          findsOneWidget,
        );

        // Initial scale is 1.0 (Tween begin value)
        final transform = tester
            .widgetList<Transform>(
              find.descendant(
                of: find.byType(VToggleButton),
                matching: find.byType(Transform),
              ),
            )
            .first;
        expect(transform.transform.getMaxScaleOnAxis(), 1.0);
      });

      testWidgets('scale returns to 1.0 after full tap', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              child: const Text('Tap Me'),
            ),
          ),
        );

        // Perform a full tap (down + up in quick succession)
        await tester.tap(find.text('Tap Me'));
        await tester.pumpAndSettle();

        // After tap completes and animation settles, scale is 1.0
        final transform = tester
            .widgetList<Transform>(
              find.descendant(
                of: find.byType(VToggleButton),
                matching: find.byType(Transform),
              ),
            )
            .first;
        expect(transform.transform.getMaxScaleOnAxis(), 1.0);
      });
    });

    // ── Child rendering ──────────────────────────────────────────────

    group('child rendering', () {
      testWidgets('String child renders as Text', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              child: const Text('String Label'),
            ),
          ),
        );

        expect(find.text('String Label'), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('Widget child renders directly', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text('Widget Child')],
              ),
            ),
          ),
        );

        expect(find.text('Widget Child'), findsOneWidget);
        // Row is the child, not a Text wrapping
        expect(
          find.descendant(
            of: find.byType(VToggleButton),
            matching: find.byType(Row),
          ),
          findsWidgets,
        );
      });
    });

    // ── Semantics ────────────────────────────────────────────────────

    group('semantics', () {
      testWidgets('toggled=true in selected state', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: true,
              onChanged: (_) {},
              child: const Text('Selected'),
            ),
          ),
        );

        final semantics = tester.getSemantics(find.byType(VToggleButton));
        expect(
          semantics.getSemanticsData().flagsCollection.isToggled,
          Tristate.isTrue,
        );
      });

      testWidgets('toggled=false in unselected state', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              child: const Text('Unselected'),
            ),
          ),
        );

        final semantics = tester.getSemantics(find.byType(VToggleButton));
        expect(
          semantics.getSemanticsData().flagsCollection.isToggled,
          Tristate.isFalse,
        );
      });

      testWidgets('enabled=false when disabled', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              enabled: false,
              child: const Text('Disabled'),
            ),
          ),
        );

        final semantics = tester.getSemantics(find.byType(VToggleButton));
        expect(
          semantics.getSemanticsData().flagsCollection.isEnabled,
          Tristate.isFalse,
        );
      });
    });

    // ── Mouse cursor ─────────────────────────────────────────────────

    group('mouse cursor', () {
      testWidgets('shows click cursor when enabled', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              child: const Text('Clickable'),
            ),
          ),
        );

        // The focus detector adds a MouseRegion of its own (deferring).
        final cursors = tester
            .widgetList<MouseRegion>(find.byType(MouseRegion))
            .map((region) => region.cursor);
        expect(cursors, contains(SystemMouseCursors.click));
      });

      testWidgets('shows basic cursor when disabled', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              enabled: false,
              child: const Text('Not Clickable'),
            ),
          ),
        );

        // The focus detector adds a MouseRegion of its own (deferring).
        final cursors = tester
            .widgetList<MouseRegion>(find.byType(MouseRegion))
            .map((region) => region.cursor);
        expect(cursors, contains(SystemMouseCursors.basic));
      });
    });
  });

  // ════════════════════════════════════════════════════════════════════
  // VToggleButtonGroup
  // ════════════════════════════════════════════════════════════════════

  group('VToggleButtonGroup', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    final testItems = <VToggleButtonItem<String>>[
      const VToggleButtonItem(value: 'grid', label: Text('Grid')),
      const VToggleButtonItem(value: 'list', label: Text('List')),
      const VToggleButtonItem(value: 'table', label: Text('Table')),
    ];

    // ── Single selection ─────────────────────────────────────────────

    group('single selection', () {
      testWidgets('selects a single value', (tester) async {
        String? selected;

        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              value: 'grid',
              items: testItems,
              onChanged: (value) => selected = value,
            ),
          ),
        );

        expect(find.text('Grid'), findsOneWidget);
        expect(find.text('List'), findsOneWidget);
        expect(find.text('Table'), findsOneWidget);

        // Tap on 'List' item
        await tester.tap(find.text('List'));
        expect(selected, 'list');
      });

      testWidgets('deselects current value when allowEmpty=true', (
        tester,
      ) async {
        String? selected = 'grid';

        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              value: 'grid',
              items: testItems,
              onChanged: (value) => selected = value,
            ),
          ),
        );

        // Tap already-selected 'Grid'
        await tester.tap(find.text('Grid'));
        expect(selected, isNull);
      });

      testWidgets('does not deselect when allowEmpty=false', (tester) async {
        String? lastValue;

        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              value: 'grid',
              items: testItems,
              allowEmpty: false,
              onChanged: (value) => lastValue = value,
            ),
          ),
        );

        // Tap already-selected 'Grid' — should not call onValueChange
        await tester.tap(find.text('Grid'));
        expect(lastValue, isNull);
      });
    });

    // ── Multiple selection ───────────────────────────────────────────

    group('multiple selection', () {
      testWidgets('selects multiple values', (tester) async {
        List<String>? selected;

        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              values: const ['grid'],
              items: testItems,
              allowMultiple: true,
              onValuesChanged: (values) => selected = values,
            ),
          ),
        );

        // Tap 'List' to add it
        await tester.tap(find.text('List'));
        expect(selected, containsAll(['grid', 'list']));
      });

      testWidgets('deselects from multiple when allowEmpty=true', (
        tester,
      ) async {
        List<String>? selected;

        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              values: const ['grid', 'list'],
              items: testItems,
              allowMultiple: true,
              onValuesChanged: (values) => selected = values,
            ),
          ),
        );

        // Tap 'Grid' to deselect it
        await tester.tap(find.text('Grid'));
        expect(selected, ['list']);
      });

      testWidgets('cannot deselect last item when allowEmpty=false', (
        tester,
      ) async {
        List<String>? selected;

        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              values: const ['grid'],
              items: testItems,
              allowMultiple: true,
              allowEmpty: false,
              onValuesChanged: (values) => selected = values,
            ),
          ),
        );

        // Tap already-selected 'Grid' — should remain
        await tester.tap(find.text('Grid'));
        expect(selected, ['grid']);
      });
    });

    // ── allowEmpty ───────────────────────────────────────────────────

    group('allowEmpty toggle', () {
      testWidgets('allowEmpty=true allows null in single mode', (tester) async {
        String? result = 'grid';

        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              value: 'grid',
              items: testItems,
              onChanged: (value) => result = value,
            ),
          ),
        );

        await tester.tap(find.text('Grid'));
        expect(result, isNull);
      });

      testWidgets('allowEmpty=true allows empty list in multi mode', (
        tester,
      ) async {
        List<String>? result;

        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              values: const ['grid'],
              items: testItems,
              allowMultiple: true,
              onValuesChanged: (values) => result = values,
            ),
          ),
        );

        await tester.tap(find.text('Grid'));
        expect(result, isEmpty);
      });
    });

    // ── Custom type / size ───────────────────────────────────────────

    group('custom type and size', () {
      testWidgets('filled type applies muted container background', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              items: testItems,
              type: VToggleButtonType.filled,
            ),
          ),
        );

        final theme = VThemeData.light();
        // Find the outer Container that wraps the group
        final containers = tester.widgetList<Container>(
          find.descendant(
            of: find.byType(VToggleButtonGroup<String>),
            matching: find.byType(Container),
          ),
        );
        final outerContainer = containers.first;
        final decoration = outerContainer.decoration! as BoxDecoration;
        expect(decoration.color, theme.colors.muted);
      });

      testWidgets('outlined type applies border on container', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              items: testItems,
              type: VToggleButtonType.outlined,
            ),
          ),
        );

        final containers = tester.widgetList<Container>(
          find.descendant(
            of: find.byType(VToggleButtonGroup<String>),
            matching: find.byType(Container),
          ),
        );
        final outerContainer = containers.first;
        final decoration = outerContainer.decoration! as BoxDecoration;
        expect(decoration.border, isNotNull);
      });

      testWidgets('size=sm reduces item height', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              items: testItems,
              size: VToggleButtonSize.sm,
              onChanged: (_) {},
            ),
          ),
        );

        final theme = VThemeData.light();
        // Group items use AnimatedContainer with the group's height
        final animatedContainers = tester.widgetList<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        for (final container in animatedContainers) {
          final renderBox = tester.renderObject<RenderBox>(
            find.byWidget(container),
          );
          expect(renderBox.size.height, theme.sizes.sm.height);
        }
      });

      testWidgets('size=lg increases item height', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              items: testItems,
              size: VToggleButtonSize.lg,
              onChanged: (_) {},
            ),
          ),
        );

        final theme = VThemeData.light();
        final animatedContainers = tester.widgetList<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        for (final container in animatedContainers) {
          final renderBox = tester.renderObject<RenderBox>(
            find.byWidget(container),
          );
          expect(renderBox.size.height, theme.sizes.lg.height);
        }
      });
    });

    // ── fullWidth layout ─────────────────────────────────────────────

    group('fullWidth layout', () {
      testWidgets('fullWidth=false uses min size', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Center(
              child: VToggleButtonGroup<String>(
                items: testItems,
                onChanged: (_) {},
              ),
            ),
          ),
        );

        // Row should use MainAxisSize.min
        final row = tester.widget<Row>(
          find.descendant(
            of: find.byType(VToggleButtonGroup<String>),
            matching: find.byType(Row),
          ),
        );
        expect(row.mainAxisSize, MainAxisSize.min);
      });

      testWidgets('fullWidth=true uses max size with Expanded children', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Center(
              child: SizedBox(
                width: 400,
                child: VToggleButtonGroup<String>(
                  items: testItems,
                  fullWidth: true,
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        // Row should use MainAxisSize.max
        final row = tester.widget<Row>(
          find.descendant(
            of: find.byType(VToggleButtonGroup<String>),
            matching: find.byType(Row),
          ),
        );
        expect(row.mainAxisSize, MainAxisSize.max);

        // Children should be wrapped in Expanded
        final expandedWidgets = find.descendant(
          of: find.byType(Row),
          matching: find.byType(Expanded),
        );
        expect(expandedWidgets, findsNWidgets(testItems.length));
      });
    });

    // ── Disabled individual items ────────────────────────────────────

    group('disabled individual items', () {
      testWidgets('disabled item has opacity 0.5', (tester) async {
        final itemsWithDisabled = <VToggleButtonItem<String>>[
          const VToggleButtonItem(value: 'a', label: Text('A')),
          const VToggleButtonItem(value: 'b', label: Text('B'), enabled: false),
          const VToggleButtonItem(value: 'c', label: Text('C')),
        ];

        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              items: itemsWithDisabled,
              onChanged: (_) {},
            ),
          ),
        );

        // Find Opacity widgets — the disabled item should have 0.5
        final opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
        final hasHalfOpacity = opacityWidgets.any((w) => w.opacity == 0.5);
        expect(hasHalfOpacity, isTrue);
      });

      testWidgets('disabled item does not fire callback', (tester) async {
        String? tapped;

        final itemsWithDisabled = <VToggleButtonItem<String>>[
          const VToggleButtonItem(value: 'a', label: Text('A')),
          const VToggleButtonItem(value: 'b', label: Text('B'), enabled: false),
        ];

        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              items: itemsWithDisabled,
              onChanged: (value) => tapped = value,
            ),
          ),
        );

        // Tap disabled item 'B'
        await tester.tap(find.text('B'));
        expect(tapped, isNull);

        // Tap enabled item 'A'
        await tester.tap(find.text('A'));
        expect(tapped, 'a');
      });

      testWidgets('enabled items remain clickable alongside disabled', (
        tester,
      ) async {
        String? tapped;

        final itemsWithDisabled = <VToggleButtonItem<String>>[
          const VToggleButtonItem(value: 'a', label: Text('A')),
          const VToggleButtonItem(value: 'b', label: Text('B'), enabled: false),
          const VToggleButtonItem(value: 'c', label: Text('C')),
        ];

        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              items: itemsWithDisabled,
              onChanged: (value) => tapped = value,
            ),
          ),
        );

        await tester.tap(find.text('C'));
        expect(tapped, 'c');
      });
    });

    // ── FocusTraversalGroup ──────────────────────────────────────────

    group('accessibility', () {
      testWidgets('wraps items in FocusTraversalGroup', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(items: testItems, onChanged: (_) {}),
          ),
        );

        expect(
          find.descendant(
            of: find.byType(VToggleButtonGroup<String>),
            matching: find.byType(FocusTraversalGroup),
          ),
          findsOneWidget,
        );
      });
    });

    // ── VToggleButtonItem with icon ──────────────────────────────────

    group('item with icon', () {
      testWidgets('renders icon instead of label when icon is provided', (
        tester,
      ) async {
        final iconItems = <VToggleButtonItem<String>>[
          const VToggleButtonItem(
            value: 'grid',
            label: Text('Grid'),
            icon: Text('G'),
          ),
        ];

        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(items: iconItems, onChanged: (_) {}),
          ),
        );

        // Icon content ('G') should be rendered
        expect(find.text('G'), findsOneWidget);
      });
    });
  });
}
