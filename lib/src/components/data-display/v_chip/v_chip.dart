import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_chip_style.dart';

/// Height presets for a [VChip].
enum VChipSize {
  /// Extra small size (20px).
  xs,

  /// Small size (24px).
  sm,

  /// Medium size (32px).
  md,

  /// Large size (40px).
  lg,

  /// Extra large size (48px).
  xl,
}

/// Compact pill for a tag, a filter toggle or a removable input value.
///
/// The default and [VChip.outlined] chips fire [onTap], [VChip.filter] toggles
/// through [onSelected], and [VChip.input] shows a delete icon for [onDeleted].
///
/// ```dart
/// VChip.filter(
///   label: Text('Flutter'),
///   leading: Icon(IconData(0xe047, fontFamily: 'MaterialIcons')),
///   selected: isSelected,
///   onSelected: (value) => setState(() => isSelected = value),
/// )
/// ```
///
/// See also:
///
/// - [VChipGroup], which manages several filter chips as one group.
/// - [VChipItem], the item description used by the group.
/// - [VChipSize], the chip sizes.
class VChip extends StatefulWidget {
  /// Filled chip with a muted background.
  const VChip({
    required this.label,
    super.key,
    this.leading,
    this.onTap,
    this.enabled = true,
    this.size = VChipSize.md,
    this.style,
  }) : _variant = _VChipVariant.filled,
       selected = false,
       onSelected = null,
       onDeleted = null;

  /// Transparent chip with a border.
  const VChip.outlined({
    required this.label,
    super.key,
    this.leading,
    this.onTap,
    this.enabled = true,
    this.size = VChipSize.md,
    this.style,
  }) : _variant = _VChipVariant.outlined,
       selected = false,
       onSelected = null,
       onDeleted = null;

  /// Chip that toggles between selected and unselected.
  const VChip.filter({
    required this.label,
    super.key,
    this.leading,
    this.selected = false,
    this.onSelected,
    this.enabled = true,
    this.size = VChipSize.md,
    this.style,
  }) : _variant = _VChipVariant.filter,
       onTap = null,
       onDeleted = null;

  /// Chip with a delete icon for removable values.
  const VChip.input({
    required this.label,
    super.key,
    this.leading,
    this.onDeleted,
    this.enabled = true,
    this.size = VChipSize.md,
    this.style,
  }) : _variant = _VChipVariant.input,
       selected = false,
       onSelected = null,
       onTap = null;

  final _VChipVariant _variant;

  /// Content of the chip, usually a short [Text].
  ///
  /// Font size and color come from the chip, so a plain [Text] needs no style.
  final Widget label;

  /// Widget shown before the label, such as an icon.
  final Widget? leading;

  /// Called when the chip is tapped; only on the default and outlined chips.
  final VoidCallback? onTap;

  /// Whether the filter chip is selected; always false on other variants.
  final bool selected;

  /// Called with the new selection when a filter chip is tapped.
  final ValueChanged<bool>? onSelected;

  /// Called when the delete icon of an input chip is tapped.
  ///
  /// The delete icon is only shown when this is set.
  final VoidCallback? onDeleted;

  /// Whether the chip reacts to taps and focus; false dims it.
  final bool enabled;

  /// Height and padding preset of the chip.
  final VChipSize size;

  /// Per-instance style override merged over the theme style.
  final VChipStyle? style;

  @override
  State<VChip> createState() => _VChipState();
}

enum _VChipVariant { filled, outlined, filter, input }

