import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vTextFieldComponent() => WidgetbookComponent(
  name: 'VTextField',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _textFieldPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _TextFieldShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _TextFieldSample(),
    ),
  ],
);

Widget _textFieldPlayground(BuildContext context) {
  final k = context.knobs;
  final kind = k.object.dropdown<_TextFieldKind>(
    label: 'variant',
    options: _TextFieldKind.values,
    initialOption: _TextFieldKind.text,
    labelBuilder: (v) => v.name,
  );
  final type = k.object.dropdown<VFormBodyType>(
    label: 'type',
    options: VFormBodyType.values,
    initialOption: VFormBodyType.outlined,
    labelBuilder: (v) => v.name,
  );
  final size = k.object.dropdown<VFormBodySize>(
    label: 'size',
    options: VFormBodySize.values,
    initialOption: VFormBodySize.md,
    labelBuilder: (v) => v.name,
  );
  final color = k.object.dropdown<VFormBodyColor>(
    label: 'color',
    options: VFormBodyColor.values,
    initialOption: VFormBodyColor.primary,
    labelBuilder: (v) => v.name,
  );
  final corner = k.object.dropdown<VFormBodyCorner>(
    label: 'corner',
    options: VFormBodyCorner.values,
    initialOption: VFormBodyCorner.rounded,
    labelBuilder: (v) => v.name,
  );
  final label = k.stringOrNull(label: 'label', initialValue: 'Name');
  final placeholder = k.stringOrNull(
    label: 'placeholder',
    initialValue: 'Enter text...',
  );
  final helper = k.stringOrNull(label: 'helper');
  final error = k.boolean(label: 'error');
  final errorText = k.stringOrNull(label: 'errorText');
  final success = k.boolean(label: 'success');
  final successText = k.stringOrNull(label: 'successText');
  final suffix = k.stringOrNull(label: 'suffix');
  final maxLength = k.int.slider(label: 'maxLength', max: 100);
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final readOnly = k.boolean(label: 'readOnly');
  final loading = k.boolean(label: 'loading');
  final clearable = k.boolean(label: 'clearable');
  final required = k.boolean(label: 'required');
  final floatingLabel = k.boolean(label: 'floatingLabel');
  final fullWidth = k.boolean(label: 'fullWidth');
  var text = '';

  return StatefulBuilder(
    builder: (context, setState) {
      void onChanged(String v) => setState(() => text = v);
      final limit = maxLength == 0 ? null : maxLength;
      final field = switch (kind) {
        _TextFieldKind.email => VTextField.email(
          name: 'playground',
          onChanged: onChanged,
          label: label,
          placeholder: placeholder,
          helper: helper,
          error: error,
          errorText: errorText,
          success: success,
          successText: successText,
          suffix: suffix,
          type: type,
          size: size,
          color: color,
          corner: corner,
          maxLength: limit,
          enabled: enabled,
          readOnly: readOnly,
          loading: loading,
          clearable: clearable,
          required: required,
          floatingLabel: floatingLabel,
          fullWidth: fullWidth,
        ),
        _TextFieldKind.password => VTextField.password(
          name: 'playground',
          onChanged: onChanged,
          label: label,
          placeholder: placeholder,
          helper: helper,
          error: error,
          errorText: errorText,
          success: success,
          successText: successText,
          suffix: suffix,
          type: type,
          size: size,
          color: color,
          corner: corner,
          maxLength: limit,
          enabled: enabled,
          readOnly: readOnly,
          loading: loading,
          clearable: clearable,
          required: required,
          floatingLabel: floatingLabel,
          fullWidth: fullWidth,
        ),
        _TextFieldKind.search => VTextField.search(
          name: 'playground',
          onChanged: onChanged,
          label: label,
          placeholder: placeholder,
          helper: helper,
          error: error,
          errorText: errorText,
          success: success,
          successText: successText,
          suffix: suffix,
          type: type,
          size: size,
          color: color,
          corner: corner,
          maxLength: limit,
          enabled: enabled,
          readOnly: readOnly,
          loading: loading,
          clearable: clearable,
          required: required,
          floatingLabel: floatingLabel,
          fullWidth: fullWidth,
        ),
        _TextFieldKind.number => VTextField.number(
          name: 'playground',
          onChanged: onChanged,
          label: label,
          placeholder: placeholder,
          helper: helper,
          error: error,
          errorText: errorText,
          success: success,
          successText: successText,
          suffix: suffix,
          type: type,
          size: size,
          color: color,
          corner: corner,
          maxLength: limit,
          enabled: enabled,
          readOnly: readOnly,
          loading: loading,
          clearable: clearable,
          required: required,
          floatingLabel: floatingLabel,
          fullWidth: fullWidth,
        ),
        _TextFieldKind.phone => VTextField.phone(
          name: 'playground',
          onChanged: onChanged,
          label: label,
          placeholder: placeholder,
          helper: helper,
          error: error,
          errorText: errorText,
          success: success,
          successText: successText,
          suffix: suffix,
          type: type,
          size: size,
          color: color,
          corner: corner,
          maxLength: limit,
          enabled: enabled,
          readOnly: readOnly,
          loading: loading,
          clearable: clearable,
          required: required,
          floatingLabel: floatingLabel,
          fullWidth: fullWidth,
        ),
        _TextFieldKind.url => VTextField.url(
          name: 'playground',
          onChanged: onChanged,
          label: label,
          placeholder: placeholder,
          helper: helper,
          error: error,
          errorText: errorText,
          success: success,
          successText: successText,
          suffix: suffix,
          type: type,
          size: size,
          color: color,
          corner: corner,
          maxLength: limit,
          enabled: enabled,
          readOnly: readOnly,
          loading: loading,
          clearable: clearable,
          required: required,
          floatingLabel: floatingLabel,
          fullWidth: fullWidth,
        ),
        _TextFieldKind.text => VTextField(
          name: 'playground',
          onChanged: onChanged,
          label: label,
          placeholder: placeholder,
          helper: helper,
          error: error,
          errorText: errorText,
          success: success,
          successText: successText,
          suffix: suffix,
          type: type,
          size: size,
          color: color,
          corner: corner,
          maxLength: limit,
          enabled: enabled,
          readOnly: readOnly,
          loading: loading,
          clearable: clearable,
          required: required,
          floatingLabel: floatingLabel,
          fullWidth: fullWidth,
        ),
      };
      return WidgetbookPlayground(
        info: ['text: "$text"'],
        child: SizedBox(width: 320, child: field),
      );
    },
  );
}

