import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_checkbox/v_checkbox.dart'
    show VWidgetSize;
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_radio_style.dart';

/// Keys that activate the focused control.
const Map<ShortcutActivator, Intent> _activateShortcuts =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    };

// WHY: Generic type parameter <T> on VRadioItem — supports any value type
// (String, int, enum) without runtime casting. The groupValue comparison
// uses == operator, so T must have proper equality semantics.
/// One option of a [VRadio.group], carrying its value, label and enabled flag.
///
/// ```dart
/// VRadioItem(value: 'email', label: Text('Email'))
/// ```
class VRadioItem<T> {
  /// Creates a radio option item.
  const VRadioItem({
    required this.value,
    required this.label,
    this.sublabel,
    this.enabled = true,
  });

  /// Value reported by the group when this option is picked.
  final T value;

  /// Content shown next to the radio.
  final Widget label;

  /// Secondary content below [label].
  final Widget? sublabel;

  /// Whether this individual option reacts to input.
  final bool enabled;
}

/// Single-selection radio button, or a whole group via [VRadio.group].
///
/// A radio is selected when its [value] equals [groupValue]. Without
/// [onChanged] it is disabled.
///
/// ```dart
/// VRadio<String>(
///   value: 'option1',
///   groupValue: selectedValue,
///   onChanged: (value) => setState(() => selectedValue = value),
///   label: const Text('Option 1'),
/// )
/// ```
class VRadio<T> extends StatefulWidget {
  /// Creates a single radio button.
  const VRadio({
    required this.value,
    super.key,
    this.groupValue,
    this.onChanged,
    this.label,
    this.sublabel,
    this.enabled = true,
    this.size = VWidgetSize.md,
    this.style,
  }) : options = null,
       orientation = null,
       spacing = null;

  /// Creates a vertical or horizontal group of radios from [options].
  ///
  /// ```dart
  /// VRadio<String>.group(
  ///   options: [
  ///     VRadioItem(value: 'a', label: Text('Option A')),
  ///     VRadioItem(value: 'b', label: Text('Option B')),
  ///   ],
  ///   groupValue: selected,
  ///   onChanged: (v) => setState(() => selected = v),
  /// )
  /// ```
  const VRadio.group({
    required List<VRadioItem<T>> this.options,
    required this.groupValue,
    this.onChanged,
    this.orientation = Axis.vertical,
    this.size = VWidgetSize.md,
    this.enabled = true,
    this.spacing,
    this.style,
    super.key,
  }) : value = null,
       label = null,
       sublabel = null;

  /// Value this radio stands for; `null` in group mode.
  final T? value;

  /// Currently selected value of the radio set.
  final T? groupValue;

  /// Called with the picked value when an unselected radio is tapped.
  final ValueChanged<T?>? onChanged;

  /// Content shown next to the radio; unused in group mode.
  final Widget? label;

  /// Secondary content below [label]; unused in group mode.
  final Widget? sublabel;

  /// Whether the radio (or the whole group) reacts to input.
  final bool enabled;

  /// Size (sm: 16, md: 20, lg: 24).
  final VWidgetSize size;

  /// Options of the group; `null` for a single radio.
  final List<VRadioItem<T>>? options;

  /// Layout direction in group mode.
  final Axis? orientation;

  /// Spacing between items in group mode.
  ///
  /// Defaults to `theme.spacing.sm` when null.
  final double? spacing;

  /// Style override merged over the theme's [VRadioStyle].
  final VRadioStyle? style;

  @override
  State<VRadio<T>> createState() => _VRadioState<T>();
}

