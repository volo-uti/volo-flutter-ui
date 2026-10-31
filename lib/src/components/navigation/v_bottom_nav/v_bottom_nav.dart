import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'package:volo_flutter_ui/src/utils/v_debug.dart';
import 'v_bottom_nav_style.dart';

/// An item displayed in a [VBottomNav].
///
/// Destination of a [VBottomNav]: an icon, a label, and an optional badge.
///
/// ## Basic Usage
///
/// ```dart
/// VBottomNavItem(
///   key: 'home',
///   icon: Icon(Icons.home_outlined),
///   label: 'Home',
///   activeIcon: Icon(Icons.home),
/// )
/// ```
class VBottomNavItem {
  /// Creates a destination.
  const VBottomNavItem({
    required this.key,
    required this.icon,
    required this.label,
    this.activeIcon,
    this.badge,
  });

  /// Identifier of the destination, such as a route name, used in debug logs.
  final String key;

  /// Icon shown while the destination is not selected.
  final Widget icon;

  /// Text under the icon, also the accessibility label.
  final String label;

  /// Icon shown instead of [icon] while selected.
  final Widget? activeIcon;

  /// Widget pinned to the icon's top right corner, such as a [VBadge].
  final Widget? badge;
}

/// Bottom navigation bar for primary sections.
///
/// {@category Navigation}
///
/// ## Overview
///
/// [VBottomNav] shows 3 to 5 destinations at the bottom of the screen and
/// reports the tapped index through [onTap].
///
/// ## Basic Usage
///
/// ```dart
/// VBottomNav(
///   selectedIndex: _currentIndex,
///   onTap: (index) => setState(() => _currentIndex = index),
///   items: [
///     VBottomNavItem(key: 'home', icon: Icon(Icons.home), label: 'Home'),
///     VBottomNavItem(key: 'search', icon: Icon(Icons.search), label: 'Search'),
///     VBottomNavItem(key: 'profile', icon: Icon(Icons.person), label: 'Profile'),
///   ],
/// )
/// ```
///
/// ## Variants
///
/// - [VBottomNav.new] - Shows the label of the selected item only
/// - [VBottomNav.labeled] - Shows every label
///
/// ## Navigation with badges
///
/// ```dart
/// VBottomNav(
///   selectedIndex: 0,
///   onTap: (index) {},
///   items: [
///     VBottomNavItem(
///       key: 'inbox',
///       icon: Icon(Icons.inbox),
///       label: 'Inbox',
///       badge: VBadge(label: Text('5')),
///     ),
///     VBottomNavItem(key: 'sent', icon: Icon(Icons.send), label: 'Sent'),
///     VBottomNavItem(key: 'trash', icon: Icon(Icons.delete), label: 'Trash'),
///   ],
/// )
/// ```
///
/// ## Always labeled navigation
///
/// ```dart
/// VBottomNav.labeled(
///   selectedIndex: 0,
///   onTap: (index) {},
///   items: [
///     VBottomNavItem(key: 'home', icon: Icon(Icons.home), label: 'Home'),
///     VBottomNavItem(key: 'explore', icon: Icon(Icons.explore), label: 'Explore'),
///     VBottomNavItem(key: 'library', icon: Icon(Icons.library_books), label: 'Library'),
///   ],
/// )
/// ```
///
/// See also:
///
/// - [VBottomNavItem], for individual navigation items
/// - [VAppBar], for top navigation
/// - [VTabs], for content switching within a section
class VBottomNav extends StatelessWidget {
  /// Creates a bar that shows the label of the selected item only.
  const VBottomNav({
    required this.items,
    super.key,
    this.selectedIndex = 0,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8,
    this.style,
  }) : _variant = _VBottomNavVariant.defaultNav,
       assert(items.length >= 3, 'VBottomNav requires at least 3 items');

  /// Creates a bar that shows every label.
  const VBottomNav.labeled({
    required this.items,
    super.key,
    this.selectedIndex = 0,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8,
    this.style,
  }) : _variant = _VBottomNavVariant.labeled,
       assert(items.length >= 3, 'VBottomNav requires at least 3 items');

  final _VBottomNavVariant _variant;

  /// Destinations to show, at least 3 and at most 5 for a usable layout.
  final List<VBottomNavItem> items;

  /// Index of the selected destination, clamped to the item range.
  final int selectedIndex;

  /// Called with the index of a tapped destination.
  final ValueChanged<int>? onTap;

  /// Bar fill color, defaulting to the theme background.
  final Color? backgroundColor;

  /// Icon and label color of the selected item, defaulting to primary.
  final Color? selectedItemColor;

  /// Icon and label color of the other items, defaulting to muted foreground.
  final Color? unselectedItemColor;

