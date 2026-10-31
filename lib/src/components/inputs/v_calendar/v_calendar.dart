import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_date_picker/v_date_picker.dart'
    show VDateTimeRange;
import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_calendar_style.dart';

/// Returns whether a day can be selected in a calendar or date picker.
typedef VSelectableDayPredicate = bool Function(DateTime day);

/// Dated event shown as a colored dot under its day in [VCalendar].
///
/// ```dart
/// VCalendarEvent(
///   id: '1',
///   date: DateTime(2024, 12, 25),
///   title: 'Christmas',
///   color: const Color(0xFFEF4444),
/// )
/// ```
class VCalendarEvent {
  /// Creates a calendar event.
  const VCalendarEvent({
    required this.id,
    required this.date,
    this.title,
    this.color,
    this.data,
  });

  /// Identifier that, with [date], defines equality.
  final String id;

  /// Day the dot is drawn under.
  final DateTime date;

  /// Short description of the event.
  final String? title;

  /// Dot color; defaults to the theme's primary color.
  final Color? color;

  /// Arbitrary payload carried with the event, not used by the calendar.
  final Object? data;

  @override
  bool operator ==(Object other) =>
      other is VCalendarEvent && id == other.id && date == other.date;

  @override
  int get hashCode => id.hashCode ^ date.hashCode;
}

/// Month grid for picking one date, a range or several dates, with event dots.
///
///
/// **Variants:**
///
/// - [VCalendar] - Single date selection
/// - [VCalendar.range] - Date range selection
/// - [VCalendar.multiple] - Multiple date selection
///
/// **Basic Usage:**
///
/// ```dart
/// VCalendar(
///   value: selectedDate,
///   onChanged: (date) => setState(() => selectedDate = date),
/// )
/// ```
///
/// **With Events:**
///
/// ```dart
/// VCalendar(
///   value: selectedDate,
///   onChanged: (date) => setState(() => selectedDate = date),
///   events: [
///     VCalendarEvent(id: '1', date: DateTime(2024, 12, 25), title: 'Christmas'),
///   ],
/// )
/// ```
class VCalendar extends StatefulWidget {
  /// Single date selection.
  const VCalendar({
    super.key,
    this.value,
    this.onChanged,
    this.initialMonth,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.events,
    this.showWeekNumbers = false,
    this.showOutsideDays = true,
    this.weekStartsOnMonday = false,
    this.enabled = true,
    this.style,
  }) : _mode = _CalendarMode.single,
       rangeValue = null,
       onRangeChanged = null,
       values = null,
       onValuesChanged = null,
       maxSelections = null;

  /// Date range selection.
  const VCalendar.range({
    super.key,
    this.rangeValue,
    this.onRangeChanged,
    this.initialMonth,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.events,
    this.showWeekNumbers = false,
    this.showOutsideDays = true,
    this.weekStartsOnMonday = false,
    this.enabled = true,
    this.style,
  }) : _mode = _CalendarMode.range,
       value = null,
       onChanged = null,
       values = null,
       onValuesChanged = null,
       maxSelections = null;

  /// Multiple date selection.
  const VCalendar.multiple({
    super.key,
    this.values,
    this.onValuesChanged,
    this.maxSelections,
    this.initialMonth,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.events,
    this.showWeekNumbers = false,
    this.showOutsideDays = true,
    this.weekStartsOnMonday = false,
    this.enabled = true,
    this.style,
  }) : _mode = _CalendarMode.multiple,
       value = null,
       onChanged = null,
       rangeValue = null,
       onRangeChanged = null;

  final _CalendarMode _mode;

  /// Selected date in single mode.
  final DateTime? value;

  /// Called with the tapped date, or null when the selected date is tapped again.
  final ValueChanged<DateTime?>? onChanged;

  /// Selected range in range mode.
  final VDateTimeRange? rangeValue;

  /// Called with the completed range once both ends are chosen.
  final ValueChanged<VDateTimeRange?>? onRangeChanged;

  /// Selected dates in multiple mode.
  final List<DateTime>? values;

  /// Called with the updated list when a date is toggled.
  final ValueChanged<List<DateTime>>? onValuesChanged;

