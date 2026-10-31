import 'package:flutter/material.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../components/widgetbook_components.dart';

/// Gradient component (Foundation).
WidgetbookComponent gradientComponent() => WidgetbookComponent(
  name: 'Gradient',
  useCases: [
    WidgetbookUseCase(
      name: 'overview',
      builder: (context) => const _GradientShowcase(),
    ),
  ],
);

class _GradientShowcase extends StatelessWidget {
  const _GradientShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final gradients = theme.gradients;

    final items = [
      _GradientItem(
        'brand',
        gradients.brand,
        'Primary brand gradient (Indigo to Cyan)',
        'Hero sections, brand emphasis',
        'LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF0EA5E9)])',
      ),
      _GradientItem(
        'surface',
        gradients.surface,
        'Subtle surface gradient',
        'Background depth, card surfaces',
        'LinearGradient(colors: [Color(0xFFFAFAFA), Color(0xFFF4F4F5)])',
      ),
    ];

    return WidgetbookPageLayout(
      title: 'Gradient',
      description:
          'Gradient tokens for brand identity and subtle surface depth.',
      children: [
        WidgetbookSection(
          title: 'Gradient Styles',
          children: [
            Wrap(
              spacing: 40,
              runSpacing: 40,
              children: items
                  .map((item) => _GradientSwatch(item: item))
                  .toList(),
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Application Examples',
          children: [
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                SizedBox(
                  width: 400,
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: items[0].gradient,
                      borderRadius: BorderRadius.circular(theme.radius.card),
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Brand Gradient',
                          style: theme.typography.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colors.background,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Used for hero sections and brand emphasis areas.',
                          style: theme.typography.bodySmall.copyWith(
                            color: theme.colors.background.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: items[1].gradient,
                      borderRadius: BorderRadius.circular(theme.radius.card),
                      border: Border.all(color: theme.colors.border),
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Surface Gradient',
                          style: theme.typography.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colors.foreground,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Used for subtle background depth.',
                          style: theme.typography.bodySmall.copyWith(
                            color: theme.colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Gradient Table',
          children: [
            Table(
              columnWidths: const {
                0: FixedColumnWidth(100),
                1: FixedColumnWidth(80),
                2: FlexColumnWidth(),
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
                    FoundationTableHeader('Preview'),
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
                        child: Container(
                          width: 64,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: item.gradient,
                            borderRadius: theme.radius.smRadius,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          item.value,
                          style: theme.typography.labelSmall.copyWith(
                            fontFamily: theme.typography.fontFamilyMono,
                            color: theme.colors.mutedForeground,
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
          description: 'Guidelines for gradient usage.',
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
                    FoundationTableHeader('Gradient'),
                    FoundationTableHeader('When to use'),
                    FoundationTableHeader('Examples'),
                  ],
                ),
                _buildGuidelineRow(
                  context,
                  'brand',
                  'Brand emphasis, CTAs',
                  'Hero section, brand banner, CTA background',
                ),
                _buildGuidelineRow(
                  context,
                  'surface',
                  'Subtle depth, backgrounds',
                  'Page background, card surface',
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
    String gradient,
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
            gradient,
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

class _GradientItem {
  const _GradientItem(
    this.name,
    this.gradient,
    this.description,
    this.usage,
    this.value,
  );
  final String name;
  final LinearGradient gradient;
  final String description;
  final String usage;
  final String value;
}

class _GradientSwatch extends StatelessWidget {
  const _GradientSwatch({required this.item});
  final _GradientItem item;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: item.gradient,
              borderRadius: BorderRadius.circular(theme.radius.card),
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
            item.description,
            style: theme.typography.labelSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.value,
            style: theme.typography.labelSmall.copyWith(
              fontFamily: theme.typography.fontFamilyMono,
              color: theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colors.accent,
              borderRadius: theme.radius.smRadius,
            ),
            child: Text(
              item.usage,
              style: theme.typography.labelSmall.copyWith(
                color: theme.colors.accentForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
