import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vNumberStepperComponent() => WidgetbookComponent(
  name: 'VNumberStepper',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _numberStepperPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _NumberStepperShowcase(),
    ),
  ],
);

Widget _numberStepperPlayground(BuildContext context) {
  final k = context.knobs;
  final min = k.int.slider(label: 'min', max: 10);
  final max = k.int.slider(label: 'max (0 = none)', initialValue: 10, max: 50);
  final step = k.int.slider(label: 'step', initialValue: 1, min: 1, max: 10);
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final size = k.object.dropdown<VNumberStepperSize>(
    label: 'size',
    options: VNumberStepperSize.values,
    initialOption: VNumberStepperSize.md,
    labelBuilder: (v) => v.name,
  );
  final semanticLabel = k.string(
    label: 'semanticLabel',
    initialValue: 'Quantity',
  );

  var value = min;
  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      info: ['value: $value'],
      child: VNumberStepper(
        value: value,
        min: min,
        max: max == 0 || max < min ? null : max,
        step: step,
        enabled: enabled,
        size: size,
        semanticLabel: semanticLabel.isEmpty ? null : semanticLabel,
        onChanged: (v) => setState(() => value = v),
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _NumberStepperShowcase extends StatelessWidget {
  const _NumberStepperShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VNumberStepper',
    description:
        'Whole number between minus and plus buttons. The button at an end '
        'of the range turns off; screen readers get increase and decrease.',
    children: [
      WidgetbookSection(
        title: 'Sizes',
        children: [
          for (final size in VNumberStepperSize.values)
            WidgetbookSubsection(
              title: size.name,
              labels: ['size="${size.name}"'],
              children: [_Stepper(initial: 3, max: 9, size: size)],
            ),
        ],
      ),
      const WidgetbookSection(
        title: 'Range',
        children: [
          WidgetbookSubsection(
            title: 'at min',
            labels: ['value == min'],
            children: [_Stepper(initial: 1, min: 1, max: 9)],
          ),
          WidgetbookSubsection(
            title: 'at max',
            labels: ['value == max'],
            children: [_Stepper(initial: 9, min: 1, max: 9)],
          ),
          WidgetbookSubsection(
            title: 'step 5',
            labels: ['step: 5'],
            children: [_Stepper(initial: 10, max: 100, step: 5)],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'State',
        children: [
          WidgetbookSubsection(
            title: 'disabled',
            labels: ['enabled: false'],
            children: [_Stepper(initial: 4, max: 9, enabled: false)],
          ),
        ],
      ),
    ],
  );
}

class _Stepper extends StatefulWidget {
  const _Stepper({
    required this.initial,
    this.min = 0,
    this.max,
    this.step = 1,
    this.enabled = true,
    this.size = VNumberStepperSize.md,
  });

  final int initial;
  final int min;
  final int? max;
  final int step;
  final bool enabled;
  final VNumberStepperSize size;

  @override
  State<_Stepper> createState() => _StepperState();
}

class _StepperState extends State<_Stepper> {
  late int _value = widget.initial;

  @override
  Widget build(BuildContext context) => VNumberStepper(
    value: _value,
    min: widget.min,
    max: widget.max,
    step: widget.step,
    enabled: widget.enabled,
    size: widget.size,
    semanticLabel: 'Quantity',
    onChanged: (v) => setState(() => _value = v),
  );
}
