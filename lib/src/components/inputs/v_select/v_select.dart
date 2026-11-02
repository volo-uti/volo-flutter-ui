import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_form_field/v_form_field.dart';
import 'package:volo_flutter_ui/src/components/surfaces/v_popover/v_popover.dart';
import 'package:volo_flutter_ui/src/components/surfaces/v_popover/v_popover_style.dart';
import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'package:volo_flutter_ui/src/utils/v_debug.dart';

import 'v_select_style.dart';

/// Three-step size of a [VSelect] trigger and its option rows.
enum VSelectSize {
  /// Small size.
  sm,

  /// Medium size (default).
  md,

  /// Large size.
  lg,
}

/// One option of a [VSelect], with a value, a text label and an optional icon.
class VSelectItem<T> {
  /// Creates a select item.
  const VSelectItem({
    required this.value,
    required this.label,
    this.leading,
    this.enabled = true,
  });

  /// Value reported when this option is picked.
  final T value;

  /// Text shown in the option row and, once picked, in the trigger.
  final String label;

  /// Widget shown before [label] in the option row.
  final Widget? leading;

  /// Whether this option can be picked.
  final bool enabled;
}

/// Dropdown that picks one option, or several with [VSelect.multiple].
///
/// Opens a popover list below the trigger, optionally searchable, and can
/// carry its own label, helper and error text.
///
/// ```dart
/// VSelect<String>(
///   value: selected,
///   onChanged: (v) => setState(() => selected = v),
///   items: [
///     VSelectItem(value: 'ko', label: 'Korean'),
///     VSelectItem(value: 'en', label: 'English'),
///   ],
/// )
/// ```
class VSelect<T> extends StatefulWidget {
  /// Creates a select that picks one [value].
  const VSelect({
    required this.items,
    super.key,
    this.name,
    this.value,
    this.onChanged,
    this.placeholder,
    this.label,
    this.more,
    this.tooltip,
    this.required = false,
    this.requiredMark = '*',
    this.helper,
    this.error = false,
    this.errorText,
    this.success = false,
    this.successText,
    this.extra,
    this.size,
    this.enabled = true,
    this.readOnly = false,
    this.loading = false,
    this.fullWidth = false,
    this.searchable = false,
    this.popoverPosition = VPopoverPosition.bottomEnd,
    this.matchTriggerWidth = true,
    this.style,
  }) : values = const [],
       onValuesChanged = null,
       maxSelection = null,
       _isMultiple = false;

  /// Creates a select that picks several [values], up to [maxSelection].
  ///
  /// ```dart
  /// VSelect<String>.multiple(
  ///   values: selectedList,
  ///   onValuesChanged: (v) => setState(() => selectedList = v),
  ///   items: items,
  /// )
  /// ```
  const VSelect.multiple({
    required this.items,
    super.key,
    this.name,
    this.values = const [],
    this.onValuesChanged,
    this.maxSelection,
    this.placeholder,
    this.label,
    this.more,
    this.tooltip,
    this.required = false,
    this.requiredMark = '*',
    this.helper,
    this.error = false,
    this.errorText,
    this.success = false,
    this.successText,
    this.extra,
    this.size,
    this.enabled = true,
    this.readOnly = false,
    this.loading = false,
    this.fullWidth = false,
    this.searchable = false,
    this.popoverPosition = VPopoverPosition.bottomEnd,
    this.matchTriggerWidth = true,
    this.style,
  }) : value = null,
       onChanged = null,
       _isMultiple = true;

  /// Key identifying this select in debug logs.
  final String? name;

  /// Options offered in the dropdown.
  final List<VSelectItem<T>> items;

  /// Picked value of a single select; `null` shows [placeholder].
  final T? value;

  /// Called with the picked value in a single select.
  final ValueChanged<T?>? onChanged;

  /// Picked values of a [VSelect.multiple].
  final List<T> values;

  /// Called with the new list when [VSelect.multiple] toggles an option.
  final ValueChanged<List<T>>? onValuesChanged;

  /// Largest number of values a [VSelect.multiple] accepts; unlimited if `null`.
  final int? maxSelection;

  /// Text shown in the trigger while nothing is picked.
  final String? placeholder;

