part of 'v_autocomplete.dart';

class _VAutocompleteState<T> extends State<VAutocomplete<T>> {
  final VPopoverController _popoverController = VPopoverController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  // WHY: One node for the key listener; a new node per build leaked.
  final FocusNode _keyNode = FocusNode(
    skipTraversal: true,
    canRequestFocus: false,
  );
  String _lastText = '';

  List<VAutocompleteItem<T>> _asyncItems = [];
  bool _isSearching = false;
  String _query = '';
  int _highlightedIndex = -1;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
    _syncTextFromValue();
    _textController.addListener(_handleTextChanged);
  }

  @override
  void didUpdateWidget(VAutocomplete<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget._isMultiple && widget.value != oldWidget.value) {
      _syncTextFromValue();
    }
  }

  /// Shows the label of the selected [VAutocomplete.value] in the input.
  void _syncTextFromValue() {
    if (widget._isMultiple) return;
    final value = widget.value;
    if (value == null) {
      _textController.text = '';
    } else {
      final match = widget.items.where((item) => item.value == value);
      if (match.isNotEmpty) {
        _textController.text = match.first.label;
      } else if (value is String) {
        _textController.text = value;
      }
    }
    _lastText = _textController.text;
  }

  // WHY: The text changes in code too (selection, clear, value sync), and the
  // placeholder and the clear button follow it.
  void _handleTextChanged() {
    if (_textController.text == _lastText) return;
    _lastText = _textController.text;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _popoverController.dispose();
    _textController
      ..removeListener(_handleTextChanged)
      ..dispose();
    _keyNode.dispose();
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus && widget.enabled && !widget.readOnly) {
      _popoverController.show();
    }
  }

  List<VAutocompleteItem<T>> get _filteredItems {
    if (widget._isAsync) {
      return _asyncItems;
    }

    if (_query.isEmpty) return widget.items;

    if (widget.filterFn != null) {
      return widget.items
          .where((item) => widget.filterFn!(item, _query))
          .toList();
    }

    final queryLower = _query.toLowerCase();
    return widget.items.where((item) {
      if (item.label.toLowerCase().contains(queryLower)) return true;
      if (item.subtitle?.toLowerCase().contains(queryLower) ?? false) {
        return true;
      }
      if (item.keywords?.any((k) => k.toLowerCase().contains(queryLower)) ??
          false) {
        return true;
      }
      return false;
    }).toList();
  }

  void _handleInputChange(String value) {
    setState(() {
      _query = value;
      _highlightedIndex = -1;
    });

    widget.onInputChanged?.call(value);

    if (widget._isAsync) {
      _debounceTimer?.cancel();
      if (value.length >= widget.minSearchLength) {
        _debounceTimer = Timer(Duration(milliseconds: widget.debounceMs), () {
          unawaited(_performAsyncSearch(value));
        });
      } else {
        setState(() {
          _asyncItems = [];
          _isSearching = false;
        });
      }
    }

    if (!_popoverController.isOpen) {
      _popoverController.show();
    }
  }

  Future<void> _performAsyncSearch(String query) async {
    if (widget.onSearch == null) return;

    setState(() => _isSearching = true);

    try {
      final results = await widget.onSearch!(query);
      if (mounted && _query == query) {
        setState(() {
          _asyncItems = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _asyncItems = [];
          _isSearching = false;
        });
      }
    }
  }

  void _handleSelect(VAutocompleteItem<T> item) {
    if (!item.enabled) return;

    if (widget._isMultiple) {
      final newValues = List<T>.from(widget.values);
      if (newValues.contains(item.value)) {
        newValues.remove(item.value);
      } else {
        if (widget.maxSelection != null &&
            newValues.length >= widget.maxSelection!) {
          return;
        }
        newValues.add(item.value);
      }

      VDebug.log(
        category: VDebugCategory.input,
        component: 'VAutocomplete',
        name: widget.name,
        action: 'selected',
        value: newValues,
      );

      widget.onValuesChanged?.call(newValues);
      _textController.clear();
      setState(() => _query = '');
    } else {
      VDebug.log(
        category: VDebugCategory.input,
        component: 'VAutocomplete',
        name: widget.name,
        action: 'selected',
        value: item.value,
      );

      widget.onChanged?.call(item.value);
      _textController.text = item.label;
      _popoverController.hide();
    }
  }

  void _handleCustomValue() {
    if (!widget.allowCustomValue || _query.isEmpty) return;

    // Check if query matches existing item
    for (final item in _filteredItems) {
      if (item.label.toLowerCase() == _query.toLowerCase()) {
        _handleSelect(item);
        return;
      }
    }

    // A custom value is the typed text, so it only fits a String-compatible T.
    final Object typed = _query;
    if (typed is! T) return;
    final custom = typed as T;

    if (widget._isMultiple) {
      final values = List<T>.from(widget.values);
      if (!values.contains(custom)) {
        if (widget.maxSelection != null &&
            values.length >= widget.maxSelection!) {
          return;
        }
        widget.onValuesChanged?.call([...values, custom]);
      }
      _textController.clear();
      setState(() => _query = '');
    } else {
      widget.onChanged?.call(custom);
      _popoverController.hide();
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return;
    if (!widget.enabled || widget.readOnly) return;
    final isRepeat = event is KeyRepeatEvent;
    final key = event.logicalKey;
    final items = _filteredItems;

    // Keys that work with an empty list, too: a custom value is typed
    // exactly when nothing matches.
    if (!isRepeat) {
      if (key == LogicalKeyboardKey.enter) {
        if (_highlightedIndex >= 0 && _highlightedIndex < items.length) {
          _handleSelect(items[_highlightedIndex]);
        } else if (widget.allowCustomValue) {
          _handleCustomValue();
        }
        return;
      }
      if (key == LogicalKeyboardKey.escape) {
        _popoverController.hide();
        _focusNode.unfocus();
        return;
      }
      if (key == LogicalKeyboardKey.backspace &&
          widget._isMultiple &&
          _query.isEmpty &&
          widget.values.isNotEmpty) {
        // Remove last chip
        final newValues = List<T>.from(widget.values)..removeLast();
        widget.onValuesChanged?.call(newValues);
        return;
      }
    }

    if (items.isEmpty) return;

    if (key == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _highlightedIndex = (_highlightedIndex + 1) % items.length;
      });
    } else if (key == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _highlightedIndex =
            (_highlightedIndex - 1 + items.length) % items.length;
      });
    } else if (!isRepeat && key == LogicalKeyboardKey.home) {
      setState(() => _highlightedIndex = 0);
    } else if (!isRepeat && key == LogicalKeyboardKey.end) {
      setState(() => _highlightedIndex = items.length - 1);
    }
  }

  void _removeChip(T value) {
    final newValues = List<T>.from(widget.values)..remove(value);
    widget.onValuesChanged?.call(newValues);
  }

  VComponentSize get _sizeToken {
    final theme = VTheme.of(context);
    return switch (widget.size) {
      VAutocompleteSize.sm => theme.sizes.sm,
      VAutocompleteSize.lg => theme.sizes.lg,
      _ => theme.sizes.md,
    };
  }

  BorderRadius get _borderRadius =>
      BorderRadius.circular(_sizeToken.borderRadius);

  static const _kTriggerMinWidthSm = 188.0;
  static const _kTriggerMinWidthMd = 208.0;
  static const _kTriggerMinWidthLg = 247.0;
  static const _kDropdownMaxHeight = 240.0;
  static const _kChipMinWidth = 80.0;

  // Minimum trigger width per size, about 20 characters
  double get _triggerMinWidth => switch (widget.size) {
    VAutocompleteSize.sm => _kTriggerMinWidthSm,
    VAutocompleteSize.lg => _kTriggerMinWidthLg,
    _ => _kTriggerMinWidthMd,
  };

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VAutocompleteStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    final colors = theme.colors;
    final typography = theme.typography;

    final isError = widget.error;
    final isDisabled = !widget.enabled;

    Color borderColor;
    if (isDisabled) {
      borderColor = colors.muted;
    } else if (isError) {
      borderColor = colors.destructive;
    } else if (_focusNode.hasFocus) {
      borderColor = resolvedStyle?.focusBorderColor ?? colors.ring;
    } else {
      borderColor = resolvedStyle?.borderColor ?? colors.input;
    }

    // Input trigger
    final sizeToken = _sizeToken;
    final inputStyle = typography.bodyMedium.copyWith(
      color: colors.foreground,
      fontSize: sizeToken.fontSize,
    );
    final Widget inputField = EditableText(
      controller: _textController,
      focusNode: _focusNode,
      style: inputStyle,
      cursorColor: colors.primary,
      backgroundCursorColor: colors.muted,
      onChanged: _handleInputChange,
      readOnly: widget.readOnly || isDisabled,
    );

    Widget trigger;
    if (widget._isMultiple && widget.values.isNotEmpty) {
      // Multiple selection with chips
      trigger = Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: sizeToken.height),
        padding:
            resolvedStyle?.padding ??
            EdgeInsets.symmetric(
              horizontal: sizeToken.paddingHorizontal,
              vertical: sizeToken.paddingVertical,
            ),
        decoration: BoxDecoration(
          color: resolvedStyle?.backgroundColor ?? colors.background,
          border: Border.all(color: borderColor),
          borderRadius: resolvedStyle?.borderRadius ?? _borderRadius,
        ),
        child: Wrap(
          spacing: theme.spacing.xs,
          runSpacing: theme.spacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...widget.values.map((v) {
              if (widget.chipBuilder != null) {
                return widget.chipBuilder!(v);
              }
              final item = widget.items.firstWhere(
                (i) => i.value == v,
                orElse: () => VAutocompleteItem(value: v, label: v.toString()),
              );
              return _Chip(label: item.label, onRemove: () => _removeChip(v));
            }),
            IntrinsicWidth(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: _kChipMinWidth),
                child: KeyboardListener(
                  focusNode: _keyNode,
                  onKeyEvent: _handleKeyEvent,
                  child: inputField,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Single selection or empty multiple
      trigger = Container(
        height: sizeToken.height,
        constraints: widget.fullWidth
            ? null
            : BoxConstraints(minWidth: _triggerMinWidth),
        padding:
            resolvedStyle?.padding ??
            EdgeInsets.symmetric(horizontal: sizeToken.paddingHorizontal),
        decoration: BoxDecoration(
          color: resolvedStyle?.backgroundColor ?? colors.background,
          border: Border.all(color: borderColor),
          borderRadius: resolvedStyle?.borderRadius ?? _borderRadius,
        ),
        child: Row(
          children: [
            VIcons.search(
              color: colors.mutedForeground,
              size: sizeToken.iconSize,
            ),
            SizedBox(width: sizeToken.spacing),
            Expanded(
              child: KeyboardListener(
                focusNode: _keyNode,
                onKeyEvent: _handleKeyEvent,
                child: Stack(
                  children: [
                    if (_textController.text.isEmpty &&
                        widget.placeholder != null)
                      IgnorePointer(
                        child: Text(
                          widget.placeholder!,
                          style: inputStyle.copyWith(
                            color: colors.mutedForeground,
                          ),
                        ),
                      ),
                    inputField,
                  ],
                ),
              ),
            ),
            if (widget.loading || _isSearching)
              const _LoadingIndicator()
            else if (_textController.text.isNotEmpty)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _textController.clear();
                    setState(() => _query = '');
                    if (!widget._isMultiple) {
                      widget.onChanged?.call(null);
                    }
                    _focusNode.unfocus();
                    _popoverController.hide();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(theme.spacing.xs),
                    child: VIcons.close(
                      color: colors.mutedForeground,
                      size: sizeToken.iconSize,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Dropdown
    final Widget dropdown = Container(
      constraints: const BoxConstraints(maxHeight: _kDropdownMaxHeight),
      child: _buildDropdownContent(colors, typography),
    );

    Widget autocomplete = VPopover(
      controller: _popoverController,
      position: VPopoverPosition.bottomStart,
      content: dropdown,
      triggerOnTap: false, // VAutocomplete handles tap events directly
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: IgnorePointer(
          ignoring: isDisabled,
          child: ExcludeFocus(excluding: isDisabled, child: trigger),
        ),
      ),
    );

    if (widget.fullWidth) {
      autocomplete = SizedBox(width: double.infinity, child: autocomplete);
    }

    // WHY: Always wrapped, so the input keeps its place in the tree when a
    // label or message appears or goes away.
    return VFormField(
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
      child: autocomplete,
    );
  }

  Widget _buildDropdownContent(VColors colors, VTypography typography) {
    final theme = VTheme.of(context);
    final items = _filteredItems;

    if (_isSearching) {
      return Padding(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: const Center(child: _LoadingIndicator()),
      );
    }

    if (widget._isAsync && _query.length < widget.minSearchLength) {
      return Padding(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: Text(
          VoloLocalizations.of(
            context,
          ).autocompleteMinChars(widget.minSearchLength),
          style: typography.bodyMedium.copyWith(color: colors.mutedForeground),
        ),
      );
    }

    if (items.isEmpty) {
      if (widget.emptyBuilder != null) {
        return widget.emptyBuilder!(_query);
      }
      return Padding(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: Text(
          _query.isNotEmpty
              ? VoloLocalizations.of(context).autocompleteNoResults(_query)
              : VoloLocalizations.of(context).noOptions,
          style: typography.bodyMedium.copyWith(color: colors.mutedForeground),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = widget._isMultiple
            ? widget.values.contains(item.value)
            : widget.value == item.value;
        final isHighlighted = index == _highlightedIndex;
        final isMaxReached =
            widget._isMultiple &&
            widget.maxSelection != null &&
            widget.values.length >= widget.maxSelection! &&
            !isSelected;
        final isItemEnabled = item.enabled && !isMaxReached;

        return Semantics(
          button: true,
          selected: isSelected,
          enabled: isItemEnabled,
          label: item.label,
          child: GestureDetector(
            onTap: isItemEnabled ? () => _handleSelect(item) : null,
            child: MouseRegion(
              onEnter: (_) => setState(() => _highlightedIndex = index),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.md,
                  vertical: theme.sizes.sm.paddingVertical,
                ),
                color: isHighlighted
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
                          padding: EdgeInsets.only(right: theme.spacing.sm),
                          child: item.leading,
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildHighlightedText(
                              item.label,
                              _query,
                              typography.bodyMedium.copyWith(
                                color: colors.foreground,
                              ),
                              colors.primary,
                            ),
                            if (item.subtitle != null)
                              Text(
                                item.subtitle!,
                                style: typography.bodySmall.copyWith(
                                  color: colors.mutedForeground,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        VIcons.check(
                          color: colors.primary,
                          size: theme.sizes.md.iconSize,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHighlightedText(
    String text,
    String query,
    TextStyle style,
    Color highlightColor,
  ) {
    if (query.isEmpty) {
      return Text(text, style: style);
    }

    final queryLower = query.toLowerCase();
    final textLower = text.toLowerCase();
    final startIndex = textLower.indexOf(queryLower);

    if (startIndex == -1) {
      return Text(text, style: style);
    }

    final endIndex = startIndex + query.length;

    return Text.rich(
      TextSpan(
        children: [
          if (startIndex > 0) TextSpan(text: text.substring(0, startIndex)),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: highlightColor,
            ),
          ),
          if (endIndex < text.length) TextSpan(text: text.substring(endIndex)),
        ],
      ),
      style: style,
    );
  }
}

/// Selection chip.
class _Chip extends StatelessWidget {
  const _Chip({required this.label, this.onRemove});

  final String label;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.sm,
        vertical: theme.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.accent,
        borderRadius: theme.radius.smRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: typography.bodySmall.copyWith(color: colors.foreground),
          ),
          if (onRemove != null) ...[
            SizedBox(width: theme.spacing.xs),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onRemove,
              // Min 24x24px touch target (WCAG 2.2 SC 2.5.8)
              child: Padding(
                padding: EdgeInsets.all(theme.spacing.xs),
                child: VIcons.close(
                  color: colors.mutedForeground,
                  size: theme.sizes.xs.iconSize,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading indicator.
class _LoadingIndicator extends StatefulWidget {
  const _LoadingIndicator();

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
        angle: _controller.value * 2 * pi,
        child: VIcons.refresh(
          color: theme.colors.mutedForeground,
          size: theme.sizes.sm.iconSize,
        ),
      ),
    );
  }
}
