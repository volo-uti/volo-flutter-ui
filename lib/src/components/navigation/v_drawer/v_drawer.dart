import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_drawer_style.dart';

// WHY: VDrawer.persistent variant with elevation=0 — on desktop layouts,
// the drawer is always visible (no slide animation) and sits flush with
// content, acting as a sidebar. Elevation 0 removes the shadow that
// would visually separate it from the main content area.
/// Side panel with a header, content and footer for app navigation.
///
/// {@category Navigation}
///
/// ## Overview
///
/// [VDrawer] is the panel itself, not the sliding: place it in a scaffold's
/// drawer slot or beside the content. [onClose] runs when Escape is pressed.
///
/// ## Basic Usage
///
/// ```dart
/// VDrawer(
///   header: UserHeader(name: 'John Doe'),
///   child: Column(
///     children: [
///       VListTile(title: Text('Home'), onTap: () => navigate('/home')),
///       VListTile(title: Text('Settings'), onTap: () => navigate('/settings')),
///     ],
///   ),
/// )
/// ```
///
/// ## Variants
///
/// - [VDrawer.new] - Default drawer sliding from left
/// - [VDrawer.end] - Drawer sliding from right side
/// - [VDrawer.persistent] - Fixed drawer for desktop layouts (no elevation)
///
/// ## Drawer with header and footer
///
/// ```dart
/// VDrawer(
///   header: Container(
///     padding: EdgeInsets.all(16),
///     child: Row(
///       children: [
///         CircleAvatar(child: Icon(Icons.person)),
///         SizedBox(width: 12),
///         Text('Welcome, User'),
///       ],
///     ),
///   ),
///   footer: VButton(
///     child: Text('Logout'),
///     onPressed: () => logout(),
///   ),
///   child: ListView(
///     children: [
///       VListTile(title: Text('Dashboard'), onTap: () {}),
///       VListTile(title: Text('Projects'), onTap: () {}),
///       VListTile(title: Text('Settings'), onTap: () {}),
///     ],
///   ),
/// )
/// ```
///
/// ## Right-side drawer
///
/// ```dart
/// VDrawer.end(
///   child: NotificationsList(),
/// )
/// ```
///
/// ## Persistent drawer for desktop
///
/// ```dart
/// Row(
///   children: [
///     VDrawer.persistent(
///       width: 256,
///       child: NavigationMenu(),
///     ),
///     Expanded(child: MainContent()),
///   ],
/// )
/// ```
///
/// See also:
///
/// - [VAppBar], for top navigation bar
/// - [VBottomNav], for bottom navigation
/// - [VMenu], for popup menu options
class VDrawer extends StatefulWidget {
  /// Creates a panel for the start side.
  const VDrawer({
    required this.child,
    super.key,
    this.header,
    this.footer,
    this.width,
    this.backgroundColor,
    this.elevation = 16,
    this.semanticLabel,
    this.onClose,
    this.style,
  }) : _variant = _VDrawerVariant.start;

  /// Creates a panel for the end side, with rounded start corners.
  const VDrawer.end({
    required this.child,
    super.key,
    this.header,
    this.footer,
    this.width,
    this.backgroundColor,
    this.elevation = 16,
    this.semanticLabel,
    this.onClose,
    this.style,
  }) : _variant = _VDrawerVariant.end;

  /// Creates a flush, shadowless panel that stays beside the content.
  const VDrawer.persistent({
    required this.child,
    super.key,
    this.header,
    this.footer,
    this.width,
    this.backgroundColor,
    this.semanticLabel,
    this.onClose,
    this.style,
  }) : _variant = _VDrawerVariant.persistent,
       elevation = 0;

  final _VDrawerVariant _variant;

  /// Main content, filling the space between header and footer.
  final Widget child;

  /// Widget above [child], such as a user summary.
  final Widget? header;

  /// Widget below [child], such as a logout button.
  final Widget? footer;

  /// Width in logical pixels, defaulting to 320 and capped at 80% of the screen.
  final double? width;

  /// Fill color, defaulting to the theme background.
  final Color? backgroundColor;

  /// Whether the panel casts a shadow, when above 0.
  final double elevation;

  /// Screen reader label, defaulting to "Navigation drawer".
  final String? semanticLabel;

  /// Called when Escape is pressed while the panel has focus.
  final VoidCallback? onClose;

  /// Overrides for background, text color, elevation and corner radius.
  final VDrawerStyle? style;

  @override
  State<VDrawer> createState() => _VDrawerState();
}

class _VDrawerState extends State<VDrawer> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Request focus when the drawer is mounted to receive Escape. A persistent
    // drawer sits beside the content and must not take focus from it, and
    // without onClose there is no key to receive.
    if (widget.onClose != null &&
        widget._variant != _VDrawerVariant.persistent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      widget.onClose?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides
    final themeStyle = theme.componentOverrides.get<VDrawerStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;
    final colors = theme.colors;

    var bgColor = widget.backgroundColor ?? colors.background;
    var effectiveElevation = widget.elevation;
    BorderRadiusGeometry? effectiveBorderRadius =
        widget._variant == _VDrawerVariant.end
        ? BorderRadiusDirectional.only(
            topStart: Radius.circular(theme.radius.md),
            bottomStart: Radius.circular(theme.radius.md),
          )
        : null;

    if (resolvedStyle != null) {
      bgColor = resolvedStyle.backgroundColor ?? bgColor;
      effectiveElevation = resolvedStyle.elevation ?? effectiveElevation;
      if (resolvedStyle.borderRadius != null) {
        effectiveBorderRadius = resolvedStyle.borderRadius;
      }
    }

    Widget content = Column(
      children: [
        if (widget.header != null) widget.header!,
        Expanded(child: widget.child),
        if (widget.footer != null) widget.footer!,
      ],
    );
    final foregroundColor = resolvedStyle?.foregroundColor;
    if (foregroundColor != null) {
      content = IconTheme.merge(
        data: IconThemeData(color: foregroundColor),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: foregroundColor),
          child: content,
        ),
      );
    }

    final drawerWidth = widget.width ?? 320;
    final maxWidth = MediaQuery.of(context).size.width * 0.8;
    final effectiveWidth = drawerWidth.clamp(0.0, maxWidth);

    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        label:
            widget.semanticLabel ?? VoloLocalizations.of(context).drawerLabel,
        child: KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: Container(
            width: effectiveWidth,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: effectiveBorderRadius,
              boxShadow: effectiveElevation > 0 ? theme.shadows.md : null,
            ),
            child: SafeArea(child: content),
          ),
        ),
      ),
    );
  }
}

enum _VDrawerVariant { start, end, persistent }