  /// Label above the field.
  final String? label;

  /// Secondary text at the right end of the label row.
  final String? more;

  /// Help widget shown next to the label.
  final Widget? tooltip;

  /// Whether the label carries the [requiredMark].
  final bool required;

  /// Character appended to the label when [required].
  final String requiredMark;

  /// Helper text below the field.
  final String? helper;

  /// Whether the field is drawn in the error state.
  final bool error;

  /// Message below the field while [error] is set.
  final String? errorText;

  /// Whether the field is drawn in the success state.
  final bool success;

  /// Message below the field while [success] is set.
  final String? successText;

  /// Note below the field that is always visible.
  final String? extra;

  /// Trigger size; defaults to medium.
  final VSelectSize? size;

  /// Whether the select reacts to input.
  final bool enabled;

  /// Whether the dropdown is blocked from opening while the value stays visible.
  final bool readOnly;

  /// Whether a spinner replaces the chevron.
  final bool loading;

  /// Whether the trigger fills the available width.
  final bool fullWidth;

  /// Whether the dropdown shows a search box that filters options by label.
  final bool searchable;

  /// Where the dropdown opens relative to the trigger.
  final VPopoverPosition popoverPosition;

  /// Whether the dropdown is as wide as the trigger.
  final bool matchTriggerWidth;

  /// Style override merged over the theme's [VSelectStyle].
  final VSelectStyle? style;

  final bool _isMultiple;

  @override
  State<VSelect<T>> createState() => _VSelectState<T>();
}

class _VSelectState<T> extends State<VSelect<T>> {
  final VPopoverController _popoverController = VPopoverController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final GlobalKey _triggerKey = GlobalKey();
  String _searchQuery = '';
  double? _triggerWidth;
  int _hoveredIndex = -1;
  bool _hasFocus = false;

  // Internal selection state (for multiple selection)
  late List<T> _internalValues;

  @override
  void initState() {
    super.initState();
    _internalValues = List<T>.from(widget.values);
    _popoverController.addListener(_handlePopoverChanged);
  }

