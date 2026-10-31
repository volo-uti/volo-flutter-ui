import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _CardVariant { elevated, outlined }

WidgetbookComponent vCardComponent() => WidgetbookComponent(
  name: 'VCard',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _cardPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _CardShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _CardSample(),
    ),
  ],
);

Widget _cardPlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_CardVariant>(
    label: 'variant',
    options: _CardVariant.values,
    labelBuilder: (v) => v.name,
  );
  final pressable = k.boolean(label: 'onTap');
  final longPressable = k.boolean(label: 'onLongPress');
  final showFooter = k.boolean(label: 'footer');

  var taps = 0;
  var longPresses = 0;
  return StatefulBuilder(
    builder: (context, setState) {
      final onTap = pressable ? () => setState(() => taps++) : null;
      final onLongPress = longPressable
          ? () => setState(() => longPresses++)
          : null;
      final content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const VCardHeader(
            title: Text('Card Title'),
            description: Text('Card content goes here.'),
          ),
          if (showFooter)
            VCardFooter(
              children: [
                VButton.outlined(onPressed: () {}, child: const Text('Cancel')),
              ],
            ),
        ],
      );
      return WidgetbookPlayground(
        info: ['taps: $taps', 'longPresses: $longPresses'],
        child: SizedBox(
          width: 320,
          child: switch (variant) {
            _CardVariant.elevated => VCard.elevated(
              onTap: onTap,
              onLongPress: onLongPress,
              child: content,
            ),
            _CardVariant.outlined => VCard.outlined(
              onTap: onTap,
              onLongPress: onLongPress,
              child: content,
            ),
          },
        ),
      );
    },
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _CardShowcase extends StatelessWidget {
  const _CardShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VCard',
    description:
        'A container component for grouping related content with visual hierarchy.',
    children: [
      const WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'elevated',
            labels: ['variant="elevated"'],
            children: [
              VCard.elevated(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Elevated',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Card with shadow for visual depth.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'outlined',
            labels: ['variant="outlined"'],
            children: [
              VCard.outlined(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Outlined',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Card with border for subtle grouping.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'filled',
            labels: ['variant="filled"'],
            children: [
              VCard(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filled',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Card with background fill.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      const WidgetbookSection(
        title: 'All Variants Comparison',
        children: [
          WidgetbookSubsection(
            title: 'side by side',
            labels: ['elevated', 'outlined', 'filled'],
            children: [
              VCard.elevated(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Elevated',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text('variant="elevated"'),
                    ],
                  ),
                ),
              ),
              VCard.outlined(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Outlined',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text('variant="outlined"'),
                    ],
                  ),
                ),
              ),
              VCard(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filled',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text('variant="filled"'),
                    ],
                  ),
                ),
              ),
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
              'Group related content into a single visual container',
            ),
            _guidelineRow(
              theme,
              'Elevated',
              'Use for primary content areas that need visual prominence',
            ),
            _guidelineRow(
              theme,
              'Outlined',
              'Use for secondary content grouping with subtle borders',
            ),
            _guidelineRow(
              theme,
              'Filled',
              'Use for background-level grouping that blends into the page',
            ),
            _guidelineRow(
              theme,
              'Interactive',
              'Use onTap/onLongPress to make cards tappable for navigation or selection',
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

class _CardSample extends StatelessWidget {
  const _CardSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VCard Samples',
    description: 'Copy-paste code examples for common card patterns.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic card',
        code: '''VCard.elevated(
  child: Column(
    children: [
      Text('Card Title'),
      Text('Card content goes here.'),
    ],
  ),
)''',
        preview: Builder(
          builder: (context) {
            final theme = VTheme.of(context);
            return VCard.elevated(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Card Title', style: theme.typography.titleSmall),
                    const SizedBox(height: 8),
                    Text(
                      'Card content goes here.',
                      style: theme.typography.bodySmall.copyWith(
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Outlined card with actions',
        code: '''VCard.outlined(
  child: Column(
    children: [
      Text('Outlined Card'),
      Text('Description text'),
      Row(children: [
        VButton.outlined(onPressed: () {}, child: Text('Action 1')),
        VButton.outlined(onPressed: () {}, child: Text('Action 2')),
      ]),
    ],
  ),
)''',
        preview: Builder(
          builder: (context) {
            final theme = VTheme.of(context);
            return VCard.outlined(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Outlined Card', style: theme.typography.titleSmall),
                    const SizedBox(height: 8),
                    Text(
                      'Description text',
                      style: theme.typography.bodySmall.copyWith(
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        VButton.outlined(
                          onPressed: () {},
                          child: const Text('Action 1'),
                        ),
                        const SizedBox(width: 8),
                        VButton.outlined(
                          onPressed: () {},
                          child: const Text('Action 2'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Card grid',
        code: '''Row(
  children: [
    VCard.elevated(child: Text('Item 1')),
    VCard.elevated(child: Text('Item 2')),
    VCard.elevated(child: Text('Item 3')),
  ],
)''',
        preview: Row(
          children: [
            Expanded(
              child: VCard.elevated(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Item 1',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text('Description'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: VCard.elevated(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Item 2',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text('Description'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: VCard.elevated(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Item 3',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text('Description'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Card with actions',
        code: '''VCard.elevated(
  onTap: () => navigateToDetail(),
  child: Column(
    children: [
      Text('Tappable Card'),
      Text('Tap to navigate or trigger an action.'),
      Row(children: [
        VButton.text(onPressed: () {}, child: Text('View')),
        VButton.text(onPressed: () {}, child: Text('Share')),
      ]),
    ],
  ),
)''',
        preview: Builder(
          builder: (context) {
            final theme = VTheme.of(context);
            return VCard.elevated(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tappable Card', style: theme.typography.titleSmall),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to navigate or trigger an action.',
                      style: theme.typography.bodySmall.copyWith(
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        VButton.text(
                          onPressed: () {},
                          child: const Text('View'),
                        ),
                        const SizedBox(width: 8),
                        VButton.text(
                          onPressed: () {},
                          child: const Text('Share'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Product card',
        code: r'''VCard.outlined(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(height: 120, color: Colors.grey[200]),
      Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wireless Headphones'),
            Text('$79.99'),
            SizedBox(height: 8),
            VButton(onPressed: () {}, child: Text('Add to Cart')),
          ],
        ),
      ),
    ],
  ),
)''',
        preview: Builder(
          builder: (context) {
            final theme = VTheme.of(context);
            return SizedBox(
              width: 240,
              child: VCard.outlined(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Image',
                            style: TextStyle(color: Color(0xFF9CA3AF)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wireless Headphones',
                            style: theme.typography.titleSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            r'$79.99',
                            style: theme.typography.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: VButton(
                              onPressed: () {},
                              child: const Text('Add to Cart'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Profile card',
        code: '''VCard.elevated(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        VAvatar.text('JS', size: VAvatarSize.lg),
        SizedBox(height: 12),
        Text('Jane Smith'),
        Text('Product Designer'),
      ],
    ),
  ),
)''',
        preview: Builder(
          builder: (context) {
            final theme = VTheme.of(context);
            return SizedBox(
              width: 220,
              child: VCard.elevated(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const VAvatar.text('JS', size: VAvatarSize.lg),
                      const SizedBox(height: 12),
                      Text('Jane Smith', style: theme.typography.titleSmall),
                      const SizedBox(height: 4),
                      Text(
                        'Product Designer',
                        style: theme.typography.bodySmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Interactive card',
        code: '''VCard.outlined(
  onTap: () => navigateToDetail(),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Row(
      children: [
        VAvatar.text('P', size: VAvatarSize.md),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Project Alpha'),
              Text('Updated 2 hours ago'),
            ],
          ),
        ),
        Icon(Icons.chevron_right),
      ],
    ),
  ),
)''',
        preview: Builder(
          builder: (context) {
            final theme = VTheme.of(context);
            return SizedBox(
              width: 320,
              child: VCard.outlined(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const VAvatar.text('P'),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Project Alpha',
                              style: theme.typography.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Updated 2 hours ago',
                              style: theme.typography.bodySmall.copyWith(
                                color: theme.colors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(IconData(0xe5cc, fontFamily: 'MaterialIcons')),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
