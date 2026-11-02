import 'package:flutter/services.dart';
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

  group('VDatePicker style fields', () {
    final theme = VThemeData.light();

    // Builds a date picker styled through the theme or as the instance style.
    Widget styled(
      VDatePickerStyle? style, {
      bool viaTheme = false,
      DateTime? value,
      bool enabled = true,
    }) => VTheme(
      data: theme.copyWith(
        componentOverrides: VComponentOverrides([
          if (viaTheme && style != null) style,
        ]),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (_) => Center(
                  child: VDatePicker.date(
                    value: value,
                    placeholder: 'Pick',
                    enabled: enabled,
                    style: viaTheme ? null : style,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    TextStyle? textStyleOf(WidgetTester tester, String text) =>
        tester.widget<Text>(find.text(text)).style;

    // The trigger is the nearest bordered box around the shown text.
    Border triggerBorder(WidgetTester tester, String text) =>
        (tester
                        .widget<Container>(
                          find
                              .ancestor(
                                of: find.text(text),
                                matching: find.byType(Container),
                              )
                              .first,
                        )
                        .decoration!
                    as BoxDecoration)
                .border!
            as Border;

    // Decorations of the boxes around a day number, nearest first.
    List<BoxDecoration> decorationsAround(WidgetTester tester, String day) =>
        tester
            .widgetList<Container>(
              find.ancestor(
                of: find.text(day),
                matching: find.byType(Container),
              ),
            )
            .map((c) => c.decoration)
            .whereType<BoxDecoration>()
            .toList();

    // Asks the picker's own focus node, the one above its popover, for focus.
    Future<void> focusPicker(WidgetTester tester) async {
      Focus.of(tester.element(find.byType(VPopover))).requestFocus();
      await tester.pumpAndSettle();
    }

    Future<void> openCalendar(WidgetTester tester) async {
      await tester.tap(find.byType(VDatePicker));
      await tester.pumpAndSettle();
    }

    testWidgets('defaults to the body style, ring focus and calendar tokens', (
      tester,
    ) async {
      final june = DateTime(2024, 6, 15);
      await tester.pumpWidget(styled(null, value: june));
      final shown = VoloLocalizations.of(
        tester.element(find.byType(VDatePicker)),
      ).fullDate(2024, 6, 15);
      expect(textStyleOf(tester, shown)?.color, theme.colors.foreground);
      expect(textStyleOf(tester, shown)?.fontSize, theme.sizes.md.fontSize);
      expect(triggerBorder(tester, shown).top.color, theme.colors.input);

      await focusPicker(tester);
      expect(triggerBorder(tester, shown).top.color, theme.colors.ring);
      expect(triggerBorder(tester, shown).top.width, 2);

      await openCalendar(tester);
      final selected = decorationsAround(tester, '15');
      expect(selected.first.color, theme.colors.primary);
      expect(
        tester.widget<Text>(find.text('15')).style?.color,
        theme.colors.primaryForeground,
      );
      expect(
        tester.widget<Text>(find.text('14')).style?.color,
        theme.colors.foreground,
      );
    });

    testWidgets('the placeholder stays muted', (tester) async {
      await tester.pumpWidget(
        styled(
          const VDatePickerStyle(
            foregroundColor: Color(0xFF123456),
            textStyle: TextStyle(color: Color(0xFF654321)),
          ),
        ),
      );
      expect(textStyleOf(tester, 'Pick')?.color, theme.colors.mutedForeground);
    });

    testWidgets('Enter on the focused picker opens the calendar', (
      tester,
    ) async {
      await tester.pumpWidget(styled(null, value: DateTime(2024, 6, 15)));
      await focusPicker(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('a disabled picker takes no focus', (tester) async {
      await tester.pumpWidget(styled(null, enabled: false));
      await focusPicker(tester);
      expect(Focus.of(tester.element(find.byType(VPopover))).hasFocus, isFalse);
      expect(triggerBorder(tester, 'Pick').top.color, theme.colors.muted);
      expect(triggerBorder(tester, 'Pick').top.width, 1);
    });

    for (final viaTheme in [true, false]) {
      final via = viaTheme ? 'theme' : 'instance';

      testWidgets('textStyle and foregroundColor style the value ($via)', (
        tester,
      ) async {
        const color = Color(0xFF123456);
        await tester.pumpWidget(
          styled(
            const VDatePickerStyle(
              foregroundColor: color,
              textStyle: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color(0xFFFF0000),
              ),
            ),
            viaTheme: viaTheme,
            value: DateTime(2024, 6, 15),
          ),
        );
        final shown = VoloLocalizations.of(
          tester.element(find.byType(VDatePicker)),
        ).fullDate(2024, 6, 15);
        expect(textStyleOf(tester, shown)?.color, color);
        expect(textStyleOf(tester, shown)?.fontStyle, FontStyle.italic);
        expect(textStyleOf(tester, shown)?.fontSize, theme.sizes.md.fontSize);
      });

      testWidgets('focusBorderColor draws the focused border ($via)', (
        tester,
      ) async {
        const color = Color(0xFF123456);
        await tester.pumpWidget(
          styled(
            const VDatePickerStyle(focusBorderColor: color),
            viaTheme: viaTheme,
          ),
        );
        expect(triggerBorder(tester, 'Pick').top.color, theme.colors.input);

        await focusPicker(tester);
        expect(triggerBorder(tester, 'Pick').top.color, color);
        expect(triggerBorder(tester, 'Pick').top.width, 2);
      });

      testWidgets('calendarStyle colors the calendar in the popover ($via)', (
        tester,
      ) async {
        const selected = Color(0xFF111111);
        const selectedText = Color(0xFF222222);
        const dayText = Color(0xFF333333);
        const fill = Color(0xFF444444);
        const radius = BorderRadius.all(Radius.circular(3));
        await tester.pumpWidget(
          styled(
            const VDatePickerStyle(
              calendarStyle: VCalendarStyle(
                selectedColor: selected,
                selectedForegroundColor: selectedText,
                foregroundColor: dayText,
                backgroundColor: fill,
                borderRadius: radius,
              ),
            ),
            viaTheme: viaTheme,
            value: DateTime(2024, 6, 15),
          ),
        );
        await openCalendar(tester);

        final around = decorationsAround(tester, '15');
        expect(around.first.color, selected);
        expect(
          around.any((d) => d.color == fill && d.borderRadius == radius),
          isTrue,
        );
        expect(tester.widget<Text>(find.text('15')).style?.color, selectedText);
        expect(tester.widget<Text>(find.text('14')).style?.color, dayText);
      });

      testWidgets('calendarStyle.todayColor fills today ($via)', (
        tester,
      ) async {
        const today = Color(0xFF555555);
        await tester.pumpWidget(
          styled(
            const VDatePickerStyle(
              calendarStyle: VCalendarStyle(todayColor: today),
            ),
            viaTheme: viaTheme,
          ),
        );
        await openCalendar(tester);
        expect(
          decorationsAround(tester, '${DateTime.now().day}').first.color,
          today,
        );
      });
    }
  });

  group('VDatePicker closed when disabled or read-only', () {
    // Hosts [child] in an overlay, where the popover opens.
    Widget host(Widget child) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: Overlay(
            initialEntries: [
              OverlayEntry(builder: (_) => Center(child: child)),
            ],
          ),
        ),
      ),
    );

    Future<bool> opensOnTap(
      WidgetTester tester, {
      bool enabled = true,
      bool readOnly = false,
    }) async {
      await tester.pumpWidget(
        host(
          VDatePicker.date(
            placeholder: 'Pick',
            enabled: enabled,
            readOnly: readOnly,
          ),
        ),
      );
      await tester.tap(find.byType(VDatePicker), warnIfMissed: false);
      await tester.pumpAndSettle();
      // The weekday header shows only while the calendar is open.
      return find.text('Sun').evaluate().isNotEmpty;
    }

    testWidgets('an enabled picker opens on tap', (tester) async {
      expect(await opensOnTap(tester), isTrue);
    });

    testWidgets('a disabled picker stays closed on tap', (tester) async {
      expect(await opensOnTap(tester, enabled: false), isFalse);
    });

    testWidgets('a read-only picker stays closed on tap', (tester) async {
      expect(await opensOnTap(tester, readOnly: true), isFalse);
    });
  });
}
