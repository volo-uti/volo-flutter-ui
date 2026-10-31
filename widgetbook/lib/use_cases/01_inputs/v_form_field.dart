import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vFormFieldComponent() => WidgetbookComponent(
  name: 'VFormField',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _formFieldPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _FormFieldShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _FormFieldSample(),
    ),
  ],
);

Widget _formFieldPlayground(BuildContext context) {
  final k = context.knobs;
  final label = k.stringOrNull(label: 'label', initialValue: 'Email');
  final more = k.stringOrNull(label: 'more');
  final helper = k.stringOrNull(label: 'helper', initialValue: 'Work email');
  final error = k.boolean(label: 'error');
  final errorText = k.stringOrNull(label: 'errorText');
  final success = k.boolean(label: 'success');
  final successText = k.stringOrNull(label: 'successText');
  final extra = k.stringOrNull(label: 'extra');
  final tooltip = k.boolean(label: 'tooltip');
  final required = k.boolean(label: 'required');
  final floatingLabel = k.boolean(label: 'floatingLabel');
  final maxLength = k.int.slider(label: 'maxLength', max: 100);
  final currentLength = k.int.slider(label: 'currentLength', max: 100);

  return WidgetbookPlayground(
    child: SizedBox(
      width: 320,
      child: VFormField(
        label: label,
        more: more,
        helper: helper,
        error: error,
        errorText: errorText,
        success: success,
        successText: successText,
        extra: extra,
        tooltip: tooltip ? const Text('?') : null,
        required: required,
        floatingLabel: floatingLabel,
        maxLength: maxLength == 0 ? null : maxLength,
        currentLength: currentLength,
        child: const VFormBody(child: Text('Input content')),
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _FormFieldShowcase extends StatelessWidget {
  const _FormFieldShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return WidgetbookPageLayout(
      title: 'VFormField',
      description:
          'Wrapper component providing label, helper text, and error message for form inputs.',
      children: [
        WidgetbookSection(
          title: 'Label & Helper Text',
          children: [
            WidgetbookSubsection(
              title: 'label only',
              labels: const ['label'],
              children: [
                VFormField(
                  label: 'Label',
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
              title: 'with helper text',
              labels: const ['label + helper'],
              children: [
                VFormField(
                  label: 'Label',
                  helper: 'This is helper text',
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
              title: 'required',
              labels: const ['required mark'],
              children: [
                VFormField(
                  label: 'Username',
                  required: true,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'States',
          children: [
            WidgetbookSubsection(
              title: 'default',
              labels: const ['default'],
              children: [
                VFormField(
                  label: 'Label',
                  helper: 'This is helper text',
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
              title: 'error',
              labels: const ['error'],
              children: [
                VFormField(
                  label: 'Email',
                  error: true,
                  errorText: 'Invalid email format',
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colors.destructive),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: const Text('invalid-email'),
                  ),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'success',
              labels: const ['success'],
              children: [
                VFormField(
                  label: 'Email',
                  success: true,
                  successText: 'Email is valid',
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: const Text('user@example.com'),
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
              'Wrap any form input to add label, helper text, and validation messaging',
            ),
            _guidelineRow(
              theme,
              'Label',
              'Always provide a label. Use htmlFor to connect label to input for accessibility',
            ),
            _guidelineRow(
              theme,
              'Required',
              'Mark mandatory fields with required. Show indicator consistently across the form',
            ),
            _guidelineRow(
              theme,
              'Error',
              'Display errorText below input on validation failure. Replace helperText when error is true',
            ),
            _guidelineRow(
              theme,
              'Helper text',
              'Use for format guidance, constraints, or instructions (e.g., "Max 50 characters")',
            ),
            _guidelineRow(
              theme,
              'Consistency',
              'Use the same size for VFormField and its child input component',
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

class _FormFieldSample extends StatelessWidget {
  const _FormFieldSample();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return WidgetbookPageLayout(
      title: 'VFormField Samples',
      description: 'Copy-paste code examples for common form field patterns.',
      children: [
        WidgetbookCodeBlock(
          title: 'Basic Usage',
          code: '''VFormField(
  label: 'Username',
  helper: 'Enter your username',
  child: MyInputWidget(),
)''',
          preview: VFormField(
            label: 'Username',
            helper: 'Enter your username',
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
          title: 'Error State',
          code: '''VFormField(
  label: 'Email',
  error: true,
  errorText: 'Invalid email format',
  child: MyInputWidget(),
)''',
          preview: VFormField(
            label: 'Email',
            error: true,
            errorText: 'Invalid email format',
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: theme.colors.destructive),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: const Text('invalid-email'),
            ),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Required Field',
          code: '''VFormField(
  label: 'Password',
  required: true,
  helper: 'Minimum 8 characters',
  child: MyInputWidget(),
)''',
          preview: VFormField(
            label: 'Password',
            required: true,
            helper: 'Minimum 8 characters',
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: theme.colors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        const WidgetbookCodeBlock(
          title: 'Required with helper text',
          code: '''VFormField(
  label: 'Email',
  required: true,
  helper: 'We will never share your email',
  tooltip: Text('?'),
  child: VFormBody(child: Text('user@example.com')),
)''',
          preview: VFormField(
            label: 'Email',
            required: true,
            helper: 'We will never share your email',
            tooltip: Text('?'),
            child: VFormBody(child: Text('user@example.com')),
          ),
        ),
        const WidgetbookCodeBlock(
          title: 'Size comparison',
          code: '''Column(
  children: [
    VFormField(label: 'Small', child: VFormBody(size: VFormBodySize.sm, child: Text('sm'))),
    VFormField(label: 'Medium', child: VFormBody(child: Text('md'))),
    VFormField(label: 'Large', child: VFormBody(size: VFormBodySize.lg, child: Text('lg'))),
  ],
)''',
          preview: Column(
            children: [
              VFormField(
                label: 'Small',
                child: VFormBody(size: VFormBodySize.sm, child: Text('sm')),
              ),
              SizedBox(height: 8),
              VFormField(
                label: 'Medium',
                child: VFormBody(child: Text('md')),
              ),
              SizedBox(height: 8),
              VFormField(
                label: 'Large',
                child: VFormBody(size: VFormBodySize.lg, child: Text('lg')),
              ),
            ],
          ),
        ),
        WidgetbookCodeBlock(
          title: 'With character counter',
          code: '''VFormField(
  label: 'Bio',
  helper: 'Tell us about yourself',
  maxLength: 200,
  currentLength: controller.text.length,
  child: MyTextArea(),
)''',
          preview: VFormField(
            label: 'Bio',
            helper: 'Tell us about yourself',
            maxLength: 200,
            currentLength: 42,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: theme.colors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              alignment: Alignment.topLeft,
              child: const Text('Flutter developer passionate about UI...'),
            ),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'With error state',
          code: '''VFormField(
  label: 'Username',
  error: true,
  errorText: 'Username is already taken',
  required: true,
  child: VTextField(
    name: 'username',
    value: 'john_doe',
    onChanged: (v) {},
  ),
)''',
          preview: VFormField(
            label: 'Username',
            error: true,
            errorText: 'Username is already taken',
            required: true,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: theme.colors.destructive),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: const Text('john_doe'),
            ),
          ),
        ),
      ],
    );
  }
}