  // WHY: Reopening the dropdown must not show the list still filtered by the
  // previous search.
  void _handlePopoverChanged() {
    if (_popoverController.isOpen || !mounted) return;
    if (_searchQuery.isEmpty && _hoveredIndex == -1) return;
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _hoveredIndex = -1;
    });
  }

  @override
  void didUpdateWidget(VSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync internal state when values change externally
    if (widget._isMultiple && widget.values != oldWidget.values) {
      _internalValues = List<T>.from(widget.values);
    }
  }

  List<VSelectItem<T>> get _filteredItems {
    if (_searchQuery.isEmpty) return widget.items;
    return widget.items
        .where(
          (item) =>
              item.label.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  String _displayText(BuildContext context) {
    if (widget._isMultiple) {
      if (_internalValues.isEmpty) return widget.placeholder ?? '';
      if (_internalValues.length == 1) {
        return _labelOf(_internalValues.first) ?? widget.placeholder ?? '';
      }
      return VoloLocalizations.of(context).nSelected(_internalValues.length);
    } else {
      if (widget.value == null) return widget.placeholder ?? '';
      return _labelOf(widget.value as T) ?? widget.placeholder ?? '';
    }
  }

  /// Label of the item holding [value], or null when no item does.
  String? _labelOf(T value) {
    for (final item in widget.items) {
      if (item.value == value) return item.label;
    }
    return null;
  }

  void _handleSelect(VSelectItem<T> item) {
    if (!item.enabled) return;

    if (widget._isMultiple) {
      // WHY: Checked before setState, so a refused pick (max reached, by
      // keyboard) reports no change.
      if (!_internalValues.contains(item.value) &&
          widget.maxSelection != null &&
          _internalValues.length >= widget.maxSelection!) {
        return;
      }
      setState(() {
        if (_internalValues.contains(item.value)) {
          _internalValues.remove(item.value);
        } else {
          _internalValues.add(item.value);
        }
      });
      // Rebuild OverlayEntry after VSelect rebuild
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _popoverController.rebuild();
      });

      VDebug.log(
        category: VDebugCategory.input,
        component: 'VSelect',
        name: widget.name,
        action: 'selected',
        value: _internalValues,
      );

      widget.onValuesChanged?.call(List<T>.from(_internalValues));
    } else {
      VDebug.log(
        category: VDebugCategory.input,
        component: 'VSelect',
        name: widget.name,
        action: 'selected',
        value: item.value,
      );

      widget.onChanged?.call(item.value);
      _popoverController.hide();
    }
  }

  /// Handles keyboard navigation within the dropdown.
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (!widget.enabled || widget.readOnly) return KeyEventResult.ignored;

    if (!_popoverController.isOpen) {
      // Open dropdown on ArrowDown when closed.
      if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.space) {
        _popoverController.show();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    final items = _filteredItems;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        if (items.isNotEmpty) {
          _hoveredIndex = (_hoveredIndex + 1) % items.length;
        }
      });
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        if (items.isNotEmpty) {
          _hoveredIndex = (_hoveredIndex - 1 + items.length) % items.length;
        }
      });
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (_hoveredIndex >= 0 && _hoveredIndex < items.length) {
        _handleSelect(items[_hoveredIndex]);
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _popoverController.hide();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.home) {
      setState(() => _hoveredIndex = 0);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.end) {
      setState(() {
        if (items.isNotEmpty) {
          _hoveredIndex = items.length - 1;
        }
      });
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _popoverController
      ..removeListener(_handlePopoverChanged)
      ..dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  VComponentSize get _sizeToken {
    final theme = VTheme.of(context);
    return switch (widget.size) {
      VSelectSize.sm => theme.sizes.sm,
      VSelectSize.lg => theme.sizes.lg,
      _ => theme.sizes.md,
    };
  }

  BorderRadius get _borderRadius =>
      BorderRadius.circular(_sizeToken.borderRadius);

  static const _kTriggerMinWidthSm = 188.0;
  static const _kTriggerMinWidthMd = 208.0;
  static const _kTriggerMinWidthLg = 247.0;
  static const _kDropdownMaxHeight = 240.0;

  double get _triggerMinWidth => switch (widget.size) {
    VSelectSize.sm => _kTriggerMinWidthSm,
    VSelectSize.lg => _kTriggerMinWidthLg,
    _ => _kTriggerMinWidthMd,
  };

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VSelectStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    final colors = theme.colors;
    final typography = theme.typography;
    final l10n = VoloLocalizations.of(context);

    final isError = widget.error;
    final isDisabled = !widget.enabled;
    final sizeToken = _sizeToken;

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

    final displayText = _displayText(context);
    final hasValue =
        displayText.isNotEmpty && displayText != widget.placeholder;
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
      key: _triggerKey,
      height: sizeToken.height,
      constraints: widget.fullWidth
          ? null
          : BoxConstraints(
              minWidth: resolvedStyle?.minWidth ?? _triggerMinWidth,
            ),
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
              displayText,
              style: triggerTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: sizeToken.spacing),
          if (widget.loading)
            _LoadingIndicator(size: sizeToken.iconSize)
          else
            VIcons.chevronDown(
              color: colors.mutedForeground,
              size: sizeToken.iconSize,
            ),
        ],
      ),
    );

    // Measure trigger width using post-frame callback.
    // Always re-measure to handle layout changes (e.g., resize).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox =
          _triggerKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null && mounted) {
        final w = renderBox.size.width;
        if (w != _triggerWidth) {
          setState(() => _triggerWidth = w);
        }
      }
    });

    final dropdownWidth = widget.matchTriggerWidth
        ? (_triggerWidth ?? 200.0)
        : 200.0;

    final Widget dropdown = Container(
      constraints: BoxConstraints(
        maxHeight: _kDropdownMaxHeight,
        minWidth: dropdownWidth,
        maxWidth: dropdownWidth,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.searchable)
            Padding(
              padding: EdgeInsets.all(theme.spacing.sm),
              child: Container(
                height: sizeToken.height,
                padding: EdgeInsets.symmetric(
                  horizontal: sizeToken.paddingHorizontal,
                ),
                decoration: BoxDecoration(
                  color: colors.muted,
                  borderRadius: theme.radius.xsRadius,
                ),
                child: Row(
                  children: [
                    VIcons.search(
                      color: colors.mutedForeground,
                      size: sizeToken.iconSize,
                    ),
                    SizedBox(width: sizeToken.spacing),
                    Expanded(
                      child: EditableText(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        style: typography.bodyMedium.copyWith(
                          color: colors.foreground,
                          fontSize: sizeToken.fontSize,
                        ),
                        cursorColor: colors.primary,
                        backgroundCursorColor: colors.muted,
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Flexible(
            child: _filteredItems.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(theme.spacing.lg),
                    child: Text(
                      widget.searchable && _searchQuery.isNotEmpty
                          ? l10n.selectNoResults
                          : l10n.selectNoOptions,
                      style: typography.bodyMedium.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isSelected = widget._isMultiple
                          ? _internalValues.contains(item.value)
                          : widget.value == item.value;
                      final isMaxReached =
                          widget._isMultiple &&
                          widget.maxSelection != null &&
                          _internalValues.length >= widget.maxSelection! &&
                          !isSelected;
                      final isItemEnabled = item.enabled && !isMaxReached;

                      final labelWidget = Text(
                        item.label,
                        style: typography.bodyMedium.copyWith(
                          color: isItemEnabled
                              ? colors.foreground
                              : colors.mutedForeground,
                          fontSize: sizeToken.fontSize,
                        ),
                      );

                      return Semantics(
                        button: true,
                        selected: isSelected,
                        enabled: isItemEnabled,
                        label: item.label,
                        child: GestureDetector(
                          onTap: isItemEnabled
                              ? () => _handleSelect(item)
                              : null,
                          child: MouseRegion(
                            onEnter: (_) =>
                                setState(() => _hoveredIndex = index),
                            onExit: (_) => setState(() => _hoveredIndex = -1),
                            child: Container(
                              height: sizeToken.height,
                              padding: EdgeInsets.symmetric(
                                horizontal: sizeToken.paddingHorizontal,
                              ),
                              color: _hoveredIndex == index
                                  ? colors.accent
                                  : isSelected
                                  ? colors.accent.withValues(alpha: 0.5)
                                  : VColors.transparent,
                              child: Opacity(
                                opacity: isItemEnabled ? 1.0 : 0.5,
                                child: Row(
                                  children: [
                                    if (item.leading != null)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: sizeToken.spacing,
                                        ),
                                        child: item.leading,
                                      ),
                                    Expanded(child: labelWidget),
                                    if (isSelected)
                                      VIcons.check(
                                        color: colors.primary,
                                        size: sizeToken.iconSize,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );

    final dropdownBackgroundColor = resolvedStyle?.dropdownBackgroundColor;
    final dropdownBorderRadius = resolvedStyle?.dropdownBorderRadius;

    // WHY: The select is one focus stop. Its own node takes the keyboard and
    // draws the focus border, so the popover trigger inside may not take focus.
    Widget select = Focus(
      canRequestFocus: !isDisabled && !widget.readOnly,
      skipTraversal: isDisabled || widget.readOnly,
      descendantsAreFocusable: false,
      onFocusChange: (focused) {
        if (mounted) setState(() => _hasFocus = focused);
      },
      onKeyEvent: _handleKeyEvent,
      child: VPopover(
        controller: _popoverController,
        position: widget.popoverPosition,
        style: dropdownBackgroundColor == null && dropdownBorderRadius == null
            ? null
            : VPopoverStyle(
                backgroundColor: dropdownBackgroundColor,
                borderRadius: dropdownBorderRadius,
              ),
        content: dropdown,
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
      select = SizedBox(width: double.infinity, child: select);
    }

    // WHY: Always wrapped, so the select keeps its place in the tree when a
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
        child: select,
      ),
    );
  }
}

/// Loading indicator.
class _LoadingIndicator extends StatefulWidget {
  const _LoadingIndicator({required this.size});

  /// Icon size.
  final double size;

  @override
  State<_LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<_LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: VAnimations.defaults.verySlow, // fallback default
    );
    unawaited(_controller.repeat());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.duration = VTheme.of(context).animations.verySlow;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.rotate(
        angle: _controller.value * 2 * 3.14159,
        child: VIcons.refresh(
          color: theme.colors.mutedForeground,
          size: widget.size,
        ),
      ),
    );
  }
}
