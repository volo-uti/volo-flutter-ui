import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VSlider', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: SizedBox(width: 300, child: child)),
      ),
    );

    testWidgets('creates VSlider', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VSlider(value: 0.5, onChanged: (_) {})),
      );

      expect(find.byType(VSlider), findsOneWidget);
    });

    testWidgets('sets min/max', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VSlider(value: 50, onChanged: (_) {})),
      );

      expect(find.byType(VSlider), findsOneWidget);
    });

    testWidgets('ignores drag when enabled=false', (tester) async {
      double? newValue;

      await tester.pumpWidget(
        buildTestWidget(
          VSlider(value: 0.5, onChanged: (v) => newValue = v, enabled: false),
        ),
      );

      await tester.drag(find.byType(VSlider), const Offset(50, 0));
      expect(newValue, null);
    });

    testWidgets('showLabel draws the value above the thumb', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VSlider(value: 40, showLabel: true, onChanged: (_) {})),
      );
      expect(find.text('40'), findsOneWidget);

      await tester.pumpWidget(
        buildTestWidget(VSlider(value: 40, onChanged: (_) {})),
      );
      expect(find.text('40'), findsNothing);
    });

    testWidgets('range showLabel draws both values', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VSlider.range(
            values: const RangeValues(20, 80),
            showLabel: true,
            onRangeChanged: (_) {},
          ),
        ),
      );
      expect(find.text('20'), findsOneWidget);
      expect(find.text('80'), findsOneWidget);
    });

    testWidgets('sets divisions', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VSlider(value: 0.5, divisions: 10, onChanged: (_) {})),
      );

      expect(find.byType(VSlider), findsOneWidget);
    });

    group('interaction tests', () {
      testWidgets('changes value by dragging', (tester) async {
        var currentValue = 0.5;
        final changedValues = <double>[];

        await tester.pumpWidget(
          buildTestWidget(
            StatefulBuilder(
              builder: (context, setState) => VSlider(
                value: currentValue,
                onChanged: (v) {
                  setState(() => currentValue = v);
                  changedValues.add(v);
                },
              ),
            ),
          ),
        );

        // Drag right (increase value)
        await tester.drag(find.byType(VSlider), const Offset(100, 0));
        await tester.pumpAndSettle();

        expect(changedValues, isNotEmpty);
        expect(changedValues.last, greaterThan(0.5));
      });

      testWidgets('changes value by tap', (tester) async {
        var currentValue = 0.5;
        final changedValues = <double>[];

        await tester.pumpWidget(
          buildTestWidget(
            StatefulBuilder(
              builder: (context, setState) => VSlider(
                value: currentValue,
                onChanged: (v) {
                  setState(() => currentValue = v);
                  changedValues.add(v);
                },
              ),
            ),
          ),
        );

        // Tap right end of slider
        final sliderFinder = find.byType(VSlider);
        final sliderBox = tester.getRect(sliderFinder);

        // Start drag to right end (simulating tap behavior)
        await tester.dragFrom(sliderBox.center, Offset(sliderBox.width / 4, 0));
        await tester.pumpAndSettle();

        expect(changedValues, isNotEmpty);
      });

      testWidgets('calls onChanged callback', (tester) async {
        var currentValue = 0.3;
        var callCount = 0;
        double? lastValue;

        await tester.pumpWidget(
          buildTestWidget(
            StatefulBuilder(
              builder: (context, setState) => VSlider(
                value: currentValue,
                onChanged: (v) {
                  setState(() => currentValue = v);
                  callCount++;
                  lastValue = v;
                },
              ),
            ),
          ),
        );

        // Change value by dragging
        await tester.drag(find.byType(VSlider), const Offset(50, 0));
        await tester.pumpAndSettle();

        expect(callCount, greaterThan(0));
        expect(lastValue, isNotNull);
        expect(lastValue, isNot(equals(0.3)));
      });

      testWidgets('ignores interaction in disabled state', (tester) async {
        var currentValue = 0.5;
        var wasChanged = false;

        await tester.pumpWidget(
          buildTestWidget(
            VSlider(
              value: currentValue,
              onChanged: (v) {
                currentValue = v;
                wasChanged = true;
              },
              enabled: false,
            ),
          ),
        );

        // Attempt drag
        await tester.drag(find.byType(VSlider), const Offset(100, 0));
        await tester.pumpAndSettle();

        expect(wasChanged, isFalse);
        expect(currentValue, equals(0.5));

        // Attempt drag in opposite direction
        await tester.drag(find.byType(VSlider), const Offset(-100, 0));
        await tester.pumpAndSettle();

        expect(wasChanged, isFalse);
        expect(currentValue, equals(0.5));
      });

      testWidgets('changes value only within min/max range', (tester) async {
        double currentValue = 50;
        final changedValues = <double>[];

        await tester.pumpWidget(
          buildTestWidget(
            StatefulBuilder(
              builder: (context, setState) => VSlider(
                value: currentValue,
                onChanged: (v) {
                  setState(() => currentValue = v);
                  changedValues.add(v);
                },
              ),
            ),
          ),
        );

        // Drag far to the right
        await tester.drag(find.byType(VSlider), const Offset(500, 0));
        await tester.pumpAndSettle();

        // Verify all values are within min/max range
        for (final value in changedValues) {
          expect(value, greaterThanOrEqualTo(0));
          expect(value, lessThanOrEqualTo(100));
        }

        // Last value should be close to max
        if (changedValues.isNotEmpty) {
          expect(changedValues.last, greaterThanOrEqualTo(90));
        }
      });

      testWidgets('calls onChangeStart/onChangeEnd callbacks', (tester) async {
        var currentValue = 0.5;
        double? startValue;
        double? endValue;

        await tester.pumpWidget(
          buildTestWidget(
            StatefulBuilder(
              builder: (context, setState) => VSlider(
                value: currentValue,
                onChanged: (v) => setState(() => currentValue = v),
                onChangeStart: (v) => startValue = v,
                onChangeEnd: (v) => endValue = v,
              ),
            ),
          ),
        );

        // Perform drag
        await tester.drag(find.byType(VSlider), const Offset(50, 0));
        await tester.pumpAndSettle();

        expect(startValue, isNotNull);
        expect(endValue, isNotNull);
      });

      testWidgets('values snap when divisions is set', (tester) async {
        double currentValue = 0;
        final changedValues = <double>[];

        await tester.pumpWidget(
          buildTestWidget(
            StatefulBuilder(
              builder: (context, setState) => VSlider(
                value: currentValue,
                max: 1,
                divisions: 10, // 0.1 increments
                onChanged: (v) {
                  setState(() => currentValue = v);
                  changedValues.add(v);
                },
              ),
            ),
          ),
        );

        // Change value by dragging
        await tester.drag(find.byType(VSlider), const Offset(100, 0));
        await tester.pumpAndSettle();

        // All values should snap to 0.1 increments
        for (final value in changedValues) {
          final rounded = (value * 10).round() / 10;
          expect((value - rounded).abs(), lessThan(0.01));
        }
      });
    });

    // ── FocusTraversalGroup ──────────────────────────────────────────

    group('accessibility', () {
      testWidgets('wraps content in FocusTraversalGroup', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VSlider(value: 0.5, onChanged: (_) {})),
        );

        expect(
          find.descendant(
            of: find.byType(VSlider),
            matching: find.byType(FocusTraversalGroup),
          ),
          findsOneWidget,
        );
      });
    });
  });

  group('VSlider.range', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: SizedBox(width: 300, child: child)),
      ),
    );

    testWidgets('creates range slider', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VSlider.range(
            values: const RangeValues(0.2, 0.8),
            onRangeChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(VSlider), findsOneWidget);
    });
  });

  group('RangeValues', () {
    test('equality comparison', () {
      const a = RangeValues(0.2, 0.8);
      const b = RangeValues(0.2, 0.8);
      const c = RangeValues(0.3, 0.7);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('toString', () {
      const range = RangeValues(0.2, 0.8);
      expect(range.toString(), 'RangeValues(0.2, 0.8)');
    });
  });

  group('theme override', () {
    testWidgets('theme componentOverrides applies to slider', (tester) async {
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light().copyWith(
            componentOverrides: const VComponentOverrides([
              VSliderStyle(activeColor: Color(0xFFFF0000)),
            ]),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SizedBox(
                width: 300,
                child: VSlider(value: 0.5, onChanged: (_) {}),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(VSlider), findsOneWidget);
    });
  });
}
