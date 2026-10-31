import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vDividerComponent() => WidgetbookComponent(
  name: 'VDivider',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _dividerPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _DividerShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _DividerSample(),
    ),
  ],
);

enum _DividerVariant { normal, bold, dashed, label }

Widget _dividerPlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_DividerVariant>(
    label: 'variant',
    options: _DividerVariant.values,
    initialOption: _DividerVariant.normal,
    labelBuilder: (v) => v.name,
  );
  final direction = k.object.dropdown<Axis>(
    label: 'direction',
    options: Axis.values,
    initialOption: Axis.horizontal,
    labelBuilder: (v) => v.name,
  );
  final thickness = k.double.slider(
    label: 'thickness',
    initialValue: 1,
    min: 1,
    max: 8,
  );
  final indent = k.double.slider(label: 'indent', max: 80);
  final endIndent = k.double.slider(label: 'endIndent', max: 80);
  final label = k.string(label: 'label', initialValue: 'OR');

  final divider = switch (variant) {
    _DividerVariant.bold => VDivider.bold(
      direction: direction,
      indent: indent,
      endIndent: endIndent,
    ),
    _DividerVariant.dashed => VDivider.dashed(
      direction: direction,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    ),
    _DividerVariant.label => VDivider.label(Text(label), thickness: thickness),
    _DividerVariant.normal => VDivider(
      direction: direction,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    ),
  };

  return WidgetbookPlayground(
    child: direction == Axis.vertical
        ? SizedBox(height: 60, child: divider)
        : SizedBox(width: 300, child: divider),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _DividerShowcase extends StatelessWidget {
  const _DividerShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VDivider',
    description:
        'Visually separates content sections. '
        'Supports horizontal/vertical, bold, dashed, and label variants.',
    children: [
      // Variants
      const WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'normal',
            labels: ['VDivider()'],
            fullWidth: true,
            children: [VDivider()],
          ),
          WidgetbookSubsection(
            title: 'bold',
            labels: ['VDivider.bold()'],
            fullWidth: true,
            children: [VDivider.bold()],
          ),
          WidgetbookSubsection(
            title: 'dashed',
            labels: ['VDivider.dashed()'],
            fullWidth: true,
            children: [VDivider.dashed()],
          ),
          WidgetbookSubsection(
            title: 'label',
            labels: ['VDivider.label(Text("OR"))'],
            fullWidth: true,
            children: [VDivider.label(Text('OR'))],
          ),
        ],
      ),

      // Direction
      const WidgetbookSection(
        title: 'Direction',
        children: [
          WidgetbookSubsection(
            title: 'horizontal',
            labels: ['direction="horizontal"'],
            fullWidth: true,
            children: [VDivider()],
          ),
          WidgetbookSubsection(
            title: 'vertical',
            labels: ['direction="vertical"'],
            children: [
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Left'),
                    SizedBox(width: 8),
                    VDivider(direction: Axis.vertical),
                    SizedBox(width: 8),
                    Text('Right'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      // Indent
      const WidgetbookSection(
        title: 'Indent',
        children: [
          WidgetbookSubsection(
            title: 'no indent',
            labels: ['indent=0'],
            fullWidth: true,
            children: [VDivider()],
          ),
          WidgetbookSubsection(
            title: 'start indent',
            labels: ['indent=56'],
            fullWidth: true,
            children: [VDivider(indent: 56)],
          ),
          WidgetbookSubsection(
            title: 'both indents',
            labels: ['indent=16, endIndent=16'],
            fullWidth: true,
            children: [VDivider(indent: 16, endIndent: 16)],
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
              'Separate sections or list items with visual boundary lines',
            ),
            _guidelineRow(
              theme,
              'Horizontal',
              'Full width by default. Use indent for list item dividers',
            ),
            _guidelineRow(
              theme,
              'Vertical',
              'Must have a constrained height from parent (e.g., SizedBox, Row)',
            ),
            _guidelineRow(
              theme,
              'Label',
              'Use for section breaks with text like "OR", "AND", etc.',
            ),
            _guidelineRow(
              theme,
              'Dashed',
              'For visual distinction or less prominent separation',
            ),
            _guidelineRow(
              theme,
              'Bold',
              'Use for strong section breaks between major content areas',
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

class _DividerSample extends StatelessWidget {
  const _DividerSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VDivider Samples',
    description: 'Copy-paste code examples for common divider patterns.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic divider',
        code: 'VDivider()',
        preview: VDivider(),
      ),
      WidgetbookCodeBlock(
        title: 'Bold divider',
        code: 'VDivider.bold()',
        preview: VDivider.bold(),
      ),
      WidgetbookCodeBlock(
        title: 'Dashed divider',
        code: 'VDivider.dashed()',
        preview: VDivider.dashed(),
      ),
      WidgetbookCodeBlock(
        title: 'Label divider',
        code: "VDivider.label(Text('OR'))",
        preview: VDivider.label(Text('OR')),
      ),
      WidgetbookCodeBlock(
        title: 'Indented divider (list item pattern)',
        code: 'VDivider(indent: 56)',
        preview: VDivider(indent: 56),
      ),
      WidgetbookCodeBlock(
        title: 'Section separator',
        code: '''Column(
  children: [
    Text('Section A'),
    SizedBox(height: 12),
    VDivider(),
    SizedBox(height: 12),
    Text('Section B'),
  ],
)''',
        preview: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Section A'),
            SizedBox(height: 12),
            VDivider(),
            SizedBox(height: 12),
            Text('Section B'),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Divider with label',
        code: '''VDivider.label(Text('OR'))''',
        preview: VDivider.label(Text('OR')),
      ),
    ],
  );
}
