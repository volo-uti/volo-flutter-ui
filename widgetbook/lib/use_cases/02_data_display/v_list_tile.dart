import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vListTileComponent() => WidgetbookComponent(
  name: 'VListTile',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _listTilePlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _ListTileShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _ListTileSample(),
    ),
  ],
);

Widget _listTilePlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_ListTileVariant>(
    label: 'variant',
    options: _ListTileVariant.values,
    initialOption: _ListTileVariant.normal,
    labelBuilder: (v) => v.name,
  );
  final title = k.string(label: 'title', initialValue: 'List Item');
  final subtitle = k.string(label: 'subtitle', initialValue: 'Description');
  final leading = k.boolean(label: 'leading', initialValue: true);
  final trailing = k.boolean(label: 'trailing');
  final selected = k.boolean(label: 'selected');
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final tappable = k.boolean(label: 'onTap', initialValue: true);
  final longPressable = k.boolean(label: 'onLongPress');

  final titleWidget = Text(title);
  final subtitleWidget = subtitle.isEmpty ? null : Text(subtitle);
  final leadingWidget = leading ? const VAvatar.text('KM') : null;
  final trailingWidget = trailing
      ? const Icon(IconData(0xe5cc, fontFamily: 'MaterialIcons'))
      : null;
  final onTap = tappable ? () {} : null;
  final onLongPress = longPressable ? () {} : null;

  return WidgetbookPlayground(
    child: SizedBox(
      width: 420,
      child: switch (variant) {
        _ListTileVariant.normal => VListTile(
          title: titleWidget,
          subtitle: subtitleWidget,
          leading: leadingWidget,
          trailing: trailingWidget,
          selected: selected,
          enabled: enabled,
          onTap: onTap,
          onLongPress: onLongPress,
        ),
        _ListTileVariant.dense => VListTile.dense(
          title: titleWidget,
          subtitle: subtitleWidget,
          leading: leadingWidget,
          trailing: trailingWidget,
          selected: selected,
          enabled: enabled,
          onTap: onTap,
          onLongPress: onLongPress,
        ),
        _ListTileVariant.threeLine => VListTile.threeLine(
          title: titleWidget,
          subtitle: subtitleWidget,
          leading: leadingWidget,
          trailing: trailingWidget,
          selected: selected,
          enabled: enabled,
          onTap: onTap,
          onLongPress: onLongPress,
        ),
      },
    ),
  );
}

enum _ListTileVariant { normal, dense, threeLine }

// =============================================================================
// Showcase
// =============================================================================

