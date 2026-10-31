import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _DrawerVariant { start, end, persistent }

Widget _drawerPlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_DrawerVariant>(
    label: 'variant',
    options: _DrawerVariant.values,
    labelBuilder: (v) => v.name,
  );
  final width = k.double.slider(
    label: 'width',
    initialValue: 240,
    min: 160,
    max: 320,
  );
  final showHeader = k.boolean(label: 'header', initialValue: true);
  final showFooter = k.boolean(label: 'footer');
  final closable = k.boolean(label: 'onClose');

  var closes = 0;
  return StatefulBuilder(
    builder: (context, setState) {
      final onClose = closable ? () => setState(() => closes++) : null;
      final header = showHeader
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Navigation'),
            )
          : null;
      final footer = showFooter
          ? const Padding(padding: EdgeInsets.all(16), child: Text('v1.0'))
          : null;
      final child = VStack.vertical(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VListTile(title: const Text('Home'), onTap: () {}),
          VListTile(title: const Text('Settings'), onTap: () {}),
        ],
      );
      final drawer = switch (variant) {
        _DrawerVariant.start => VDrawer(
          width: width,
          header: header,
          footer: footer,
          onClose: onClose,
          child: child,
        ),
        _DrawerVariant.end => VDrawer.end(
          width: width,
          header: header,
          footer: footer,
          onClose: onClose,
          child: child,
        ),
        _DrawerVariant.persistent => VDrawer.persistent(
          width: width,
          header: header,
          footer: footer,
          onClose: onClose,
          child: child,
        ),
      };
      return WidgetbookPlayground(
        info: ['onClose (Escape): $closes'],
        child: SizedBox(
          width: 480,
          height: 280,
          child: Align(
            alignment: variant == _DrawerVariant.end
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: drawer,
          ),
        ),
      );
    },
  );
}

WidgetbookComponent vDrawerComponent() => WidgetbookComponent(
  name: 'VDrawer',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _drawerPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _DrawerShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _DrawerSample(),
    ),
  ],
);

// =============================================================================
// Showcase
// =============================================================================

