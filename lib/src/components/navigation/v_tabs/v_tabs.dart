import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'package:volo_flutter_ui/src/utils/v_debug.dart';
import 'v_tabs_style.dart';

/// An item displayed in a [VTabs] widget.
///
/// One tab of a [VTabs]: a label, an optional icon and the content it shows.
///
/// ## Basic Usage
///
/// ```dart
/// VTab(
///   key: 'profile',
///   label: Text('Profile'),
///   icon: Icon(Icons.person),
///   content: ProfileView(),
/// )
/// ```
class VTab {
  /// Creates a tab.
  const VTab({
    required this.label,
    required this.content,
    this.key,
    this.icon,
    this.enabled = true,
  });

  /// Identifier of the tab, such as a route name, used in debug logs.
  final String? key;

  /// Name of the tab, usually a [Text].
  ///
  /// A plain [Text] picks up the theme's label style and the tab color.
  final Widget label;

  /// Widget shown below or beside the tab bar while this tab is selected.
  final Widget content;

  /// Icon shown before the label.
  final Widget? icon;

  /// Whether the tab can be selected; a disabled tab is dimmed and skipped.
  final bool enabled;
}

/// A tabbed interface for switching views.
///
/// {@category Navigation}
///
/// ## Overview
///
/// [VTabs] pairs a row or column of tabs with the content of the selected one.
/// It keeps the selected index itself and reports changes through [onChanged].
///
/// ## Basic Usage
///
/// ```dart
/// VTabs(
///   tabs: [
///     VTab(label: Text('Profile'), content: ProfileView()),
///     VTab(label: Text('Settings'), content: SettingsView()),
///   ],
/// )
/// ```
///
/// ## Variants
///
/// - [VTabs.new] - Default tabs with subtle background highlight
/// - [VTabs.pills] - Pill-shaped selected tab indicator
/// - [VTabs.underline] - Underline style tab indicator
///
/// ## Tabs with icons
///
/// ```dart
/// VTabs(
///   tabs: [
///     VTab(
///       label: Text('Home'),
///       icon: Icon(Icons.home),
///       content: HomeView(),
///     ),
///     VTab(
///       label: Text('Search'),
///       icon: Icon(Icons.search),
///       content: SearchView(),
///     ),
///     VTab(
///       label: Text('Settings'),
///       icon: Icon(Icons.settings),
///       content: SettingsView(),
///     ),
///   ],
/// )
/// ```
///
/// ## Pills style tabs
///
/// ```dart
/// VTabs.pills(
///   tabs: [
///     VTab(label: Text('Day'), content: DayView()),
///     VTab(label: Text('Week'), content: WeekView()),
///     VTab(label: Text('Month'), content: MonthView()),
///   ],
/// )
/// ```
///
/// ## Underline style tabs
///
/// ```dart
/// VTabs.underline(
///   tabs: [
///     VTab(label: Text('Overview'), content: OverviewTab()),
///     VTab(label: Text('Analytics'), content: AnalyticsTab()),
///     VTab(label: Text('Reports'), content: ReportsTab()),
///   ],
/// )
/// ```
///
/// ## Controlled tabs with callback
///
/// ```dart
/// VTabs(
///   initialIndex: 1,
///   onChanged: (index) => print('Selected tab: $index'),
///   tabs: [
///     VTab(label: Text('Tab 1'), content: Content1()),
///     VTab(label: Text('Tab 2'), content: Content2()),
///   ],
/// )
/// ```
///
/// ## Scrollable tabs for many items
///
/// ```dart
/// VTabs(
///   isScrollable: true,
///   tabs: List.generate(
///     10,
///     (i) => VTab(label: Text('Tab ${i + 1}'), content: Text('Content $i')),
///   ),
/// )
/// ```
///
/// ## Custom styling
///
/// ```dart
/// VTabs(
///   backgroundColor: Colors.grey.shade100,
///   selectedColor: Colors.blue,
///   unselectedColor: Colors.grey,
///   padding: EdgeInsets.symmetric(horizontal: 16),
///   tabPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
///   tabs: [...],
/// )
/// ```
///
/// See also:
///
/// - [VTab], for individual tab items
/// - [VBottomNav], for bottom navigation
/// - [VAppBar], for top app bar with tabs in bottom slot
class VTabs extends StatefulWidget {
  /// Creates tabs whose selected tab is filled with the card color.
  const VTabs({
    required this.tabs,
    super.key,
    this.initialIndex = 0,
    this.onChanged,
    this.isScrollable = false,
    this.orientation = Axis.horizontal,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.padding,
    this.tabPadding,
    this.borderRadius,
    this.indicatorBorderRadius,
    this.indicatorBorder,
    this.style,
  }) : _variant = _VTabsVariant.defaultTabs;

