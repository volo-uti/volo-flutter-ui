import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vIconButtonComponent() => WidgetbookComponent(
  name: 'VIconButton',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _iconButtonPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _IconButtonShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _IconButtonSample(),
    ),
  ],
);

enum _IconButtonVariant { standard, filled, outlined, filledTonal }

Widget _iconButtonPlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_IconButtonVariant>(
    label: 'variant',
    options: _IconButtonVariant.values,
    labelBuilder: (v) => v.name,
  );
  final size = k.object.dropdown<VIconButtonSize>(
    label: 'size',
    options: VIconButtonSize.values,
    initialOption: VIconButtonSize.md,
    labelBuilder: (v) => v.name,
  );
  final color = k.object.dropdown<VButtonColor>(
    label: 'color',
    options: VButtonColor.values,
    labelBuilder: (v) => v.name,
  );
  final toggle = k.boolean(label: 'toggle');
  var selected = k.boolean(label: 'isSelected');
  final tooltip = k.string(label: 'tooltip', initialValue: 'Favorite');
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final loading = k.boolean(label: 'loading');
  final pressable = k.boolean(label: 'onPressed', initialValue: true);

  return StatefulBuilder(
    builder: (context, setState) {
      const icon = Icon(IconData(0xe87e, fontFamily: 'MaterialIcons'));
      const selectedIcon = Icon(IconData(0xe87d, fontFamily: 'MaterialIcons'));
      final onPressed = pressable
          ? () => setState(() => selected = !selected)
          : null;
      final isSelected = toggle ? selected : null;
      final tip = tooltip.isEmpty ? null : tooltip;

      return WidgetbookPlayground(
        info: ['isSelected: $isSelected'],
        child: switch (variant) {
          _IconButtonVariant.standard => VIconButton(
            icon: icon,
            selectedIcon: selectedIcon,
            isSelected: isSelected,
            onPressed: onPressed,
            tooltip: tip,
            size: size,
            color: color,
            loading: loading,
            enabled: enabled,
          ),
          _IconButtonVariant.filled => VIconButton.filled(
            icon: icon,
            selectedIcon: selectedIcon,
            isSelected: isSelected,
            onPressed: onPressed,
            tooltip: tip,
            size: size,
            color: color,
            loading: loading,
            enabled: enabled,
          ),
          _IconButtonVariant.outlined => VIconButton.outlined(
            icon: icon,
            selectedIcon: selectedIcon,
            isSelected: isSelected,
            onPressed: onPressed,
            tooltip: tip,
            size: size,
            color: color,
            loading: loading,
            enabled: enabled,
          ),
          _IconButtonVariant.filledTonal => VIconButton.filledTonal(
            icon: icon,
            selectedIcon: selectedIcon,
            isSelected: isSelected,
            onPressed: onPressed,
            tooltip: tip,
            size: size,
            color: color,
            loading: loading,
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

class _IconButtonShowcase extends StatelessWidget {
  const _IconButtonShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VIconButton',
    description: 'A button component that displays only an icon.',
    children: [
      // Variants
      WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'standard',
            labels: const ['variant="default"'],
            children: [
              VIconButton(
                icon: const Text('\u2605', style: TextStyle(fontSize: 20)),
                onPressed: () {},
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'filled',
            labels: const ['variant="filled"'],
            children: [
              VIconButton.filled(
                icon: const Text('\u2605', style: TextStyle(fontSize: 20)),
                onPressed: () {},
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'outlined',
            labels: const ['variant="outlined"'],
            children: [
              VIconButton.outlined(
                icon: const Text('\u2605', style: TextStyle(fontSize: 20)),
                onPressed: () {},
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'filledTonal',
            labels: const ['variant="filledTonal"'],
            children: [
              VIconButton.filledTonal(
                icon: const Text('\u2605', style: TextStyle(fontSize: 20)),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),

      // Sizes
      WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'xs',
            labels: const ['size="xs"'],
            children: [
              VIconButton.filled(
                icon: const Text('\u2605'),
                onPressed: () {},
                size: VIconButtonSize.xs,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'sm',
            labels: const ['size="sm"'],
            children: [
              VIconButton.filled(
                icon: const Text('\u2605'),
                onPressed: () {},
                size: VIconButtonSize.sm,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: const ['size="md"'],
            children: [
              VIconButton.filled(icon: const Text('\u2605'), onPressed: () {}),
            ],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: const ['size="lg"'],
            children: [
              VIconButton.filled(
                icon: const Text('\u2605'),
                onPressed: () {},
                size: VIconButtonSize.lg,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'xl',
            labels: const ['size="xl"'],
            children: [
              VIconButton.filled(
                icon: const Text('\u2605'),
                onPressed: () {},
                size: VIconButtonSize.xl,
              ),
            ],
          ),
        ],
      ),

      // Colors
      WidgetbookSection(
        title: 'Colors',
        children: [
          WidgetbookSubsection(
            title: 'primary',
            labels: const ['color="primary"'],
            children: [
              VIconButton.filled(icon: const Text('\u2605'), onPressed: () {}),
            ],
          ),
          WidgetbookSubsection(
            title: 'secondary',
            labels: const ['color="secondary"'],
            children: [
              VIconButton.filled(
                icon: const Text('\u2605'),
                onPressed: () {},
                color: VButtonColor.secondary,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'tertiary',
            labels: const ['color="tertiary"'],
            children: [
              VIconButton.filled(
                icon: const Text('\u2605'),
                onPressed: () {},
                color: VButtonColor.tertiary,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'destructive',
            labels: const ['color="destructive"'],
            children: [
              VIconButton.filled(
                icon: const Text('\u2605'),
                onPressed: () {},
                color: VButtonColor.destructive,
              ),
            ],
          ),
        ],
      ),

      // States
      WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: const ['disabled={false}'],
            children: [
              VIconButton.filled(
                icon: const Text('\u2605', style: TextStyle(fontSize: 20)),
                onPressed: () {},
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: const ['disabled'],
            children: [
              VIconButton.filled(
                icon: const Text('\u2605', style: TextStyle(fontSize: 20)),
                onPressed: () {},
                enabled: false,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'loading',
            labels: const ['loading'],
            children: [
              VIconButton.filled(
                icon: const Text('\u2605', style: TextStyle(fontSize: 20)),
                onPressed: () {},
                loading: true,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'selected',
            labels: const ['selected'],
            children: [
              VIconButton.filled(
                icon: const Text('\u2605', style: TextStyle(fontSize: 20)),
                onPressed: () {},
                isSelected: true,
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
              'When an icon-only button is needed (space saving, visual simplicity)',
            ),
            _guidelineRow(
              theme,
              'Toolbar',
              'Suitable for toolbars, action bars, and navigation bars',
            ),
            _guidelineRow(
              theme,
              'Accessibility',
              'Always provide aria-label for accessibility',
            ),
            _guidelineRow(
              theme,
              'Toggle',
              'Use selected property to implement toggle buttons (favorite, like)',
            ),
            _guidelineRow(
              theme,
              'Size',
              'Recommend minimum 48x48dp touch target (mobile accessibility)',
            ),
            _guidelineRow(
              theme,
              'Variant',
              'Filled for emphasis, outlined for secondary, standard for blending with background',
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

class _IconButtonSample extends StatelessWidget {
  const _IconButtonSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VIconButton Samples',
    description: 'Copy-paste code examples for common icon button patterns.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic Usage',
        code: '''VIconButton(
  icon: Icon(Icons.favorite),
  onPressed: () {},
)''',
        preview: Row(
          children: [
            VIconButton(
              icon: const Text('\u2605', style: TextStyle(fontSize: 20)),
              onPressed: () {},
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Filled Button',
        code: '''VIconButton.filled(
  icon: Icon(Icons.add),
  onPressed: () {},
)''',
        preview: Row(
          children: [
            VIconButton.filled(
              icon: const Text('\u2605', style: TextStyle(fontSize: 20)),
              onPressed: () {},
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Outlined Button',
        code: '''VIconButton.outlined(
  icon: Icon(Icons.edit),
  onPressed: () {},
)''',
        preview: Row(
          children: [
            VIconButton.outlined(
              icon: const Text('\u2605', style: TextStyle(fontSize: 20)),
              onPressed: () {},
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Toggle Button (Selected State)',
        code: '''VIconButton.filledTonal(
  icon: Icon(Icons.bookmark),
  onPressed: () {},
  isSelected: true,
)''',
        preview: Row(
          children: [
            VIconButton.filledTonal(
              icon: const Text('\u2605', style: TextStyle(fontSize: 20)),
              onPressed: () {},
              isSelected: true,
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Toolbar actions',
        code: '''Row(
  children: [
    VIconButton(icon: Icon(Icons.content_copy), onPressed: () {}),
    SizedBox(width: 4),
    VIconButton(icon: Icon(Icons.content_paste), onPressed: () {}),
    SizedBox(width: 4),
    VIconButton(
      icon: Icon(Icons.delete),
      onPressed: () {},
      color: VButtonColor.destructive,
    ),
  ],
)''',
        preview: Row(
          children: [
            VIconButton(
              icon: const Text('\u2398', style: TextStyle(fontSize: 20)),
              onPressed: () {},
            ),
            const SizedBox(width: 4),
            VIconButton(
              icon: const Text('\u2399', style: TextStyle(fontSize: 20)),
              onPressed: () {},
            ),
            const SizedBox(width: 4),
            VIconButton(
              icon: const Text('\u2716', style: TextStyle(fontSize: 20)),
              onPressed: () {},
              color: VButtonColor.destructive,
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'With tooltip',
        code: '''VIconButton.filled(
  icon: Icon(Icons.settings),
  onPressed: () {},
  tooltip: 'Settings',
)''',
        preview: Row(
          children: [
            VIconButton.filled(
              icon: const Text('\u2699', style: TextStyle(fontSize: 20)),
              onPressed: () {},
              tooltip: 'Settings',
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Loading icon button',
        code: '''VIconButton.filled(
  icon: Icon(Icons.refresh),
  onPressed: () {},
  loading: true,
)''',
        preview: Row(
          children: [
            VIconButton.filled(
              icon: const Text('\u21BB', style: TextStyle(fontSize: 20)),
              onPressed: () {},
              loading: true,
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Disabled states',
        code: '''Row(
  children: [
    VIconButton.filled(
      icon: Icon(Icons.edit),
      onPressed: () {},
      enabled: false,
    ),
    SizedBox(width: 8),
    VIconButton.outlined(
      icon: Icon(Icons.delete),
      onPressed: () {},
      enabled: false,
      color: VButtonColor.destructive,
    ),
  ],
)''',
        preview: Row(
          children: [
            VIconButton.filled(
              icon: const Text('\u270E', style: TextStyle(fontSize: 20)),
              onPressed: () {},
              enabled: false,
            ),
            const SizedBox(width: 8),
            VIconButton.outlined(
              icon: const Text('\u2716', style: TextStyle(fontSize: 20)),
              onPressed: () {},
              enabled: false,
              color: VButtonColor.destructive,
            ),
          ],
        ),
      ),
    ],
  );
}
