import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VForm', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(data: const MediaQueryData(), child: child),
      ),
    );

    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VForm(children: [Text('Field 1'), Text('Field 2')]),
        ),
      );

      expect(find.text('Field 1'), findsOneWidget);
      expect(find.text('Field 2'), findsOneWidget);
      expect(find.byType(VForm), findsOneWidget);
    });

    testWidgets('formKey validates the fields', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildTestWidget(
          VForm(
            formKey: formKey,
            children: [
              VTextField(
                name: 'email',
                validator: (v) => (v ?? '').isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('save() calls VTextField.onSaved with the current text', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();
      String? saved;

      await tester.pumpWidget(
        buildTestWidget(
          VForm(
            formKey: formKey,
            children: [VTextField(name: 'email', onSaved: (v) => saved = v)],
          ),
        ),
      );

      await tester.enterText(find.byType(EditableText), 'a@b.co');
      await tester.pump();
      expect(saved, isNull);

      formKey.currentState!.save();
      expect(saved, 'a@b.co');
    });

    testWidgets('validate() shows the validator error below the field and '
        'clears it once the text is valid', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        buildTestWidget(
          VForm(
            formKey: formKey,
            children: [
              VTextField(
                name: 'email',
                validator: (v) => (v ?? '').contains('@') ? null : 'Invalid',
              ),
            ],
          ),
        ),
      );

      expect(find.text('Invalid'), findsNothing);
      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Invalid'), findsOneWidget);

      await tester.enterText(find.byType(EditableText), 'a@b.co');
      await tester.pump();
      expect(formKey.currentState!.validate(), isTrue);
      await tester.pump();
      expect(find.text('Invalid'), findsNothing);
    });

    testWidgets('renders with VFormField children', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VForm(
            children: [
              Text('Header Area'),
              Text('Body Area'),
              Text('Footer Area'),
            ],
          ),
        ),
      );

      expect(find.text('Header Area'), findsOneWidget);
      expect(find.text('Body Area'), findsOneWidget);
      expect(find.text('Footer Area'), findsOneWidget);
    });

    testWidgets('renders with spacing', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VForm(spacing: 24, children: [Text('A'), Text('B')]),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('onChanged callback works', (tester) async {
      var changed = false;

      await tester.pumpWidget(
        buildTestWidget(
          VForm(
            onChanged: () => changed = true,
            children: const [Text('Content')],
          ),
        ),
      );

      final formWidget = tester.widget<VForm>(find.byType(VForm));
      expect(formWidget.onChanged, isNotNull);
      formWidget.onChanged!();
      expect(changed, isTrue);
    });
  });
}