  /// Most dates that can be selected at once; null for no limit.
  final int? maxSelections;

  /// Month shown first; defaults to the selected date or today.
  final DateTime? initialMonth;

  /// Earliest selectable date.
  final DateTime? firstDate;

  /// Latest selectable date.
  final DateTime? lastDate;

  /// Returns whether a day can be selected, e.g. to block weekends.
  final VSelectableDayPredicate? selectableDayPredicate;

  /// Events drawn as dots under their days.
  final List<VCalendarEvent>? events;

  /// Whether a week-number column is shown.
  final bool showWeekNumbers;

  /// Whether days of the neighboring months fill the grid edges.
  final bool showOutsideDays;

  /// Whether weeks start on Monday instead of Sunday.
  final bool weekStartsOnMonday;

  /// Whether dates can be selected. When false the grid is dimmed and ignores taps.
  final bool enabled;

  /// Style override.
  final VCalendarStyle? style;

  @override
  State<VCalendar> createState() => _VCalendarState();
}

enum _CalendarMode { single, range, multiple }

class _VCalendarState extends State<VCalendar> {
  late DateTime _displayMonth;
  DateTime? _rangeStart;

  @override
  void initState() {
    super.initState();
    _displayMonth =
        widget.initialMonth ??
        widget.value ??
        widget.rangeValue?.start ??
        widget.values?.firstOrNull ??
        DateTime.now();
    _displayMonth = DateTime(_displayMonth.year, _displayMonth.month);
  }

  bool _isSelectable(DateTime date) {
    if (widget.firstDate != null) {
      final first = DateTime(
        widget.firstDate!.year,
        widget.firstDate!.month,
        widget.firstDate!.day,
      );
      if (date.isBefore(first)) return false;
    }
    if (widget.lastDate != null) {
      final last = DateTime(
        widget.lastDate!.year,
        widget.lastDate!.month,
        widget.lastDate!.day,
      );
      if (date.isAfter(last)) return false;
    }
    if (widget.selectableDayPredicate != null) {
      return widget.selectableDayPredicate!(date);
    }
    return true;
  }

  void _handleDateSelect(DateTime date) {
    if (!_isSelectable(date) || !widget.enabled) return;

    switch (widget._mode) {
      case _CalendarMode.single:
        final currentValue = widget.value;
        if (currentValue != null &&
            currentValue.year == date.year &&
            currentValue.month == date.month &&
            currentValue.day == date.day) {
          widget.onChanged?.call(null);
        } else {
          widget.onChanged?.call(date);
        }

      case _CalendarMode.range:
        if (_rangeStart == null) {
          setState(() => _rangeStart = date);
        } else {
          final start = date.isBefore(_rangeStart!) ? date : _rangeStart!;
          final end = date.isBefore(_rangeStart!) ? _rangeStart! : date;
          widget.onRangeChanged?.call(VDateTimeRange(start: start, end: end));
          setState(() => _rangeStart = null);
        }

      case _CalendarMode.multiple:
        final currentValues = List<DateTime>.from(widget.values ?? []);
        final existingIndex = currentValues.indexWhere(
          (d) =>
              d.year == date.year && d.month == date.month && d.day == date.day,
        );

        if (existingIndex >= 0) {
          currentValues.removeAt(existingIndex);
        } else {
          if (widget.maxSelections != null &&
              currentValues.length >= widget.maxSelections!) {
            return;
          }
          currentValues.add(date);
        }
        widget.onValuesChanged?.call(currentValues);
    }
  }

