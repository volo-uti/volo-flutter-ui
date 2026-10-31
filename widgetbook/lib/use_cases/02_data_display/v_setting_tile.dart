import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vSettingTileComponent() => WidgetbookComponent(
  name: 'VSettingTile',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _settingTilePlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _SettingTileShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _SettingTileSample(),
    ),
  ],
);

Widget _settingTilePlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_SettingVariant>(
    label: 'variant',
    options: _SettingVariant.values,
    initialOption: _SettingVariant.navigation,
    labelBuilder: (v) => v.name,
  );
  final title = k.string(label: 'title', initialValue: 'Language');
  final subtitle = k.string(label: 'subtitle');
  final value = k.string(label: 'value (navigation)', initialValue: 'English');
  final checked = k.boolean(label: 'checked (switchTile, checkbox)');
  final leading = k.boolean(label: 'leading', initialValue: true);
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final actionable = k.boolean(label: 'onTap / onChanged', initialValue: true);

  final titleWidget = Text(title);
  final subtitleWidget = subtitle.isEmpty ? null : Text(subtitle);
  final leadingWidget = leading
      ? const Icon(IconData(0xe894, fontFamily: 'MaterialIcons'))
      : null;
  final onTap = actionable ? () {} : null;
  final onChanged = actionable ? (_) {} : null;

  return WidgetbookPlayground(
    child: SizedBox(
      width: 420,
      child: switch (variant) {
        _SettingVariant.simple => VSettingTile.simple(
          title: titleWidget,
          subtitle: subtitleWidget,
          leading: leadingWidget,
          enabled: enabled,
          onTap: onTap,
        ),
        _SettingVariant.navigation => VSettingTile.navigation(
          title: titleWidget,
          subtitle: subtitleWidget,
          leading: leadingWidget,
          value: value.isEmpty ? null : value,
          enabled: enabled,
          onTap: onTap,
        ),
        _SettingVariant.switchTile => VSettingTile.switchTile(
          title: titleWidget,
          subtitle: subtitleWidget,
          leading: leadingWidget,
          value: checked,
          enabled: enabled,
          onChanged: onChanged,
        ),
        _SettingVariant.checkbox => VSettingTile.checkbox(
          title: titleWidget,
          subtitle: subtitleWidget,
          leading: leadingWidget,
          value: checked,
          enabled: enabled,
          onChanged: onChanged,
        ),
      },
    ),
  );
}

enum _SettingVariant { simple, navigation, switchTile, checkbox }

// =============================================================================
// Showcase
// =============================================================================

