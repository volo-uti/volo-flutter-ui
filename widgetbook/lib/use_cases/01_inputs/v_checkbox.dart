import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vCheckboxComponent() => WidgetbookComponent(
  name: 'VCheckbox',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _checkboxPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _CheckboxShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _CheckboxSample(),
    ),
  ],
);

Widget _checkboxPlayground(BuildContext context) {
  final k = context.knobs;
  final grouped = k.boolean(label: 'group');
  final card = k.boolean(label: 'card');
  final size = k.object.dropdown<VWidgetSize>(
    label: 'size',
    options: VWidgetSize.values,
    initialOption: VWidgetSize.md,
    labelBuilder: (v) => v.name,
  );
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final label = k.string(label: 'label', initialValue: 'Agree to terms');
  final sublabel = k.string(label: 'sublabel');
  final orientation = k.object.dropdown<Axis>(
    label: 'orientation',
    options: Axis.values,
    initialOption: Axis.vertical,
    labelBuilder: (v) => v.name,
  );
  var checked = k.object.dropdown<bool?>(
    label: 'value',
    options: const [false, true, null],
    initialOption: false,
    labelBuilder: (v) => v?.toString() ?? 'indeterminate',
  );
  var selected = <String>['a'];

  Widget? sub() => sublabel.isEmpty ? null : Text(sublabel);

  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      info: [
        if (grouped) 'values: ${selected.join(', ')}' else 'value: $checked',
      ],
      child: grouped
          ? SizedBox(
              width: 300,
              child: VCheckboxGroup<String>(
                options: [
                  for (final id in const ['a', 'b', 'c'])
                    VCheckboxItem(
                      value: id,
                      label: Text('$label ${id.toUpperCase()}'),
                      sublabel: sub(),
                    ),
                ],
                values: selected,
                onChanged: (v) => setState(() => selected = v),
                orientation: orientation,
                size: size,
                enabled: enabled,
              ),
            )
          : card
          ? VCheckbox.card(
              value: checked,
              onChanged: (v) => setState(() => checked = v),
              label: Text(label),
              sublabel: sub(),
              enabled: enabled,
              size: size,
            )
          : VCheckbox(
              value: checked,
              onChanged: (v) => setState(() => checked = v),
              label: Text(label),
              sublabel: sub(),
              enabled: enabled,
              size: size,
            ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _CheckboxShowcase extends StatelessWidget {
  const _CheckboxShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VCheckbox',
    description:
        'Toggle a single boolean value on or off, or manage multiple selections as a group.',
    children: [
      const WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'sm',
            labels: ['size="sm"'],
            children: [
              _InteractiveCheckbox(label: 'Small', size: VWidgetSize.sm),
            ],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: ['size="md"'],
            children: [_InteractiveCheckbox(label: 'Medium')],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: ['size="lg"'],
            children: [
              _InteractiveCheckbox(label: 'Large', size: VWidgetSize.lg),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'unchecked',
            labels: const ['checked={false}'],
            children: [
              VCheckbox(
                value: false,
                onChanged: (_) {},
                label: const Text('Unchecked'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'checked',
            labels: const ['defaultChecked'],
            children: [
              VCheckbox(
                value: true,
                onChanged: (_) {},
                label: const Text('Checked'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'indeterminate',
            labels: const ['indeterminate'],
            children: [
              VCheckbox(
                value: null,
                onChanged: (_) {},
                label: const Text('Indeterminate'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: const ['disabled'],
            children: [
              VCheckbox(
                value: false,
                onChanged: (_) {},
                label: const Text('Disabled'),
                enabled: false,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled checked',
            labels: const ['disabled', 'defaultChecked'],
            children: [
              VCheckbox(
                value: true,
                onChanged: (_) {},
                label: const Text('Disabled Checked'),
                enabled: false,
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Card Variant',
        children: [
          WidgetbookSubsection(
            title: 'card unchecked',
            labels: const ['VCheckbox.card()'],
            children: [
              VCheckbox.card(
                value: false,
                onChanged: (_) {},
                label: const Text('Card Checkbox'),
                sublabel: const Text('Card-style variant'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'card checked',
            labels: const ['VCheckbox.card()', 'checked'],
            children: [
              VCheckbox.card(
                value: true,
                onChanged: (_) {},
                label: const Text('Card Checked'),
                sublabel: const Text('Active card with border highlight'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'card disabled',
            labels: const ['VCheckbox.card()', 'disabled'],
            children: [
              VCheckbox.card(
                value: true,
                onChanged: (_) {},
                label: const Text('Card Disabled'),
                enabled: false,
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Without Label',
        children: [
          WidgetbookSubsection(
            title: 'no label',
            labels: const ['VCheckbox()'],
            children: [VCheckbox(value: false, onChanged: (_) {})],
          ),
        ],
      ),

      // VCheckboxGroup
      const WidgetbookSection(
        title: 'VCheckboxGroup',
        children: [
          WidgetbookSubsection(
            title: 'vertical',
            labels: ['VCheckboxGroup', 'orientation="vertical"'],
            children: [_CheckboxGroupDemo()],
          ),
          WidgetbookSubsection(
            title: 'horizontal',
            labels: ['VCheckboxGroup', 'orientation="horizontal"'],
            children: [_CheckboxGroupDemo(orientation: Axis.horizontal)],
          ),
          WidgetbookSubsection(
            title: 'with disabled item',
            labels: ['VCheckboxGroup', 'VCheckboxItem.disabled'],
            children: [_CheckboxGroupWithDisabledDemo()],
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
              'Binary choices: agree/disagree, enable/disable, select items in a list',
            ),
            _guidelineRow(
              theme,
              'Label',
              'Always provide a label or aria-label for accessibility',
            ),
            _guidelineRow(
              theme,
              'Indeterminate',
              'Use for parent checkbox when some children are checked (select all pattern)',
            ),
            _guidelineRow(
              theme,
              'vs Switch',
              'Use checkbox for forms requiring submit. Use switch for instant toggles',
            ),
            _guidelineRow(
              theme,
              'Group',
              'For multi-select, use VCheckboxGroup. For single toggles, use VCheckbox',
            ),
            _guidelineRow(
              theme,
              'Disabled',
              'When the option is not available. Explain via tooltip or helper text',
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

class _CheckboxSample extends StatelessWidget {
  const _CheckboxSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VCheckbox Samples',
    description: 'Copy-paste code examples for common checkbox patterns.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Basic checkbox',
        code: '''VCheckbox(
  value: isChecked,
  onChanged: (value) => setState(() => isChecked = value),
  label: Text('I agree to the terms'),
)''',
        preview: Row(
          children: [_InteractiveCheckbox(label: 'I agree to the terms')],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Controlled checkbox',
        code: '''VCheckbox(
  value: isChecked,
  onChanged: (value) => setState(() => isChecked = value),
  label: Text('Enable notifications'),
)''',
        preview: Row(
          children: [_InteractiveCheckbox(label: 'Enable notifications')],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Indeterminate state',
        code: '''VCheckbox(
  value: null,
  onChanged: (_) {},
  label: Text('Select all'),
)''',
        preview: Row(
          children: [
            VCheckbox(
              value: null,
              onChanged: (_) {},
              label: const Text('Select all'),
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Disabled',
        code: '''VCheckbox(
  value: true,
  onChanged: (_) {},
  enabled: false,
  label: Text('Cannot change'),
)''',
        preview: Row(
          children: [
            VCheckbox(
              value: true,
              onChanged: (_) {},
              enabled: false,
              label: const Text('Cannot change'),
            ),
          ],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Preferences Form (VForm)',
        code: '''VForm(
  formKey: formKey,
  children: [
    VCheckbox(
      value: emailNotif,
      onChanged: (v) => setState(() => emailNotif = v ?? false),
      label: Text('Email notifications'),
    ),
    VCheckbox(
      value: smsNotif,
      onChanged: (v) => setState(() => smsNotif = v ?? false),
      label: Text('SMS notifications'),
    ),
    VCheckbox(
      value: pushNotif,
      onChanged: (v) => setState(() => pushNotif = v ?? false),
      label: Text('Push notifications'),
    ),
    VButton(
      onPressed: () {},
      child: Text('Save Preferences'),
    ),
  ],
)''',
        preview: _PreferencesFormDemo(),
      ),
      const WidgetbookCodeBlock(
        title: 'VCheckboxGroup (multi-select)',
        code: '''VCheckboxGroup<String>(
  options: [
    VCheckboxItem(value: 'email', label: Text('Email')),
    VCheckboxItem(value: 'sms', label: Text('SMS')),
    VCheckboxItem(value: 'push', label: Text('Push Notification')),
  ],
  values: selectedValues,
  onChanged: (v) => setState(() => selectedValues = v),
)''',
        preview: _CheckboxGroupDemo(),
      ),
      const WidgetbookCodeBlock(
        title: 'VCheckboxGroup horizontal',
        code: '''VCheckboxGroup<String>(
  options: [
    VCheckboxItem(value: 'dark', label: Text('Dark')),
    VCheckboxItem(value: 'compact', label: Text('Compact')),
    VCheckboxItem(value: 'animations', label: Text('Animations')),
  ],
  values: selectedValues,
  onChanged: (v) => setState(() => selectedValues = v),
  orientation: Axis.horizontal,
)''',
        preview: _CheckboxGroupDemo(orientation: Axis.horizontal),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _PreferencesFormDemo extends StatefulWidget {
  const _PreferencesFormDemo();

  @override
  State<_PreferencesFormDemo> createState() => _PreferencesFormDemoState();
}

class _PreferencesFormDemoState extends State<_PreferencesFormDemo> {
  bool _email = true;
  bool _sms = false;
  bool _push = true;

  @override
  Widget build(BuildContext context) => VForm(
    children: [
      VCheckbox(
        value: _email,
        onChanged: (v) => setState(() => _email = v ?? false),
        label: const Text('Email notifications'),
      ),
      VCheckbox(
        value: _sms,
        onChanged: (v) => setState(() => _sms = v ?? false),
        label: const Text('SMS notifications'),
      ),
      VCheckbox(
        value: _push,
        onChanged: (v) => setState(() => _push = v ?? false),
        label: const Text('Push notifications'),
      ),
      VButton(onPressed: () {}, child: const Text('Save Preferences')),
    ],
  );
}

class _InteractiveCheckbox extends StatefulWidget {
  const _InteractiveCheckbox({required this.label, this.size = VWidgetSize.md});

  final String label;
  final VWidgetSize size;

  @override
  State<_InteractiveCheckbox> createState() => _InteractiveCheckboxState();
}

class _InteractiveCheckboxState extends State<_InteractiveCheckbox> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) => VCheckbox(
    value: _checked,
    onChanged: (value) => setState(() => _checked = value ?? false),
    label: Text(widget.label),
    size: widget.size,
  );
}

class _CheckboxGroupDemo extends StatefulWidget {
  const _CheckboxGroupDemo({this.orientation = Axis.vertical});

  final Axis orientation;

  @override
  State<_CheckboxGroupDemo> createState() => _CheckboxGroupDemoState();
}

class _CheckboxGroupDemoState extends State<_CheckboxGroupDemo> {
  List<String> _selected = ['email'];

  @override
  Widget build(BuildContext context) => VCheckboxGroup<String>(
    options: const [
      VCheckboxItem(value: 'email', label: Text('Email')),
      VCheckboxItem(value: 'sms', label: Text('SMS')),
      VCheckboxItem(value: 'push', label: Text('Push Notification')),
    ],
    values: _selected,
    onChanged: (v) => setState(() => _selected = v),
    orientation: widget.orientation,
  );
}

class _CheckboxGroupWithDisabledDemo extends StatefulWidget {
  const _CheckboxGroupWithDisabledDemo();

  @override
  State<_CheckboxGroupWithDisabledDemo> createState() =>
      _CheckboxGroupWithDisabledDemoState();
}

class _CheckboxGroupWithDisabledDemoState
    extends State<_CheckboxGroupWithDisabledDemo> {
  List<String> _selected = ['standard'];

  @override
  Widget build(BuildContext context) => VCheckboxGroup<String>(
    options: const [
      VCheckboxItem(value: 'standard', label: Text('Standard')),
      VCheckboxItem(value: 'express', label: Text('Express')),
      VCheckboxItem(
        value: 'overnight',
        label: Text('Overnight'),
        enabled: false,
      ),
    ],
    values: _selected,
    onChanged: (v) => setState(() => _selected = v),
  );
}
