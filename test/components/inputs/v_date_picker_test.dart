import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  Widget buildTestWidgetWithOverlay(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Overlay(
          initialEntries: [
            OverlayEntry(builder: (context) => Center(child: child)),
          ],
        ),
      ),
    ),
  );

  group('VDatePicker.date', () {
    testWidgets('default rendering', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VDatePicker.date()));

      expect(find.byType(VDatePicker), findsOneWidget);
    });

    testWidgets('displays placeholder', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VDatePicker.date(placeholder: 'Select Date')),
      );

      expect(find.text('Select Date'), findsOneWidget);
    });

    testWidgets('displays selected date', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(VDatePicker.date(value: DateTime(2024, 12, 25))),
      );

      expect(find.text('December 25, 2024'), findsOneWidget);
    });

    testWidgets('displays label', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VDatePicker.date(label: 'Date of Birth')),
      );

      expect(find.text('Date of Birth'), findsOneWidget);
    });

    testWidgets('displays error message', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VDatePicker.date(
            error: true,
            errorText: 'This field is required',
          ),
        ),
      );

      expect(find.text('This field is required'), findsOneWidget);
    });

    testWidgets('displays helper text', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VDatePicker.date(helper: 'Please select a date')),
      );

      expect(find.text('Please select a date'), findsOneWidget);
    });

    testWidgets('disabled state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VDatePicker.date(enabled: false)),
      );

      expect(find.byType(VDatePicker), findsOneWidget);
    });
  });

  group('VDatePicker.time', () {
    testWidgets('default rendering', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VDatePicker.time()));

      expect(find.byType(VDatePicker), findsOneWidget);
    });

    testWidgets('displays placeholder', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VDatePicker.time(placeholder: 'Select Time')),
      );

      expect(find.text('Select Time'), findsOneWidget);
    });

    testWidgets('displays selected time (24-hour)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VDatePicker.time(timeValue: VTimeOfDay(hour: 14, minute: 30)),
        ),
      );

      expect(find.text('14:30'), findsOneWidget);
    });

    testWidgets('displays selected time (12-hour)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VDatePicker.time(
            timeValue: VTimeOfDay(hour: 14, minute: 30),
            use24HourFormat: false,
          ),
        ),
      );

      expect(find.text('2:30 PM'), findsOneWidget);
    });
  });

  group('VDatePicker.dateTime', () {
    testWidgets('default rendering', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VDatePicker.dateTime()));

      expect(find.byType(VDatePicker), findsOneWidget);
    });

    testWidgets('displays selected date+time', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VDatePicker.dateTime(value: DateTime(2024, 12, 25, 14, 30)),
        ),
      );

      expect(find.text('December 25, 2024 14:30'), findsOneWidget);
    });
  });

  group('VDatePicker.range', () {
    testWidgets('default rendering', (tester) async {
      await tester.pumpWidget(buildTestWidget(const VDatePicker.range()));

      expect(find.byType(VDatePicker), findsOneWidget);
    });

    testWidgets('displays selected range', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VDatePicker.range(
            rangeValue: VDateTimeRange(
              start: DateTime(2024, 12, 20),
              end: DateTime(2024, 12, 25),
            ),
          ),
        ),
      );

      expect(
        find.text('December 20, 2024 ~ December 25, 2024'),
        findsOneWidget,
      );
    });
  });

  group('VTimeOfDay', () {
    test('default constructor', () {
      const time = VTimeOfDay(hour: 14, minute: 30);
      expect(time.hour, 14);
      expect(time.minute, 30);
    });

    test('hourOfPeriod', () {
      expect(const VTimeOfDay(hour: 0, minute: 0).hourOfPeriod, 12);
      expect(const VTimeOfDay(hour: 12, minute: 0).hourOfPeriod, 12);
      expect(const VTimeOfDay(hour: 14, minute: 0).hourOfPeriod, 2);
      expect(const VTimeOfDay(hour: 9, minute: 0).hourOfPeriod, 9);
    });

    test('period', () {
      expect(const VTimeOfDay(hour: 9, minute: 0).period, VDayPeriod.am);
      expect(const VTimeOfDay(hour: 14, minute: 0).period, VDayPeriod.pm);
    });

    test('equality', () {
      const time1 = VTimeOfDay(hour: 14, minute: 30);
      const time2 = VTimeOfDay(hour: 14, minute: 30);
      const time3 = VTimeOfDay(hour: 15, minute: 30);

      expect(time1 == time2, true);
      expect(time1 == time3, false);
    });
  });

  group('VDateTimeRange', () {
    test('default constructor', () {
      final range = VDateTimeRange(
        start: DateTime(2024, 12, 20),
        end: DateTime(2024, 12, 25),
      );

      expect(range.start, DateTime(2024, 12, 20));
      expect(range.end, DateTime(2024, 12, 25));
    });

    test('duration', () {
      final range = VDateTimeRange(
        start: DateTime(2024, 12, 20),
        end: DateTime(2024, 12, 25),
      );

      expect(range.duration.inDays, 5);
    });

    test('equality', () {
      final range1 = VDateTimeRange(
        start: DateTime(2024, 12, 20),
        end: DateTime(2024, 12, 25),
      );
      final range2 = VDateTimeRange(
        start: DateTime(2024, 12, 20),
        end: DateTime(2024, 12, 25),
      );
      final range3 = VDateTimeRange(
        start: DateTime(2024, 12, 21),
        end: DateTime(2024, 12, 25),
      );

      expect(range1 == range2, true);
      expect(range1 == range3, false);
    });
  });

  group('VDatePicker interactions', () {
    testWidgets('opens calendar on tap', (tester) async {
      await tester.pumpWidget(
        buildTestWidgetWithOverlay(
          const VDatePicker.date(placeholder: 'Select Date'),
        ),
      );

      // Verify calendar icon
      expect(find.byType(VDatePicker), findsOneWidget);

      // Tap DatePicker to open calendar
      await tester.tap(find.byType(VDatePicker));
      await tester.pumpAndSettle();

      // Verify calendar is open (check month/year header)
      final now = DateTime.now();
      const monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      expect(
        find.text('${monthNames[now.month - 1]} ${now.year}'),
        findsOneWidget,
      );

      // Verify day-of-week headers
      expect(find.text('Sun'), findsOneWidget);
      expect(find.text('Mon'), findsOneWidget);
    });

    testWidgets('date selection test', (tester) async {
      DateTime? selectedDate;

      await tester.pumpWidget(
        buildTestWidgetWithOverlay(
          VDatePicker.date(
            placeholder: 'Select Date',
            onChanged: (date) => selectedDate = date,
          ),
        ),
      );

      // Tap DatePicker to open calendar
      await tester.tap(find.byType(VDatePicker));
      await tester.pumpAndSettle();

      // Select date 15
      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();

      // Verify date is selected
      expect(selectedDate, isNotNull);
      expect(selectedDate!.day, 15);
    });

    testWidgets('onChanged callback invocation test', (tester) async {
      DateTime? callbackDate;
      var callbackCount = 0;

      await tester.pumpWidget(
        buildTestWidgetWithOverlay(
          VDatePicker.date(
            placeholder: 'Select Date',
            onChanged: (date) {
              callbackDate = date;
              callbackCount++;
            },
          ),
        ),
      );

      // Tap DatePicker to open calendar
      await tester.tap(find.byType(VDatePicker));
      await tester.pumpAndSettle();

      // Select date 10
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();

      // Verify callback was called once
      expect(callbackCount, 1);
      expect(callbackDate, isNotNull);
      expect(callbackDate!.day, 10);
    });

    testWidgets('verifies disabled state', (tester) async {
      await tester.pumpWidget(
        buildTestWidgetWithOverlay(
          const VDatePicker.date(placeholder: 'Select Date', enabled: false),
        ),
      );

      // Verify disabled DatePicker renders
      expect(find.byType(VDatePicker), findsOneWidget);

      // Verify Opacity is 0.5 when disabled
      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, 0.5);
    });

    testWidgets('range selection mode test', (tester) async {
      VDateTimeRange? selectedRange;

      await tester.pumpWidget(
        buildTestWidgetWithOverlay(
          VDatePicker.range(
            placeholder: 'Select Period',
            onRangeChanged: (range) => selectedRange = range,
          ),
        ),
      );

      // Tap DatePicker to open calendar
      await tester.tap(find.byType(VDatePicker));
      await tester.pumpAndSettle();

      // Select first date (10)
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();

      // Range is not yet complete
      expect(selectedRange, isNull);

      // Select second date (15)
      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();

      // Verify range is selected
      expect(selectedRange, isNotNull);
      expect(selectedRange!.start.day, 10);
      expect(selectedRange!.end.day, 15);
    });

    testWidgets('verifies readOnly state', (tester) async {
      await tester.pumpWidget(
        buildTestWidgetWithOverlay(
          VDatePicker.date(value: DateTime(2024, 12, 25), readOnly: true),
        ),
      );

      // Verify readOnly DatePicker renders
      expect(find.byType(VDatePicker), findsOneWidget);

      // Verify selected date is displayed
      expect(find.text('December 25, 2024'), findsOneWidget);
    });

    testWidgets('opens calendar and verifies month display', (tester) async {
      await tester.pumpWidget(
        buildTestWidgetWithOverlay(
          VDatePicker.date(value: DateTime(2024, 6, 15)),
        ),
      );

      // Tap DatePicker to open calendar
      await tester.tap(find.byType(VDatePicker));
      await tester.pumpAndSettle();

      // Verify current month
      expect(find.text('June 2024'), findsOneWidget);

      // Verify day-of-week headers
      expect(find.text('Sun'), findsOneWidget);
      expect(find.text('Sat'), findsOneWidget);

      // Verify date 15 is displayed
      expect(find.text('15'), findsOneWidget);

      // Verify month navigation buttons (previous/next) exist
      // VIcons.chevronLeft/chevronRight render as SizedBox > CustomPaint
      // The calendar header has two navigation buttons with CustomPaint icons
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('calendar auto-closes after date selection', (tester) async {
      await tester.pumpWidget(
        buildTestWidgetWithOverlay(
          VDatePicker.date(placeholder: 'Select Date', onChanged: (_) {}),
        ),
      );

      // Tap DatePicker to open calendar
      await tester.tap(find.byType(VDatePicker));
      await tester.pumpAndSettle();

      // Verify calendar is open
      expect(find.text('Sun'), findsOneWidget);

      // Select a date
      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();

      // Verify calendar is closed
      expect(find.text('Sun'), findsNothing);
    });

    testWidgets('non-selectable date test (selectableDayPredicate)', (
      tester,
    ) async {
      DateTime? selectedDate;
      final now = DateTime.now();

      await tester.pumpWidget(
        buildTestWidgetWithOverlay(
          VDatePicker.date(
            value: DateTime(now.year, now.month, 15),
            onChanged: (date) => selectedDate = date,
            // Only even dates are selectable
            selectableDayPredicate: (date) => date.day.isEven,
          ),
        ),
      );

      // Tap DatePicker to open calendar
      await tester.tap(find.byType(VDatePicker));
      await tester.pumpAndSettle();

      // Try selecting odd date (11) - not selectable
      await tester.tap(find.text('11'));
      await tester.pumpAndSettle();

      expect(selectedDate, isNull);

      // Select even date (12) - selectable
      await tester.tap(find.text('12'));
      await tester.pumpAndSettle();

      expect(selectedDate, isNotNull);
      expect(selectedDate!.day, 12);
    });
  });
}
