import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vButtonGroupComponent() => WidgetbookComponent(
  name: 'VButtonGroup',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _buttonGroupPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _ButtonGroupShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _ButtonGroupSample(),
    ),
  ],
);

Widget _buttonGroupPlayground(BuildContext context) {
  final k = context.knobs;
  final size = k.object.dropdown<VButtonSize>(
    label: 'size',
    options: VButtonSize.values,
    initialOption: VButtonSize.md,
    labelBuilder: (v) => v.name,
  );
  final orientation = k.object.dropdown<VButtonGroupOrientation>(
    label: 'orientation',
    options: VButtonGroupOrientation.values,
    initialOption: VButtonGroupOrientation.horizontal,
    labelBuilder: (v) => v.name,
  );
  final spacing = k.double.slider(label: 'spacing', max: 24, divisions: 24);
  final count = k.int.slider(
    label: 'buttons',
    initialValue: 3,
    min: 1,
    max: 5,
    divisions: 4,
  );

  final group = VButtonGroup(
    size: size,
    orientation: orientation,
    spacing: spacing,
    children: [
      for (var i = 1; i <= count; i++)
        VButton.outlined(onPressed: () {}, child: Text('Button $i')),
    ],
  );
  return WidgetbookPlayground(
    child: orientation == VButtonGroupOrientation.vertical
        ? SizedBox(width: 300, child: group)
        : group,
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _ButtonGroupShowcase extends StatelessWidget {
  const _ButtonGroupShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VButtonGroup',
    description: 'Groups multiple buttons together as a single visual unit.',
    children: [
      WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'filled',
            labels: const ['variant="filled"'],
            children: [
              VButtonGroup(
                children: [
                  VButton(onPressed: () {}, child: const Text('Left')),
                  VButton(onPressed: () {}, child: const Text('Center')),
                  VButton(onPressed: () {}, child: const Text('Right')),
                ],
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'outlined',
            labels: const ['variant="outlined"'],
            children: [
              VButtonGroup(
                children: [
                  VButton.outlined(onPressed: () {}, child: const Text('Left')),
                  VButton.outlined(
                    onPressed: () {},
                    child: const Text('Center'),
                  ),
                  VButton.outlined(
                    onPressed: () {},
                    child: const Text('Right'),
                  ),
                ],
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'text',
            labels: const ['variant="text"'],
            children: [
              VButtonGroup(
                children: [
                  VButton.text(onPressed: () {}, child: const Text('Left')),
                  VButton.text(onPressed: () {}, child: const Text('Center')),
                  VButton.text(onPressed: () {}, child: const Text('Right')),
                ],
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'ghost',
            labels: const ['variant="ghost"'],
            children: [
              VButtonGroup(
                children: [
                  VButton.ghost(onPressed: () {}, child: const Text('Left')),
                  VButton.ghost(onPressed: () {}, child: const Text('Center')),
                  VButton.ghost(onPressed: () {}, child: const Text('Right')),
                ],
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'sm',
            labels: const ['size="sm"'],
            children: [
              VButtonGroup(
                children: [
                  VButton(
                    onPressed: () {},
                    size: VButtonSize.sm,
                    child: const Text('A'),
                  ),
                  VButton(
                    onPressed: () {},
                    size: VButtonSize.sm,
                    child: const Text('B'),
                  ),
                  VButton(
                    onPressed: () {},
                    size: VButtonSize.sm,
                    child: const Text('C'),
                  ),
                ],
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: const ['size="md"'],
            children: [
              VButtonGroup(
                children: [
                  VButton(onPressed: () {}, child: const Text('A')),
                  VButton(onPressed: () {}, child: const Text('B')),
                  VButton(onPressed: () {}, child: const Text('C')),
                ],
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: const ['size="lg"'],
            children: [
              VButtonGroup(
                children: [
                  VButton(
                    onPressed: () {},
                    size: VButtonSize.lg,
                    child: const Text('A'),
                  ),
                  VButton(
                    onPressed: () {},
                    size: VButtonSize.lg,
                    child: const Text('B'),
                  ),
                  VButton(
                    onPressed: () {},
                    size: VButtonSize.lg,
                    child: const Text('C'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Orientation',
        children: [
          WidgetbookSubsection(
            title: 'horizontal',
            labels: const ['orientation="horizontal"'],
            children: [
              VButtonGroup(
                children: [
                  VButton(onPressed: () {}, child: const Text('Left')),
                  VButton(onPressed: () {}, child: const Text('Center')),
                  VButton(onPressed: () {}, child: const Text('Right')),
                ],
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'vertical',
            labels: const ['orientation="vertical"'],
            children: [
              SizedBox(
                width: 300,
                child: VButtonGroup(
                  orientation: VButtonGroupOrientation.vertical,
                  children: [
                    VButton(onPressed: () {}, child: const Text('Top')),
                    VButton(onPressed: () {}, child: const Text('Middle')),
                    VButton(onPressed: () {}, child: const Text('Bottom')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: const ['default'],
            children: [
              VButtonGroup(
                children: [
                  VButton.outlined(onPressed: () {}, child: const Text('One')),
                  VButton.outlined(onPressed: () {}, child: const Text('Two')),
                  VButton.outlined(
                    onPressed: () {},
                    child: const Text('Three'),
                  ),
                ],
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'mixed disabled',
            labels: const ['individual disabled'],
            children: [
              VButtonGroup(
                children: [
                  VButton.outlined(
                    onPressed: () {},
                    child: const Text('Enabled'),
                  ),
                  const VButton.outlined(child: Text('Disabled')),
                  VButton.outlined(
                    onPressed: () {},
                    child: const Text('Enabled'),
                  ),
                ],
              ),
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
          'Related actions that belong together: text alignment, view modes, pagination',
        ),
        _guidelineRow(
          theme,
          'Variant',
          'Use outlined for most cases. Filled for primary action groups',
        ),
        _guidelineRow(
          theme,
          'Button count',
          'Keep to 2-5 buttons. For more options, use a dropdown or segmented control',
        ),
        _guidelineRow(
          theme,
          'Orientation',
          'Horizontal by default. Vertical for sidebar toolbars or stacked actions',
        ),
        _guidelineRow(
          theme,
          'Disabled items',
          'Disable individual buttons when their action is not available',
        ),
        _guidelineRow(
          theme,
          'Selection',
          'Combine with state management to highlight the active button',
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

class _ButtonGroupSample extends StatelessWidget {
  const _ButtonGroupSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VButtonGroup Samples',
    description: 'Copy-paste code examples for VButtonGroup.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic button group',
        code: '''VButtonGroup(
  children: [
    VButton.outlined(onPressed: () {}, child: Text('Left')),
    VButton.outlined(onPressed: () {}, child: Text('Center')),
    VButton.outlined(onPressed: () {}, child: Text('Right')),
  ],
)''',
        preview: VButtonGroup(
          children: [
            VButton.outlined(onPressed: () {}, child: const Text('Left')),
            VButton.outlined(onPressed: () {}, child: const Text('Center')),
            VButton.outlined(onPressed: () {}, child: const Text('Right')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Filled group',
        code: '''VButtonGroup(
  children: [
    VButton(onPressed: () {}, child: Text('Save')),
    VButton(onPressed: () {}, child: Text('Preview')),
    VButton(onPressed: () {}, child: Text('Cancel')),
  ],
)''',
        preview: VButtonGroup(
          children: [
            VButton(onPressed: () {}, child: const Text('Save')),
            VButton(onPressed: () {}, child: const Text('Preview')),
            VButton(onPressed: () {}, child: const Text('Cancel')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Vertical orientation',
        code: '''VButtonGroup(
  orientation: VButtonGroupOrientation.vertical,
  children: [
    VButton.outlined(onPressed: () {}, child: Text('Top')),
    VButton.outlined(onPressed: () {}, child: Text('Middle')),
    VButton.outlined(onPressed: () {}, child: Text('Bottom')),
  ],
)''',
        preview: SizedBox(
          width: 300,
          child: VButtonGroup(
            orientation: VButtonGroupOrientation.vertical,
            children: [
              VButton.outlined(onPressed: () {}, child: const Text('Top')),
              VButton.outlined(onPressed: () {}, child: const Text('Middle')),
              VButton.outlined(onPressed: () {}, child: const Text('Bottom')),
            ],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'With disabled button',
        code: '''VButtonGroup(
  children: [
    VButton.outlined(onPressed: () {}, child: Text('Enabled')),
    VButton.outlined(onPressed: null, child: Text('Disabled')),
    VButton.outlined(onPressed: () {}, child: Text('Enabled')),
  ],
)''',
        preview: VButtonGroup(
          children: [
            VButton.outlined(onPressed: () {}, child: const Text('Enabled')),
            const VButton.outlined(child: Text('Disabled')),
            VButton.outlined(onPressed: () {}, child: const Text('Enabled')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Segmented control',
        code: '''VButtonGroup(
  children: [
    VButton(onPressed: () {}, child: Text('Day')),
    VButton.outlined(onPressed: () {}, child: Text('Week')),
    VButton.outlined(onPressed: () {}, child: Text('Month')),
    VButton.outlined(onPressed: () {}, child: Text('Year')),
  ],
)''',
        preview: VButtonGroup(
          children: [
            VButton(onPressed: () {}, child: const Text('Day')),
            VButton.outlined(onPressed: () {}, child: const Text('Week')),
            VButton.outlined(onPressed: () {}, child: const Text('Month')),
            VButton.outlined(onPressed: () {}, child: const Text('Year')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Action bar',
        code: '''VButtonGroup(
  children: [
    VButton(onPressed: () {}, child: Text('Save')),
    VButton.outlined(onPressed: () {}, child: Text('Cancel')),
    VButton(
      onPressed: () {},
      color: VButtonColor.destructive,
      child: Text('Delete'),
    ),
  ],
)''',
        preview: VButtonGroup(
          children: [
            VButton(onPressed: () {}, child: const Text('Save')),
            VButton.outlined(onPressed: () {}, child: const Text('Cancel')),
            VButton(
              onPressed: () {},
              color: VButtonColor.destructive,
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Pagination controls',
        code: '''VButtonGroup(
  children: [
    VButton.outlined(onPressed: () {}, child: Text('Prev')),
    VButton.outlined(onPressed: null, child: Text('1')),
    VButton(onPressed: () {}, child: Text('2')),
    VButton.outlined(onPressed: () {}, child: Text('3')),
    VButton.outlined(onPressed: () {}, child: Text('Next')),
  ],
)''',
        preview: VButtonGroup(
          children: [
            VButton.outlined(onPressed: () {}, child: const Text('Prev')),
            const VButton.outlined(child: Text('1')),
            VButton(onPressed: () {}, child: const Text('2')),
            VButton.outlined(onPressed: () {}, child: const Text('3')),
            VButton.outlined(onPressed: () {}, child: const Text('Next')),
          ],
        ),
      ),
    ],
  );
}
