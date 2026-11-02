import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'package:volo_flutter_ui/src/utils/v_debug.dart';
import 'v_toggle_button_style.dart';

/// Keys that activate the focused control.
const Map<ShortcutActivator, Intent> _activateShortcuts =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    };

/// Visual style of a [VToggleButton] or [VToggleButtonGroup] while unselected.
enum VToggleButtonType {
  /// Filled background.
  filled,

  /// No background (default).
  ghost,

  /// Bordered style.
  outlined,
}

/// Five-step size of a [VToggleButton] or [VToggleButtonGroup].
enum VToggleButtonSize {
  /// Extra small (24px).
  xs,

  /// Small (32px).
  sm,

  /// Medium (40px) - default.
  md,

  /// Large (48px).
  lg,

  /// Extra large (56px).
  xl,
}

/// Standalone on/off button that is drawn selected while [isSelected] is true.
///
/// Without [onChanged] the button is disabled. For a set of related toggles
/// use [VToggleButtonGroup].
///
/// ```dart
/// VToggleButton(
///   isSelected: isBold,
///   onChanged: (value) => setState(() => isBold = value),
///   child: const Icon(Icons.format_bold),
/// )
/// ```
class VToggleButton extends StatefulWidget {
  /// Creates a toggle button showing [child].
  const VToggleButton({
    required this.isSelected,
    required this.child,
    super.key,
    this.name,
    this.onChanged,
    this.enabled = true,
    this.type = VToggleButtonType.ghost,
    this.size,
    this.style,
  });

  /// Key identifying this button in debug logs.
  final String? name;

  /// Whether the button is on and drawn selected.
  final bool isSelected;

  /// Content of the button; inherits the button's text and icon style.
  final Widget child;

  /// Called with the new state when the user taps the button.
  final ValueChanged<bool>? onChanged;

  /// Whether the button reacts to input.
  final bool enabled;

  /// Look of the button while it is off.
  final VToggleButtonType type;

  /// Button size; defaults to medium.
  final VToggleButtonSize? size;

  /// Style override merged over the theme's [VToggleButtonStyle].
  final VToggleButtonStyle? style;

  @override
  State<VToggleButton> createState() => _VToggleButtonState();
}

