import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vGridComponent() => WidgetbookComponent(
  name: 'VGrid',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _gridPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _GridShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _GridSample(),
    ),
  ],
);

Widget _gridPlayground(BuildContext context) {
  final k = context.knobs;
  final crossAxisCount = k.int.slider(
    label: 'crossAxisCount',
    initialValue: 3,
    min: 1,
    max: 6,
  );
  final spacing = k.double.slider(label: 'spacing', initialValue: 8, max: 32);
  final mainAxisSpacing = k.doubleOrNull.slider(
    label: 'mainAxisSpacing',
    max: 32,
  );
  final crossAxisSpacing = k.doubleOrNull.slider(
    label: 'crossAxisSpacing',
    max: 32,
  );
  final childAspectRatio = k.double.slider(
    label: 'childAspectRatio',
    initialValue: 1,
    min: 0.5,
    max: 3,
  );
  final mainAxisExtent = k.doubleOrNull.slider(
    label: 'mainAxisExtent',
    min: 40,
    max: 200,
  );
  final scrollDirection = k.object.dropdown<Axis>(
    label: 'scrollDirection',
    options: Axis.values,
    initialOption: Axis.vertical,
    labelBuilder: (v) => v.name,
  );
  final shrinkWrap = k.boolean(label: 'shrinkWrap');
  final reverse = k.boolean(label: 'reverse');

  return WidgetbookPlayground(
    layout: PlaygroundLayout.stretch,
    child: SizedBox(
      height: 320,
      child: VGrid.count(
        crossAxisCount: crossAxisCount,
        spacing: spacing,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
        mainAxisExtent: mainAxisExtent,
        scrollDirection: scrollDirection,
        shrinkWrap: shrinkWrap,
        reverse: reverse,
        children: List.generate(
          9,
          (index) => VBox.card(
            alignment: Alignment.center,
            child: Text('${index + 1}'),
          ),
        ),
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _GridShowcase extends StatelessWidget {
  const _GridShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VGrid',
    description:
        'A responsive grid layout with configurable columns and spacing.',
    children: [
      WidgetbookSection(
        title: 'Types',
        children: [
          WidgetbookSubsection(
            title: '2 columns',
            labels: const ['VGrid.count(crossAxisCount: 2)'],
            fullWidth: true,
            children: [
              VGrid.count(
                crossAxisCount: 2,
                spacing: 8,
                shrinkWrap: true,
                children: List.generate(
                  4,
                  (index) => VBox.card(
                    alignment: Alignment.center,
                    child: Text('${index + 1}'),
                  ),
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: '3 columns',
            labels: const ['VGrid.count(crossAxisCount: 3)'],
            fullWidth: true,
            children: [
              VGrid.count(
                crossAxisCount: 3,
                spacing: 8,
                shrinkWrap: true,
                children: List.generate(
                  6,
                  (index) => VBox.card(
                    alignment: Alignment.center,
                    child: Text('${index + 1}'),
                  ),
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'extent',
            labels: const ['VGrid.extent(maxCrossAxisExtent: 100)'],
            fullWidth: true,
            children: [
              VGrid.extent(
                maxCrossAxisExtent: 100,
                spacing: 8,
                shrinkWrap: true,
                children: List.generate(
                  8,
                  (index) => VBox.elevated(
                    alignment: Alignment.center,
                    child: Text('${index + 1}'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Aspect Ratio',
        children: [
          WidgetbookSubsection(
            title: 'childAspectRatio',
            labels: const ['16:9'],
            fullWidth: true,
            children: [
              VGrid.count(
                crossAxisCount: 2,
                spacing: 8,
                childAspectRatio: 16 / 9,
                shrinkWrap: true,
                children: List.generate(
                  4,
                  (index) => VBox.card(
                    alignment: Alignment.center,
                    child: Text('16:9 ${index + 1}'),
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
              'Use when a grid layout is needed (galleries, product lists, card grids, etc.)',
            ),
            _guidelineRow(
              theme,
              'count',
              'Use when the column count is fixed (e.g., 2-column or 3-column grid)',
            ),
            _guidelineRow(
              theme,
              'extent',
              'Use to auto-calculate column count based on max item width',
            ),
            _guidelineRow(
              theme,
              'aspectRatio',
              'Adjust item ratio with childAspectRatio (1:1, 16:9, etc.)',
            ),
            _guidelineRow(
              theme,
              'spacing',
              'Maintain consistent spacing between items; multiples of 8 recommended',
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

class _GridSample extends StatelessWidget {
  const _GridSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VGrid Samples',
    description: 'Copy-ready code examples.',
    children: [
      WidgetbookCodeBlock(
        title: 'Fixed Column Count',
        code: '''VGrid.count(
  crossAxisCount: 2,
  spacing: 8,
  children: [
    VBox.card(child: Text('1')),
    VBox.card(child: Text('2')),
    VBox.card(child: Text('3')),
    VBox.card(child: Text('4')),
  ],
)''',
        preview: VGrid.count(
          crossAxisCount: 2,
          spacing: 8,
          shrinkWrap: true,
          children: List.generate(
            4,
            (index) => VBox.card(
              alignment: Alignment.center,
              child: Text('${index + 1}'),
            ),
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Max Width Extent',
        code: '''VGrid.extent(
  maxCrossAxisExtent: 100,
  spacing: 8,
  children: [...],
)''',
        preview: VGrid.extent(
          maxCrossAxisExtent: 100,
          spacing: 8,
          shrinkWrap: true,
          children: List.generate(
            6,
            (index) => VBox.outlined(
              alignment: Alignment.center,
              child: Text('${index + 1}'),
            ),
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Responsive card grid',
        code: '''VGrid.count(
  crossAxisCount: 2,
  spacing: 12,
  childAspectRatio: 1.4,
  children: [
    VBox.card(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Card Title', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('Description text'),
        ],
      ),
    ),
    // ...more cards
  ],
)''',
        preview: VGrid.count(
          crossAxisCount: 2,
          spacing: 12,
          childAspectRatio: 1.4,
          shrinkWrap: true,
          children: List.generate(
            4,
            (index) => VBox.card(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Card ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text('Description text'),
                ],
              ),
            ),
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Photo gallery',
        code: '''VGrid.count(
  crossAxisCount: 3,
  spacing: 4,
  children: [
    VBox.outlined(alignment: Alignment.center, child: Icon(Icons.image)),
    VBox.outlined(alignment: Alignment.center, child: Icon(Icons.image)),
    VBox.outlined(alignment: Alignment.center, child: Icon(Icons.image)),
    VBox.outlined(alignment: Alignment.center, child: Icon(Icons.image)),
    VBox.outlined(alignment: Alignment.center, child: Icon(Icons.image)),
    VBox.outlined(alignment: Alignment.center, child: Icon(Icons.image)),
  ],
)''',
        preview: VGrid.count(
          crossAxisCount: 3,
          spacing: 4,
          shrinkWrap: true,
          children: List.generate(
            6,
            (index) => const VBox.outlined(
              alignment: Alignment.center,
              child: Icon(
                IconData(0xe3f4, fontFamily: 'MaterialIcons'),
                size: 24,
              ),
            ),
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Dashboard layout',
        code: '''VGrid.count(
  crossAxisCount: 3,
  spacing: 12,
  childAspectRatio: 1.6,
  children: [
    VBox.elevated(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Users'),
          Text('1,234', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    ),
    // ...more widgets
  ],
)''',
        preview: VGrid.count(
          crossAxisCount: 3,
          spacing: 12,
          childAspectRatio: 1.6,
          shrinkWrap: true,
          children: [
            VBox.elevated(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Users'),
                  Text(
                    '1,234',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            VBox.elevated(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Revenue'),
                  Text(
                    r'$5,678',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            VBox.elevated(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Orders'),
                  Text(
                    '892',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Responsive grid',
        code: '''VGrid.extent(
  maxCrossAxisExtent: 200,
  spacing: 16,
  childAspectRatio: 1.0,
  children: [
    VBox.outlined(alignment: Alignment.center, child: Text('Item 1')),
    VBox.outlined(alignment: Alignment.center, child: Text('Item 2')),
    VBox.outlined(alignment: Alignment.center, child: Text('Item 3')),
    VBox.outlined(alignment: Alignment.center, child: Text('Item 4')),
  ],
)''',
        preview: VGrid.extent(
          maxCrossAxisExtent: 150,
          spacing: 12,
          shrinkWrap: true,
          children: [
            VBox.outlined(alignment: Alignment.center, child: Text('Item 1')),
            VBox.outlined(alignment: Alignment.center, child: Text('Item 2')),
            VBox.outlined(alignment: Alignment.center, child: Text('Item 3')),
            VBox.outlined(alignment: Alignment.center, child: Text('Item 4')),
          ],
        ),
      ),
    ],
  );
}
