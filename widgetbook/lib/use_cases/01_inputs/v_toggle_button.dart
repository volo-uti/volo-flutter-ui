import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vToggleButtonComponent() => WidgetbookComponent(
  name: 'VToggleButton',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _toggleButtonPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _ToggleButtonShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _ToggleButtonSample(),
    ),
  ],
);

Widget _toggleButtonPlayground(BuildContext context) {
  final k = context.knobs;
  final grouped = k.boolean(label: 'group');
  final type = k.object.dropdown<VToggleButtonType>(
    label: 'type',
    options: VToggleButtonType.values,
    initialOption: VToggleButtonType.ghost,
    labelBuilder: (v) => v.name,
  );
  final size = k.object.dropdown<VToggleButtonSize>(
    label: 'size',
    options: VToggleButtonSize.values,
    initialOption: VToggleButtonSize.md,
    labelBuilder: (v) => v.name,
  );
  final label = k.string(label: 'label', initialValue: 'Bold');
  var on = k.boolean(label: 'value');
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final allowMultiple = k.boolean(label: 'allowMultiple');
  final allowEmpty = k.boolean(label: 'allowEmpty', initialValue: true);
  final fullWidth = k.boolean(label: 'fullWidth');
  String? one = 'b';
  var many = <String>['b'];

  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      info: [
        if (!grouped)
          'value: $on'
        else if (allowMultiple)
          'values: ${many.join(', ')}'
        else
          'value: $one',
      ],
      child: grouped
          ? SizedBox(
              width: 360,
              child: VToggleButtonGroup<String>(
                items: [
                  for (final id in const ['a', 'b', 'c'])
                    VToggleButtonItem(
                      value: id,
                      label: Text('$label ${id.toUpperCase()}'),
                      enabled: enabled,
                    ),
                ],
                value: one,
                values: many,
                onChanged: (v) => setState(() => one = v),
                onValuesChanged: (v) => setState(() => many = v),
                allowMultiple: allowMultiple,
                allowEmpty: allowEmpty,
                type: type,
                size: size,
                fullWidth: fullWidth,
              ),
            )
          : VToggleButton(
              isSelected: on,
              onChanged: (v) => setState(() => on = v),
              enabled: enabled,
              type: type,
              size: size,
              child: Text(label),
            ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _ToggleButtonShowcase extends StatelessWidget {
  const _ToggleButtonShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VToggleButton',
    description:
        'A toggle button that visually indicates selection state. '
        'Use VToggleButtonGroup for managing multiple toggle buttons.',
    children: [
      // Types
      const WidgetbookSection(
        title: 'Types',
        children: [
          WidgetbookSubsection(
            title: 'ghost',
            labels: ['type="ghost"'],
            children: [_ToggleButtonDemo(label: 'Ghost')],
          ),
          WidgetbookSubsection(
            title: 'filled',
            labels: ['type="filled"'],
            children: [
              _ToggleButtonDemo(
                type: VToggleButtonType.filled,
                label: 'Filled',
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'outlined',
            labels: ['type="outlined"'],
            children: [
              _ToggleButtonDemo(
                type: VToggleButtonType.outlined,
                label: 'Outlined',
              ),
            ],
          ),
        ],
      ),

      // Sizes
      const WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'xs',
            labels: ['size="xs"'],
            children: [
              _ToggleButtonDemo(
                size: VToggleButtonSize.xs,
                label: 'Extra Small',
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'sm',
            labels: ['size="sm"'],
            children: [
              _ToggleButtonDemo(size: VToggleButtonSize.sm, label: 'Small'),
            ],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: ['size="md"'],
            children: [_ToggleButtonDemo(label: 'Medium')],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: ['size="lg"'],
            children: [
              _ToggleButtonDemo(size: VToggleButtonSize.lg, label: 'Large'),
            ],
          ),
          WidgetbookSubsection(
            title: 'xl',
            labels: ['size="xl"'],
            children: [
              _ToggleButtonDemo(
                size: VToggleButtonSize.xl,
                label: 'Extra Large',
              ),
            ],
          ),
        ],
      ),

      // States
      const WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'unselected',
            labels: ['selected={false}'],
            children: [_ToggleButtonDemo(label: 'Unselected')],
          ),
          WidgetbookSubsection(
            title: 'selected',
            labels: ['selected'],
            children: [
              _ToggleButtonDemo(initialSelected: true, label: 'Selected'),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: ['disabled'],
            children: [
              VToggleButton(
                isSelected: false,
                enabled: false,
                child: Text('Disabled'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled + selected',
            labels: ['disabled', 'selected'],
            children: [
              VToggleButton(
                isSelected: true,
                enabled: false,
                child: Text('Disabled'),
              ),
            ],
          ),
        ],
      ),

      // Toggle Button Group
      const WidgetbookSection(
        title: 'VToggleButtonGroup',
        children: [
          WidgetbookSubsection(
            title: 'single selection',
            labels: ['VToggleButtonGroup'],
            children: [_ToggleGroupSingleDemo()],
          ),
          WidgetbookSubsection(
            title: 'multiple selection',
            labels: ['allowMultiple'],
            children: [_ToggleGroupMultiDemo()],
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
              'For toggling visual state on/off (e.g., text formatting, view modes)',
            ),
            _guidelineRow(
              theme,
              'vs Checkbox',
              'Use toggle button for toolbar-like actions, checkbox for form data',
            ),
            _guidelineRow(
              theme,
              'Group',
              'Use VToggleButtonGroup for mutually exclusive or multi-select groups',
            ),
            _guidelineRow(
              theme,
              'Icons',
              'Prefer icon-only toggle buttons for compact toolbars',
            ),
            _guidelineRow(
              theme,
              'Disabled',
              'Show disabled state when the option is temporarily unavailable',
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

class _ToggleButtonSample extends StatelessWidget {
  const _ToggleButtonSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VToggleButton Samples',
    description: 'Copy-paste code examples for common toggle button patterns.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic toggle',
        code: '''VToggleButton(
  isSelected: isBold,
  onChanged: (value) => setState(() => isBold = value),
  child: Text('B'),
)''',
        preview: _ToggleButtonDemo(label: 'B'),
      ),
      WidgetbookCodeBlock(
        title: 'Outlined toggle',
        code: '''VToggleButton(
  isSelected: isActive,
  type: VToggleButtonType.outlined,
  onChanged: (value) => setState(() => isActive = value),
  child: Text('Active'),
)''',
        preview: _ToggleButtonDemo(
          type: VToggleButtonType.outlined,
          label: 'Active',
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Toggle button group (single)',
        code: '''VToggleButtonGroup<String>(
  value: selectedView,
  items: [
    VToggleButtonItem(value: 'grid', label: Text('Grid')),
    VToggleButtonItem(value: 'list', label: Text('List')),
    VToggleButtonItem(value: 'table', label: Text('Table')),
  ],
  onChanged: (value) => setState(() => selectedView = value),
)''',
        preview: _ToggleGroupSingleDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Toggle button group (multiple)',
        code: '''VToggleButtonGroup<String>(
  values: selectedFormats,
  allowMultiple: true,
  items: [
    VToggleButtonItem(value: 'bold', label: Text('B')),
    VToggleButtonItem(value: 'italic', label: Text('I')),
    VToggleButtonItem(value: 'underline', label: Text('U')),
  ],
  onValuesChanged: (values) => setState(() => selectedFormats = values),
)''',
        preview: _ToggleGroupMultiDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Controlled toggle',
        code: '''VToggleButton(
  isSelected: isActive,
  onChanged: (value) => setState(() => isActive = value),
  type: VToggleButtonType.filled,
  child: Text('Active'),
)''',
        preview: _ToggleButtonDemo(
          type: VToggleButtonType.filled,
          label: 'Active',
        ),
      ),
      WidgetbookCodeBlock(
        title: 'View mode selector',
        code: '''VToggleButtonGroup<String>(
  value: viewMode,
  items: [
    VToggleButtonItem(value: 'grid', label: Text('Grid')),
    VToggleButtonItem(value: 'list', label: Text('List')),
  ],
  onChanged: (value) => setState(() => viewMode = value),
)''',
        preview: _ToggleGroupSingleDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Text formatting toolbar',
        code: '''VToggleButtonGroup<String>(
  values: formatting,
  allowMultiple: true,
  type: VToggleButtonType.outlined,
  items: [
    VToggleButtonItem(value: 'bold', label: Text('B')),
    VToggleButtonItem(value: 'italic', label: Text('I')),
    VToggleButtonItem(value: 'underline', label: Text('U')),
  ],
  onValuesChanged: (values) => setState(() => formatting = values),
)''',
        preview: _ToggleGroupMultiDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Full width toggle group',
        code: '''VToggleButtonGroup<String>(
  value: alignment,
  fullWidth: true,
  items: [
    VToggleButtonItem(value: 'left', label: Text('Left')),
    VToggleButtonItem(value: 'center', label: Text('Center')),
    VToggleButtonItem(value: 'right', label: Text('Right')),
  ],
  onChanged: (value) => setState(() => alignment = value),
)''',
        preview: _ToggleGroupSingleDemo(),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _ToggleButtonDemo extends StatefulWidget {
  const _ToggleButtonDemo({
    this.type = VToggleButtonType.ghost,
    this.size,
    this.label = 'Toggle',
    // ignore: avoid_positional_boolean_parameters
    this.initialSelected = false,
  });

  final VToggleButtonType type;
  final VToggleButtonSize? size;
  final String label;
  final bool initialSelected;

  @override
  State<_ToggleButtonDemo> createState() => _ToggleButtonDemoState();
}

class _ToggleButtonDemoState extends State<_ToggleButtonDemo> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) => VToggleButton(
    isSelected: _selected,
    type: widget.type,
    size: widget.size,
    onChanged: (value) => setState(() => _selected = value),
    child: Text(widget.label),
  );
}

class _ToggleGroupSingleDemo extends StatefulWidget {
  const _ToggleGroupSingleDemo();

  @override
  State<_ToggleGroupSingleDemo> createState() => _ToggleGroupSingleDemoState();
}

class _ToggleGroupSingleDemoState extends State<_ToggleGroupSingleDemo> {
  String? _value = 'grid';

  @override
  Widget build(BuildContext context) => VToggleButtonGroup<String>(
    value: _value,
    items: const [
      VToggleButtonItem(value: 'grid', label: Text('Grid')),
      VToggleButtonItem(value: 'list', label: Text('List')),
      VToggleButtonItem(value: 'table', label: Text('Table')),
    ],
    onChanged: (value) => setState(() => _value = value),
  );
}

class _ToggleGroupMultiDemo extends StatefulWidget {
  const _ToggleGroupMultiDemo();

  @override
  State<_ToggleGroupMultiDemo> createState() => _ToggleGroupMultiDemoState();
}

class _ToggleGroupMultiDemoState extends State<_ToggleGroupMultiDemo> {
  List<String> _values = ['bold'];

  @override
  Widget build(BuildContext context) => VToggleButtonGroup<String>(
    values: _values,
    allowMultiple: true,
    items: const [
      VToggleButtonItem(value: 'bold', label: Text('B')),
      VToggleButtonItem(value: 'italic', label: Text('I')),
      VToggleButtonItem(value: 'underline', label: Text('U')),
    ],
    onValuesChanged: (values) => setState(() => _values = values),
  );
}
