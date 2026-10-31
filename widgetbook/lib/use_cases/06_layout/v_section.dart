import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _SectionKind { section, card, inset }

WidgetbookComponent vSectionComponent() => WidgetbookComponent(
  name: 'VSection',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _sectionPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _SectionShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _SectionSample(),
    ),
  ],
);

Widget _sectionPlayground(BuildContext context) {
  final k = context.knobs;
  final kind = k.object.dropdown<_SectionKind>(
    label: 'variant',
    options: _SectionKind.values,
    initialOption: _SectionKind.card,
    labelBuilder: (v) => v.name,
  );
  final header = k.stringOrNull(label: 'header', initialValue: 'Settings');
  final footer = k.stringOrNull(
    label: 'footer',
    initialValue: 'Changes are saved automatically.',
  );
  final divider = k.boolean(label: 'divider', initialValue: true);
  final backgroundColor = k.colorOrNull(label: 'backgroundColor');
  final radius = k.doubleOrNull.slider(label: 'borderRadius', max: 48);

  const rows = <Widget>[
    VListTile(title: Text('Profile')),
    VListTile(title: Text('Notifications')),
    VListTile(title: Text('Privacy')),
  ];
  final headerWidget = header == null ? null : Text(header);
  final footerWidget = footer == null ? null : Text(footer);
  final borderRadius = radius == null ? null : BorderRadius.circular(radius);

  final section = switch (kind) {
    _SectionKind.section => VSection(
      header: headerWidget,
      footer: footerWidget,
      divider: divider,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      children: rows,
    ),
    _SectionKind.card => VSection.card(
      header: headerWidget,
      footer: footerWidget,
      divider: divider,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      children: rows,
    ),
    _SectionKind.inset => VSection.inset(
      header: headerWidget,
      footer: footerWidget,
      divider: divider,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      children: rows,
    ),
  };

  return WidgetbookPlayground(layout: PlaygroundLayout.stretch, child: section);
}

// =============================================================================
// Showcase
// =============================================================================

