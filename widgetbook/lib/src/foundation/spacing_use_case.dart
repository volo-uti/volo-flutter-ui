import 'package:flutter/material.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../components/widgetbook_components.dart';

/// Spacing component (Foundation).
WidgetbookComponent spacingComponent() => WidgetbookComponent(
  name: 'Spacing',
  useCases: [
    WidgetbookUseCase(
      name: 'overview',
      builder: (context) => const _SpacingShowcase(),
    ),
  ],
);

class _SpacingShowcase extends StatelessWidget {
  const _SpacingShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final spacing = theme.spacing;

    final items = [
      _SpacingItem('xxs', spacing.xxs, 'Fine adjustment within icons'),
      _SpacingItem('xs', spacing.xs, 'Extra small spacing'),
      _SpacingItem('sm', spacing.sm, 'Default spacing between elements'),
      _SpacingItem('md', spacing.md, 'Card inner spacing'),
      _SpacingItem('lg', spacing.lg, 'Default spacing between sections'),
      _SpacingItem('xl', spacing.xl, 'Spacing between large elements'),
      _SpacingItem('xxl', spacing.xxl, 'Page padding'),
      _SpacingItem('xxxl', spacing.xxxl, 'Section separator'),
      _SpacingItem('4xl', spacing.fourXL, 'Large section gap, wide padding'),
      _SpacingItem('5xl', spacing.fiveXL, 'Page margin, hero padding'),
      _SpacingItem('6xl', spacing.sixXL, 'Major section divider, landing page'),
    ];

    return WidgetbookPageLayout(
      title: 'Spacing',
      description: 'A consistent spacing system based on a 4px grid.',
      children: [
        WidgetbookSection(
          title: 'Spacing Scale',
          children: [
            Table(
              columnWidths: const {
                0: FixedColumnWidth(80),
                1: FixedColumnWidth(80),
                2: FlexColumnWidth(),
                3: FlexColumnWidth(2),
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
                    FoundationTableHeader('Visual'),
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
                          '${item.value.toStringAsFixed(0)}px',
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
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: item.value.clamp(4.0, 200.0),
                            height: 24,
                            decoration: BoxDecoration(
                              color: theme.colors.primary,
                              borderRadius: theme.radius.smRadius,
                            ),
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
          description: 'Guidelines for choosing appropriate spacing.',
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
                    FoundationTableHeader('Context'),
                    FoundationTableHeader('Recommended'),
                    FoundationTableHeader('Examples'),
                  ],
                ),
                _buildGuidelineRow(
                  context,
                  'Inline elements',
                  'xxs ~ xs (2~4px)',
                  'Icon-label gap, badge padding',
                ),
                _buildGuidelineRow(
                  context,
                  'Inside components',
                  'sm ~ md (8~12px)',
                  'Button padding, input padding',
                ),
                _buildGuidelineRow(
                  context,
                  'Between components',
                  'md ~ lg (12~16px)',
                  'Form field gap, list item spacing',
                ),
                _buildGuidelineRow(
                  context,
                  'Section separation',
                  'xl ~ xxl (20~24px)',
                  'Content block margin, card group gap',
                ),
                _buildGuidelineRow(
                  context,
                  'Page layout',
                  'xxl ~ xxxl (24~32px)',
                  'Page margin, container padding',
                ),
                _buildGuidelineRow(
                  context,
                  'Major layout',
                  '4xl ~ 6xl (40~64px)',
                  'Hero padding, landing page sections',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _SpacingItem {
  const _SpacingItem(this.name, this.value, this.usage);
  final String name;
  final double value;
  final String usage;
}

extension _SpacingGuidelineRow on _SpacingShowcase {
  TableRow _buildGuidelineRow(
    BuildContext context,
    String contextName,
    String recommended,
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
            contextName,
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
