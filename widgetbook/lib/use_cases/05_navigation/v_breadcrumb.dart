import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _BreadcrumbSeparator { slash, chevron, dash }

Widget _breadcrumbPlayground(BuildContext context) {
  final k = context.knobs;
  final separator = k.object.dropdown<_BreadcrumbSeparator>(
    label: 'separator',
    options: _BreadcrumbSeparator.values,
    labelBuilder: (v) => v.name,
  );
  final withIcon = k.boolean(label: 'icon');
  final collapse = k.boolean(label: 'maxItems');

  String? tapped;
  return StatefulBuilder(
    builder: (context, setState) {
      VBreadcrumbItem item(String name, {bool current = false}) =>
          VBreadcrumbItem(
            label: Text(name),
            icon: withIcon && name == 'Home'
                ? const Icon(IconData(0xe88a, fontFamily: 'MaterialIcons'))
                : null,
            onTap: current ? null : () => setState(() => tapped = name),
          );
      return WidgetbookPlayground(
        info: ['onTap: ${tapped ?? '-'}'],
        child: VBreadcrumb(
          maxItems: collapse ? 3 : null,
          separator: switch (separator) {
            _BreadcrumbSeparator.slash => null,
            _BreadcrumbSeparator.chevron => const Text('>'),
            _BreadcrumbSeparator.dash => const Text('-'),
          },
          items: [
            item('Home'),
            item('Products'),
            item('Electronics'),
            item('Phones'),
            item('Detail', current: true),
          ],
        ),
      );
    },
  );
}

WidgetbookComponent vBreadcrumbComponent() => WidgetbookComponent(
  name: 'VBreadcrumb',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _breadcrumbPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _BreadcrumbShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _BreadcrumbSample(),
    ),
  ],
);

// =============================================================================
// Showcase
// =============================================================================

