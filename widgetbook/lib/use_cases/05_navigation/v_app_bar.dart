import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _AppBarVariant { standard, transparent, elevated, centered }

Widget _appBarPlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_AppBarVariant>(
    label: 'variant',
    options: _AppBarVariant.values,
    labelBuilder: (v) => v.name,
  );
  final title = k.string(label: 'title', initialValue: 'Page Title');
  final automaticallyImplyLeading = k.boolean(
    label: 'automaticallyImplyLeading',
    initialValue: true,
  );
  final withLeading = k.boolean(label: 'leading');
  final withActions = k.boolean(label: 'actions');

  var presses = 0;
  return StatefulBuilder(
    builder: (context, setState) {
      final titleWidget = Text(title);
      final leading = withLeading
          ? VIconButton(
              icon: const Icon(IconData(0xe5d2, fontFamily: 'MaterialIcons')),
              onPressed: () => setState(() => presses++),
            )
          : null;
      final actions = withActions
          ? [
              VIconButton(
                icon: const Icon(IconData(0xe8b6, fontFamily: 'MaterialIcons')),
                onPressed: () => setState(() => presses++),
              ),
            ]
          : null;
      return WidgetbookPlayground(
        info: ['presses: $presses'],
        child: SizedBox(
          width: 480,
          child: switch (variant) {
            _AppBarVariant.standard => VAppBar(
              title: titleWidget,
              leading: leading,
              actions: actions,
              automaticallyImplyLeading: automaticallyImplyLeading,
            ),
            _AppBarVariant.transparent => VAppBar.transparent(
              title: titleWidget,
              leading: leading,
              actions: actions,
              automaticallyImplyLeading: automaticallyImplyLeading,
            ),
            _AppBarVariant.elevated => VAppBar.elevated(
              title: titleWidget,
              leading: leading,
              actions: actions,
              automaticallyImplyLeading: automaticallyImplyLeading,
            ),
            _AppBarVariant.centered => VAppBar.centered(
              title: titleWidget,
              leading: leading,
              actions: actions,
              automaticallyImplyLeading: automaticallyImplyLeading,
            ),
          },
        ),
      );
    },
  );
}

WidgetbookComponent vAppBarComponent() => WidgetbookComponent(
  name: 'VAppBar',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _appBarPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _AppBarShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _AppBarSample(),
    ),
  ],
);

// =============================================================================
// Showcase
// =============================================================================

class _AppBarShowcase extends StatelessWidget {
  const _AppBarShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VAppBar',
    description: 'Top app bar for title, navigation, and actions.',
    children: [
      const WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: ['VAppBar()'],
            children: [
              SizedBox(height: 56, child: VAppBar(title: Text('Default'))),
            ],
          ),
          WidgetbookSubsection(
            title: 'transparent',
            labels: ['VAppBar.transparent()'],
            children: [
              SizedBox(
                height: 56,
                child: VAppBar.transparent(title: Text('Transparent')),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'elevated',
            labels: ['VAppBar.elevated()'],
            children: [
              SizedBox(
                height: 56,
                child: VAppBar.elevated(title: Text('Elevated')),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'centered',
            labels: ['VAppBar.centered()'],
            children: [
              SizedBox(
                height: 56,
                child: VAppBar.centered(title: Text('Centered')),
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'With Leading',
        children: [
          WidgetbookSubsection(
            title: 'leading',
            labels: const ['custom icon'],
            children: [
              VAppBar(
                title: const Text('Custom Leading'),
                automaticallyImplyLeading: false,
                leading: VIconButton(
                  icon: const Icon(
                    IconData(0xe5d2, fontFamily: 'MaterialIcons'),
                  ),
                  onPressed: () {},
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
              'Provide consistent top-level navigation with title and actions',
            ),
            _guidelineRow(
              theme,
              'Default',
              'Standard app bar with solid background',
            ),
            _guidelineRow(
              theme,
              'Transparent',
              'Use for hero sections or overlay content',
            ),
            _guidelineRow(
              theme,
              'Elevated',
              'Use when visual separation from content is needed',
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

class _AppBarSample extends StatelessWidget {
  const _AppBarSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VAppBar Samples',
    description: 'Copy-paste code examples.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Basic Usage',
        code: '''VAppBar(
  title: Text('Title'),
)''',
        preview: VAppBar(title: Text('Title')),
      ),
      WidgetbookCodeBlock(
        title: 'With Actions',
        code: '''VAppBar(
  title: Text('Title'),
  actions: [
    VIconButton(icon: Icon(Icons.search), onPressed: () {}),
    VIconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
  ],
)''',
        preview: VAppBar(
          title: const Text('Title'),
          actions: [
            VIconButton(
              icon: const Icon(IconData(0xe8b6, fontFamily: 'MaterialIcons')),
              onPressed: () {},
            ),
            VIconButton(
              icon: const Icon(IconData(0xe5d3, fontFamily: 'MaterialIcons')),
              onPressed: () {},
            ),
          ],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Centered',
        code: '''VAppBar.centered(
  title: Text('Centered Title'),
)''',
        preview: VAppBar.centered(title: Text('Centered Title')),
      ),
      WidgetbookCodeBlock(
        title: 'Search app bar',
        code: '''VAppBar(
  title: Text('Search'),
  actions: [
    VIconButton(icon: Icon(Icons.search), onPressed: () {}),
    VIconButton(icon: Icon(Icons.filter_list), onPressed: () {}),
  ],
)''',
        preview: VAppBar(
          title: const Text('Search'),
          actions: [
            VIconButton(
              icon: const Icon(IconData(0xe8b6, fontFamily: 'MaterialIcons')),
              onPressed: () {},
            ),
            VIconButton(
              icon: const Icon(IconData(0xe152, fontFamily: 'MaterialIcons')),
              onPressed: () {},
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Back navigation',
        code: '''VAppBar(
  leading: VIconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => Navigator.pop(context),
  ),
  title: const Text('Product Detail'),
  automaticallyImplyLeading: false,
)''',
        preview: VAppBar(
          leading: VIconButton(
            icon: const Icon(IconData(0xe5c4, fontFamily: 'MaterialIcons')),
            onPressed: () {},
          ),
          title: const Text('Product Detail'),
          automaticallyImplyLeading: false,
        ),
      ),
      WidgetbookCodeBlock(
        title: 'App bar with actions',
        code: '''VAppBar(
  title: Text('Messages'),
  actions: [
    VIconButton(
      icon: Icon(Icons.search),
      onPressed: () {},
    ),
    VIconButton(
      icon: Icon(Icons.more_vert),
      onPressed: () {},
    ),
  ],
)''',
        preview: VAppBar(
          title: const Text('Messages'),
          actions: [
            VIconButton(
              icon: const Icon(IconData(0xe8b6, fontFamily: 'MaterialIcons')),
              onPressed: () {},
            ),
            VIconButton(
              icon: const Icon(IconData(0xe5d4, fontFamily: 'MaterialIcons')),
              onPressed: () {},
            ),
          ],
        ),
      ),
    ],
  );
}