enum _TextFieldKind { text, email, password, search, number, phone, url }

// =============================================================================
// Showcase
// =============================================================================

class _TextFieldShowcase extends StatelessWidget {
  const _TextFieldShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VTextField',
    description: 'Single-line text input for forms and data entry.',
    children: [
      // Types
      const WidgetbookSection(
        title: 'Types',
        children: [
          WidgetbookSubsection(
            title: 'text',
            labels: ['type="text"'],
            children: [
              SizedBox(
                width: 250,
                child: VTextField(name: 'text', placeholder: 'Enter your name'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'email',
            labels: ['type="email"'],
            children: [
              SizedBox(
                width: 250,
                child: VTextField.email(
                  name: 'email',
                  placeholder: 'user@example.com',
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'password',
            labels: ['type="password"'],
            children: [
              SizedBox(
                width: 250,
                child: VTextField.password(
                  name: 'password',
                  placeholder: 'Password',
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'number',
            labels: ['type="number"'],
            children: [
              SizedBox(
                width: 250,
                child: VTextField.number(name: 'number', placeholder: '0'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'search',
            labels: ['type="search"'],
            children: [
              SizedBox(
                width: 250,
                child: VTextField.search(
                  name: 'search',
                  placeholder: 'Search...',
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'phone',
            labels: ['type="phone"'],
            children: [
              SizedBox(
                width: 250,
                child: VTextField.phone(
                  name: 'phone',
                  placeholder: '010-1234-5678',
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'url',
            labels: ['type="url"'],
            children: [
              SizedBox(
                width: 250,
                child: VTextField.url(
                  name: 'url',
                  placeholder: 'https://example.com',
                ),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'sm',
            labels: ['size="sm"'],
            children: [
              SizedBox(
                width: 180,
                child: VTextField(
                  name: 'sm',
                  placeholder: 'Small',
                  size: VFormBodySize.sm,
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: ['size="md"'],
            children: [
              SizedBox(
                width: 180,
                child: VTextField(name: 'md', placeholder: 'Medium'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: ['size="lg"'],
            children: [
              SizedBox(
                width: 180,
                child: VTextField(
                  name: 'lg',
                  placeholder: 'Large',
                  size: VFormBodySize.lg,
                ),
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
                width: 300,
                child: VTextField(
                  name: 'username',
                  label: 'Username',
                  placeholder: 'Enter username',
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'helper text',
            labels: ['helperText="..."'],
            children: [
              SizedBox(
                width: 300,
                child: VTextField(
                  name: 'email_helper',
                  label: 'Email',
                  placeholder: 'user@example.com',
                  helper: 'We will never share your email',
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
                width: 200,
                child: VTextField(
                  name: 'enabled',
                  placeholder: 'Default state',
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: ['disabled'],
            children: [
              SizedBox(
                width: 200,
                child: VTextField(
                  name: 'disabled',
                  placeholder: 'Disabled',
                  enabled: false,
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'error',
            labels: ['error', 'errorText="..."'],
            children: [
              SizedBox(
                width: 200,
                child: VTextField(
                  name: 'error_state',
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
        title: 'Adornments',
        children: [
          WidgetbookSubsection(
            title: 'start adornment',
            labels: ['startAdornment={...}'],
            children: [
              SizedBox(
                width: 250,
                child: VTextField(
                  name: 'start_adorn',
                  leading: Text(r'$'),
                  placeholder: '0.00',
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'end adornment',
            labels: ['endAdornment={...}'],
            children: [
              SizedBox(
                width: 250,
                child: VTextField(
                  name: 'end_adorn',
                  suffix: 'kg',
                  placeholder: 'Weight',
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'both',
            labels: ['startAdornment', 'endAdornment'],
            children: [
              SizedBox(
                width: 250,
                child: VTextField(
                  name: 'both_adorn',
                  leading: Text('@'),
                  suffix: '.com',
                  placeholder: 'username',
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
            children: [
              VTextField(
                name: 'full_width',
                fullWidth: true,
                placeholder: 'Full width input',
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
              'Short single-line input: names, emails, passwords, search queries',
            ),
            _guidelineRow(
              theme,
              'Label',
              'Always provide a label for accessibility. Use placeholder as hint only',
            ),
            _guidelineRow(
              theme,
              'Validation',
              'Show error state with errorText on blur or submit, not on every keystroke',
            ),
            _guidelineRow(
              theme,
              'Helper text',
              'Use for format hints or constraints (e.g., "Max 50 characters")',
            ),
            _guidelineRow(
              theme,
              'Disabled',
              'When input is not applicable in current context. Explain why if possible',
            ),
            _guidelineRow(
              theme,
              'Adornments',
              r'Use for units ($, kg) or icons. Keep them concise',
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

class _TextFieldSample extends StatelessWidget {
  const _TextFieldSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VTextField Samples',
    description: 'Copy-paste code examples for common text field patterns.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Basic input',
        code: '''VTextField(
  name: 'name',
  label: 'Name',
  placeholder: 'Enter your name',
)''',
        preview: SizedBox(
          width: 300,
          child: VTextField(
            name: 'name',
            label: 'Name',
            placeholder: 'Enter your name',
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Email with helper text',
        code: '''VTextField.email(
  name: 'email',
  label: 'Email',
  placeholder: 'user@example.com',
  helper: 'We will never share your email',
)''',
        preview: SizedBox(
          width: 300,
          child: VTextField.email(
            name: 'email',
            label: 'Email',
            placeholder: 'user@example.com',
            helper: 'We will never share your email',
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Password field',
        code: '''VTextField.password(
  name: 'password',
  label: 'Password',
  placeholder: 'Enter password',
)''',
        preview: SizedBox(
          width: 300,
          child: VTextField.password(
            name: 'password',
            label: 'Password',
            placeholder: 'Enter password',
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Error state',
        code: '''VTextField(
  name: 'username',
  label: 'Username',
  error: true,
  errorText: 'Username is already taken',
  value: 'john_doe',
)''',
        preview: SizedBox(
          width: 300,
          child: VTextField(
            name: 'username',
            label: 'Username',
            error: true,
            errorText: 'Username is already taken',
            value: 'john_doe',
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'With adornment',
        code: r'''VTextField(
  name: 'price',
  leading: Text('$'),
  placeholder: '0.00',
)''',
        preview: SizedBox(
          width: 300,
          child: VTextField(
            name: 'price',
            leading: Text(r'$'),
            placeholder: '0.00',
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Full width',
        code: '''VTextField(
  name: 'full',
  fullWidth: true,
  placeholder: 'Full width input',
)''',
        preview: VTextField(
          name: 'full',
          fullWidth: true,
          placeholder: 'Full width input',
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Login Form',
        code: '''VForm(
  children: [
    VTextField.email(name: 'email', label: 'Email', placeholder: 'Enter email'),
    VTextField.password(name: 'password', label: 'Password'),
    VButton(onPressed: () {}, child: 'Sign In'),
  ],
)''',
        preview: VForm(
          children: [
            const VTextField.email(
              name: 'email',
              label: 'Email',
              placeholder: 'Enter email',
            ),
            const VTextField.password(name: 'password', label: 'Password'),
            VButton(onPressed: () {}, child: const Text('Sign In')),
          ],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Search with clear button',
        code: '''VTextField.search(
  name: 'search',
  placeholder: 'Search...',
  clearable: true,
  fullWidth: true,
  onChanged: (value) => performSearch(value),
)''',
        preview: SizedBox(
          width: 300,
          child: VTextField.search(
            name: 'search',
            placeholder: 'Search...',
            clearable: true,
            fullWidth: true,
          ),
        ),
      ),
    ],
  );
}
