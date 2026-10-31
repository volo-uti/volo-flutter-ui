import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'package:volo_flutter_ui/src/utils/v_debug.dart';
import 'v_checkbox_style.dart';

/// Keys that activate the focused control.
const Map<ShortcutActivator, Intent> _activateShortcuts =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    };

/// Three-step size for the checkbox, radio and switch family.
///
/// Used by [VCheckbox], [VRadio], [VSwitch] and others.
enum VWidgetSize {
  /// Small size.
  sm,

  /// Medium size (default).
  md,

  /// Large size.
  lg,
}

/// Tri-state checkbox with an optional label, also available as a bordered card.
///
/// A `null` [value] shows the indeterminate state. Tapping a checked box reports
/// `false`; any other state reports `true`. Without [onChanged] the checkbox is disabled.
///
/// ```dart
/// VCheckbox(
///   value: isChecked,
///   onChanged: (value) => setState(() => isChecked = value),
///   label: const Text('I agree'),
/// )
/// ```
class VCheckbox extends StatefulWidget {
  /// Creates a plain checkbox.
  const VCheckbox({
    required this.value,
    super.key,
    this.name,
    this.onChanged,
    this.label,
    this.sublabel,
    this.enabled = true,
    this.size = VWidgetSize.md,
    this.style,
  }) : _isCard = false;

  /// Creates a checkbox wrapped in a bordered card.
  const VCheckbox.card({
    required this.value,
    super.key,
    this.name,
    this.onChanged,
    this.label,
    this.sublabel,
    this.enabled = true,
    this.size = VWidgetSize.md,
    this.style,
  }) : _isCard = true;

  /// Key identifying this checkbox in debug logs.
  final String? name;

  /// Check state; `null` means indeterminate.
  final bool? value;

  /// Called with the new state when the user toggles the checkbox.
  final ValueChanged<bool?>? onChanged;

  /// Content shown next to the box; inherits the label text style.
  final Widget? label;

  /// Secondary content below [label]; inherits the muted text style.
  final Widget? sublabel;

  /// Whether the checkbox reacts to input.
  final bool enabled;

  /// Size (sm: 16, md: 20, lg: 24).
  final VWidgetSize size;

  /// Style override merged over the theme's [VCheckboxStyle].
  final VCheckboxStyle? style;

  final bool _isCard;

  @override
  State<VCheckbox> createState() => _VCheckboxState();
}

