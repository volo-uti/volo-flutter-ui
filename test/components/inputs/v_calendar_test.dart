import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  group('VCalendar', () {
    testWidgets('default rendering', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VCalendar()));

      expect(find.byType(VCalendar), findsOneWidget);
    });

    testWidgets('displays month header', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VCalendar(initialMonth: DateTime(2024, 12))),
      );

      expect(find.text('December 2024'), findsOneWidget);
    });

    testWidgets('displays weekday headers (starting Sunday)', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VCalendar()));

      expect(find.text('Sun'), findsOneWidget);
      expect(find.text('Mon'), findsOneWidget);
      expect(find.text('Sat'), findsOneWidget);
    });

    testWidgets('displays weekday headers (starting Monday)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VCalendar(weekStartsOnMonday: true)),
      );

      // Monday is displayed first.
      expect(find.text('Mon'), findsOneWidget);
    });

    testWidgets('displays dates', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VCalendar(initialMonth: DateTime(2024, 12), showOutsideDays: false),
        ),
      );

      // December has days from 1 to 31.
      expect(find.text('1'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
      expect(find.text('31'), findsOneWidget);
    });

    testWidgets('displays selected date', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VCalendar(value: DateTime(2024, 12, 25))),
      );

      expect(find.text('25'), findsOneWidget);
    });

    testWidgets('date selection callback', (tester) async {
      DateTime? selectedDate;

      await tester.pumpWidget(
        buildTestWidget(
          VCalendar(
            initialMonth: DateTime(2024, 12),
            showOutsideDays: false,
            onChanged: (date) => selectedDate = date,
          ),
        ),
      );

      // Tap the 15th.
      await tester.tap(find.text('15'));
      await tester.pump();

      expect(selectedDate, DateTime(2024, 12, 15));
    });

    testWidgets('date deselection', (tester) async {
      DateTime? selectedDate = DateTime(2024, 12, 15);

      await tester.pumpWidget(
        buildTestWidget(
          VCalendar(
            value: selectedDate,
            showOutsideDays: false,
            onChanged: (date) => selectedDate = date,
          ),
        ),
      );

      // Tap the same date again.
      await tester.tap(find.text('15'));
      await tester.pump();

      expect(selectedDate, isNull);
    });

    testWidgets('navigate to previous month', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VCalendar(initialMonth: DateTime(2024, 12))),
      );

      expect(find.text('December 2024'), findsOneWidget);

      // Tap the previous month button (VIcons.chevronLeft in first GestureDetector).
      final navButtons = find.byWidgetPredicate(
        (w) =>
            w is GestureDetector &&
            w.behavior == HitTestBehavior.opaque &&
            w.onTap != null,
      );
      await tester.tap(navButtons.first);
      await tester.pump();

      expect(find.text('November 2024'), findsOneWidget);
    });

    testWidgets('navigate to next month', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VCalendar(initialMonth: DateTime(2024, 12))),
      );

      expect(find.text('December 2024'), findsOneWidget);

      // Tap the next month button (VIcons.chevronRight in last nav GestureDetector).
      final navButtons = find.byWidgetPredicate(
        (w) =>
            w is GestureDetector &&
            w.behavior == HitTestBehavior.opaque &&
            w.onTap != null,
      );
      await tester.tap(navButtons.at(1));
      await tester.pump();

      expect(find.text('January 2025'), findsOneWidget);
    });

    // ── FocusTraversalGroup ──────────────────────────────────────────

    testWidgets('wraps content in FocusTraversalGroup', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VCalendar()));

      expect(
        find.descendant(
          of: find.byType(VCalendar),
          matching: find.byType(FocusTraversalGroup),
        ),
        findsOneWidget,
      );
    });

    testWidgets('disabled state', (tester) async {
      DateTime? selectedDate;

      await tester.pumpWidget(
        buildTestWidget(
          VCalendar(
            initialMonth: DateTime(2024, 12),
            showOutsideDays: false,
            enabled: false,
            onChanged: (date) => selectedDate = date,
          ),
        ),
      );

      await tester.tap(find.text('15'));
      await tester.pump();

      expect(selectedDate, isNull);
    });
  });

  group('VCalendar.range', () {
    testWidgets('default rendering', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VCalendar.range()));

      expect(find.byType(VCalendar), findsOneWidget);
    });

    testWidgets('range selection', (tester) async {
      VDateTimeRange? selectedRange;

      await tester.pumpWidget(
        buildTestWidget(
          VCalendar.range(
            initialMonth: DateTime(2024, 12),
            showOutsideDays: false,
            onRangeChanged: (range) => selectedRange = range,
          ),
        ),
      );

      // Select start date.
      await tester.tap(find.text('10'));
      await tester.pump();

      // Select end date.
      await tester.tap(find.text('15'));
      await tester.pump();

      expect(selectedRange, isNotNull);
      expect(selectedRange!.start, DateTime(2024, 12, 10));
      expect(selectedRange!.end, DateTime(2024, 12, 15));
    });

    testWidgets('displays selected range', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VCalendar.range(
            rangeValue: VDateTimeRange(
              start: DateTime(2024, 12, 10),
              end: DateTime(2024, 12, 15),
            ),
          ),
        ),
      );

      expect(find.byType(VCalendar), findsOneWidget);
    });
  });

  group('VCalendar.multiple', () {
    testWidgets('default rendering', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VCalendar.multiple()));

      expect(find.byType(VCalendar), findsOneWidget);
    });

    testWidgets('multiple date selection', (tester) async {
      var selectedDates = <DateTime>[];

      Widget buildCalendar() => buildTestWidget(
        VCalendar.multiple(
          initialMonth: DateTime(2024, 12),
          showOutsideDays: false,
          values: selectedDates,
          onValuesChanged: (dates) => selectedDates = dates,
        ),
      );

      await tester.pumpWidget(buildCalendar());

      // Select first date.
      await tester.tap(find.text('10'));
      await tester.pumpWidget(buildCalendar());

      expect(selectedDates.length, 1);

      // Select second date.
      await tester.tap(find.text('15'));
      await tester.pumpWidget(buildCalendar());

      expect(selectedDates.length, 2);
    });

    testWidgets('maximum selection count limit', (tester) async {
      var selectedDates = <DateTime>[];

      await tester.pumpWidget(
        buildTestWidget(
          VCalendar.multiple(
            initialMonth: DateTime(2024, 12),
            showOutsideDays: false,
            values: selectedDates,
            maxSelections: 2,
            onValuesChanged: (dates) => selectedDates = dates,
          ),
        ),
      );

      await tester.tap(find.text('10'));
      await tester.pumpWidget(
        buildTestWidget(
          VCalendar.multiple(
            initialMonth: DateTime(2024, 12),
            showOutsideDays: false,
            values: selectedDates,
            maxSelections: 2,
            onValuesChanged: (dates) => selectedDates = dates,
          ),
        ),
      );

      await tester.tap(find.text('15'));
      await tester.pumpWidget(
        buildTestWidget(
          VCalendar.multiple(
            initialMonth: DateTime(2024, 12),
            showOutsideDays: false,
            values: selectedDates,
            maxSelections: 2,
            onValuesChanged: (dates) => selectedDates = dates,
          ),
        ),
      );

      expect(selectedDates.length, 2);

      // Attempt to select a third date.
      await tester.tap(find.text('20'));
      await tester.pumpWidget(
        buildTestWidget(
          VCalendar.multiple(
            initialMonth: DateTime(2024, 12),
            showOutsideDays: false,
            values: selectedDates,
            maxSelections: 2,
            onValuesChanged: (dates) => selectedDates = dates,
          ),
        ),
      );

      expect(selectedDates.length, 2); // Still 2.
    });

    testWidgets('date deselection', (tester) async {
      var selectedDates = <DateTime>[DateTime(2024, 12, 15)];

      await tester.pumpWidget(
        buildTestWidget(
          VCalendar.multiple(
            initialMonth: DateTime(2024, 12),
            showOutsideDays: false,
            values: selectedDates,
            onValuesChanged: (dates) => selectedDates = dates,
          ),
        ),
      );

      // Tap the same date again to deselect.
      await tester.tap(find.text('15'));
      await tester.pump();

      expect(selectedDates, isEmpty);
    });
  });

  group('VCalendar with events', () {
    testWidgets('displays events', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VCalendar(
            initialMonth: DateTime(2024, 12),
            events: [
              VCalendarEvent(
                id: '1',
                date: DateTime(2024, 12, 25),
                title: 'Christmas',
              ),
            ],
          ),
        ),
      );

      expect(find.byType(VCalendar), findsOneWidget);
    });

    testWidgets('displays multiple events', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VCalendar(
            initialMonth: DateTime(2024, 12),
            events: [
              VCalendarEvent(
                id: '1',
                date: DateTime(2024, 12, 25),
                title: 'Christmas',
              ),
              VCalendarEvent(
                id: '2',
                date: DateTime(2024, 12, 25),
                title: 'Holiday',
              ),
              VCalendarEvent(
                id: '3',
                date: DateTime(2024, 12, 31),
                title: 'New Year Eve',
              ),
            ],
          ),
        ),
      );

      expect(find.byType(VCalendar), findsOneWidget);
    });
  });

  group('VCalendar constraints', () {
    testWidgets('cannot select dates before firstDate', (tester) async {
      DateTime? selectedDate;

      await tester.pumpWidget(
        buildTestWidget(
          VCalendar(
            initialMonth: DateTime(2024, 12),
            showOutsideDays: false,
            firstDate: DateTime(2024, 12, 10),
            onChanged: (date) => selectedDate = date,
          ),
        ),
      );

      // Tap a date before firstDate (5th).
      await tester.tap(find.text('5'));
      await tester.pump();

      expect(selectedDate, isNull);
    });

    testWidgets('cannot select dates after lastDate', (tester) async {
      DateTime? selectedDate;

      await tester.pumpWidget(
        buildTestWidget(
          VCalendar(
            initialMonth: DateTime(2024, 12),
            showOutsideDays: false,
            lastDate: DateTime(2024, 12, 20),
            onChanged: (date) => selectedDate = date,
          ),
        ),
      );

      // Tap a date after lastDate.
      await tester.tap(find.text('25'));
      await tester.pump();

      expect(selectedDate, isNull);
    });

    testWidgets('selectableDayPredicate condition', (tester) async {
      DateTime? selectedDate;

      await tester.pumpWidget(
        buildTestWidget(
          VCalendar(
            initialMonth: DateTime(2024, 12),
            showOutsideDays: false,
            selectableDayPredicate: (date) => date.weekday != DateTime.sunday,
            onChanged: (date) => selectedDate = date,
          ),
        ),
      );

      // December 15 is a Sunday.
      await tester.tap(find.text('15'));
      await tester.pump();

      expect(selectedDate, isNull);
    });
  });

  group('VCalendarEvent', () {
    test('default constructor', () {
      final event = VCalendarEvent(
        id: '1',
        date: DateTime(2024, 12, 25),
        title: 'Christmas',
      );

      expect(event.id, '1');
      expect(event.date, DateTime(2024, 12, 25));
      expect(event.title, 'Christmas');
    });

    test('equality', () {
      final event1 = VCalendarEvent(id: '1', date: DateTime(2024, 12, 25));
      final event2 = VCalendarEvent(id: '1', date: DateTime(2024, 12, 25));
      final event3 = VCalendarEvent(id: '2', date: DateTime(2024, 12, 25));

      expect(event1 == event2, true);
      expect(event1 == event3, false);
    });
  });
}
