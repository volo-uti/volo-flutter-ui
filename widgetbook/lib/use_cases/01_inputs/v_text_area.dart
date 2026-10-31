import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vTextAreaComponent() => WidgetbookComponent(
  name: 'VTextArea',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _textAreaPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _TextAreaShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _TextAreaSample(),
    ),
  ],
);

Widget _textAreaPlayground(BuildContext context) {
  final k = context.knobs;
  final label = k.stringOrNull(label: 'label', initialValue: 'Description');
  final placeholder = k.stringOrNull(
    label: 'placeholder',
    initialValue: 'Enter text...',
  );
  final helper = k.stringOrNull(label: 'helper');
  final error = k.boolean(label: 'error');
  final errorText = k.stringOrNull(label: 'errorText');
  final success = k.boolean(label: 'success');
  final successText = k.stringOrNull(label: 'successText');
  final minLines = k.int.slider(
    label: 'minLines',
    initialValue: 3,
    min: 1,
    max: 10,
  );
  final maxLines = k.int.slider(label: 'maxLines');
  final maxLength = k.int.slider(label: 'maxLength', max: 500);
  final showCounter = k.boolean(label: 'showCounter');
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final readOnly = k.boolean(label: 'readOnly');
  final required = k.boolean(label: 'required');
  final fullWidth = k.boolean(label: 'fullWidth');
  var text = '';

  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      info: ['length: ${text.length}'],
      child: SizedBox(
        width: fullWidth ? double.infinity : 400,
        child: VTextArea(
          onChanged: (v) => setState(() => text = v),
          label: label,
          placeholder: placeholder,
          helper: helper,
          error: error,
          errorText: errorText,
          success: success,
          successText: successText,
          minLines: minLines,
          maxLines: maxLines == 0 ? null : maxLines,
          maxLength: maxLength == 0 ? null : maxLength,
          showCounter: showCounter,
          enabled: enabled,
          readOnly: readOnly,
          required: required,
          fullWidth: fullWidth,
        ),
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _TextAreaShowcase extends StatelessWidget {
  const _TextAreaShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VTextArea',
    description:
        'Multi-line text input for longer content such as descriptions, comments, and messages.',
    children: [
      const WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'sm',
            labels: ['size="sm"'],
            children: [
              SizedBox(
                width: 400,
                child: VTextArea(placeholder: 'Small textarea'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: ['size="md"'],
            children: [
              SizedBox(
                width: 400,
                child: VTextArea(placeholder: 'Medium textarea'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: ['size="lg"'],
            children: [
              SizedBox(
                width: 400,
                child: VTextArea(placeholder: 'Large textarea'),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Label & Helper Text',
        children: [
          WidgetbookSubsection(
            title: 'label',
            labels: ['label="..."'],
            children: [
              SizedBox(
                width: 400,
                child: VTextArea(
                  label: 'Description',
                  placeholder: 'Enter a description',
                  maxLines: 5,
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'helper text',
            labels: ['helperText="..."'],
            children: [
              SizedBox(
                width: 400,
                child: VTextArea(
                  label: 'Bio',
                  placeholder: 'Tell us about yourself',
                  helper: 'Max 500 characters',
                  maxLines: 5,
                ),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: ['default'],
            children: [
              SizedBox(
                width: 400,
                child: VTextArea(placeholder: 'Default state'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: ['disabled'],
            children: [
              SizedBox(
                width: 400,
                child: VTextArea(placeholder: 'Disabled', enabled: false),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'error',
            labels: ['error', 'errorText="..."'],
            children: [
              SizedBox(
                width: 400,
                child: VTextArea(
                  placeholder: 'Error state',
                  error: true,
                  errorText: 'This field is required',
                ),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Resize',
        children: [
          WidgetbookSubsection(
            title: 'none',
            labels: ['resize="none"'],
            children: [
              SizedBox(
                width: 400,
                child: VTextArea(placeholder: 'Cannot resize', maxLines: 3),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'vertical',
            labels: ['resize="vertical"'],
            children: [
              SizedBox(
                width: 400,
                child: VTextArea(
                  placeholder: 'Vertical resize only',
                  maxLines: 8,
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'both',
            labels: ['resize="both"'],
            children: [
              SizedBox(
                width: 400,
                child: VTextArea(placeholder: 'Resize both directions'),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Auto Resize',
        children: [
          WidgetbookSubsection(
            title: 'auto resize',
            labels: ['autoResize'],
            children: [
              SizedBox(
                width: 400,
                child: VTextArea(
                  placeholder: 'Grows as you type...',
                  minLines: 2,
                ),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Rows',
        children: [
          WidgetbookSubsection(
            title: 'rows=2',
            labels: ['rows={2}'],
            children: [
              SizedBox(
                width: 400,
                child: VTextArea(
                  placeholder: '2 rows',
                  minLines: 2,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'rows=6',
            labels: ['rows={6}'],
            children: [
              SizedBox(
                width: 400,
                child: VTextArea(
                  placeholder: '6 rows',
                  minLines: 6,
                  maxLines: 6,
                ),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Full Width',
        children: [
          WidgetbookSubsection(
            title: 'full width',
            labels: ['fullWidth'],
            children: [VTextArea(placeholder: 'Full width textarea')],
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
              'Multi-line content: descriptions, comments, messages, notes',
            ),
            _guidelineRow(
              theme,
              'Rows',
              'Set initial rows to match expected content length (3-5 for short, 8+ for long)',
            ),
            _guidelineRow(
              theme,
              'Auto resize',
              'Enable for inputs where content length varies (e.g., chat messages)',
            ),
            _guidelineRow(
              theme,
              'Validation',
              'Show character count or limit via helperText. Show errorText on submit',
            ),
            _guidelineRow(
              theme,
              'Resize',
              'Default to vertical. Use none for fixed-height areas (e.g., code editors)',
            ),
            _guidelineRow(
              theme,
              'Disabled',
              'When content is read-only or not editable in current context',
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

class _TextAreaSample extends StatelessWidget {
  const _TextAreaSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VTextArea Samples',
    description: 'Copy-paste code examples for common textarea patterns.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Basic textarea',
        code: '''VTextArea(
  label: 'Description',
  placeholder: 'Enter description',
  minLines: 4,
)''',
        preview: SizedBox(
          width: 400,
          child: VTextArea(
            label: 'Description',
            placeholder: 'Enter description',
            minLines: 4,
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'With helper text',
        code: '''VTextArea(
  label: 'Bio',
  placeholder: 'Tell us about yourself',
  helper: 'Max 500 characters',
  minLines: 4,
)''',
        preview: SizedBox(
          width: 400,
          child: VTextArea(
            label: 'Bio',
            placeholder: 'Tell us about yourself',
            helper: 'Max 500 characters',
            minLines: 4,
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Auto-resizing',
        code: '''VTextArea(
  placeholder: 'Type to expand...',
  minLines: 2,
)''',
        preview: SizedBox(
          width: 400,
          child: VTextArea(placeholder: 'Type to expand...', minLines: 2),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Error state',
        code: '''VTextArea(
  label: 'Comment',
  error: true,
  errorText: 'Comment cannot be empty',
  minLines: 3,
)''',
        preview: SizedBox(
          width: 400,
          child: VTextArea(
            label: 'Comment',
            error: true,
            errorText: 'Comment cannot be empty',
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Non-resizable full width',
        code: '''VTextArea(
  minLines: 4,
  maxLines: 4,
  placeholder: 'Fixed size',
)''',
        preview: SizedBox(
          width: 400,
          child: VTextArea(minLines: 4, maxLines: 4, placeholder: 'Fixed size'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Feedback Form',
        code: '''VForm(
  children: [
    VTextField(name: 'subject', label: 'Subject'),
    VTextArea(label: 'Message', placeholder: 'Your feedback...'),
    VButton(onPressed: () {}, child: 'Submit'),
  ],
)''',
        preview: VForm(
          children: [
            const VTextField(name: 'subject', label: 'Subject'),
            const VTextArea(label: 'Message', placeholder: 'Your feedback...'),
            VButton(onPressed: () {}, child: const Text('Submit')),
          ],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Character counter',
        code: '''VTextArea(
  label: 'Bio',
  placeholder: 'Tell us about yourself...',
  maxLength: 200,
  showCounter: true,
  minLines: 4,
  helper: 'Brief description for your profile',
)''',
        preview: SizedBox(
          width: 400,
          child: VTextArea(
            label: 'Bio',
            placeholder: 'Tell us about yourself...',
            maxLength: 200,
            showCounter: true,
            minLines: 4,
            helper: 'Brief description for your profile',
          ),
        ),
      ),
    ],
  );
}