class _DrawerShowcase extends StatelessWidget {
  const _DrawerShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VDrawer',
    description:
        'Slide-in panel from the edge of the screen for secondary content or navigation.',
    children: [
      WidgetbookSection(
        title: 'Side',
        children: [
          WidgetbookSubsection(
            title: 'directional drawers',
            labels: const [
              'side="left"',
              'side="right"',
              'side="top"',
              'side="bottom"',
            ],
            children: [
              SizedBox(
                height: 200,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: VDrawer(
                    width: 180,
                    header: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'side="left"',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    child: VStack.vertical(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        VListTile(
                          title: const Text('Slides in from the left.'),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 200,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: VDrawer.end(
                    width: 180,
                    header: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'side="right"',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Slides in from the right side.'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      WidgetbookSection(
        title: 'Compound Components',
        children: [
          WidgetbookSubsection(
            title: 'full structure',
            labels: const [
              'VDrawerHeader()',
              'VDrawerFooter()',
              'VDrawerClose()',
            ],
            children: [
              SizedBox(
                height: 300,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: VDrawer(
                      width: 220,
                      header: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            VAvatar.text('U'),
                            SizedBox(width: 8),
                            Text(
                              'Drawer Title',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      footer: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text('Footer with actions.'),
                      ),
                      child: VStack.vertical(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          VListTile(
                            title: const Text('Dashboard'),
                            onTap: () {},
                          ),
                          VListTile(
                            title: const Text('Analytics'),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
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
              'Side panels for forms, navigation menus, detail views',
            ),
            _guidelineRow(
              theme,
              'Side',
              'Right for detail panels, left for navigation menus',
            ),
            _guidelineRow(
              theme,
              'Header',
              'Use VDrawerHeader for a clear title in the drawer',
            ),
            _guidelineRow(
              theme,
              'Footer',
              'Use VDrawerFooter for action buttons (save, cancel)',
            ),
            _guidelineRow(
              theme,
              'Accessibility',
              'Focus is trapped inside the drawer when open',
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

class _DrawerSample extends StatelessWidget {
  const _DrawerSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VDrawer Samples',
    description: 'Copy-paste code examples for common drawer patterns.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic drawer',
        code: '''VDrawer(
  header: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Title'),
  ),
  child: Column(
    children: [
      VListTile(title: Text('Home'), onTap: () {}),
      VListTile(title: Text('Settings'), onTap: () {}),
    ],
  ),
)''',
        preview: SizedBox(
          height: 180,
          child: VDrawer(
            width: 200,
            header: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Title',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            child: VStack.vertical(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VListTile(title: const Text('Home'), onTap: () {}),
                VListTile(title: const Text('Settings'), onTap: () {}),
              ],
            ),
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Left navigation drawer',
        code: '''VDrawer(
  header: Text('Navigation'),
  child: Column(
    children: [
      VListTile(title: Text('Dashboard')),
      VListTile(title: Text('Projects')),
      VListTile(title: Text('Settings')),
    ],
  ),
)''',
        preview: SizedBox(
          height: 200,
          child: VDrawer(
            width: 200,
            header: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Navigation',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            child: VStack.vertical(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VListTile(title: const Text('Dashboard'), onTap: () {}),
                VListTile(title: const Text('Projects'), onTap: () {}),
                VListTile(title: const Text('Team'), onTap: () {}),
                VListTile(title: const Text('Settings'), onTap: () {}),
              ],
            ),
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Form drawer',
        code: '''VDrawer.end(
  header: Text('Edit Profile'),
  child: Column(
    children: [
      VTextField(name: 'name', label: 'Name'),
      VTextField(name: 'email', label: 'Email'),
    ],
  ),
  footer: Row(
    children: [
      VButton.outlined(child: Text('Cancel')),
      VButton(child: Text('Save')),
    ],
  ),
)''',
        preview: SizedBox(
          height: 200,
          child: Align(
            alignment: Alignment.centerRight,
            child: VDrawer.end(
              width: 220,
              header: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              footer: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    VButton.outlined(
                      onPressed: () {},
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    VButton(onPressed: () {}, child: const Text('Save')),
                  ],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: User'),
                    SizedBox(height: 8),
                    Text('Email: user@example.com'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Mobile sidebar',
        code: '''VScaffold(
  drawer: VDrawer(
    width: 280,
    header: Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          VAvatar.text('A'),
          SizedBox(width: 12),
          Text('My App'),
        ],
      ),
    ),
    child: Column(
      children: [
        VListTile(title: Text('Home'), onTap: () {}),
        VListTile(title: Text('Explore'), onTap: () {}),
        VListTile(title: Text('Notifications'), onTap: () {}),
        VListTile(title: Text('Settings'), onTap: () {}),
      ],
    ),
  ),
)''',
        preview: SizedBox(
          height: 250,
          child: VDrawer(
            width: 220,
            header: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  VAvatar.text('A'),
                  SizedBox(width: 12),
                  Text('My App', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            child: VStack.vertical(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VListTile(title: const Text('Home'), onTap: () {}),
                VListTile(title: const Text('Explore'), onTap: () {}),
                VListTile(title: const Text('Notifications'), onTap: () {}),
                VListTile(title: const Text('Settings'), onTap: () {}),
              ],
            ),
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Filter drawer',
        code: '''VDrawer.end(
  width: 260,
  header: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Filters'),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.all(16),
        child: Text('Category'),
      ),
      VListTile(title: Text('Electronics'), onTap: () {}),
      VListTile(title: Text('Clothing'), onTap: () {}),
      VListTile(title: Text('Books'), onTap: () {}),
    ],
  ),
  footer: Padding(
    padding: EdgeInsets.all(16),
    child: VButton(child: Text('Apply Filters')),
  ),
)''',
        preview: SizedBox(
          height: 250,
          child: Align(
            alignment: Alignment.centerRight,
            child: VDrawer.end(
              width: 220,
              header: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Filters',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              footer: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: VButton(
                    onPressed: () {},
                    child: const Text('Apply Filters'),
                  ),
                ),
              ),
              child: VStack.vertical(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VListTile(title: const Text('Electronics'), onTap: () {}),
                  VListTile(title: const Text('Clothing'), onTap: () {}),
                  VListTile(title: const Text('Books'), onTap: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Navigation drawer',
        code: '''VDrawer(
  width: 260,
  header: Padding(
    padding: EdgeInsets.all(16),
    child: Row(
      children: [
        VAvatar.text('A', size: VAvatarSize.sm),
        SizedBox(width: 12),
        Text('Admin Panel'),
      ],
    ),
  ),
  child: Column(
    children: [
      VListTile(title: Text('Dashboard'), onTap: () {}, selected: true),
      VListTile(title: Text('Users'), onTap: () {}),
      VListTile(title: Text('Reports'), onTap: () {}),
    ],
  ),
)''',
        preview: SizedBox(
          height: 250,
          child: Align(
            alignment: Alignment.centerLeft,
            child: VDrawer(
              width: 220,
              header: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    VAvatar.text('A', size: VAvatarSize.sm),
                    SizedBox(width: 12),
                    Text(
                      'Admin Panel',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              child: VStack.vertical(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VListTile(
                    title: const Text('Dashboard'),
                    onTap: () {},
                    selected: true,
                  ),
                  VListTile(title: const Text('Users'), onTap: () {}),
                  VListTile(title: const Text('Reports'), onTap: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
