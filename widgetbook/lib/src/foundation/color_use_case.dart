import 'package:flutter/material.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../components/widgetbook_components.dart';

/// Color component (Foundation).
WidgetbookComponent colorComponent() => WidgetbookComponent(
  name: 'Color',
  useCases: [
    WidgetbookUseCase(
      name: 'overview',
      builder: (context) => const _SemanticColorShowcase(),
    ),
  ],
);

class _SemanticColorShowcase extends StatelessWidget {
  const _SemanticColorShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final colors = theme.colors;

    return WidgetbookPageLayout(
      title: 'Semantic Colors',
      description: 'A semantic color system categorized by purpose.',
      children: [
        _buildSection(context, 'Primary', [
          _ColorItem('primary', colors.primary),
          _ColorItem('primaryForeground', colors.primaryForeground),
        ]),
        _buildSection(context, 'Secondary', [
          _ColorItem('secondary', colors.secondary),
          _ColorItem('secondaryForeground', colors.secondaryForeground),
        ]),
        _buildSection(context, 'Tertiary', [
          _ColorItem('tertiary', colors.tertiary),
          _ColorItem('tertiaryForeground', colors.tertiaryForeground),
        ]),
        _buildSection(context, 'Accent', [
          _ColorItem('accent', colors.accent),
          _ColorItem('accentForeground', colors.accentForeground),
        ]),
        _buildSection(context, 'Background & Foreground', [
          _ColorItem('background', colors.background),
          _ColorItem('foreground', colors.foreground),
        ]),
        _buildSection(context, 'Muted', [
          _ColorItem('muted', colors.muted),
          _ColorItem('mutedForeground', colors.mutedForeground),
        ]),
        _buildSection(context, 'Surface Colors', [
          _ColorItem('card', colors.card),
          _ColorItem('cardForeground', colors.cardForeground),
          _ColorItem('popover', colors.popover),
          _ColorItem('popoverForeground', colors.popoverForeground),
        ]),
        _buildSection(context, 'Status Colors', [
          _ColorItem('success', colors.success),
          _ColorItem('successForeground', colors.successForeground),
          _ColorItem('warning', colors.warning),
          _ColorItem('warningForeground', colors.warningForeground),
          _ColorItem('error', colors.error),
          _ColorItem('errorForeground', colors.errorForeground),
          _ColorItem('info', colors.info),
          _ColorItem('infoForeground', colors.infoForeground),
        ]),
        _buildSection(context, 'Destructive', [
          _ColorItem('destructive', colors.destructive),
          _ColorItem('destructiveForeground', colors.destructiveForeground),
        ]),
        _buildSection(context, 'UI Colors', [
          _ColorItem('border', colors.border),
          _ColorItem('input', colors.input),
          _ColorItem('ring', colors.ring),
        ]),
        _buildSection(context, 'State Colors', [
          _ColorItem('disabled', colors.disabled),
          _ColorItem('disabledForeground', colors.disabledForeground),
          _ColorItem('scrim', colors.scrim),
        ]),
        WidgetbookSection(
          title: 'Usage Guidelines',
          description: 'Guidelines for choosing appropriate colors.',
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
                    color: colors.muted,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  children: const [
                    FoundationTableHeader('Color'),
                    FoundationTableHeader('When to use'),
                    FoundationTableHeader('Examples'),
                  ],
                ),
                _buildGuidelineRow(
                  context,
                  'primary',
                  'Primary actions, brand emphasis',
                  'CTA button, active tab, selected item',
                ),
                _buildGuidelineRow(
                  context,
                  'secondary',
                  'Secondary actions, alternative choices',
                  'Cancel button, secondary navigation',
                ),
                _buildGuidelineRow(
                  context,
                  'muted',
                  'Inactive areas, background emphasis',
                  'Disabled state background, subtle divider',
                ),
                _buildGuidelineRow(
                  context,
                  'accent',
                  'Highlight, hover state',
                  'Hover highlight, keyboard focus background',
                ),
                _buildGuidelineRow(
                  context,
                  'destructive',
                  'Delete, dangerous actions',
                  'Delete button, error alert',
                ),
                _buildGuidelineRow(
                  context,
                  'success/warning/error',
                  'Status feedback display',
                  'Form validation, toast notification',
                ),
                _buildGuidelineRow(
                  context,
                  'info',
                  'Informational alerts, notices',
                  'Info banner, help tooltip, guidance message',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<_ColorItem> items,
  ) => WidgetbookSection(
    title: title,
    children: [
      Wrap(
        spacing: 16,
        runSpacing: 16,
        children: items.map((item) => _ColorSwatch(item: item)).toList(),
      ),
    ],
  );
}

class _ColorItem {
  const _ColorItem(this.name, this.color);
  final String name;
  final Color color;
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.item});
  final _ColorItem item;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final hex =
        '#${item.color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: theme.radius.lgRadius,
              border: Border.all(color: theme.colors.border),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.name,
            style: theme.typography.labelSmall.copyWith(
              color: theme.colors.foreground,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            hex,
            style: theme.typography.labelSmall.copyWith(
              color: theme.colors.mutedForeground,
              fontFamily: theme.typography.fontFamilyMono,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

extension _ColorGuidelineRow on _SemanticColorShowcase {
  TableRow _buildGuidelineRow(
    BuildContext context,
    String colorName,
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colors.muted,
              borderRadius: theme.radius.smRadius,
            ),
            child: Text(
              colorName,
              style: theme.typography.labelMedium.copyWith(
                fontFamily: theme.typography.fontFamilyMono,
                fontWeight: FontWeight.bold,
                color: theme.colors.foreground,
              ),
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
