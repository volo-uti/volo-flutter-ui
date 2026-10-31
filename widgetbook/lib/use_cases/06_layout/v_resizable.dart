import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vResizableComponent() => WidgetbookComponent(
  name: 'VResizable',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _resizablePlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _ResizableShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _ResizableSample(),
    ),
  ],
);

Widget _resizablePlayground(BuildContext context) {
  final k = context.knobs;
  final direction = k.object.dropdown<Axis>(
    label: 'direction',
    options: Axis.values,
    initialOption: Axis.horizontal,
    labelBuilder: (v) => v.name,
  );
  final defaultSize = k.double.slider(
    label: 'defaultSize (Panel A)',
    initialValue: 0.5,
    min: 0.1,
    max: 0.9,
  );
  final minSize = k.double.slider(label: 'minSize (Panel A)', max: 0.5);
  final maxSize = k.double.slider(
    label: 'maxSize (Panel A)',
    initialValue: 1,
    min: 0.5,
    max: 1,
  );
  final collapsible = k.boolean(label: 'collapsible (double-tap handle)');
  final collapsedSize = k.double.slider(label: 'collapsedSize', max: 0.2);
  final withHandle = k.boolean(label: 'withHandle', initialValue: true);
  final enabled = k.boolean(label: 'enabled', initialValue: true);

  return WidgetbookPlayground(
    child: SizedBox(
      width: 400,
      height: 200,
      child: VResizablePanelGroup(
        // The group reads default sizes once, so a knob change rebuilds it.
        key: ValueKey((direction, defaultSize, minSize, maxSize)),
        direction: direction,
        children: [
          VResizablePanel(
            defaultSize: defaultSize,
            minSize: minSize,
            maxSize: maxSize,
            collapsible: collapsible,
            collapsedSize: collapsedSize,
            child: const _PanelContent(
              title: 'Panel A',
              color: Color(0xFFE2E8F0),
            ),
          ),
          VResizableHandle(withHandle: withHandle, enabled: enabled),
          VResizablePanel(
            defaultSize: 1 - defaultSize,
            child: const _PanelContent(
              title: 'Panel B',
              color: Color(0xFFF1F5F9),
            ),
          ),
        ],
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _ResizableShowcase extends StatelessWidget {
  const _ResizableShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VResizable',
    description: 'A panel splitter with draggable resize handles.',
    children: [
      const WidgetbookSection(
        title: 'Directions',
        children: [
          WidgetbookSubsection(
            title: 'horizontal',
            labels: ['Axis.horizontal'],
            children: [_HorizontalDemo()],
          ),
          WidgetbookSubsection(
            title: 'vertical',
            labels: ['Axis.vertical'],
            children: [_VerticalDemo()],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Layouts',
        children: [
          WidgetbookSubsection(
            title: 'three panels',
            labels: ['3-way split'],
            children: [_ThreePanelDemo()],
          ),
          WidgetbookSubsection(
            title: 'nested',
            labels: ['nested panels'],
            children: [_NestedDemo()],
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
              'IDE-style layouts, split views, sidebars',
            ),
            _guidelineRow(
              theme,
              'Size',
              'Limit min/max size with minSize/maxSize',
            ),
            _guidelineRow(
              theme,
              'Collapsible',
              'Recommended for sidebars to be collapsible',
            ),
            _guidelineRow(theme, 'Nested', 'Use nesting for complex layouts'),
            _guidelineRow(
              theme,
              'Keyboard',
              'Supports accessibility via arrow keys',
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

class _ResizableSample extends StatelessWidget {
  const _ResizableSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VResizable Samples',
    description: 'Copy-ready code examples.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic Horizontal Split',
        code: '''VResizablePanelGroup(
  direction: Axis.horizontal,
  children: [
    VResizablePanel(
      defaultSize: 0.3,
      child: Sidebar(),
    ),
    VResizableHandle(),
    VResizablePanel(
      defaultSize: 0.7,
      child: MainContent(),
    ),
  ],
)''',
        preview: _HorizontalDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Vertical Split',
        code: '''VResizablePanelGroup(
  direction: Axis.vertical,
  children: [
    VResizablePanel(
      defaultSize: 0.6,
      child: Editor(),
    ),
    VResizableHandle(),
    VResizablePanel(
      defaultSize: 0.4,
      child: Terminal(),
    ),
  ],
)''',
        preview: _VerticalDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Size Constraints',
        code: '''VResizablePanel(
  defaultSize: 0.25,
  minSize: 0.15,
  maxSize: 0.4,
  child: Sidebar(),
)''',
      ),
      WidgetbookCodeBlock(
        title: 'Collapsible Panel',
        code: '''VResizablePanel(
  defaultSize: 0.25,
  collapsible: true,
  collapsedSize: 0.05,
  onCollapse: () => print('Collapsed'),
  onExpand: () => print('Expanded'),
  child: Sidebar(),
)''',
      ),
      WidgetbookCodeBlock(
        title: 'IDE layout',
        code: '''VResizablePanelGroup(
  direction: Axis.horizontal,
  children: [
    VResizablePanel(
      defaultSize: 0.2,
      minSize: 0.1,
      child: FileExplorer(),
    ),
    VResizableHandle(),
    VResizablePanel(
      defaultSize: 0.6,
      child: VResizablePanelGroup(
        direction: Axis.vertical,
        children: [
          VResizablePanel(defaultSize: 0.7, child: Editor()),
          VResizableHandle(),
          VResizablePanel(defaultSize: 0.3, child: Terminal()),
        ],
      ),
    ),
    VResizableHandle(),
    VResizablePanel(
      defaultSize: 0.2,
      minSize: 0.1,
      child: Inspector(),
    ),
  ],
)''',
        preview: _ThreePanelIdeDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Email layout',
        code: '''VResizablePanelGroup(
  direction: Axis.horizontal,
  children: [
    VResizablePanel(
      defaultSize: 0.3,
      minSize: 0.2,
      child: Text('Inbox list'),
    ),
    VResizableHandle(),
    VResizablePanel(
      defaultSize: 0.7,
      child: Text('Email content'),
    ),
  ],
)''',
        preview: _EmailLayoutDemo(),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _HorizontalDemo extends StatelessWidget {
  const _HorizontalDemo();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return SizedBox(
      width: 400,
      height: 200,
      child: VResizablePanelGroup(
        children: [
          VResizablePanel(
            defaultSize: 0.3,
            minSize: 0.15,
            child: _PanelContent(title: 'Sidebar', color: theme.colors.muted),
          ),
          const VResizableHandle(),
          VResizablePanel(
            defaultSize: 0.7,
            child: _PanelContent(title: 'Content', color: theme.colors.card),
          ),
        ],
      ),
    );
  }
}

class _VerticalDemo extends StatelessWidget {
  const _VerticalDemo();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return SizedBox(
      width: 400,
      height: 200,
      child: VResizablePanelGroup(
        direction: Axis.vertical,
        children: [
          VResizablePanel(
            defaultSize: 0.6,
            child: _PanelContent(title: 'Editor', color: theme.colors.card),
          ),
          const VResizableHandle(),
          VResizablePanel(
            defaultSize: 0.4,
            child: _PanelContent(title: 'Terminal', color: theme.colors.muted),
          ),
        ],
      ),
    );
  }
}

class _ThreePanelDemo extends StatelessWidget {
  const _ThreePanelDemo();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return SizedBox(
      width: 500,
      height: 150,
      child: VResizablePanelGroup(
        children: [
          VResizablePanel(
            defaultSize: 0.2,
            minSize: 0.1,
            child: _PanelContent(title: 'Left', color: theme.colors.muted),
          ),
          const VResizableHandle(),
          VResizablePanel(
            defaultSize: 0.6,
            child: _PanelContent(title: 'Center', color: theme.colors.card),
          ),
          const VResizableHandle(),
          VResizablePanel(
            defaultSize: 0.2,
            minSize: 0.1,
            child: _PanelContent(title: 'Right', color: theme.colors.muted),
          ),
        ],
      ),
    );
  }
}

class _NestedDemo extends StatelessWidget {
  const _NestedDemo();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return SizedBox(
      width: 500,
      height: 250,
      child: VResizablePanelGroup(
        children: [
          VResizablePanel(
            defaultSize: 0.25,
            minSize: 0.15,
            child: _PanelContent(title: 'Sidebar', color: theme.colors.muted),
          ),
          const VResizableHandle(),
          VResizablePanel(
            defaultSize: 0.75,
            child: VResizablePanelGroup(
              direction: Axis.vertical,
              children: [
                VResizablePanel(
                  defaultSize: 0.6,
                  child: _PanelContent(
                    title: 'Editor',
                    color: theme.colors.card,
                  ),
                ),
                const VResizableHandle(),
                VResizablePanel(
                  defaultSize: 0.4,
                  child: _PanelContent(
                    title: 'Terminal',
                    color: theme.colors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreePanelIdeDemo extends StatelessWidget {
  const _ThreePanelIdeDemo();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return SizedBox(
      width: 500,
      height: 250,
      child: VResizablePanelGroup(
        children: [
          VResizablePanel(
            defaultSize: 0.2,
            minSize: 0.1,
            child: _PanelContent(title: 'Explorer', color: theme.colors.muted),
          ),
          const VResizableHandle(),
          VResizablePanel(
            defaultSize: 0.6,
            child: VResizablePanelGroup(
              direction: Axis.vertical,
              children: [
                VResizablePanel(
                  defaultSize: 0.7,
                  child: _PanelContent(
                    title: 'Editor',
                    color: theme.colors.card,
                  ),
                ),
                const VResizableHandle(),
                VResizablePanel(
                  defaultSize: 0.3,
                  child: _PanelContent(
                    title: 'Terminal',
                    color: theme.colors.muted,
                  ),
                ),
              ],
            ),
          ),
          const VResizableHandle(),
          VResizablePanel(
            defaultSize: 0.2,
            minSize: 0.1,
            child: _PanelContent(title: 'Inspector', color: theme.colors.muted),
          ),
        ],
      ),
    );
  }
}

class _PanelContent extends StatelessWidget {
  const _PanelContent({required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Container(
      color: color,
      child: Center(
        child: Text(
          title,
          style: theme.typography.labelMedium.copyWith(
            color: theme.colors.foreground,
          ),
        ),
      ),
    );
  }
}

class _EmailLayoutDemo extends StatelessWidget {
  const _EmailLayoutDemo();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return SizedBox(
      width: 500,
      height: 200,
      child: VResizablePanelGroup(
        children: [
          VResizablePanel(
            defaultSize: 0.3,
            minSize: 0.2,
            child: Container(
              color: theme.colors.muted.withValues(alpha: 0.3),
              child: Center(
                child: Text('Inbox list', style: theme.typography.labelMedium),
              ),
            ),
          ),
          const VResizableHandle(),
          VResizablePanel(
            defaultSize: 0.7,
            child: Container(
              color: theme.colors.muted.withValues(alpha: 0.1),
              child: Center(
                child: Text(
                  'Email content',
                  style: theme.typography.labelMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
