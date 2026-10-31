import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _ButtonVariant { filled, outlined, text, ghost, icon, link }

WidgetbookComponent vButtonComponent() => WidgetbookComponent(
  name: 'VButton',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _buttonPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _ButtonShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _ButtonSample(),
    ),
  ],
);

Widget _buttonPlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_ButtonVariant>(
    label: 'variant',
    options: _ButtonVariant.values,
    labelBuilder: (v) => v.name,
  );
  final size = k.object.dropdown<VButtonSize>(
    label: 'size',
    options: VButtonSize.values,
    initialOption: VButtonSize.md,
    labelBuilder: (v) => v.name,
  );
  final color = k.object.dropdown<VButtonColor>(
    label: 'color',
    options: VButtonColor.values,
    labelBuilder: (v) => v.name,
  );
  final corner = k.object.dropdown<VButtonCorner>(
    label: 'corner',
    options: VButtonCorner.values,
    initialOption: VButtonCorner.rounded,
    labelBuilder: (v) => v.name,
  );
  final align = k.object.dropdown<VButtonAlign>(
    label: 'align',
    options: VButtonAlign.values,
    initialOption: VButtonAlign.center,
    labelBuilder: (v) => v.name,
  );
  final loadingPosition = k.object.dropdown<VButtonLoadingPosition>(
    label: 'loadingPosition',
    options: VButtonLoadingPosition.values,
    labelBuilder: (v) => v.name,
  );
  final label = k.string(label: 'child', initialValue: 'Button');
  final tooltip = k.string(label: 'tooltip');
  final semanticLabel = k.string(label: 'semanticLabel');
  final hasLeading = k.boolean(label: 'leading');
  final hasTrailing = k.boolean(label: 'trailing');
  final fullWidth = k.boolean(label: 'fullWidth');
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final loading = k.boolean(label: 'loading');
  final pressable = k.boolean(label: 'onPressed', initialValue: true);
  final longPressable = k.boolean(label: 'onLongPress');

  var presses = 0;
  return StatefulBuilder(
    builder: (context, setState) {
      const leadingIcon = Icon(IconData(0xe5ca, fontFamily: 'MaterialIcons'));
      const trailingIcon = Icon(IconData(0xe5cc, fontFamily: 'MaterialIcons'));
      final content = variant == _ButtonVariant.icon
          ? leadingIcon
          : Text(label);
      final onPressed = pressable ? () => setState(() => presses++) : null;
      final onLongPress = longPressable ? () {} : null;
      final leading = hasLeading ? leadingIcon : null;
      final trailing = hasTrailing ? trailingIcon : null;
      final tip = tooltip.isEmpty ? null : tooltip;
      final semantics = semanticLabel.isEmpty ? null : semanticLabel;

      return WidgetbookPlayground(
        info: ['presses: $presses'],
        child: SizedBox(
          width: fullWidth ? 320 : null,
          child: switch (variant) {
            _ButtonVariant.filled => VButton(
              onPressed: onPressed,
              onLongPress: onLongPress,
              leading: leading,
              trailing: trailing,
              color: color,
              size: size,
              corner: corner,
              align: align,
              fullWidth: fullWidth,
              enabled: enabled,
              loading: loading,
              loadingPosition: loadingPosition,
              tooltip: tip,
              semanticLabel: semantics,
              child: content,
            ),
            _ButtonVariant.outlined => VButton.outlined(
              onPressed: onPressed,
              onLongPress: onLongPress,
              leading: leading,
              trailing: trailing,
              color: color,
              size: size,
              corner: corner,
              align: align,
              fullWidth: fullWidth,
              enabled: enabled,
              loading: loading,
              loadingPosition: loadingPosition,
              tooltip: tip,
              semanticLabel: semantics,
              child: content,
            ),
            _ButtonVariant.text => VButton.text(
              onPressed: onPressed,
              onLongPress: onLongPress,
              leading: leading,
              trailing: trailing,
              color: color,
              size: size,
              corner: corner,
              align: align,
              fullWidth: fullWidth,
              enabled: enabled,
              loading: loading,
              loadingPosition: loadingPosition,
              tooltip: tip,
              semanticLabel: semantics,
              child: content,
            ),
            _ButtonVariant.ghost => VButton.ghost(
              onPressed: onPressed,
              onLongPress: onLongPress,
              leading: leading,
              trailing: trailing,
              color: color,
              size: size,
              corner: corner,
              align: align,
              fullWidth: fullWidth,
              enabled: enabled,
              loading: loading,
              loadingPosition: loadingPosition,
              tooltip: tip,
              semanticLabel: semantics,
              child: content,
            ),
            _ButtonVariant.icon => VButton.icon(
              onPressed: onPressed,
              onLongPress: onLongPress,
              color: color,
              size: size,
              corner: corner,
              align: align,
              enabled: enabled,
              loading: loading,
              loadingPosition: loadingPosition,
              tooltip: tip,
              semanticLabel: semantics,
              child: content,
            ),
            _ButtonVariant.link => VButton.link(
              onPressed: onPressed,
              onLongPress: onLongPress,
              leading: leading,
              trailing: trailing,
              color: color,
              size: size,
              corner: corner,
              align: align,
              fullWidth: fullWidth,
              enabled: enabled,
              loading: loading,
              loadingPosition: loadingPosition,
              tooltip: tip,
              semanticLabel: semantics,
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

class _ButtonShowcase extends StatelessWidget {
  const _ButtonShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VButton',
    description:
        'Triggers user actions such as form submissions, dialogs, and navigation.',
    children: [
      // Variants
      WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'filled',
            labels: const ['variant="filled"'],
            children: [
              VButton(onPressed: () {}, child: const Text('Filled')),
              VButton(
                onPressed: () {},
                color: VButtonColor.secondary,
                child: const Text('Secondary'),
              ),
              VButton(
                onPressed: () {},
                color: VButtonColor.destructive,
                child: const Text('Destructive'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'outlined',
            labels: const ['variant="outlined"'],
            children: [
              VButton.outlined(onPressed: () {}, child: const Text('Outlined')),
              VButton.outlined(
                onPressed: () {},
                color: VButtonColor.secondary,
                child: const Text('Secondary'),
              ),
              VButton.outlined(
                onPressed: () {},
                color: VButtonColor.destructive,
                child: const Text('Destructive'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'text',
            labels: const ['variant="text"'],
            children: [
              VButton.text(onPressed: () {}, child: const Text('Text')),
              VButton.text(
                onPressed: () {},
                color: VButtonColor.secondary,
                child: const Text('Secondary'),
              ),
              VButton.text(
                onPressed: () {},
                color: VButtonColor.destructive,
                child: const Text('Destructive'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'ghost',
            labels: const ['variant="ghost"'],
            children: [
              VButton.ghost(onPressed: () {}, child: const Text('Ghost')),
              VButton.ghost(
                onPressed: () {},
                color: VButtonColor.secondary,
                child: const Text('Secondary'),
              ),
              VButton.ghost(
                onPressed: () {},
                color: VButtonColor.destructive,
                child: const Text('Destructive'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'link',
            labels: const ['variant="link"'],
            children: [
              VButton.link(onPressed: () {}, child: const Text('Link')),
              VButton.link(
                onPressed: () {},
                color: VButtonColor.secondary,
                child: const Text('Secondary'),
              ),
              VButton.link(
                onPressed: () {},
                color: VButtonColor.destructive,
                child: const Text('Destructive'),
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
              VButton(
                onPressed: () {},
                size: VButtonSize.xs,
                child: const Text('Extra Small'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'sm',
            labels: const ['size="sm"'],
            children: [
              VButton(
                onPressed: () {},
                size: VButtonSize.sm,
                child: const Text('Small'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: const ['size="md"'],
            children: [VButton(onPressed: () {}, child: const Text('Medium'))],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: const ['size="lg"'],
            children: [
              VButton(
                onPressed: () {},
                size: VButtonSize.lg,
                child: const Text('Large'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'xl',
            labels: const ['size="xl"'],
            children: [
              VButton(
                onPressed: () {},
                size: VButtonSize.xl,
                child: const Text('Extra Large'),
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
            children: [VButton(onPressed: () {}, child: const Text('Primary'))],
          ),
          WidgetbookSubsection(
            title: 'secondary',
            labels: const ['color="secondary"'],
            children: [
              VButton(
                onPressed: () {},
                color: VButtonColor.secondary,
                child: const Text('Secondary'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'tertiary',
            labels: const ['color="tertiary"'],
            children: [
              VButton(
                onPressed: () {},
                color: VButtonColor.tertiary,
                child: const Text('Tertiary'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'destructive',
            labels: const ['color="destructive"'],
            children: [
              VButton(
                onPressed: () {},
                color: VButtonColor.destructive,
                child: const Text('Destructive'),
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
            children: [VButton(onPressed: () {}, child: const Text('Enabled'))],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: const ['disabled'],
            children: [
              VButton(
                onPressed: () {},
                enabled: false,
                child: const Text('Disabled'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'loading',
            labels: const ['loading'],
            children: [
              VButton(
                onPressed: () {},
                loading: true,
                child: const Text('Loading'),
              ),
            ],
          ),
        ],
      ),

      // Full Width
      WidgetbookSection(
        title: 'Full Width',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: const ['fullWidth={false}'],
            children: [
              VButton(onPressed: () {}, child: const Text('Default Width')),
            ],
          ),
          WidgetbookSubsection(
            title: 'full width',
            labels: const ['fullWidth'],
            fullWidth: true,
            children: [
              VButton(
                onPressed: () {},
                fullWidth: true,
                child: const Text('Full Width'),
              ),
            ],
          ),
        ],
      ),

      // With Icons
      WidgetbookSection(
        title: 'With Icons',
        children: [
          WidgetbookSubsection(
            title: 'start icon',
            labels: const ['leading: Icon'],
            children: [
              VButton(
                onPressed: () {},
                leading: const Text('+'),
                child: const Text('Add Item'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'end icon',
            labels: const ['trailing: Icon'],
            children: [
              VButton(
                onPressed: () {},
                trailing: const Text('\u2192'),
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),

      // Corners
      WidgetbookSection(
        title: 'Corners',
        children: [
          WidgetbookSubsection(
            title: 'square',
            labels: const ['corner="square"'],
            children: [
              VButton(
                onPressed: () {},
                corner: VButtonCorner.square,
                child: const Text('Square'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'rounded',
            labels: const ['corner="rounded"'],
            children: [VButton(onPressed: () {}, child: const Text('Rounded'))],
          ),
          WidgetbookSubsection(
            title: 'pill',
            labels: const ['corner="pill"'],
            children: [
              VButton(
                onPressed: () {},
                corner: VButtonCorner.pill,
                child: const Text('Pill'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'circle',
            labels: const ['corner="circle"'],
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: VButton(
                  onPressed: () {},
                  corner: VButtonCorner.circle,
                  child: const Text('+'),
                ),
              ),
            ],
          ),
        ],
      ),

      // Align
      WidgetbookSection(
        title: 'Align',
        children: [
          WidgetbookSubsection(
            title: 'left',
            labels: const ['align="left"'],
            fullWidth: true,
            children: [
              VButton(
                onPressed: () {},
                fullWidth: true,
                align: VButtonAlign.left,
                child: const Text('Left Align'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'center',
            labels: const ['align="center"'],
            fullWidth: true,
            children: [
              VButton(
                onPressed: () {},
                fullWidth: true,
                child: const Text('Center Align'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'right',
            labels: const ['align="right"'],
            fullWidth: true,
            children: [
              VButton(
                onPressed: () {},
                fullWidth: true,
                align: VButtonAlign.right,
                child: const Text('Right Align'),
              ),
            ],
          ),
        ],
      ),

      // Loading Position
      WidgetbookSection(
        title: 'Loading Position',
        children: [
          WidgetbookSubsection(
            title: 'center',
            labels: const ['loadingPosition="center"'],
            children: [
              VButton(
                onPressed: () {},
                loading: true,
                child: const Text('Center'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'start',
            labels: const ['loadingPosition="start"'],
            children: [
              VButton(
                onPressed: () {},
                loading: true,
                loadingPosition: VButtonLoadingPosition.start,
                child: const Text('Start'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'end',
            labels: const ['loadingPosition="end"'],
            children: [
              VButton(
                onPressed: () {},
                loading: true,
                loadingPosition: VButtonLoadingPosition.end,
                child: const Text('End'),
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
              'For user interactions such as form submission, action triggers, and navigation',
            ),
            _guidelineRow(
              theme,
              'Primary',
              'Use for one main CTA per screen (save, submit, confirm)',
            ),
            _guidelineRow(
              theme,
              'Secondary',
              'Use for secondary actions (cancel, go back)',
            ),
            _guidelineRow(
              theme,
              'Destructive',
              'Use only for irreversible actions such as delete or remove',
            ),
            _guidelineRow(
              theme,
              'Loading',
              'Provide feedback during async operations and prevent duplicate clicks',
            ),
            _guidelineRow(
              theme,
              'Disabled',
              'Use when conditions are not met; provide explanation for why it is disabled',
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

class _ButtonSample extends StatelessWidget {
  const _ButtonSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VButton Samples',
    description: 'Copy-paste code examples for common button patterns.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic usage',
        code: 'VButton(onPressed: () {}, child: Text("Save"))',
        preview: VButton(onPressed: () {}, child: const Text('Save')),
      ),
      WidgetbookCodeBlock(
        title: 'Outlined button',
        code: 'VButton.outlined(onPressed: () {}, child: Text("Cancel"))',
        preview: VButton.outlined(
          onPressed: () {},
          child: const Text('Cancel'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Destructive action',
        code:
            'VButton(onPressed: () {}, color: VButtonColor.destructive, child: Text("Delete"))',
        preview: VButton(
          onPressed: () {},
          color: VButtonColor.destructive,
          child: const Text('Delete'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Button with icon',
        code: '''VButton(
  onPressed: () {},
  leading: Icon(Icons.download),
  trailing: Icon(Icons.arrow_forward),
  child: Text('Download'),
)''',
        preview: VButton(
          onPressed: () {},
          leading: const Text('\u2B07'),
          trailing: const Text('\u2192'),
          child: const Text('Download'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Loading state',
        code: '''VButton(
  onPressed: () {},
  loading: true,
  loadingPosition: VButtonLoadingPosition.start,
  child: Text('Saving...'),
)''',
        preview: VButton(
          onPressed: () {},
          loading: true,
          loadingPosition: VButtonLoadingPosition.start,
          child: const Text('Saving...'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Full width',
        code: '''VButton(
  onPressed: () {},
  fullWidth: true,
  child: Text('Continue'),
)''',
        preview: VButton(
          onPressed: () {},
          fullWidth: true,
          child: const Text('Continue'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Submit form button',
        code: '''Column(
  children: [
    VButton(
      onPressed: () {},
      fullWidth: true,
      child: Text('Submit'),
    ),
    SizedBox(height: 8),
    VButton.text(
      onPressed: () {},
      fullWidth: true,
      child: Text('Cancel'),
    ),
  ],
)''',
        preview: Column(
          children: [
            VButton(
              onPressed: () {},
              fullWidth: true,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 8),
            VButton.text(
              onPressed: () {},
              fullWidth: true,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Icon-only toolbar',
        code: '''Row(
  children: [
    VButton.icon(onPressed: () {}, child: Icon(Icons.format_bold)),
    SizedBox(width: 4),
    VButton.icon(onPressed: () {}, child: Icon(Icons.format_italic)),
    SizedBox(width: 4),
    VButton.icon(onPressed: () {}, child: Icon(Icons.format_underline)),
  ],
)''',
        preview: Row(
          children: [
            VButton.icon(
              onPressed: () {},
              child: const Text(
                'B',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 4),
            VButton.icon(
              onPressed: () {},
              child: const Text(
                'I',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(width: 4),
            VButton.icon(
              onPressed: () {},
              child: const Text(
                'U',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Action toolbar',
        code: '''Row(
  children: [
    VButton.ghost(
      onPressed: () {},
      corner: VButtonCorner.circle,
      child: Icon(Icons.edit),
    ),
    SizedBox(width: 4),
    VButton.ghost(
      onPressed: () {},
      corner: VButtonCorner.circle,
      child: Icon(Icons.copy),
    ),
    SizedBox(width: 4),
    VButton.ghost(
      onPressed: () {},
      corner: VButtonCorner.circle,
      color: VButtonColor.destructive,
      child: Icon(Icons.delete),
    ),
  ],
)''',
        preview: Row(
          children: [
            VButton.ghost(
              onPressed: () {},
              corner: VButtonCorner.circle,
              child: const Text('\u270E'),
            ),
            const SizedBox(width: 4),
            VButton.ghost(
              onPressed: () {},
              corner: VButtonCorner.circle,
              child: const Text('\u2398'),
            ),
            const SizedBox(width: 4),
            VButton.ghost(
              onPressed: () {},
              corner: VButtonCorner.circle,
              color: VButtonColor.destructive,
              child: const Text('\u2716'),
            ),
          ],
        ),
      ),
    ],
  );
}
