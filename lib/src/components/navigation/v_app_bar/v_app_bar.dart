import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_icon_button/v_icon_button.dart';
import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_app_bar_style.dart';

/// Top bar with a title, leading widget and actions, with a back button.
///
/// {@category Navigation}
///
/// ## Overview
///
/// [VAppBar] sits at the top of a screen. When it is inside a [Navigator] that
/// can pop, it shows a back button on its own.
///
/// ## Basic Usage
///
/// ```dart
/// VAppBar(
///   title: Text('My App'),
///   actions: [
///     VIconButton(
///       icon: Icon(Icons.search),
///       onPressed: () => print('Search'),
///     ),
///   ],
/// )
/// ```
///
/// ## Variants
///
/// - [VAppBar.new] - Default app bar with optional elevation
/// - [VAppBar.transparent] - Transparent background with no elevation
/// - [VAppBar.elevated] - App bar with shadow (elevation: 4)
/// - [VAppBar.centered] - Title centered horizontally
///
/// ## App bar with leading widget
///
/// ```dart
/// VAppBar(
///   leading: VIconButton(
///     icon: Icon(Icons.menu),
///     onPressed: () => Scaffold.of(context).openDrawer(),
///   ),
///   title: Text('Dashboard'),
/// )
/// ```
///
/// ## Transparent app bar for overlay content
///
/// ```dart
/// VAppBar.transparent(
///   title: Text('Profile'),
///   foregroundColor: Colors.white,
///   actions: [
///     VIconButton(icon: Icon(Icons.settings), onPressed: () {}),
///   ],
/// )
/// ```
///
/// See also:
///
/// - [VBottomNav], for bottom navigation
/// - [VDrawer], for side navigation panel
class VAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an app bar with an optional shadow.
  const VAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle,
    this.style,
  }) : _variant = _VAppBarVariant.defaultBar;

  /// Transparent app bar.
  const VAppBar.transparent({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.automaticallyImplyLeading = true,
    this.foregroundColor,
    this.centerTitle,
    this.style,
  }) : _variant = _VAppBarVariant.transparent,
       backgroundColor = VColors.transparent,
       elevation = 0;

  /// Elevated app bar with shadow.
  const VAppBar.elevated({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle,
    this.style,
  }) : _variant = _VAppBarVariant.elevated,
       elevation = 4;

  /// Centered title app bar.
  const VAppBar.centered({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.style,
  }) : _variant = _VAppBarVariant.centered,
       centerTitle = true;

  final _VAppBarVariant _variant;

  /// Title shown after the leading widget, usually a [Text].
  ///
  /// A plain [Text] picks up the theme's title style and the foreground color.
  final Widget? title;

  /// Widget before the title, replacing the automatic back button.
  final Widget? leading;

  /// Widgets shown after the title, usually icon buttons.
  final List<Widget>? actions;

  /// Widget under the bar, such as a tab bar, that adds to [preferredSize].
  final PreferredSizeWidget? bottom;

  /// Whether to show a back button when [leading] is null and the route can pop.
  final bool automaticallyImplyLeading;

  /// Fill color, defaulting to the theme background.
  final Color? backgroundColor;

  /// Color of the title text, defaulting to the theme foreground.
  final Color? foregroundColor;

  /// Whether the bar casts a shadow, when above 0.
  final double? elevation;

  /// Whether to center the title, defaulting to false except for [VAppBar.centered].
  final bool? centerTitle;

  /// Overrides for colors, padding and title style.
  final VAppBarStyle? style;

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(56 + bottomHeight);
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;
    if (!automaticallyImplyLeading) return null;

    final navigator = Navigator.maybeOf(context);
    if (navigator != null && navigator.canPop()) {
      return VIconButton(
        icon: VIcons.arrowBack(color: VTheme.of(context).colors.foreground),
        // WHY: maybePop, not pop, so a PopScope on the page can veto it just
        // like the system back gesture.
        onPressed: navigator.maybePop,
        tooltip: VoloLocalizations.of(context).backTooltip,
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides
    final themeStyle = theme.componentOverrides.get<VAppBarStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;
    final colors = theme.colors;
    final typography = theme.typography;

    var bgColor = backgroundColor ?? colors.background;
    var fgColor = foregroundColor ?? colors.foreground;
    final isCentered = centerTitle ?? (_variant == _VAppBarVariant.centered);
    var effectiveElevation = elevation ?? 0;
    var effectivePadding = EdgeInsets.symmetric(horizontal: theme.spacing.xs);
    var effectiveTitleStyle = typography.titleLarge.copyWith(color: fgColor);

    if (resolvedStyle != null) {
      bgColor = resolvedStyle.backgroundColor ?? bgColor;
      fgColor = resolvedStyle.foregroundColor ?? fgColor;
      effectiveElevation = resolvedStyle.elevation ?? effectiveElevation;
      effectivePadding = resolvedStyle.padding ?? effectivePadding;
      effectiveTitleStyle = resolvedStyle.titleStyle ?? effectiveTitleStyle;
      // Re-apply foreground color to title style if overridden
      if (resolvedStyle.foregroundColor != null) {
        effectiveTitleStyle = effectiveTitleStyle.copyWith(color: fgColor);
      }
    }
    final borderColor = resolvedStyle?.borderColor;
    final leadingWidget = _buildLeading(context);

    final titleWidget = title == null
        ? const SizedBox.shrink()
        : DefaultTextStyle.merge(style: effectiveTitleStyle, child: title!);

    return FocusTraversalGroup(
      child: Semantics(
        header: true,
        child: Container(
          decoration: BoxDecoration(
            color: _variant == _VAppBarVariant.transparent
                ? VColors.transparent
                : bgColor,
            boxShadow: effectiveElevation > 0 ? theme.shadows.sm : null,
            border: borderColor == null
                ? null
                : Border(
                    bottom: BorderSide(
                      color: borderColor,
                      width: theme.borders.subtle.width,
                    ),
                  ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: theme.sizes.xl.height,
                  child: Padding(
                    padding: effectivePadding,
                    child: Row(
                      children: [
                        // Leading
                        if (leadingWidget != null)
                          SizedBox(
                            width: theme.sizes.lg.height,
                            child: Center(child: leadingWidget),
                          )
                        else
                          SizedBox(width: theme.spacing.lg),
                        // Title
                        Expanded(
                          child: isCentered
                              ? Center(child: titleWidget)
                              : titleWidget,
                        ),
                        // Actions
                        if (actions != null && actions!.isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: actions!,
                          )
                        else
                          SizedBox(width: theme.spacing.lg),
                      ],
                    ),
                  ),
                ),
                ?bottom,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _VAppBarVariant { defaultBar, transparent, elevated, centered }