  /// Creates tabs whose selected tab is a primary-colored pill.
  const VTabs.pills({
    required this.tabs,
    super.key,
    this.initialIndex = 0,
    this.onChanged,
    this.isScrollable = false,
    this.orientation = Axis.horizontal,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.padding,
    this.tabPadding,
    this.borderRadius,
    this.indicatorBorderRadius,
    this.indicatorBorder,
    this.style,
  }) : _variant = _VTabsVariant.pills;

  /// Creates tabs whose selected tab has an underline.
  const VTabs.underline({
    required this.tabs,
    super.key,
    this.initialIndex = 0,
    this.onChanged,
    this.isScrollable = false,
    this.orientation = Axis.horizontal,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.padding,
    this.tabPadding,
    this.borderRadius,
    this.indicatorBorderRadius,
    this.indicatorBorder,
    this.style,
  }) : _variant = _VTabsVariant.underline;

  final _VTabsVariant _variant;

  /// Tabs to show, in order.
  final List<VTab> tabs;

  /// Index selected first, clamped to the tab range.
  final int initialIndex;

  /// Called with the new index when the selection changes by tap or key.
  final ValueChanged<int>? onChanged;

  /// Whether the tab bar scrolls instead of sharing the width evenly.
  final bool isScrollable;

  /// Direction of the tab bar; vertical puts a column at the start.
  final Axis orientation;

  /// Fill color of the tab bar.
  final Color? backgroundColor;

  /// Color of the selected tab's fill or text, depending on the variant.
  final Color? selectedColor;

  /// Text color of the unselected tabs.
  final Color? unselectedColor;

  /// Color of the underline in [VTabs.underline].
  final Color? indicatorColor;

  /// Space around the tab bar.
  final EdgeInsetsGeometry? padding;

  /// Space inside each tab.
  final EdgeInsetsGeometry? tabPadding;

  /// Corner radius of the tab bar.
  final BorderRadiusGeometry? borderRadius;

  /// Corner radius of the selected tab's fill.
  final BorderRadiusGeometry? indicatorBorderRadius;

  /// Border drawn around the selected tab.
  final BoxBorder? indicatorBorder;

  /// Overrides for colors and padding.
  final VTabsStyle? style;

  @override
  State<VTabs> createState() => _VTabsState();
}

