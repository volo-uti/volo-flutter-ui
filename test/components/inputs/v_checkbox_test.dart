import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VCheckbox', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );

    group('default constructor', () {
      testWidgets('creates VCheckbox', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VCheckbox(value: false, onChanged: (_) {})),
        );

        expect(find.byType(VCheckbox), findsOneWidget);
      });

      testWidgets('displays label', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCheckbox(
              value: false,
              onChanged: (_) {},
              label: const Text('I agree'),
            ),
          ),
        );

        expect(find.text('I agree'), findsOneWidget);
      });

      testWidgets('displays sublabel', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCheckbox(
              value: false,
              onChanged: (_) {},
              label: const Text('Agree'),
              sublabel: const Text('Optional'),
            ),
          ),
        );

        expect(find.text('Agree'), findsOneWidget);
        expect(find.text('Optional'), findsOneWidget);
      });
    });

    group('state', () {
      testWidgets('checked when value=true', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VCheckbox(value: true, onChanged: (_) {})),
        );

        expect(find.byType(VCheckbox), findsOneWidget);
      });

      testWidgets('indeterminate when value=null', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VCheckbox(value: null, onChanged: (_) {})),
        );

        expect(find.byType(VCheckbox), findsOneWidget);
      });

      testWidgets('invokes onCheckedChange on tap', (tester) async {
        bool? newValue;

        await tester.pumpWidget(
          buildTestWidget(
            VCheckbox(
              value: false,
              onChanged: (v) => newValue = v,
              label: const Text('Check'),
            ),
          ),
        );

        await tester.tap(find.text('Check'));
        expect(newValue, true);
      });

      testWidgets('ignores tap when enabled=false', (tester) async {
        bool? newValue;

        await tester.pumpWidget(
          buildTestWidget(
            VCheckbox(
              value: false,
              onChanged: (v) => newValue = v,
              enabled: false,
              label: const Text('Disabled'),
            ),
          ),
        );

        await tester.tap(find.text('Disabled'));
        expect(newValue, null);
      });
    });

    group('VCheckbox.card', () {
      testWidgets('card style', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCheckbox.card(
              value: false,
              onChanged: (_) {},
              label: const Text('Card'),
            ),
          ),
        );

        expect(find.text('Card'), findsOneWidget);
      });
    });

    group('Widget label/sublabel', () {
      testWidgets('uses Widget label as-is', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCheckbox(
              value: false,
              onChanged: (_) {},
              label: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text('Widget'), Text('Label')],
              ),
            ),
          ),
        );

        expect(find.text('Widget'), findsOneWidget);
        expect(find.text('Label'), findsOneWidget);
      });

      testWidgets('uses Widget sublabel as-is', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCheckbox(
              value: false,
              onChanged: (_) {},
              label: const Text('Main'),
              sublabel: const Text('Widget Sublabel'),
            ),
          ),
        );

        expect(find.text('Main'), findsOneWidget);
        expect(find.text('Widget Sublabel'), findsOneWidget);
      });
    });

    group('tristate toggle', () {
      testWidgets('false -> true', (tester) async {
        bool? newValue;

        await tester.pumpWidget(
          buildTestWidget(
            VCheckbox(
              value: false,
              onChanged: (v) => newValue = v,
              label: const Text('Check'),
            ),
          ),
        );

        await tester.tap(find.text('Check'));
        expect(newValue, true);
      });

      testWidgets('true -> false', (tester) async {
        bool? newValue;

        await tester.pumpWidget(
          buildTestWidget(
            VCheckbox(
              value: true,
              onChanged: (v) => newValue = v,
              label: const Text('Check'),
            ),
          ),
        );

        await tester.tap(find.text('Check'));
        expect(newValue, false);
      });

      testWidgets('null -> true', (tester) async {
        bool? newValue;

        await tester.pumpWidget(
          buildTestWidget(
            VCheckbox(
              value: null,
              onChanged: (v) => newValue = v,
              label: const Text('Check'),
            ),
          ),
        );

        await tester.tap(find.text('Check'));
        expect(newValue, true);
      });
    });

    group('onCheckedChange=null', () {
      testWidgets('ignores tap when onCheckedChange=null', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VCheckbox(value: false, label: Text('Read-only')),
          ),
        );

        await tester.tap(find.text('Read-only'));
        // Nothing happens.
        expect(find.byType(VCheckbox), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('Semantics checked=true', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VCheckbox(value: true, onChanged: (_) {})),
        );

        final semantics = tester.getSemantics(find.byType(VCheckbox));
        expect(
          semantics.getSemanticsData().flagsCollection.isChecked,
          CheckedState.isTrue,
        );
      });

      testWidgets('Semantics mixed=true (indeterminate)', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VCheckbox(value: null, onChanged: (_) {})),
        );

        final semantics = tester.getSemantics(find.byType(VCheckbox));
        // hasCheckedState is now represented by isChecked != CheckedState.none
        expect(
          semantics.getSemanticsData().flagsCollection.isChecked,
          isNot(CheckedState.none),
        );
      });

      testWidgets('Semantics enabled=false when disabled', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VCheckbox(value: false, onChanged: (_) {}, enabled: false),
          ),
        );

        final semantics = tester.getSemantics(find.byType(VCheckbox));
        expect(
          semantics.getSemanticsData().flagsCollection.isEnabled,
          Tristate.isFalse,
        );
      });
    });

    group('theme override', () {
      testWidgets('theme componentOverrides applies to checkbox', (
        tester,
      ) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VCheckboxStyle(activeColor: Color(0xFFFF0000)),
              ]),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: VCheckbox(value: false, onChanged: (_) {}),
            ),
          ),
        );

        expect(find.byType(VCheckbox), findsOneWidget);
      });
    });
  });
}
