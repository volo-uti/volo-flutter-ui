import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_breadcrumb_style.dart';

/// An item displayed in a [VBreadcrumb].
///
/// One level of a [VBreadcrumb] trail: a label, an optional icon and a tap.
///
/// ## Basic Usage
///
/// ```dart
/// VBreadcrumbItem(
///   label: Text('Products'),
///   icon: Icon(Icons.shopping_bag),
///   onTap: () => Navigator.pushNamed(context, '/products'),
/// )
/// ```
class VBreadcrumbItem {
  /// Creates a breadcrumb level.
  const VBreadcrumbItem({
    required this.label,
    this.icon,
    this.onTap,
    this.active = false,
  });

  /// Name of the level, usually a [Text].
  ///
  /// A plain [Text] picks up the theme's body style and the item color.
  final Widget label;

  /// Icon shown before the label.
  final Widget? icon;

  /// Called when the level is tapped; a level without it is not a link.
  final VoidCallback? onTap;

  /// Whether this item is drawn as the current location.
  ///
  /// The last item is always current; this marks an earlier one as current.
  final bool active;
}

/// Shows the current location hierarchy.
///
/// {@category Navigation}
///
/// ## Overview
///
/// [VBreadcrumb] lists the path to the current page as a trail of links
/// separated by a divider, so users can jump back to a parent level.
///
/// ## Basic Usage
///
/// ```dart
/// VBreadcrumb(
///   items: [
///     VBreadcrumbItem(label: Text('Home'), onTap: () => goHome()),
///     VBreadcrumbItem(label: Text('Products'), onTap: () => goProducts()),
///     VBreadcrumbItem(label: Text('Electronics')), // Current page (no onTap)
///   ],
/// )
/// ```
///
/// ## Breadcrumb with icons
///
/// ```dart
/// VBreadcrumb(
///   items: [
///     VBreadcrumbItem(
///       label: Text('Home'),
///       icon: Icon(Icons.home),
///       onTap: () => goHome(),
///     ),
///     VBreadcrumbItem(label: Text('Settings'), onTap: () => goSettings()),
///     VBreadcrumbItem(label: Text('Profile')),
///   ],
/// )
/// ```
///
/// ## Breadcrumb with custom separator
///
/// ```dart
/// VBreadcrumb(
///   separator: Icon(Icons.chevron_right, size: 16),
///   items: [
///     VBreadcrumbItem(label: Text('Dashboard'), onTap: () {}),
///     VBreadcrumbItem(label: Text('Analytics'), onTap: () {}),
///     VBreadcrumbItem(label: Text('Reports')),
///   ],
/// )
/// ```
///
/// ## Collapsed breadcrumb with maxItems
///
/// When there are many items, use [maxItems] to collapse middle items:
///
/// ```dart
/// VBreadcrumb(
///   maxItems: 4,
///   items: [
///     VBreadcrumbItem(label: Text('Home'), onTap: () {}),
///     VBreadcrumbItem(label: Text('Category'), onTap: () {}),
///     VBreadcrumbItem(label: Text('Subcategory'), onTap: () {}),
///     VBreadcrumbItem(label: Text('Product'), onTap: () {}),
///     VBreadcrumbItem(label: Text('Details')),
///   ],
/// )
/// // Displays: Home / ... / Product / Details
/// ```
///
/// See also:
///
/// - [VBreadcrumbItem], for individual breadcrumb items
/// - [VAppBar], for top navigation bar
/// - [VTabs], for content switching
class VBreadcrumb extends StatelessWidget {
  /// Creates a trail from [items], with the last one as the current page.
  const VBreadcrumb({
    required this.items,
    super.key,
    this.separator,
    this.maxItems,
    this.style,
  }) : assert(
         maxItems == null || maxItems >= 2,
         'VBreadcrumb: maxItems must be at least 2',
       );

  /// Levels of the trail, from the root to the current page.
  final List<VBreadcrumbItem> items;

  /// Widget between levels, defaulting to a slash.
  final Widget? separator;

  /// Most levels to show before the middle ones collapse into an ellipsis.
  final int? maxItems;

