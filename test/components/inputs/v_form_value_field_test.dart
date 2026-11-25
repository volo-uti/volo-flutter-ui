import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

Widget _wrap(Widget child) => VTheme(
  data: VThemeData.light(),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Center(child: SizedBox(width: 400, child: child)),
  ),
);

void main() {
  group('VFormValueField', () {
    testWidgets('shows the label, the required mark and the helper', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          VForm(
            children: [
              VFormValueField<int>(
                label: 'Guests',
                required: true,
                helper: 'How many people come',
                initialValue: 2,
                builder: (state) => Text('guests ${state.value}'),
              ),
            ],
          ),
        ),
      );

      expect(find.textContaining('Guests'), findsOneWidget);
      expect(find.textContaining('*'), findsOneWidget);
      expect(find.text('How many people come'), findsOneWidget);
      expect(find.text('guests 2'), findsOneWidget);
    });

    testWidgets('validates, saves and resets with a widgets Form', (
      tester,
    ) async {
      final key = GlobalKey<FormState>();
      late FormFieldState<int> field;
      int? saved;
      await tester.pumpWidget(
        _wrap(
          Form(
            key: key,
            child: VFormValueField<int>(
              label: 'Guests',
              helper: 'At least one',
              initialValue: 1,
              validator: (v) => (v ?? 0) < 1 ? 'Add a guest' : null,
              onSaved: (v) => saved = v,
              builder: (state) {
                field = state;
                return Text('guests ${state.value}');
              },
            ),
          ),
        ),
      );

      field.didChange(0);
      expect(key.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();
      expect(find.text('Add a guest'), findsOneWidget);
      expect(find.text('At least one'), findsNothing);

      field.didChange(3);
      expect(key.currentState!.validate(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Add a guest'), findsNothing);

      key.currentState!.save();
      expect(saved, 3);

      key.currentState!.reset();
      await tester.pumpAndSettle();
      expect(find.text('guests 1'), findsOneWidget);
    });

    testWidgets('validates on change with AutovalidateMode.onUserInteraction', (
      tester,
    ) async {
      late FormFieldState<String> field;
      await tester.pumpWidget(
        _wrap(
          VForm(
            children: [
              VFormValueField<String>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (v) => (v ?? '').isEmpty ? 'Required' : null,
                builder: (state) {
                  field = state;
                  return Text('v:${state.value}');
                },
              ),
            ],
          ),
        ),
      );

      expect(find.text('Required'), findsNothing);
      field.didChange('');
      await tester.pumpAndSettle();
      expect(find.text('Required'), findsOneWidget);
    });
  });
}