class _SettingTileShowcase extends StatelessWidget {
  const _SettingTileShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VSettingTile',
    description:
        'A settings list item with title, subtitle, and interactive control.',
    children: [
      WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'simple',
            labels: const ['VSettingTile.simple()'],
            children: [
              VSettingTile.simple(
                leading: const Icon(
                  IconData(0xe7fd, fontFamily: 'MaterialIcons'),
                ),
                title: const Text('Simple'),
                subtitle: const Text('Basic setting tile'),
                onTap: () {},
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'navigation',
            labels: const ['VSettingTile.navigation()'],
            children: [
              VSettingTile.navigation(
                leading: const Icon(
                  IconData(0xe894, fontFamily: 'MaterialIcons'),
                ),
                title: const Text('Navigation'),
                value: 'English',
                onTap: () {},
              ),
            ],
          ),
          const WidgetbookSubsection(
            title: 'switch',
            labels: ['VSettingTile.switchTile()'],
            children: [_SwitchSettingTileDemo()],
          ),
          const WidgetbookSubsection(
            title: 'checkbox',
            labels: ['VSettingTile.checkbox()'],
            children: [_CheckboxSettingTileDemo()],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'With Content',
        children: [
          WidgetbookSubsection(
            title: 'leading icon',
            labels: const ['leading: Icon(...)'],
            children: [
              VSettingTile.simple(
                leading: const Icon(
                  IconData(0xe7fd, fontFamily: 'MaterialIcons'),
                ),
                title: const Text('Profile'),
                subtitle: const Text('Edit name, photo, and more'),
                onTap: () {},
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'subtitle',
            labels: const ['subtitle: String'],
            children: [
              VSettingTile.navigation(
                leading: const Icon(
                  IconData(0xe8b8, fontFamily: 'MaterialIcons'),
                ),
                title: const Text('Notifications'),
                value: 'On',
                onTap: () {},
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
              'Settings pages, preference panels, or configuration lists with interactive controls.',
            ),
            _guidelineRow(
              theme,
              'When not to use',
              'For informational lists without interactive controls. Use VListTile instead.',
            ),
            _guidelineRow(
              theme,
              'Variant',
              'Use toggle for on/off settings, navigation for drill-down pages.',
            ),
            _guidelineRow(
              theme,
              'Consistency',
              'Maintain consistent styling across all settings items',
            ),
            _guidelineRow(
              theme,
              'Simple',
              'Use for display-only settings without interactive controls',
            ),
            _guidelineRow(
              theme,
              'Checkbox',
              'Use when the setting has a binary yes/no value requiring form save',
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

class _SettingTileSample extends StatelessWidget {
  const _SettingTileSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VSettingTile Samples',
    description: 'Copy-ready code examples.',
    children: [
      WidgetbookCodeBlock(
        title: 'Simple',
        code: '''VSettingTile.simple(
  leading: Icon(Icons.person),
  title: Text('Profile'),
  subtitle: Text('Edit name, photo, and more'),
  onTap: () {},
)''',
        preview: VSettingTile.simple(
          leading: const Icon(IconData(0xe7fd, fontFamily: 'MaterialIcons')),
          title: const Text('Profile'),
          subtitle: const Text('Edit name, photo, and more'),
          onTap: () {},
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Navigation',
        code: '''VSettingTile.navigation(
  leading: Icon(Icons.language),
  title: Text('Language'),
  value: 'English',
  onTap: () {},
)''',
        preview: VSettingTile.navigation(
          leading: const Icon(IconData(0xe894, fontFamily: 'MaterialIcons')),
          title: const Text('Language'),
          value: 'English',
          onTap: () {},
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Switch',
        code: '''VSettingTile.switchTile(
  leading: Icon(Icons.dark_mode),
  title: Text('Dark Mode'),
  subtitle: Text('Use the dark theme'),
  value: isDark,
  onChanged: (value) => ...,
)''',
        preview: _SwitchSettingTileDemo(),
      ),
      const WidgetbookCodeBlock(
        title: 'Checkbox',
        code: '''VSettingTile.checkbox(
  leading: Icon(Icons.notifications),
  title: Text('Marketing Consent'),
  subtitle: Text('Receive promotions and event information'),
  value: isChecked,
  onChanged: (value) => ...,
)''',
        preview: _CheckboxSettingTileDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Account settings page',
        code: '''Column(
  children: [
    VSettingTile.navigation(
      leading: Icon(Icons.person),
      title: Text('Profile'),
      subtitle: Text('Name, photo, bio'),
      value: 'John Doe',
      onTap: () {},
    ),
    VSettingTile.navigation(
      leading: Icon(Icons.language),
      title: Text('Language'),
      value: 'English',
      onTap: () {},
    ),
    VSettingTile.navigation(
      leading: Icon(Icons.color_lens),
      title: Text('Theme'),
      value: 'System',
      onTap: () {},
    ),
    VSettingTile.simple(
      leading: Icon(Icons.logout),
      title: Text('Sign Out'),
      onTap: () {},
    ),
  ],
)''',
        preview: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VSettingTile.navigation(
              leading: const Icon(
                IconData(0xe7fd, fontFamily: 'MaterialIcons'),
              ),
              title: const Text('Profile'),
              subtitle: const Text('Name, photo, bio'),
              value: 'John Doe',
              onTap: () {},
            ),
            VSettingTile.navigation(
              leading: const Icon(
                IconData(0xe894, fontFamily: 'MaterialIcons'),
              ),
              title: const Text('Language'),
              value: 'English',
              onTap: () {},
            ),
            VSettingTile.navigation(
              leading: const Icon(
                IconData(0xe40a, fontFamily: 'MaterialIcons'),
              ),
              title: const Text('Theme'),
              value: 'System',
              onTap: () {},
            ),
            VSettingTile.simple(
              leading: const Icon(
                IconData(0xe9ba, fontFamily: 'MaterialIcons'),
              ),
              title: const Text('Sign Out'),
              onTap: () {},
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'With value',
        code: '''VSettingTile.navigation(
  leading: Icon(Icons.update),
  title: Text('App Update'),
  subtitle: Text('A new version is available'),
  value: 'New',
  onTap: () {},
)''',
        preview: VSettingTile.navigation(
          leading: const Icon(IconData(0xe923, fontFamily: 'MaterialIcons')),
          title: const Text('App Update'),
          subtitle: const Text('A new version is available'),
          value: 'New',
          onTap: () {},
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Grouped settings',
        code: '''Column(
  children: [
    VSettingTile.switch(
      leading: Icon(Icons.dark_mode),
      title: Text('Dark mode'),
      value: isDark,
      onChanged: (v) => ...,
    ),
    VSettingTile.navigation(
      leading: Icon(Icons.language),
      title: Text('Language'),
      value: Text('English'),
      onTap: () {},
    ),
  ],
)''',
        preview: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VSettingTile.navigation(
              leading: const Icon(
                IconData(0xe3ab, fontFamily: 'MaterialIcons'),
              ),
              title: const Text('Dark mode'),
              value: 'Off',
              onTap: () {},
            ),
            VSettingTile.navigation(
              leading: const Icon(
                IconData(0xe894, fontFamily: 'MaterialIcons'),
              ),
              title: const Text('Language'),
              value: 'English',
              onTap: () {},
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

class _SwitchSettingTileDemo extends StatefulWidget {
  const _SwitchSettingTileDemo();

  @override
  State<_SwitchSettingTileDemo> createState() => _SwitchSettingTileDemoState();
}

class _SwitchSettingTileDemoState extends State<_SwitchSettingTileDemo> {
  bool _value = true;

  @override
  Widget build(BuildContext context) => VSettingTile.switchTile(
    leading: const Icon(IconData(0xe3a9, fontFamily: 'MaterialIcons')),
    title: const Text('Dark Mode'),
    subtitle: const Text('Use the dark theme'),
    value: _value,
    onChanged: (value) => setState(() => _value = value),
  );
}

class _CheckboxSettingTileDemo extends StatefulWidget {
  const _CheckboxSettingTileDemo();

  @override
  State<_CheckboxSettingTileDemo> createState() =>
      _CheckboxSettingTileDemoState();
}

class _CheckboxSettingTileDemoState extends State<_CheckboxSettingTileDemo> {
  bool _value = false;

  @override
  Widget build(BuildContext context) => VSettingTile.checkbox(
    leading: const Icon(IconData(0xe7f4, fontFamily: 'MaterialIcons')),
    title: const Text('Marketing Consent'),
    subtitle: const Text('Receive promotions and event information'),
    value: _value,
    onChanged: (value) => setState(() => _value = value),
  );
}
