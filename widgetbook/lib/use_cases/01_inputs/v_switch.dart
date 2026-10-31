import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vSwitchComponent() => WidgetbookComponent(
  name: 'VSwitch',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _switchPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _SwitchShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _SwitchSample(),
    ),
  ],
);

Widget _switchPlayground(BuildContext context) {
  final k = context.knobs;
  final labeled = k.boolean(label: 'labeled');
  var on = k.boolean(label: 'value');
  final size = k.object.dropdown<VWidgetSize>(
    label: 'size',
    options: VWidgetSize.values,
    initialOption: VWidgetSize.md,
    labelBuilder: (v) => v.name,
  );
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final label = k.string(label: 'label', initialValue: 'Notifications');
  final sublabel = k.string(label: 'sublabel');
  final activeColor = k.colorOrNull(label: 'activeColor');

  return StatefulBuilder(
    builder: (context, setState) {
      final labelWidget = label.isEmpty ? null : Text(label);
      final sublabelWidget = sublabel.isEmpty ? null : Text(sublabel);
      return WidgetbookPlayground(
        info: ['value: $on'],
        child: SizedBox(
          width: 320,
          child: labeled
              ? VSwitch.labeled(
                  value: on,
                  onChanged: (v) => setState(() => on = v),
                  label: labelWidget,
                  sublabel: sublabelWidget,
                  enabled: enabled,
                  size: size,
                  activeColor: activeColor,
                )
              : VSwitch(
                  value: on,
                  onChanged: (v) => setState(() => on = v),
                  label: labelWidget,
                  sublabel: sublabelWidget,
                  enabled: enabled,
                  size: size,
                  activeColor: activeColor,
                ),
        ),
      );
    },
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _SwitchShowcase extends StatelessWidget {
  const _SwitchShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VSwitch',
    description:
        'Toggle switch for instant on/off actions without form submission.',
    children: [
      const WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'sm',
            labels: ['size="sm"'],
            children: [_SwitchSizeDemo(label: 'Small', size: VWidgetSize.sm)],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: ['size="md"'],
            children: [_SwitchSizeDemo(label: 'Medium')],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: ['size="lg"'],
            children: [_SwitchSizeDemo(label: 'Large', size: VWidgetSize.lg)],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'off',
            labels: const ['checked={false}'],
            children: [
              VSwitch(
                value: false,
                onChanged: (_) {},
                label: const Text('Off'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'on',
            labels: const ['defaultChecked'],
            children: [
              VSwitch(value: true, onChanged: (_) {}, label: const Text('On')),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled off',
            labels: const ['disabled'],
            children: [
              VSwitch(
                value: false,
                onChanged: (_) {},
                enabled: false,
                label: const Text('Disabled Off'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled on',
            labels: const ['disabled', 'defaultChecked'],
            children: [
              VSwitch(
                value: true,
                onChanged: (_) {},
                enabled: false,
                label: const Text('Disabled On'),
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
            labels: const ['VSwitch()'],
            children: [VSwitch(value: false, onChanged: (_) {})],
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
              'Settings that take effect immediately: dark mode, notifications, features',
            ),
            _guidelineRow(
              theme,
              'vs Checkbox',
              'Switch for instant effect. Checkbox when changes require form submission',
            ),
            _guidelineRow(
              theme,
              'Label',
              'Always provide a label. Use positive phrasing ("Enable X" not "Disable X")',
            ),
            _guidelineRow(
              theme,
              'Feedback',
              'If the action is async, show loading state or confirmation toast',
            ),
            _guidelineRow(
              theme,
              'Disabled',
              'When the setting is locked by permission or plan. Show explanation',
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

class _SwitchSample extends StatelessWidget {
  const _SwitchSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VSwitch Samples',
    description: 'Copy-paste code examples for common switch patterns.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic toggle',
        code: '''VSwitch(
  value: isEnabled,
  onChanged: (value) => setState(() => isEnabled = value),
  label: Text('Enable notifications'),
)''',
        preview: VSwitch(
          value: false,
          onChanged: (_) {},
          label: const Text('Enable notifications'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Controlled switch',
        code: '''VSwitch(
  value: isDarkMode,
  onChanged: (value) => setState(() => isDarkMode = value),
  label: Text('Dark mode'),
)''',
        preview: VSwitch(
          value: false,
          onChanged: (_) {},
          label: const Text('Dark mode'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Default on',
        code: '''VSwitch(
  value: true,
  onChanged: (value) {},
  label: Text('Auto-save'),
)''',
        preview: VSwitch(
          value: true,
          onChanged: (_) {},
          label: const Text('Auto-save'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Disabled',
        code: '''VSwitch(
  value: false,
  onChanged: (_) {},
  enabled: false,
  label: Text('Premium feature'),
)''',
        preview: VSwitch(
          value: false,
          onChanged: (_) {},
          enabled: false,
          label: const Text('Premium feature'),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Settings Form (VForm)',
        code: '''VForm(
  formKey: formKey,
  children: [
    VSwitch(
      value: darkMode,
      onChanged: (v) => setState(() => darkMode = v),
      label: Text('Dark mode'),
    ),
    VSwitch(
      value: notifications,
      onChanged: (v) => setState(() => notifications = v),
      label: Text('Push notifications'),
    ),
    VSwitch(
      value: autoSave,
      onChanged: (v) => setState(() => autoSave = v),
      label: Text('Auto-save'),
    ),
    VButton(
      onPressed: () {},
      child: Text('Save Settings'),
    ),
  ],
)''',
        preview: _SettingsFormDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Dark mode toggle',
        code: '''VSwitch.labeled(
  value: isDarkMode,
  onChanged: (v) => setState(() => isDarkMode = v),
  label: Text('Dark mode'),
  sublabel: Text('Switch between light and dark theme'),
)''',
        preview: VSwitch.labeled(
          value: false,
          onChanged: (_) {},
          label: const Text('Dark mode'),
          sublabel: const Text('Switch between light and dark theme'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Notification settings',
        code: '''Column(
  children: [
    VSwitch(
      value: emailNotif,
      onChanged: (v) => setState(() => emailNotif = v),
      label: Text('Email notifications'),
    ),
    SizedBox(height: 12),
    VSwitch(
      value: pushNotif,
      onChanged: (v) => setState(() => pushNotif = v),
      label: Text('Push notifications'),
    ),
    SizedBox(height: 12),
    VSwitch(
      value: false,
      onChanged: null,
      label: Text('SMS alerts (coming soon)'),
      enabled: false,
    ),
  ],
)''',
        preview: Column(
          children: [
            VSwitch(
              value: true,
              onChanged: (_) {},
              label: const Text('Email notifications'),
            ),
            const SizedBox(height: 12),
            VSwitch(
              value: false,
              onChanged: (_) {},
              label: const Text('Push notifications'),
            ),
            const SizedBox(height: 12),
            const VSwitch(
              value: false,
              label: Text('SMS alerts (coming soon)'),
              enabled: false,
            ),
          ],
        ),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _SettingsFormDemo extends StatefulWidget {
  const _SettingsFormDemo();

  @override
  State<_SettingsFormDemo> createState() => _SettingsFormDemoState();
}

class _SettingsFormDemoState extends State<_SettingsFormDemo> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _autoSave = true;

  @override
  Widget build(BuildContext context) => VForm(
    children: [
      VSwitch(
        value: _darkMode,
        onChanged: (v) => setState(() => _darkMode = v),
        label: const Text('Dark mode'),
      ),
      VSwitch(
        value: _notifications,
        onChanged: (v) => setState(() => _notifications = v),
        label: const Text('Push notifications'),
      ),
      VSwitch(
        value: _autoSave,
        onChanged: (v) => setState(() => _autoSave = v),
        label: const Text('Auto-save'),
      ),
      VButton(onPressed: () {}, child: const Text('Save Settings')),
    ],
  );
}

class _SwitchDemo extends StatefulWidget {
  const _SwitchDemo();

  @override
  State<_SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<_SwitchDemo> {
  bool _value = false;

  @override
  Widget build(BuildContext context) => VSwitch(
    value: _value,
    onChanged: (value) => setState(() => _value = value),
  );
}

class _SwitchSizeDemo extends StatefulWidget {
  const _SwitchSizeDemo({required this.label, this.size = VWidgetSize.md});

  final String label;
  final VWidgetSize size;

  @override
  State<_SwitchSizeDemo> createState() => _SwitchSizeDemoState();
}

class _SwitchSizeDemoState extends State<_SwitchSizeDemo> {
  bool _value = false;

  @override
  Widget build(BuildContext context) => VSwitch(
    value: _value,
    onChanged: (value) => setState(() => _value = value),
    label: Text(widget.label),
    size: widget.size,
  );
}