  /// Overrides for separator, link and current colors and the text style.
  final VBreadcrumbStyle? style;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = VTheme.of(context);
    // Apply style overrides
    final themeStyle = theme.componentOverrides.get<VBreadcrumbStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;
    final colors = theme.colors;
    final typography = theme.typography;

    final effectiveMaxItems = maxItems != null && maxItems! >= 2
        ? maxItems!
        : null;
    final separatorTextColor =
        resolvedStyle?.separatorColor ?? colors.mutedForeground;
    final defaultSeparator = Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.xs),
      child: Text(
        '/',
        style: typography.bodyMedium.copyWith(color: separatorTextColor),
      ),
    );

    var displayItems = items;
    var showEllipsis = false;

    if (effectiveMaxItems != null && items.length > effectiveMaxItems) {
      showEllipsis = true;
      displayItems = [
        items.first,
        ...items.skip(items.length - effectiveMaxItems + 1),
      ];
    }

    final widgets = <Widget>[];

    for (var i = 0; i < displayItems.length; i++) {
      final item = displayItems[i];
      final isLast = i == displayItems.length - 1;
      final isFirst = i == 0;

      if (showEllipsis && isFirst) {
        widgets
          ..add(_buildItem(context, item, false, colors, typography))
          ..add(separator ?? defaultSeparator)
          ..add(
            Padding(
              padding: EdgeInsets.symmetric(horizontal: theme.spacing.xs),
              child: Text(
                '...',
                style: typography.bodyMedium.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
            ),
          )
          ..add(separator ?? defaultSeparator);
        continue;
      }

      final isCurrent = isLast || item.active;
      widgets.add(_buildItem(context, item, isCurrent, colors, typography));

      if (!isLast) {
        widgets.add(separator ?? defaultSeparator);
      }
    }

    return FocusTraversalGroup(
      child: Semantics(
        label: VoloLocalizations.of(context).breadcrumbLabel,
        child: Row(mainAxisSize: MainAxisSize.min, children: widgets),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    VBreadcrumbItem item,
    bool isCurrent,
    VColors colors,
    VTypography typography,
  ) {
    final theme = VTheme.of(context);
    // Resolve style overrides for item colors
    final themeStyle = theme.componentOverrides.get<VBreadcrumbStyle>();
    final itemResolvedStyle = themeStyle?.merge(style) ?? style;

    final activeColor = itemResolvedStyle?.activeColor ?? colors.foreground;
    final inactiveColor =
        itemResolvedStyle?.foregroundColor ?? colors.mutedForeground;
    final textColor = isCurrent ? activeColor : inactiveColor;
    var labelStyle = typography.bodyMedium.copyWith(
      color: textColor,
      fontWeight: isCurrent ? FontWeight.w500 : null,
    );
    if (itemResolvedStyle?.textStyle != null) {
      labelStyle = itemResolvedStyle!.textStyle!.copyWith(
        color: textColor,
        fontWeight: isCurrent ? FontWeight.w500 : null,
      );
    }

    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.icon != null)
          Padding(
            padding: EdgeInsetsDirectional.only(end: theme.spacing.xs),
            child: IconTheme(
              data: IconThemeData(color: textColor, size: 16),
              child: item.icon!,
            ),
          ),
        DefaultTextStyle.merge(style: labelStyle, child: item.label),
      ],
    );

    if (isCurrent || item.onTap == null) {
      return Semantics(child: content);
    }

    // WCAG 2.5.8: Minimum touch target 24x24
    return Focus(
      onKeyEvent: (node, event) {
        // Enter and Space follow the focused link.
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.numpadEnter ||
                event.logicalKey == LogicalKeyboardKey.space)) {
          item.onTap?.call();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Builder(
        builder: (focusContext) {
          final isFocused = Focus.of(focusContext).hasFocus;
          return Semantics(
            link: true,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              child: GestureDetector(
                onTap: item.onTap,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.spacing.xxs,
                      vertical: theme.spacing.xxs,
                    ),
                    decoration: isFocused
                        ? BoxDecoration(
                            borderRadius: theme.radius.smRadius,
                            border: Border.all(color: colors.ring, width: 2),
                          )
                        : null,
                    child: content,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
