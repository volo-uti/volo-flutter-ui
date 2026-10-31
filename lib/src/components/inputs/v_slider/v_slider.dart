import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'package:volo_flutter_ui/src/utils/v_debug.dart';
import 'v_slider_style.dart';

/// Draggable slider for one value, or two with [VSlider.range].
///
/// Supports tap-to-jump, keyboard steps and optional [divisions]. Without a
/// change callback the slider is disabled.
///
/// ```dart
/// VSlider(
///   value: volume,
///   onChanged: (value) => setState(() => volume = value),
/// )
/// ```
class VSlider extends StatefulWidget {
  /// Creates a slider for a single [value].
  const VSlider({
    required this.value,
    super.key,
    this.name,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.showLabel = false,
    this.enabled = true,
    this.style,
  }) : assert(min < max, 'VSlider: min must be less than max'),
       assert(
         value >= min && value <= max,
         'VSlider: value must be between min and max',
       ),
       assert(
         divisions == null || divisions > 0,
         'VSlider: divisions must be greater than 0',
       ),
       rangeValues = null,
       onRangeChanged = null,
       _isRange = false;

  /// Creates a slider with two thumbs selecting [values].
  ///
  /// ```dart
  /// VSlider.range(
  ///   values: RangeValues(20, 80),
  ///   onRangeChanged: (values) {},
  /// )
  /// ```
  const VSlider.range({
    required RangeValues values,
    super.key,
    this.name,
    this.onRangeChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.showLabel = false,
    this.enabled = true,
    this.style,
  }) : assert(min < max, 'VSlider: min must be less than max'),
       assert(
         divisions == null || divisions > 0,
         'VSlider: divisions must be greater than 0',
       ),
       value = 0.0,
       rangeValues = values,
       onChanged = null,
       _isRange = true;

  /// Key identifying this slider in debug logs.
  final String? name;

  /// Current value of a single slider; unused by [VSlider.range].
  final double value;

  /// Selected range of a [VSlider.range]; `null` for a single slider.
  final RangeValues? rangeValues;

  /// Called with the new value while a single slider moves.
  final ValueChanged<double>? onChanged;

  /// Called with the new range while a [VSlider.range] moves.
  final ValueChanged<RangeValues>? onRangeChanged;

  /// Called with the grabbed thumb's value when a drag starts.
  final ValueChanged<double>? onChangeStart;

  /// Called with the released thumb's value when a drag ends.
  final ValueChanged<double>? onChangeEnd;

  /// Lowest selectable value.
  final double min;

  /// Highest selectable value.
  final double max;

  /// Number of equal steps between [min] and [max]; continuous when `null`.
  final int? divisions;

  /// Whether a bubble with the current value is drawn above each thumb.
  final bool showLabel;

  /// Whether the slider reacts to input.
  final bool enabled;

  /// Style override merged over the theme's [VSliderStyle].
  final VSliderStyle? style;

  final bool _isRange;

  @override
  State<VSlider> createState() => _VSliderState();
}

