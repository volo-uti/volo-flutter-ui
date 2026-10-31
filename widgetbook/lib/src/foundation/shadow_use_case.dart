import 'package:flutter/material.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../components/widgetbook_components.dart';

/// Shadow component (Foundation).
WidgetbookComponent shadowComponent() => WidgetbookComponent(
  name: 'Shadow',
  useCases: [
    WidgetbookUseCase(
      name: 'overview',
      builder: (context) => const _ShadowShowcase(),
    ),
  ],
);

class _ShadowShowcase extends StatelessWidget {
  const _ShadowShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final shadows = theme.shadows;

    return WidgetbookPageLayout(
      title: 'Shadow',
      description: 'A consistent shadow style system with 6 elevation levels.',
      children: [
        WidgetbookSection(
          title: 'Shadow Styles',
          children: [
            Wrap(
              spacing: 48,
              runSpacing: 48,
              children: [
                _ShadowSwatch(
                  name: 'xs',
                  description:
                      'Subtle depth (input, divider)\nblur: 2px, offset: 0,1',
                  shadows: shadows.xs,
                ),
                _ShadowSwatch(
                  name: 'sm',
                  description: 'Card, small popup\nblur: 4px, offset: 0,2',
                  shadows: shadows.sm,
                ),
                _ShadowSwatch(
                  name: 'md',
                  description: 'Dropdown, hover card\nblur: 8px, offset: 0,4',
                  shadows: shadows.md,
                ),
                _ShadowSwatch(
                  name: 'lg',
                  description: 'Modal, dialog\nblur: 16px, offset: 0,8',
                  shadows: shadows.lg,
                ),
                _ShadowSwatch(
                  name: 'xl',
                  description:
                      'Floating element, FAB\nblur: 24px, offset: 0,12',
                  shadows: shadows.xl,
                ),
                _ShadowSwatch(
                  name: 'glow',
                  description: 'Emphasis glow effect\nblur: 20px, offset: 0,0',
                  shadows: shadows.glow,
                ),
              ],
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
                _ShadowBox(name: 'xs', shadows: shadows.xs),
                _ShadowBox(name: 'sm', shadows: shadows.sm),
                _ShadowBox(name: 'md', shadows: shadows.md),
                _ShadowBox(name: 'lg', shadows: shadows.lg),
                _ShadowBox(name: 'xl', shadows: shadows.xl),
                _ShadowBox(name: 'glow', shadows: shadows.glow),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Usage Guidelines',
          description: 'Guidelines for choosing appropriate shadows.',
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
                    FoundationTableHeader('Shadow'),
                    FoundationTableHeader('When to use'),
                    FoundationTableHeader('Examples'),
                  ],
                ),
                _buildGuidelineRow(
                  context,
                  'xs (blur 2px)',
                  'Subtle depth cue',
                  'Input field, divider, subtle card',
                ),
                _buildGuidelineRow(
                  context,
                  'sm (blur 4px)',
                  'Default card elevation',
                  'Content card, small popup, dropdown panel',
                ),
                _buildGuidelineRow(
                  context,
                  'md (blur 8px)',
                  'Hover state, interactive cards',
                  'Dropdown, hover card, context menu',
                ),
                _buildGuidelineRow(
                  context,
                  'lg (blur 16px)',
                  'Modal, dialog overlays',
                  'Modal dialog, bottom sheet, drawer',
                ),
                _buildGuidelineRow(
                  context,
                  'xl (blur 24px)',
                  'Floating elements',
                  'FAB, floating toolbar, dragged item',
                ),
                _buildGuidelineRow(
                  context,
                  'glow (blur 20px)',
                  'Emphasis, focus indicator',
                  'Brand highlight area, focus ring',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

extension _ShadowGuidelineRow on _ShadowShowcase {
  TableRow _buildGuidelineRow(
    BuildContext context,
    String shadowName,
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
            shadowName,
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

class _ShadowSwatch extends StatelessWidget {
  const _ShadowSwatch({
    required this.name,
    required this.description,
    required this.shadows,
  });

  final String name;
  final String description;
  final List<BoxShadow> shadows;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return SizedBox(
      width: 160,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.colors.card,
              borderRadius: theme.radius.cardRadius,
              boxShadow: shadows,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: theme.typography.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colors.foreground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
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

class _ShadowBox extends StatelessWidget {
  const _ShadowBox({required this.name, required this.shadows});

  final String name;
  final List<BoxShadow> shadows;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colors.card,
            borderRadius: theme.radius.lgRadius,
            boxShadow: shadows,
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
