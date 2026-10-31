import 'package:flutter/material.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../components/widgetbook_components.dart';

/// Typography component (Foundation).
WidgetbookComponent typographyComponent() => WidgetbookComponent(
  name: 'Typography',
  useCases: [
    WidgetbookUseCase(
      name: 'overview',
      builder: (context) => const _TypographyShowcase(),
    ),
  ],
);

/// Typography style entry for Type Scale table.
class _TypeScaleEntry {
  const _TypeScaleEntry(this.name, this.style);
  final String name;
  final TextStyle style;
}

/// Semantic Role entry for Usage Guidelines table.
class _UsageGuidelineEntry {
  const _UsageGuidelineEntry(
    this.role,
    this.name,
    this.whenToUse,
    this.examples,
  );
  final String role;
  final String name;
  final String whenToUse;
  final String examples;
}

class _TypographyShowcase extends StatelessWidget {
  const _TypographyShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final typography = theme.typography;

    return WidgetbookPageLayout(
      title: 'Typography',
      description:
          'A typography system based on Material Design 3 type scale with Semantic Roles for cross-platform consistency.',
      children: [
        // ---- 1. Font Families ----
        WidgetbookSection(
          title: 'Font Families',
          children: [
            _FontFamilyPreview(
              label: 'sans',
              fontName: typography.fontFamily,
              description: 'UI text, headings, body copy',
              previewText: 'The quick brown fox jumps over the lazy dog',
              style: theme.typography.headlineSmall,
            ),
            _FontFamilyPreview(
              label: 'mono',
              fontName: typography.fontFamilyMono,
              description: 'Code, technical content, token names',
              previewText: 'const x = 42; fn(x);',
              style: theme.typography.headlineSmall.copyWith(
                fontFamily: typography.fontFamilyMono,
              ),
            ),
          ],
        ),

        // ---- 2. Type Scale (unified table) ----
        _buildUnifiedTypeScaleSection(context, {
          'Display': [
            _TypeScaleEntry('displayLarge', typography.displayLarge),
            _TypeScaleEntry('displayMedium', typography.displayMedium),
            _TypeScaleEntry('displaySmall', typography.displaySmall),
          ],
          'Headline': [
            _TypeScaleEntry('headlineLarge', typography.headlineLarge),
            _TypeScaleEntry('headlineMedium', typography.headlineMedium),
            _TypeScaleEntry('headlineSmall', typography.headlineSmall),
          ],
          'Title': [
            _TypeScaleEntry('titleLarge', typography.titleLarge),
            _TypeScaleEntry('titleMedium', typography.titleMedium),
            _TypeScaleEntry('titleSmall', typography.titleSmall),
          ],
          'Body': [
            _TypeScaleEntry('bodyLarge', typography.bodyLarge),
            _TypeScaleEntry('bodyMedium', typography.bodyMedium),
            _TypeScaleEntry('bodySmall', typography.bodySmall),
          ],
          'Label': [
            _TypeScaleEntry('labelLarge', typography.labelLarge),
            _TypeScaleEntry('labelMedium', typography.labelMedium),
            _TypeScaleEntry('labelSmall', typography.labelSmall),
          ],
        }),

        // ---- 3. Usage Guidelines (Semantic Role based) ----
        _buildUsageGuidelinesSection(context, [
          const _UsageGuidelineEntry(
            'page-title',
            'headlineLarge',
            'Main page heading',
            'Dashboard title, settings page title',
          ),
          const _UsageGuidelineEntry(
            'section-title',
            'headlineMedium',
            'Section headings',
            'Form group title, sidebar section',
          ),
          const _UsageGuidelineEntry(
            'subsection-title',
            'headlineSmall',
            'Subsection headings',
            'Card group header, filter group',
          ),
          const _UsageGuidelineEntry(
            'card-title',
            'titleLarge',
            'Card / dialog titles',
            'Card heading, dialog title, panel title',
          ),
          const _UsageGuidelineEntry(
            'subtitle',
            'titleMedium',
            'List item titles',
            'List item heading, tab label, nav item',
          ),
          const _UsageGuidelineEntry(
            'compact-title',
            'titleSmall',
            'Compact section titles',
            'Sidebar item, breadcrumb, tag label',
          ),
          const _UsageGuidelineEntry(
            'body-primary',
            'bodyLarge',
            'Primary body text',
            'Article paragraph, description block',
          ),
          const _UsageGuidelineEntry(
            'body-default',
            'bodyMedium',
            'Default body text',
            'List item text, form field value',
          ),
          const _UsageGuidelineEntry(
            'body-secondary',
            'bodySmall',
            'Secondary text',
            'Help text, timestamp, secondary info',
          ),
          const _UsageGuidelineEntry(
            'ui-label',
            'labelLarge',
            'UI labels',
            'Button text, form label, chip label',
          ),
          const _UsageGuidelineEntry(
            'ui-caption',
            'labelMedium',
            'Captions, helper text',
            'Image caption, input helper, badge text',
          ),
          const _UsageGuidelineEntry(
            'ui-small',
            'labelSmall',
            'Smallest text',
            'Footnote, legal text, version number',
          ),
          const _UsageGuidelineEntry(
            'hero-display',
            'displayLarge',
            'Hero / marketing',
            'Landing hero, splash screen, promo banner',
          ),
          const _UsageGuidelineEntry(
            'hero-secondary',
            'displayMedium',
            'Secondary hero',
            'Feature highlight, stat number',
          ),
          const _UsageGuidelineEntry(
            'hero-tertiary',
            'displaySmall',
            'Tertiary hero',
            'Onboarding title, modal hero',
          ),
        ]),
      ],
    );
  }

  /// Unified Type Scale section with category sub-headers
  Widget _buildUnifiedTypeScaleSection(
    BuildContext context,
    Map<String, List<_TypeScaleEntry>> groups,
  ) {
    final theme = VTheme.of(context);

    return WidgetbookSection(
      title: 'Type Scale',
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(150),
              1: FixedColumnWidth(62),
              2: FixedColumnWidth(86),
              3: FixedColumnWidth(62),
              4: FixedColumnWidth(66),
              5: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              // Header row
              TableRow(
                decoration: BoxDecoration(color: theme.colors.muted),
                children: const [
                  FoundationTableHeader('Name'),
                  FoundationTableHeader('Size'),
                  FoundationTableHeader('Weight'),
                  FoundationTableHeader('LH'),
                  FoundationTableHeader('LS'),
                  FoundationTableHeader('Preview'),
                ],
              ),
              // Category groups
              for (final entry in groups.entries) ...[
                // Category sub-header row
                TableRow(
                  decoration: BoxDecoration(
                    color: theme.colors.muted.withValues(alpha: 0.5),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Text(
                        entry.key.toUpperCase(),
                        style: theme.typography.labelSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                    ),
                    const SizedBox.shrink(),
                    const SizedBox.shrink(),
                    const SizedBox.shrink(),
                    const SizedBox.shrink(),
                    const SizedBox.shrink(),
                  ],
                ),
                // Data rows
                for (final item in entry.value)
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
                          '${item.style.fontSize?.toInt()}',
                          style: theme.typography.labelSmall.copyWith(
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
                          '${item.style.fontWeight?.value}',
                          style: theme.typography.labelSmall.copyWith(
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
                          '${item.style.height}',
                          style: theme.typography.labelSmall.copyWith(
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
                          '${item.style.letterSpacing}',
                          style: theme.typography.labelSmall.copyWith(
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
                          'The quick brown fox',
                          style: item.style.copyWith(
                            color: theme.colors.foreground,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Usage Guidelines section with 4 columns: Role | Name | When to use | Examples
  Widget _buildUsageGuidelinesSection(
    BuildContext context,
    List<_UsageGuidelineEntry> items,
  ) {
    final theme = VTheme.of(context);

    return WidgetbookSection(
      title: 'Usage Guidelines',
      description:
          'Choose typography by Semantic Role for cross-platform consistency.',
      children: [
        Table(
          columnWidths: const {
            0: FixedColumnWidth(120),
            1: FixedColumnWidth(120),
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
                FoundationTableHeader('Role'),
                FoundationTableHeader('Name'),
                FoundationTableHeader('When to use'),
                FoundationTableHeader('Examples'),
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
                      item.role,
                      style: theme.typography.labelSmall.copyWith(
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
                      item.name,
                      style: theme.typography.labelSmall.copyWith(
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
                      item.whenToUse,
                      style: theme.typography.bodySmall.copyWith(
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
                      item.examples,
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
    );
  }
}

class _FontFamilyPreview extends StatelessWidget {
  const _FontFamilyPreview({
    required this.label,
    required this.fontName,
    required this.description,
    required this.previewText,
    required this.style,
  });

  final String label;
  final String? fontName;
  final String description;
  final String previewText;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.radius.lg),
        border: Border.all(color: theme.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            previewText,
            style: style.copyWith(color: theme.colors.foreground),
          ),
          const SizedBox(height: 8),
          Text(
            '${fontName ?? 'System Default'} \u2014 $description',
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
