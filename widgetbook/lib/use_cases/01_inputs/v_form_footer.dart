import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vFormFooterComponent() => WidgetbookComponent(
  name: 'VFormFooter',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _formFooterPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _FormFooterShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _FormFooterSample(),
    ),
  ],
);

Widget _formFooterPlayground(BuildContext context) {
  final k = context.knobs;
  final helper = k.stringOrNull(label: 'helper', initialValue: 'Helper text');
  final error = k.boolean(label: 'error');
  final errorText = k.stringOrNull(label: 'errorText');
  final success = k.boolean(label: 'success');
  final successText = k.stringOrNull(label: 'successText');
  final extra = k.stringOrNull(label: 'extra');
  final maxLength = k.int.slider(label: 'maxLength', max: 100);
  final currentLength = k.int.slider(label: 'currentLength', max: 120);

  return WidgetbookPlayground(
    child: SizedBox(
      width: 320,
      child: VFormFooter(
        helper: helper,
        error: error,
        errorText: errorText,
        success: success,
        successText: successText,
        extra: extra,
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

class _FormFooterShowcase extends StatelessWidget {
  const _FormFooterShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return WidgetbookPageLayout(
      title: 'VFormFooter',
      description:
          'Footer section of a form field showing helper text, errors, and character count.',
      children: [
        WidgetbookSection(
          title: 'Messages',
          children: [
            WidgetbookSubsection(
              title: 'helper',
              labels: const ['VFormFooter(helper: ...)'],
              children: [
                VFormFooter(
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
              labels: const ['VFormFooter(error: ...)'],
              children: [
                VFormFooter(
                  error: true,
                  errorText: 'This field has an error',
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colors.destructive),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: const Text('Invalid input'),
                  ),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'success',
              labels: const ['VFormFooter(success: ...)'],
              children: [
                VFormFooter(
                  success: true,
                  successText: 'Input is valid',
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: const Text('Valid input'),
                  ),
                ),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Counter',
          children: [
            WidgetbookSubsection(
              title: 'with maxLength',
              labels: const ['VFormFooter(currentLength: ..., maxLength: ...)'],
              children: [
                VFormFooter(
                  helper: 'Enter your bio',
                  currentLength: 45,
                  maxLength: 100,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: const Text('Some text here...'),
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
              'Use to display help, error, or success messages below a field',
            ),
            _guidelineRow(
              theme,
              'Helper',
              'Provide helpful information about input format, constraints, etc.',
            ),
            _guidelineRow(
              theme,
              'Error',
              'Provide specific messages with resolution steps when validation fails',
            ),
            _guidelineRow(
              theme,
              'Success',
              'Positive feedback confirming the input value is valid',
            ),
            _guidelineRow(
              theme,
              'Counter',
              'Display current/max character count for fields with maxLength',
            ),
            _guidelineRow(
              theme,
              'Priority',
              'Message priority order: error > success > helper',
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

class _FormFooterSample extends StatelessWidget {
  const _FormFooterSample();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return WidgetbookPageLayout(
      title: 'VFormFooter Samples',
      description: 'Copy-ready code examples.',
      children: [
        WidgetbookCodeBlock(
          title: 'Helper Text',
          code: '''VFormFooter(
  helper: 'Enter your username',
  child: MyInputWidget(),
)''',
          preview: VFormFooter(
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
          title: 'Error Message',
          code: '''VFormFooter(
  error: true,
  errorText: 'Invalid email format',
  child: MyInputWidget(),
)''',
          preview: VFormFooter(
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
          title: 'Character Counter',
          code: '''VFormFooter(
  helper: 'Enter your bio',
  currentLength: controller.text.length,
  maxLength: 100,
  child: MyInputWidget(),
)''',
          preview: VFormFooter(
            helper: 'Enter your bio',
            currentLength: 45,
            maxLength: 100,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: theme.colors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: const Text('Some text here...'),
            ),
          ),
        ),
        const WidgetbookCodeBlock(
          title: 'Success message',
          code: '''VFormFooter(
  success: true,
  successText: 'Email is available!',
  child: VFormBody(child: Text('user@example.com')),
)''',
          preview: VFormFooter(
            success: true,
            successText: 'Email is available!',
            child: VFormBody(child: Text('user@example.com')),
          ),
        ),
        const WidgetbookCodeBlock(
          title: 'With link',
          code: '''VFormFooter(
  helper: 'Forgot your password?',
  extra: VLink(onTap: () {}, child: Text('Reset password')),
  child: VFormBody(child: Text('********')),
)''',
          preview: VFormFooter(
            helper: 'Forgot your password?',
            child: VFormBody(child: Text('********')),
          ),
        ),
        const WidgetbookCodeBlock(
          title: 'With counter',
          code: '''VFormFooter(
  helper: '42 / 200 characters',
  child: VFormBody(child: Text('Some input text...')),
)''',
          preview: VFormFooter(
            helper: '42 / 200 characters',
            child: VFormBody(child: Text('Some input text...')),
          ),
        ),
      ],
    );
  }
}