class _VChipState extends State<VChip> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _isFocused = false;
  late AnimationController _checkController;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      value: widget.selected ? 1.0 : 0.0,
    );
    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _checkController.duration = theme.animations.fast;
  }

  @override
  void didUpdateWidget(VChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEnabled) {
      // A disabled chip keeps no press or focus state for later.
      _isPressed = false;
      _isFocused = false;
    }
    if (widget.selected != oldWidget.selected) {
      if (widget.selected) {
        unawaited(_checkController.forward());
      } else {
        unawaited(_checkController.reverse());
      }
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  /// Maps VChipSize to VComponentSize token.
  ///
  /// Chip uses one step smaller than standard components:
  /// xs(20px)→xxs, sm(24px)→xs, md(32px)→sm, lg(40px)→md, xl(48px)→lg.
  VComponentSize get _sizeToken {
    final theme = VTheme.of(context);
    return switch (widget.size) {
      VChipSize.xs => theme.sizes.xs,
      VChipSize.sm => theme.sizes.xs,
      VChipSize.lg => theme.sizes.md,
      VChipSize.xl => theme.sizes.lg,
      _ => theme.sizes.sm,
    };
  }

  EdgeInsets get _padding => _sizeToken.padding;

  double get _fontSize => _sizeToken.fontSize;

  double get _height => _sizeToken.height;

  double get _iconSize => _sizeToken.iconSize;

  bool get _isEnabled => widget.enabled;

  void _handleTap() {
    if (!_isEnabled) return;

    if (widget._variant == _VChipVariant.filter) {
      widget.onSelected?.call(!widget.selected);
    } else {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VChipStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;
    final colors = theme.colors;

    Color bgColor;
    Color fgColor;
    Border? border;

    final isSelected =
        widget._variant == _VChipVariant.filter && widget.selected;

    if (isSelected) {
      bgColor = colors.primary;
      fgColor = colors.primaryForeground;
    } else if (widget._variant == _VChipVariant.outlined) {
      bgColor = VColors.transparent;
      fgColor = colors.foreground;
      border = Border.all(color: colors.border);
    } else {
      bgColor = colors.muted;
      fgColor = colors.foreground;
    }

    if (resolvedStyle != null) {
      bgColor = resolvedStyle.backgroundColor ?? bgColor;
      fgColor = resolvedStyle.foregroundColor ?? fgColor;
      if (resolvedStyle.borderColor != null) {
        border = Border.all(color: resolvedStyle.borderColor!);
      }
    }

    final labelWidget = DefaultTextStyle.merge(
      style: (resolvedStyle?.textStyle ?? const TextStyle()).copyWith(
        fontSize: _fontSize,
        color: fgColor,
        height: 1.15,
      ),
      overflow: TextOverflow.ellipsis,
      child: widget.label,
    );

    final children = <Widget>[];

    final gap = _sizeToken.spacing;

    // Filter chip: check icon (shown only when selected)
    if (widget._variant == _VChipVariant.filter && widget.selected) {
      children.add(
        ScaleTransition(
          scale: _checkAnimation,
          child: Padding(
            padding: EdgeInsets.only(right: gap),
            child: VIcons.check(color: fgColor, size: _iconSize),
          ),
        ),
      );
    }

    // Leading icon
    if (widget.leading != null) {
      children.add(
        Padding(
          padding: EdgeInsets.only(right: gap),
          child: widget.leading!,
        ),
      );
    }

    // Label
    children.add(Flexible(child: labelWidget));

    // Input chip: delete button (WCAG 2.5.8: minimum touch target 24x24)
    if (widget._variant == _VChipVariant.input &&
        widget.onDeleted != null &&
        _isEnabled) {
      children.add(
        Semantics(
          button: true,
          // Its own node, so a screen reader can reach delete apart from the chip.
          container: true,
          label: VoloLocalizations.of(context).chipDelete,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            child: GestureDetector(
              onTap: widget.onDeleted,
              child: Padding(
                padding: EdgeInsets.only(left: gap),
                child: VIcons.close(
                  color: resolvedStyle?.deleteIconColor ?? fgColor,
                  size: _iconSize,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Focus ring (WCAG 2.4.7)
    final chipRadius =
        resolvedStyle?.borderRadius ?? BorderRadius.circular(_height / 2);
    final chipPadding = resolvedStyle?.padding ?? _padding;

    Widget chip = DecoratedBox(
      decoration: _isFocused && _isEnabled
          ? BoxDecoration(
              borderRadius: chipRadius,
              border: Border.all(color: colors.ring, width: 2),
            )
          : const BoxDecoration(),
      child: AnimatedContainer(
        duration: theme.animations.fast,
        curve: Curves.easeOut,
        height: _height,
        padding: chipPadding,
        transform: _isPressed
            ? (Matrix4.identity()..scaleByDouble(0.95, 0.95, 1, 1))
            : Matrix4.identity(),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: chipRadius,
          border: border,
        ),
        child: Opacity(
          opacity: _isEnabled ? 1.0 : 0.5,
          child: Row(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ),
    );

    if (_isEnabled) {
      chip = Focus(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        onKeyEvent: (node, event) {
          // Enter and Space press a focused chip like a tap. Keys that reach it
          // from a focused child are left to that child.
          if (node.hasPrimaryFocus &&
              event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.numpadEnter ||
                  event.logicalKey == LogicalKeyboardKey.space)) {
            _handleTap();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: _handleTap,
          child: chip,
        ),
      );
    }

    return Semantics(
      button: true,
      toggled: widget._variant == _VChipVariant.filter ? widget.selected : null,
      enabled: _isEnabled,
      child: chip,
    );
  }
}

/// One selectable entry of a [VChipGroup].
///
/// ```dart
/// VChipItem(value: 'flutter', label: Text('Flutter'))
/// ```
class VChipItem<T> {
  /// Creates an item with a value and a label.
  const VChipItem({required this.value, required this.label, this.leading});

  /// Value reported by [VChipGroup.onChanged] while this item is selected.
  final T value;

  /// Content of the chip built from this item, usually a short [Text].
  final Widget label;

  /// Widget shown before the label, such as an icon.
  final Widget? leading;
}

/// Wrapping row of filter chips that reports the selected values as a list.
///
/// ```dart
/// VChipGroup<String>(
///   items: [
///     VChipItem(value: 'flutter', label: Text('Flutter')),
///     VChipItem(value: 'dart', label: Text('Dart')),
///   ],
///   values: selectedTags,
///   onChanged: (values) => setState(() => selectedTags = values),
/// )
/// ```
class VChipGroup<T> extends StatelessWidget {
  /// Creates a group of filter chips.
  const VChipGroup({
    required this.items,
    super.key,
    this.values = const [],
    this.onChanged,
    this.allowMultiple = true,
    this.size = VChipSize.md,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  /// Items to render, one filter chip each.
  final List<VChipItem<T>> items;

  /// Values of the currently selected items.
  final List<T> values;

  /// Called with the new list of selected values after a chip is toggled.
  final ValueChanged<List<T>>? onChanged;

  /// Whether several chips can be selected at once; false keeps one.
  final bool allowMultiple;

  /// Size of every chip in the group.
  final VChipSize size;

  /// Horizontal spacing between chips.
  final double spacing;

  /// Vertical spacing between rows of chips.
  final double runSpacing;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: spacing,
    runSpacing: runSpacing,
    children: items.map((item) {
      final isSelected = values.contains(item.value);
      return VChip.filter(
        label: item.label,
        leading: item.leading,
        selected: isSelected,
        size: size,
        onSelected: (selected) {
          if (onChanged == null) return;

          List<T> newValues;
          if (selected) {
            if (allowMultiple) {
              newValues = [...values, item.value];
            } else {
              newValues = [item.value];
            }
          } else {
            newValues = values.where((v) => v != item.value).toList();
          }
          onChanged!(newValues);
        },
      );
    }).toList(),
  );
}