class _VToggleButtonState extends State<VToggleButton>
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
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _controller.duration = theme.animations.fast;
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
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

  bool get _isEnabled => widget.enabled && widget.onChanged != null;

  void _handleTapDown(TapDownDetails details) {
    if (!_isEnabled) return;
    unawaited(_controller.forward());
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isEnabled) return;
    unawaited(_controller.reverse());
  }

  void _handleTapCancel() {
    if (!_isEnabled) return;
    unawaited(_controller.reverse());
  }

  void _handleTap() {
    if (!_isEnabled) return;
    final newValue = !widget.isSelected;

    VDebug.log(
      category: VDebugCategory.input,
      component: 'VToggleButton',
      name: widget.name,
      action: 'toggled',
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
    final themeStyle = theme.componentOverrides.get<VToggleButtonStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    // Size
    final sizeToken = switch (widget.size) {
      VToggleButtonSize.xs => theme.sizes.xs,
      VToggleButtonSize.sm => theme.sizes.sm,
      VToggleButtonSize.lg => theme.sizes.lg,
      VToggleButtonSize.xl => theme.sizes.xl,
      _ => theme.sizes.md,
    };
    final height = sizeToken.height;
    final padding = sizeToken.paddingHorizontal;

    // Style
    Color backgroundColor;
    Color foregroundColor;
    BoxBorder? border;

    if (widget.isSelected) {
      backgroundColor = theme.colors.accent;
      foregroundColor = theme.colors.accentForeground;
      border = null;
    } else {
      switch (widget.type) {
        case VToggleButtonType.filled:
          backgroundColor = _isHovered && _isEnabled
              ? theme.colors.secondary
              : theme.colors.muted;
          foregroundColor = theme.colors.foreground;
          border = null;
        case VToggleButtonType.ghost:
          backgroundColor = _isHovered && _isEnabled
              ? theme.colors.accent
              : VColors.transparent;
          foregroundColor = theme.colors.foreground;
          border = null;
        case VToggleButtonType.outlined:
          backgroundColor = _isHovered && _isEnabled
              ? theme.colors.accent
              : VColors.transparent;
          foregroundColor = theme.colors.foreground;
          border = Border.all(
            color: _isHovered && _isEnabled
                ? theme.colors.primary
                : theme.colors.border,
          );
      }
    }

    // Apply resolvedStyle overrides
    if (resolvedStyle != null) {
      if (widget.isSelected) {
        backgroundColor =
            resolvedStyle.selectedBackgroundColor ?? backgroundColor;
        foregroundColor =
            resolvedStyle.selectedForegroundColor ?? foregroundColor;
      } else {
        backgroundColor = resolvedStyle.backgroundColor ?? backgroundColor;
        foregroundColor = resolvedStyle.foregroundColor ?? foregroundColor;
      }
      if (resolvedStyle.borderColor != null) {
        border = Border.all(color: resolvedStyle.borderColor!);
      }
    }

    final textStyle = TextStyle(
      fontSize: sizeToken.fontSize,
      fontWeight: FontWeight.w500,
      color: foregroundColor,
    );

    // The focus ring follows the same corners as the button.
    final borderRadius =
        resolvedStyle?.borderRadius ??
        BorderRadius.circular(sizeToken.borderRadius);

    Widget toggle = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: AnimatedContainer(
          duration: theme.animations.fast,
          height: height,
          padding:
              resolvedStyle?.padding ??
              EdgeInsets.symmetric(horizontal: padding),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            border: border,
          ),
          child: Center(
            child: IconTheme(
              data: IconThemeData(
                color: foregroundColor,
                size: sizeToken.iconSize,
              ),
              child: DefaultTextStyle.merge(
                style: textStyle,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );

    // WCAG 2.5.8: Minimum touch target 24x24
    toggle = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      child: toggle,
    );

    // Opacity when disabled
    toggle = Opacity(opacity: _isEnabled ? 1.0 : 0.5, child: toggle);

    // MouseRegion + gesture wrapping
    toggle = MouseRegion(
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: toggle,
      ),
    );

    // Focus ring for keyboard navigation (WCAG 2.4.7)
    toggle = FocusableActionDetector(
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
          borderRadius: borderRadius,
          border: _isFocused
              ? Border.all(color: theme.colors.ring, width: 2)
              : null,
        ),
        child: toggle,
      ),
    );

    // Semantics (outside the focus detector, so it is the outermost node)
    toggle = Semantics(
      toggled: widget.isSelected,
      enabled: _isEnabled,
      child: toggle,
    );

    return FocusTraversalGroup(child: toggle);
  }
}

/// One option of a [VToggleButtonGroup], shown as an [icon] or a [label].
class VToggleButtonItem<T> {
  /// Creates a toggle button option.
  const VToggleButtonItem({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
    this.semanticLabel,
  });

  /// Value reported when this option is selected.
  final T value;

  /// Content of the option; replaced by [icon] when one is given.
  final Widget label;

  /// Icon shown instead of [label].
  final Widget? icon;

  /// Whether this option reacts to input.
  final bool enabled;

  /// Name screen readers announce for this option.
  ///
  /// Defaults to the text of a `Text` [label] when [icon] replaces it, and to
  /// the label's own semantics otherwise.
  final String? semanticLabel;
}

/// Segmented row of [VToggleButtonItem]s selecting one value or several.
///
/// Each option is a focus stop that Enter or Space toggles. Screen readers hear
/// a button that is selected in a single-choice group or toggled with
/// [allowMultiple].
///
/// ```dart
/// VToggleButtonGroup<String>(
///   value: viewMode,
///   items: [
///     VToggleButtonItem(
///       value: 'grid',
///       label: Text('Grid'),
///       icon: Icon(Icons.grid_view),
///     ),
///     VToggleButtonItem(
///       value: 'list',
///       label: Text('List'),
///       icon: Icon(Icons.list),
///     ),
///   ],
///   onChanged: (mode) => setState(() => viewMode = mode),
/// )
/// ```
class VToggleButtonGroup<T> extends StatelessWidget {
  /// Creates a toggle group; set [allowMultiple] to select several values.
  const VToggleButtonGroup({
    required this.items,
    super.key,
    this.name,
    this.value,
    this.values = const [],
    this.onChanged,
    this.onValuesChanged,
    this.allowMultiple = false,
    this.allowEmpty = true,
    this.type = VToggleButtonType.ghost,
    this.size,
    this.fullWidth = false,
    this.style,
  });