class _SectionShowcase extends StatelessWidget {
  const _SectionShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return WidgetbookPageLayout(
      title: 'VSection',
      description:
          'A content section with optional title, description, and collapsible behavior.',
      children: [
        WidgetbookSection(
          title: 'Variants',
          children: [
            WidgetbookSubsection(
              title: 'default',
              labels: const ['VSection()'],
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colors.border),
                  ),
                  child: const VSection(
                    header: Text('Default Section'),
                    children: [
                      Text('A basic transparent background section.'),
                      Text('Only padding is applied.'),
                    ],
                  ),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'card',
              labels: const ['VSection.card()'],
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colors.border),
                  ),
                  child: const VSection.card(
                    header: Text('Card Section'),
                    children: [
                      Text('A section with card background.'),
                      Text('Background color + rounded corners.'),
                    ],
                  ),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'inset',
              labels: const ['VSection.inset()'],
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colors.border),
                  ),
                  child: const VSection.inset(
                    header: Text('Inset Section'),
                    children: [
                      Text('A section with extra internal padding.'),
                      Text('Content indentation effect.'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Header & Footer',
          children: [
            const WidgetbookSubsection(
              title: 'header (Text)',
              labels: ['header: Text("Header")'],
              children: [
                VSection.card(
                  header: Text('Text header'),
                  children: [Text('Header is a plain Text')],
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'header (VSectionHeader)',
              labels: const ['header: VSectionHeader()'],
              children: [
                VSection.card(
                  header: VSectionHeader(
                    title: const Text('VSectionHeader'),
                    subtitle: const Text('Title + Subtitle + Action'),
                    trailing: VButton.text(
                      onPressed: () {},
                      child: const Text('Action'),
                    ),
                  ),
                  children: const [
                    Text('Detailed configuration with VSectionHeader widget'),
                  ],
                ),
              ],
            ),
            const WidgetbookSubsection(
              title: 'footer (Text)',
              labels: ['footer: Text("Footer")'],
              children: [
                VSection.card(
                  header: Text('With Text footer'),
                  footer: Text('Footer is a plain Text'),
                  children: [Text('Content')],
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'footer (VSectionFooter)',
              labels: const ['footer: VSectionFooter()'],
              children: [
                VSection.card(
                  header: const Text('With VSectionFooter'),
                  footer: VSectionFooter(
                    child: Row(
                      children: [
                        Icon(
                          const IconData(0xe88e, fontFamily: 'MaterialIcons'),
                          size: 16,
                          color: theme.colors.mutedForeground,
                        ),
                        const SizedBox(width: 8),
                        const Text('Custom footer widget'),
                      ],
                    ),
                  ),
                  children: const [Text('Content')],
                ),
              ],
            ),
          ],
        ),
        const WidgetbookSection(
          title: 'With Divider',
          children: [
            WidgetbookSubsection(
              title: 'divider: false',
              labels: ['divider: false'],
              children: [
                VSection.card(
                  header: Text('divider: false'),
                  children: [Text('Item 1'), Text('Item 2'), Text('Item 3')],
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'divider: true',
              labels: ['divider: true'],
              children: [
                VSection.card(
                  header: Text('divider: true'),
                  divider: true,
                  children: [Text('Item 1'), Text('Item 2'), Text('Item 3')],
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
              'Use to logically group content (settings screens, form sections, etc.)',
            ),
            _guidelineRow(
              theme,
              'header',
              'Clearly display the section title to help users understand content structure',
            ),
            _guidelineRow(
              theme,
              'footer',
              'Use for additional descriptions or hint text',
            ),
            _guidelineRow(
              theme,
              'divider',
              'Use divider: true when separation between items is needed',
            ),
            _guidelineRow(
              theme,
              'variant',
              'Choose a style that matches the screen design (card, inset)',
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

class _SectionSample extends StatelessWidget {
  const _SectionSample();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return WidgetbookPageLayout(
      title: 'VSection Samples',
      description: 'Copy-ready code examples.',
      children: [
        const WidgetbookCodeBlock(
          title: 'Basic Usage (Text)',
          code: '''VSection(
  header: Text('Announcements'),
  children: [
    Text('Service maintenance notice'),
    Text('New feature introduction'),
  ],
)''',
          preview: VSection(
            header: Text('Announcements'),
            children: [
              Text('Service maintenance notice'),
              Text('New feature introduction'),
            ],
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Layout Container (Single)',
          code: '''VSection.card(
  header: Text('Dashboard'),
  children: [
    MyChartWidget(), // Single content
  ],
)''',
          preview: VSection.card(
            header: const Text('Dashboard'),
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: theme.colors.muted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: Text('Chart/Graph Area')),
              ),
            ],
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Settings Screen (ListTile)',
          code: '''VSection.card(
  header: Text('Account'),
  divider: true,
  children: [
    VSettingTile.navigation(title: Text('Profile'), onTap: () {}),
    VSettingTile.navigation(title: Text('Security'), onTap: () {}),
  ],
)''',
          preview: VSection.card(
            header: const Text('Account'),
            divider: true,
            children: [
              VSettingTile.navigation(
                title: const Text('Profile'),
                onTap: () {},
              ),
              VSettingTile.navigation(
                title: const Text('Security'),
                onTap: () {},
              ),
            ],
          ),
        ),
        const WidgetbookCodeBlock(
          title: 'Form Grouping',
          code: '''VSection.card(
  header: VSectionHeader(
    title: Text('Shipping Info'),
    subtitle: Text('Enter your shipping address'),
  ),
  children: [
    VTextField(label: 'Address'),
    VTextField(label: 'Address Detail'),
  ],
)''',
          preview: VSection.card(
            header: VSectionHeader(
              title: Text('Shipping Info'),
              subtitle: Text('Enter your shipping address'),
            ),
            children: [
              VTextField(
                name: 'address',
                label: 'Address',
                placeholder: 'Enter address',
              ),
              SizedBox(height: 12),
              VTextField(
                name: 'address_detail',
                label: 'Address Detail',
                placeholder: 'Enter address detail',
              ),
            ],
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Content Section (Card List)',
          code: '''VSection(
  header: VSectionHeader(
    title: Text('Recent'),
    trailing: VButton.text(...),
  ),
  children: [
    ListView(
      scrollDirection: Axis.horizontal,
      children: [...cards],
    ),
  ],
)''',
          preview: VSection(
            header: VSectionHeader(
              title: const Text('Recent'),
              trailing: VButton.text(
                onPressed: () {},
                child: const Text('More'),
              ),
            ),
            children: [
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    4,
                    (i) => Container(
                      width: 100,
                      margin: EdgeInsets.only(right: i < 3 ? 12 : 0),
                      decoration: BoxDecoration(
                        color: theme.colors.muted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text('Item ${i + 1}')),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Usage Patterns
        WidgetbookCodeBlock(
          title: 'Settings Pattern (Settings)',
          code: '''VSection.card(
  header: VSectionHeader(
    title: Text('Settings Section'),
    subtitle: Text('Used with ListTile'),
  ),
  divider: true,
  children: [
    VSettingTile.navigation(title: Text('Profile'), onTap: () {}),
    VSettingTile.navigation(title: Text('Notifications'), onTap: () {}),
    VSettingTile.navigation(title: Text('Privacy'), onTap: () {}),
  ],
)''',
          preview: VSection.card(
            header: const VSectionHeader(
              title: Text('Settings Section'),
              subtitle: Text('Used with ListTile'),
            ),
            divider: true,
            children: [
              VSettingTile.navigation(
                title: const Text('Profile'),
                onTap: () {},
              ),
              VSettingTile.navigation(
                title: const Text('Notifications'),
                onTap: () {},
              ),
              VSettingTile.navigation(
                title: const Text('Privacy'),
                onTap: () {},
              ),
            ],
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Content Pattern (Content)',
          code: '''VSection(
  header: VSectionHeader(
    title: Text('Content Section'),
    subtitle: Text('Card/Image grid'),
    trailing: VButton.text(onPressed: () {}, child: Text('More')),
  ),
  children: [
    SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [...cards],
      ),
    ),
  ],
)''',
          preview: VSection(
            header: VSectionHeader(
              title: const Text('Content Section'),
              subtitle: const Text('Card/Image grid'),
              trailing: VButton.text(
                onPressed: () {},
                child: const Text('More'),
              ),
            ),
            children: [
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    5,
                    (i) => Container(
                      width: 120,
                      margin: EdgeInsets.only(right: i < 4 ? 12 : 0),
                      decoration: BoxDecoration(
                        color: theme.colors.muted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text('Card ${i + 1}')),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const WidgetbookCodeBlock(
          title: 'Form Pattern (Form)',
          code: '''VSection.card(
  header: VSectionHeader(
    title: Text('Form Section'),
    subtitle: Text('Group input fields'),
  ),
  children: [
    VTextField(name: 'name', label: 'Name'),
    SizedBox(height: 12),
    VTextField(name: 'email', label: 'Email'),
  ],
)''',
          preview: VSection.card(
            header: VSectionHeader(
              title: Text('Form Section'),
              subtitle: Text('Group input fields'),
            ),
            children: [
              VTextField(
                name: 'name',
                label: 'Name',
                placeholder: 'Enter name',
              ),
              SizedBox(height: 12),
              VTextField(
                name: 'email',
                label: 'Email',
                placeholder: 'Enter email',
              ),
            ],
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Mixed Pattern (Mixed)',
          code: '''VSection(
  header: Text('Mixed Content'),
  footer: Text('Any widget can be used as children.'),
  children: [
    Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(...),
      child: Row(
        children: [
          Icon(Icons.info),
          SizedBox(width: 12),
          Text('VSection is a general-purpose container.'),
        ],
      ),
    ),
  ],
)''',
          preview: VSection(
            header: const Text('Mixed Content'),
            footer: const Text('Any widget can be used as children.'),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      const IconData(0xe88e, fontFamily: 'MaterialIcons'),
                      color: theme.colors.primary,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text('VSection is a general-purpose container.'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Inset with footer',
          code: '''VSection.inset(
  header: VSectionHeader(
    title: Text('Notifications'),
    subtitle: Text('Manage your notification preferences'),
  ),
  footer: Text('Changes are saved automatically.'),
  divider: true,
  children: [
    VSwitch(value: true, label: 'Email', onChanged: (v) {}),
    VSwitch(value: false, label: 'Push', onChanged: (v) {}),
    VSwitch(value: true, label: 'SMS', onChanged: (v) {}),
  ],
)''',
          preview: VSection.inset(
            header: const VSectionHeader(
              title: Text('Notifications'),
              subtitle: Text('Manage your notification preferences'),
            ),
            footer: const Text('Changes are saved automatically.'),
            divider: true,
            children: [
              VSwitch(
                value: true,
                label: const Text('Email'),
                onChanged: (v) {},
              ),
              VSwitch(
                value: false,
                label: const Text('Push'),
                onChanged: (v) {},
              ),
              VSwitch(value: true, label: const Text('SMS'), onChanged: (v) {}),
            ],
          ),
        ),
      ],
    );
  }
}
