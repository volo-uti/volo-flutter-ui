import 'package:flutter/material.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../components/widgetbook_components.dart';

/// Radius component (Foundation).
WidgetbookComponent radiusComponent() => WidgetbookComponent(
  name: 'Radius',
  useCases: [
    WidgetbookUseCase(
      name: 'overview',
      builder: (context) => const _RadiusShowcase(),
    ),
  ],
);

class _RadiusShowcase extends StatelessWidget {
  const _RadiusShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final radius = theme.radius;

    final items = [
      _RadiusItem('none', radius.none, 'Square corners'),
      _RadiusItem('xs', radius.xs, 'Minimal rounding (tag, badge outline)'),
      _RadiusItem('sm', radius.sm, 'Badge, chip'),
      _RadiusItem('md', radius.md, 'Button, input'),
      _RadiusItem('lg', radius.lg, 'Modal'),
      _RadiusItem('card', radius.card, 'Card'),
      _RadiusItem('xl', radius.xl, 'Extra large (pill tabs, large containers)'),
      _RadiusItem('full', radius.full, 'Avatar, switch'),
    ];

    return WidgetbookPageLayout(
      title: 'Radius',
      description: 'A consistent border radius system.',
      children: [
        WidgetbookSection(
          title: 'Radius Scale',
          children: [
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: items.map((item) => _RadiusSwatch(item: item)).toList(),
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Radius Table',
          children: [
            Table(
              columnWidths: const {
                0: FixedColumnWidth(80),
                1: FixedColumnWidth(100),
                2: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: theme.colors.muted,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  children: const [
                    FoundationTableHeader('Token'),
                    FoundationTableHeader('Value'),
                    FoundationTableHeader('Usage'),
                  ],
                ),
                for (final item in items)
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: theme.colors.border),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          item.name,
                          style: theme.typography.labelMedium.copyWith(
                            fontFamily: theme.typography.fontFamilyMono,
                            fontWeight: FontWeight.bold,
                            color: theme.colors.foreground,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          item.value >= 9999
                              ? 'full'
                              : '${item.value.toStringAsFixed(0)}px',
                          style: theme.typography.labelMedium.copyWith(
                            fontFamily: theme.typography.fontFamilyMono,
                            color: theme.colors.foreground,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          item.usage,
                          style: theme.typography.bodySmall.copyWith(
                            color: theme.colors.mutedForeground,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Usage Guidelines',
          description: 'Guidelines for choosing appropriate border radii.',
          children: [
            Table(
              columnWidths: const {
                0: FixedColumnWidth(120),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(2),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: theme.colors.muted,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  children: const [
                    FoundationTableHeader('Component'),
                    FoundationTableHeader('Recommended'),
                    FoundationTableHeader('Examples'),
                  ],
                ),
                _buildGuidelineRow(
                  context,
                  'Button',
                  'sm (4px) ~ md (8px)',
                  'Action button, form submit, toolbar button',
                ),
                _buildGuidelineRow(
                  context,
                  'Input field',
                  'md (8px)',
                  'Text input, select, textarea',
                ),
                _buildGuidelineRow(
                  context,
                  'Card / Modal',
                  'card (16px) ~ lg (12px)',
                  'Content card, dialog, popover',
                ),
                _buildGuidelineRow(
                  context,
                  'Avatar / Chip',
                  'full (9999px)',
                  'User avatar, status badge',
                ),
                _buildGuidelineRow(
                  context,
                  'Toggle / Switch',
                  'full (9999px)',
                  'Switch control, pill button',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _RadiusItem {
  const _RadiusItem(this.name, this.value, this.usage);
  final String name;
  final double value;
  final String usage;
}

extension _RadiusGuidelineRow on _RadiusShowcase {
  TableRow _buildGuidelineRow(
    BuildContext context,
    String component,
    String recommended,
    String notes,
  ) {
    final theme = VTheme.of(context);
    return TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colors.border)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            component,
            style: theme.typography.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colors.foreground,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            recommended,
            style: theme.typography.labelMedium.copyWith(
              color: theme.colors.foreground,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            notes,
            style: theme.typography.bodySmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}

class _RadiusSwatch extends StatelessWidget {
  const _RadiusSwatch({required this.item});
  final _RadiusItem item;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return SizedBox(
      width: 120,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colors.primary,
              borderRadius: BorderRadius.circular(
                item.value >= 9999 ? 40 : item.value,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.name,
            style: theme.typography.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colors.foreground,
            ),
          ),
          Text(
            item.value >= 9999 ? 'full' : '${item.value.toStringAsFixed(0)}px',
            style: theme.typography.labelSmall.copyWith(
              color: theme.colors.mutedForeground,
              fontFamily: theme.typography.fontFamilyMono,
            ),
          ),
        ],
      ),
    );
  }
}
