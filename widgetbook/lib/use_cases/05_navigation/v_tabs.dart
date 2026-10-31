import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _TabsVariant { standard, pills, underline }

Widget _tabsPlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_TabsVariant>(
    label: 'variant',
    options: _TabsVariant.values,
    labelBuilder: (v) => v.name,
  );
  final orientation = k.object.dropdown<Axis>(
    label: 'orientation',
    options: Axis.values,
    labelBuilder: (v) => v.name,
  );
  final isScrollable = k.boolean(label: 'isScrollable');
  final lastEnabled = k.boolean(label: 'tab 3 enabled', initialValue: true);

  var changes = 0;
  int? selected;
  return StatefulBuilder(
    builder: (context, setState) {
      void onChanged(int index) => setState(() {
        changes++;
        selected = index;
      });
      final tabs = [
        const VTab(label: Text('Account'), content: Text('Account settings')),
        const VTab(label: Text('Password'), content: Text('Password settings')),
        VTab(
          label: const Text('Settings'),
          content: const Text('General settings'),
          enabled: lastEnabled,
        ),
      ];
      return WidgetbookPlayground(
        info: ['onChanged: $changes', 'selected: ${selected ?? 0}'],
        child: SizedBox(
          width: 480,
          height: 200,
          child: switch (variant) {
            _TabsVariant.standard => VTabs(
              tabs: tabs,
              orientation: orientation,
              isScrollable: isScrollable,
              onChanged: onChanged,
            ),
            _TabsVariant.pills => VTabs.pills(
              tabs: tabs,
              orientation: orientation,
              isScrollable: isScrollable,
              onChanged: onChanged,
            ),
            _TabsVariant.underline => VTabs.underline(
              tabs: tabs,
              orientation: orientation,
              isScrollable: isScrollable,
              onChanged: onChanged,
            ),
          },
        ),
      );
    },
  );
}

WidgetbookComponent vTabsComponent() => WidgetbookComponent(
  name: 'VTabs',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _tabsPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _TabsShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _TabsSample(),
    ),
  ],
);

// =============================================================================
// Showcase
// =============================================================================