  /// Key identifying this group in debug logs.
  final String? name;

  /// Selected value when [allowMultiple] is false.
  final T? value;

  /// Selected values when [allowMultiple] is true.
  final List<T> values;

  /// Options of the group, in display order.
  final List<VToggleButtonItem<T>> items;

  /// Called with the new value (or `null` when deselected) in single mode.
  final ValueChanged<T?>? onChanged;

  /// Called with the new list in multiple mode.
  final ValueChanged<List<T>>? onValuesChanged;

  /// Whether several options can be selected at once.
  final bool allowMultiple;

  /// Whether the last selected option can be deselected.
  final bool allowEmpty;

  /// Look of the unselected options.
  final VToggleButtonType type;

  /// Option height, text size and icon size; defaults to medium.
  final VToggleButtonSize? size;

  /// Whether the group fills the available width.
  final bool fullWidth;

  /// Style override merged over the theme's [VToggleButtonStyle].
  ///
  /// The same style a single [VToggleButton] reads: its colors and padding
  /// apply to each option, its borderRadius and borderColor to the group.
  final VToggleButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VToggleButtonStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;
    final groupRadius =
        resolvedStyle?.borderRadius ?? BorderRadius.circular(theme.radius.md);
    final borderColor =
        resolvedStyle?.borderColor ??
        (type == VToggleButtonType.outlined ? theme.colors.border : null);

    // Determine height from size token
    final sizeToken = switch (size) {
      VToggleButtonSize.xs => theme.sizes.xs,
      VToggleButtonSize.sm => theme.sizes.sm,
      VToggleButtonSize.lg => theme.sizes.lg,
      VToggleButtonSize.xl => theme.sizes.xl,
      _ => theme.sizes.md,
    };
    return FocusTraversalGroup(
      child: Container(
        decoration: BoxDecoration(
          color: type == VToggleButtonType.filled ? theme.colors.muted : null,
          border: borderColor != null ? Border.all(color: borderColor) : null,
          borderRadius: groupRadius,
        ),
        child: ClipRRect(
          borderRadius: groupRadius,
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = allowMultiple
                  ? values.contains(item.value)
                  : value == item.value;

              // Corner radius: the group's outer corners only
              BorderRadius? borderRadius;
              if (items.length == 1) {
                borderRadius = groupRadius;
              } else if (index == 0) {
                borderRadius = BorderRadius.only(
                  topLeft: groupRadius.topLeft,
                  bottomLeft: groupRadius.bottomLeft,
                );
              } else if (index == items.length - 1) {
                borderRadius = BorderRadius.only(
                  topRight: groupRadius.topRight,
                  bottomRight: groupRadius.bottomRight,
                );
              }

              final itemWidget = _ToggleButtonGroupItem<T>(
                item: item,
                isSelected: isSelected,
                borderRadius: borderRadius,
                sizeToken: sizeToken,
                exclusive: !allowMultiple,
                fullWidth: fullWidth,
                style: resolvedStyle,
                onTap: !item.enabled
                    ? null
                    : () => _handleItemTap(item.value, isSelected),
              );

              return fullWidth ? Expanded(child: itemWidget) : itemWidget;
            }),
          ),
        ),
      ),
    );
  }

  void _handleItemTap(T itemValue, bool isCurrentlySelected) {
    if (allowMultiple) {
      final newValues = List<T>.from(values);
      if (isCurrentlySelected) {
        if (allowEmpty || newValues.length > 1) {
          newValues.remove(itemValue);
        }
      } else {
        newValues.add(itemValue);
      }

      VDebug.log(
        category: VDebugCategory.input,
        component: 'VToggleButtonGroup',
        name: name,
        action: 'selected',
        value: newValues,
      );

      onValuesChanged?.call(newValues);
    } else {
      final newValue = isCurrentlySelected && allowEmpty ? null : itemValue;

      VDebug.log(
        category: VDebugCategory.input,
        component: 'VToggleButtonGroup',
        name: name,
        action: 'selected',
        value: newValue,
      );

      if (isCurrentlySelected) {
        if (allowEmpty) {
          onChanged?.call(null);
        }
      } else {
        onChanged?.call(itemValue);
      }
    }
  }
}

