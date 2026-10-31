import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vCommandComponent() => WidgetbookComponent(
  name: 'VCommand',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _commandPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _CommandShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _CommandSample(),
    ),
  ],
);

Widget _commandPlayground(BuildContext context) {
  final k = context.knobs;
  final placeholder = k.stringOrNull(
    label: 'placeholder',
    initialValue: 'Type a command...',
  );
  final loading = k.boolean(label: 'loading');
  final startsWithOnly = k.boolean(label: 'filter: starts with');
  final customEmpty = k.boolean(label: 'emptyBuilder');
  final emailEnabled = k.boolean(label: 'email.enabled', initialValue: true);
  var ran = 'none';

  return StatefulBuilder(
    builder: (context, setState) {
      void run(String name) => setState(() => ran = name);
      return WidgetbookPlayground(
        info: ['ran: $ran'],
        child: Center(
          child: SizedBox(
            width: 350,
            child: VCommand(
              placeholder: placeholder,
              loading: loading,
              filter: startsWithOnly
                  ? (item, query) =>
                        item.value.toLowerCase().startsWith(query.toLowerCase())
                  : null,
              emptyBuilder: customEmpty
                  ? (query) => Text('Nothing for "$query"')
                  : null,
              children: [
                const VCommandInput(),
                VCommandList(
                  children: [
                    VCommandGroup(
                      heading: 'Suggestions',
                      children: [
                        VCommandItem(
                          value: 'calendar',
                          keywords: const ['date', 'agenda'],
                          leading: const Text('\u{1F4C5}'),
                          trailing: const VCommandShortcut(keys: ['⌘', 'K']),
                          onTap: () => run('calendar'),
                          child: const Text('Calendar'),
                        ),
                        VCommandItem(
                          value: 'emoji',
                          leading: const Text('\u{1F600}'),
                          onTap: () => run('emoji'),
                          child: const Text('Search Emoji'),
                        ),
                        VCommandItem(
                          value: 'email',
                          enabled: emailEnabled,
                          leading: const Text('\u{2709}'),
                          onTap: () => run('email'),
                          child: const Text('Send Email'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _CommandShowcase extends StatelessWidget {
  const _CommandShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VCommand',
    description: 'Command palette for quick search and navigation actions.',
    children: [
      const WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'inline',
            labels: ['VCommand()'],
            children: [_InlineDemo()],
          ),
          WidgetbookSubsection(
            title: 'dialog',
            labels: ['VCommand.dialog()'],
            children: [_DialogDemo()],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Components',
        children: [
          WidgetbookSubsection(
            title: 'with groups',
            labels: ['VCommandGroup()'],
            children: [_WithGroupsDemo()],
          ),
          WidgetbookSubsection(
            title: 'with shortcuts',
            labels: ['VCommandShortcut()'],
            children: [_WithShortcutsDemo()],
          ),
          WidgetbookSubsection(
            title: 'with icons',
            labels: ['leading: Icon(...)'],
            children: [_WithIconsDemo()],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'empty',
            labels: ['VCommandEmpty()'],
            children: [_EmptyStateDemo()],
          ),
          WidgetbookSubsection(
            title: 'loading',
            labels: ['loading: true'],
            children: [_LoadingDemo()],
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
              'Use Case',
              'Use for quick command execution, search, and navigation',
            ),
            _guidelineRow(
              theme,
              'Shortcut',
              'Recommended shortcut: Cmd+K (Mac) / Ctrl+K (Windows)',
            ),
            _guidelineRow(
              theme,
              'Grouping',
              'Group related commands using VCommandGroup',
            ),
            _guidelineRow(
              theme,
              'Keyboard',
              'Navigate with arrow keys, select with Enter, close with Escape',
            ),
            _guidelineRow(
              theme,
              'Filtering',
              'Searchable via value and keywords',
            ),
            _guidelineRow(
              theme,
              'Dialog',
              'Use dialog mode for global commands',
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

class _CommandSample extends StatelessWidget {
  const _CommandSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VCommand Samples',
    description: 'Copy-ready code examples.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic Command Palette',
        code: '''VCommand(
  children: [
    VCommandInput(placeholder: 'Type a command...'),
    VCommandList(
      children: [
        VCommandEmpty(child: Text('No results found.')),
        VCommandGroup(
          heading: 'Suggestions',
          children: [
            VCommandItem(
              value: 'calendar',
              leading: Icon(Icons.calendar_today),
              onTap: () => openCalendar(),
              child: Text('Calendar'),
              trailing: VCommandShortcut(keys: ['⌘', 'C']),
            ),
          ],
        ),
      ],
    ),
  ],
)''',
        preview: _InlineDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Dialog Mode',
        code: '''VCommand.dialog(
  open: isOpen,
  onOpenChanged: (open) => setState(() => isOpen = open),
  children: [
    VCommandInput(placeholder: 'Search...'),
    VCommandList(
      children: [
        VCommandGroup(
          heading: 'Actions',
          children: [
            VCommandItem(
              value: 'new',
              onTap: () => createNew(),
              child: Text('New Document'),
            ),
          ],
        ),
      ],
    ),
  ],
)''',
        preview: _DialogDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Keyboard shortcut',
        code: '''VCommand(
  children: [
    VCommandInput(placeholder: 'Press Cmd+K to open...'),
    VCommandList(
      children: [
        VCommandGroup(
          heading: 'Actions',
          children: [
            VCommandItem(
              value: 'new-file',
              leading: Icon(Icons.add),
              trailing: VCommandShortcut(keys: ['⌘', 'N']),
              child: Text('New File'),
            ),
            VCommandItem(
              value: 'open-file',
              leading: Icon(Icons.folder_open),
              trailing: VCommandShortcut(keys: ['⌘', 'O']),
              child: Text('Open File'),
            ),
            VCommandItem(
              value: 'save',
              leading: Icon(Icons.save),
              trailing: VCommandShortcut(keys: ['⌘', 'S']),
              child: Text('Save'),
            ),
          ],
        ),
      ],
    ),
  ],
)''',
        preview: _WithShortcutsDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Recent items',
        code: '''VCommand(
  children: [
    VCommandInput(placeholder: 'Search...'),
    VCommandList(
      children: [
        VCommandGroup(
          heading: 'Recent',
          children: [
            VCommandItem(value: 'doc-1', child: Text('Project Proposal.pdf')),
            VCommandItem(value: 'doc-2', child: Text('Meeting Notes.md')),
            VCommandItem(value: 'doc-3', child: Text('Budget Report.xlsx')),
          ],
        ),
        VCommandSeparator(),
        VCommandGroup(
          heading: 'Commands',
          children: [
            VCommandItem(value: 'settings', child: Text('Settings')),
            VCommandItem(value: 'help', child: Text('Help')),
          ],
        ),
      ],
    ),
  ],
)''',
        preview: _WithGroupsDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Filtered search',
        code: '''VCommand(
  children: [
    VCommandInput(placeholder: 'Filter by category...'),
    VCommandList(
      children: [
        VCommandGroup(
          heading: 'Pages',
          children: [
            VCommandItem(value: 'home', leading: Text('🏠'), child: Text('Home')),
            VCommandItem(value: 'about', leading: Text('ℹ️'), child: Text('About')),
          ],
        ),
        VCommandSeparator(),
        VCommandGroup(
          heading: 'Settings',
          children: [
            VCommandItem(value: 'profile', leading: Text('👤'), child: Text('Profile')),
            VCommandItem(value: 'billing', leading: Text('💳'), child: Text('Billing')),
          ],
        ),
      ],
    ),
  ],
)''',
        preview: _WithIconsDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Empty state command',
        code: '''VCommand(
  children: [
    VCommandInput(placeholder: 'Search actions...'),
    VCommandEmpty(child: Text('No results found.')),
  ],
)''',
        preview: SizedBox(
          width: 350,
          child: VCommand(
            children: [
              VCommandInput(placeholder: 'Search actions...'),
              VCommandEmpty(child: Text('No results found.')),
            ],
          ),
        ),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _InlineDemo extends StatelessWidget {
  const _InlineDemo();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 350,
    child: VCommand(
      children: [
        VCommandInput(placeholder: 'Type a command...'),
        VCommandList(
          children: [
            VCommandGroup(
              heading: 'Suggestions',
              children: [
                VCommandItem(
                  value: 'calendar',
                  leading: Text('📅'),
                  child: Text('Calendar'),
                ),
                VCommandItem(
                  value: 'emoji',
                  leading: Text('😀'),
                  child: Text('Search Emoji'),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

class _DialogDemo extends StatefulWidget {
  const _DialogDemo();

  @override
  State<_DialogDemo> createState() => _DialogDemoState();
}

class _DialogDemoState extends State<_DialogDemo> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      VButton(
        onPressed: () => setState(() => _isOpen = true),
        child: const Text('Open Command (⌘K)'),
      ),
      if (_isOpen)
        SizedBox(
          width: 400,
          height: 300,
          child: VCommand.dialog(
            open: _isOpen,
            onOpenChanged: (open) => setState(() => _isOpen = open),
            children: const [
              VCommandInput(placeholder: 'Search...'),
              VCommandList(
                children: [
                  VCommandGroup(
                    heading: 'Actions',
                    children: [
                      VCommandItem(
                        value: 'new',
                        leading: Text('📄'),
                        child: Text('New Document'),
                      ),
                      VCommandItem(
                        value: 'save',
                        leading: Text('💾'),
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
    ],
  );
}

class _WithGroupsDemo extends StatelessWidget {
  const _WithGroupsDemo();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 350,
    child: VCommand(
      children: [
        VCommandInput(),
        VCommandList(
          children: [
            VCommandGroup(
              heading: 'Recently Used',
              children: [
                VCommandItem(value: 'recent1', child: Text('Recent Item 1')),
                VCommandItem(value: 'recent2', child: Text('Recent Item 2')),
              ],
            ),
            VCommandSeparator(),
            VCommandGroup(
              heading: 'All Commands',
              children: [
                VCommandItem(value: 'command1', child: Text('Command 1')),
                VCommandItem(value: 'command2', child: Text('Command 2')),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

class _WithShortcutsDemo extends StatelessWidget {
  const _WithShortcutsDemo();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 350,
    child: VCommand(
      children: [
        VCommandInput(),
        VCommandList(
          children: [
            VCommandItem(
              value: 'new',
              trailing: VCommandShortcut(keys: ['⌘', 'N']),
              child: Text('New File'),
            ),
            VCommandItem(
              value: 'open',
              trailing: VCommandShortcut(keys: ['⌘', 'O']),
              child: Text('Open File'),
            ),
            VCommandItem(
              value: 'save',
              trailing: VCommandShortcut(keys: ['⌘', 'S']),
              child: Text('Save'),
            ),
            VCommandItem(
              value: 'saveAs',
              trailing: VCommandShortcut(keys: ['⌘', '⇧', 'S']),
              child: Text('Save As'),
            ),
          ],
        ),
      ],
    ),
  );
}

class _WithIconsDemo extends StatelessWidget {
  const _WithIconsDemo();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 350,
    child: VCommand(
      children: [
        VCommandInput(),
        VCommandList(
          children: [
            VCommandItem(
              value: 'home',
              leading: Text('🏠'),
              child: Text('Home'),
            ),
            VCommandItem(
              value: 'settings',
              leading: Text('⚙️'),
              child: Text('Settings'),
            ),
            VCommandItem(
              value: 'profile',
              leading: Text('👤'),
              child: Text('Profile'),
            ),
            VCommandItem(
              value: 'logout',
              leading: Text('🚪'),
              child: Text('Logout'),
            ),
          ],
        ),
      ],
    ),
  );
}

class _EmptyStateDemo extends StatelessWidget {
  const _EmptyStateDemo();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 350,
    child: VCommand(
      children: [
        VCommandInput(),
        VCommandList(
          children: [
            VCommandEmpty(
              child: Text('No results found. Try a different search.'),
            ),
          ],
        ),
      ],
    ),
  );
}

class _LoadingDemo extends StatelessWidget {
  const _LoadingDemo();

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 350,
    child: VCommand(
      loading: true,
      children: [
        VCommandInput(),
        VCommandList(
          children: [
            VCommandItem(value: 'item1', child: Text('Loading results...')),
          ],
        ),
      ],
    ),
  );
}
