import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

const _decrement = ValueKey('VNumberStepper.decrement');
const _increment = ValueKey('VNumberStepper.increment');

Widget _wrap(Widget child, {VThemeData? theme}) => VTheme(
  data: theme ?? VThemeData.light(),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Center(child: child),
  ),
);

/// Holds the value like an app would and passes it back to the stepper.
class _Host extends StatefulWidget {
  const _Host({required this.initial, this.max});

  final int initial;
  final int? max;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late int value = widget.initial;

  @override
  Widget build(BuildContext context) => VNumberStepper(
    value: value,
    max: widget.max,
    onChanged: (v) => setState(() => value = v),
  );
}

void main() {
  group('VNumberStepper', () {
    testWidgets('steps a held value until max turns the plus button off', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const _Host(initial: 1, max: 3)));
      expect(find.text('1'), findsOneWidget);

      for (var i = 0; i < 4; i++) {
        await tester.tap(find.byKey(_increment), warnIfMissed: false);
        await tester.pumpAndSettle();
      }
      expect(find.text('3'), findsOneWidget);

      await tester.tap(find.byKey(_decrement));
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('takes a negative min', (tester) async {
      final calls = <int>[];
      await tester.pumpWidget(
        _wrap(VNumberStepper(value: -4, min: -5, onChanged: calls.add)),
      );
      await tester.tap(find.byKey(_decrement));
      await tester.pumpAndSettle();
      expect(calls, [-5]);
    });

    testWidgets('screen reader actions follow the range ends', (tester) async {
      final semantics = tester.ensureSemantics();
      final calls = <int>[];
      await tester.pumpWidget(
        _wrap(
          VNumberStepper(
            value: 9,
            max: 10,
            step: 3,
            semanticLabel: 'Seats',
            onChanged: calls.add,
          ),
        ),
      );
      final node = tester.getSemantics(find.byType(VNumberStepper));
      final data = node.getSemanticsData();
      expect(data.label, 'Seats');
      expect(data.value, '9');
      expect(data.increasedValue, '10');
      expect(data.decreasedValue, '6');
      node.owner!.performAction(node.id, SemanticsAction.increase);
      expect(calls, [10]);
      semantics.dispose();
    });

    testWidgets('both buttons keep the minimum tap target at xs', (
      tester,
    ) async {
      final theme = VThemeData.light();
      await tester.pumpWidget(
        _wrap(
          VNumberStepper(
            value: 1,
            size: VNumberStepperSize.xs,
            onChanged: (_) {},
          ),
          theme: theme,
        ),
      );
      for (final key in [_decrement, _increment]) {
        final size = tester.getSize(find.byKey(key));
        expect(size.width, greaterThanOrEqualTo(theme.minTapTargetSize));
        expect(size.height, greaterThanOrEqualTo(theme.minTapTargetSize));
      }
    });

    testWidgets('applies the instance style over the theme style', (
      tester,
    ) async {
      const themeColor = Color(0xFF112233);
      const ownColor = Color(0xFF445566);
      await tester.pumpWidget(
        _wrap(
          VNumberStepper(
            value: 7,
            onChanged: (_) {},
            style: const VNumberStepperStyle(
              foregroundColor: ownColor,
              spacing: 20,
              valueMinWidth: 80,
              textStyle: TextStyle(fontSize: 30),
            ),
          ),
          theme: VThemeData.light().copyWith(
            componentOverrides: const VComponentOverrides([
              VNumberStepperStyle(foregroundColor: themeColor, spacing: 2),
            ]),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('7'));
      expect(text.style!.color, ownColor);
      expect(text.style!.fontSize, 30);
      expect(
        tester
            .getSize(
              find
                  .ancestor(
                    of: find.text('7'),
                    matching: find.byType(ConstrainedBox),
                  )
                  .first,
            )
            .width,
        greaterThanOrEqualTo(80),
      );
      final gap =
          tester.getTopLeft(find.text('7')).dx -
          tester.getTopRight(find.byKey(_decrement)).dx;
      expect(gap, greaterThanOrEqualTo(20));
    });

    test('merge lets the other style win and keeps the rest', () {
      const base = VNumberStepperStyle(spacing: 4, valueMinWidth: 10);
      const over = VNumberStepperStyle(spacing: 8);
      expect(
        base.merge(over),
        const VNumberStepperStyle(spacing: 8, valueMinWidth: 10),
      );
      expect(base.merge(null), base);
      expect(base.copyWith(spacing: 1).spacing, 1);
    });
  });
}
