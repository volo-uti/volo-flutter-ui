import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _StepperLayout { horizontal, vertical, compact }

WidgetbookComponent vStepperComponent() => WidgetbookComponent(
  name: 'VStepper',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _stepperPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _StepperShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _StepperSample(),
    ),
  ],
);

Widget _stepperPlayground(BuildContext context) {
  final k = context.knobs;
  final layout = k.object.dropdown<_StepperLayout>(
    label: 'layout',
    options: _StepperLayout.values,
    initialOption: _StepperLayout.vertical,
    labelBuilder: (v) => v.name,
  );
  final secondState = k.object.dropdown<VStepState>(
    label: 'steps[1].state',
    options: VStepState.values,
    initialOption: VStepState.indexed,
    labelBuilder: (v) => v.name,
  );
  final showSubtitle = k.boolean(label: 'subtitle', initialValue: true);
  final tappable = k.boolean(label: 'onStepTapped', initialValue: true);
  var active = k.int.slider(label: 'activeStep', initialValue: 1, max: 2);

  return StatefulBuilder(
    builder: (context, setState) {
      final steps = [
        VStep(
          title: const Text('Account'),
          subtitle: showSubtitle ? const Text('Create your login') : null,
          content: const Center(child: Text('Account step content')),
        ),
        VStep(
          title: const Text('Profile'),
          subtitle: showSubtitle ? const Text('Tell us about you') : null,
          state: secondState,
          content: const Center(child: Text('Profile step content')),
        ),
        VStep(
          title: const Text('Review'),
          subtitle: showSubtitle ? const Text('Check and confirm') : null,
          content: const Center(child: Text('Review step content')),
        ),
      ];
      void goTo(int index) => setState(() => active = index.clamp(0, 2));
      final stepper = switch (layout) {
        _StepperLayout.horizontal => VStepper.horizontal(
          activeStep: active,
          steps: steps,
          onStepTapped: tappable ? goTo : null,
          onStepContinue: () => goTo(active + 1),
          onStepCancel: () => goTo(active - 1),
        ),
        _StepperLayout.vertical => VStepper.vertical(
          activeStep: active,
          steps: steps,
          onStepTapped: tappable ? goTo : null,
          onStepContinue: () => goTo(active + 1),
          onStepCancel: () => goTo(active - 1),
        ),
        _StepperLayout.compact => VStepper.compact(
          activeStep: active,
          steps: steps,
          onStepTapped: tappable ? goTo : null,
        ),
      };
      return WidgetbookPlayground(
        info: ['activeStep: $active'],
        child: SizedBox(
          height: 340,
          child: layout == _StepperLayout.vertical
              ? SingleChildScrollView(child: stepper)
              : stepper,
        ),
      );
    },
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _StepperShowcase extends StatelessWidget {
  const _StepperShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VStepper',
    description: 'Multi-step progress indicator for wizard-like workflows.',
    children: [
      const WidgetbookSection(
        title: 'Orientation',
        children: [
          WidgetbookSubsection(
            title: 'horizontal',
            labels: ['orientation="horizontal"'],
            children: [SizedBox(height: 250, child: _HorizontalStepperDemo())],
          ),
          WidgetbookSubsection(
            title: 'vertical',
            labels: ['orientation="vertical"'],
            children: [SizedBox(height: 300, child: _VerticalStepperDemo())],
          ),
        ],
      ),

      WidgetbookSection(
        title: 'Alternative Label',
        children: [
          WidgetbookSubsection(
            title: 'labels below icons',
            labels: const ['alternativeLabel'],
            children: [
              SizedBox(
                height: 250,
                child: VStepper.horizontal(
                  activeStep: 1,
                  steps: const [
                    VStep(
                      title: Text('Account'),
                      content: Center(child: Text('Account step content')),
                    ),
                    VStep(
                      title: Text('Profile'),
                      content: Center(child: Text('Profile step content')),
                    ),
                    VStep(
                      title: Text('Review'),
                      content: Center(child: Text('Review step content')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      WidgetbookSection(
        title: 'Active Step',
        children: [
          WidgetbookSubsection(
            title: 'step 0 (start)',
            labels: const ['activeStep={0}'],
            children: [
              SizedBox(
                height: 120,
                child: VStepper.horizontal(
                  activeStep: 0,
                  steps: const [
                    VStep(title: Text('Account'), content: SizedBox.shrink()),
                    VStep(title: Text('Profile'), content: SizedBox.shrink()),
                    VStep(title: Text('Review'), content: SizedBox.shrink()),
                  ],
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'step 1 (middle)',
            labels: const ['activeStep={1}'],
            children: [
              SizedBox(
                height: 120,
                child: VStepper.horizontal(
                  activeStep: 1,
                  steps: const [
                    VStep(title: Text('Account'), content: SizedBox.shrink()),
                    VStep(title: Text('Profile'), content: SizedBox.shrink()),
                    VStep(title: Text('Review'), content: SizedBox.shrink()),
                  ],
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'step 2 (last)',
            labels: const ['activeStep={2}'],
            children: [
              SizedBox(
                height: 120,
                child: VStepper.horizontal(
                  activeStep: 2,
                  steps: const [
                    VStep(title: Text('Account'), content: SizedBox.shrink()),
                    VStep(title: Text('Profile'), content: SizedBox.shrink()),
                    VStep(title: Text('Review'), content: SizedBox.shrink()),
                  ],
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'all completed',
            labels: const ['activeStep={2} (last)'],
            children: [
              SizedBox(
                height: 120,
                child: VStepper.horizontal(
                  activeStep: 2,
                  steps: const [
                    VStep(
                      title: Text('Account'),
                      content: SizedBox.shrink(),
                      state: VStepState.complete,
                    ),
                    VStep(
                      title: Text('Profile'),
                      content: SizedBox.shrink(),
                      state: VStepState.complete,
                    ),
                    VStep(
                      title: Text('Review'),
                      content: SizedBox.shrink(),
                      state: VStepState.complete,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      WidgetbookSection(
        title: 'Error State',
        children: [
          WidgetbookSubsection(
            title: 'step with error',
            labels: const ['VStep(error)'],
            children: [
              SizedBox(
                height: 120,
                child: VStepper.horizontal(
                  activeStep: 1,
                  steps: const [
                    VStep(
                      title: Text('Account'),
                      content: SizedBox.shrink(),
                      state: VStepState.complete,
                    ),
                    VStep(
                      title: Text('Profile'),
                      content: SizedBox.shrink(),
                      state: VStepState.error,
                    ),
                    VStep(title: Text('Review'), content: SizedBox.shrink()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      WidgetbookSection(
        title: 'Optional Steps',
        children: [
          WidgetbookSubsection(
            title: 'optional markers',
            labels: const ['VStep(optional)'],
            children: [
              SizedBox(
                height: 120,
                child: VStepper.horizontal(
                  activeStep: 1,
                  steps: const [
                    VStep(title: Text('Account'), content: SizedBox.shrink()),
                    VStep(
                      title: Text('Profile'),
                      subtitle: Text('Optional'),
                      content: SizedBox.shrink(),
                    ),
                    VStep(
                      title: Text('Preferences'),
                      subtitle: Text('Optional'),
                      content: SizedBox.shrink(),
                    ),
                    VStep(title: Text('Review'), content: SizedBox.shrink()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      WidgetbookSection(
        title: 'With Descriptions',
        children: [
          WidgetbookSubsection(
            title: 'descriptive steps',
            labels: const ['VStep(description)'],
            children: [
              SizedBox(
                height: 120,
                child: VStepper.horizontal(
                  activeStep: 2,
                  steps: const [
                    VStep(
                      title: Text('Account'),
                      subtitle: Text('Create your account credentials'),
                      content: SizedBox.shrink(),
                    ),
                    VStep(
                      title: Text('Profile'),
                      subtitle: Text('Fill in your personal information'),
                      content: SizedBox.shrink(),
                    ),
                    VStep(
                      title: Text('Preferences'),
                      subtitle: Text('Set your notification preferences'),
                      content: SizedBox.shrink(),
                    ),
                    VStep(
                      title: Text('Review'),
                      subtitle: Text('Review and confirm your details'),
                      content: SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      // Usage Guidelines
      _buildUsageGuidelines(context),
    ],
  );

  Widget _buildUsageGuidelines(BuildContext context) {
    final theme = VTheme.of(context);
    return WidgetbookSection(
      title: 'Usage Guidelines',
      children: [
        Table(
          columnWidths: const {0: FixedColumnWidth(120), 1: FlexColumnWidth()},
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: theme.colors.muted,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              children: [
                _tableHeader(theme, 'Category'),
                _tableHeader(theme, 'Guideline'),
              ],
            ),
            _guidelineRow(
              theme,
              'When to use',
              'Multi-step forms, onboarding wizards, checkout flows',
            ),
            _guidelineRow(
              theme,
              'Horizontal',
              'Default layout for standard multi-step processes',
            ),
            _guidelineRow(
              theme,
              'Vertical',
              'Use for detailed steps with longer descriptions',
            ),
            _guidelineRow(
              theme,
              'Error state',
              'Highlight steps that require user attention or correction',
            ),
            _guidelineRow(
              theme,
              'Optional steps',
              'Mark steps the user can skip during the flow',
            ),
          ],
        ),
      ],
    );
  }

  Widget _tableHeader(VThemeData theme, String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Text(
      text,
      style: theme.typography.labelMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colors.foreground,
      ),
    ),
  );

  TableRow _guidelineRow(VThemeData theme, String category, String guideline) =>
      TableRow(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: theme.colors.border)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              category,
              style: theme.typography.labelMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colors.foreground,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              guideline,
              style: theme.typography.bodySmall.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ),
        ],
      );
}

// =============================================================================
// Sample
// =============================================================================

class _StepperSample extends StatelessWidget {
  const _StepperSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VStepper Samples',
    description: 'Copy-paste code examples for common stepper patterns.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic stepper',
        code: '''VStepper.horizontal(
  activeStep: 1,
  steps: [
    VStep(title: Text('Account'), content: Text('...')),
    VStep(title: Text('Profile'), content: Text('...')),
    VStep(title: Text('Review'), content: Text('...')),
  ],
)''',
        preview: SizedBox(
          height: 200,
          child: VStepper.horizontal(
            activeStep: 1,
            steps: const [
              VStep(
                title: Text('Account'),
                content: Center(child: Text('Account step')),
              ),
              VStep(
                title: Text('Profile'),
                content: Center(child: Text('Profile step')),
              ),
              VStep(
                title: Text('Review'),
                content: Center(child: Text('Review step')),
              ),
            ],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Stepper with descriptions',
        code: '''VStepper.horizontal(
  activeStep: 2,
  steps: [
    VStep(title: Text('Account'), subtitle: Text('Create your account')),
    VStep(title: Text('Profile'), subtitle: Text('Fill in your info')),
    VStep(title: Text('Preferences'), subtitle: Text('Set preferences')),
    VStep(title: Text('Review'), subtitle: Text('Review details')),
  ],
)''',
        preview: SizedBox(
          height: 200,
          child: VStepper.horizontal(
            activeStep: 2,
            steps: const [
              VStep(
                title: Text('Account'),
                subtitle: Text('Create your account'),
                content: SizedBox.shrink(),
              ),
              VStep(
                title: Text('Profile'),
                subtitle: Text('Fill in your info'),
                content: SizedBox.shrink(),
              ),
              VStep(
                title: Text('Preferences'),
                subtitle: Text('Set preferences'),
                content: SizedBox.shrink(),
              ),
              VStep(
                title: Text('Review'),
                subtitle: Text('Review details'),
                content: SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Vertical stepper',
        code: '''VStepper.vertical(
  activeStep: 1,
  steps: [
    VStep(title: Text('Step 1'), subtitle: Text('Description 1')),
    VStep(title: Text('Step 2'), subtitle: Text('Description 2')),
    VStep(title: Text('Step 3'), subtitle: Text('Description 3')),
  ],
)''',
        preview: SizedBox(height: 250, child: _VerticalStepperDemo()),
      ),
      const WidgetbookCodeBlock(
        title: 'Interactive stepper',
        code: '''VStepper.horizontal(
  activeStep: step,
  onStepContinue: () => setState(() => step++),
  onStepCancel: () => setState(() => step--),
  steps: [
    VStep(title: Text('Account Info'), content: ...),
    VStep(title: Text('Profile Setup'), content: ...),
    VStep(title: Text('Confirmation'), content: ...),
  ],
)''',
        preview: SizedBox(height: 250, child: _HorizontalStepperDemo()),
      ),
      WidgetbookCodeBlock(
        title: 'Error and optional steps',
        code: '''VStepper.horizontal(
  activeStep: 2,
  steps: [
    VStep(title: Text('Account')),
    VStep(title: Text('Profile'), state: VStepState.error),
    VStep(title: Text('Preferences'), subtitle: Text('Optional')),
    VStep(title: Text('Review')),
  ],
)''',
        preview: SizedBox(
          height: 120,
          child: VStepper.horizontal(
            activeStep: 2,
            steps: const [
              VStep(title: Text('Account'), content: SizedBox.shrink()),
              VStep(
                title: Text('Profile'),
                content: SizedBox.shrink(),
                state: VStepState.error,
              ),
              VStep(
                title: Text('Preferences'),
                subtitle: Text('Optional'),
                content: SizedBox.shrink(),
              ),
              VStep(title: Text('Review'), content: SizedBox.shrink()),
            ],
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Checkout flow',
        code: '''VStepper.horizontal(
  activeStep: _currentStep,
  onStepContinue: () => setState(() => _currentStep++),
  onStepCancel: () => setState(() => _currentStep--),
  steps: [
    VStep(
      title: Text('Cart'),
      subtitle: Text('Review your items'),
      content: Text('3 items in cart'),
    ),
    VStep(
      title: Text('Shipping'),
      subtitle: Text('Enter address'),
      content: Text('Enter shipping address'),
    ),
    VStep(
      title: Text('Payment'),
      subtitle: Text('Complete order'),
      content: Text('Enter payment details'),
    ),
  ],
)''',
        preview: SizedBox(height: 250, child: _HorizontalStepperDemo()),
      ),
      const WidgetbookCodeBlock(
        title: 'Vertical stepper',
        code: '''VStepper.vertical(
  activeStep: _step,
  onStepContinue: () => setState(() => _step++),
  onStepCancel: () => setState(() => _step--),
  steps: [
    VStep(title: Text('Account'), content: Text('Create your account')),
    VStep(title: Text('Profile'), content: Text('Set up your profile')),
    VStep(title: Text('Confirm'), content: Text('Review and confirm')),
  ],
)''',
        preview: SizedBox(height: 300, child: _VerticalStepperDemo()),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _VerticalStepperDemo extends StatefulWidget {
  const _VerticalStepperDemo();

  @override
  State<_VerticalStepperDemo> createState() => _VerticalStepperDemoState();
}

class _VerticalStepperDemoState extends State<_VerticalStepperDemo> {
  int _activeStep = 0;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: VStepper.vertical(
      activeStep: _activeStep,
      onStepTapped: (step) => setState(() => _activeStep = step),
      onStepContinue: () {
        if (_activeStep < 2) setState(() => _activeStep++);
      },
      onStepCancel: () {
        if (_activeStep > 0) setState(() => _activeStep--);
      },
      steps: const [
        VStep(
          title: Text('Enter Information'),
          subtitle: Text('Enter your basic information'),
          content: Text('Please enter your name and email.'),
        ),
        VStep(
          title: Text('Detailed Settings'),
          subtitle: Text('Configure additional settings'),
          content: Text('Please review notification and privacy settings.'),
        ),
        VStep(
          title: Text('Complete'),
          subtitle: Text('Finish the registration'),
          content: Text(
            'Review the entered information and press the complete button.',
          ),
        ),
      ],
    ),
  );
}

class _HorizontalStepperDemo extends StatefulWidget {
  const _HorizontalStepperDemo();

  @override
  State<_HorizontalStepperDemo> createState() => _HorizontalStepperDemoState();
}

class _HorizontalStepperDemoState extends State<_HorizontalStepperDemo> {
  int _activeStep = 0;

  @override
  Widget build(BuildContext context) => VStepper.horizontal(
    activeStep: _activeStep,
    onStepTapped: (step) => setState(() => _activeStep = step),
    onStepContinue: () {
      if (_activeStep < 2) setState(() => _activeStep++);
    },
    onStepCancel: () {
      if (_activeStep > 0) setState(() => _activeStep--);
    },
    steps: const [
      VStep(
        title: Text('Cart'),
        content: Center(child: Text('Review the items in your cart.')),
      ),
      VStep(
        title: Text('Shipping'),
        content: Center(child: Text('Enter shipping information.')),
      ),
      VStep(
        title: Text('Payment'),
        content: Center(child: Text('Proceed with payment.')),
      ),
    ],
  );
}
