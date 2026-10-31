import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vChipComponent() => WidgetbookComponent(
  name: 'VChip',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _chipPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _ChipShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _ChipSample(),
    ),
  ],
);

enum _ChipVariant { filled, outlined, filter, input }

Widget _chipPlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_ChipVariant>(
    label: 'variant',
    options: _ChipVariant.values,
    initialOption: _ChipVariant.filled,
    labelBuilder: (v) => v.name,
  );
  final size = k.object.dropdown<VChipSize>(
    label: 'size',
    options: VChipSize.values,
    initialOption: VChipSize.md,
    labelBuilder: (v) => v.name,
  );
  final label = Text(k.string(label: 'label', initialValue: 'Chip'));
  final withLeading = k.boolean(label: 'leading');
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  var selected = k.boolean(label: 'selected');
  final deletable = k.boolean(label: 'onDeleted', initialValue: true);
  final leading = withLeading
      ? const Icon(IconData(0xe838, fontFamily: 'MaterialIcons'), size: 16)
      : null;

  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      info: variant == _ChipVariant.filter ? ['selected: $selected'] : const [],
      child: switch (variant) {
        _ChipVariant.filled => VChip(
          label: label,
          size: size,
          enabled: enabled,
          leading: leading,
          onTap: () {},
        ),
        _ChipVariant.outlined => VChip.outlined(
          label: label,
          size: size,
          enabled: enabled,
          leading: leading,
          onTap: () {},
        ),
        _ChipVariant.filter => VChip.filter(
          label: label,
          size: size,
          enabled: enabled,
          leading: leading,
          selected: selected,
          onSelected: (v) => setState(() => selected = v),
        ),
        _ChipVariant.input => VChip.input(
          label: label,
          size: size,
          enabled: enabled,
          leading: leading,
          onDeleted: deletable ? () {} : null,
        ),
      },
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _ChipShowcase extends StatelessWidget {
  const _ChipShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VChip',
    description:
        'Compact element for displaying tags, categories, or selections.',
    children: [
      const WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'filled',
            labels: ['VChip variant="filled"'],
            children: [
              VChip(label: Text('Primary')),
              VChip(label: Text('Secondary')),
              VChip(label: Text('Destructive')),
              VChip(label: Text('Success')),
              VChip(label: Text('Warning')),
            ],
          ),
          WidgetbookSubsection(
            title: 'outlined',
            labels: ['VChip variant="outlined"'],
            children: [
              VChip.outlined(label: Text('Primary')),
              VChip.outlined(label: Text('Secondary')),
              VChip.outlined(label: Text('Destructive')),
              VChip.outlined(label: Text('Success')),
              VChip.outlined(label: Text('Warning')),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'xs',
            labels: ['VChip size="xs"'],
            children: [VChip(label: Text('Extra Small'), size: VChipSize.xs)],
          ),
          WidgetbookSubsection(
            title: 'sm',
            labels: ['VChip size="sm"'],
            children: [VChip(label: Text('Small'), size: VChipSize.sm)],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: ['VChip size="md"'],
            children: [VChip(label: Text('Medium'))],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: ['VChip size="lg"'],
            children: [VChip(label: Text('Large'), size: VChipSize.lg)],
          ),
          WidgetbookSubsection(
            title: 'xl',
            labels: ['VChip size="xl"'],
            children: [VChip(label: Text('Extra Large'), size: VChipSize.xl)],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Colors',
        children: [
          WidgetbookSubsection(
            title: 'primary',
            labels: ['VChip color="primary"'],
            children: [VChip(label: Text('Primary'))],
          ),
          WidgetbookSubsection(
            title: 'secondary',
            labels: ['VChip color="secondary"'],
            children: [VChip(label: Text('Secondary'))],
          ),
          WidgetbookSubsection(
            title: 'destructive',
            labels: ['VChip color="destructive"'],
            children: [VChip(label: Text('Destructive'))],
          ),
          WidgetbookSubsection(
            title: 'success',
            labels: ['VChip color="success"'],
            children: [VChip(label: Text('Success'))],
          ),
          WidgetbookSubsection(
            title: 'warning',
            labels: ['VChip color="warning"'],
            children: [VChip(label: Text('Warning'))],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Deletable',
        children: [
          WidgetbookSubsection(
            title: 'with delete button',
            labels: ['VChip.input onDeleted'],
            children: [_DeletableChipDemo()],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Start Icon',
        children: [
          WidgetbookSubsection(
            title: 'with icon',
            labels: ['VChip leading'],
            children: [
              VChip(
                label: Text('React'),
                leading: Icon(
                  IconData(0xe8b8, fontFamily: 'MaterialIcons'),
                  size: 16,
                ),
              ),
              VChip(
                label: Text('Starred'),
                leading: Icon(
                  IconData(0xe838, fontFamily: 'MaterialIcons'),
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'enabled',
            labels: ['VChip enabled'],
            children: [VChip(label: Text('Enabled'))],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: ['VChip enabled: false'],
            children: [
              VChip(label: Text('Disabled'), enabled: false),
              VChip.outlined(label: Text('Disabled'), enabled: false),
            ],
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

class _DeletableChipDemo extends StatelessWidget {
  const _DeletableChipDemo();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      VChip.input(label: const Text('Removable'), onDeleted: () {}),
      VChip.input(label: const Text('Removable'), onDeleted: () {}),
      VChip.input(label: const Text('Removable'), onDeleted: () {}),
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
          'Display tags, filter selections, or categorization labels in a compact form.',
        ),
        _guidelineRow(
          theme,
          'When not to use',
          'For count indicators or status dots attached to elements. Use VBadge instead.',
        ),
        _guidelineRow(
          theme,
          'Deletable',
          'Provide onDelete to render a delete button, allowing users to remove the chip.',
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

class _ChipSample extends StatelessWidget {
  const _ChipSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VChip Samples',
    description: 'Copy-paste code examples for VChip.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Basic tag',
        code: '''VChip(label: Text('React'))''',
        preview: Row(children: [VChip(label: Text('React'))]),
      ),
      const WidgetbookCodeBlock(
        title: 'Deletable tag',
        code: '''VChip.input(
  label: Text('TypeScript'),
  onDeleted: () => removeTag('ts'),
)''',
        preview: _InputChipDemo(),
      ),
      const WidgetbookCodeBlock(
        title: 'Tag with icon',
        code: '''VChip(
  label: Text('Starred'),
  leading: Icon(Icons.star, size: 16),
)''',
        preview: Row(
          children: [
            VChip(
              label: Text('Starred'),
              leading: Icon(
                IconData(0xe838, fontFamily: 'MaterialIcons'),
                size: 16,
              ),
            ),
          ],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Tag group',
        code: '''Wrap(
  spacing: 8,
  children: [
    VChip(label: Text('React')),
    VChip(label: Text('Vue')),
    VChip(label: Text('Angular')),
    VChip(label: Text('Svelte')),
  ],
)''',
        preview: Wrap(
          spacing: 8,
          children: [
            VChip(label: Text('React')),
            VChip(label: Text('Vue')),
            VChip(label: Text('Angular')),
            VChip(label: Text('Svelte')),
          ],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Outlined status chips',
        code: '''VChip.outlined(label: Text('Active'))
VChip.outlined(label: Text('Inactive'))''',
        preview: Wrap(
          spacing: 8,
          children: [
            VChip.outlined(label: Text('Active')),
            VChip.outlined(label: Text('Inactive')),
          ],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Filter chips',
        code: '''Wrap(
  spacing: 8,
  children: [
    VChip.filter(
      label: Text('Electronics'),
      selected: true,
      onSelected: (v) => toggleFilter('electronics'),
    ),
    VChip.filter(
      label: Text('Clothing'),
      selected: false,
      onSelected: (v) => toggleFilter('clothing'),
    ),
    VChip.filter(
      label: Text('Books'),
      selected: true,
      onSelected: (v) => toggleFilter('books'),
    ),
  ],
)''',
        preview: _FilterChipsDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Tag list with delete',
        code: '''Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    VChip.input(label: Text('React'), onDeleted: () {}),
    VChip.input(label: Text('Flutter'), onDeleted: () {}),
    VChip.input(label: Text('Vue'), onDeleted: () {}),
  ],
)''',
        preview: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            VChip.input(label: const Text('React'), onDeleted: () {}),
            VChip.input(label: const Text('Flutter'), onDeleted: () {}),
            VChip.input(label: const Text('Vue'), onDeleted: () {}),
          ],
        ),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _InputChipDemo extends StatefulWidget {
  const _InputChipDemo();

  @override
  State<_InputChipDemo> createState() => _InputChipDemoState();
}

class _InputChipDemoState extends State<_InputChipDemo> {
  final List<String> _chips = ['React', 'Flutter', 'Vue'];

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: _chips
        .map(
          (chip) => VChip.input(
            label: Text(chip),
            onDeleted: () => setState(() => _chips.remove(chip)),
          ),
        )
        .toList(),
  );
}

class _FilterChipsDemo extends StatefulWidget {
  const _FilterChipsDemo();

  @override
  State<_FilterChipsDemo> createState() => _FilterChipsDemoState();
}

class _FilterChipsDemoState extends State<_FilterChipsDemo> {
  final Map<String, bool> _filters = {
    'Electronics': true,
    'Clothing': false,
    'Books': true,
  };

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: _filters.entries
        .map(
          (entry) => VChip.filter(
            label: Text(entry.key),
            selected: entry.value,
            onSelected: (v) => setState(() => _filters[entry.key] = v),
          ),
        )
        .toList(),
  );
}
