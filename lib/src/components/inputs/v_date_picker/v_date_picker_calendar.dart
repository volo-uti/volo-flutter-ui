part of 'v_date_picker.dart';

class _VDatePickerState extends State<VDatePicker> {
  static const _kCalendarWidth = 280.0;
  static const _kTimePickerWidth = 200.0;

  final VPopoverController _popoverController = VPopoverController();
  late DateTime _displayMonth;
  DateTime? _rangeStart;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _displayMonth = widget.value ?? DateTime.now();
    _displayMonth = DateTime(_displayMonth.year, _displayMonth.month);
    _popoverController.addListener(_handlePopoverChanged);
  }

  // WHY: A range anchor picked before the popover closed must not survive
  // into the next opening, or the next click would complete a hidden range.
  void _handlePopoverChanged() {
    if (_rangeStart != null && mounted) {
      setState(() => _rangeStart = null);
    }
  }

  String get _displayText {
    switch (widget._mode) {
      case _DatePickerMode.date:
        if (widget.value == null) return widget.placeholder ?? '';
        return _formatDate(widget.value!);
      case _DatePickerMode.time:
        if (widget.timeValue == null) return widget.placeholder ?? '';
        return _formatTime(widget.timeValue!);
      case _DatePickerMode.dateTime:
        if (widget.value == null) return widget.placeholder ?? '';
        return '${_formatDate(widget.value!)} ${_formatTime(VTimeOfDay.fromDateTime(widget.value!))}';
      case _DatePickerMode.range:
        if (widget.rangeValue == null) return widget.placeholder ?? '';
        return '${_formatDate(widget.rangeValue!.start)} ~ ${_formatDate(widget.rangeValue!.end)}';
    }
  }

  String _formatDate(DateTime date) =>
      VoloLocalizations.of(context).fullDate(date.year, date.month, date.day);

  String _formatTime(VTimeOfDay time) {
    if (widget.use24HourFormat) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      final l10n = VoloLocalizations.of(context);
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      return l10n.time12Hour(
        hour,
        time.minute,
        isPm: time.period != VDayPeriod.am,
      );
    }
  }

  bool _isSelectable(DateTime date) {
    // WHY: Cells are midnight dates, so a bound that carries a time of day
    // is compared by its date only (as VCalendar does).
    final first = widget.firstDate;
    if (first != null &&
        date.isBefore(DateTime(first.year, first.month, first.day))) {
      return false;
    }
    final last = widget.lastDate;
    if (last != null &&
        date.isAfter(DateTime(last.year, last.month, last.day))) {
      return false;
    }
    if (widget.selectableDayPredicate != null) {
      return widget.selectableDayPredicate!(date);
    }
    return true;
  }

  void _handleDateSelect(DateTime date) {
    if (!_isSelectable(date)) return;

    if (widget._mode == _DatePickerMode.range) {
      if (_rangeStart == null) {
        setState(() => _rangeStart = date);
      } else {
        final start = date.isBefore(_rangeStart!) ? date : _rangeStart!;
        final end = date.isBefore(_rangeStart!) ? _rangeStart! : date;
        widget.onRangeChanged?.call(VDateTimeRange(start: start, end: end));
        _rangeStart = null;
        _popoverController.hide();
      }
    } else if (widget._mode == _DatePickerMode.dateTime) {
      final current = widget.value ?? DateTime.now();
      final newDate = DateTime(
        date.year,
        date.month,
        date.day,
        current.hour,
        current.minute,
      );
      widget.onChanged?.call(newDate);
    } else {
      widget.onChanged?.call(date);
      _popoverController.hide();
    }
  }

  void _handleTimeSelect(int hour, int minute) {
    if (widget._mode == _DatePickerMode.time) {
      widget.onTimeChanged?.call(VTimeOfDay(hour: hour, minute: minute));
      _popoverController.hide();
    } else if (widget._mode == _DatePickerMode.dateTime) {
      final current = widget.value ?? DateTime.now();
      final newDate = DateTime(
        current.year,
        current.month,
        current.day,
        hour,
        minute,
      );
      widget.onChanged?.call(newDate);
      _popoverController.hide();
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

  @override
  void dispose() {
    _popoverController
      ..removeListener(_handlePopoverChanged)
      ..dispose();
    super.dispose();
  }

  VComponentSize get _sizeToken {
    final theme = VTheme.of(context);
    return switch (widget.size) {
      VDatePickerSize.sm => theme.sizes.sm,
      VDatePickerSize.lg => theme.sizes.lg,
      _ => theme.sizes.md,
    };
  }

  BorderRadius get _borderRadius =>
      BorderRadius.circular(_sizeToken.borderRadius);

  // Enter and Space open and close the calendar of the focused picker.
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.numpadEnter ||
            event.logicalKey == LogicalKeyboardKey.space)) {
      _popoverController.toggle();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VDatePickerStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    final colors = theme.colors;
    final typography = theme.typography;

    final isError = widget.error;
    final isDisabled = !widget.enabled;

    // Keyboard focus draws a thicker border in the focus color (WCAG 2.4.7).
    final isFocused = _hasFocus && !isDisabled;
    Color borderColor;
    if (isDisabled) {
      borderColor = colors.muted;
    } else if (isError) {
      borderColor = colors.destructive;
    } else if (isFocused) {
      borderColor = resolvedStyle?.focusBorderColor ?? colors.ring;
    } else {
      borderColor = resolvedStyle?.borderColor ?? colors.input;
    }

    final sizeToken = _sizeToken;
    final hasValue =
        _displayText.isNotEmpty && _displayText != widget.placeholder;
    // The body type style at the size's font size, then the style's
    // textStyle; foregroundColor wins over its color, and the placeholder
    // stays muted.
    final triggerTextStyle = typography.bodyMedium
        .copyWith(fontSize: sizeToken.fontSize)
        .merge(resolvedStyle?.textStyle)
        .copyWith(
          color: hasValue
              ? resolvedStyle?.foregroundColor ??
                    resolvedStyle?.textStyle?.color ??
                    colors.foreground
              : colors.mutedForeground,
        );

    final Widget trigger = Container(
      height: sizeToken.height,
      padding:
          resolvedStyle?.padding ??
          EdgeInsets.symmetric(horizontal: sizeToken.paddingHorizontal),
      decoration: BoxDecoration(
        color: resolvedStyle?.backgroundColor ?? colors.background,
        border: Border.all(color: borderColor, width: isFocused ? 2 : 1),
        borderRadius: resolvedStyle?.borderRadius ?? _borderRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _displayText,
              style: triggerTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: theme.spacing.sm),
          VIcons.calendar(
            size: sizeToken.iconSize,
            color: colors.mutedForeground,
          ),
        ],
      ),
    );

    Widget content;
    if (widget._mode == _DatePickerMode.time) {
      content = _buildTimePicker(colors, typography);
    } else {
      content = _buildCalendar(
        colors,
        typography,
        resolvedStyle?.calendarStyle,
      );
    }

    // WHY: The picker is one focus stop. Its own node takes the keyboard and
    // draws the focus border, so the popover trigger inside may not take focus.
    Widget picker = Focus(
      canRequestFocus: !isDisabled && !widget.readOnly,
      skipTraversal: isDisabled || widget.readOnly,
      descendantsAreFocusable: false,
      onFocusChange: (focused) {
        if (mounted) setState(() => _hasFocus = focused);
      },
      onKeyEvent: _handleKeyEvent,
      child: VPopover(
        controller: _popoverController,
        position: VPopoverPosition.bottomStart,
        content: content,
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: IgnorePointer(
            ignoring: isDisabled || widget.readOnly,
            child: trigger,
          ),
        ),
      ),
    );

    if (widget.fullWidth) {
      picker = SizedBox(width: double.infinity, child: picker);
    }

    // Delegate label/message/extra rendering via VFormField wrapping
    // WHY: Always wrapped, so the picker keeps its place in the tree when a
    // label or message appears or goes away.
    return FocusTraversalGroup(
      child: VFormField(
        label: widget.label,
        more: widget.more,
        tooltip: widget.tooltip,
        required: widget.required,
        requiredMark: widget.requiredMark,
        helper: widget.helper,
        error: widget.error,
        errorText: widget.errorText,
        success: widget.success,
        successText: widget.successText,
        extra: widget.extra,
        child: picker,
      ),
    );
  }

  Widget _buildCalendar(
    VColors colors,
    VTypography typography,
    VCalendarStyle? calendarStyle,
  ) {
    final theme = VTheme.of(context);
    final daysInMonth = DateTime(
      _displayMonth.year,
      _displayMonth.month + 1,
      0,
    ).day;

    final firstWeekday = DateTime(
      _displayMonth.year,
      _displayMonth.month,
    ).weekday;

    // Start from Sunday (Flutter weekday: 1=Mon, 7=Sun)
    final startOffset = firstWeekday % 7;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final calendarFill = calendarStyle?.backgroundColor;
    final calendarRadius = calendarStyle?.borderRadius;
    return Container(
      width: _kCalendarWidth,
      padding: EdgeInsets.all(theme.spacing.md),
      decoration: calendarFill == null && calendarRadius == null
          ? null
          : BoxDecoration(color: calendarFill, borderRadius: calendarRadius),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _previousMonth,
                child: Container(
                  width: theme.sizes.sm.height,
                  height: theme.sizes.sm.height,
                  alignment: Alignment.center,
                  child: VIcons.chevronLeft(
                    size: theme.sizes.lg.iconSize,
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
                child: Container(
                  width: theme.sizes.sm.height,
                  height: theme.sizes.sm.height,
                  alignment: Alignment.center,
                  child: VIcons.chevronRight(
                    size: theme.sizes.lg.iconSize,
                    color: colors.foreground,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: VTheme.of(context).spacing.sm),
          // Weekday header
          Row(
            children: [7, 1, 2, 3, 4, 5, 6]
                .map(VoloLocalizations.of(context).weekdayShort)
                .map(
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
                )
                .toList(),
          ),
          SizedBox(height: VTheme.of(context).spacing.xs),
          // Date grid
          ...List.generate(
            6,
            (week) => Row(
              children: List.generate(7, (day) {
                final dayNumber = week * 7 + day - startOffset + 1;
                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return Expanded(
                    child: SizedBox(height: theme.sizes.sm.height),
                  );
                }

                final date = DateTime(
                  _displayMonth.year,
                  _displayMonth.month,
                  dayNumber,
                );

                final isToday = date == todayDate;
                final isSelected = _isDateSelected(date);
                final isInRange = _isInRange(date);
                final isSelectable = _isSelectable(date);

                final dateLabel = _formatDate(date);

                return Expanded(
                  child: Semantics(
                    button: true,
                    selected: isSelected,
                    enabled: isSelectable,
                    label: dateLabel,
                    child: GestureDetector(
                      onTap: isSelectable
                          ? () => _handleDateSelect(date)
                          : null,
                      child: Container(
                        height: theme.sizes.sm.height,
                        margin: const EdgeInsets.symmetric(vertical: 1),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? calendarStyle?.selectedColor ?? colors.primary
                              : isInRange
                              ? colors.accent
                              : isToday
                              ? calendarStyle?.todayColor ?? colors.accent
                              : VColors.transparent,
                          borderRadius: VTheme.of(context).radius.xsRadius,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$dayNumber',
                          style: typography.bodySmall.copyWith(
                            color: isSelected
                                ? calendarStyle?.selectedForegroundColor ??
                                      colors.primaryForeground
                                : isSelectable
                                ? calendarStyle?.foregroundColor ??
                                      colors.foreground
                                : colors.mutedForeground,
                            fontWeight: isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Time selection (dateTime mode)
          if (widget._mode == _DatePickerMode.dateTime) ...[
            SizedBox(height: VTheme.of(context).spacing.md),
            _buildTimeSelector(colors, typography),
          ],
        ],
      ),
    );
  }

  bool _isDateSelected(DateTime date) {
    if (widget._mode == _DatePickerMode.range) {
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
        return date == _rangeStart;
      }
      return false;
    } else if (widget.value != null) {
      return date.year == widget.value!.year &&
          date.month == widget.value!.month &&
          date.day == widget.value!.day;
    }
    return false;
  }

  bool _isInRange(DateTime date) {
    if (widget._mode != _DatePickerMode.range || widget.rangeValue == null) {
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

  Widget _buildTimeSelector(VColors colors, VTypography typography) {
    final current = widget.value ?? DateTime.now();
    final hour = current.hour;
    final minute = current.minute;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hour
        _buildTimeSpinner(
          value: hour,
          max: 23,
          colors: colors,
          typography: typography,
          onChanged: (h) => _handleTimeSelect(h, minute),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: VTheme.of(context).spacing.sm,
          ),
          child: Text(
            ':',
            style: typography.titleMedium.copyWith(color: colors.foreground),
          ),
        ),
        // Minute
        _buildTimeSpinner(
          value: minute,
          max: 59,
          step: widget.minuteInterval,
          colors: colors,
          typography: typography,
          onChanged: (m) => _handleTimeSelect(hour, m),
        ),
      ],
    );
  }

  Widget _buildTimePicker(VColors colors, VTypography typography) {
    final current = widget.timeValue ?? VTimeOfDay.now();
    final hour = current.hour;
    final minute = current.minute;

    return Container(
      width: _kTimePickerWidth,
      padding: EdgeInsets.all(VTheme.of(context).spacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hour
          _buildTimeSpinner(
            value: hour,
            max: 23,
            colors: colors,
            typography: typography,
            onChanged: (h) => _handleTimeSelect(h, minute),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: VTheme.of(context).spacing.sm,
            ),
            child: Text(
              ':',
              style: typography.titleMedium.copyWith(color: colors.foreground),
            ),
          ),
          // Minute
          _buildTimeSpinner(
            value: minute,
            max: 59,
            step: widget.minuteInterval,
            colors: colors,
            typography: typography,
            onChanged: (m) => _handleTimeSelect(hour, m),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSpinner({
    required int value,
    required int max,
    required VColors colors,
    required VTypography typography,
    required ValueChanged<int> onChanged,
    int step = 1,
  }) {
    final sizes = VTheme.of(context).sizes;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged((value + step) % (max + 1)),
          // Min 32x32px touch target (WCAG 2.2 SC 2.5.8)
          child: SizedBox(
            width: sizes.sm.height,
            height: sizes.sm.height,
            child: Center(
              child: VIcons.chevronUp(
                size: sizes.xl.iconSize,
                color: colors.foreground,
              ),
            ),
          ),
        ),
        Container(
          width: sizes.lg.height,
          height: sizes.md.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.muted,
            borderRadius: VTheme.of(context).radius.xsRadius,
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: typography.titleMedium.copyWith(color: colors.foreground),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged((value - step + max + 1) % (max + 1)),
          // Min 32x32px touch target (WCAG 2.2 SC 2.5.8)
          child: SizedBox(
            width: sizes.sm.height,
            height: sizes.sm.height,
            child: Center(
              child: VIcons.chevronDown(
                size: sizes.xl.iconSize,
                color: colors.foreground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Hour and minute of a day, used by time mode of [VDatePicker].
class VTimeOfDay {
  /// Creates a time of day.
  const VTimeOfDay({required this.hour, required this.minute});

  /// Current time.
  factory VTimeOfDay.now() {
    final now = DateTime.now();
    return VTimeOfDay(hour: now.hour, minute: now.minute);
  }

  /// Extracts time from a DateTime.
  factory VTimeOfDay.fromDateTime(DateTime time) =>
      VTimeOfDay(hour: time.hour, minute: time.minute);

  /// Hour in 24-hour format, 0 to 23.
  final int hour;

  /// Minute, 0 to 59.
  final int minute;

  /// Hour in 12-hour format.
  int get hourOfPeriod => hour == 0 || hour == 12 ? 12 : hour % 12;

  /// Half of the day a [VTimeOfDay] falls in.
  VDayPeriod get period => hour < 12 ? VDayPeriod.am : VDayPeriod.pm;

  @override
  bool operator ==(Object other) =>
      other is VTimeOfDay && hour == other.hour && minute == other.minute;

  @override
  int get hashCode => hour.hashCode ^ minute.hashCode;

  @override
  String toString() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

/// Half of the day a [VTimeOfDay] falls in.
enum VDayPeriod { am, pm }

/// Inclusive range between two dates.
class VDateTimeRange {
  /// Creates a date range.
  const VDateTimeRange({required this.start, required this.end});

  /// Start date.
  final DateTime start;

  /// End date.
  final DateTime end;

  /// Duration (in days).
  Duration get duration => end.difference(start);

  @override
  bool operator ==(Object other) =>
      other is VDateTimeRange && start == other.start && end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
