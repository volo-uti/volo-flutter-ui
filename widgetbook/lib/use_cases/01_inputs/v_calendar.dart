import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vCalendarComponent() => WidgetbookComponent(
  name: 'VCalendar',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _calendarPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _CalendarShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _CalendarSample(),
    ),
  ],
);

enum _CalendarMode { single, range, multiple }

Widget _calendarPlayground(BuildContext context) {
  final k = context.knobs;
  final mode = k.object.dropdown<_CalendarMode>(
    label: 'mode',
    options: _CalendarMode.values,
    labelBuilder: (v) => v.name,
  );
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final weekStartsOnMonday = k.boolean(label: 'weekStartsOnMonday');
  final showWeekNumbers = k.boolean(label: 'showWeekNumbers');
  final showOutsideDays = k.boolean(
    label: 'showOutsideDays',
    initialValue: true,
  );
  final maxSelections = k.int.slider(label: 'maxSelections', max: 10);
  DateTime? date;
  VDateTimeRange? range;
  var dates = <DateTime>[];

  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      info: [
        switch (mode) {
          _CalendarMode.single => 'value: $date',
          _CalendarMode.range => 'range: ${range?.start} ~ ${range?.end}',
          _CalendarMode.multiple => 'values: ${dates.length}',
        },
      ],
      child: switch (mode) {
        _CalendarMode.single => VCalendar(
          value: date,
          onChanged: (v) => setState(() => date = v),
          enabled: enabled,
          weekStartsOnMonday: weekStartsOnMonday,
          showWeekNumbers: showWeekNumbers,
          showOutsideDays: showOutsideDays,
        ),
        _CalendarMode.range => VCalendar.range(
          rangeValue: range,
          onRangeChanged: (v) => setState(() => range = v),
          enabled: enabled,
          weekStartsOnMonday: weekStartsOnMonday,
          showWeekNumbers: showWeekNumbers,
          showOutsideDays: showOutsideDays,
        ),
        _CalendarMode.multiple => VCalendar.multiple(
          values: dates,
          onValuesChanged: (v) => setState(() => dates = v),
          maxSelections: maxSelections == 0 ? null : maxSelections,
          enabled: enabled,
          weekStartsOnMonday: weekStartsOnMonday,
          showWeekNumbers: showWeekNumbers,
          showOutsideDays: showOutsideDays,
        ),
      },
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _CalendarShowcase extends StatelessWidget {
  const _CalendarShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VCalendar',
    description: 'A date selection calendar component.',
    children: [
      const WidgetbookSection(
        title: 'Selection Modes',
        children: [
          WidgetbookSubsection(
            title: 'single',
            labels: ['VCalendar()'],
            children: [_SingleSelectionDemo()],
          ),
          WidgetbookSubsection(
            title: 'range',
            labels: ['VCalendar.range()'],
            children: [_RangeSelectionDemo()],
          ),
          WidgetbookSubsection(
            title: 'multiple',
            labels: ['VCalendar.multiple()'],
            children: [_MultipleSelectionDemo()],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'With Events',
        children: [
          WidgetbookSubsection(
            title: 'events',
            labels: ['events: [...]'],
            children: [_EventsDemo()],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Options',
        children: [
          WidgetbookSubsection(
            title: 'weekStartsOnMonday',
            labels: ['weekStartsOnMonday: true'],
            children: [VCalendar(weekStartsOnMonday: true)],
          ),
          WidgetbookSubsection(
            title: 'showWeekNumbers',
            labels: ['showWeekNumbers: true'],
            children: [VCalendar(showWeekNumbers: true)],
          ),
          WidgetbookSubsection(
            title: 'showOutsideDays: false',
            labels: ['showOutsideDays: false'],
            children: [VCalendar(showOutsideDays: false)],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'enabled',
            labels: ['default state'],
            children: [VCalendar()],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: ['enabled: false'],
            children: [VCalendar(enabled: false)],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Constraints',
        children: [
          WidgetbookSubsection(
            title: 'firstDate',
            labels: const ['firstDate: today'],
            children: [VCalendar(firstDate: DateTime.now())],
          ),
          WidgetbookSubsection(
            title: 'lastDate',
            labels: const ['lastDate: +30 days'],
            children: [
              VCalendar(lastDate: DateTime.now().add(const Duration(days: 30))),
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
              'Use Case',
              'Use for always-visible calendar UI (e.g., schedule management, booking systems)',
            ),
            _guidelineRow(
              theme,
              'vs DatePicker',
              'Use VDatePicker for popups, VCalendar for inline display',
            ),
            _guidelineRow(
              theme,
              'Events',
              'Show up to 3 dots for events; tap for details',
            ),
            _guidelineRow(
              theme,
              'Week Start',
              'Sunday start is common in Korea; Monday start is common in Europe',
            ),
            _guidelineRow(
              theme,
              'Range',
              'Guide users to select the start date first when using range selection',
            ),
            _guidelineRow(
              theme,
              'Multiple',
              'Recommend limiting maximum selections (maxSelections)',
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

class _CalendarSample extends StatelessWidget {
  const _CalendarSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VCalendar Samples',
    description: 'Copy-ready code examples.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Single Date Selection',
        code: '''VCalendar(
  value: selectedDate,
  onChanged: (date) => setState(() => selectedDate = date),
)''',
        preview: _SingleSelectionDemo(),
      ),
      const WidgetbookCodeBlock(
        title: 'Date Range Selection',
        code: '''VCalendar.range(
  rangeValue: selectedRange,
  onRangeChanged: (range) => setState(() => selectedRange = range),
)''',
        preview: _RangeSelectionDemo(),
      ),
      const WidgetbookCodeBlock(
        title: 'Multiple Date Selection',
        code: '''VCalendar.multiple(
  values: selectedDates,
  onValuesChanged: (dates) => setState(() => selectedDates = dates),
  maxSelections: 5,
)''',
        preview: _MultipleSelectionDemo(),
      ),
      const WidgetbookCodeBlock(
        title: 'Event Display',
        code: '''VCalendar(
  value: selectedDate,
  onChanged: (date) => setState(() => selectedDate = date),
  events: [
    VCalendarEvent(id: '1', date: DateTime(2024, 12, 25), title: 'Christmas'),
    VCalendarEvent(id: '2', date: DateTime(2024, 12, 31), title: "New Year's Eve"),
  ],
)''',
        preview: _EventsDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Date Constraints',
        code: '''VCalendar(
  value: selectedDate,
  onChanged: (date) => setState(() => selectedDate = date),
  firstDate: DateTime.now(),
  lastDate: DateTime.now().add(Duration(days: 30)),
)''',
        preview: VCalendar(
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Booking calendar',
        code: '''VCalendar(
  value: selectedDate,
  onChanged: (date) => setState(() => selectedDate = date),
  firstDate: DateTime.now(),
  lastDate: DateTime.now().add(Duration(days: 90)),
  weekStartsOnMonday: true,
  showOutsideDays: false,
)''',
        preview: VCalendar(
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 90)),
          weekStartsOnMonday: true,
          showOutsideDays: false,
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Date range selection',
        code: '''VCalendar.range(
  startDate: checkIn,
  endDate: checkOut,
  onRangeChanged: (start, end) {
    setState(() {
      checkIn = start;
      checkOut = end;
    });
  },
  firstDate: DateTime.now(),
  lastDate: DateTime.now().add(Duration(days: 365)),
)''',
        preview: VCalendar.range(
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        ),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _SingleSelectionDemo extends StatefulWidget {
  const _SingleSelectionDemo();

  @override
  State<_SingleSelectionDemo> createState() => _SingleSelectionDemoState();
}

class _SingleSelectionDemoState extends State<_SingleSelectionDemo> {
  DateTime? _value;

  @override
  Widget build(BuildContext context) => VCalendar(
    value: _value,
    onChanged: (date) => setState(() => _value = date),
  );
}

class _RangeSelectionDemo extends StatefulWidget {
  const _RangeSelectionDemo();

  @override
  State<_RangeSelectionDemo> createState() => _RangeSelectionDemoState();
}

class _RangeSelectionDemoState extends State<_RangeSelectionDemo> {
  VDateTimeRange? _value;

  @override
  Widget build(BuildContext context) => VCalendar.range(
    rangeValue: _value,
    onRangeChanged: (range) => setState(() => _value = range),
  );
}

class _MultipleSelectionDemo extends StatefulWidget {
  const _MultipleSelectionDemo();

  @override
  State<_MultipleSelectionDemo> createState() => _MultipleSelectionDemoState();
}

class _MultipleSelectionDemoState extends State<_MultipleSelectionDemo> {
  List<DateTime> _values = [];

  @override
  Widget build(BuildContext context) => VCalendar.multiple(
    values: _values,
    onValuesChanged: (dates) => setState(() => _values = dates),
    maxSelections: 5,
  );
}

class _EventsDemo extends StatefulWidget {
  const _EventsDemo();

  @override
  State<_EventsDemo> createState() => _EventsDemoState();
}

class _EventsDemoState extends State<_EventsDemo> {
  DateTime? _value;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final now = DateTime.now();

    return VCalendar(
      value: _value,
      onChanged: (date) => setState(() => _value = date),
      events: [
        VCalendarEvent(
          id: '1',
          date: DateTime(now.year, now.month, 10),
          title: 'Meeting',
          color: theme.colors.primary,
        ),
        VCalendarEvent(
          id: '2',
          date: DateTime(now.year, now.month, 15),
          title: 'Deadline',
          color: theme.colors.destructive,
        ),
        VCalendarEvent(
          id: '3',
          date: DateTime(now.year, now.month, 15),
          title: 'Another event',
          color: theme.colors.accent,
        ),
        VCalendarEvent(
          id: '4',
          date: DateTime(now.year, now.month, 20),
          title: 'Holiday',
          color: theme.colors.success,
        ),
      ],
    );
  }
}