class _VRadioState<T> extends State<VRadio<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _isFocused = false;
  late final FocusNode _focusNode;

  bool get _isGroupMode => widget.options != null;

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChange);
    _controller = AnimationController(vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    if (!_isGroupMode && _isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _controller.duration = theme.animations.fast;
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: theme.animations.curveBouncy),
    );
  }

  @override
  void didUpdateWidget(VRadio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isGroupMode) {
      final wasSelected = oldWidget.value == oldWidget.groupValue;
      if (_isSelected != wasSelected) {
        if (_isSelected) {
          unawaited(_controller.forward());
        } else {
          unawaited(_controller.reverse());
        }
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

  bool get _isSelected => widget.value == widget.groupValue;

  bool get _isEnabled => widget.enabled && widget.onChanged != null;

  void _handleTap() {
    if (!_isEnabled) return;
    if (!_isSelected) {
      widget.onChanged?.call(widget.value);
    }
  }

  void _handleMouseEnter(PointerEnterEvent event) {
    if (!_isEnabled) return;
    setState(() => _isHovered = true);
  }

  void _handleMouseExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
  }

  /// Builds group layout with multiple radio options.
  Widget _buildGroup(BuildContext context) {
    final theme = VTheme.of(context);
    final options = widget.options!;
    final effectiveSpacing = widget.spacing ?? theme.spacing.sm;

    final children = <Widget>[
      for (final option in options)
        VRadio<T>(
          value: option.value,
          groupValue: widget.groupValue,
          onChanged: widget.onChanged,
          label: option.label,
          sublabel: option.sublabel,
          enabled: widget.enabled && option.enabled,
          size: widget.size,
          style: widget.style,
        ),
    ];

    if (widget.orientation == Axis.horizontal) {
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

  @override
  Widget build(BuildContext context) {
    // Group mode: delegate to individual VRadio instances
    if (_isGroupMode) {
      return _buildGroup(context);
    }

    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VRadioStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    // Radio size based on widget.size (token reference)
    final radioSize = switch (widget.size) {
      VWidgetSize.sm => theme.sizes.sm.iconSize,
      VWidgetSize.md => theme.sizes.md.iconSize,
      VWidgetSize.lg => theme.sizes.lg.iconSize,
    };
    final innerSize = radioSize * 0.5;

    // State-dependent colors
    Color borderColor;
    if (_isSelected) {
      borderColor = widget.enabled ? theme.colors.primary : theme.colors.muted;
    } else if (_isHovered && _isEnabled) {
      borderColor = theme.colors.primary;
    } else {
      borderColor = widget.enabled ? theme.colors.input : theme.colors.muted;
    }
    var innerColor = widget.enabled ? theme.colors.primary : theme.colors.muted;

    // Apply resolvedStyle overrides
    if (resolvedStyle != null) {
      if (_isSelected) {
        borderColor = resolvedStyle.activeColor ?? borderColor;
      } else if (!(_isHovered && _isEnabled)) {
        borderColor = resolvedStyle.borderColor ?? borderColor;
      }
      innerColor =
          resolvedStyle.dotColor ?? resolvedStyle.activeColor ?? innerColor;
    }

    // Scale on hover
    final hoverScale = _isHovered && _isEnabled ? 1.1 : 1.0;

    // Radio widget
    Widget radio = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: hoverScale,
        child: AnimatedContainer(
          duration: theme.animations.fast,
          curve: theme.animations.curveEaseOut,
          width: radioSize,
          height: radioSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Center(
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: innerSize,
                height: innerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: innerColor,
                ),
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

      radio = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: theme.spacing.xxs),
            child: radio,
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

    // Ensure minimum touch target of 24x24px (WCAG 2.2 SC 2.5.8)
    radio = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      child: radio,
    );

    // Opacity when disabled
    radio = Opacity(opacity: _isEnabled ? 1.0 : 0.5, child: radio);

    // MouseRegion + gesture wrapping
    radio = MouseRegion(
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: radio,
      ),
    );

    // Focus ring for keyboard navigation (WCAG 2.4.7)
    radio = FocusableActionDetector(
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
        child: radio,
      ),
    );

    // Semantics (outside the focus detector, so it is the outermost node)
    radio = Semantics(
      inMutuallyExclusiveGroup: true,
      checked: _isSelected,
      selected: _isSelected,
      enabled: _isEnabled,
      child: radio,
    );

    return FocusTraversalGroup(child: radio);
  }
}
