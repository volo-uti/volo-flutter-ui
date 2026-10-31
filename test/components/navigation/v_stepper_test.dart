import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(data: const MediaQueryData(), child: child),
    ),
  );

  const testSteps = [
    VStep(title: Text('Step 1'), content: Text('Content 1')),
    VStep(title: Text('Step 2'), content: Text('Content 2')),
    VStep(title: Text('Step 3'), content: Text('Content 3')),
  ];

  group('VStepper', () {
    group('assertion', () {
      test('throws assertion error for empty steps', () {
        expect(() => VStepper(steps: const <VStep>[]), throwsAssertionError);
      });

      test('throws assertion error for out-of-range activeStep', () {
        expect(
          () => VStepper(
            activeStep: 5,
            steps: const [
              VStep(title: Text('Step 1'), content: Text('Content 1')),
            ],
          ),
          throwsAssertionError,
        );
      });

      test('throws assertion error for negative activeStep', () {
        expect(
          () => VStepper(
            activeStep: -1,
            steps: const [
              VStep(title: Text('Step 1'), content: Text('Content 1')),
            ],
          ),
          throwsAssertionError,
        );
      });
    });

    group('default (horizontal)', () {
      testWidgets('renders step icons', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            SizedBox(height: 400, child: VStepper(steps: testSteps)),
          ),
        );

        // Horizontal layout renders step icons (numbers), not labels.
        expect(find.byType(VStepper), findsOneWidget);
      });

      testWidgets('shows first step content by default', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            SizedBox(height: 400, child: VStepper(steps: testSteps)),
          ),
        );

        expect(find.text('Content 1'), findsOneWidget);
      });

      testWidgets('shows active step content', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            SizedBox(
              height: 400,
              child: VStepper(activeStep: 1, steps: testSteps),
            ),
          ),
        );

        expect(find.text('Content 2'), findsOneWidget);
      });

      testWidgets('shows Next button on non-last step', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            SizedBox(height: 400, child: VStepper(steps: testSteps)),
          ),
        );

        expect(find.text('Next'), findsOneWidget);
      });

      testWidgets('shows Complete button on last step', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            SizedBox(
              height: 400,
              child: VStepper(activeStep: 2, steps: testSteps),
            ),
          ),
        );

        expect(find.text('Complete'), findsOneWidget);
      });

      testWidgets('does not show Previous button on first step', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            SizedBox(height: 400, child: VStepper(steps: testSteps)),
          ),
        );

        expect(find.text('Previous'), findsNothing);
      });

      testWidgets('shows Previous button on non-first step', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            SizedBox(
              height: 400,
              child: VStepper(activeStep: 1, steps: testSteps),
            ),
          ),
        );

        expect(find.text('Previous'), findsOneWidget);
      });
    });

    group('horizontal', () {
      testWidgets('renders via named constructor', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            SizedBox(height: 400, child: VStepper.horizontal(steps: testSteps)),
          ),
        );

        expect(find.text('Content 1'), findsOneWidget);
      });
    });

    group('vertical', () {
      testWidgets('renders step labels', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VStepper.vertical(steps: testSteps)),
        );

        expect(find.text('Step 1'), findsOneWidget);
        expect(find.text('Step 2'), findsOneWidget);
        expect(find.text('Step 3'), findsOneWidget);
      });

      testWidgets('shows first step content by default', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VStepper.vertical(steps: testSteps)),
        );

        expect(find.text('Content 1'), findsOneWidget);
      });

      testWidgets('shows active step content', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VStepper.vertical(activeStep: 1, steps: testSteps)),
        );

        expect(find.text('Content 2'), findsOneWidget);
      });

      testWidgets('renders step description', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              steps: const [
                VStep(
                  title: Text('Step 1'),
                  subtitle: Text('Fill in your details'),
                  content: Text('Content 1'),
                ),
                VStep(title: Text('Step 2'), content: Text('Content 2')),
              ],
            ),
          ),
        );

        expect(find.text('Fill in your details'), findsOneWidget);
      });
    });

    group('compact', () {
      testWidgets('renders without content', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VStepper.compact(steps: testSteps)),
        );

        // Compact does not show step content.
        expect(find.text('Content 1'), findsNothing);
        expect(find.text('Content 2'), findsNothing);
        expect(find.text('Content 3'), findsNothing);
      });

      testWidgets('renders step icons', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VStepper.compact(activeStep: 1, steps: testSteps)),
        );

        expect(find.byType(VStepper), findsOneWidget);
      });
    });

    group('step navigation', () {
      testWidgets('calls onStepTapped on vertical step tap', (tester) async {
        int? tappedIndex;

        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              onStepTapped: (index) => tappedIndex = index,
              steps: testSteps,
            ),
          ),
        );

        await tester.tap(find.text('Step 2'));
        await tester.pump();

        expect(tappedIndex, equals(1));
      });

      testWidgets('calls onStepContinue when Next tapped', (tester) async {
        var continued = false;

        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              onStepContinue: () => continued = true,
              steps: testSteps,
            ),
          ),
        );

        await tester.tap(find.text('Next'));
        await tester.pump();

        expect(continued, isTrue);
      });

      testWidgets('calls onStepCancel when Previous tapped', (tester) async {
        var cancelled = false;

        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              activeStep: 1,
              onStepCancel: () => cancelled = true,
              steps: testSteps,
            ),
          ),
        );

        await tester.tap(find.text('Previous'));
        await tester.pump();

        expect(cancelled, isTrue);
      });

      testWidgets('disabled step cannot be tapped', (tester) async {
        int? tappedIndex;

        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              onStepTapped: (index) => tappedIndex = index,
              steps: const [
                VStep(title: Text('Step 1'), content: Text('Content 1')),
                VStep(
                  title: Text('Step 2'),
                  content: Text('Content 2'),
                  state: VStepState.disabled,
                ),
              ],
            ),
          ),
        );

        await tester.tap(find.text('Step 2'));
        await tester.pump();

        expect(tappedIndex, isNull);
      });
    });

    group('step states', () {
      testWidgets('renders complete state with check icon', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              activeStep: 1,
              steps: const [
                VStep(
                  title: Text('Step 1'),
                  content: Text('Content 1'),
                  state: VStepState.complete,
                ),
                VStep(title: Text('Step 2'), content: Text('Content 2')),
              ],
            ),
          ),
        );

        // Check icon is rendered via CustomPaint.
        expect(find.byType(CustomPaint), findsWidgets);
      });

      testWidgets('renders editing state', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              steps: const [
                VStep(
                  title: Text('Step 1'),
                  content: Text('Content 1'),
                  state: VStepState.editing,
                ),
              ],
            ),
          ),
        );

        expect(find.byType(VStepper), findsOneWidget);
      });

      testWidgets('renders error state', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              steps: const [
                VStep(
                  title: Text('Step 1'),
                  content: Text('Content 1'),
                  state: VStepState.error,
                ),
              ],
            ),
          ),
        );

        expect(find.byType(VStepper), findsOneWidget);
      });

      testWidgets('renders disabled state', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              steps: const [
                VStep(
                  title: Text('Step 1'),
                  content: Text('Content 1'),
                  state: VStepState.disabled,
                ),
              ],
            ),
          ),
        );

        expect(find.byType(VStepper), findsOneWidget);
      });

      testWidgets('renders indexed state for inactive step', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              activeStep: 0,
              steps: const [
                VStep(title: Text('Step 1'), content: Text('Content 1')),
                VStep(title: Text('Step 2'), content: Text('Content 2')),
              ],
            ),
          ),
        );

        // Inactive indexed step renders with outlined border.
        expect(find.byType(VStepper), findsOneWidget);
      });
    });

    group('semantics', () {
      testWidgets('provides Semantics widget for vertical steps', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              onStepTapped: (index) {},
              steps: const [
                VStep(title: Text('Account'), content: Text('Content 1')),
                VStep(title: Text('Profile'), content: Text('Content 2')),
              ],
            ),
          ),
        );

        // Each step header wraps with a Semantics widget.
        expect(
          find.descendant(
            of: find.byType(VStepper),
            matching: find.byType(Semantics),
          ),
          findsWidgets,
        );
      });

      testWidgets('Semantics includes step label text', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              onStepTapped: (index) {},
              steps: const [
                VStep(title: Text('Account'), content: Text('Content 1')),
              ],
            ),
          ),
        );

        // Verify the label text is present in semantics tree via
        // RegExp match on the Semantics label pattern.
        expect(
          find.bySemanticsLabel(RegExp(r'Step 1 of 1[\s\S]*Account')),
          findsOneWidget,
        );
      });

      testWidgets('disabled step has disabled semantics', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              steps: const [
                VStep(
                  title: Text('Step 1'),
                  content: Text('Content 1'),
                  state: VStepState.disabled,
                ),
              ],
            ),
          ),
        );

        // The step header Semantics widget with enabled: false should be present.
        final semanticsFinder = find.descendant(
          of: find.byType(VStepper),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.enabled == false &&
                widget.properties.label != null &&
                widget.properties.label!.contains('Step 1'),
          ),
        );
        expect(semanticsFinder, findsOneWidget);
      });
    });

    group('custom controls', () {
      testWidgets('renders custom controls builder', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              controlsBuilder: (context, {onStepContinue, onStepCancel}) =>
                  const Text('Custom Controls'),
              steps: const [
                VStep(title: Text('Step 1'), content: Text('Content 1')),
              ],
            ),
          ),
        );

        expect(find.text('Custom Controls'), findsOneWidget);
        // Default controls should not appear.
        expect(find.text('Next'), findsNothing);
        expect(find.text('Previous'), findsNothing);
      });

      testWidgets('custom controls receive callbacks', (tester) async {
        var continued = false;
        var cancelled = false;

        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              activeStep: 1,
              onStepContinue: () => continued = true,
              onStepCancel: () => cancelled = true,
              controlsBuilder: (context, {onStepContinue, onStepCancel}) => Row(
                children: [
                  GestureDetector(
                    onTap: onStepCancel,
                    child: const Text('Back'),
                  ),
                  GestureDetector(
                    onTap: onStepContinue,
                    child: const Text('Forward'),
                  ),
                ],
              ),
              steps: const [
                VStep(title: Text('Step 1'), content: Text('Content 1')),
                VStep(title: Text('Step 2'), content: Text('Content 2')),
              ],
            ),
          ),
        );

        await tester.tap(find.text('Forward'));
        await tester.pump();
        expect(continued, isTrue);

        await tester.tap(find.text('Back'));
        await tester.pump();
        expect(cancelled, isTrue);
      });
    });

    group('FocusTraversalGroup', () {
      testWidgets('wraps content in FocusTraversalGroup', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(VStepper.vertical(steps: testSteps)),
        );

        expect(
          find.descendant(
            of: find.byType(VStepper),
            matching: find.byType(FocusTraversalGroup),
          ),
          findsAtLeastNWidgets(1),
        );
      });
    });

    group('VStep', () {
      test('has default state indexed', () {
        const step = VStep(title: Text('Test'), content: Text('Content'));
        expect(step.state, VStepState.indexed);
      });

      test('subtitle is optional', () {
        const step = VStep(title: Text('Test'), content: Text('Content'));
        expect(step.subtitle, isNull);
      });
    });

    group('Widget slots', () {
      testWidgets(
        'plain Text title and subtitle take the stepper text styles',
        (tester) async {
          final theme = VThemeData.light();
          await tester.pumpWidget(
            buildTestWidget(
              VStepper.vertical(
                steps: const [
                  VStep(
                    title: Text('Account'),
                    subtitle: Text('Your details'),
                    content: Text('Content 1'),
                  ),
                ],
              ),
            ),
          );

          TextStyle styleOf(String text) => tester
              .widget<RichText>(
                find.descendant(
                  of: find.text(text),
                  matching: find.byType(RichText),
                ),
              )
              .text
              .style!;

          final title = styleOf('Account');
          expect(title.fontSize, theme.typography.bodyLarge.fontSize);
          expect(title.fontWeight, FontWeight.w500);
          expect(title.color, theme.colors.foreground);
          final subtitle = styleOf('Your details');
          expect(subtitle.fontSize, theme.typography.bodySmall.fontSize);
          expect(subtitle.color, theme.colors.mutedForeground);
        },
      );

      testWidgets('title accepts any widget', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            VStepper.vertical(
              steps: const [
                VStep(
                  title: Row(
                    children: [
                      SizedBox(key: ValueKey('mark')),
                      Text('Rich'),
                    ],
                  ),
                  content: Text('Content 1'),
                ),
              ],
            ),
          ),
        );

        expect(find.text('Rich'), findsOneWidget);
        expect(find.byKey(const ValueKey('mark')), findsOneWidget);
      });
    });
  });

  group('VStepper regressions', () {
    testWidgets('onStepTapped fires from the default horizontal layout', (
      tester,
    ) async {
      int? tapped;
      await tester.pumpWidget(
        buildTestWidget(
          VStepper(steps: testSteps, onStepTapped: (index) => tapped = index),
        ),
      );

      await tester.tap(find.text('2'));
      expect(tapped, 1);
    });

    testWidgets('onStepTapped fires from the compact layout', (tester) async {
      int? tapped;
      await tester.pumpWidget(
        buildTestWidget(
          VStepper.compact(
            steps: testSteps,
            onStepTapped: (index) => tapped = index,
          ),
        ),
      );

      await tester.tap(find.text('3'));
      expect(tapped, 2);
    });

    testWidgets('Enter activates a focused marker', (tester) async {
      int? tapped;
      await tester.pumpWidget(
        buildTestWidget(
          VStepper.compact(
            steps: testSteps,
            onStepTapped: (index) => tapped = index,
          ),
        ),
      );

      Focus.of(tester.element(find.text('2'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      expect(tapped, 1);
    });

    testWidgets('markers are plain when onStepTapped is null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VStepper.compact(steps: testSteps)),
      );

      await tester.tap(find.text('2'));
      expect(tester.takeException(), isNull);
    });

    testWidgets('the step label comes from the localizations', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        VTheme(
          data: VThemeData.light(),
          localizations: const _FrenchSteps(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: const MediaQueryData(),
              child: VStepper.vertical(steps: testSteps, onStepTapped: (_) {}),
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel(RegExp('Etape 1 sur 3')), findsOneWidget);
      handle.dispose();
    });

    testWidgets('a disabled step before the active one is not a check mark', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          VStepper.compact(
            activeStep: 1,
            steps: const [
              VStep(
                title: Text('A'),
                content: Text('a'),
                state: VStepState.disabled,
              ),
              VStep(title: Text('B'), content: Text('b')),
            ],
          ),
        ),
      );

      // The marker keeps its number instead of turning into a check mark.
      expect(find.text('1'), findsOneWidget);
    });
  });
}

class _FrenchSteps extends VoloLocalizationsEn {
  const _FrenchSteps();

  @override
  String stepperStepOf(int step, int total) => 'Etape $step sur $total';
}
