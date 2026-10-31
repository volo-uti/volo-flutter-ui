import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vFormBodyComponent() => WidgetbookComponent(
  name: 'VFormBody',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _formBodyPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _FormBodyShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _FormBodySample(),
    ),
  ],
);

Widget _formBodyPlayground(BuildContext context) {
  final k = context.knobs;
  final type = k.object.dropdown<VFormBodyType>(
    label: 'type',
    options: VFormBodyType.values,
    initialOption: VFormBodyType.outlined,
    labelBuilder: (v) => v.name,
  );
  final size = k.object.dropdown<VFormBodySize>(
    label: 'size',
    options: VFormBodySize.values,
    initialOption: VFormBodySize.md,
    labelBuilder: (v) => v.name,
  );
  final color = k.object.dropdown<VFormBodyColor>(
    label: 'color',
    options: VFormBodyColor.values,
    initialOption: VFormBodyColor.primary,
    labelBuilder: (v) => v.name,
  );
  final corner = k.object.dropdown<VFormBodyCorner>(
    label: 'corner',
    options: VFormBodyCorner.values,
    initialOption: VFormBodyCorner.rounded,
    labelBuilder: (v) => v.name,
  );
  final leading = k.boolean(label: 'leading');
  final trailing = k.boolean(label: 'trailing');
  final fullWidth = k.boolean(label: 'fullWidth');
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final readOnly = k.boolean(label: 'readOnly');
  final focused = k.boolean(label: 'focused');
  final error = k.boolean(label: 'error');
  final success = k.boolean(label: 'success');

  return WidgetbookPlayground(
    child: SizedBox(
      width: 320,
      child: VFormBody(
        type: type,
        size: size,
        color: color,
        corner: corner,
        leading: leading ? const Text('#') : null,
        trailing: trailing ? const Text('X') : null,
        fullWidth: fullWidth,
        enabled: enabled,
        readOnly: readOnly,
        focused: focused,
        error: error,
        success: success,
        child: const Text('Content'),
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _FormBodyShowcase extends StatelessWidget {
  const _FormBodyShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VFormBody',
    description:
        'The input container portion of a form field with visual styling.',
    children: [
      const WidgetbookSection(
        title: 'Types',
        children: [
          WidgetbookSubsection(
            title: 'outlined',
            labels: ['VFormBody(type: outlined)'],
            children: [VFormBody(child: Text('Outlined'))],
          ),
          WidgetbookSubsection(
            title: 'filled',
            labels: ['VFormBody(type: filled)'],
            children: [
              VFormBody(type: VFormBodyType.filled, child: Text('Filled')),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'sm',
            labels: ['VFormBody(size: sm)'],
            children: [VFormBody(size: VFormBodySize.sm, child: Text('Small'))],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: ['VFormBody(size: md)'],
            children: [VFormBody(child: Text('Medium'))],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: ['VFormBody(size: lg)'],
            children: [VFormBody(size: VFormBodySize.lg, child: Text('Large'))],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: ['VFormBody()'],
            children: [VFormBody(child: Text('Default'))],
          ),
          WidgetbookSubsection(
            title: 'focused',
            labels: ['VFormBody(focused: true)'],
            children: [VFormBody(focused: true, child: Text('Focused'))],
          ),
          WidgetbookSubsection(
            title: 'error',
            labels: ['VFormBody(error: true)'],
            children: [VFormBody(error: true, child: Text('Error'))],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: ['VFormBody(enabled: false)'],
            children: [VFormBody(enabled: false, child: Text('Disabled'))],
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
              'A wrapper for input areas to maintain consistency in type, color, and size',
            ),
            _guidelineRow(
              theme,
              'Type',
              'Choose between outlined (border) and filled (background) to match the design system',
            ),
            _guidelineRow(
              theme,
              'Size',
              'Recommend using the same size (sm/md/lg) across the entire form',
            ),
            _guidelineRow(
              theme,
              'States',
              'Provide visual feedback for focus, error, and disabled states',
            ),
            _guidelineRow(
              theme,
              'Corner',
              'Follow the design system border-radius rules',
            ),
            _guidelineRow(
              theme,
              'Full Width',
              'Decide on full width usage based on form layout',
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

class _FormBodySample extends StatelessWidget {
  const _FormBodySample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VFormBody Samples',
    description: 'Copy-ready code examples.',
    children: [
      WidgetbookCodeBlock(
        title: 'Outlined Type',
        code: '''VFormBody(
  type: VFormBodyType.outlined,
  child: Text('Content'),
)''',
        preview: VFormBody(child: Text('Content')),
      ),
      WidgetbookCodeBlock(
        title: 'Filled Type',
        code: '''VFormBody(
  type: VFormBodyType.filled,
  child: Text('Content'),
)''',
        preview: VFormBody(type: VFormBodyType.filled, child: Text('Content')),
      ),
      WidgetbookCodeBlock(
        title: 'Error State',
        code: '''VFormBody(
  error: true,
  child: Text('Invalid input'),
)''',
        preview: VFormBody(error: true, child: Text('Invalid input')),
      ),
      WidgetbookCodeBlock(
        title: 'Login form body',
        code: '''Column(
  children: [
    VFormBody(
      leading: Text('@'),
      child: Text('username'),
    ),
    SizedBox(height: 8),
    VFormBody(
      leading: Text('\u{1F512}'),
      child: Text('password'),
    ),
  ],
)''',
        preview: Column(
          children: [
            VFormBody(leading: Text('@'), child: Text('username')),
            SizedBox(height: 8),
            VFormBody(leading: Text('\u{1F512}'), child: Text('password')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Settings form body',
        code: '''Column(
  children: [
    VFormBody(
      type: VFormBodyType.filled,
      size: VFormBodySize.lg,
      child: Text('Dark mode toggle area'),
    ),
    SizedBox(height: 8),
    VFormBody(
      type: VFormBodyType.filled,
      size: VFormBodySize.lg,
      child: Text('Language selector area'),
    ),
  ],
)''',
        preview: Column(
          children: [
            VFormBody(
              type: VFormBodyType.filled,
              size: VFormBodySize.lg,
              child: Text('Dark mode toggle area'),
            ),
            SizedBox(height: 8),
            VFormBody(
              type: VFormBodyType.filled,
              size: VFormBodySize.lg,
              child: Text('Language selector area'),
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Disabled form body',
        code: '''VFormBody(
  type: VFormBodyType.outlined,
  enabled: false,
  child: Text('Read-only content'),
)''',
        preview: VFormBody(enabled: false, child: Text('Read-only content')),
      ),
    ],
  );
}