class _ToggleButtonGroupItem<T> extends StatefulWidget {
  const _ToggleButtonGroupItem({
    required this.item,
    required this.isSelected,
    required this.borderRadius,
    required this.sizeToken,
    required this.exclusive,
    required this.onTap,
    this.fullWidth = false,
    this.style,
  });

  final VToggleButtonItem<T> item;
  final bool isSelected;
  final BorderRadius? borderRadius;
  final VComponentSize sizeToken;

  /// Whether only one option of the group can be selected.
  final bool exclusive;
  final VoidCallback? onTap;
  final bool fullWidth;
  final VToggleButtonStyle? style;

  @override
  State<_ToggleButtonGroupItem<T>> createState() =>
      _ToggleButtonGroupItemState<T>();
}

class _ToggleButtonGroupItemState<T> extends State<_ToggleButtonGroupItem<T>> {
  bool _isHovered = false;
  bool _isFocused = false;

  bool get _isEnabled => widget.item.enabled && widget.onTap != null;

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
    final style = widget.style;

    // Colors: the style wins over the tokens, as on a single VToggleButton.
    Color backgroundColor;
    Color foregroundColor;
    if (widget.isSelected) {
      backgroundColor = style?.selectedBackgroundColor ?? theme.colors.accent;
      foregroundColor =
          style?.selectedForegroundColor ?? theme.colors.accentForeground;
    } else {
      backgroundColor =
          style?.backgroundColor ??
          (_isHovered && _isEnabled
              ? theme.colors.accent
              : VColors.transparent);
      foregroundColor = style?.foregroundColor ?? theme.colors.foreground;
    }

    final sizeToken = widget.sizeToken;
    final textStyle = TextStyle(
      fontSize: sizeToken.fontSize,
      fontWeight: FontWeight.w500,
      color: foregroundColor,
    );

    Widget content;
    if (widget.item.icon != null) {
      content = IconTheme(
        data: IconThemeData(color: foregroundColor, size: sizeToken.iconSize),
        child: widget.item.icon!,
      );
    } else {
      content = DefaultTextStyle.merge(
        style: textStyle,
        child: widget.item.label,
      );
    }

    // A given or derived name replaces what the content would announce.
    final label = widget.item.label;
    final name =
        widget.item.semanticLabel ??
        (widget.item.icon != null && label is Text
            ? label.data ?? label.textSpan?.toPlainText()
            : null);
    if (name != null) content = ExcludeSemantics(child: content);

    Widget toggle = AnimatedContainer(
      duration: theme.animations.fast,
      height: sizeToken.height,
      padding:
          style?.padding ?? EdgeInsets.symmetric(horizontal: theme.spacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: widget.borderRadius,
      ),
      child: Center(child: content),
    );

    // Opacity when disabled
    toggle = Opacity(opacity: widget.item.enabled ? 1.0 : 0.5, child: toggle);

    // Focus ring drawn over the option (WCAG 2.4.7)
    toggle = DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        border: _isFocused
            ? Border.all(color: theme.colors.ring, width: 2)
            : null,
      ),
      child: toggle,
    );

    // MouseRegion + gesture wrapping
    toggle = MouseRegion(
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: widget.onTap != null
          ? GestureDetector(
              onTap: widget.onTap,
              behavior: HitTestBehavior.opaque,
              child: toggle,
            )
          : toggle,
    );

    // Each option is a focus stop; Enter and Space press it.
    toggle = FocusableActionDetector(
      enabled: _isEnabled,
      shortcuts: _activateShortcuts,
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap?.call();
            return null;
          },
        ),
      },
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: toggle,
    );

    // A button that is selected in a single-choice group, toggled otherwise.
    return Semantics(
      container: true,
      button: true,
      enabled: _isEnabled,
      selected: widget.exclusive ? widget.isSelected : null,
      inMutuallyExclusiveGroup: widget.exclusive ? true : null,
      toggled: widget.exclusive ? null : widget.isSelected,
      label: name,
      child: toggle,
    );
  }
}
