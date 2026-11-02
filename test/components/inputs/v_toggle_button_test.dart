import 'dart:ui';

import 'package:flutter/services.dart';
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

    group('focus ring', () {
      testWidgets('follows style.borderRadius', (tester) async {
        const radius = BorderRadius.all(Radius.circular(3));
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButton(
              isSelected: false,
              onChanged: (_) {},
              style: const VToggleButtonStyle(borderRadius: radius),
              child: const Text('B'),
            ),
          ),
        );
        Focus.of(tester.element(find.text('B'))).requestFocus();
        await tester.pumpAndSettle();

        final ring = tester
            .widgetList<DecoratedBox>(
              find.descendant(
                of: find.byType(VToggleButton),
                matching: find.byType(DecoratedBox),
              ),
            )
            .map((box) => box.decoration as BoxDecoration)
            .singleWhere(
              (d) =>
                  d.border is Border &&
                  (d.border! as Border).top.color ==
                      VThemeData.light().colors.ring,
            );
        expect(ring.borderRadius, radius);
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

    // ── Style ────────────────────────────────────────────────────────

    group('style', () {
      final theme = VThemeData.light();
      const style = VToggleButtonStyle(
        backgroundColor: Color(0xFFF0F0F0),
        foregroundColor: Color(0xFF333333),
        selectedBackgroundColor: Color(0xFF0000AA),
        selectedForegroundColor: Color(0xFFFFFFFF),
        borderColor: Color(0xFF00AA00),
        borderRadius: BorderRadius.all(Radius.circular(3)),
        padding: EdgeInsets.symmetric(horizontal: 30),
      );

      // Applies [style] through the theme or as the instance style.
      Widget styled({
        required bool viaTheme,
        required Widget Function(VToggleButtonStyle? instanceStyle) build,
      }) => VTheme(
        data: theme.copyWith(
          componentOverrides: VComponentOverrides(viaTheme ? [style] : []),
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(child: build(viaTheme ? null : style)),
        ),
      );

      List<BoxDecoration> optionDecorations(WidgetTester tester) => tester
          .widgetList<AnimatedContainer>(
            find.descendant(
              of: find.byType(VToggleButtonGroup<String>),
              matching: find.byType(AnimatedContainer),
            ),
          )
          .map((c) => c.decoration! as BoxDecoration)
          .toList();

      BoxDecoration groupDecoration(WidgetTester tester) =>
          tester
                  .widget<Container>(
                    find
                        .descendant(
                          of: find.byType(VToggleButtonGroup<String>),
                          matching: find.byType(Container),
                        )
                        .first,
                  )
                  .decoration!
              as BoxDecoration;

      Color? textColorOf(WidgetTester tester, String text) => tester
          .widget<RichText>(
            find.descendant(
              of: find.text(text),
              matching: find.byType(RichText),
            ),
          )
          .text
          .style!
          .color;

      for (final viaTheme in [true, false]) {
        final via = viaTheme ? 'theme' : 'instance';

        testWidgets('colors, corners, border and padding follow the style '
            '($via)', (tester) async {
          await tester.pumpWidget(
            styled(
              viaTheme: viaTheme,
              build: (s) => VToggleButtonGroup<String>(
                items: testItems,
                value: 'grid',
                onChanged: (_) {},
                style: s,
              ),
            ),
          );

          final options = optionDecorations(tester);
          expect(options[0].color, style.selectedBackgroundColor);
          expect(options[1].color, style.backgroundColor);
          expect(textColorOf(tester, 'Grid'), style.selectedForegroundColor);
          expect(textColorOf(tester, 'List'), style.foregroundColor);

          const r = Radius.circular(3);
          expect(
            options.first.borderRadius,
            const BorderRadius.only(topLeft: r, bottomLeft: r),
          );
          expect(
            options.last.borderRadius,
            const BorderRadius.only(topRight: r, bottomRight: r),
          );
          final group = groupDecoration(tester);
          expect(group.borderRadius, style.borderRadius);
          expect((group.border! as Border).top.color, style.borderColor);
          expect(
            tester
                .widget<ClipRRect>(
                  find.descendant(
                    of: find.byType(VToggleButtonGroup<String>),
                    matching: find.byType(ClipRRect),
                  ),
                )
                .borderRadius,
            style.borderRadius,
          );

          final option = find
              .descendant(
                of: find.byType(VToggleButtonGroup<String>),
                matching: find.byType(AnimatedContainer),
              )
              .at(1);
          expect(
            tester.getTopLeft(find.text('List')).dx -
                tester.getTopLeft(option).dx,
            30,
          );
        });
      }

      testWidgets('without a style, the tokens draw the group', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              items: testItems,
              value: 'grid',
              type: VToggleButtonType.outlined,
              onChanged: (_) {},
            ),
          ),
        );

        final options = optionDecorations(tester);
        expect(options[0].color, theme.colors.accent);
        expect(options[1].color, VColors.transparent);
        expect(textColorOf(tester, 'Grid'), theme.colors.accentForeground);
        expect(textColorOf(tester, 'List'), theme.colors.foreground);
        final group = groupDecoration(tester);
        expect(group.borderRadius, BorderRadius.circular(theme.radius.md));
        expect((group.border! as Border).top.color, theme.colors.border);
      });
    });

    // ── Keyboard, semantics and size ─────────────────────────────────

    group('keyboard and semantics', () {
      final theme = VThemeData.light();

      Widget withKeyboard(Widget child) => buildTestWidget(
        Shortcuts(
          shortcuts: WidgetsApp.defaultShortcuts,
          child: Actions(actions: WidgetsApp.defaultActions, child: child),
        ),
      );

      bool focusedOn(WidgetTester tester, String text) =>
          Focus.of(tester.element(find.text(text))).hasPrimaryFocus;

      testWidgets('Tab stops on each enabled option and draws a focus ring', (
        tester,
      ) async {
        final before = FocusNode();
        addTearDown(before.dispose);
        await tester.pumpWidget(
          withKeyboard(
            Column(
              children: [
                Focus(focusNode: before, child: const SizedBox(height: 10)),
                VToggleButtonGroup<String>(
                  items: const [
                    VToggleButtonItem(value: 'grid', label: Text('Grid')),
                    VToggleButtonItem(
                      value: 'list',
                      label: Text('List'),
                      enabled: false,
                    ),
                    VToggleButtonItem(value: 'table', label: Text('Table')),
                  ],
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        );
        before.requestFocus();
        await tester.pump();

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(focusedOn(tester, 'Grid'), isTrue);
        final rings = tester
            .widgetList<DecoratedBox>(
              find.descendant(
                of: find.byType(VToggleButtonGroup<String>),
                matching: find.byType(DecoratedBox),
              ),
            )
            .where(
              (box) =>
                  box.position == DecorationPosition.foreground &&
                  (box.decoration as BoxDecoration).border != null,
            );
        expect(rings, hasLength(1));
        expect(
          ((rings.single.decoration as BoxDecoration).border! as Border)
              .top
              .color,
          theme.colors.ring,
        );

        // The disabled option is skipped.
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(focusedOn(tester, 'Table'), isTrue);
      });

      testWidgets('Enter and Space press the focused option', (tester) async {
        String? single;
        List<String>? multiple;
        await tester.pumpWidget(
          withKeyboard(
            Column(
              children: [
                VToggleButtonGroup<String>(
                  items: testItems,
                  onChanged: (v) => single = v,
                ),
                VToggleButtonGroup<String>(
                  items: const [
                    VToggleButtonItem(value: 'b', label: Text('Bold')),
                    VToggleButtonItem(value: 'i', label: Text('Italic')),
                  ],
                  allowMultiple: true,
                  onValuesChanged: (v) => multiple = v,
                ),
              ],
            ),
          ),
        );

        Focus.of(tester.element(find.text('List'))).requestFocus();
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();
        expect(single, 'list');

        Focus.of(tester.element(find.text('Italic'))).requestFocus();
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pump();
        expect(multiple, ['i']);
      });

      testWidgets('a single-choice option is a selected button', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              items: testItems,
              value: 'grid',
              onChanged: (_) {},
            ),
          ),
        );

        final grid = tester.getSemantics(find.text('Grid'));
        final flags = grid.getSemanticsData().flagsCollection;
        expect(flags.isButton, isTrue);
        expect(flags.isSelected, Tristate.isTrue);
        expect(flags.isInMutuallyExclusiveGroup, isTrue);
        expect(grid.label, 'Grid');
        expect(
          tester
              .getSemantics(find.text('List'))
              .getSemanticsData()
              .flagsCollection
              .isSelected,
          Tristate.isFalse,
        );
      });

      testWidgets('a multiple-choice option is a toggled button', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              items: testItems,
              values: const ['list'],
              allowMultiple: true,
              onValuesChanged: (_) {},
            ),
          ),
        );

        final flags = tester
            .getSemantics(find.text('List'))
            .getSemanticsData()
            .flagsCollection;
        expect(flags.isButton, isTrue);
        expect(flags.isToggled, Tristate.isTrue);
        expect(flags.isInMutuallyExclusiveGroup, isFalse);
      });

      testWidgets(
        'an icon option is named by its Text label or semanticLabel',
        (tester) async {
          await tester.pumpWidget(
            buildTestWidget(
              VToggleButtonGroup<String>(
                items: const [
                  VToggleButtonItem(
                    value: 'grid',
                    label: Text('Grid'),
                    icon: Text('G'),
                  ),
                  VToggleButtonItem(
                    value: 'list',
                    label: Text('List'),
                    icon: Text('L'),
                    semanticLabel: 'List view',
                  ),
                ],
                onChanged: (_) {},
              ),
            ),
          );

          expect(tester.getSemantics(find.text('G')).label, 'Grid');
          expect(tester.getSemantics(find.text('L')).label, 'List view');
        },
      );

      testWidgets('size sets the text and icon size', (tester) async {
        double? iconSize;
        await tester.pumpWidget(
          buildTestWidget(
            VToggleButtonGroup<String>(
              size: VToggleButtonSize.sm,
              items: [
                const VToggleButtonItem(value: 'grid', label: Text('Grid')),
                VToggleButtonItem(
                  value: 'list',
                  label: const Text('List'),
                  icon: Builder(
                    builder: (context) {
                      iconSize = IconTheme.of(context).size;
                      return const SizedBox(width: 10, height: 10);
                    },
                  ),
                ),
              ],
              onChanged: (_) {},
            ),
          ),
        );

        final grid = tester
            .widget<RichText>(
              find.descendant(
                of: find.text('Grid'),
                matching: find.byType(RichText),
              ),
            )
            .text
            .style!;
        expect(grid.fontSize, theme.sizes.sm.fontSize);
        expect(iconSize, theme.sizes.sm.iconSize);
      });
    });
  });
}