  void _previousMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1);
    });
  }

  List<VCalendarEvent> _getEventsForDate(DateTime date) {
    if (widget.events == null) return [];
    return widget.events!
        .where(
          (e) =>
              e.date.year == date.year &&
              e.date.month == date.month &&
              e.date.day == date.day,
        )
        .toList();
  }

  bool _isDateSelected(DateTime date) {
    switch (widget._mode) {
      case _CalendarMode.single:
        if (widget.value == null) return false;
        return date.year == widget.value!.year &&
            date.month == widget.value!.month &&
            date.day == widget.value!.day;

      case _CalendarMode.range:
        if (widget.rangeValue != null) {
          final start = DateTime(
            widget.rangeValue!.start.year,
            widget.rangeValue!.start.month,
            widget.rangeValue!.start.day,
          );
          final end = DateTime(
            widget.rangeValue!.end.year,
            widget.rangeValue!.end.month,
            widget.rangeValue!.end.day,
          );
          return date == start || date == end;
        }
        if (_rangeStart != null) {
          return date.year == _rangeStart!.year &&
              date.month == _rangeStart!.month &&
              date.day == _rangeStart!.day;
        }
        return false;

      case _CalendarMode.multiple:
        if (widget.values == null) return false;
        return widget.values!.any(
          (d) =>
              d.year == date.year && d.month == date.month && d.day == date.day,
        );
    }
  }

  bool _isInRange(DateTime date) {
    if (widget._mode != _CalendarMode.range || widget.rangeValue == null) {
      return false;
    }
    final start = DateTime(
      widget.rangeValue!.start.year,
      widget.rangeValue!.start.month,
      widget.rangeValue!.start.day,
    );
    final end = DateTime(
      widget.rangeValue!.end.year,
      widget.rangeValue!.end.month,
      widget.rangeValue!.end.day,
    );
    return date.isAfter(start) && date.isBefore(end);
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year);
    final daysDifference = date.difference(firstDayOfYear).inDays;
    return ((daysDifference + firstDayOfYear.weekday) / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VCalendarStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    final colors = theme.colors;
    final typography = theme.typography;

    final daysInMonth = DateTime(
      _displayMonth.year,
      _displayMonth.month + 1,
      0,
    ).day;

    final firstDayOfMonth = DateTime(_displayMonth.year, _displayMonth.month);

    // Calculate week start day offset
    int startOffset;
    if (widget.weekStartsOnMonday) {
      startOffset = (firstDayOfMonth.weekday - 1) % 7;
    } else {
      startOffset = firstDayOfMonth.weekday % 7;
    }

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final l10n = VoloLocalizations.of(context);
    final weekdays =
        (widget.weekStartsOnMonday
                ? [1, 2, 3, 4, 5, 6, 7]
                : [7, 1, 2, 3, 4, 5, 6])
            .map(l10n.weekdayShort)
            .toList();

    // Last day of the previous month
    final prevMonthLastDay = DateTime(
      _displayMonth.year,
      _displayMonth.month,
      0,
    ).day;

    return FocusTraversalGroup(
      child: Opacity(
        opacity: widget.enabled ? 1.0 : 0.5,
        child: IgnorePointer(
          ignoring: !widget.enabled,
          child: Container(
            padding: EdgeInsets.all(theme.spacing.md),
            decoration: BoxDecoration(
              color: resolvedStyle?.backgroundColor ?? colors.background,
              border: Border.all(color: colors.border),
              borderRadius:
                  resolvedStyle?.borderRadius ?? theme.radius.mdRadius,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                _buildHeader(colors, typography),
                SizedBox(height: theme.spacing.sm),
                // Weekday header
                Row(
                  children: [
                    if (widget.showWeekNumbers)
                      SizedBox(
                        width: theme.sizes.sm.height,
                        child: Center(
                          child: Text(
                            '#',
                            style: typography.bodySmall.copyWith(
                              color: colors.mutedForeground,
                            ),
                          ),
                        ),
                      ),
                    ...weekdays.map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: typography.bodySmall.copyWith(
                              color: colors.mutedForeground,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: theme.spacing.xs),
                // Date grid
                ...List.generate(6, (week) {
                  final firstDayInWeek = DateTime(
                    _displayMonth.year,
                    _displayMonth.month,
                    1 + (week * 7) - startOffset,
                  );

                  return Row(
                    children: [
                      if (widget.showWeekNumbers)
                        SizedBox(
                          width: theme.sizes.sm.height,
                          height: 36,
                          child: Center(
                            child: Text(
                              '${_getWeekNumber(firstDayInWeek)}',
                              style: typography.bodySmall.copyWith(
                                color: colors.mutedForeground,
                                fontSize: theme.typography.labelSmall.fontSize,
                              ),
                            ),
                          ),
                        ),
                      ...List.generate(7, (day) {
                        final dayNumber = week * 7 + day - startOffset + 1;

                        DateTime date;
                        var isOutsideMonth = false;

                        if (dayNumber < 1) {
                          // Previous month
                          date = DateTime(
                            _displayMonth.year,
                            _displayMonth.month - 1,
                            prevMonthLastDay + dayNumber,
                          );
                          isOutsideMonth = true;
                        } else if (dayNumber > daysInMonth) {
                          // Next month
                          date = DateTime(
                            _displayMonth.year,
                            _displayMonth.month + 1,
                            dayNumber - daysInMonth,
                          );
                          isOutsideMonth = true;
                        } else {
                          date = DateTime(
                            _displayMonth.year,
                            _displayMonth.month,
                            dayNumber,
                          );
                        }

                        if (isOutsideMonth && !widget.showOutsideDays) {
                          return const Expanded(child: SizedBox(height: 36));
                        }

                        return Expanded(
                          child: _buildDayCell(
                            date: date,
                            isOutsideMonth: isOutsideMonth,
                            isToday: date == todayDate,
                            colors: colors,
                            typography: typography,
                            styleOverride: resolvedStyle,
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(VColors colors, VTypography typography) {
    final sizes = VTheme.of(context).sizes;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _previousMonth,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: sizes.sm.height,
            height: sizes.sm.height,
            alignment: Alignment.center,
            child: VIcons.chevronLeft(
              size: sizes.lg.iconSize,
              color: colors.foreground,
            ),
          ),
        ),
        Text(
          VoloLocalizations.of(
            context,
          ).monthYear(_displayMonth.year, _displayMonth.month),
          style: typography.titleSmall.copyWith(color: colors.foreground),
        ),
        GestureDetector(
          onTap: _nextMonth,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: sizes.sm.height,
            height: sizes.sm.height,
            alignment: Alignment.center,
            child: VIcons.chevronRight(
              size: sizes.lg.iconSize,
              color: colors.foreground,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayCell({
    required DateTime date,
    required bool isOutsideMonth,
    required bool isToday,
    required VColors colors,
    required VTypography typography,
    VCalendarStyle? styleOverride,
  }) {
    final isSelected = _isDateSelected(date);
    final isInRange = _isInRange(date);
    final isSelectable = _isSelectable(date);
    final events = _getEventsForDate(date);

    Color backgroundColor;
    if (isSelected) {
      backgroundColor = styleOverride?.selectedColor ?? colors.primary;
    } else if (isInRange) {
      backgroundColor = colors.accent;
    } else if (isToday && !isOutsideMonth) {
      backgroundColor = styleOverride?.todayColor ?? colors.accent;
    } else {
      backgroundColor = VColors.transparent;
    }

    Color textColor;
    if (isSelected) {
      textColor =
          styleOverride?.selectedForegroundColor ?? colors.primaryForeground;
    } else if (isOutsideMonth) {
      textColor = colors.mutedForeground.withValues(alpha: 0.4);
    } else if (!isSelectable) {
      textColor = colors.mutedForeground;
    } else {
      textColor = styleOverride?.foregroundColor ?? colors.foreground;
    }

    final dateLabel = VoloLocalizations.of(
      context,
    ).fullDate(date.year, date.month, date.day);

    return Semantics(
      button: true,
      selected: isSelected,
      enabled: isSelectable && !isOutsideMonth,
      label: dateLabel,
      child: GestureDetector(
        onTap: isSelectable && !isOutsideMonth
            ? () => _handleDateSelect(date)
            : null,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 36,
          margin: const EdgeInsets.symmetric(vertical: 1),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: VTheme.of(context).radius.xsRadius,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '${date.day}',
                style: typography.bodySmall.copyWith(
                  color: textColor,
                  fontWeight: isToday && !isOutsideMonth
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              // Event indicators
              if (events.isNotEmpty)
                Positioned(
                  bottom: 2,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: events
                        .take(3)
                        .map(
                          (event) => Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: event.color ?? colors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
