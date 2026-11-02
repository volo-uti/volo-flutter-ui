import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_command_style.dart';

/// Decides whether [item] matches [query] in a [VCommand].
typedef VCommandFilter = bool Function(VCommandItemData item, String query);

/// Builds the content shown by a [VCommand] when nothing matches [query].
typedef VCommandEmptyBuilder = Widget Function(String query);

/// Searchable command palette, inline or as a Cmd+K dialog.
///
/// Typing filters the items, arrows move the highlight and Enter runs the
/// highlighted item's [VCommandItem.onTap].
///
/// ```dart
/// VCommand(
///   placeholder: 'Type a command...',
///   children: [
///     VCommandInput(),
///     VCommandList(
///       children: [
///         VCommandGroup(
///           heading: 'Suggestions',
///           children: [
///             VCommandItem(
///               value: 'calendar',
///               leading: Icon(Icons.calendar_today),
///               onTap: () => openCalendar(),
///               child: Text('Calendar'),
///             ),
///           ],
///         ),
///       ],
///     ),
///   ],
/// )
/// ```
///
/// Use [VCommand.dialog] for a modal palette driven by [open] and
/// [onOpenChanged].
class VCommand extends StatefulWidget {
  /// Command palette drawn in place, always visible.
  const VCommand({
    required this.children,
    super.key,
    this.placeholder,
    this.emptyBuilder,
    this.filter,
    this.loading = false,
    this.style,
  }) : open = true,
       onOpenChanged = null,
       _isDialog = false;

  /// Command palette shown in a modal dialog while [open] is true.
  const VCommand.dialog({
    required this.children,
    super.key,
    this.open = false,
    this.onOpenChanged,
    this.placeholder,
    this.emptyBuilder,
    this.filter,
    this.loading = false,
    this.style,
  }) : _isDialog = true;

  /// [VCommandInput], [VCommandList] and any other widgets, in order.
  final List<Widget> children;

  /// Whether the dialog is shown; always true for the inline form.
  final bool open;

  /// Called with false when the dialog asks to close (Escape, scrim tap, pick).
  final ValueChanged<bool>? onOpenChanged;

  /// Hint shown in the search field while it is empty.
  ///
  /// A [VCommandInput.placeholder] takes precedence.
  final String? placeholder;

  /// Builds the empty state when no item matches the query.
  final VCommandEmptyBuilder? emptyBuilder;

  /// Replaces the default case-insensitive match on value and keywords.
  final VCommandFilter? filter;

  /// Whether a spinner is shown next to the search field.
  final bool loading;

  /// Overrides the theme's [VCommandStyle] for this palette.
  final VCommandStyle? style;

  final bool _isDialog;

  @override
  State<VCommand> createState() => _VCommandState();
}

