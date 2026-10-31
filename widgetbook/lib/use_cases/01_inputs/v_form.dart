import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

/// VForm props metadata.

WidgetbookComponent vFormComponent() => WidgetbookComponent(
  name: 'VForm',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _formPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _FormShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _FormSample(),
    ),
  ],
);

Widget _formPlayground(BuildContext context) {
  final k = context.knobs;
  final autoValidateMode = k.object.dropdown<VFormAutoValidateMode>(
    label: 'autoValidateMode',
    options: VFormAutoValidateMode.values,
    labelBuilder: (v) => v.name,
  );
  final spacing = k.double.slider(label: 'spacing', initialValue: 16, max: 48);
  var changes = 0;

  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      info: ['changes: $changes'],
      child: SizedBox(
        width: 320,
        child: VForm(
          autoValidateMode: autoValidateMode,
          spacing: spacing,
          onChanged: () => setState(() => changes++),
          children: [
            VTextField(
              name: 'name',
              label: 'Name',
              placeholder: 'Enter your name',
              validator: (v) => (v ?? '').isEmpty ? 'Required' : null,
            ),
            VTextField.email(
              name: 'email',
              label: 'Email',
              required: true,
              validator: (v) =>
                  (v ?? '').contains('@') ? null : 'Enter a valid email',
            ),
          ],
        ),
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _FormShowcase extends StatelessWidget {
  const _FormShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VForm',
    description:
        'Form container component that wraps form elements and handles submission.',
    children: [
      WidgetbookSection(
        title: 'Form Patterns',
        children: [
          WidgetbookSubsection(
            title: 'simple form',
            labels: const ['basic structure'],
            fullWidth: true,
            children: [
              VForm(
                children: [
                  const VTextField(name: 'username', label: 'Username'),
                  VButton(onPressed: () {}, child: const Text('Submit')),
                ],
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'contact form',
            labels: const ['VFormField composition'],
            fullWidth: true,
            children: [
              VForm(
                children: [
                  const VTextField(name: 'name', label: 'Name'),
                  const VTextField(name: 'email', label: 'Email'),
                  const VTextArea(label: 'Message'),
                  VButton(onPressed: () {}, child: const Text('Send Message')),
                ],
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
            fullWidth: true,
            children: [
              VForm(
                children: [
                  const VTextField(name: 'email', label: 'Email'),
                  VButton(onPressed: () {}, child: const Text('Submit')),
                ],
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'validation errors',
            labels: const ['error states'],
            fullWidth: true,
            children: [
              VForm(
                children: [
                  const VTextField(
                    name: 'email',
                    label: 'Email',
                    error: true,
                    errorText: 'Invalid email format',
                  ),
                  const VTextField(
                    name: 'password',
                    label: 'Password',
                    error: true,
                    errorText: 'Must be at least 8 characters',
                  ),
                  VButton(onPressed: () {}, child: const Text('Submit')),
                ],
              ),
            ],
          ),
          const WidgetbookSubsection(
            title: 'disabled',
            labels: ['disabled fields'],
            fullWidth: true,
            children: [
              VForm(
                children: [
                  VTextField(name: 'email', label: 'Email', enabled: false),
                  VButton(child: Text('Submit')),
                ],
              ),
            ],
          ),
        ],
      ),

      // Usage Guidelines
      WidgetbookSection(
        title: 'Usage Guidelines',
        children: [_UsageGuidelinesTable()],
      ),
    ],
  );
}

class _UsageGuidelinesTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    return Table(
      columnWidths: const {0: FixedColumnWidth(160), 1: FlexColumnWidth()},
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: theme.colors.muted,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          children: [
            _tableHeader(theme, 'Category'),
            _tableHeader(theme, 'Guideline'),
          ],
        ),
        _guidelineRow(
          theme,
          'When to use',
          'Wrap related form inputs for data collection: login, registration, contact',
        ),
        _guidelineRow(
          theme,
          'formKey',
          'Validate or save programmatically through the form key',
        ),
        _guidelineRow(
          theme,
          'Validation',
          'Validate on submit. Show inline errors per field. Disable submit if needed',
        ),
        _guidelineRow(
          theme,
          'Layout',
          'Use VFormField for consistent spacing and label/error alignment',
        ),
        _guidelineRow(
          theme,
          'Accessibility',
          'Use proper labels, required indicators, and error announcements',
        ),
        _guidelineRow(
          theme,
          'Submit button',
          'Place submit button at the bottom. Use loading state during async submission',
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

class _FormSample extends StatelessWidget {
  const _FormSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VForm Samples',
    description: 'Copy-paste code examples for VForm.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic form',
        code: '''VForm(
  children: [
    VTextField(name: 'name', label: 'Name'),
    VButton(onPressed: () {}, child: 'Submit'),
  ],
)''',
        preview: VForm(
          children: [
            const VTextField(name: 'name', label: 'Name'),
            VButton(onPressed: () {}, child: const Text('Submit')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Login form',
        code: '''VForm(
  children: [
    VTextField(name: 'email', label: 'Email'),
    VTextField(name: 'password', label: 'Password'),
    VButton(onPressed: () {}, fullWidth: true, child: 'Sign In'),
  ],
)''',
        preview: VForm(
          children: [
            const VTextField(name: 'email', label: 'Email'),
            const VTextField(name: 'password', label: 'Password'),
            VButton(
              onPressed: () {},
              fullWidth: true,
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Contact form',
        code: '''VForm(
  children: [
    VTextField(name: 'name', label: 'Name'),
    VTextField(name: 'email', label: 'Email'),
    VTextArea(name: 'message', label: 'Message'),
    VButton(onPressed: () {}, child: 'Send'),
  ],
)''',
        preview: VForm(
          children: [
            const VTextField(name: 'name', label: 'Name'),
            const VTextField(name: 'email', label: 'Email'),
            const VTextArea(label: 'Message'),
            VButton(onPressed: () {}, child: const Text('Send')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Error state form',
        code: '''VForm(
  children: [
    VTextField(name: 'email', label: 'Email', error: true, errorText: 'Invalid email format'),
    VButton(onPressed: () {}, child: 'Submit'),
  ],
)''',
        preview: VForm(
          children: [
            const VTextField(
              name: 'email',
              label: 'Email',
              error: true,
              errorText: 'Invalid email format',
            ),
            VButton(onPressed: () {}, child: const Text('Submit')),
          ],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Registration Form',
        code: '''VForm(
  children: [
    VTextField(name: 'fullName', label: 'Full Name'),
    VTextField.email(name: 'email', label: 'Email', required: true),
    VSelect<String>(
      label: 'Country',
      items: [
        VSelectItem(value: 'us', label: 'United States'),
        VSelectItem(value: 'kr', label: 'South Korea'),
        VSelectItem(value: 'jp', label: 'Japan'),
      ],
      onChanged: (v) {},
    ),
    VDatePicker.date(label: 'Date of Birth'),
    VCheckbox(value: false, label: 'I agree to the Terms', onChanged: (_) {}),
    VButton(onPressed: () {}, child: 'Register'),
  ],
)''',
      ),
      const _RegistrationFormPreview(),
      const WidgetbookCodeBlock(
        title: 'Settings Form',
        code: '''VForm(
  children: [
    VSwitch(value: true, label: 'Dark Mode', onChanged: (v) {}),
    VSwitch(value: false, label: 'Notifications', onChanged: (v) {}),
    VSlider(value: 70, max: 100, showLabel: true, onChanged: (v) {}),
    VButton(onPressed: () {}, child: 'Save'),
  ],
)''',
      ),
      const _SettingsFormPreview(),
      const WidgetbookCodeBlock(
        title: 'Survey Form',
        code: '''VForm(
  children: [
    // Radio group
    VRadio<String>(value: 'good', groupValue: selected, label: 'Good', onChanged: (v) {}),
    VRadio<String>(value: 'average', groupValue: selected, label: 'Average', onChanged: (v) {}),
    VRadio<String>(value: 'poor', groupValue: selected, label: 'Poor', onChanged: (v) {}),
    // Multi-select checkboxes
    VCheckbox(value: false, label: 'Design', onChanged: (_) {}),
    VCheckbox(value: false, label: 'Performance', onChanged: (_) {}),
    VCheckbox(value: false, label: 'Usability', onChanged: (_) {}),
    // Comment
    VTextArea(label: 'Additional Comments'),
    VButton(onPressed: () {}, child: 'Submit Survey'),
  ],
)''',
      ),
      const _SurveyFormPreview(),
      const WidgetbookCodeBlock(
        title: 'Preferences Form',
        code: '''VForm(
  children: [
    VCheckbox(value: darkMode, onChanged: (v) => setState(() => darkMode = v ?? false), label: 'Dark Mode'),
    VSwitch(value: notifications, onChanged: (v) => setState(() => notifications = v), label: 'Notifications'),
    VSwitch(value: autoUpdate, onChanged: (v) => setState(() => autoUpdate = v), label: 'Auto Update'),
    VButton(onPressed: () {}, child: Text('Save Preferences')),
  ],
)''',
        preview: _PreferencesFormPreview(),
      ),
    ],
  );
}

// -----------------------------------------------------------------------------
// Registration Form Preview (StatefulWidget)
// -----------------------------------------------------------------------------

class _RegistrationFormPreview extends StatefulWidget {
  const _RegistrationFormPreview();

  @override
  State<_RegistrationFormPreview> createState() =>
      _RegistrationFormPreviewState();
}

class _RegistrationFormPreviewState extends State<_RegistrationFormPreview> {
  String? _country;
  DateTime? _birthDate;
  bool _agreeTerms = false;

  @override
  Widget build(BuildContext context) => WidgetbookCodeBlock(
    title: 'Registration Form (Live)',
    code: '// Interactive preview — try the controls',
    preview: VForm(
      children: [
        const VTextField(name: 'fullName', label: 'Full Name'),
        const VTextField.email(name: 'email', label: 'Email', required: true),
        VSelect<String>(
          label: 'Country',
          value: _country,
          onChanged: (v) => setState(() => _country = v),
          items: const [
            VSelectItem(value: 'us', label: 'United States'),
            VSelectItem(value: 'kr', label: 'South Korea'),
            VSelectItem(value: 'jp', label: 'Japan'),
          ],
        ),
        VDatePicker.date(
          label: 'Date of Birth',
          value: _birthDate,
          onChanged: (v) => setState(() => _birthDate = v),
        ),
        VCheckbox(
          value: _agreeTerms,
          label: const Text('I agree to the Terms'),
          onChanged: (v) => setState(() => _agreeTerms = v ?? false),
        ),
        VButton(onPressed: () {}, child: const Text('Register')),
      ],
    ),
  );
}

// -----------------------------------------------------------------------------
// Settings Form Preview (StatefulWidget)
// -----------------------------------------------------------------------------

class _SettingsFormPreview extends StatefulWidget {
  const _SettingsFormPreview();

  @override
  State<_SettingsFormPreview> createState() => _SettingsFormPreviewState();
}

class _SettingsFormPreviewState extends State<_SettingsFormPreview> {
  bool _darkMode = true;
  bool _notifications = false;
  double _volume = 70;

  @override
  Widget build(BuildContext context) => WidgetbookCodeBlock(
    title: 'Settings Form (Live)',
    code: '// Interactive preview — try the controls',
    preview: VForm(
      children: [
        VSwitch(
          value: _darkMode,
          label: const Text('Dark Mode'),
          onChanged: (v) => setState(() => _darkMode = v),
        ),
        VSwitch(
          value: _notifications,
          label: const Text('Notifications'),
          onChanged: (v) => setState(() => _notifications = v),
        ),
        VSlider(
          value: _volume,
          showLabel: true,
          onChanged: (v) => setState(() => _volume = v),
        ),
        VButton(onPressed: () {}, child: const Text('Save')),
      ],
    ),
  );
}

// -----------------------------------------------------------------------------
// Survey Form Preview (StatefulWidget)
// -----------------------------------------------------------------------------

class _SurveyFormPreview extends StatefulWidget {
  const _SurveyFormPreview();

  @override
  State<_SurveyFormPreview> createState() => _SurveyFormPreviewState();
}

class _SurveyFormPreviewState extends State<_SurveyFormPreview> {
  String? _rating;
  bool _design = false;
  bool _performance = false;
  bool _usability = false;

  @override
  Widget build(BuildContext context) => WidgetbookCodeBlock(
    title: 'Survey Form (Live)',
    code: '// Interactive preview — try the controls',
    preview: VForm(
      children: [
        VRadio<String>(
          value: 'good',
          groupValue: _rating,
          label: const Text('Good'),
          onChanged: (v) => setState(() => _rating = v),
        ),
        VRadio<String>(
          value: 'average',
          groupValue: _rating,
          label: const Text('Average'),
          onChanged: (v) => setState(() => _rating = v),
        ),
        VRadio<String>(
          value: 'poor',
          groupValue: _rating,
          label: const Text('Poor'),
          onChanged: (v) => setState(() => _rating = v),
        ),
        VCheckbox(
          value: _design,
          label: const Text('Design'),
          onChanged: (v) => setState(() => _design = v ?? false),
        ),
        VCheckbox(
          value: _performance,
          label: const Text('Performance'),
          onChanged: (v) => setState(() => _performance = v ?? false),
        ),
        VCheckbox(
          value: _usability,
          label: const Text('Usability'),
          onChanged: (v) => setState(() => _usability = v ?? false),
        ),
        const VTextArea(label: 'Additional Comments'),
        VButton(onPressed: () {}, child: const Text('Submit Survey')),
      ],
    ),
  );
}

// -----------------------------------------------------------------------------
// Preferences Form Preview (StatefulWidget)
// -----------------------------------------------------------------------------

class _PreferencesFormPreview extends StatefulWidget {
  const _PreferencesFormPreview();

  @override
  State<_PreferencesFormPreview> createState() =>
      _PreferencesFormPreviewState();
}

class _PreferencesFormPreviewState extends State<_PreferencesFormPreview> {
  bool _darkMode = true;
  bool _notifications = true;
  bool _autoUpdate = false;

  @override
  Widget build(BuildContext context) => VForm(
    children: [
      VCheckbox(
        value: _darkMode,
        label: const Text('Dark Mode'),
        onChanged: (v) => setState(() => _darkMode = v ?? false),
      ),
      VSwitch(
        value: _notifications,
        label: const Text('Notifications'),
        onChanged: (v) => setState(() => _notifications = v),
      ),
      VSwitch(
        value: _autoUpdate,
        label: const Text('Auto Update'),
        onChanged: (v) => setState(() => _autoUpdate = v),
      ),
      VButton(onPressed: () {}, child: const Text('Save Preferences')),
    ],
  );
}
