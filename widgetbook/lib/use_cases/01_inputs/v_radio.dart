import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vRadioComponent() => WidgetbookComponent(
  name: 'VRadio',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _radioPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _RadioShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _RadioSample(),
    ),
  ],
);

Widget _radioPlayground(BuildContext context) {
  final k = context.knobs;
  final grouped = k.boolean(label: 'group');
  final size = k.object.dropdown<VWidgetSize>(
    label: 'size',
    options: VWidgetSize.values,
    initialOption: VWidgetSize.md,
    labelBuilder: (v) => v.name,
  );
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final label = k.string(label: 'label', initialValue: 'Option');
  final sublabel = k.string(label: 'sublabel');
  final orientation = k.object.dropdown<Axis>(
    label: 'orientation',
    options: Axis.values,
    initialOption: Axis.vertical,
    labelBuilder: (v) => v.name,
  );
  var groupValue = k.object.dropdown<String?>(
    label: 'groupValue',
    options: const ['a', 'b', 'c', null],
    initialOption: 'a',
    labelBuilder: (v) => v ?? 'none',
  );

  Widget? sub() => sublabel.isEmpty ? null : Text(sublabel);

  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      info: ['groupValue: $groupValue'],
      child: grouped
          ? SizedBox(
              width: 300,
              child: VRadio<String>.group(
                options: [
                  for (final id in const ['a', 'b', 'c'])
                    VRadioItem(
                      value: id,
                      label: Text('$label ${id.toUpperCase()}'),
                      sublabel: sub(),
                    ),
                ],
                groupValue: groupValue,
                onChanged: (v) => setState(() => groupValue = v),
                orientation: orientation,
                size: size,
                enabled: enabled,
              ),
            )
          : VRadio<String>(
              value: 'a',
              groupValue: groupValue,
              onChanged: (v) => setState(() => groupValue = v),
              label: Text(label),
              sublabel: sub(),
              enabled: enabled,
              size: size,
            ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _RadioShowcase extends StatelessWidget {
  const _RadioShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VRadio',
    description: 'Select a single option from a mutually exclusive set.',
    children: [
      const WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'sm',
            labels: ['size="sm"'],
            children: [_RadioSizeDemo(label: 'Small', size: VWidgetSize.sm)],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: ['size="md"'],
            children: [_RadioSizeDemo(label: 'Medium')],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: ['size="lg"'],
            children: [_RadioSizeDemo(label: 'Large', size: VWidgetSize.lg)],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Orientation',
        children: [
          WidgetbookSubsection(
            title: 'vertical',
            labels: ['orientation="vertical"'],
            children: [_RadioOrientationDemo(direction: Axis.vertical)],
          ),
          WidgetbookSubsection(
            title: 'horizontal',
            labels: ['orientation="horizontal"'],
            children: [_RadioOrientationDemo(direction: Axis.horizontal)],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: ['default'],
            children: [_RadioDemo()],
          ),
          WidgetbookSubsection(
            title: 'disabled group',
            labels: ['disabled'],
            children: [
              VStack.vertical(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VRadio<String>(
                    value: 'a',
                    groupValue: 'a',
                    label: Text('Disabled A'),
                    enabled: false,
                  ),
                  VRadio<String>(
                    value: 'b',
                    groupValue: 'a',
                    label: Text('Disabled B'),
                    enabled: false,
                  ),
                ],
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled item',
            labels: ['VRadio disabled'],
            children: [
              VStack.vertical(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VRadio<String>(
                    value: 'a',
                    groupValue: 'a',
                    label: Text('Enabled'),
                  ),
                  VRadio<String>(
                    value: 'b',
                    groupValue: 'a',
                    label: Text('Disabled Item'),
                    enabled: false,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Group mode
      const WidgetbookSection(
        title: 'Group Mode (VRadio.group)',
        children: [
          WidgetbookSubsection(
            title: 'vertical',
            labels: ['VRadio.group', 'orientation="vertical"'],
            children: [_RadioGroupModeDemo()],
          ),
          WidgetbookSubsection(
            title: 'horizontal',
            labels: ['VRadio.group', 'orientation="horizontal"'],
            children: [_RadioGroupModeDemo(orientation: Axis.horizontal)],
          ),
          WidgetbookSubsection(
            title: 'with disabled item',
            labels: ['VRadio.group', 'VRadioItem.disabled'],
            children: [_RadioGroupWithDisabledItemDemo()],
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
              'Mutually exclusive choices: payment method, shipping speed, plan selection',
            ),
            _guidelineRow(
              theme,
              'vs Select',
              'Use radio for 2-5 options visible at once. Use select for 6+ or limited space',
            ),
            _guidelineRow(
              theme,
              'Default',
              'Pre-select the most common option. Avoid empty state if possible',
            ),
            _guidelineRow(
              theme,
              'Label',
              'Each radio must have a clear, concise label. Group needs a title/heading',
            ),
            _guidelineRow(
              theme,
              'Orientation',
              'Vertical for readability. Horizontal only for 2-3 short options',
            ),
            _guidelineRow(
              theme,
              'Disabled',
              'Disable individual items for unavailable options (e.g., out of stock)',
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

class _RadioSample extends StatelessWidget {
  const _RadioSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VRadio Samples',
    description: 'Copy-paste code examples for common radio group patterns.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic radio group',
        code: '''Column(
  children: [
    VRadio<String>(
      value: 'email',
      groupValue: selectedValue,
      onChanged: (v) => setState(() => selectedValue = v),
      label: Text('Email'),
    ),
    VRadio<String>(
      value: 'sms',
      groupValue: selectedValue,
      onChanged: (v) => setState(() => selectedValue = v),
      label: Text('SMS'),
    ),
    VRadio<String>(
      value: 'push',
      groupValue: selectedValue,
      onChanged: (v) => setState(() => selectedValue = v),
      label: Text('Push Notification'),
    ),
  ],
)''',
        preview: _RadioGroupDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Horizontal layout',
        code: '''Row(
  children: [
    VRadio<String>(
      value: 'left',
      groupValue: selectedValue,
      onChanged: (v) => setState(() => selectedValue = v),
      label: Text('Left'),
    ),
    VRadio<String>(
      value: 'center',
      groupValue: selectedValue,
      onChanged: (v) => setState(() => selectedValue = v),
      label: Text('Center'),
    ),
    VRadio<String>(
      value: 'right',
      groupValue: selectedValue,
      onChanged: (v) => setState(() => selectedValue = v),
      label: Text('Right'),
    ),
  ],
)''',
        preview: _RadioOrientationDemo(direction: Axis.horizontal),
      ),
      WidgetbookCodeBlock(
        title: 'Controlled',
        code: '''Column(
  children: [
    VRadio<String>(
      value: 'monthly',
      groupValue: selectedValue,
      onChanged: (v) => setState(() => selectedValue = v),
      label: Text('Monthly'),
    ),
    VRadio<String>(
      value: 'yearly',
      groupValue: selectedValue,
      onChanged: (v) => setState(() => selectedValue = v),
      label: Text('Yearly'),
    ),
  ],
)''',
        preview: _RadioDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'With disabled option',
        code: '''Column(
  children: [
    VRadio<String>(
      value: 'standard',
      groupValue: selectedValue,
      onChanged: (v) => setState(() => selectedValue = v),
      label: Text('Standard'),
    ),
    VRadio<String>(
      value: 'express',
      groupValue: selectedValue,
      onChanged: (v) => setState(() => selectedValue = v),
      label: Text('Express'),
    ),
    VRadio<String>(
      value: 'overnight',
      groupValue: selectedValue,
      label: Text('Overnight'),
      enabled: false,
    ),
  ],
)''',
        preview: _RadioWithDisabledDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'VRadio.group (simplified)',
        code: '''VRadio<String>.group(
  options: [
    VRadioItem(value: 'email', label: Text('Email')),
    VRadioItem(value: 'sms', label: Text('SMS')),
    VRadioItem(value: 'push', label: Text('Push Notification')),
  ],
  groupValue: selectedValue,
  onChanged: (v) => setState(() => selectedValue = v),
)''',
        preview: _RadioGroupModeDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'VRadio.group horizontal',
        code: '''VRadio<String>.group(
  options: [
    VRadioItem(value: 'left', label: Text('Left')),
    VRadioItem(value: 'center', label: Text('Center')),
    VRadioItem(value: 'right', label: Text('Right')),
  ],
  groupValue: selectedValue,
  onChanged: (v) => setState(() => selectedValue = v),
  orientation: Axis.horizontal,
)''',
        preview: _RadioGroupModeDemo(orientation: Axis.horizontal),
      ),
      WidgetbookCodeBlock(
        title: 'Payment Method Form (VForm)',
        code: '''VForm(
  formKey: formKey,
  children: [
    VRadio<String>(
      value: 'card',
      groupValue: selected,
      onChanged: (v) => setState(() => selected = v),
      label: Text('Credit Card'),
    ),
    VRadio<String>(
      value: 'bank',
      groupValue: selected,
      onChanged: (v) => setState(() => selected = v),
      label: Text('Bank Transfer'),
    ),
    VRadio<String>(
      value: 'paypal',
      groupValue: selected,
      onChanged: (v) => setState(() => selected = v),
      label: Text('PayPal'),
    ),
    VButton(
      onPressed: () {},
      child: Text('Continue'),
    ),
  ],
)''',
        preview: _PaymentMethodFormDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'VRadio.group with sublabels',
        code: r'''VRadio<String>.group(
  options: [
    VRadioItem(value: 'free', label: Text('Free'), sublabel: Text('0 / month')),
    VRadioItem(value: 'pro', label: Text('Pro'), sublabel: Text('$9.99 / month')),
    VRadioItem(value: 'enterprise', label: Text('Enterprise'), sublabel: Text('Contact us')),
  ],
  groupValue: selectedPlan,
  onChanged: (v) => setState(() => selectedPlan = v),
)''',
        preview: _RadioGroupWithSublabelsDemo(),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _PaymentMethodFormDemo extends StatefulWidget {
  const _PaymentMethodFormDemo();

  @override
  State<_PaymentMethodFormDemo> createState() => _PaymentMethodFormDemoState();
}

class _PaymentMethodFormDemoState extends State<_PaymentMethodFormDemo> {
  String? _selected = 'card';

  @override
  Widget build(BuildContext context) => VForm(
    children: [
      VRadio<String>(
        value: 'card',
        groupValue: _selected,
        onChanged: (v) => setState(() => _selected = v),
        label: const Text('Credit Card'),
      ),
      VRadio<String>(
        value: 'bank',
        groupValue: _selected,
        onChanged: (v) => setState(() => _selected = v),
        label: const Text('Bank Transfer'),
      ),
      VRadio<String>(
        value: 'paypal',
        groupValue: _selected,
        onChanged: (v) => setState(() => _selected = v),
        label: const Text('PayPal'),
      ),
      VButton(onPressed: () {}, child: const Text('Continue')),
    ],
  );
}

class _RadioDemo extends StatefulWidget {
  const _RadioDemo();

  @override
  State<_RadioDemo> createState() => _RadioDemoState();
}

class _RadioDemoState extends State<_RadioDemo> {
  String? _selected = 'a';

  @override
  Widget build(BuildContext context) => VStack.vertical(
    spacing: 16,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      VRadio<String>(
        value: 'a',
        groupValue: _selected,
        onChanged: (value) => setState(() => _selected = value),
        label: const Text('Option A'),
      ),
      VRadio<String>(
        value: 'b',
        groupValue: _selected,
        onChanged: (value) => setState(() => _selected = value),
        label: const Text('Option B'),
      ),
    ],
  );
}

class _RadioSizeDemo extends StatefulWidget {
  const _RadioSizeDemo({required this.label, this.size = VWidgetSize.md});

  final String label;
  final VWidgetSize size;

  @override
  State<_RadioSizeDemo> createState() => _RadioSizeDemoState();
}

class _RadioSizeDemoState extends State<_RadioSizeDemo> {
  String? _selected = 'a';

  @override
  Widget build(BuildContext context) => VStack.vertical(
    spacing: 16,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      VRadio<String>(
        value: 'a',
        groupValue: _selected,
        onChanged: (value) => setState(() => _selected = value),
        label: Text('${widget.label} A'),
        size: widget.size,
      ),
      VRadio<String>(
        value: 'b',
        groupValue: _selected,
        onChanged: (value) => setState(() => _selected = value),
        label: Text('${widget.label} B'),
        size: widget.size,
      ),
    ],
  );
}

class _RadioOrientationDemo extends StatefulWidget {
  const _RadioOrientationDemo({required this.direction});

  final Axis direction;

  @override
  State<_RadioOrientationDemo> createState() => _RadioOrientationDemoState();
}

class _RadioOrientationDemoState extends State<_RadioOrientationDemo> {
  String? _selected = 'a';

  @override
  Widget build(BuildContext context) {
    final prefix = widget.direction == Axis.vertical
        ? 'Vertical'
        : 'Horizontal';
    final radios = [
      VRadio<String>(
        value: 'a',
        groupValue: _selected,
        onChanged: (value) => setState(() => _selected = value),
        label: Text('$prefix A'),
      ),
      VRadio<String>(
        value: 'b',
        groupValue: _selected,
        onChanged: (value) => setState(() => _selected = value),
        label: Text('$prefix B'),
      ),
      VRadio<String>(
        value: 'c',
        groupValue: _selected,
        onChanged: (value) => setState(() => _selected = value),
        label: Text('$prefix C'),
      ),
    ];
    if (widget.direction == Axis.horizontal) {
      return VStack.horizontal(spacing: 16, children: radios);
    }
    return VStack.vertical(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: radios,
    );
  }
}

class _RadioGroupDemo extends StatefulWidget {
  const _RadioGroupDemo();

  @override
  State<_RadioGroupDemo> createState() => _RadioGroupDemoState();
}

class _RadioGroupDemoState extends State<_RadioGroupDemo> {
  String? _selected = 'email';

  @override
  Widget build(BuildContext context) => VStack.vertical(
    spacing: 16,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      VRadio<String>(
        value: 'email',
        groupValue: _selected,
        onChanged: (value) => setState(() => _selected = value),
        label: const Text('Email'),
      ),
      VRadio<String>(
        value: 'sms',
        groupValue: _selected,
        onChanged: (value) => setState(() => _selected = value),
        label: const Text('SMS'),
      ),
      VRadio<String>(
        value: 'push',
        groupValue: _selected,
        onChanged: (value) => setState(() => _selected = value),
        label: const Text('Push Notification'),
      ),
    ],
  );
}

class _RadioWithDisabledDemo extends StatefulWidget {
  const _RadioWithDisabledDemo();

  @override
  State<_RadioWithDisabledDemo> createState() => _RadioWithDisabledDemoState();
}

class _RadioWithDisabledDemoState extends State<_RadioWithDisabledDemo> {
  String? _selected = 'standard';

  @override
  Widget build(BuildContext context) => VStack.vertical(
    spacing: 16,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      VRadio<String>(
        value: 'standard',
        groupValue: _selected,
        onChanged: (value) => setState(() => _selected = value),
        label: const Text('Standard'),
      ),
      VRadio<String>(
        value: 'express',
        groupValue: _selected,
        onChanged: (value) => setState(() => _selected = value),
        label: const Text('Express'),
      ),
      VRadio<String>(
        value: 'overnight',
        groupValue: _selected,
        label: const Text('Overnight'),
        enabled: false,
      ),
    ],
  );
}

class _RadioGroupModeDemo extends StatefulWidget {
  const _RadioGroupModeDemo({this.orientation = Axis.vertical});

  final Axis orientation;

  @override
  State<_RadioGroupModeDemo> createState() => _RadioGroupModeDemoState();
}

class _RadioGroupModeDemoState extends State<_RadioGroupModeDemo> {
  String? _selected = 'email';

  @override
  Widget build(BuildContext context) => VRadio<String>.group(
    options: const [
      VRadioItem(value: 'email', label: Text('Email')),
      VRadioItem(value: 'sms', label: Text('SMS')),
      VRadioItem(value: 'push', label: Text('Push Notification')),
    ],
    groupValue: _selected,
    onChanged: (value) => setState(() => _selected = value),
    orientation: widget.orientation,
  );
}

class _RadioGroupWithSublabelsDemo extends StatefulWidget {
  const _RadioGroupWithSublabelsDemo();

  @override
  State<_RadioGroupWithSublabelsDemo> createState() =>
      _RadioGroupWithSublabelsDemoState();
}

class _RadioGroupWithSublabelsDemoState
    extends State<_RadioGroupWithSublabelsDemo> {
  String? _selected = 'free';

  @override
  Widget build(BuildContext context) => VRadio<String>.group(
    options: const [
      VRadioItem(
        value: 'free',
        label: Text('Free'),
        sublabel: Text(r'$0 / month'),
      ),
      VRadioItem(
        value: 'pro',
        label: Text('Pro'),
        sublabel: Text(r'$9.99 / month'),
      ),
      VRadioItem(
        value: 'enterprise',
        label: Text('Enterprise'),
        sublabel: Text('Contact us'),
      ),
    ],
    groupValue: _selected,
    onChanged: (value) => setState(() => _selected = value),
  );
}

class _RadioGroupWithDisabledItemDemo extends StatefulWidget {
  const _RadioGroupWithDisabledItemDemo();

  @override
  State<_RadioGroupWithDisabledItemDemo> createState() =>
      _RadioGroupWithDisabledItemDemoState();
}

class _RadioGroupWithDisabledItemDemoState
    extends State<_RadioGroupWithDisabledItemDemo> {
  String? _selected = 'standard';

  @override
  Widget build(BuildContext context) => VRadio<String>.group(
    options: const [
      VRadioItem(value: 'standard', label: Text('Standard')),
      VRadioItem(value: 'express', label: Text('Express')),
      VRadioItem(value: 'overnight', label: Text('Overnight'), enabled: false),
    ],
    groupValue: _selected,
    onChanged: (value) => setState(() => _selected = value),
  );
}