class _VCheckboxState extends State<VCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _isFocused = false;
  late final FocusNode _focusNode;

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChange);
    _controller = AnimationController(vsync: this);
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      ),
    );

    if ((widget.value ?? false) || widget.value == null) {
      _controller.value = 1.0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _controller.duration = theme.animations.fast;
    _controller.reverseDuration = theme.animations.fast;
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: theme.animations.curveBouncy,
        reverseCurve: theme.animations.curveEaseIn,
      ),
    );
  }

  @override
  void didUpdateWidget(VCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if ((widget.value ?? false) || widget.value == null) {
        unawaited(_controller.forward());
      } else {
        unawaited(_controller.reverse());
      }
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  bool get _isEnabled => widget.enabled && widget.onChanged != null;

  void _handleTap() {
    if (!_isEnabled) return;
    // false -> true, true -> false, null -> true
    final newValue = !(widget.value ?? false);

    VDebug.log(
      category: VDebugCategory.input,
      component: 'VCheckbox',
      name: widget.name,
      action: 'changed',
      value: newValue,
    );

    widget.onChanged?.call(newValue);
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
    final themeStyle = theme.componentOverrides.get<VCheckboxStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    // Checkbox size based on widget.size (token reference)
    final boxSize = switch (widget.size) {
      VWidgetSize.sm => theme.sizes.sm.iconSize,
      VWidgetSize.md => theme.sizes.md.iconSize,
      VWidgetSize.lg => theme.sizes.lg.iconSize,
    };

    // State-dependent colors
    final isChecked = widget.value ?? false;
    final isIndeterminate = widget.value == null;
    final hasValue = isChecked || isIndeterminate;

    var boxColor = hasValue
        ? (widget.enabled ? theme.colors.primary : theme.colors.muted)
        : VColors.transparent;
    // Border color changes on hover
    Color borderColor;
    if (hasValue) {
      borderColor = boxColor;
    } else if (_isHovered && _isEnabled) {
      borderColor = theme.colors.primary;
    } else {
      borderColor = widget.enabled ? theme.colors.input : theme.colors.muted;
    }
    var checkColor = hasValue
        ? theme.colors.primaryForeground
        : VColors.transparent;

    // Apply resolvedStyle overrides
    if (resolvedStyle != null) {
      if (hasValue) {
        boxColor = resolvedStyle.activeColor ?? boxColor;
        borderColor = resolvedStyle.activeColor ?? borderColor;
      } else {
        if (resolvedStyle.borderColor != null && !(_isHovered && _isEnabled)) {
          borderColor = resolvedStyle.borderColor!;
        }
      }
      if (hasValue) {
        checkColor = resolvedStyle.checkColor ?? checkColor;
      }
    }

    // Scale on hover
    final hoverScale = _isHovered && _isEnabled ? 1.1 : 1.0;

    // Checkbox widget
    Widget checkbox = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: hoverScale,
        child: AnimatedContainer(
          duration: theme.animations.fast,
          curve: theme.animations.curveEaseOut,
          width: boxSize,
          height: boxSize,
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: resolvedStyle?.borderRadius ?? theme.radius.smRadius,
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Center(
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: isIndeterminate
                  ? Container(
                      width: boxSize * 0.5,
                      height: 2,
                      color: checkColor,
                    )
                  : CustomPaint(
                      size: Size(boxSize * 0.6, boxSize * 0.6),
                      painter: _CheckPainter(color: checkColor),
                    ),
            ),
          ),
        ),
      ),
    );

    // Compose with Row if label exists
    if (widget.label != null) {
      final labelStyle = theme.typography.bodyMedium.copyWith(
        color: widget.enabled
            ? theme.colors.foreground
            : theme.colors.mutedForeground,
      );
      final sublabelStyle = theme.typography.bodySmall.copyWith(
        color: theme.colors.mutedForeground,
      );

      final labelWidget = DefaultTextStyle.merge(
        style: labelStyle,
        child: widget.label!,
      );
      final sublabelWidget = widget.sublabel == null
          ? null
          : DefaultTextStyle.merge(
              style: sublabelStyle,
              child: widget.sublabel!,
            );

      checkbox = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: theme.spacing.xxs),
            child: checkbox,
          ),
          SizedBox(width: theme.spacing.sm),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                labelWidget,
                if (sublabelWidget != null) ...[
                  SizedBox(height: theme.spacing.xxs),
                  sublabelWidget,
                ],
              ],
            ),
          ),
        ],
      );
    }

    // Card style
    if (widget._isCard) {
      checkbox = Container(
        padding: EdgeInsets.all(theme.spacing.lg),
        decoration: BoxDecoration(
          color: theme.colors.card,
          borderRadius: theme.radius.cardRadius,
          border: Border.all(
            color: isChecked ? theme.colors.primary : theme.colors.border,
          ),
        ),
        child: checkbox,
      );
    }

    // Ensure minimum touch target of 24x24px (WCAG 2.2 SC 2.5.8)
    checkbox = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      child: checkbox,
    );

    // Opacity when disabled
    checkbox = Opacity(opacity: _isEnabled ? 1.0 : 0.5, child: checkbox);

    // MouseRegion + gesture wrapping
    checkbox = MouseRegion(
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: checkbox,
      ),
    );

    // Focus ring for keyboard navigation (WCAG 2.4.7)
    checkbox = FocusableActionDetector(
      focusNode: _focusNode,
      enabled: _isEnabled,
      shortcuts: _activateShortcuts,
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _handleTap();
            return null;
          },
        ),
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: theme.radius.smRadius,
          border: _isFocused
              ? Border.all(color: theme.colors.ring, width: 2)
              : null,
        ),
        child: checkbox,
      ),
    );

    // Semantics (outside the focus detector, so it is the outermost node)
    checkbox = Semantics(
      checked: widget.value ?? false,
      mixed: widget.value == null,
      enabled: _isEnabled,
      child: checkbox,
    );

    return FocusTraversalGroup(child: checkbox);
  }
}

