import 'package:flutter/material.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../components/widgetbook_components.dart';

/// Border component (Foundation).
WidgetbookComponent borderComponent() => WidgetbookComponent(
  name: 'Border',
  useCases: [
    WidgetbookUseCase(
      name: 'overview',
      builder: (context) => const _BorderShowcase(),
    ),
  ],
);

class _BorderShowcase extends StatelessWidget {
  const _BorderShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    final borders = theme.borders;
    final items = [
      _BorderItem('default', borders.defaultBorder.width, 'Default border'),
      _BorderItem(
        'strong',
        borders.strong.width,
        'Emphasized border (focus ring, active state)',
      ),
      _BorderItem(
        'subtle',
        borders.subtle.width,
        'Subtle divider or separator',
      ),
    ];

    return WidgetbookPageLayout(
      title: 'Border',
      description:
          'A consistent border style system for containers, inputs, and dividers.',
      children: [
        WidgetbookSection(
          title: 'Border Styles',
          children: [
            Wrap(
              spacing: 40,
              runSpacing: 40,
              children: items.map((item) => _BorderSwatch(item: item)).toList(),
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Comparison',
          children: [
            Wrap(
              spacing: 40,
              runSpacing: 24,
              children: [
                for (final item in items)
                  _BorderBox(name: item.name, width: item.width),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Border Table',
          children: [
            Table(
              columnWidths: const {
                0: FixedColumnWidth(100),
                1: FixedColumnWidth(80),
                2: FixedColumnWidth(80),
                3: FlexColumnWidth(),
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
                    FoundationTableHeader('Width'),
                    FoundationTableHeader('Style'),
                    FoundationTableHeader('Description'),
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
                          '${item.width}px',
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
                          'solid',
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
                          item.description,
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
          description: 'Guidelines for choosing appropriate borders.',
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
                  'Card / Container',
                  'default (1px)',
                  'Content card, section wrapper, data table',
                ),
                _buildGuidelineRow(
                  context,
                  'Input field',
                  'default (1px)',
                  'Text input, select, textarea',
                ),
                _buildGuidelineRow(
                  context,
                  'Focus ring',
                  'strong (1px)',
                  'Keyboard focus outline, active input ring',
                ),
                _buildGuidelineRow(
                  context,
                  'Divider',
                  'subtle (1px)',
                  'Section separator, menu divider',
                ),
                _buildGuidelineRow(
                  context,
                  'Table',
                  'subtle (1px)',
                  'Table cell border, grid line',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

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

class _BorderItem {
  const _BorderItem(this.name, this.width, this.description);
  final String name;
  final double width;
  final String description;
}

class _BorderSwatch extends StatelessWidget {
  const _BorderSwatch({required this.item});
  final _BorderItem item;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    final colorMap = {
      'default': theme.borders.defaultBorder.color,
      'strong': theme.borders.strong.color,
      'subtle': theme.borders.subtle.color,
    };

    return SizedBox(
      width: 200,
      child: Column(
        children: [
          Container(
            width: 160,
            height: 100,
            decoration: BoxDecoration(
              color: theme.colors.card,
              borderRadius: theme.radius.mdRadius,
              border: Border.all(
                color: colorMap[item.name] ?? theme.colors.border,
                width: item.width,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.name,
            style: theme.typography.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colors.foreground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${item.width.toStringAsFixed(0)}px solid',
            style: theme.typography.labelSmall.copyWith(
              fontFamily: theme.typography.fontFamilyMono,
              color: theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.description,
            style: theme.typography.labelSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BorderBox extends StatelessWidget {
  const _BorderBox({required this.name, required this.width});
  final String name;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    final colorMap = {
      'default': theme.borders.defaultBorder.color,
      'strong': theme.borders.strong.color,
      'subtle': theme.borders.subtle.color,
    };

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colors.card,
            borderRadius: theme.radius.lgRadius,
            border: Border.all(
              color: colorMap[name] ?? theme.colors.border,
              width: width,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: theme.typography.labelSmall.copyWith(
            color: theme.colors.foreground,
          ),
        ),
      ],
    );
  }
}
