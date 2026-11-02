import 'dart:async';

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

/// Selected tab index of a [VTabs] that code outside it can read and change.
///
/// Pass it to [VTabs.controller]. Setting [index] selects that tab, and
/// listeners hear every change, whether it comes from code, a tap, a key or a
/// swipe. Code may select a disabled tab; only taps, keys and swipes skip it.
/// Dispose the controller when it is no longer needed.
///
/// ```dart
/// final controller = VTabsController(initialIndex: 1);
///
/// VTabs(controller: controller, tabs: tabs);
///
/// // Select the first tab from elsewhere.
/// controller.index = 0;
/// ```
class VTabsController extends ChangeNotifier {
  /// Creates a controller whose selected index starts at [initialIndex].
  VTabsController({int initialIndex = 0}) : _index = initialIndex;

  int _index;

  /// Index of the selected tab.
  ///
  /// An index outside the tab range shows the nearest tab, and [VTabs] moves
  /// the index into range after the frame.
  int get index => _index;

  /// Selects the tab at [value] and notifies listeners when it changes.
  set index(int value) {
    if (value == _index) return;
    _index = value;
    notifyListeners();
  }
}

/// A tabbed interface for switching views.
///
/// {@category Navigation}
///
/// ## Overview
///
/// [VTabs] pairs a row or column of tabs with the content of the selected one.
/// It keeps the selected index itself, or in a [controller], and reports the
/// user's changes through [onChanged]. With [swipeable], the content can be
/// swiped sideways to the next or previous tab.
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
/// ## Tabs driven from outside, with swipeable content
///
/// ```dart
/// final controller = VTabsController();
///
/// VTabs(
///   controller: controller,
///   swipeable: true,
///   tabs: [
///     VTab(label: Text('Inbox'), content: InboxView()),
///     VTab(label: Text('Archive'), content: ArchiveView()),
///   ],
/// )
///
/// // Show the archive from a button elsewhere.
/// controller.index = 1;
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
    this.controller,
    this.onChanged,
    this.isScrollable = false,
    this.swipeable = false,
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
    this.controller,
    this.onChanged,
    this.isScrollable = false,
    this.swipeable = false,
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
    this.controller,
    this.onChanged,
    this.isScrollable = false,
    this.swipeable = false,
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
  ///
  /// It is read once; to change the selection later, use [controller]. It is
  /// ignored when [controller] is set.
  final int initialIndex;

  /// Reads and changes the selected tab from outside the tabs.
  ///
  /// When null, the tabs keep their own selection, starting at [initialIndex].
  final VTabsController? controller;

  /// Called with the new index when the user selects a tab by tap, key or swipe.
  ///
  /// It is not called when code sets [VTabsController.index].
  final ValueChanged<int>? onChanged;

  /// Whether the tab bar scrolls instead of sharing the width evenly.
  final bool isScrollable;

  /// Whether the content can be swiped sideways to the next or previous tab.
  ///
  /// The content is then a page view that follows the selected tab, and the
  /// tab follows the page a swipe settles on. A swipe that settles on a
  /// disabled tab slides back.
  final bool swipeable;

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

  /// Overrides for colors, padding, label text styles and the underline.
  final VTabsStyle? style;

  @override
  State<VTabs> createState() => _VTabsState();
}

class _VTabsState extends State<VTabs> {
  VTabsController? _internalController;
  late VTabsController _controller;
  late FocusNode _focusNode;
  final List<FocusNode> _tabNodes = [];
  PageController? _pageController;
  late VAnimations _animations;
  // Page animations started by a selection change that have not finished; the
  // pages they pass on the way must not select tabs.
  int _pageAnimations = 0;
  bool _selectingFromPage = false;

  VTabsController get _effectiveController =>
      widget.controller ??
      (_internalController ??= VTabsController(
        initialIndex: widget.tabs.isEmpty
            ? 0
            : widget.initialIndex.clamp(0, widget.tabs.length - 1),
      ));