class _TabsShowcase extends StatelessWidget {
  const _TabsShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VTabs',
    description:
        'Tab navigation compound component for switching between content panels.',
    children: [
      const WidgetbookSection(
        title: 'Orientation',
        children: [
          WidgetbookSubsection(
            title: 'horizontal',
            labels: ['orientation="horizontal"'],
            children: [
              SizedBox(
                height: 150,
                child: VTabs(
                  tabs: [
                    VTab(
                      label: Text('Account'),
                      content: Center(child: Text('Account settings content.')),
                    ),
                    VTab(
                      label: Text('Password'),
                      content: Center(child: Text('Password change content.')),
                    ),
                    VTab(
                      label: Text('Settings'),
                      content: Center(child: Text('General settings content.')),
                    ),
                  ],
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'vertical',
            labels: ['orientation="vertical"'],
            children: [
              SizedBox(
                height: 150,
                child: VTabs(
                  orientation: Axis.vertical,
                  tabs: [
                    VTab(
                      label: Text('Account'),
                      content: Center(child: Text('Account settings content.')),
                    ),
                    VTab(
                      label: Text('Password'),
                      content: Center(child: Text('Password change content.')),
                    ),
                    VTab(
                      label: Text('Settings'),
                      content: Center(child: Text('General settings content.')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      const WidgetbookSection(
        title: 'Disabled Tab',
        children: [
          WidgetbookSubsection(
            title: 'disabled tab',
            labels: ['VTab(enabled: false)'],
            children: [
              SizedBox(
                height: 150,
                child: VTabs(
                  tabs: [
                    VTab(
                      label: Text('Active'),
                      content: Center(child: Text('Active tab content.')),
                    ),
                    VTab(
                      label: Text('Normal'),
                      content: Center(child: Text('Normal tab content.')),
                    ),
                    VTab(
                      label: Text('Disabled'),
                      content: Center(child: Text('Disabled tab content.')),
                      enabled: false,
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
              'Switch between related content panels without page navigation',
            ),
            _guidelineRow(
              theme,
              'Horizontal',
              'Default layout for top-level tab navigation',
            ),
            _guidelineRow(
              theme,
              'Vertical',
              'Use for sidebar-style navigation in settings pages',
            ),
            _guidelineRow(
              theme,
              'Disabled',
              'Disable tabs that are temporarily unavailable',
            ),
            _guidelineRow(
              theme,
              'Accessibility',
              'Supports arrow key navigation between tabs',
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

class _TabsSample extends StatelessWidget {
  const _TabsSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VTabs Samples',
    description: 'Copy-paste code examples for common tab patterns.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic tabs',
        code: '''VTabs(
  tabs: [
    VTab(label: Text('Tab 1'), content: Text('Content 1')),
    VTab(label: Text('Tab 2'), content: Text('Content 2')),
  ],
)''',
        preview: SizedBox(
          height: 120,
          child: VTabs(
            tabs: [
              VTab(
                label: Text('Tab 1'),
                content: Center(child: Text('Content 1')),
              ),
              VTab(
                label: Text('Tab 2'),
                content: Center(child: Text('Content 2')),
              ),
            ],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Vertical tabs',
        code: '''VTabs(
  orientation: Axis.vertical,
  tabs: [
    VTab(label: Text('General'), content: Text('General settings')),
    VTab(label: Text('Security'), content: Text('Security settings')),
    VTab(label: Text('Notifications'), content: Text('Notification settings')),
  ],
)''',
        preview: SizedBox(
          height: 120,
          child: VTabs(
            orientation: Axis.vertical,
            tabs: [
              VTab(
                label: Text('General'),
                content: Center(child: Text('General settings content')),
              ),
              VTab(
                label: Text('Security'),
                content: Center(child: Text('Security settings content')),
              ),
              VTab(
                label: Text('Notifications'),
                content: Center(child: Text('Notification settings content')),
              ),
            ],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Settings page pattern',
        code: '''VTabs(
  tabs: [
    VTab(label: Text('Profile'), content: ProfileSettings()),
    VTab(label: Text('Account'), content: AccountSettings()),
    VTab(label: Text('Notifications'), content: NotificationPrefs()),
  ],
)''',
        preview: SizedBox(
          height: 150,
          child: VTabs(
            tabs: [
              VTab(
                label: Text('Profile'),
                content: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Settings',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4),
                      Text('Manage your name, photo, and personal info.'),
                    ],
                  ),
                ),
              ),
              VTab(
                label: Text('Account'),
                content: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Settings',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4),
                      Text('Manage email, password, and account details.'),
                    ],
                  ),
                ),
              ),
              VTab(
                label: Text('Notifications'),
                content: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notification Settings',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Configure email and push notification preferences.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'With icons',
        code: '''VTabs(
  tabs: [
    VTab(
      label: Text('Home'),
      icon: Icon(Icons.home, size: 16),
      content: Text('Home content'),
    ),
    VTab(
      label: Text('Messages'),
      icon: Icon(Icons.message, size: 16),
      content: Text('Messages content'),
    ),
    VTab(
      label: Text('Settings'),
      icon: Icon(Icons.settings, size: 16),
      content: Text('Settings content'),
    ),
  ],
)''',
        preview: SizedBox(
          height: 120,
          child: VTabs(
            tabs: [
              VTab(
                label: Text('Home'),
                icon: Icon(
                  IconData(0xe88a, fontFamily: 'MaterialIcons'),
                  size: 16,
                ),
                content: Center(child: Text('Home content')),
              ),
              VTab(
                label: Text('Messages'),
                icon: Icon(
                  IconData(0xe0c9, fontFamily: 'MaterialIcons'),
                  size: 16,
                ),
                content: Center(child: Text('Messages content')),
              ),
              VTab(
                label: Text('Settings'),
                icon: Icon(
                  IconData(0xe8b8, fontFamily: 'MaterialIcons'),
                  size: 16,
                ),
                content: Center(child: Text('Settings content')),
              ),
            ],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Scrollable tabs',
        code: '''VTabs(
  isScrollable: true,
  tabs: [
    VTab(label: Text('Overview'), content: Text('...')),
    VTab(label: Text('Analytics'), content: Text('...')),
    VTab(label: Text('Reports'), content: Text('...')),
    VTab(label: Text('Notifications'), content: Text('...')),
    VTab(label: Text('Integrations'), content: Text('...')),
    VTab(label: Text('Advanced'), content: Text('...')),
  ],
)''',
        preview: SizedBox(
          height: 120,
          child: VTabs(
            isScrollable: true,
            tabs: [
              VTab(
                label: Text('Overview'),
                content: Center(child: Text('Overview content')),
              ),
              VTab(
                label: Text('Analytics'),
                content: Center(child: Text('Analytics content')),
              ),
              VTab(
                label: Text('Reports'),
                content: Center(child: Text('Reports content')),
              ),
              VTab(
                label: Text('Notifications'),
                content: Center(child: Text('Notifications content')),
              ),
              VTab(
                label: Text('Integrations'),
                content: Center(child: Text('Integrations content')),
              ),
              VTab(
                label: Text('Advanced'),
                content: Center(child: Text('Advanced content')),
              ),
            ],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Tabs with icons',
        code: '''VTabs(
  tabs: [
    VTab(
      icon: Icon(Icons.info),
      label: Text('Info'),
      content: Text('Information content'),
    ),
    VTab(
      icon: Icon(Icons.settings),
      label: Text('Settings'),
      content: Text('Settings content'),
    ),
    VTab(
      icon: Icon(Icons.history),
      label: Text('History'),
      content: Text('History content'),
    ),
  ],
)''',
        preview: SizedBox(
          height: 120,
          child: VTabs(
            tabs: [
              VTab(
                icon: Icon(IconData(0xe88e, fontFamily: 'MaterialIcons')),
                label: Text('Info'),
                content: Center(child: Text('Information content')),
              ),
              VTab(
                icon: Icon(IconData(0xe8b8, fontFamily: 'MaterialIcons')),
                label: Text('Settings'),
                content: Center(child: Text('Settings content')),
              ),
              VTab(
                icon: Icon(IconData(0xe889, fontFamily: 'MaterialIcons')),
                label: Text('History'),
                content: Center(child: Text('History content')),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