class _VTabsState extends State<VTabs> {
  late int _selectedIndex;
  late FocusNode _focusNode;
  final List<FocusNode> _tabNodes = [];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    if (widget.tabs.isEmpty) {
      _selectedIndex = 0;
    } else {
      _selectedIndex = widget.initialIndex.clamp(0, widget.tabs.length - 1);
    }
    _syncTabNodes();
  }

  @override
  void didUpdateWidget(VTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    // WHY: The parent may shrink the tab list (a filtered or permission-gated
    // list) while a later tab is selected; keep the selection in range.
    if (widget.tabs.isEmpty) {
      _selectedIndex = 0;
    } else if (_selectedIndex >= widget.tabs.length) {
      _selectedIndex = widget.tabs.length - 1;
    }
    _syncTabNodes();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    for (final node in _tabNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // One focus node per tab, so a key press can move focus with the selection.
  void _syncTabNodes() {
    while (_tabNodes.length < widget.tabs.length) {
      _tabNodes.add(FocusNode(debugLabel: 'VTabs tab ${_tabNodes.length}'));
    }
    while (_tabNodes.length > widget.tabs.length) {
      _tabNodes.removeLast().dispose();
    }
  }

  // Index of the tab that holds focus, or the selected tab when none does.
  int get _anchorIndex {
    for (var i = 0; i < _tabNodes.length; i++) {
      if (_tabNodes[i].hasFocus) return i;
    }
    return _selectedIndex;
  }

  void _selectAndFocus(int index) {
    _selectTab(index);
    if (index < _tabNodes.length && widget.tabs[index].enabled) {
      _tabNodes[index].requestFocus();
    }
  }

  void _selectTab(int index) {
    if (!widget.tabs[index].enabled) return;
    if (index == _selectedIndex) return;

    final tabKey = widget.tabs[index].key;
    VDebug.log(
      category: VDebugCategory.navigation,
      component: 'VTabs',
      name: tabKey,
      action: 'selected',
      value: 'index: $index',
    );

    setState(() => _selectedIndex = index);
    widget.onChanged?.call(index);
  }

  // WHY: Wrapping search (modulo) — when navigating past the last tab,
  // wrap to the first (and vice versa). This matches WAI-ARIA roving
  // tabindex pattern for tab widgets.
  int _findNextEnabledTab(int from, int direction) {
    var index = from;
    for (var i = 0; i < widget.tabs.length; i++) {
      index = (index + direction) % widget.tabs.length;
      if (index < 0) index += widget.tabs.length;
      if (widget.tabs[index].enabled) return index;
    }
    return from;
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final isHorizontal = widget.orientation == Axis.horizontal;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final nextKey = isHorizontal
        ? (isRtl ? LogicalKeyboardKey.arrowLeft : LogicalKeyboardKey.arrowRight)
        : LogicalKeyboardKey.arrowDown;
    final prevKey = isHorizontal
        ? (isRtl ? LogicalKeyboardKey.arrowRight : LogicalKeyboardKey.arrowLeft)
        : LogicalKeyboardKey.arrowUp;

    if (event.logicalKey == nextKey) {
      final next = _findNextEnabledTab(_anchorIndex, 1);
      _selectAndFocus(next);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == prevKey) {
      final prev = _findNextEnabledTab(_anchorIndex, -1);
      _selectAndFocus(prev);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.home) {
      // Select first enabled tab
      for (var i = 0; i < widget.tabs.length; i++) {
        if (widget.tabs[i].enabled) {
          _selectAndFocus(i);
          break;
        }
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.end) {
      // Select last enabled tab
      for (var i = widget.tabs.length - 1; i >= 0; i--) {
        if (widget.tabs[i].enabled) {
          _selectAndFocus(i);
          break;
        }
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tabs.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = VTheme.of(context);
    // Apply style overrides
    final themeStyle = theme.componentOverrides.get<VTabsStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;
    final colors = theme.colors;
    final typography = theme.typography;

    // Apply resolvedStyle overrides to widget properties passed downstream
    final effectiveBackgroundColor =
        resolvedStyle?.backgroundColor ?? widget.backgroundColor;
    final effectiveSelectedColor =
        resolvedStyle?.activeColor ?? widget.selectedColor;
    final effectiveUnselectedColor =
        resolvedStyle?.inactiveColor ?? widget.unselectedColor;
    final effectiveIndicatorColor =
        resolvedStyle?.indicatorColor ?? widget.indicatorColor;
    final effectivePadding = resolvedStyle?.padding ?? widget.padding;

    final selectedIndex = _selectedIndex.clamp(0, widget.tabs.length - 1);
    final contentWidget = Expanded(
      child: AnimatedSwitcher(
        duration: theme.animations.fast,
        child: KeyedSubtree(
          key: ValueKey(selectedIndex),
          child: widget.tabs[selectedIndex].content,
        ),
      ),
    );

    // WHY: FocusTraversalGroup wraps both tab bar and content — ensures
    // Tab key cycles through tab buttons + content as a logical group,
    // while arrow keys navigate between tabs (WAI-ARIA Tabs pattern).
    if (widget.orientation == Axis.vertical) {
      return FocusTraversalGroup(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tab bar (vertical)
            _buildTabBar(
              context,
              colors,
              typography,
              bgColor: effectiveBackgroundColor,
              padding: effectivePadding,
              selectedColor: effectiveSelectedColor,
              unselectedColor: effectiveUnselectedColor,
              indicatorColor: effectiveIndicatorColor,
            ),
            // Tab content
            contentWidget,
          ],
        ),
      );
    }

    return FocusTraversalGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tab bar
          _buildTabBar(
            context,
            colors,
            typography,
            bgColor: effectiveBackgroundColor,
            padding: effectivePadding,
            selectedColor: effectiveSelectedColor,
            unselectedColor: effectiveUnselectedColor,
            indicatorColor: effectiveIndicatorColor,
          ),
          // Tab content
          contentWidget,
        ],
      ),
    );
  }

  Widget _buildTabBar(
    BuildContext context,
    VColors colors,
    VTypography typography, {
    Color? bgColor,
    EdgeInsetsGeometry? padding,
    Color? selectedColor,
    Color? unselectedColor,
    Color? indicatorColor,
  }) {
    final tabWidgets = List.generate(widget.tabs.length, (index) {
      final tab = widget.tabs[index];
      final isSelected = index == _selectedIndex;

      return _buildTab(
        context,
        tab,
        isSelected,
        index,
        colors,
        typography,
        selectedColor: selectedColor,
        unselectedColor: unselectedColor,
        indicatorColor: indicatorColor,
      );
    });

    Widget tabBar;
    if (widget.orientation == Axis.vertical) {
      if (widget.isScrollable) {
        tabBar = SingleChildScrollView(child: Column(children: tabWidgets));
      } else {
        tabBar = Column(mainAxisSize: MainAxisSize.min, children: tabWidgets);
      }
    } else if (widget.isScrollable) {
      tabBar = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: tabWidgets),
      );
    } else {
      tabBar = Row(children: tabWidgets);
    }

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: widget.borderRadius,
          border: widget._variant == _VTabsVariant.underline
              ? (widget.orientation == Axis.vertical
                    ? Border(right: BorderSide(color: colors.border))
                    : Border(bottom: BorderSide(color: colors.border)))
              : null,
        ),
        child: ClipRRect(
          borderRadius:
              widget.borderRadius?.resolve(Directionality.of(context)) ??
              BorderRadius.zero,
          child: tabBar,
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    VTab tab,
    bool isSelected,
    int index,
    VColors colors,
    VTypography typography, {
    Color? selectedColor,
    Color? unselectedColor,
    Color? indicatorColor,
  }) {
    final theme = VTheme.of(context);
    // Custom tab padding or default padding
    final defaultTabPadding = EdgeInsets.symmetric(
      horizontal: theme.spacing.lg,
      vertical: widget._variant == _VTabsVariant.underline
          ? theme.spacing.md
          : theme.spacing.sm,
    );

    final tabWidget = _TabItem(
      tab: tab,
      isSelected: isSelected,
      variant: widget._variant,
      colors: colors,
      typography: typography,
      selectedColor: selectedColor,
      unselectedColor: unselectedColor,
      indicatorColor: indicatorColor,
      indicatorBorderRadius: widget.indicatorBorderRadius,
      indicatorBorder: widget.indicatorBorder,
      tabPadding: widget.tabPadding ?? defaultTabPadding,
      onTap: tab.enabled ? () => _selectTab(index) : null,
      focusNode: index < _tabNodes.length ? _tabNodes[index] : null,
    );

    if (widget.orientation == Axis.vertical || widget.isScrollable) {
      return tabWidget;
    }
    return Expanded(child: tabWidget);
  }
}