  /// Whether the bar casts a shadow, when above 0.
  final double elevation;

  /// Overrides for colors.
  final VBottomNavStyle? style;

  int get _effectiveSelectedIndex => selectedIndex.clamp(0, items.length - 1);

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides
    final themeStyle = theme.componentOverrides.get<VBottomNavStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;
    final colors = theme.colors;
    final typography = theme.typography;

    var bgColor = backgroundColor ?? colors.background;
    var selectedColor = selectedItemColor ?? colors.primary;
    var unselectedColor = unselectedItemColor ?? colors.mutedForeground;
    final borderColor = resolvedStyle?.borderColor;
    final indicatorColor = resolvedStyle?.indicatorColor;
    final indicatorHeight = resolvedStyle?.indicatorHeight ?? 4;

    if (resolvedStyle != null) {
      bgColor = resolvedStyle.backgroundColor ?? bgColor;
      selectedColor = resolvedStyle.activeColor ?? selectedColor;
      unselectedColor = resolvedStyle.inactiveColor ?? unselectedColor;
    }

    // WHY: A minimum height, not a fixed one: the safe-area inset is added to
    // the bar instead of eating its content area, and larger text can grow it.
    final bottomInset = MediaQuery.maybePaddingOf(context)?.bottom ?? 0;

    return FocusTraversalGroup(
      child: Container(
        constraints: BoxConstraints(minHeight: 80 + bottomInset),
        decoration: BoxDecoration(
          color: bgColor,
          border: borderColor == null
              ? null
              : Border(top: BorderSide(color: borderColor)),
          boxShadow: elevation > 0 ? theme.shadows.sm : null,
        ),
        child: SafeArea(
          top: false,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isSelected = index == _effectiveSelectedIndex;
                final color = isSelected ? selectedColor : unselectedColor;
                final showLabel =
                    _variant == _VBottomNavVariant.labeled || isSelected;

                void select() {
                  VDebug.log(
                    category: VDebugCategory.navigation,
                    component: 'VBottomNav',
                    name: item.key,
                    action: 'tapped',
                    value: 'index: $index',
                  );
                  onTap?.call(index);
                }

                // WCAG 2.5.8: Minimum touch target 24x24
                return Expanded(
                  child: Focus(
                    onKeyEvent: (node, event) {
                      // Enter and Space activate the focused destination.
                      if (event is KeyDownEvent &&
                          (event.logicalKey == LogicalKeyboardKey.enter ||
                              event.logicalKey ==
                                  LogicalKeyboardKey.numpadEnter ||
                              event.logicalKey == LogicalKeyboardKey.space)) {
                        select();
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: Builder(
                      builder: (focusContext) {
                        final isFocused = Focus.of(focusContext).hasFocus;
                        return Semantics(
                          button: true,
                          selected: isSelected,
                          label: item.label,
                          child: GestureDetector(
                            onTap: select,
                            behavior: HitTestBehavior.opaque,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                DecoratedBox(
                                  decoration: isFocused
                                      ? BoxDecoration(
                                          borderRadius: theme.radius.smRadius,
                                          border: Border.all(
                                            color: colors.ring,
                                            width: 2,
                                          ),
                                        )
                                      : const BoxDecoration(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          AnimatedScale(
                                            scale: isSelected ? 1.2 : 1.0,
                                            duration: theme.animations.normal,
                                            child: IconTheme(
                                              data: IconThemeData(
                                                color: color,
                                                size: 24,
                                              ),
                                              child: isSelected
                                                  ? (item.activeIcon ??
                                                        item.icon)
                                                  : item.icon,
                                            ),
                                          ),
                                          if (item.badge != null)
                                            Positioned(
                                              right: -8,
                                              top: -4,
                                              child: item.badge!,
                                            ),
                                        ],
                                      ),
                                      if (showLabel)
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: theme.spacing.xs,
                                          ),
                                          child: AnimatedOpacity(
                                            opacity: showLabel ? 1.0 : 0.0,
                                            duration: theme.animations.normal,
                                            // WHY: The item's Semantics already
                                            // carries the label; a second copy
                                            // makes a screen reader say it twice.
                                            child: ExcludeSemantics(
                                              child: Text(
                                                item.label,
                                                style: typography.labelSmall
                                                    .copyWith(
                                                      color: color,
                                                      fontWeight: isSelected
                                                          ? FontWeight.w600
                                                          : FontWeight.normal,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (isSelected && indicatorColor != null)
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    height: indicatorHeight,
                                    child: ExcludeSemantics(
                                      child: ColoredBox(color: indicatorColor),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

enum _VBottomNavVariant { defaultNav, labeled }
