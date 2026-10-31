import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vFormHeaderComponent() => WidgetbookComponent(
  name: 'VFormHeader',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _formHeaderPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _FormHeaderShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _FormHeaderSample(),
    ),
  ],
);

Widget _formHeaderPlayground(BuildContext context) {
  final k = context.knobs;
  final label = k.stringOrNull(label: 'label', initialValue: 'Email');
  final more = k.stringOrNull(label: 'more');
  final required = k.boolean(label: 'required');
  final requiredMark = k.string(label: 'requiredMark', initialValue: '*');
  final tooltip = k.boolean(label: 'tooltip');
  final floatingLabel = k.boolean(label: 'floatingLabel');

  return WidgetbookPlayground(
    child: SizedBox(
      width: 320,
      child: VFormHeader(
        label: label,
        more: more,
        required: required,
        requiredMark: requiredMark,
        tooltip: tooltip ? const Text('?') : null,
        floatingLabel: floatingLabel,
        child: const VFormBody(child: Text('Input content')),
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _FormHeaderShowcase extends StatelessWidget {
  const _FormHeaderShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return WidgetbookPageLayout(
      title: 'VFormHeader',
      description:
          'Header section of a form field with label, required indicator, and tooltip.',
      children: [
        WidgetbookSection(
          title: 'Basic',
          children: [
            WidgetbookSubsection(
              title: 'header',
              labels: const ['label only'],
              children: [
                VFormHeader(
                  label: 'Field Label',
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: const Text('Input content'),
                  ),
                ),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Variants',
          children: [
            WidgetbookSubsection(
              title: 'required',
              labels: const ['VFormHeader(required: true)'],
              children: [
                VFormHeader(
                  label: 'Required Field',
                  required: true,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: const Text('Input content'),
                  ),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'with_more',
              labels: const ['VFormHeader(more: ...)'],
              children: [
                VFormHeader(
                  label: 'With More Info',
                  more: 'Optional',
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: const Text('Input content'),
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
  }

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
              'Use to include labels, required marks, and tooltips above a field',
            ),
            _guidelineRow(
              theme,
              'Label',
              'Describe the purpose of the input field with a clear and concise label',
            ),
            _guidelineRow(
              theme,
              'Required',
              'Provide a visual indicator (*) for required fields',
            ),
            _guidelineRow(
              theme,
              'More',
              'Provide optional information or additional context (e.g., "Optional", "0/100")',
            ),
            _guidelineRow(
              theme,
              'Floating',
              'Use floatingLabel for a label that animates upward on input focus',
            ),
            _guidelineRow(
              theme,
              'Consistency',
              'Maintain the same header style across the entire form',
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

class _FormHeaderSample extends StatelessWidget {
  const _FormHeaderSample();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return WidgetbookPageLayout(
      title: 'VFormHeader Samples',
      description: 'Copy-ready code examples.',
      children: [
        WidgetbookCodeBlock(
          title: 'Basic Usage',
          code: '''VFormHeader(
  label: 'Username',
  child: MyInputWidget(),
)''',
          preview: VFormHeader(
            label: 'Username',
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: theme.colors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: const Text('Input content'),
            ),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Required Indicator',
          code: '''VFormHeader(
  label: 'Email',
  required: true,
  child: MyInputWidget(),
)''',
          preview: VFormHeader(
            label: 'Email',
            required: true,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: theme.colors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: const Text('Input content'),
            ),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Additional Info Display',
          code: '''VFormHeader(
  label: 'Bio',
  more: 'Optional',
  child: MyInputWidget(),
)''',
          preview: VFormHeader(
            label: 'Bio',
            more: 'Optional',
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: theme.colors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: const Text('Input content'),
            ),
          ),
        ),
        const WidgetbookCodeBlock(
          title: 'Section header',
          code: '''VFormHeader(
  label: 'Personal Information',
  more: 'Step 1 of 3',
  child: Column(
    children: [
      VFormBody(child: Text('Name')),
      SizedBox(height: 8),
      VFormBody(child: Text('Email')),
    ],
  ),
)''',
          preview: VFormHeader(
            label: 'Personal Information',
            more: 'Step 1 of 3',
            child: Column(
              children: [
                VFormBody(child: Text('Name')),
                SizedBox(height: 8),
                VFormBody(child: Text('Email')),
              ],
            ),
          ),
        ),
        const WidgetbookCodeBlock(
          title: 'With tooltip help',
          code: '''VFormHeader(
  label: 'API Key',
  required: true,
  tooltip: Text('?'),
  child: VFormBody(child: Text('sk-...')),
)''',
          preview: VFormHeader(
            label: 'API Key',
            required: true,
            tooltip: Text('?'),
            child: VFormBody(child: Text('sk-...')),
          ),
        ),
        const WidgetbookCodeBlock(
          title: 'Required with more info',
          code: '''VFormHeader(
  label: 'Password',
  required: true,
  more: 'Min 8 characters',
  child: VFormBody(child: VTextField.password(name: 'password')),
)''',
          preview: VFormHeader(
            label: 'Password',
            required: true,
            more: 'Min 8 characters',
            child: VFormBody(child: Text('********')),
          ),
        ),
      ],
    );
  }
}