// Paints the check mark.
class _CheckPainter extends CustomPainter {
  _CheckPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(size.width * 0.4, size.height * 0.7)
      ..lineTo(size.width * 0.8, size.height * 0.3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) =>
      color != oldDelegate.color;
}

/// One option of a [VCheckboxGroup], carrying its value, label and enabled flag.
///
/// ```dart
/// VCheckboxItem(value: 'email', label: Text('Email notifications'))
/// ```
class VCheckboxItem<T> {
  /// Creates a checkbox option item.
  const VCheckboxItem({
    required this.value,
    required this.label,
    this.sublabel,
    this.enabled = true,
  });

  /// Value reported in the group's selection when this option is checked.
  final T value;

  /// Content shown next to the checkbox.
  final Widget label;

  /// Secondary content below [label].
  final Widget? sublabel;

  /// Whether this individual option reacts to input.
  final bool enabled;
}

/// Group of [VCheckbox]es that reports the selected values as a `List<T>`.
///
/// ```dart
/// VCheckboxGroup<String>(
///   options: [
///     VCheckboxItem(value: 'email', label: Text('Email')),
///     VCheckboxItem(value: 'sms', label: Text('SMS')),
///     VCheckboxItem(value: 'push', label: Text('Push')),
///   ],
///   values: selectedValues,
///   onChanged: (v) => setState(() => selectedValues = v),
/// )
/// ```
class VCheckboxGroup<T> extends StatelessWidget {
  /// Creates a checkbox group for multi-select.
  const VCheckboxGroup({
    required this.options,
    required this.values,
    this.onChanged,
    this.orientation = Axis.vertical,
    this.size = VWidgetSize.md,
    this.enabled = true,
    this.spacing,
    super.key,
  });

  /// Checkbox option items.
  final List<VCheckboxItem<T>> options;

  /// Currently selected values.
  final List<T> values;

  /// Called with the new selection when any option is toggled.
  final ValueChanged<List<T>>? onChanged;

  /// Layout orientation.
  final Axis orientation;

  /// Size for all checkboxes in the group.
  final VWidgetSize size;

  /// Whether the whole group reacts to input.
  final bool enabled;

  /// Spacing between items.
  ///
  /// Defaults to `theme.spacing.sm` when null.
  final double? spacing;

  void _handleItemChanged(T itemValue, {required bool isSelected}) {
    final newValues = List<T>.of(values);
    if (isSelected) {
      if (!newValues.contains(itemValue)) {
        newValues.add(itemValue);
      }
    } else {
      newValues.remove(itemValue);
    }
    onChanged?.call(newValues);
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final effectiveSpacing = spacing ?? theme.spacing.sm;

    final children = <Widget>[
      for (final option in options)
        VCheckbox(
          value: values.contains(option.value),
          onChanged: (checked) =>
              _handleItemChanged(option.value, isSelected: checked ?? false),
          label: option.label,
          sublabel: option.sublabel,
          enabled: enabled && option.enabled,
          size: size,
        ),
    ];

    if (orientation == Axis.horizontal) {
      return Wrap(
        spacing: effectiveSpacing,
        runSpacing: effectiveSpacing,
        children: children,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1) SizedBox(height: effectiveSpacing),
        ],
      ],
    );
  }
}
