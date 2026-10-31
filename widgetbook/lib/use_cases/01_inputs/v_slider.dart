import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vSliderComponent() => WidgetbookComponent(
  name: 'VSlider',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _sliderPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _SliderShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _SliderSample(),
    ),
  ],
);

Widget _sliderPlayground(BuildContext context) {
  final k = context.knobs;
  final range = k.boolean(label: 'range');
  var value = k.double.slider(
    label: 'value',
    initialValue: 40,
    max: 100,
    divisions: 100,
  );
  var start = k.double.slider(
    label: 'range start',
    initialValue: 20,
    max: 100,
    divisions: 100,
  );
  var end = k.double.slider(
    label: 'range end',
    initialValue: 80,
    max: 100,
    divisions: 100,
  );
  final divisions = k.int.slider(
    label: 'divisions (0 = continuous)',
    divisions: 20,
  );
  final showLabel = k.boolean(label: 'showLabel');
  final enabled = k.boolean(label: 'enabled', initialValue: true);

  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      info: [
        if (range)
          'range: ${start.toStringAsFixed(0)} - ${end.toStringAsFixed(0)}'
        else
          'value: ${value.toStringAsFixed(0)}',
      ],
      child: SizedBox(
        width: 320,
        child: range
            ? VSlider.range(
                values: RangeValues(math.min(start, end), math.max(start, end)),
                divisions: divisions == 0 ? null : divisions,
                showLabel: showLabel,
                enabled: enabled,
                onRangeChanged: (v) => setState(() {
                  start = v.start;
                  end = v.end;
                }),
              )
            : VSlider(
                value: value,
                divisions: divisions == 0 ? null : divisions,
                showLabel: showLabel,
                enabled: enabled,
                onChanged: (v) => setState(() => value = v),
              ),
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _SliderShowcase extends StatelessWidget {
  const _SliderShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VSlider',
    description: 'Slider input for selecting a numeric value within a range.',
    children: [
      const WidgetbookSection(
        title: 'Basic',
        children: [
          WidgetbookSubsection(
            title: 'slider',
            labels: ['single value'],
            children: [_SliderDemo()],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Divisions',
        children: [
          WidgetbookSubsection(
            title: 'stepped',
            labels: ['divisions={10}'],
            children: [_SliderWithDivisionsDemo()],
          ),
          WidgetbookSubsection(
            title: 'continuous',
            labels: ['continuous'],
            children: [_SliderDemo()],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Range',
        children: [
          WidgetbookSubsection(
            title: 'range slider',
            labels: ['range'],
            children: [_RangeSliderDemo()],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: ['default'],
            children: [_SliderDemo()],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: ['disabled'],
            children: [_DisabledSliderDemo()],
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
              'Adjusting continuous values: volume, brightness, price range, opacity',
            ),
            _guidelineRow(
              theme,
              'Range',
              'Set meaningful min/max. Consider using step to snap to useful increments',
            ),
            _guidelineRow(
              theme,
              'vs Number input',
              'Use slider for approximate values. Use number input for precise entry',
            ),
            _guidelineRow(
              theme,
              'Feedback',
              'Show current value label. Consider pairing with a number input for precision',
            ),
            _guidelineRow(
              theme,
              'Step',
              'Use step for discrete values (e.g., step=5 for 0/5/10/15/...)',
            ),
            _guidelineRow(
              theme,
              'Disabled',
              'When the value is locked or determined by another control',
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

class _SliderSample extends StatelessWidget {
  const _SliderSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VSlider Samples',
    description: 'Copy-paste code examples for common slider patterns.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic Usage',
        code: '''VSlider(
  value: volume,
  onChanged: (value) => setState(() => volume = value),
)''',
        preview: _SliderDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Range Slider',
        code: '''VSlider.range(
  values: RangeValues(20, 80),
  min: 0,
  max: 100,
  onChanged: (values) => setState(() => range = values),
)''',
        preview: _RangeSliderDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'With Divisions',
        code: '''VSlider(
  value: rating,
  min: 0,
  max: 100,
  divisions: 10,
  onChanged: (value) => setState(() => rating = value),
)''',
        preview: _SliderWithDivisionsDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Configuration Form (VForm)',
        code: '''VForm(
  formKey: formKey,
  children: [
    VSlider(
      value: volume,
      onChanged: (v) => setState(() => volume = v),
      showLabel: true,
    ),
    VSlider(
      value: brightness,
      onChanged: (v) => setState(() => brightness = v),
      showLabel: true,
    ),
    VSlider(
      value: quality,
      min: 0,
      max: 100,
      divisions: 5,
      onChanged: (v) => setState(() => quality = v),
      showLabel: true,
    ),
    VButton(
      onPressed: () {},
      child: Text('Apply'),
    ),
  ],
)''',
        preview: _ConfigurationFormDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Volume control',
        code: '''Row(
  children: [
    Text('\u{1F508}'),
    Expanded(
      child: VSlider(
        value: volume,
        onChanged: (v) => setState(() => volume = v),
      ),
    ),
    Text('\u{1F50A}'),
  ],
)''',
        preview: _VolumeSliderDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Price range filter',
        code: r'''Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Price Range: $${range.start.toInt()} - $${range.end.toInt()}'),
    VSlider.range(
      values: range,
      min: 0,
      max: 1000,
      divisions: 20,
      onRangeChanged: (v) => setState(() => range = v),
    ),
  ],
)''',
        preview: _PriceRangeDemo(),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _ConfigurationFormDemo extends StatefulWidget {
  const _ConfigurationFormDemo();

  @override
  State<_ConfigurationFormDemo> createState() => _ConfigurationFormDemoState();
}

class _ConfigurationFormDemoState extends State<_ConfigurationFormDemo> {
  double _volume = 0.7;
  double _brightness = 0.5;
  double _quality = 60;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 300,
    child: VForm(
      children: [
        VStack.vertical(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Volume: ${(_volume * 100).toInt()}%'),
            VSlider(
              value: _volume,
              onChanged: (v) => setState(() => _volume = v),
              showLabel: true,
            ),
          ],
        ),
        VStack.vertical(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Brightness: ${(_brightness * 100).toInt()}%'),
            VSlider(
              value: _brightness,
              onChanged: (v) => setState(() => _brightness = v),
              showLabel: true,
            ),
          ],
        ),
        VStack.vertical(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quality: ${_quality.toInt()}'),
            VSlider(
              value: _quality,
              divisions: 5,
              onChanged: (v) => setState(() => _quality = v),
              showLabel: true,
            ),
          ],
        ),
        VButton(onPressed: () {}, child: const Text('Apply')),
      ],
    ),
  );
}

class _SliderDemo extends StatefulWidget {
  const _SliderDemo();

  @override
  State<_SliderDemo> createState() => _SliderDemoState();
}

class _SliderDemoState extends State<_SliderDemo> {
  double _value = 0.5;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 300,
    child: VStack.vertical(
      spacing: 8,
      children: [
        Text('Value: ${_value.toStringAsFixed(2)}'),
        VSlider(
          value: _value,
          onChanged: (value) => setState(() => _value = value),
        ),
      ],
    ),
  );
}

class _RangeSliderDemo extends StatefulWidget {
  const _RangeSliderDemo();

  @override
  State<_RangeSliderDemo> createState() => _RangeSliderDemoState();
}

class _RangeSliderDemoState extends State<_RangeSliderDemo> {
  RangeValues _values = const RangeValues(0.2, 0.8);

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 300,
    child: VStack.vertical(
      spacing: 8,
      children: [
        Text(
          'Range: ${_values.start.toStringAsFixed(2)} - ${_values.end.toStringAsFixed(2)}',
        ),
        VSlider.range(
          values: _values,
          onRangeChanged: (values) => setState(() => _values = values),
        ),
      ],
    ),
  );
}

class _SliderWithDivisionsDemo extends StatefulWidget {
  const _SliderWithDivisionsDemo();

  @override
  State<_SliderWithDivisionsDemo> createState() =>
      _SliderWithDivisionsDemoState();
}

class _SliderWithDivisionsDemoState extends State<_SliderWithDivisionsDemo> {
  double _value = 50;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 300,
    child: VStack.vertical(
      spacing: 8,
      children: [
        Text('Value: ${_value.toInt()}'),
        VSlider(
          value: _value,
          divisions: 10,
          onChanged: (value) => setState(() => _value = value),
        ),
      ],
    ),
  );
}

class _DisabledSliderDemo extends StatelessWidget {
  const _DisabledSliderDemo();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 300,
    child: VStack.vertical(
      spacing: 8,
      children: [
        const Text('Value: 0.50'),
        VSlider(value: 0.5, onChanged: (value) {}, enabled: false),
      ],
    ),
  );
}

class _VolumeSliderDemo extends StatefulWidget {
  const _VolumeSliderDemo();

  @override
  State<_VolumeSliderDemo> createState() => _VolumeSliderDemoState();
}

class _VolumeSliderDemoState extends State<_VolumeSliderDemo> {
  double _volume = 0.5;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 300,
    child: Row(
      children: [
        const Text('\u{1F508}'),
        Expanded(
          child: VSlider(
            value: _volume,
            onChanged: (v) => setState(() => _volume = v),
          ),
        ),
        const Text('\u{1F50A}'),
      ],
    ),
  );
}

class _PriceRangeDemo extends StatefulWidget {
  const _PriceRangeDemo();

  @override
  State<_PriceRangeDemo> createState() => _PriceRangeDemoState();
}

class _PriceRangeDemoState extends State<_PriceRangeDemo> {
  RangeValues _range = const RangeValues(100, 500);

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 300,
    child: VStack.vertical(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Price: \$${_range.start.toInt()} - \$${_range.end.toInt()}'),
        VSlider.range(
          values: _range,
          max: 1000,
          divisions: 20,
          onRangeChanged: (v) => setState(() => _range = v),
        ),
      ],
    ),
  );
}
