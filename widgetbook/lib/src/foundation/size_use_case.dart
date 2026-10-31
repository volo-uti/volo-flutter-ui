import 'package:flutter/material.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../components/widgetbook_components.dart';

/// Size component (Foundation).
WidgetbookComponent sizeComponent() => WidgetbookComponent(
  name: 'Size',
  useCases: [
    WidgetbookUseCase(
      name: 'overview',
      builder: (context) => const _SizeShowcase(),
    ),
  ],
);

class _SizeShowcase extends StatelessWidget {
  const _SizeShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final sizes = theme.sizes;

    return WidgetbookPageLayout(
      title: 'Component Sizes',
      description:
          'All components support five sizes: xs, sm, md, lg, xl. Build harmonious UIs with a consistent sizing system.',
      children: [
        WidgetbookSection(
          title: 'Size Scale',
          description:
              'Visual comparison of each size preset. md is the default size.',
          children: [
            Wrap(
              spacing: 40,
              runSpacing: 24,
              children: [
                _SizeBox(name: 'xs', size: sizes.xs),
                _SizeBox(name: 'sm', size: sizes.sm),
                _SizeBox(name: 'md', size: sizes.md, isDefault: true),
                _SizeBox(name: 'lg', size: sizes.lg),
                _SizeBox(name: 'xl', size: sizes.xl),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Size Tokens',
          description: 'Token values included in each size preset.',
          children: [
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
                3: FlexColumnWidth(),
                4: FlexColumnWidth(),
                5: FlexColumnWidth(),
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
                    FoundationTableHeader('Property'),
                    FoundationTableHeader('xs'),
                    FoundationTableHeader('sm'),
                    FoundationTableHeader('md (default)'),
                    FoundationTableHeader('lg'),
                    FoundationTableHeader('xl'),
                  ],
                ),
                _buildTokenRow5(
                  context,
                  'height',
                  sizes.xs.height,
                  sizes.sm.height,
                  sizes.md.height,
                  sizes.lg.height,
                  sizes.xl.height,
                ),
                _buildTokenRow5(
                  context,
                  'paddingHorizontal',
                  sizes.xs.paddingHorizontal,
                  sizes.sm.paddingHorizontal,
                  sizes.md.paddingHorizontal,
                  sizes.lg.paddingHorizontal,
                  sizes.xl.paddingHorizontal,
                ),
                _buildTokenRow5(
                  context,
                  'paddingVertical',
                  sizes.xs.paddingVertical,
                  sizes.sm.paddingVertical,
                  sizes.md.paddingVertical,
                  sizes.lg.paddingVertical,
                  sizes.xl.paddingVertical,
                ),
                _buildTokenRow5(
                  context,
                  'fontSize',
                  sizes.xs.fontSize,
                  sizes.sm.fontSize,
                  sizes.md.fontSize,
                  sizes.lg.fontSize,
                  sizes.xl.fontSize,
                ),
                _buildTokenRow5(
                  context,
                  'iconSize',
                  sizes.xs.iconSize,
                  sizes.sm.iconSize,
                  sizes.md.iconSize,
                  sizes.lg.iconSize,
                  sizes.xl.iconSize,
                ),
                _buildTokenRow5(
                  context,
                  'gap',
                  sizes.xs.spacing,
                  sizes.sm.spacing,
                  sizes.md.spacing,
                  sizes.lg.spacing,
                  sizes.xl.spacing,
                ),
                _buildTokenRow5(
                  context,
                  'borderRadius',
                  sizes.xs.borderRadius,
                  sizes.sm.borderRadius,
                  sizes.md.borderRadius,
                  sizes.lg.borderRadius,
                  sizes.xl.borderRadius,
                ),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Usage Guidelines',
          description: 'Guidelines for choosing appropriate sizes.',
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
                    FoundationTableHeader('Size'),
                    FoundationTableHeader('When to use'),
                    FoundationTableHeader('Examples'),
                  ],
                ),
                _buildGuidelineRow(
                  context,
                  'xs',
                  'Compact UI, icon-only buttons, dense tables',
                  'Icon button, compact tag, inline action',
                ),
                _buildGuidelineRow(
                  context,
                  'sm',
                  'Dense UI, table interiors, secondary actions',
                  'Table row action, toolbar icon button, compact menu item',
                ),
                _buildGuidelineRow(
                  context,
                  'md',
                  'Default UI, form elements, standard buttons',
                  'Standard button, input field, dropdown trigger',
                ),
                _buildGuidelineRow(
                  context,
                  'lg',
                  'Touch devices, CTA, enhanced accessibility',
                  'Mobile CTA, primary form input, landing page button',
                ),
                _buildGuidelineRow(
                  context,
                  'xl',
                  'Hero sections, large touch targets',
                  'Hero CTA, prominent action, accessibility emphasis',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  TableRow _buildTokenRow5(
    BuildContext context,
    String property,
    double xs,
    double sm,
    double md,
    double lg,
    double xl,
  ) {
    final theme = VTheme.of(context);
    final mono = theme.typography.labelMedium.copyWith(
      fontFamily: theme.typography.fontFamilyMono,
      color: theme.colors.mutedForeground,
    );
    return TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colors.border)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            property,
            style: theme.typography.labelMedium.copyWith(
              fontFamily: theme.typography.fontFamilyMono,
              fontWeight: FontWeight.bold,
              color: theme.colors.foreground,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text('${xs.toStringAsFixed(0)}px', style: mono),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text('${sm.toStringAsFixed(0)}px', style: mono),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text('${md.toStringAsFixed(0)}px', style: mono),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text('${lg.toStringAsFixed(0)}px', style: mono),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text('${xl.toStringAsFixed(0)}px', style: mono),
        ),
      ],
    );
  }

  TableRow _buildGuidelineRow(
    BuildContext context,
    String size,
    String whenToUse,
    String examples,
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
            size,
            style: theme.typography.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colors.foreground,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            whenToUse,
            style: theme.typography.bodySmall.copyWith(
              color: theme.colors.foreground,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            examples,
            style: theme.typography.bodySmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}

class _SizeBox extends StatelessWidget {
  const _SizeBox({
    required this.name,
    required this.size,
    this.isDefault = false,
  });

  final String name;
  final VComponentSize size;
  final bool isDefault;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return SizedBox(
      width: 100,
      child: Column(
        children: [
          // Height visualization
          Container(
            width: 80,
            height: size.height,
            decoration: BoxDecoration(
              color: isDefault ? theme.colors.primary : theme.colors.muted,
              borderRadius: BorderRadius.circular(theme.radius.md),
              border: Border.all(
                color: isDefault ? theme.colors.primary : theme.colors.border,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Name
          Text(
            isDefault ? '$name (default)' : name,
            style: theme.typography.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colors.foreground,
            ),
          ),
          // Value
          Text(
            '${size.height.toInt()}px',
            style: theme.typography.labelSmall.copyWith(
              fontFamily: theme.typography.fontFamilyMono,
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