class _ListTileShowcase extends StatelessWidget {
  const _ListTileShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VListTile',
    description:
        'A list item component with title, subtitle, and optional leading/trailing content.',
    children: [
      WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: const ['VListTile()'],
            children: [
              VListTile(
                leading: const VAvatar.text('KM'),
                title: const Text('Default'),
                subtitle: const Text('Standard list tile'),
                onTap: () {},
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'dense',
            labels: const ['dense: true'],
            children: [
              VListTile.dense(
                leading: const Icon(
                  IconData(0xe156, fontFamily: 'MaterialIcons'),
                ),
                title: const Text('Dense'),
                subtitle: const Text('Compact version'),
                onTap: () {},
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'threeLine',
            labels: const ['isThreeLine: true'],
            children: [
              VListTile.threeLine(
                leading: const VAvatar.text('JD'),
                title: const Text('Three Line'),
                subtitle: const Text(
                  'This is a longer description that can span multiple lines for detailed information.',
                ),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Leading & Trailing',
        children: [
          WidgetbookSubsection(
            title: 'with leading icon',
            labels: const ['leading: Icon(...)'],
            children: [
              VListTile(
                leading: const Icon(
                  IconData(0xe156, fontFamily: 'MaterialIcons'),
                ),
                title: const Text('With Icon'),
                subtitle: const Text('Leading icon variant'),
                onTap: () {},
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'with leading avatar',
            labels: const ['leading: VAvatar(...)'],
            children: [
              VListTile(
                leading: const VAvatar.text('AB'),
                title: const Text('With Avatar'),
                subtitle: const Text('Leading avatar variant'),
                onTap: () {},
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'with trailing badge',
            labels: const ['trailing: VBadge(...)'],
            children: [
              VListTile(
                title: const Text('Notifications'),
                subtitle: const Text('Check your updates'),
                trailing: const VBadge.primary(label: Text('3')),
                onTap: () {},
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'with leading and trailing',
            labels: const ['leading', 'trailing'],
            children: [
              VListTile(
                leading: const VAvatar.text('KM'),
                title: const Text('Full Layout'),
                subtitle: const Text('Leading + trailing combination'),
                trailing: const Icon(
                  IconData(0xe5cc, fontFamily: 'MaterialIcons'),
                ),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'selected',
            labels: ['selected: true'],
            children: [
              VListTile(
                leading: Icon(IconData(0xe156, fontFamily: 'MaterialIcons')),
                title: Text('Selected Item'),
                selected: true,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: ['enabled: false'],
            children: [
              VListTile(
                leading: Icon(IconData(0xe156, fontFamily: 'MaterialIcons')),
                title: Text('Disabled Item'),
                enabled: false,
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
              'Display items in a vertical list such as settings, contacts, menus, or navigation.',
            ),
            _guidelineRow(
              theme,
              'When not to use',
              'For tabular data with multiple columns. Use VTable instead.',
            ),
            _guidelineRow(
              theme,
              'Leading/Trailing',
              'Use leading for icons/avatars and trailing for actions, badges, or navigation chevrons.',
            ),
            _guidelineRow(
              theme,
              'Tap Area',
              'The entire tile is tappable for better usability',
            ),
            _guidelineRow(
              theme,
              'Dense',
              'Use for compact lists where space is limited',
            ),
            _guidelineRow(
              theme,
              'Three Line',
              'Enable threeLine for items with longer descriptions',
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

class _ListTileSample extends StatelessWidget {
  const _ListTileSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VListTile Samples',
    description: 'Copy-ready code examples.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic Usage',
        code: '''VListTile(
  title: Text('Title'),
  subtitle: Text('Subtitle'),
  onTap: () {},
)''',
        preview: VListTile(
          title: const Text('Title'),
          subtitle: const Text('Subtitle'),
          onTap: () {},
        ),
      ),
      WidgetbookCodeBlock(
        title: 'With Leading',
        code: '''VListTile(
  leading: VAvatar.text('KM'),
  title: Text('John Doe'),
  subtitle: Text('john@example.com'),
  onTap: () {},
)''',
        preview: VListTile(
          leading: const VAvatar.text('KM'),
          title: const Text('John Doe'),
          subtitle: const Text('john@example.com'),
          onTap: () {},
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Dense Version',
        code: '''VListTile.dense(
  leading: Icon(Icons.inbox),
  title: Text('Compact Item'),
  onTap: () {},
)''',
        preview: VListTile.dense(
          leading: const Icon(IconData(0xe156, fontFamily: 'MaterialIcons')),
          title: const Text('Compact Item'),
          onTap: () {},
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Three Line',
        code: '''VListTile.threeLine(
  leading: VAvatar.text('JD'),
  title: Text('Long Content'),
  subtitle: Text('This is a longer description...'),
  onTap: () {},
)''',
        preview: VListTile.threeLine(
          leading: const VAvatar.text('JD'),
          title: const Text('Long Content'),
          subtitle: const Text(
            'This is a longer description that spans multiple lines.',
          ),
          onTap: () {},
        ),
      ),
      WidgetbookCodeBlock(
        title: 'With Trailing',
        code: '''VListTile(
  leading: VAvatar.text('AB'),
  title: Text('With Trailing'),
  trailing: VBadge.primary(label: Text('New')),
  onTap: () {},
)''',
        preview: VListTile(
          leading: const VAvatar.text('AB'),
          title: const Text('With Trailing'),
          trailing: const VBadge.primary(label: Text('New')),
          onTap: () {},
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Settings list',
        code: '''Column(
  children: [
    VListTile(
      leading: Icon(Icons.person),
      title: Text('Account'),
      subtitle: Text('Privacy, security, language'),
      trailing: Icon(Icons.chevron_right),
      onTap: () {},
    ),
    VDivider(indent: 56),
    VListTile(
      leading: Icon(Icons.notifications),
      title: Text('Notifications'),
      subtitle: Text('Message, group, call tones'),
      trailing: Icon(Icons.chevron_right),
      onTap: () {},
    ),
    VDivider(indent: 56),
    VListTile(
      leading: Icon(Icons.help),
      title: Text('Help'),
      subtitle: Text('FAQ, contact us, privacy policy'),
      trailing: Icon(Icons.chevron_right),
      onTap: () {},
    ),
  ],
)''',
        preview: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VListTile(
              leading: const Icon(
                IconData(0xe7fd, fontFamily: 'MaterialIcons'),
              ),
              title: const Text('Account'),
              subtitle: const Text('Privacy, security, language'),
              trailing: const Icon(
                IconData(0xe5cc, fontFamily: 'MaterialIcons'),
              ),
              onTap: () {},
            ),
            const VDivider(indent: 56),
            VListTile(
              leading: const Icon(
                IconData(0xe7f4, fontFamily: 'MaterialIcons'),
              ),
              title: const Text('Notifications'),
              subtitle: const Text('Message, group, call tones'),
              trailing: const Icon(
                IconData(0xe5cc, fontFamily: 'MaterialIcons'),
              ),
              onTap: () {},
            ),
            const VDivider(indent: 56),
            VListTile(
              leading: const Icon(
                IconData(0xe887, fontFamily: 'MaterialIcons'),
              ),
              title: const Text('Help'),
              subtitle: const Text('FAQ, contact us, privacy policy'),
              trailing: const Icon(
                IconData(0xe5cc, fontFamily: 'MaterialIcons'),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Selectable list',
        code: '''VListTile(
  leading: VAvatar.text('JD', size: VAvatarSize.sm),
  title: Text('John Doe'),
  subtitle: Text('john@example.com'),
  selected: true,
  onTap: () {},
)''',
        preview: VListTile(
          leading: const VAvatar.text('JD', size: VAvatarSize.sm),
          title: const Text('John Doe'),
          subtitle: const Text('john@example.com'),
          selected: true,
          onTap: () {},
        ),
      ),
    ],
  );
}