  int get _selectedIndex => widget.tabs.isEmpty
      ? 0
      : _controller.index.clamp(0, widget.tabs.length - 1);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = _effectiveController..addListener(_handleControllerChange);
    _syncTabNodes();
    _keepIndexInRange();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animations = VTheme.of(context).animations;
  }

  @override
  void didUpdateWidget(VTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_handleControllerChange);
      _controller = _effectiveController..addListener(_handleControllerChange);
    }
    if (widget.controller != oldWidget.controller ||
        (widget.swipeable && !oldWidget.swipeable)) {
      _jumpPageAfterFrame();
    }
    _syncTabNodes();
    // WHY: The parent may shrink the tab list (a filtered or permission-gated
    // list) while a later tab is selected; keep the selection in range.
    _keepIndexInRange();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChange);
    _internalController?.dispose();
    _pageController?.dispose();
    _focusNode.dispose();
    for (final node in _tabNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleControllerChange() {
    setState(() {});
    if (!_selectingFromPage) _animatePageToSelection();
  }

  // An index outside the tabs shows the nearest tab now and is moved into range
  // after the frame, so listeners are not notified during a build.
  void _keepIndexInRange() {
    final index = _controller.index;
    if (widget.tabs.isEmpty || (index >= 0 && index < widget.tabs.length)) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.tabs.isEmpty) return;
      _controller.index = _selectedIndex;
    });
  }

  // Moves the page view to the selected tab without passing other pages.
  void _jumpPageAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pages = _pageController;
      if (!mounted || pages == null || !pages.hasClients) return;
      if (pages.page?.round() != _selectedIndex) {
        pages.jumpToPage(_selectedIndex);
      }
    });
  }

  void _animatePageToSelection() {
    final pages = _pageController;
    if (pages == null || !pages.hasClients) return;
    final target = _selectedIndex;
    if (pages.page?.round() == target) return;
    _pageAnimations++;
    unawaited(
      pages
          .animateToPage(
            target,
            duration: _animations.normal,
            curve: _animations.curveEaseOut,
          )
          .whenComplete(() => _pageAnimations--),
    );
  }

  // The tab follows the page a swipe settles on.
  bool _handlePageScroll(ScrollNotification notification) {
    if (notification.depth != 0 || notification is! ScrollEndNotification) {
      return false;
    }
    final page = _pageController?.page?.round();
    if (_pageAnimations > 0 || page == null || page == _selectedIndex) {
      return false;
    }
    if (page >= 0 && page < widget.tabs.length && widget.tabs[page].enabled) {
      _selectingFromPage = true;
      _selectTab(page);
      _selectingFromPage = false;
    } else {
      // A disabled tab cannot be selected, so its page slides back. The
      // scroll position is still ending its activity, so start after it.
      scheduleMicrotask(() {
        if (mounted) _animatePageToSelection();
      });
    }
    return false;
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

    _controller.index = index;
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
    final labelStyles = (
      text: resolvedStyle?.textStyle,
      selected: resolvedStyle?.selectedTextStyle,
      indicatorHeight: resolvedStyle?.indicatorHeight,
    );

    final selectedIndex = _selectedIndex;
    final contentWidget = Expanded(
      child: widget.swipeable
          ? NotificationListener<ScrollNotification>(
              onNotification: _handlePageScroll,
              child: PageView(
                controller: _pageController ??= PageController(
                  initialPage: selectedIndex,
                ),
                children: [for (final tab in widget.tabs) tab.content],
              ),
            )
          : AnimatedSwitcher(
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
              labelStyles: labelStyles,
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
            labelStyles: labelStyles,
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
    required _TabLabelStyles labelStyles,
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
        labelStyles: labelStyles,
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
    required _TabLabelStyles labelStyles,
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
      labelStyles: labelStyles,
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

/// Label text styles and underline thickness resolved from [VTabsStyle].
typedef _TabLabelStyles = ({
  TextStyle? text,
  TextStyle? selected,
  double? indicatorHeight,
});

class _TabItem extends StatefulWidget {
  const _TabItem({
    required this.tab,
    required this.isSelected,
    required this.variant,
    required this.colors,
    required this.typography,
    required this.tabPadding,
    required this.onTap,
    required this.labelStyles,
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
  final _TabLabelStyles labelStyles;
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

    // A disabled tab takes the unselected color, dimmed.
    final showsSelected = widget.isSelected && widget.tab.enabled;
    final defaultTextColor = showsSelected
        ? (widget.variant == _VTabsVariant.pills
              ? colors.primaryForeground
              : colors.foreground)
        : colors.mutedForeground;
    // A color field wins over a text style color; on pills selectedColor is
    // the fill, so the selected text keeps its color.
    final colorField = showsSelected
        ? (widget.variant == _VTabsVariant.pills ? null : widget.selectedColor)
        : widget.unselectedColor;

    var labelStyle = typography.labelMedium
        .copyWith(
          color: defaultTextColor,
          fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
        )
        .merge(widget.labelStyles.text)
        .merge(widget.isSelected ? widget.labelStyles.selected : null);
    var textColor = colorField ?? labelStyle.color ?? defaultTextColor;
    if (!widget.tab.enabled) textColor = textColor.withValues(alpha: 0.5);
    labelStyle = labelStyle.copyWith(color: textColor);

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
                    width: widget.labelStyles.indicatorHeight ?? 2,
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