class _VSliderState extends State<VSlider> with SingleTickerProviderStateMixin {
  bool _isDragging = false;
  bool _isHovered = false;
  bool _isFocused = false;
  int? _activeThumb; // 0: start, 1: end (range only)
  late AnimationController _controller;
  late Animation<double> _thumbScaleAnimation;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _thumbScaleAnimation = Tween<double>(
      begin: 1,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _controller
      ..duration = theme.animations.fast
      ..reverseDuration = theme.animations.fast;
    _thumbScaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: theme.animations.curveEaseOut,
      ),
    );
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      // Tab walks start -> end, so entering the slider starts at the start
      // thumb again.
      if (!_isFocused && !_isDragging) _activeThumb = null;
    });
  }

  bool get _isEnabled =>
      widget.enabled &&
      (widget.onChanged != null || widget.onRangeChanged != null);

  double get _range => widget.max - widget.min;

  double _clamp(double value) => value.clamp(widget.min, widget.max);

  double _snapToGrid(double value) {
    if (widget.divisions == null) return value;
    final step = _range / widget.divisions!;
    // WHY: The grid starts at min, so a min that is not a multiple of the
    // step still lands on its own ticks.
    final snapped = widget.min + ((value - widget.min) / step).round() * step;
    return _clamp(snapped);
  }

  /// Picks the thumb a pointer at [position] grabs: 0 for start, 1 for end.
  ///
  /// When the thumbs overlap, the side the pointer is on decides, so thumbs
  /// that touch can be pulled apart again.
  int _nearestThumb(double position, double startPos, double endPos) {
    final startDist = (position - startPos).abs();
    final endDist = (position - endPos).abs();
    if (startDist < endDist) return 0;
    if (endDist < startDist) return 1;
    return position < startPos ? 0 : 1;
  }

  double _positionToValue(double position, double trackWidth) {
    final ratio = (position / trackWidth).clamp(0.0, 1.0);
    return _clamp(widget.min + ratio * _range);
  }

  double _valueToPosition(double value, double trackWidth) {
    final ratio = (value - widget.min) / _range;
    return ratio * trackWidth;
  }

  void _handleDragStart(DragStartDetails details, double trackWidth) {
    if (!_isEnabled) return;

    setState(() => _isDragging = true);
    unawaited(_controller.forward());

    if (widget._isRange) {
      // Range slider: select the nearest thumb
      final position = details.localPosition.dx;
      final startPos = _valueToPosition(widget.rangeValues!.start, trackWidth);
      final endPos = _valueToPosition(widget.rangeValues!.end, trackWidth);

      _activeThumb = _nearestThumb(position, startPos, endPos);
    }

    widget.onChangeStart?.call(
      widget._isRange
          ? (_activeThumb == 0
                ? widget.rangeValues!.start
                : widget.rangeValues!.end)
          : widget.value,
    );
  }

  void _handleDragUpdate(DragUpdateDetails details, double trackWidth) {
    if (!_isEnabled || !_isDragging) return;

    final position = details.localPosition.dx;
    final newValue = _snapToGrid(_positionToValue(position, trackWidth));

    if (widget._isRange) {
      final current = widget.rangeValues!;
      RangeValues newRange;
      if (_activeThumb == 0) {
        newRange = RangeValues(
          newValue.clamp(widget.min, current.end),
          current.end,
        );
      } else {
        newRange = RangeValues(
          current.start,
          newValue.clamp(current.start, widget.max),
        );
      }
      widget.onRangeChanged?.call(newRange);
    } else {
      widget.onChanged?.call(newValue);
    }
  }

  void _handleDragCancel() {
    if (!_isDragging) return;
    setState(() => _isDragging = false);
    unawaited(_controller.reverse());
    _activeThumb = null;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isEnabled) {
      _handleDragCancel();
      return;
    }

    setState(() => _isDragging = false);
    unawaited(_controller.reverse());

    // Log on drag end
    if (widget._isRange) {
      VDebug.log(
        category: VDebugCategory.input,
        component: 'VSlider',
        name: widget.name,
        action: 'changed',
        value: widget.rangeValues,
      );
    } else {
      VDebug.log(
        category: VDebugCategory.input,
        component: 'VSlider',
        name: widget.name,
        action: 'changed',
        value: widget.value,
      );
    }

    widget.onChangeEnd?.call(
      widget._isRange
          ? (_activeThumb == 0
                ? widget.rangeValues!.start
                : widget.rangeValues!.end)
          : widget.value,
    );

    _activeThumb = null;
  }

  /// Keyboard step size.
  double get _step {
    if (widget.divisions != null) {
      return _range / widget.divisions!;
    }
    return _range * 0.01;
  }

  /// Handle track tap to jump to position (WCAG 2.2 SC 2.5.7).
  ///
  /// Runs on tap up, not on touch down, so a touch that turns into a scroll
  /// or a drag does not move the value first.
  void _handleTapUp(TapUpDetails details, double trackWidth) {
    if (!_isEnabled) return;
    final position = details.localPosition.dx;
    final newValue = _snapToGrid(_positionToValue(position, trackWidth));

    if (widget._isRange) {
      final startPos = _valueToPosition(widget.rangeValues!.start, trackWidth);
      final endPos = _valueToPosition(widget.rangeValues!.end, trackWidth);

      if (_nearestThumb(position, startPos, endPos) == 0) {
        widget.onRangeChanged?.call(
          RangeValues(
            newValue.clamp(widget.min, widget.rangeValues!.end),
            widget.rangeValues!.end,
          ),
        );
        _activeThumb = 0;
      } else {
        widget.onRangeChanged?.call(
          RangeValues(
            widget.rangeValues!.start,
            newValue.clamp(widget.rangeValues!.start, widget.max),
          ),
        );
        _activeThumb = 1;
      }
    } else {
      widget.onChanged?.call(newValue);
    }

    _focusNode.requestFocus();
  }

  /// Handle keyboard events (WCAG 2.2 SC 2.5.7).
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (!_isEnabled) return KeyEventResult.ignored;

    final step = _step;

    if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
        event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _adjustValue(step);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _adjustValue(-step);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.home) {
      _setDirectValue(widget.min);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.end) {
      _setDirectValue(widget.max);
      return KeyEventResult.handled;
    } else if (widget._isRange && event.logicalKey == LogicalKeyboardKey.tab) {
      // WHY: Tab walks start -> end and then leaves the slider; consuming it
      // on every press would trap keyboard focus (WCAG 2.1.2).
      final active = _activeThumb ?? 0;
      final backwards = HardwareKeyboard.instance.isShiftPressed;
      if (!backwards && active == 0) {
        setState(() => _activeThumb = 1);
        return KeyEventResult.handled;
      }
      if (backwards && active == 1) {
        setState(() => _activeThumb = 0);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  /// Adjust value by delta.
  void _adjustValue(double delta) {
    if (widget._isRange) {
      final activeIdx = _activeThumb ?? 0;
      final current = widget.rangeValues!;

      if (activeIdx == 0) {
        final newStart = _snapToGrid(current.start + delta);
        widget.onRangeChanged?.call(
          RangeValues(newStart.clamp(widget.min, current.end), current.end),
        );
      } else {
        final newEnd = _snapToGrid(current.end + delta);
        widget.onRangeChanged?.call(
          RangeValues(current.start, newEnd.clamp(current.start, widget.max)),
        );
      }
    } else {
      widget.onChanged?.call(_clamp(_snapToGrid(widget.value + delta)));
    }
  }

  /// Set value directly.
  void _setDirectValue(double value) {
    if (widget._isRange) {
      final activeIdx = _activeThumb ?? 0;
      final current = widget.rangeValues!;

      if (activeIdx == 0) {
        widget.onRangeChanged?.call(
          RangeValues(value.clamp(widget.min, current.end), current.end),
        );
      } else {
        widget.onRangeChanged?.call(
          RangeValues(current.start, value.clamp(current.start, widget.max)),
        );
      }
    } else {
      widget.onChanged?.call(_clamp(value));
    }
  }

  void _handleMouseEnter(PointerEnterEvent event) {
    if (!_isEnabled) return;
    setState(() => _isHovered = true);
  }

  void _handleMouseExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VSliderStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final trackHeight = resolvedStyle?.trackHeight ?? theme.spacing.sm;
        final thumbSize = theme.sizes.lg.iconSize;

        // Colors
        var activeColor = widget.enabled
            ? theme.colors.primary
            : theme.colors.muted;
        var inactiveColor = theme.colors.muted;
        var thumbColor = theme.colors.background;

        // Apply resolvedStyle overrides
        if (resolvedStyle != null) {
          if (widget.enabled) {
            activeColor = resolvedStyle.activeColor ?? activeColor;
          }
          inactiveColor = resolvedStyle.inactiveColor ?? inactiveColor;
          thumbColor = resolvedStyle.thumbColor ?? thumbColor;
        }

        // Position calculation
        final double thumbPosition;
        final double activeStart;
        final double activeEnd;

        if (widget._isRange) {
          activeStart = _valueToPosition(widget.rangeValues!.start, trackWidth);
          activeEnd = _valueToPosition(widget.rangeValues!.end, trackWidth);
          thumbPosition = 0; // not used for range
        } else {
          thumbPosition = _valueToPosition(widget.value, trackWidth);
          activeStart = 0;
          activeEnd = thumbPosition;
        }

        Widget slider = SizedBox(
          height: thumbSize,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Stack(
              clipBehavior: Clip.none,
              children: [
                // Inactive track
                Positioned(
                  left: 0,
                  right: 0,
                  top: (thumbSize - trackHeight) / 2,
                  child: Container(
                    height: trackHeight,
                    decoration: BoxDecoration(
                      color: inactiveColor,
                      borderRadius: BorderRadius.circular(trackHeight / 2),
                    ),
                  ),
                ),

                // Active track
                Positioned(
                  left: activeStart,
                  top: (thumbSize - trackHeight) / 2,
                  child: Container(
                    width: activeEnd - activeStart,
                    height: trackHeight,
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(trackHeight / 2),
                    ),
                  ),
                ),

                // Thumb(s)
                if (widget._isRange) ...[
                  // Start thumb
                  Positioned(
                    left: activeStart - thumbSize / 2,
                    top: 0,
                    child: _buildThumb(
                      theme,
                      thumbSize,
                      thumbColor,
                      activeColor,
                      isActive: _activeThumb == 0,
                      isHovered: _isHovered,
                      isFocused: _isFocused && (_activeThumb ?? 0) == 0,
                      labelValue: widget.rangeValues!.start,
                    ),
                  ),
                  // End thumb
                  Positioned(
                    left: activeEnd - thumbSize / 2,
                    top: 0,
                    child: _buildThumb(
                      theme,
                      thumbSize,
                      thumbColor,
                      activeColor,
                      isActive: _activeThumb == 1,
                      isHovered: _isHovered,
                      isFocused: _isFocused && (_activeThumb ?? 0) == 1,
                      labelValue: widget.rangeValues!.end,
                    ),
                  ),
                ] else
                  // Single thumb
                  Positioned(
                    left: thumbPosition - thumbSize / 2,
                    top: 0,
                    child: _buildThumb(
                      theme,
                      thumbSize,
                      thumbColor,
                      activeColor,
                      isActive: _isDragging,
                      isHovered: _isHovered,
                      isFocused: _isFocused,
                      labelValue: widget.value,
                    ),
                  ),
              ],
            ),
          ),
        );

        // MouseRegion + gesture wrapping
        slider = MouseRegion(
          onEnter: _handleMouseEnter,
          onExit: _handleMouseExit,
          cursor: _isEnabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          // CONSTRAINT: HitTestBehavior.opaque on the GestureDetector ensures
          // the entire track area (not just the thumb) responds to taps and
          // drags. Without this, users must hit the small thumb precisely.
          child: GestureDetector(
            onTapUp: (details) => _handleTapUp(details, trackWidth),
            onHorizontalDragStart: (details) =>
                _handleDragStart(details, trackWidth),
            onHorizontalDragUpdate: (details) =>
                _handleDragUpdate(details, trackWidth),
            onHorizontalDragEnd: _handleDragEnd,
            onHorizontalDragCancel: _handleDragCancel,
            behavior: HitTestBehavior.opaque,
            child: slider,
          ),
        );

        // Keyboard support (WCAG 2.2 SC 2.5.7)
        slider = Focus(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: slider,
        );

        // Opacity when disabled
        slider = Opacity(opacity: widget.enabled ? 1.0 : 0.5, child: slider);

        // Semantics
        final step = _step;
        final currentLabel = widget._isRange
            ? '${widget.rangeValues!.start.toStringAsFixed(1)} - ${widget.rangeValues!.end.toStringAsFixed(1)}'
            : widget.value.toStringAsFixed(1);
        final increasedLabel = widget._isRange
            ? currentLabel
            : _clamp(_snapToGrid(widget.value + step)).toStringAsFixed(1);
        final decreasedLabel = widget._isRange
            ? currentLabel
            : _clamp(_snapToGrid(widget.value - step)).toStringAsFixed(1);
        return FocusTraversalGroup(
          child: Semantics(
            slider: true,
            value: currentLabel,
            increasedValue: increasedLabel,
            decreasedValue: decreasedLabel,
            enabled: _isEnabled,
            onIncrease: _isEnabled ? () => _adjustValue(step) : null,
            onDecrease: _isEnabled ? () => _adjustValue(-step) : null,
            child: slider,
          ),
        );
      },
    );
  }

  Widget _buildThumb(
    VThemeData theme,
    double size,
    Color thumbColor,
    Color borderColor, {
    required bool isActive,
    required bool isHovered,
    required bool isFocused,
    required double labelValue,
  }) {
    // Animation scale when dragging, slight enlargement on hover
    double scale;
    if (isActive) {
      scale = _thumbScaleAnimation.value;
    } else if (isHovered) {
      scale = 1.1;
    } else {
      scale = 1.0;
    }

    // Slightly thicker border on hover
    final borderWidth = isHovered && !isActive ? 3.0 : 2.0;

    final thumb = Transform.scale(
      scale: scale,
      child: AnimatedContainer(
        duration: theme.animations.fast,
        curve: theme.animations.curveEaseOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: thumbColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: [
            ...theme.shadows.sm,
            // Focus ring (WCAG 2.4.7)
            if (isFocused)
              BoxShadow(
                color: theme.colors.ring.withValues(alpha: 0.5),
                spreadRadius: 3,
              ),
          ],
        ),
      ),
    );

    if (!widget.showLabel) return thumb;

    final text = labelValue == labelValue.roundToDouble()
        ? labelValue.toInt().toString()
        : labelValue.toStringAsFixed(1);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        thumb,
        Positioned(
          left: -size,
          right: -size,
          bottom: size + theme.spacing.xs,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colors.foreground,
                borderRadius: theme.radius.smRadius,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.sm,
                  vertical: theme.spacing.xxs,
                ),
                child: Text(
                  text,
                  style: theme.typography.labelSmall.copyWith(
                    color: theme.colors.background,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Start and end of the range selected by [VSlider.range].
class RangeValues {
  /// Creates a range from [start] to [end].
  const RangeValues(this.start, this.end);

  /// Lower bound of the range.
  final double start;

  /// Upper bound of the range.
  final double end;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RangeValues && start == other.start && end == other.end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'RangeValues($start, $end)';
}
