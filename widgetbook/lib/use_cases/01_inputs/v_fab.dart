import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vFabComponent() => WidgetbookComponent(
  name: 'VFab',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _fabPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _FabShowcase(),
    ),
    WidgetbookUseCase(name: 'Sample', builder: (context) => const _FabSample()),
  ],
);

enum _FabVariant { standard, small, large, extended }

Widget _fabPlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_FabVariant>(
    label: 'variant',
    options: _FabVariant.values,
    labelBuilder: (v) => v.name,
  );
  final label = k.string(label: 'label', initialValue: 'New item');
  final tooltip = k.string(label: 'tooltip', initialValue: 'Add');
  final backgroundColor = k.colorOrNull(label: 'backgroundColor');
  final foregroundColor = k.colorOrNull(label: 'foregroundColor');
  final elevation = k.doubleOrNull.slider(
    label: 'elevation',
    max: 24,
    divisions: 24,
  );
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final pressable = k.boolean(label: 'onPressed', initialValue: true);

  var presses = 0;
  return StatefulBuilder(
    builder: (context, setState) {
      const icon = Icon(IconData(0xe145, fontFamily: 'MaterialIcons'));
      final onPressed = pressable ? () => setState(() => presses++) : null;
      final tip = tooltip.isEmpty ? null : tooltip;

      return WidgetbookPlayground(
        info: ['presses: $presses'],
        child: switch (variant) {
          _FabVariant.standard => VFab(
            icon: icon,
            onPressed: onPressed,
            tooltip: tip,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            elevation: elevation,
            enabled: enabled,
          ),
          _FabVariant.small => VFab.small(
            icon: icon,
            onPressed: onPressed,
            tooltip: tip,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            elevation: elevation,
            enabled: enabled,
          ),
          _FabVariant.large => VFab.large(
            icon: icon,
            onPressed: onPressed,
            tooltip: tip,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            elevation: elevation,
            enabled: enabled,
          ),
          _FabVariant.extended => VFab.extended(
            icon: icon,
            label: Text(label),
            onPressed: onPressed,
            tooltip: tip,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            elevation: elevation,
            enabled: enabled,
          ),
        },
      );
    },
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _FabShowcase extends StatelessWidget {
  const _FabShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VFab',
    description: 'A floating action button for primary screen actions.',
    children: [
      WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'small',
            labels: const ['VFab.small()'],
            children: [
              VFab.small(
                icon: const Text(
                  '+',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'default',
            labels: const ['VFab()'],
            children: [
              VFab(
                icon: const Text(
                  '+',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'large',
            labels: const ['VFab.large()'],
            children: [
              VFab.large(
                icon: const Text(
                  '+',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Extended',
        children: [
          WidgetbookSubsection(
            title: 'icon + label',
            labels: const ['VFab.extended()'],
            children: [
              VFab.extended(
                icon: const Text(
                  '+',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                label: const Text('Add Item'),
                onPressed: () {},
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'label only',
            labels: const ['VFab.extended()'],
            children: [
              VFab.extended(label: const Text('Create'), onPressed: () {}),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Elevation',
        children: [
          WidgetbookSubsection(
            title: '0',
            labels: const ['elevation: 0'],
            children: [
              VFab(
                icon: const Text(
                  '+',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
                elevation: 0,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: '6 (default)',
            labels: const ['elevation: 6'],
            children: [
              VFab(
                icon: const Text(
                  '+',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
                elevation: 6,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: '12',
            labels: const ['elevation: 12'],
            children: [
              VFab(
                icon: const Text(
                  '+',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
                elevation: 12,
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
              'Use to highlight the primary action on a screen (compose, add item)',
            ),
            _guidelineRow(
              theme,
              'Quantity',
              'Recommend only one FAB per screen (focus on primary action)',
            ),
            _guidelineRow(
              theme,
              'Position',
              'Place at the bottom-right of the screen (Material Design guidelines)',
            ),
            _guidelineRow(
              theme,
              'Scroll',
              'Consider hiding or shrinking on scroll (content visibility)',
            ),
            _guidelineRow(
              theme,
              'Extended',
              'Use with a label when the action is not self-explanatory',
            ),
            _guidelineRow(
              theme,
              'Size',
              'Small is suitable for secondary screens, large for primary screens',
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

class _FabSample extends StatelessWidget {
  const _FabSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VFab Samples',
    description: 'Copy-ready code examples.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic FAB',
        code: '''VFab(
  icon: Icon(Icons.add),
  onPressed: () {},
)''',
        preview: Row(
          children: [
            VFab(
              icon: const Text(
                '+',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Extended FAB',
        code: '''VFab.extended(
  icon: Icon(Icons.add),
  label: Text('New Item'),
  onPressed: () {},
)''',
        preview: Row(
          children: [
            VFab.extended(
              icon: const Text(
                '+',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              label: const Text('New Item'),
              onPressed: () {},
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Small FAB',
        code: '''VFab.small(
  icon: Icon(Icons.add),
  onPressed: () {},
)''',
        preview: Row(
          children: [
            VFab.small(
              icon: const Text(
                '+',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Large FAB',
        code: '''VFab.large(
  icon: Icon(Icons.add),
  onPressed: () {},
)''',
        preview: Row(
          children: [
            VFab.large(
              icon: const Text(
                '+',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Chat support button',
        code: '''VFab.extended(
  icon: Icon(Icons.chat),
  label: Text('Help'),
  onPressed: () => openChatSupport(),
  tooltip: 'Contact support',
)''',
        preview: Row(
          children: [
            VFab.extended(
              icon: const Text('\u{1F4AC}', style: TextStyle(fontSize: 18)),
              label: const Text('Help'),
              onPressed: () {},
              tooltip: 'Contact support',
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Speed dial',
        code: '''Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    VFab.small(icon: Icon(Icons.photo), onPressed: () {}),
    SizedBox(height: 12),
    VFab.small(icon: Icon(Icons.note_add), onPressed: () {}),
    SizedBox(height: 12),
    VFab(icon: Icon(Icons.add), onPressed: () {}),
  ],
)''',
        preview: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VFab.small(
                  icon: const Text('\u{1F4F7}', style: TextStyle(fontSize: 16)),
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                VFab.small(
                  icon: const Text('\u{1F4DD}', style: TextStyle(fontSize: 16)),
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                VFab(
                  icon: const Text(
                    '+',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Extended FAB',
        code: '''VFab.extended(
  icon: Icon(Icons.edit),
  label: Text('Compose'),
  onPressed: () {},
)''',
        preview: Row(
          children: [
            VFab.extended(
              icon: const Text('\u270E', style: TextStyle(fontSize: 16)),
              label: const Text('Compose'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    ],
  );
}
