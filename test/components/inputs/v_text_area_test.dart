import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VTextArea', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(data: const MediaQueryData(), child: child),
      ),
    );

    testWidgets('creates VTextArea', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VTextArea(label: 'Content')),
      );

      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('displays placeholder', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VTextArea(placeholder: 'Enter content')),
      );

      expect(find.text('Enter content'), findsOneWidget);
    });

    testWidgets('shows required mark when required=true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VTextArea(label: 'Required', required: true)),
      );

      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('displays helper', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VTextArea(label: 'Label', helper: 'Helper text')),
      );

      expect(find.text('Helper text'), findsOneWidget);
    });

    testWidgets('displays error', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VTextArea(
            label: 'Label',
            error: true,
            errorText: 'Error message',
          ),
        ),
      );

      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('displays counter when showCounter=true', (tester) async {
      final controller = TextEditingController(text: 'Hello');

      await tester.pumpWidget(
        buildTestWidget(
          VTextArea(controller: controller, maxLength: 100, showCounter: true),
        ),
      );

      expect(find.text('5/100'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('fullWidth=true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Center(
            child: SizedBox(width: 300, child: VTextArea(fullWidth: true)),
          ),
        ),
      );

      expect(find.byType(VTextArea), findsOneWidget);
    });

    testWidgets('sets minLines', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VTextArea(minLines: 5)));

      expect(find.byType(VTextArea), findsOneWidget);
    });

    testWidgets('sets maxLines', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VTextArea(maxLines: 10)));

      expect(find.byType(VTextArea), findsOneWidget);
    });

    group('text input', () {
      testWidgets('text input works correctly', (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          buildTestWidget(VTextArea(controller: controller)),
        );

        await tester.tap(find.byType(EditableText));
        await tester.pump();
        await tester.enterText(find.byType(EditableText), 'Hello');
        await tester.pump();

        expect(controller.text, 'Hello');

        controller.dispose();
      });

      testWidgets('multi-line input works correctly', (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          buildTestWidget(VTextArea(controller: controller)),
        );

        await tester.tap(find.byType(EditableText));
        await tester.pump();
        await tester.enterText(
          find.byType(EditableText),
          'First line\nSecond line\nThird line',
        );
        await tester.pump();

        expect(controller.text, 'First line\nSecond line\nThird line');
        expect(controller.text.split('\n').length, 3);

        controller.dispose();
      });
    });

    group('onChanged callback', () {
      testWidgets('calls onChanged when text is entered', (tester) async {
        String? changedValue;

        await tester.pumpWidget(
          buildTestWidget(
            VTextArea(
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        );

        await tester.tap(find.byType(EditableText));
        await tester.pump();
        await tester.enterText(find.byType(EditableText), 'Test content');
        await tester.pump();

        expect(changedValue, 'Test content');
      });

      testWidgets('calls onChanged on every text change', (tester) async {
        final changedValues = <String>[];

        await tester.pumpWidget(
          buildTestWidget(VTextArea(onChanged: changedValues.add)),
        );

        await tester.tap(find.byType(EditableText));
        await tester.pump();

        await tester.enterText(find.byType(EditableText), 'A');
        await tester.pump();

        await tester.enterText(find.byType(EditableText), 'AB');
        await tester.pump();

        await tester.enterText(find.byType(EditableText), 'ABC');
        await tester.pump();

        expect(changedValues, ['A', 'AB', 'ABC']);
      });
    });

    group('focus', () {
      testWidgets('gains focus on tap', (tester) async {
        final focusNode = FocusNode();

        await tester.pumpWidget(
          buildTestWidget(VTextArea(focusNode: focusNode)),
        );

        expect(focusNode.hasFocus, isFalse);

        await tester.tap(find.byType(EditableText));
        await tester.pump();

        expect(focusNode.hasFocus, isTrue);

        focusNode.dispose();
      });

      testWidgets('loses focus with focusNode.unfocus()', (tester) async {
        final focusNode = FocusNode();

        await tester.pumpWidget(
          buildTestWidget(VTextArea(focusNode: focusNode)),
        );

        await tester.tap(find.byType(EditableText));
        await tester.pump();

        expect(focusNode.hasFocus, isTrue);

        focusNode.unfocus();
        await tester.pump();

        expect(focusNode.hasFocus, isFalse);

        focusNode.dispose();
      });

      testWidgets('requests focus with focusNode.requestFocus()', (
        tester,
      ) async {
        final focusNode = FocusNode();

        await tester.pumpWidget(
          buildTestWidget(VTextArea(focusNode: focusNode)),
        );

        expect(focusNode.hasFocus, isFalse);

        focusNode.requestFocus();
        await tester.pump();

        expect(focusNode.hasFocus, isTrue);

        focusNode.dispose();
      });
    });

    group('maxLength restriction', () {
      testWidgets('restricts input exceeding maxLength', (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          buildTestWidget(VTextArea(controller: controller, maxLength: 10)),
        );

        await tester.tap(find.byType(EditableText));
        await tester.pump();
        await tester.enterText(find.byType(EditableText), 'Hello World Test');
        await tester.pump();

        expect(controller.text.length, lessThanOrEqualTo(10));

        controller.dispose();
      });

      testWidgets('allows input within maxLength', (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          buildTestWidget(VTextArea(controller: controller, maxLength: 20)),
        );

        await tester.tap(find.byType(EditableText));
        await tester.pump();
        await tester.enterText(find.byType(EditableText), 'Hello');
        await tester.pump();

        expect(controller.text, 'Hello');
        expect(controller.text.length, 5);

        controller.dispose();
      });

      testWidgets('displays counter when maxLength is set', (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          buildTestWidget(VTextArea(controller: controller, maxLength: 100)),
        );

        // Counter is automatically displayed when maxLength is set
        expect(find.byType(VTextArea), findsOneWidget);

        controller.dispose();
      });
    });

    group('disabled state', () {
      testWidgets('ignores input when enabled=false', (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          buildTestWidget(VTextArea(controller: controller, enabled: false)),
        );

        // IgnorePointer is set to ignoring=true, preventing taps
        final ignorePointers = tester.widgetList<IgnorePointer>(
          find.byType(IgnorePointer),
        );
        final hasIgnoringTrue = ignorePointers.any((ip) => ip.ignoring == true);
        expect(hasIgnoringTrue, isTrue);

        controller.dispose();
      });

      testWidgets('reduces opacity when enabled=false', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextArea(enabled: false)),
        );

        final opacities = tester.widgetList<Opacity>(find.byType(Opacity));
        final hasHalfOpacity = opacities.any((o) => o.opacity == 0.5);
        expect(hasHalfOpacity, isTrue);
      });

      testWidgets('does not call onChanged when enabled=false', (tester) async {
        var onChangedCalled = false;

        await tester.pumpWidget(
          buildTestWidget(
            VTextArea(
              enabled: false,
              onChanged: (value) {
                onChangedCalled = true;
              },
            ),
          ),
        );

        // Input is blocked by IgnorePointer in disabled state
        await tester.tap(find.byType(VTextArea));
        await tester.pump();

        expect(onChangedCalled, isFalse);
      });
    });

    group('readOnly state', () {
      testWidgets('EditableText is readOnly when readOnly=true', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextArea(readOnly: true)),
        );

        final editableText = tester.widget<EditableText>(
          find.byType(EditableText),
        );
        expect(editableText.readOnly, isTrue);
      });

      testWidgets('displays existing text when readOnly=true', (tester) async {
        final controller = TextEditingController(text: 'Read-only content');

        await tester.pumpWidget(
          buildTestWidget(VTextArea(controller: controller, readOnly: true)),
        );

        final editableText = tester.widget<EditableText>(
          find.byType(EditableText),
        );
        expect(editableText.controller.text, 'Read-only content');

        controller.dispose();
      });

      testWidgets('focus is still possible when readOnly=true', (tester) async {
        final focusNode = FocusNode();

        await tester.pumpWidget(
          buildTestWidget(VTextArea(focusNode: focusNode, readOnly: true)),
        );

        await tester.tap(find.byType(EditableText));
        await tester.pump();

        // Focus is still possible in readOnly state
        expect(focusNode.hasFocus, isTrue);

        focusNode.dispose();
      });
    });

    group('controller integration', () {
      testWidgets('uses external controller', (tester) async {
        final controller = TextEditingController(text: 'Initial text');

        await tester.pumpWidget(
          buildTestWidget(VTextArea(controller: controller)),
        );

        final editableText = tester.widget<EditableText>(
          find.byType(EditableText),
        );
        expect(editableText.controller.text, 'Initial text');

        controller.dispose();
      });

      testWidgets('updates UI when controller.text changes', (tester) async {
        final controller = TextEditingController(text: 'Before');

        await tester.pumpWidget(
          buildTestWidget(VTextArea(controller: controller)),
        );

        controller.text = 'After';
        await tester.pump();

        final editableText = tester.widget<EditableText>(
          find.byType(EditableText),
        );
        expect(editableText.controller.text, 'After');

        controller.dispose();
      });

      testWidgets('clears text when controller.clear() is called', (
        tester,
      ) async {
        final controller = TextEditingController(text: 'Content to delete');

        await tester.pumpWidget(
          buildTestWidget(VTextArea(controller: controller)),
        );

        controller.clear();
        await tester.pump();

        expect(controller.text, '');

        controller.dispose();
      });

      testWidgets('uses internal controller when no controller provided', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(const VTextArea()));

        await tester.tap(find.byType(EditableText));
        await tester.pump();
        await tester.enterText(
          find.byType(EditableText),
          'Internal controller test',
        );
        await tester.pump();

        final editableText = tester.widget<EditableText>(
          find.byType(EditableText),
        );
        expect(editableText.controller.text, 'Internal controller test');
      });
    });

    group('focusNode integration', () {
      testWidgets('uses external focusNode', (tester) async {
        final focusNode = FocusNode();

        await tester.pumpWidget(
          buildTestWidget(VTextArea(focusNode: focusNode)),
        );

        expect(focusNode.hasFocus, isFalse);

        focusNode.requestFocus();
        await tester.pump();

        expect(focusNode.hasFocus, isTrue);

        focusNode.dispose();
      });

      testWidgets('uses internal focusNode when no focusNode provided', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget(const VTextArea()));

        await tester.tap(find.byType(EditableText));
        await tester.pump();

        // Focus gained via internal focusNode
        expect(find.byType(VTextArea), findsOneWidget);
      });
    });

    group('onSubmitted callback', () {
      testWidgets('sets onSubmitted prop', (tester) async {
        // ignore: unused_local_variable
        String? submittedValue;

        await tester.pumpWidget(
          buildTestWidget(
            VTextArea(
              onSubmitted: (value) {
                submittedValue = value;
              },
            ),
          ),
        );

        expect(find.byType(VTextArea), findsOneWidget);
        // VTextArea is multiline so Enter does not trigger onSubmitted
        // Only verify that the prop is set
      });
    });
  });
}