enum _VTabsVariant { defaultTabs, pills, underline }

class _TabItem extends StatefulWidget {
  const _TabItem({
    required this.tab,
    required this.isSelected,
    required this.variant,
    required this.colors,
    required this.typography,
    required this.tabPadding,
    required this.onTap,
    this.focusNode,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.indicatorBorderRadius,
    this.indicatorBorder,
  });

  final VTab tab;
  final bool isSelected;
  final _VTabsVariant variant;
  final VColors colors;
  final VTypography typography;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final BorderRadiusGeometry? indicatorBorderRadius;
  final BoxBorder? indicatorBorder;
  final EdgeInsetsGeometry tabPadding;
  final VoidCallback? onTap;
  final FocusNode? focusNode;

  @override
  State<_TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<_TabItem> {
  bool _isHovered = false;
  bool _isFocused = false;

  bool get _isEnabled => widget.tab.enabled && widget.onTap != null;

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
    final colors = widget.colors;
    final typography = widget.typography;

    // Use custom colors or default colors
    final defaultSelectedTextColor = widget.variant == _VTabsVariant.pills
        ? colors.primaryForeground
        : colors.foreground;
    final selectedTextColor = widget.selectedColor != null
        ? (widget.variant == _VTabsVariant.pills
              ? colors.primaryForeground
              : widget.selectedColor!)
        : defaultSelectedTextColor;
    final unselectedTextColor =
        widget.unselectedColor ?? colors.mutedForeground;

    final textColor = !widget.tab.enabled
        ? unselectedTextColor.withValues(alpha: 0.5)
        : widget.isSelected
        ? selectedTextColor
        : unselectedTextColor;

    final labelStyle = typography.labelMedium.copyWith(
      color: textColor,
      fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
    );

    final Widget tabContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.tab.icon != null)
          Padding(
            padding: EdgeInsetsDirectional.only(
              end: VTheme.of(context).spacing.sm,
            ),
            child: IconTheme(
              data: IconThemeData(color: textColor, size: 16),
              child: widget.tab.icon!,
            ),
          ),
        DefaultTextStyle.merge(style: labelStyle, child: widget.tab.label),
      ],
    );

    BoxDecoration? decoration;
    if (widget.isSelected) {
      switch (widget.variant) {
        case _VTabsVariant.defaultTabs:
          // Selected tab is a raised card: card background plus a small shadow
          decoration = BoxDecoration(
            color: widget.selectedColor ?? colors.card,
            borderRadius: widget.indicatorBorderRadius ?? theme.radius.smRadius,
            border: widget.indicatorBorder,
            boxShadow: theme.shadows.sm,
          );
          break;
        case _VTabsVariant.pills:
          decoration = BoxDecoration(
            color: widget.selectedColor ?? colors.primary,
            borderRadius: widget.indicatorBorderRadius ?? theme.radius.xlRadius,
            border: widget.indicatorBorder,
          );
          break;
        case _VTabsVariant.underline:
          decoration = BoxDecoration(
            borderRadius: widget.indicatorBorderRadius,
            border:
                widget.indicatorBorder ??
                Border(
                  bottom: BorderSide(
                    color:
                        widget.indicatorColor ??
                        widget.selectedColor ??
                        colors.primary,
                    width: 2,
                  ),
                ),
          );
          break;
      }
    } else if (_isHovered && _isEnabled) {
      // Add background color on hover
      switch (widget.variant) {
        case _VTabsVariant.defaultTabs:
          decoration = BoxDecoration(
            color: colors.muted.withValues(alpha: 0.5),
            borderRadius: widget.indicatorBorderRadius ?? theme.radius.xsRadius,
          );
          break;
        case _VTabsVariant.pills:
          decoration = BoxDecoration(
            color: colors.muted.withValues(alpha: 0.5),
            borderRadius: widget.indicatorBorderRadius ?? theme.radius.xlRadius,
          );
          break;
        case _VTabsVariant.underline:
          decoration = BoxDecoration(
            color: colors.muted.withValues(alpha: 0.3),
          );
          break;
      }
    }

    // Focus ring decoration (WCAG 2.4.7)
    final focusDecoration = _isFocused && _isEnabled
        ? BoxDecoration(
            borderRadius: theme.radius.smRadius,
            border: Border.all(color: colors.ring, width: 2),
          )
        : null;

    return Focus(
      focusNode: widget.focusNode,
      canRequestFocus: _isEnabled,
      onFocusChange: (focused) {
        setState(() => _isFocused = focused);
        // Keep a focused tab visible inside a scrollable tab bar.
        if (focused && Scrollable.maybeOf(context) != null) {
          Scrollable.ensureVisible(context);
        }
      },
      onKeyEvent: (node, event) {
        // Enter and Space activate the focused tab.
        if (event is KeyDownEvent &&
            _isEnabled &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.numpadEnter ||
                event.logicalKey == LogicalKeyboardKey.space)) {
          widget.onTap?.call();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Semantics(
        button: true,
        selected: widget.isSelected,
        enabled: _isEnabled,
        child: MouseRegion(
          onEnter: _handleMouseEnter,
          onExit: _handleMouseExit,
          cursor: _isEnabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: widget.onTap,
            behavior: HitTestBehavior.opaque,
            child: DecoratedBox(
              decoration: focusDecoration ?? const BoxDecoration(),
              child: AnimatedContainer(
                duration: theme.animations.fast,
                padding: widget.tabPadding,
                decoration: decoration,
                child: Center(child: tabContent),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
