import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vMenuComponent() => WidgetbookComponent(
  name: 'VMenu',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _menuPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _MenuShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _MenuSample(),
    ),
  ],
);

Widget _menuPlayground(BuildContext context) {
  final k = context.knobs;
  final position = k.object.dropdown<VMenuPosition>(
    label: 'position',
    options: VMenuPosition.values,
    initialOption: VMenuPosition.bottomStart,
    labelBuilder: (v) => v.name,
  );
  final closeOnSelect = k.boolean(label: 'closeOnSelect', initialValue: true);
  final archiveEnabled = k.boolean(
    label: 'archive.enabled',
    initialValue: true,
  );
  final deleteDestructive = k.boolean(
    label: 'delete.destructive',
    initialValue: true,
  );

  var picked = 'none';

  return StatefulBuilder(
    builder: (context, setState) {
      void pick(String name) => setState(() => picked = name);
      return WidgetbookPlayground(
        info: ['picked: $picked'],
        child: Center(
          child: VMenu(
            position: position,
            closeOnSelect: closeOnSelect,
            trigger: VButton(onPressed: () {}, child: const Text('Open Menu')),
            items: [
              VMenuItem(onTap: () => pick('Edit'), child: const Text('Edit')),
              VMenuItem(
                onTap: () => pick('Duplicate'),
                child: const Text('Duplicate'),
              ),
              const VMenuDivider(),
              VMenuItem(
                enabled: archiveEnabled,
                onTap: () => pick('Archive'),
                child: const Text('Archive'),
              ),
              VMenuItem(
                destructive: deleteDestructive,
                onTap: () => pick('Delete'),
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _MenuShowcase extends StatelessWidget {
  const _MenuShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VMenu',
    description:
        'Dropdown menu with keyboard navigation, grouping, and separators.',
    children: [
      WidgetbookSection(
        title: 'Align',
        children: [
          WidgetbookSubsection(
            title: 'content alignment',
            labels: const ['align="start"', 'align="center"', 'align="end"'],
            children: [
              Center(
                child: VMenu(
                  trigger: VButton.outlined(
                    onPressed: () {},
                    child: const Text('start'),
                  ),
                  items: [
                    VMenuItem(child: const Text('Item 1'), onTap: () {}),
                    VMenuItem(child: const Text('Item 2'), onTap: () {}),
                    VMenuItem(child: const Text('Item 3'), onTap: () {}),
                  ],
                ),
              ),
              Center(
                child: VMenu(
                  trigger: VButton.outlined(
                    onPressed: () {},
                    child: const Text('center'),
                  ),
                  items: [
                    VMenuItem(child: const Text('Item 1'), onTap: () {}),
                    VMenuItem(child: const Text('Item 2'), onTap: () {}),
                    VMenuItem(child: const Text('Item 3'), onTap: () {}),
                  ],
                ),
              ),
              Center(
                child: VMenu(
                  position: VMenuPosition.bottomEnd,
                  trigger: VButton.outlined(
                    onPressed: () {},
                    child: const Text('end'),
                  ),
                  items: [
                    VMenuItem(child: const Text('Item 1'), onTap: () {}),
                    VMenuItem(child: const Text('Item 2'), onTap: () {}),
                    VMenuItem(child: const Text('Item 3'), onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      WidgetbookSection(
        title: 'Menu Items',
        children: [
          WidgetbookSubsection(
            title: 'basic items',
            labels: const ['VMenuItem()'],
            children: [
              Center(
                child: VMenu(
                  trigger: VButton(
                    onPressed: () {},
                    child: const Text('Open Menu'),
                  ),
                  items: [
                    VMenuItem(child: const Text('Edit'), onTap: () {}),
                    VMenuItem(child: const Text('Duplicate'), onTap: () {}),
                    const VMenuDivider(),
                    VMenuItem(child: const Text('Archive'), onTap: () {}),
                    VMenuItem(child: const Text('Delete'), onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled item',
            labels: const ['VMenuItem(enabled: false)'],
            children: [
              Center(
                child: VMenu(
                  trigger: VButton(
                    onPressed: () {},
                    child: const Text('States'),
                  ),
                  items: [
                    VMenuItem(child: const Text('Normal'), onTap: () {}),
                    const VMenuItem(child: Text('Disabled'), enabled: false),
                    const VMenuDivider(),
                    VMenuItem(child: const Text('Another Item'), onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      WidgetbookSection(
        title: 'Groups & Labels',
        children: [
          WidgetbookSubsection(
            title: 'grouped menu',
            labels: const ['VMenuGroup()', 'VMenuLabel()'],
            children: [
              Center(
                child: VMenu(
                  trigger: VButton(
                    onPressed: () {},
                    child: const Text('Grouped Menu'),
                  ),
                  items: [
                    VMenuItem(child: const Text('Profile'), onTap: () {}),
                    VMenuItem(child: const Text('Settings'), onTap: () {}),
                    VMenuItem(child: const Text('Billing'), onTap: () {}),
                    const VMenuDivider(),
                    VMenuItem(child: const Text('Members'), onTap: () {}),
                    VMenuItem(child: const Text('Invite'), onTap: () {}),
                    const VMenuDivider(),
                    VMenuItem(child: const Text('Log Out'), onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      WidgetbookSection(
        title: 'Separator',
        children: [
          WidgetbookSubsection(
            title: 'with separators',
            labels: const ['VMenuSeparator()'],
            children: [
              Center(
                child: VMenu(
                  trigger: VButton(
                    onPressed: () {},
                    child: const Text('With Separator'),
                  ),
                  items: [
                    VMenuItem(child: const Text('New File'), onTap: () {}),
                    VMenuItem(child: const Text('Open File'), onTap: () {}),
                    const VMenuDivider(),
                    VMenuItem(child: const Text('Save'), onTap: () {}),
                    VMenuItem(child: const Text('Save As...'), onTap: () {}),
                    const VMenuDivider(),
                    VMenuItem(child: const Text('Exit'), onTap: () {}),
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
              'Action menus, context menus, dropdown navigation',
            ),
            _guidelineRow(
              theme,
              'Groups',
              'Organize related items with VMenuGroup and VMenuLabel',
            ),
            _guidelineRow(
              theme,
              'Separator',
              'Use VMenuSeparator to divide sections visually',
            ),
            _guidelineRow(
              theme,
              'Disabled',
              'Disable items that are temporarily unavailable',
            ),
            _guidelineRow(
              theme,
              'Accessibility',
              'Full keyboard navigation with arrow keys, Enter, Escape',
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

class _MenuSample extends StatelessWidget {
  const _MenuSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VMenu Samples',
    description: 'Copy-paste code examples for common menu patterns.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic menu',
        code: '''VMenu(
  trigger: VButton(onPressed: () {}, child: Text('Open Menu')),
  items: [
    VMenuItem(child: Text('Edit'), onTap: () {}),
    VMenuItem(child: Text('Delete'), onTap: () {}),
  ],
)''',
        preview: VMenu(
          trigger: VButton(onPressed: () {}, child: const Text('Open Menu')),
          items: [
            VMenuItem(child: const Text('Edit'), onTap: () {}),
            VMenuItem(child: const Text('Delete'), onTap: () {}),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Menu with separators',
        code: '''VMenu(
  trigger: VButton(onPressed: () {}, child: Text('Actions')),
  items: [
    VMenuItem(child: Text('New File'), onTap: () {}),
    VMenuItem(child: Text('Open File'), onTap: () {}),
    VMenuDivider(),
    VMenuItem(child: Text('Save'), onTap: () {}),
    VMenuItem(child: Text('Save As...'), onTap: () {}),
  ],
)''',
        preview: VMenu(
          trigger: VButton(onPressed: () {}, child: const Text('Actions')),
          items: [
            VMenuItem(child: const Text('New File'), onTap: () {}),
            VMenuItem(child: const Text('Open File'), onTap: () {}),
            const VMenuDivider(),
            VMenuItem(child: const Text('Save'), onTap: () {}),
            VMenuItem(child: const Text('Save As...'), onTap: () {}),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Grouped menu',
        code: '''VMenu(
  trigger: VButton(onPressed: () {}, child: Text('Settings')),
  items: [
    VMenuItem(child: Text('Profile'), onTap: () {}),
    VMenuItem(child: Text('Settings'), onTap: () {}),
    VMenuDivider(),
    VMenuItem(child: Text('Members'), onTap: () {}),
    VMenuItem(child: Text('Invite'), onTap: () {}),
    VMenuDivider(),
    VMenuItem(child: Text('Log Out'), onTap: () {}),
  ],
)''',
        preview: VMenu(
          trigger: VButton(onPressed: () {}, child: const Text('Settings')),
          items: [
            VMenuItem(child: const Text('Profile'), onTap: () {}),
            VMenuItem(child: const Text('Settings'), onTap: () {}),
            const VMenuDivider(),
            VMenuItem(child: const Text('Members'), onTap: () {}),
            VMenuItem(child: const Text('Invite'), onTap: () {}),
            const VMenuDivider(),
            VMenuItem(child: const Text('Log Out'), onTap: () {}),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Context menu',
        code: '''VMenu(
  trigger: VButton.outlined(
    onPressed: () {},
    child: Text('Long Press'),
  ),
  items: [
    VMenuItem(child: Text('Copy'), onTap: () {}),
    VMenuItem(child: Text('Paste'), onTap: () {}),
    VMenuItem(child: Text('Cut'), onTap: () {}),
    VMenuDivider(),
    VMenuItem(child: Text('Select All'), onTap: () {}),
  ],
)''',
        preview: VMenu(
          trigger: VButton.outlined(
            onPressed: () {},
            child: const Text('Long Press'),
          ),
          items: [
            VMenuItem(child: const Text('Copy'), onTap: () {}),
            VMenuItem(child: const Text('Paste'), onTap: () {}),
            VMenuItem(child: const Text('Cut'), onTap: () {}),
            const VMenuDivider(),
            VMenuItem(child: const Text('Select All'), onTap: () {}),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'User dropdown',
        code: '''VMenu(
  trigger: VButton.outlined(onPressed: () {}, child: Text('Account')),
  items: [
    VMenuItem(child: Text('My Account'), onTap: () {}),
    VMenuItem(child: Text('Settings'), onTap: () {}),
    VMenuItem(child: Text('Billing'), onTap: () {}),
    VMenuDivider(),
    VMenuItem(child: Text('Sign Out'), onTap: () {}),
  ],
)''',
        preview: VMenu(
          trigger: VButton.outlined(
            onPressed: () {},
            child: const Text('Account'),
          ),
          items: [
            VMenuItem(child: const Text('My Account'), onTap: () {}),
            VMenuItem(child: const Text('Settings'), onTap: () {}),
            VMenuItem(child: const Text('Billing'), onTap: () {}),
            const VMenuDivider(),
            VMenuItem(child: const Text('Sign Out'), onTap: () {}),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Context menu',
        code: '''VMenu(
  trigger: VButton.ghost(onPressed: () {}, child: Icon(Icons.more_horiz)),
  items: [
    VMenuItem(child: Text('Copy'), onTap: () {}),
    VMenuItem(child: Text('Paste'), onTap: () {}),
    VMenuDivider(),
    VMenuItem(child: Text('Delete'), destructive: true, onTap: () {}),
  ],
)''',
        preview: VMenu(
          trigger: VButton.ghost(onPressed: () {}, child: const Text('\u2026')),
          items: [
            VMenuItem(child: const Text('Copy'), onTap: () {}),
            VMenuItem(child: const Text('Paste'), onTap: () {}),
            const VMenuDivider(),
            VMenuItem(
              child: const Text('Delete'),
              destructive: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    ],
  );
}