class _BreadcrumbShowcase extends StatelessWidget {
  const _BreadcrumbShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VBreadcrumbs',
    description:
        'Hierarchical page navigation showing the current location within a site.',
    children: [
      WidgetbookSection(
        title: 'Separator',
        children: [
          WidgetbookSubsection(
            title: 'slash (default)',
            labels: const ['separator="/"'],
            children: [
              VBreadcrumb(
                items: [
                  VBreadcrumbItem(label: const Text('Home'), onTap: () {}),
                  VBreadcrumbItem(label: const Text('Products'), onTap: () {}),
                  const VBreadcrumbItem(label: Text('Detail')),
                ],
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'chevron',
            labels: const ['separator=">"'],
            children: [
              VBreadcrumb(
                separator: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('>'),
                ),
                items: [
                  VBreadcrumbItem(label: const Text('Home'), onTap: () {}),
                  VBreadcrumbItem(label: const Text('Products'), onTap: () {}),
                  const VBreadcrumbItem(label: Text('Detail')),
                ],
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'dash',
            labels: const ['separator="-"'],
            children: [
              VBreadcrumb(
                separator: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('-'),
                ),
                items: [
                  VBreadcrumbItem(label: const Text('Home'), onTap: () {}),
                  VBreadcrumbItem(label: const Text('Products'), onTap: () {}),
                  const VBreadcrumbItem(label: Text('Detail')),
                ],
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'custom separator',
            labels: const ['separator={<span>|</span>}'],
            children: [
              VBreadcrumb(
                separator: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('|'),
                ),
                items: [
                  VBreadcrumbItem(label: const Text('Home'), onTap: () {}),
                  VBreadcrumbItem(label: const Text('Products'), onTap: () {}),
                  const VBreadcrumbItem(label: Text('Detail')),
                ],
              ),
            ],
          ),
        ],
      ),

      WidgetbookSection(
        title: 'Active / Link States',
        children: [
          WidgetbookSubsection(
            title: 'link and active items',
            labels: const ['VBreadcrumbItem(href)', 'VBreadcrumbItem(active)'],
            children: [
              VBreadcrumb(
                items: [
                  VBreadcrumbItem(label: const Text('Home'), onTap: () {}),
                  VBreadcrumbItem(label: const Text('Category'), onTap: () {}),
                  VBreadcrumbItem(
                    label: const Text('Subcategory'),
                    onTap: () {},
                  ),
                  const VBreadcrumbItem(label: Text('Current Page')),
                ],
              ),
            ],
          ),
          const WidgetbookSubsection(
            title: 'single item',
            labels: ['VBreadcrumbItem(active)'],
            children: [
              VBreadcrumb(items: [VBreadcrumbItem(label: Text('Home'))]),
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
              'Show page hierarchy in multi-level navigation structures',
            ),
            _guidelineRow(
              theme,
              'Separator',
              'Use "/" (default) or ">" for standard breadcrumb patterns',
            ),
            _guidelineRow(
              theme,
              'Active item',
              'The last item should be active and non-clickable',
            ),
            _guidelineRow(
              theme,
              'Accessibility',
              'Rendered in a nav element with aria-label="breadcrumb"',
            ),
            _guidelineRow(
              theme,
              'Custom separator',
              'Any string or character can be used as a custom separator',
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

class _BreadcrumbSample extends StatelessWidget {
  const _BreadcrumbSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VBreadcrumbs Samples',
    description: 'Copy-paste code examples for common breadcrumb patterns.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic breadcrumbs',
        code: '''VBreadcrumb(
  items: [
    VBreadcrumbItem(label: Text('Home'), onTap: () {}),
    VBreadcrumbItem(label: Text('Products'), onTap: () {}),
    VBreadcrumbItem(label: Text('Detail')),
  ],
)''',
        preview: VBreadcrumb(
          items: [
            VBreadcrumbItem(label: const Text('Home'), onTap: () {}),
            VBreadcrumbItem(label: const Text('Products'), onTap: () {}),
            const VBreadcrumbItem(label: Text('Detail')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Chevron separator',
        code: '''VBreadcrumb(
  separator: Text('>'),
  items: [
    VBreadcrumbItem(label: Text('Home'), onTap: () {}),
    VBreadcrumbItem(label: Text('Docs'), onTap: () {}),
    VBreadcrumbItem(label: Text('Getting Started')),
  ],
)''',
        preview: VBreadcrumb(
          separator: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('>'),
          ),
          items: [
            VBreadcrumbItem(label: const Text('Home'), onTap: () {}),
            VBreadcrumbItem(label: const Text('Docs'), onTap: () {}),
            const VBreadcrumbItem(label: Text('Getting Started')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Deep hierarchy',
        code: '''VBreadcrumb(
  items: [
    VBreadcrumbItem(label: Text('Home'), onTap: () {}),
    VBreadcrumbItem(label: Text('Shop'), onTap: () {}),
    VBreadcrumbItem(label: Text('Electronics'), onTap: () {}),
    VBreadcrumbItem(label: Text('Phones'), onTap: () {}),
    VBreadcrumbItem(label: Text('iPhone 15')),
  ],
)''',
        preview: VBreadcrumb(
          items: [
            VBreadcrumbItem(label: const Text('Home'), onTap: () {}),
            VBreadcrumbItem(label: const Text('Shop'), onTap: () {}),
            VBreadcrumbItem(label: const Text('Electronics'), onTap: () {}),
            VBreadcrumbItem(label: const Text('Phones'), onTap: () {}),
            const VBreadcrumbItem(label: Text('iPhone 15')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Dashboard navigation',
        code: '''VBreadcrumb(
  separator: Text('>'),
  items: [
    VBreadcrumbItem(label: Text('Dashboard'), onTap: () {}),
    VBreadcrumbItem(label: Text('Settings'), onTap: () {}),
    VBreadcrumbItem(label: Text('Profile')),
  ],
)''',
        preview: VBreadcrumb(
          separator: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('>'),
          ),
          items: [
            VBreadcrumbItem(label: const Text('Dashboard'), onTap: () {}),
            VBreadcrumbItem(label: const Text('Settings'), onTap: () {}),
            const VBreadcrumbItem(label: Text('Profile')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'With dropdown',
        code: '''VBreadcrumb(
  items: [
    VBreadcrumbItem(label: Text('Home'), onTap: () {}),
    VBreadcrumbItem(label: Text('...'), onTap: () => showCollapsedItems()),
    VBreadcrumbItem(label: Text('Category'), onTap: () {}),
    VBreadcrumbItem(label: Text('Subcategory'), onTap: () {}),
    VBreadcrumbItem(label: Text('Current Page')),
  ],
)''',
        preview: VBreadcrumb(
          items: [
            VBreadcrumbItem(label: const Text('Home'), onTap: () {}),
            VBreadcrumbItem(label: const Text('...'), onTap: () {}),
            VBreadcrumbItem(label: const Text('Category'), onTap: () {}),
            VBreadcrumbItem(label: const Text('Subcategory'), onTap: () {}),
            const VBreadcrumbItem(label: Text('Current Page')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Custom separator',
        code: '''VBreadcrumb(
  separator: Text(' > '),
  items: [
    VBreadcrumbItem(label: Text('Dashboard'), onTap: () {}),
    VBreadcrumbItem(label: Text('Users'), onTap: () {}),
    VBreadcrumbItem(label: Text('Edit')),
  ],
)''',
        preview: VBreadcrumb(
          separator: const Text(' > '),
          items: [
            VBreadcrumbItem(label: const Text('Dashboard'), onTap: () {}),
            VBreadcrumbItem(label: const Text('Users'), onTap: () {}),
            const VBreadcrumbItem(label: Text('Edit')),
          ],
        ),
      ),
    ],
  );
}
