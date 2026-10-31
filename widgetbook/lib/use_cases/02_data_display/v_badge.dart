import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vBadgeComponent() => WidgetbookComponent(
  name: 'VBadge',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _badgePlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _BadgeShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _BadgeSample(),
    ),
  ],
);

enum _BadgeVariant {
  count,
  muted,
  primary,
  secondary,
  success,
  warning,
  destructive,
  outline,
}

Widget _badgePlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_BadgeVariant>(
    label: 'variant',
    options: _BadgeVariant.values,
    initialOption: _BadgeVariant.primary,
    labelBuilder: (v) => v.name,
  );
  final size = k.object.dropdown<VBadgeSize>(
    label: 'size',
    options: VBadgeSize.values,
    initialOption: VBadgeSize.md,
    labelBuilder: (v) => v.name,
  );
  final label = Text(k.string(label: 'label', initialValue: '5'));
  final count = k.int.slider(label: 'count', initialValue: 5, max: 200);
  final max = k.int.slider(label: 'max', initialValue: 99, min: 1, max: 200);
  final invisible = k.boolean(label: 'invisible');
  final semanticLabel = k.string(label: 'semanticLabel');
  final sem = semanticLabel.isEmpty ? null : semanticLabel;

  return WidgetbookPlayground(
    child: switch (variant) {
      _BadgeVariant.count => VBadge.count(
        count: count,
        max: max,
        size: size,
        invisible: invisible,
        semanticLabel: sem,
      ),
      _BadgeVariant.muted => VBadge(
        label: label,
        size: size,
        invisible: invisible,
        semanticLabel: sem,
      ),
      _BadgeVariant.primary => VBadge.primary(
        label: label,
        size: size,
        invisible: invisible,
        semanticLabel: sem,
      ),
      _BadgeVariant.secondary => VBadge.secondary(
        label: label,
        size: size,
        invisible: invisible,
        semanticLabel: sem,
      ),
      _BadgeVariant.success => VBadge.success(
        label: label,
        size: size,
        invisible: invisible,
        semanticLabel: sem,
      ),
      _BadgeVariant.warning => VBadge.warning(
        label: label,
        size: size,
        invisible: invisible,
        semanticLabel: sem,
      ),
      _BadgeVariant.destructive => VBadge.destructive(
        label: label,
        size: size,
        invisible: invisible,
        semanticLabel: sem,
      ),
      _BadgeVariant.outline => VBadge.outline(
        label: label,
        size: size,
        invisible: invisible,
        semanticLabel: sem,
      ),
    },
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _BadgeShowcase extends StatelessWidget {
  const _BadgeShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VBadge',
    description:
        'Displays a small indicator attached to a child element, such as a count or status dot.',
    children: [
      const WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'standard',
            labels: ['VBadge variant="standard"'],
            children: [
              VBadge(label: Text('5')),
              VBadge(label: Text('NEW')),
            ],
          ),
          WidgetbookSubsection(
            title: 'dot',
            labels: ['VBadge variant="dot"'],
            children: [
              VBadge.primary(label: Text('')),
              VBadge.success(label: Text('')),
              VBadge.destructive(label: Text('')),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Colors',
        children: [
          WidgetbookSubsection(
            title: 'primary',
            labels: ['VBadge color="primary"'],
            children: [VBadge.primary(label: Text('3'))],
          ),
          WidgetbookSubsection(
            title: 'secondary',
            labels: ['VBadge color="secondary"'],
            children: [VBadge.secondary(label: Text('3'))],
          ),
          WidgetbookSubsection(
            title: 'destructive',
            labels: ['VBadge color="destructive"'],
            children: [VBadge.destructive(label: Text('3'))],
          ),
          WidgetbookSubsection(
            title: 'success',
            labels: ['VBadge color="success"'],
            children: [VBadge.success(label: Text('3'))],
          ),
          WidgetbookSubsection(
            title: 'warning',
            labels: ['VBadge color="warning"'],
            children: [VBadge.warning(label: Text('3'))],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Max Value',
        children: [
          WidgetbookSubsection(
            title: 'within max',
            labels: const ['VBadge.count(count: 50)'],
            children: [VBadge.count(count: 50)],
          ),
          WidgetbookSubsection(
            title: 'exceeds max',
            labels: const [
              'VBadge.count(count: 150)',
              'VBadge.count(count: 12, max: 9)',
            ],
            children: [
              VBadge.count(count: 150),
              VBadge.count(count: 12, max: 9),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'visible',
            labels: ['VBadge invisible={false}'],
            children: [VBadge(label: Text('5'))],
          ),
          WidgetbookSubsection(
            title: 'invisible',
            labels: ['VBadge invisible'],
            children: [SizedBox.shrink()],
          ),
        ],
      ),

      // Usage Guidelines
      WidgetbookSection(
        title: 'Usage Guidelines',
        children: [_UsageGuidelinesTable()],
      ),
    ],
  );
}

class _UsageGuidelinesTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    return Table(
      columnWidths: const {0: FixedColumnWidth(160), 1: FlexColumnWidth()},
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: theme.colors.muted,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          children: [
            _tableHeader(theme, 'Category'),
            _tableHeader(theme, 'Guideline'),
          ],
        ),
        _guidelineRow(
          theme,
          'When to use',
          'Show unread counts, notification indicators, or status dots on icons and avatars.',
        ),
        _guidelineRow(
          theme,
          'When not to use',
          'For labeling or categorization. Use VChip instead.',
        ),
        _guidelineRow(
          theme,
          'Max value',
          'Use VBadge.count and set max to cap the displayed number and show "{max}+" for overflow.',
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

class _BadgeSample extends StatelessWidget {
  const _BadgeSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VBadge Samples',
    description: 'Copy-paste code examples for VBadge.',
    children: [
      WidgetbookCodeBlock(
        title: 'Notification badge',
        code: '''VBadge.destructive(label: Text('5'))''',
        preview: Row(children: [VBadge.destructive(label: Text('5'))]),
      ),
      WidgetbookCodeBlock(
        title: 'Online status indicator (dot)',
        code: '''VBadge.success(label: Text(''))''',
        preview: Row(children: [VBadge.success(label: Text(''))]),
      ),
      WidgetbookCodeBlock(
        title: 'Max overflow display',
        code: '''VBadge.count(count: 150)''',
        preview: Row(children: [VBadge.destructive(label: Text('99+'))]),
      ),
      WidgetbookCodeBlock(
        title: 'Text badge',
        code: '''VBadge.success(label: Text('NEW'))''',
        preview: Row(children: [VBadge.success(label: Text('NEW'))]),
      ),
      WidgetbookCodeBlock(
        title: 'Cart item count',
        code: '''Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(Icons.shopping_cart, size: 28),
    SizedBox(width: 4),
    VBadge.destructive(label: Text('3')),
  ],
)''',
        preview: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(IconData(0xe8cc, fontFamily: 'MaterialIcons'), size: 28),
            SizedBox(width: 4),
            VBadge.destructive(label: Text('3')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Tab with badge',
        code: '''Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text('Messages'),
    SizedBox(width: 8),
    VBadge.primary(label: Text('12')),
  ],
)''',
        preview: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Messages'),
            SizedBox(width: 8),
            VBadge.primary(label: Text('12')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Status indicators',
        code: '''Row(
  spacing: 12,
  children: [
    VBadge.success(label: Text('Active')),
    VBadge.warning(label: Text('Pending')),
    VBadge.destructive(label: Text('Offline')),
  ],
)''',
        preview: Row(
          spacing: 12,
          children: [
            VBadge.success(label: Text('Active')),
            VBadge.warning(label: Text('Pending')),
            VBadge.destructive(label: Text('Offline')),
          ],
        ),
      ),
    ],
  );
}
