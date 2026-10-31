import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vDatePickerComponent() => WidgetbookComponent(
  name: 'VDatePicker',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _datePickerPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _DatePickerShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _DatePickerSample(),
    ),
  ],
);

enum _DatePickerMode { date, time, dateTime, range }

Widget _datePickerPlayground(BuildContext context) {
  final k = context.knobs;
  final mode = k.object.dropdown<_DatePickerMode>(
    label: 'mode',
    options: _DatePickerMode.values,
    labelBuilder: (v) => v.name,
  );
  final size = k.object.dropdown<VDatePickerSize>(
    label: 'size',
    options: VDatePickerSize.values,
    initialOption: VDatePickerSize.md,
    labelBuilder: (v) => v.name,
  );
  final label = k.stringOrNull(label: 'label', initialValue: 'Date');
  final placeholder = k.stringOrNull(
    label: 'placeholder',
    initialValue: 'Select...',
  );
  final helper = k.stringOrNull(label: 'helper');
  final error = k.boolean(label: 'error');
  final errorText = k.stringOrNull(label: 'errorText');
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final readOnly = k.boolean(label: 'readOnly');
  final required = k.boolean(label: 'required');
  final fullWidth = k.boolean(label: 'fullWidth');
  final use24HourFormat = k.boolean(
    label: 'use24HourFormat',
    initialValue: true,
  );
  final minuteInterval = k.int.slider(
    label: 'minuteInterval',
    initialValue: 1,
    min: 1,
    max: 30,
  );
  DateTime? date;
  VTimeOfDay? time;
  VDateTimeRange? range;

  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      info: [
        switch (mode) {
          _DatePickerMode.date || _DatePickerMode.dateTime => 'value: $date',
          _DatePickerMode.time => 'time: $time',
          _DatePickerMode.range => 'range: ${range?.start} ~ ${range?.end}',
        },
      ],
      child: SizedBox(
        width: fullWidth ? double.infinity : 320,
        child: switch (mode) {
          _DatePickerMode.date => VDatePicker.date(
            value: date,
            onChanged: (v) => setState(() => date = v),
            label: label,
            placeholder: placeholder,
            helper: helper,
            error: error,
            errorText: errorText,
            size: size,
            enabled: enabled,
            readOnly: readOnly,
            required: required,
            fullWidth: fullWidth,
          ),
          _DatePickerMode.time => VDatePicker.time(
            timeValue: time,
            onTimeChanged: (v) => setState(() => time = v),
            use24HourFormat: use24HourFormat,
            minuteInterval: minuteInterval,
            label: label,
            placeholder: placeholder,
            helper: helper,
            error: error,
            errorText: errorText,
            size: size,
            enabled: enabled,
            readOnly: readOnly,
            required: required,
            fullWidth: fullWidth,
          ),
          _DatePickerMode.dateTime => VDatePicker.dateTime(
            value: date,
            onChanged: (v) => setState(() => date = v),
            use24HourFormat: use24HourFormat,
            minuteInterval: minuteInterval,
            label: label,
            placeholder: placeholder,
            helper: helper,
            error: error,
            errorText: errorText,
            size: size,
            enabled: enabled,
            readOnly: readOnly,
            required: required,
            fullWidth: fullWidth,
          ),
          _DatePickerMode.range => VDatePicker.range(
            rangeValue: range,
            onRangeChanged: (v) => setState(() => range = v),
            label: label,
            placeholder: placeholder,
            helper: helper,
            error: error,
            errorText: errorText,
            size: size,
            enabled: enabled,
            readOnly: readOnly,
            required: required,
            fullWidth: fullWidth,
          ),
        },
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _DatePickerShowcase extends StatelessWidget {
  const _DatePickerShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VDatePicker',
    description: 'A date input with calendar dropdown for date selection.',
    children: [
      const WidgetbookSection(
        title: 'Modes',
        children: [
          WidgetbookSubsection(
            title: 'date',
            labels: ['VDatePicker.date()'],
            children: [_DatePickerDemo()],
          ),
          WidgetbookSubsection(
            title: 'time',
            labels: ['VDatePicker.time()'],
            children: [_TimePickerDemo()],
          ),
          WidgetbookSubsection(
            title: 'dateTime',
            labels: ['VDatePicker.dateTime()'],
            children: [_DateTimePickerDemo()],
          ),
          WidgetbookSubsection(
            title: 'range',
            labels: ['VDatePicker.range()'],
            children: [_RangePickerDemo()],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'sm',
            labels: ['VDatePickerSize.sm'],
            children: [
              VDatePicker.date(size: VDatePickerSize.sm, placeholder: 'Small'),
            ],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: ['VDatePickerSize.md'],
            children: [
              VDatePicker.date(size: VDatePickerSize.md, placeholder: 'Medium'),
            ],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: ['VDatePickerSize.lg'],
            children: [
              VDatePicker.date(size: VDatePickerSize.lg, placeholder: 'Large'),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'States',
        children: [
          const WidgetbookSubsection(
            title: 'enabled',
            labels: ['default state'],
            children: [
              VDatePicker.date(placeholder: 'Enabled', label: 'Enabled'),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: const ['enabled: false'],
            children: [
              VDatePicker.date(
                value: DateTime.now(),
                enabled: false,
                label: 'Disabled',
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'readOnly',
            labels: const ['readOnly: true'],
            children: [
              VDatePicker.date(
                value: DateTime.now(),
                readOnly: true,
                label: 'Read Only',
              ),
            ],
          ),
          const WidgetbookSubsection(
            title: 'error',
            labels: ['error: "message"'],
            children: [
              VDatePicker.date(
                placeholder: 'Select date',
                error: true,
                errorText: 'This field is required',
                label: 'With Error',
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
              'Mode',
              'Choose the appropriate mode: date, time, dateTime, or range',
            ),
            _guidelineRow(
              theme,
              'Range Limits',
              'Use firstDate/lastDate to restrict selectable range and prevent invalid dates',
            ),
            _guidelineRow(
              theme,
              'Today Highlight',
              'Today is automatically highlighted to provide a reference point for users',
            ),
            _guidelineRow(
              theme,
              'Initial Value',
              'Recommend providing an appropriate initial value for bookings/schedules',
            ),
            _guidelineRow(
              theme,
              'Format',
              'Display date/time in the format of the surrounding VoloLocalizations',
            ),
            _guidelineRow(
              theme,
              'Validation',
              'Use the error property to display validation results for required fields',
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

class _DatePickerSample extends StatelessWidget {
  const _DatePickerSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VDatePicker Samples',
    description: 'Copy-ready code examples.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Date Selection',
        code: '''VDatePicker.date(
  value: selectedDate,
  onChanged: (date) => setState(() => selectedDate = date),
  label: 'Date',
  placeholder: 'Select date',
)''',
        preview: _DatePickerDemo(),
      ),
      const WidgetbookCodeBlock(
        title: 'Time Selection',
        code: '''VDatePicker.time(
  timeValue: selectedTime,
  onTimeChanged: (time) => setState(() => selectedTime = time),
  label: 'Time',
  placeholder: 'Select time',
)''',
        preview: _TimePickerDemo(),
      ),
      const WidgetbookCodeBlock(
        title: 'Date Range',
        code: '''VDatePicker.range(
  rangeValue: selectedRange,
  onRangeChanged: (range) => setState(() => selectedRange = range),
  label: 'Date Range',
  placeholder: 'Select date range',
)''',
        preview: _RangePickerDemo(),
      ),
      const WidgetbookCodeBlock(
        title: 'Helper Text',
        code: '''VDatePicker.date(
  label: 'Birth Date',
  placeholder: 'Select your birth date',
  helper: 'We will use this to calculate your age',
)''',
        preview: VDatePicker.date(
          label: 'Birth Date',
          placeholder: 'Select your birth date',
          helper: 'We will use this to calculate your age',
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Birthday picker',
        code: '''VDatePicker.date(
  label: 'Birthday',
  placeholder: 'Select your birthday',
  required: true,
  lastDate: DateTime.now(),
  firstDate: DateTime(1900),
  helper: 'You must be at least 14 years old',
)''',
        preview: VDatePicker.date(
          label: 'Birthday',
          placeholder: 'Select your birthday',
          required: true,
          lastDate: DateTime.now(),
          firstDate: DateTime(1900),
          helper: 'You must be at least 14 years old',
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Event scheduling',
        code: '''Column(
  children: [
    VDatePicker.dateTime(
      label: 'Start',
      placeholder: 'Start date & time',
      required: true,
    ),
    SizedBox(height: 16),
    VDatePicker.dateTime(
      label: 'End',
      placeholder: 'End date & time',
      required: true,
    ),
  ],
)''',
        preview: Column(
          children: [
            VDatePicker.dateTime(
              label: 'Start',
              placeholder: 'Start date & time',
              required: true,
            ),
            SizedBox(height: 16),
            VDatePicker.dateTime(
              label: 'End',
              placeholder: 'End date & time',
              required: true,
            ),
          ],
        ),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _DatePickerDemo extends StatefulWidget {
  const _DatePickerDemo();

  @override
  State<_DatePickerDemo> createState() => _DatePickerDemoState();
}

class _DatePickerDemoState extends State<_DatePickerDemo> {
  DateTime? _value;

  @override
  Widget build(BuildContext context) => VDatePicker.date(
    value: _value,
    onChanged: (date) => setState(() => _value = date),
    placeholder: 'Select date',
    label: 'Date',
  );
}

class _TimePickerDemo extends StatefulWidget {
  const _TimePickerDemo();

  @override
  State<_TimePickerDemo> createState() => _TimePickerDemoState();
}

class _TimePickerDemoState extends State<_TimePickerDemo> {
  VTimeOfDay? _value;

  @override
  Widget build(BuildContext context) => VDatePicker.time(
    timeValue: _value,
    onTimeChanged: (time) => setState(() => _value = time),
    placeholder: 'Select time',
    label: 'Time',
  );
}

class _DateTimePickerDemo extends StatefulWidget {
  const _DateTimePickerDemo();

  @override
  State<_DateTimePickerDemo> createState() => _DateTimePickerDemoState();
}

class _DateTimePickerDemoState extends State<_DateTimePickerDemo> {
  DateTime? _value;

  @override
  Widget build(BuildContext context) => VDatePicker.dateTime(
    value: _value,
    onChanged: (dateTime) => setState(() => _value = dateTime),
    placeholder: 'Select date and time',
    label: 'Date & Time',
  );
}

class _RangePickerDemo extends StatefulWidget {
  const _RangePickerDemo();

  @override
  State<_RangePickerDemo> createState() => _RangePickerDemoState();
}

class _RangePickerDemoState extends State<_RangePickerDemo> {
  VDateTimeRange? _value;

  @override
  Widget build(BuildContext context) => VDatePicker.range(
    rangeValue: _value,
    onRangeChanged: (range) => setState(() => _value = range),
    placeholder: 'Select date range',
    label: 'Date Range',
  );
}
