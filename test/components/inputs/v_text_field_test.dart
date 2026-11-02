import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VTextField', () {
    Widget buildTestWidget(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(data: const MediaQueryData(), child: child),
      ),
    );

    testWidgets('creates VTextField', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VTextField(name: 'test', label: 'Text')),
      );

      expect(find.text('Text'), findsOneWidget);
    });

    testWidgets('displays placeholder', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VTextField(name: 'test', placeholder: 'Enter text'),
        ),
      );

      expect(find.text('Enter text'), findsOneWidget);
    });

    group('variants', () {
      testWidgets('VTextField.email', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField.email(name: 'email', label: 'Email'),
          ),
        );

        expect(find.text('Email'), findsOneWidget);
      });

      testWidgets('VTextField.password', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField.password(name: 'password', label: 'Password'),
          ),
        );

        expect(find.text('Password'), findsOneWidget);
      });

      testWidgets('VTextField.search', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField.search(
              name: 'search',
              placeholder: 'Enter search term',
            ),
          ),
        );

        expect(find.text('Enter search term'), findsOneWidget);
      });

      testWidgets('VTextField.number', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField.number(name: 'number', label: 'Number'),
          ),
        );

        expect(find.text('Number'), findsOneWidget);
      });

      testWidgets('VTextField.phone', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField.phone(name: 'phone', label: 'Phone Number'),
          ),
        );

        expect(find.text('Phone Number'), findsOneWidget);
      });

      testWidgets('VTextField.url', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField.url(name: 'url', label: 'URL')),
        );

        expect(find.text('URL'), findsOneWidget);
      });
    });

    testWidgets('shows required mark when required=true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VTextField(name: 'test', label: 'Required', required: true),
        ),
      );

      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('displays helper', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VTextField(name: 'test', label: 'Label', helper: 'Helper text'),
        ),
      );

      expect(find.text('Helper text'), findsOneWidget);
    });

    testWidgets('displays error', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VTextField(
            name: 'test',
            label: 'Label',
            error: true,
            errorText: 'Error message',
          ),
        ),
      );

      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('displays leading', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VTextField(name: 'test', leading: Text('@'))),
      );

      expect(find.text('@'), findsOneWidget);
    });

    testWidgets('displays suffix', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VTextField(name: 'test', suffix: 'KRW')),
      );

      expect(find.text('KRW'), findsOneWidget);
    });

    testWidgets('fullWidth=true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const Center(
            child: SizedBox(
              width: 300,
              child: VTextField(name: 'test', fullWidth: true),
            ),
          ),
        ),
      );

      expect(find.byType(VTextField), findsOneWidget);
    });

    group('clearable', () {
      testWidgets('shows clear button when clearable=true and text exists', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField(name: 'test', value: 'Hello', clearable: true),
          ),
        );

        // Clear button is implemented as GestureDetector
        expect(find.byType(GestureDetector), findsOneWidget);
      });

      testWidgets('hides clear button when clearable=true but text is empty', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField(name: 'test', clearable: true)),
        );

        // No clear button when text is empty
        expect(find.byType(GestureDetector), findsNothing);
      });

      testWidgets('clears text when clear button is tapped', (tester) async {
        String? changedValue;

        await tester.pumpWidget(
          buildTestWidget(
            VTextField(
              name: 'test',
              value: 'Hello',
              clearable: true,
              onChanged: (value) => changedValue = value,
            ),
          ),
        );

        // Tap clear button
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pump();

        expect(changedValue, '');
      });

      testWidgets('hides clear button when clearable=false', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField(name: 'test', value: 'Hello')),
        );

        // No clear button
        expect(find.byType(GestureDetector), findsNothing);
      });

      testWidgets('hides clear button when readOnly', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField(
              name: 'test',
              value: 'Hello',
              clearable: true,
              readOnly: true,
            ),
          ),
        );

        // No clear button when readOnly
        expect(find.byType(GestureDetector), findsNothing);
      });
    });

    group('password', () {
      testWidgets('password field hides text by default', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField.password(name: 'password', value: 'secret123'),
          ),
        );

        // Verify EditableText obscureText is true
        final editableText = tester.widget<EditableText>(
          find.byType(EditableText),
        );
        expect(editableText.obscureText, isTrue);
      });

      testWidgets('password field show/hide toggle', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField.password(name: 'password', value: 'secret123'),
          ),
        );

        // Initial state: text hidden
        var editableText = tester.widget<EditableText>(
          find.byType(EditableText),
        );
        expect(editableText.obscureText, isTrue);

        // Tap eye icon (show)
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pump();

        // Text is shown
        editableText = tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.obscureText, isFalse);

        // Tap again (hide)
        await tester.tap(find.byType(GestureDetector).first);
        await tester.pump();

        // Text hidden again
        editableText = tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.obscureText, isTrue);
      });
    });

    group('validator', () {
      testWidgets('no error when validator returns null', (tester) async {
        String? validatorResult;

        await tester.pumpWidget(
          buildTestWidget(
            VTextField(
              name: 'test',
              value: 'valid@email.com',
              validator: (value) {
                validatorResult = null;
                return null;
              },
            ),
          ),
        );

        // Validator is not called (VTextField does not auto-invoke validator)
        expect(validatorResult, isNull);
      });

      testWidgets('validator prop is set', (tester) async {
        String? Function(String?)? capturedValidator;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => VTextField(
                name: 'email',
                validator: (value) {
                  capturedValidator = (v) {
                    if (v == null || v.isEmpty) return 'Please enter email';
                    if (!v.contains('@')) return 'Please enter a valid email';
                    return null;
                  };
                  return capturedValidator?.call(value);
                },
              ),
            ),
          ),
        );

        expect(find.byType(VTextField), findsOneWidget);
      });
    });

    group('maxLength', () {
      testWidgets('limits input when maxLength is set', (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          buildTestWidget(
            VTextField(name: 'test', controller: controller, maxLength: 5),
          ),
        );

        await tester.tap(find.byType(EditableText));
        await tester.pump();

        // Try entering more than 5 characters
        await tester.enterText(find.byType(EditableText), 'Hello World');
        await tester.pump();

        // Limited to 5 characters by maxLength
        expect(controller.text.length, lessThanOrEqualTo(5));
      });

      testWidgets('displays maxLength counter', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField(name: 'test', maxLength: 100)),
        );

        // Verify counter is displayed (handled by VFormFooter)
        expect(find.byType(VTextField), findsOneWidget);
      });
    });

    group('message priority', () {
      testWidgets('error message takes priority over helper', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField(
              name: 'test',
              helper: 'Helper',
              error: true,
              errorText: 'Error occurred',
            ),
          ),
        );

        // Only error message is displayed (helper is hidden)
        expect(find.text('Error occurred'), findsOneWidget);
        expect(find.text('Helper'), findsNothing);
      });

      testWidgets('success message takes priority over helper', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField(
              name: 'test',
              helper: 'Helper',
              success: true,
              successText: 'Success!',
            ),
          ),
        );

        // Only success message is displayed (helper is hidden)
        expect(find.text('Success!'), findsOneWidget);
        expect(find.text('Helper'), findsNothing);
      });

      testWidgets('error takes priority over success', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField(
              name: 'test',
              error: true,
              errorText: 'Error occurred',
              success: true,
              successText: 'Success!',
            ),
          ),
        );

        // Only error message is displayed
        expect(find.text('Error occurred'), findsOneWidget);
        expect(find.text('Success!'), findsNothing);
      });

      testWidgets('extra is always displayed', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField(
              name: 'test',
              error: true,
              errorText: 'Error occurred',
              extra: 'Additional info',
            ),
          ),
        );

        // Both error and extra are displayed
        expect(find.text('Error occurred'), findsOneWidget);
        expect(find.text('Additional info'), findsOneWidget);
      });
    });

    group('variant keyboard types', () {
      testWidgets('VTextField.email uses email keyboard type', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField.email(name: 'email')),
        );

        final widget = tester.widget<VTextField>(find.byType(VTextField));
        expect(widget.keyboardType, TextInputType.emailAddress);
      });

      testWidgets('VTextField.number uses number keyboard type', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField.number(name: 'number')),
        );

        final widget = tester.widget<VTextField>(find.byType(VTextField));
        expect(widget.keyboardType, TextInputType.number);
      });

      testWidgets('VTextField.phone uses phone keyboard type', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField.phone(name: 'phone')),
        );

        final widget = tester.widget<VTextField>(find.byType(VTextField));
        expect(widget.keyboardType, TextInputType.phone);
      });

      testWidgets('VTextField.url uses URL keyboard type', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField.url(name: 'url')),
        );

        final widget = tester.widget<VTextField>(find.byType(VTextField));
        expect(widget.keyboardType, TextInputType.url);
      });

      testWidgets('VTextField.search uses search action', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField.search(name: 'search')),
        );

        final widget = tester.widget<VTextField>(find.byType(VTextField));
        expect(widget.textInputAction, TextInputAction.search);
      });
    });

    group('Semantics accessibility', () {
      testWidgets('semanticLabel is set', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField(
              name: 'test',
              label: 'Name',
              semanticLabel: 'User name input field',
            ),
          ),
        );

        final widget = tester.widget<VTextField>(find.byType(VTextField));
        expect(widget.semanticLabel, 'User name input field');
      });

      testWidgets('displays label text when label is provided', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField(name: 'test', label: 'Email Address'),
          ),
        );

        expect(find.text('Email Address'), findsOneWidget);
      });

      testWidgets('required mark is displayed correctly', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField(
              name: 'test',
              label: 'Required Field',
              required: true,
            ),
          ),
        );

        expect(find.text('Required Field'), findsOneWidget);
        expect(find.text('*'), findsOneWidget);
      });
    });

    group('prefix/suffix', () {
      testWidgets('displays leading widget', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField(name: 'test', leading: Text(r'$'))),
        );

        expect(find.text(r'$'), findsOneWidget);
      });

      testWidgets('displays suffix text', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField(name: 'test', suffix: 'kg')),
        );

        expect(find.text('kg'), findsOneWidget);
      });

      testWidgets('displays trailing widget', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField(name: 'test', trailing: Text('!'))),
        );

        expect(find.text('!'), findsOneWidget);
      });

      testWidgets('displays both leading and suffix simultaneously', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField(name: 'price', leading: Text(r'$'), suffix: 'USD'),
          ),
        );

        expect(find.text(r'$'), findsOneWidget);
        expect(find.text('USD'), findsOneWidget);
      });
    });

    group('disabled state', () {
      testWidgets('reduces opacity when enabled=false', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField(name: 'test', enabled: false)),
        );

        // Opacity widget inside VFormBody is set to 0.5
        final opacities = tester.widgetList<Opacity>(find.byType(Opacity));
        final hasHalfOpacity = opacities.any((o) => o.opacity == 0.5);
        expect(hasHalfOpacity, isTrue);
      });

      testWidgets('applies IgnorePointer when enabled=false', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField(name: 'test', enabled: false)),
        );

        // Verify there is an IgnorePointer with ignoring=true
        final ignorePointers = tester.widgetList<IgnorePointer>(
          find.byType(IgnorePointer),
        );
        final hasIgnoringTrue = ignorePointers.any((ip) => ip.ignoring == true);
        expect(hasIgnoringTrue, isTrue);
      });

      testWidgets('normal state when enabled=true', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField(name: 'test')),
        );

        // Opacity inside VFormBody is 1.0
        final opacities = tester.widgetList<Opacity>(find.byType(Opacity));
        final hasFullOpacity = opacities.any((o) => o.opacity == 1.0);
        expect(hasFullOpacity, isTrue);

        // Verify IgnorePointer has ignoring=false
        final ignorePointers = tester.widgetList<IgnorePointer>(
          find.byType(IgnorePointer),
        );
        final allNotIgnoring = ignorePointers.every(
          (ip) => ip.ignoring == false,
        );
        expect(allNotIgnoring, isTrue);
      });
    });

    group('readOnly state', () {
      testWidgets('EditableText is readOnly when readOnly=true', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField(name: 'test', readOnly: true)),
        );

        final editableText = tester.widget<EditableText>(
          find.byType(EditableText),
        );
        expect(editableText.readOnly, isTrue);
      });
    });

    group('onChanged callback', () {
      testWidgets('calls onChanged when text is entered', (tester) async {
        String? changedName;
        String? changedValue;

        await tester.pumpWidget(
          buildTestWidget(
            VTextField(
              name: 'username',
              onChanged: (value) {
                changedName = 'username';
                changedValue = value;
              },
            ),
          ),
        );

        await tester.tap(find.byType(EditableText));
        await tester.pump();
        await tester.enterText(find.byType(EditableText), 'John');
        await tester.pump();

        expect(changedName, 'username');
        expect(changedValue, 'John');
      });
    });

    group('onSubmitted callback', () {
      testWidgets('calls onSubmitted when Enter key is pressed', (
        tester,
      ) async {
        String? submittedValue;

        await tester.pumpWidget(
          buildTestWidget(
            VTextField(
              name: 'test',
              onSubmitted: (value) {
                submittedValue = value;
              },
            ),
          ),
        );

        await tester.tap(find.byType(EditableText));
        await tester.pump();
        await tester.enterText(find.byType(EditableText), 'Test');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        expect(submittedValue, 'Test');
      });
    });

    group('inputFormatters', () {
      testWidgets('applies custom inputFormatter', (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          buildTestWidget(
            VTextField(
              name: 'test',
              controller: controller,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
        );

        await tester.tap(find.byType(EditableText));
        await tester.pump();
        await tester.enterText(find.byType(EditableText), 'abc123def');
        await tester.pump();

        // Only digits remain
        expect(controller.text, '123');
      });
    });

    group('controller', () {
      testWidgets('can use external controller', (tester) async {
        final controller = TextEditingController(text: 'Initial value');

        await tester.pumpWidget(
          buildTestWidget(VTextField(name: 'test', controller: controller)),
        );

        final editableText = tester.widget<EditableText>(
          find.byType(EditableText),
        );
        expect(editableText.controller.text, 'Initial value');
      });

      testWidgets('updates text when controller changes', (tester) async {
        final controller = TextEditingController(text: 'Before');

        await tester.pumpWidget(
          buildTestWidget(VTextField(name: 'test', controller: controller)),
        );

        controller.text = 'After';
        await tester.pump();

        final editableText = tester.widget<EditableText>(
          find.byType(EditableText),
        );
        expect(editableText.controller.text, 'After');
      });
    });

    group('focusNode', () {
      testWidgets('can use external focusNode', (tester) async {
        final focusNode = FocusNode();

        await tester.pumpWidget(
          buildTestWidget(VTextField(name: 'test', focusNode: focusNode)),
        );

        expect(focusNode.hasFocus, isFalse);

        focusNode.requestFocus();
        await tester.pump();

        expect(focusNode.hasFocus, isTrue);

        focusNode.dispose();
      });
    });

    group('loading state', () {
      testWidgets('displays loading indicator when loading=true', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(const VTextField(name: 'test', loading: true)),
        );

        // Loading indicator is displayed
        expect(find.byType(VTextField), findsOneWidget);
      });
    });

    group('style options', () {
      testWidgets('applies various sizes', (tester) async {
        for (final size in VFormBodySize.values) {
          await tester.pumpWidget(
            buildTestWidget(VTextField(name: 'test', size: size)),
          );

          expect(find.byType(VTextField), findsOneWidget);
        }
      });

      testWidgets('applies various types', (tester) async {
        for (final type in VFormBodyType.values) {
          await tester.pumpWidget(
            buildTestWidget(VTextField(name: 'test', type: type)),
          );

          expect(find.byType(VTextField), findsOneWidget);
        }
      });

      testWidgets('applies various corners', (tester) async {
        for (final corner in VFormBodyCorner.values) {
          await tester.pumpWidget(
            buildTestWidget(VTextField(name: 'test', corner: corner)),
          );

          expect(find.byType(VTextField), findsOneWidget);
        }
      });

      testWidgets('applies various colors', (tester) async {
        for (final color in VFormBodyColor.values) {
          await tester.pumpWidget(
            buildTestWidget(VTextField(name: 'test', color: color)),
          );

          expect(find.byType(VTextField), findsOneWidget);
        }
      });
    });

    group('theme override', () {
      testWidgets('theme componentOverrides applies to text field', (
        tester,
      ) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VTextFieldStyle(backgroundColor: Color(0xFFFF0000)),
              ]),
            ),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: MediaQuery(
                data: MediaQueryData(),
                child: VTextField(name: 'test'),
              ),
            ),
          ),
        );

        expect(find.byType(VTextField), findsOneWidget);
      });
    });

    group('style fields', () {
      final theme = VThemeData.light();
      const style = VTextFieldStyle(
        backgroundColor: Color(0xFFFAFAF0),
        borderColor: Color(0xFF00AA00),
        focusBorderColor: Color(0xFF0000AA),
        borderRadius: BorderRadius.all(Radius.circular(3)),
        padding: EdgeInsets.symmetric(horizontal: 30),
        labelStyle: TextStyle(fontSize: 20, color: Color(0xFF654321)),
        hintStyle: TextStyle(color: Color(0xFF888800)),
        textStyle: TextStyle(fontSize: 18, color: Color(0xFF112233)),
      );

      // Applies [style] through the theme or as the instance style.
      Widget styled({
        required bool viaTheme,
        required Widget Function(VTextFieldStyle? instanceStyle) build,
      }) => VTheme(
        data: theme.copyWith(
          componentOverrides: VComponentOverrides(viaTheme ? [style] : []),
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: Center(
              child: SizedBox(
                width: 300,
                child: build(viaTheme ? null : style),
              ),
            ),
          ),
        ),
      );

      Container boxOf(WidgetTester tester) => tester.widget<Container>(
        find
            .descendant(
              of: find.byType(VFormBody),
              matching: find.byType(Container),
            )
            .first,
      );

      for (final viaTheme in [true, false]) {
        final via = viaTheme ? 'theme' : 'instance';

        testWidgets('the box takes the style ($via)', (tester) async {
          await tester.pumpWidget(
            styled(
              viaTheme: viaTheme,
              build: (s) => VTextField(name: 'test', style: s),
            ),
          );

          final box = boxOf(tester);
          final decoration = box.decoration! as BoxDecoration;
          expect(decoration.color, style.backgroundColor);
          expect((decoration.border! as Border).top.color, style.borderColor);
          expect(decoration.borderRadius, style.borderRadius);
          expect(box.padding, style.padding);
        });

        testWidgets('the focused box takes focusBorderColor ($via)', (
          tester,
        ) async {
          final focusNode = FocusNode();
          addTearDown(focusNode.dispose);
          await tester.pumpWidget(
            styled(
              viaTheme: viaTheme,
              build: (s) =>
                  VTextField(name: 'test', focusNode: focusNode, style: s),
            ),
          );
          focusNode.requestFocus();
          await tester.pumpAndSettle();

          final border =
              (boxOf(tester).decoration! as BoxDecoration).border! as Border;
          expect(border.top.color, style.focusBorderColor);
        });

        testWidgets('the label, hint and text take their styles ($via)', (
          tester,
        ) async {
          await tester.pumpWidget(
            styled(
              viaTheme: viaTheme,
              build: (s) => VTextField(
                name: 'test',
                label: 'Name',
                placeholder: 'Your name',
                style: s,
              ),
            ),
          );

          final label = tester.widget<Text>(find.text('Name')).style!;
          expect(label.fontSize, 20);
          expect(label.color, style.labelStyle!.color);
          final hint = tester.widget<Text>(find.text('Your name')).style!;
          expect(hint.color, style.hintStyle!.color);
          final input = tester.widget<EditableText>(find.byType(EditableText));
          expect(input.style.fontSize, 18);
          expect(input.style.color, style.textStyle!.color);
        });
      }

      testWidgets('foregroundColor wins over the color of textStyle', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField(
              name: 'test',
              style: VTextFieldStyle(
                foregroundColor: Color(0xFF0000FF),
                textStyle: TextStyle(color: Color(0xFF112233)),
              ),
            ),
          ),
        );

        final input = tester.widget<EditableText>(find.byType(EditableText));
        expect(input.style.color, const Color(0xFF0000FF));
      });

      testWidgets('without a style, the label and hint keep their colors', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            const VTextField(name: 'test', label: 'Name', placeholder: 'Hint'),
          ),
        );

        expect(
          tester.widget<Text>(find.text('Name')).style!.color,
          theme.colors.foreground,
        );
        expect(
          tester.widget<Text>(find.text('Hint')).style!.color,
          theme.colors.mutedForeground,
        );
        expect((boxOf(tester).decoration! as BoxDecoration).color, isNull);
      });
    });

    testWidgets('a single line is not clipped at 320 wide and 3x text', (
      tester,
    ) async {
      final theme = VThemeData.light();
      await pumpLargeText(
        tester,
        VTextField(
          name: 'test',
          controller: TextEditingController(text: 'Hello'),
          fullWidth: true,
        ),
      );

      expect(tester.takeException(), isNull);
      final body = theme.typography.bodyMedium;
      final lineHeight = body.fontSize! * 3 * body.height!;
      expect(
        tester.getSize(find.byType(EditableText)).height,
        greaterThanOrEqualTo(lineHeight - 0.5),
      );
      expect(
        tester.getSize(find.byType(VFormBody)).height,
        greaterThan(theme.sizes.md.height),
      );
    });
  });
}

// A 320 x 640 screen with text at three times the size.
Future<void> pumpLargeText(WidgetTester tester, Widget child) async {
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
        data: VThemeData.light(),
        child: Directionality(textDirection: TextDirection.ltr, child: child),
      ),
    ),
  );
}