class _VCommandState extends State<VCommand>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _query = '';
  int _highlightedIndex = 0;
  // True for one frame after the keyboard or a new query moved the highlight,
  // so the highlighted row scrolls into view (hovering does not scroll).
  bool _scrollToHighlight = false;
  List<VCommandItemData> _allItems = [];
  List<VCommandItemData> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: VAnimations.defaults.fast, // fallback default
    );
    // Reconfigured with theme tokens in didChangeDependencies.
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: VAnimations.defaults.curveEaseOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.96, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: VAnimations.defaults.curveEaseOut,
      ),
    );

    if (widget.open) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _animationController.duration = theme.animations.fast;

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: theme.animations.curveEaseOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.96, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: theme.animations.curveEaseOut,
      ),
    );
  }

  @override
  void didUpdateWidget(VCommand oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open) {
      if (widget.open) {
        unawaited(_animationController.forward());
        _searchFocusNode.requestFocus();
      } else {
        unawaited(_animationController.reverse());
        _searchController.clear();
        setState(() {
          _query = '';
          _highlightedIndex = 0;
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _collectItems() {
    _allItems = [];
    _collectItemsFromChildren(widget.children);
    _applyFilter();
  }

  void _collectItemsFromChildren(List<Widget> children) {
    for (final child in children) {
      if (child is VCommandItem) {
        _allItems.add(
          VCommandItemData(
            value: child.value,
            keywords: child.keywords,
            enabled: child.enabled,
            onTap: child.onTap,
          ),
        );
      } else if (child is VCommandGroup) {
        _collectItemsFromChildren(child.children);
      } else if (child is VCommandList) {
        _collectItemsFromChildren(child.children);
      }
    }
  }

  void _applyFilter() {
    if (_query.isEmpty) {
      _filteredItems = _allItems.where((item) => item.enabled).toList();
    } else {
      if (widget.filter != null) {
        _filteredItems = _allItems
            .where((item) => item.enabled && widget.filter!(item, _query))
            .toList();
      } else {
        final queryLower = _query.toLowerCase();
        _filteredItems = _allItems.where((item) {
          if (!item.enabled) return false;
          if (item.value.toLowerCase().contains(queryLower)) return true;
          if (item.keywords?.any((k) => k.toLowerCase().contains(queryLower)) ??
              false) {
            return true;
          }
          return false;
        }).toList();
      }
    }

    if (_highlightedIndex >= _filteredItems.length) {
      _highlightedIndex = _filteredItems.isEmpty
          ? 0
          : _filteredItems.length - 1;
    }
  }

  void _handleSearch(String value) {
    setState(() {
      _query = value;
      _highlightedIndex = 0;
      _scrollToHighlight = true;
      _applyFilter();
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    // Holding an arrow key keeps moving the highlight.
    final isArrow =
        event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.arrowUp;
    if (event is! KeyDownEvent && !(event is KeyRepeatEvent && isArrow)) {
      return;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _scrollToHighlight = true;
        if (_filteredItems.isNotEmpty) {
          _highlightedIndex = (_highlightedIndex + 1) % _filteredItems.length;
        }
      });
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _scrollToHighlight = true;
        if (_filteredItems.isNotEmpty) {
          _highlightedIndex =
              (_highlightedIndex - 1 + _filteredItems.length) %
              _filteredItems.length;
        }
      });
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (_highlightedIndex >= 0 && _highlightedIndex < _filteredItems.length) {
        _selectItem(_filteredItems[_highlightedIndex]);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (_query.isNotEmpty) {
        _searchController.clear();
        setState(() {
          _query = '';
          _highlightedIndex = 0;
          _applyFilter();
        });
      } else if (widget._isDialog) {
        widget.onOpenChanged?.call(false);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.home) {
      setState(() {
        _scrollToHighlight = true;
        _highlightedIndex = 0;
      });
    } else if (event.logicalKey == LogicalKeyboardKey.end) {
      setState(() {
        _scrollToHighlight = true;
        if (_filteredItems.isNotEmpty) {
          _highlightedIndex = _filteredItems.length - 1;
        }
      });
    }
  }

  // WHY: A Focus that only observes keys; unlike a KeyboardListener it needs
  // no FocusNode of ours, so nothing leaks on rebuild.
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    _handleKeyEvent(event);
    return KeyEventResult.ignored;
  }

  void _selectItem(VCommandItemData item) {
    item.onTap?.call();
    if (widget._isDialog) {
      widget.onOpenChanged?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _collectItems();

    final result = widget._isDialog
        ? _buildDialog(context)
        : _buildInline(context);
    if (_scrollToHighlight) {
      // The rows below read the flag in this build; clear it for the next.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToHighlight = false;
      });
    }
    return result;
  }

  Widget _buildInline(BuildContext context) {
    final theme = VTheme.of(context);
    final inlineThemeStyle = theme.componentOverrides.get<VCommandStyle>();
    final inlineResolvedStyle =
        inlineThemeStyle?.merge(widget.style) ?? widget.style;

    final bgColor =
        inlineResolvedStyle?.backgroundColor ?? theme.colors.popover;
    final borderClr = inlineResolvedStyle?.borderColor ?? theme.colors.border;
    final borderRad =
        inlineResolvedStyle?.borderRadius ?? theme.radius.mdRadius;

    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onKeyEvent: _onKey,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderClr),
            borderRadius: borderRad,
            boxShadow: inlineResolvedStyle?.shadows,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildDialog(BuildContext context) {
    if (!widget.open) return const SizedBox.shrink();

    final theme = VTheme.of(context);
    final dlgThemeStyle = theme.componentOverrides.get<VCommandStyle>();
    final dlgResolvedStyle = dlgThemeStyle?.merge(widget.style) ?? widget.style;

    final dlgBgColor =
        dlgResolvedStyle?.backgroundColor ?? theme.colors.popover;
    final dlgBorderColor = dlgResolvedStyle?.borderColor ?? theme.colors.border;
    final dlgBorderRadius =
        dlgResolvedStyle?.borderRadius ?? theme.radius.lgRadius;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: GestureDetector(
        onTap: () => widget.onOpenChanged?.call(false),
        child: Container(
          color: theme.colors.scrim,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent tap from closing
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FocusTraversalGroup(
                  policy: WidgetOrderTraversalPolicy(),
                  child: Focus(
                    canRequestFocus: false,
                    skipTraversal: true,
                    onKeyEvent: _onKey,
                    child: Container(
                      width: 400,
                      constraints: const BoxConstraints(maxHeight: 400),
                      decoration: BoxDecoration(
                        color: dlgBgColor,
                        border: Border.all(color: dlgBorderColor),
                        borderRadius: dlgBorderRadius,
                        boxShadow:
                            dlgResolvedStyle?.shadows ?? theme.shadows.lg,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _buildContent(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context) =>
      widget.children.map((child) {
        if (child is VCommandInput) {
          return _buildInput(context, child);
        } else if (child is VCommandList) {
          return Flexible(child: _buildList(context, child));
        }
        return child;
      }).toList();

  Widget _buildInput(BuildContext context, VCommandInput input) {
    final theme = VTheme.of(context);
    final inputThemeStyle = theme.componentOverrides.get<VCommandStyle>();
    final inputResolvedStyle =
        inputThemeStyle?.merge(widget.style) ?? widget.style;

    final inputPadding =
        inputResolvedStyle?.padding ?? EdgeInsets.all(theme.spacing.md);
    final inputStyle =
        inputResolvedStyle?.inputTextStyle ??
        theme.typography.bodyMedium.copyWith(
          color: inputResolvedStyle?.foregroundColor ?? theme.colors.foreground,
        );

    final placeholder =
        input.placeholder ??
        widget.placeholder ??
        VoloLocalizations.of(context).commandPlaceholder;

    return Container(
      padding: inputPadding,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colors.border)),
      ),
      child: Row(
        children: [
          VIcons.search(size: 18, color: theme.colors.mutedForeground),
          SizedBox(width: theme.spacing.sm),
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                if (_query.isEmpty)
                  IgnorePointer(
                    child: Text(
                      placeholder,
                      style: inputStyle.copyWith(
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                  ),
                EditableText(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  style: inputStyle,
                  cursorColor: theme.colors.primary,
                  backgroundCursorColor: theme.colors.muted,
                  onChanged: _handleSearch,
                  autofocus: input.autofocus,
                ),
              ],
            ),
          ),
          if (widget.loading)
            _LoadingIndicator(color: theme.colors.mutedForeground),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, VCommandList list) {
    final theme = VTheme.of(context);

    // Check if there are any visible items
    final hasVisibleItems = _filteredItems.isNotEmpty;

    if (!hasVisibleItems) {
      final l10n = VoloLocalizations.of(context);
      // Find VCommandEmpty in children
      for (final child in list.children) {
        if (child is VCommandEmpty) {
          return Padding(
            padding: EdgeInsets.all(theme.spacing.lg),
            child:
                child.child ??
                Text(
                  l10n.commandNoResults,
                  style: theme.typography.bodyMedium.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                  textAlign: TextAlign.center,
                ),
          );
        }
      }

      if (widget.emptyBuilder != null) {
        return Padding(
          padding: EdgeInsets.all(theme.spacing.lg),
          child: widget.emptyBuilder!(_query),
        );
      }

      return Padding(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: Text(
          l10n.commandNoResults,
          style: theme.typography.bodyMedium.copyWith(
            color: theme.colors.mutedForeground,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildListChildren(context, list.children),
      ),
    );
  }

  List<Widget> _buildListChildren(BuildContext context, List<Widget> children) {
    final result = <Widget>[];
    var itemIndex = 0;

    for (final child in children) {
      if (child is VCommandEmpty) {
        // Skip empty, handled above
        continue;
      } else if (child is VCommandGroup) {
        final groupItems = _buildGroupItems(context, child.children, itemIndex);
        if (groupItems.isNotEmpty) {
          result.add(_buildGroupWidget(context, child.heading, groupItems));
          itemIndex += child.children.whereType<VCommandItem>().length;
        }
      } else if (child is VCommandItem) {
        if (_isItemVisible(child)) {
          result.add(_buildItemWidget(context, child, itemIndex));
          itemIndex++;
        }
      } else if (child is VCommandSeparator) {
        result.add(_buildSeparator(context));
      } else {
        result.add(child);
      }
    }

    return result;
  }

  List<Widget> _buildGroupItems(
    BuildContext context,
    List<Widget> children,
    int startIndex,
  ) {
    final result = <Widget>[];
    var index = startIndex;

    for (final child in children) {
      if (child is VCommandItem && _isItemVisible(child)) {
        result.add(_buildItemWidget(context, child, index));
        index++;
      }
    }

    return result;
  }

  bool _isItemVisible(VCommandItem item) {
    // A disabled item is hidden with or without a query.
    if (!item.enabled) return false;
    if (_query.isEmpty) return true;

    if (widget.filter != null) {
      return widget.filter!(
        VCommandItemData(
          value: item.value,
          keywords: item.keywords,
          enabled: item.enabled,
          onTap: item.onTap,
        ),
        _query,
      );
    }

    final queryLower = _query.toLowerCase();
    if (item.value.toLowerCase().contains(queryLower)) return true;
    if (item.keywords?.any((k) => k.toLowerCase().contains(queryLower)) ??
        false) {
      return true;
    }
    return false;
  }

  Widget _buildGroupWidget(
    BuildContext context,
    String? heading,
    List<Widget> items,
  ) {
    final theme = VTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (heading != null)
          Padding(
            padding: EdgeInsets.fromLTRB(
              theme.spacing.md,
              theme.spacing.sm,
              theme.spacing.md,
              theme.spacing.xs,
            ),
            child: Text(
              heading,
              style: theme.typography.labelSmall.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ),
        ...items,
      ],
    );
  }

  Widget _buildItemWidget(BuildContext context, VCommandItem item, int index) {
    final theme = VTheme.of(context);
    final isHighlighted = _getFilteredIndex(item) == _highlightedIndex;

    return _ScrollIntoView(
      active: isHighlighted && _scrollToHighlight,
      child: GestureDetector(
        onTap: item.enabled
            ? () => _selectItem(
                VCommandItemData(
                  value: item.value,
                  keywords: item.keywords,
                  enabled: item.enabled,
                  onTap: item.onTap,
                ),
              )
            : null,
        child: MouseRegion(
          onEnter: (_) {
            final filteredIndex = _getFilteredIndex(item);
            if (filteredIndex != -1) {
              setState(() => _highlightedIndex = filteredIndex);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.md,
              vertical: theme.spacing.md,
            ),
            color: isHighlighted ? theme.colors.accent : VColors.transparent,
            child: Opacity(
              opacity: item.enabled ? 1.0 : 0.5,
              child: Row(
                children: [
                  if (item.leading != null)
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        end: theme.spacing.sm,
                      ),
                      child: item.leading,
                    ),
                  Expanded(
                    child: DefaultTextStyle.merge(
                      style: theme.typography.bodyMedium.copyWith(
                        color: theme.colors.foreground,
                      ),
                      child: _query.isNotEmpty
                          ? _buildHighlightedText(
                              context,
                              item.child,
                              _query,
                              theme,
                            )
                          : item.child,
                    ),
                  ),
                  if (item.trailing != null)
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: theme.spacing.sm,
                      ),
                      child: item.trailing,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _getFilteredIndex(VCommandItem item) {
    for (var i = 0; i < _filteredItems.length; i++) {
      if (_filteredItems[i].value == item.value) {
        return i;
      }
    }
    return -1;
  }

  Widget _buildHighlightedText(
    BuildContext context,
    Widget child,
    String query,
    VThemeData theme,
  ) {
    if (child is Text && child.data != null) {
      final text = child.data!;
      final queryLower = query.toLowerCase();
      final textLower = text.toLowerCase();
      final startIndex = textLower.indexOf(queryLower);

      if (startIndex == -1) return child;

      final endIndex = startIndex + query.length;
      final style =
          child.style ??
          theme.typography.bodyMedium.copyWith(color: theme.colors.foreground);

      return Text.rich(
        TextSpan(
          style: style,
          children: [
            if (startIndex > 0) TextSpan(text: text.substring(0, startIndex)),
            TextSpan(
              text: text.substring(startIndex, endIndex),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colors.primary,
              ),
            ),
            if (endIndex < text.length)
              TextSpan(text: text.substring(endIndex)),
          ],
        ),
      );
    }
    return child;
  }

  Widget _buildSeparator(BuildContext context) {
    final theme = VTheme.of(context);
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(vertical: theme.spacing.xs),
      color: theme.colors.border,
    );
  }
}

/// Snapshot of a [VCommandItem] handed to a [VCommandFilter].
class VCommandItemData {
  const VCommandItemData({
    required this.value,
    this.keywords,
    this.enabled = true,
    this.onTap,
  });

  /// Text matched against the query.
  final String value;

  /// Extra words that also match the query.
  final List<String>? keywords;

  /// Whether the item can be selected.
  final bool enabled;

  /// Called when the item is selected.
  final VoidCallback? onTap;
}

/// Search field marker inside a [VCommand]; the palette draws the field.
class VCommandInput extends StatelessWidget {
  const VCommandInput({super.key, this.placeholder, this.autofocus = true});

  /// Hint shown while the field is empty.
  final String? placeholder;

  /// Whether the field takes focus when first shown.
  final bool autofocus;

  @override
  // This widget is rendered by VCommand parent
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Scrollable results region of a [VCommand] holding groups and items.
class VCommandList extends StatelessWidget {
  const VCommandList({required this.children, super.key});

  /// [VCommandItem], [VCommandGroup], [VCommandSeparator] and [VCommandEmpty].
  final List<Widget> children;

  @override
  // This widget is rendered by VCommand parent
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Custom empty state shown by a [VCommandList] when nothing matches.
class VCommandEmpty extends StatelessWidget {
  const VCommandEmpty({super.key, this.child});

  /// Content to show; the localized "no results" text when null.
  final Widget? child;

  @override
  // This widget is rendered by VCommand parent
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Labeled group of [VCommandItem] rows inside a [VCommandList].
class VCommandGroup extends StatelessWidget {
  const VCommandGroup({required this.children, super.key, this.heading});

  /// Small caption above the group.
  final String? heading;

  /// Items of the group.
  final List<Widget> children;

  @override
  // This widget is rendered by VCommand parent
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// One selectable command row in a [VCommand].
///
/// ```dart
/// VCommandItem(
///   value: 'calendar',
///   keywords: ['date', 'agenda'],
///   leading: Icon(Icons.calendar_today),
///   trailing: VCommandShortcut(keys: ['Ctrl', 'K']),
///   onTap: () => openCalendar(),
///   child: Text('Calendar'),
/// )
/// ```
class VCommandItem extends StatelessWidget {
  const VCommandItem({
    required this.value,
    required this.child,
    super.key,
    this.onTap,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.keywords,
  });

  /// Text matched against the query.
  final String value;

  /// Called when the row is tapped or chosen with Enter.
  final VoidCallback? onTap;

  /// Widget before the child, such as an icon.
  final Widget? leading;

  /// Content of the row, usually a [Text] that takes the palette text style.
  final Widget child;

  /// Widget after the child, such as a [VCommandShortcut].
  final Widget? trailing;

  /// Whether the row can be selected; false hides it from results.
  final bool enabled;

  /// Extra words that also match the query.
  final List<String>? keywords;

  @override
  // This widget is rendered by VCommand parent
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Thin line between groups of results in a [VCommandList].
class VCommandSeparator extends StatelessWidget {
  const VCommandSeparator({super.key});

  @override
  // This widget is rendered by VCommand parent
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Row of keycap chips that shows a keyboard shortcut.
class VCommandShortcut extends StatelessWidget {
  const VCommandShortcut({required this.keys, super.key});

  /// Key labels, one chip each, such as `['Ctrl', 'K']`.
  final List<String> keys;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: keys
          .map(
            (key) => Container(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.sm,
                vertical: theme.spacing.xxs,
              ),
              margin: EdgeInsetsDirectional.only(start: theme.spacing.xs),
              decoration: BoxDecoration(
                color: theme.colors.muted,
                borderRadius: theme.radius.smRadius,
                border: Border.all(color: theme.colors.border),
              ),
              child: Text(
                key,
                style: theme.typography.labelSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

/// Scrolls its child into view when [active] turns true.
class _ScrollIntoView extends StatefulWidget {
  const _ScrollIntoView({required this.active, required this.child});

  final bool active;
  final Widget child;

  @override
  State<_ScrollIntoView> createState() => _ScrollIntoViewState();
}

class _ScrollIntoViewState extends State<_ScrollIntoView> {
  @override
  void initState() {
    super.initState();
    if (widget.active) _scheduleScroll();
  }

  @override
  void didUpdateWidget(_ScrollIntoView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) _scheduleScroll();
  }

  void _scheduleScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && Scrollable.maybeOf(context) != null) {
        unawaited(Scrollable.ensureVisible(context));
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Loading indicator.
class _LoadingIndicator extends StatefulWidget {
  const _LoadingIndicator({required this.color});

  final Color color;

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
    final theme = VTheme.of(context);
    _controller.duration = theme.animations.verySlow;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: VoloLocalizations.of(context).loading,
    liveRegion: true,
    child: AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.rotate(
        angle: _controller.value * 2 * 3.14159,
        child: VIcons.refresh(size: 16, color: widget.color),
      ),
    ),
  );
}
