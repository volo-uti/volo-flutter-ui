import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';

/// Where [VScaffold] places its floating action button.
enum VFabLocation {
  /// Bottom right (default).
  endFloat,

  /// Bottom center.
  centerFloat,

  /// Bottom left.
  startFloat,

  /// Bottom right (overlapping BottomNav).
  endDocked,

  /// Bottom center (overlapping BottomNav).
  centerDocked,
}

// WHY: Custom scaffold instead of Material Scaffold — Material's Scaffold
// hard-codes ink splash, snackbar positioning, FAB animation, and drawer
// behavior via MaterialLocalizations. Our layout uses Stack-based positioning
// for full control over component placement and animation.
/// {@template v_scaffold}
/// Screen frame with app bar, body, bottom nav, drawers, FAB.
///
/// Replaces `Scaffold` without Material. It pads the top and bottom safe
/// areas and the keyboard, and places [floatingActionButton] at
/// [floatingActionButtonLocation]. Open and close the drawers from any
/// descendant with [VScaffold.openDrawer] and [VScaffold.closeDrawer].
///
/// ## Basic Usage:
///
/// ```dart
/// VScaffold(
///   appBar: VAppBar(title: Text('Home')),
///   body: Center(child: Text('Hello World')),
///   bottomNavigationBar: VBottomNav(
///     selectedIndex: 0,
///     onTap: (index) {},
///     items: [
///       VBottomNavItem(key: 'home', icon: Icon(Icons.home), label: 'Home'),
///       VBottomNavItem(key: 'search', icon: Icon(Icons.search), label: 'Search'),
///     ],
///   ),
/// )
/// ```
///
/// ## With FAB:
///
/// ```dart
/// VScaffold(
///   body: ListView.builder(...),
///   floatingActionButton: VFab(
///     onPressed: () {},
///     icon: Icon(Icons.add),
///   ),
///   floatingActionButtonLocation: VFabLocation.centerFloat,
/// )
/// ```
///
/// ## With Drawer:
///
/// ```dart
/// VScaffold(
///   appBar: VAppBar(
///     leading: Builder(
///       builder: (context) => VIconButton(
///         icon: Icon(Icons.menu),
///         onPressed: () => VScaffold.openDrawer(context),
///       ),
///     ),
///     title: Text('Menu'),
///   ),
///   drawer: VDrawer(child: ListView(...)),
///   body: Center(child: Text('Content')),
/// )
/// ```
///
/// See also:
///
/// - [VFabLocation], FAB position options
/// - [VAppBar], app bar widget
/// - [VBottomNav], bottom navigation widget
/// - [VDrawer], drawer widget
/// {@endtemplate}
class VScaffold extends StatefulWidget {
  /// {@macro v_scaffold}
  const VScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation = VFabLocation.endFloat,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
  });

  /// Main content, placed between the app bar and the bottom navigation.
  final Widget body;

  /// Bar shown at the top of the screen.
  final PreferredSizeWidget? appBar;

  /// Navigation shown at the bottom, above the safe area.
  final Widget? bottomNavigationBar;

  /// Panel that slides in from the left edge, opened by [openDrawer].
  final Widget? drawer;

  /// Panel that slides in from the right edge, opened by [openEndDrawer].
  final Widget? endDrawer;

  /// Floating button placed at [floatingActionButtonLocation].
  final Widget? floatingActionButton;

  /// Where [floatingActionButton] sits; docked values overlap the bottom nav.
  final VFabLocation floatingActionButtonLocation;

  /// Screen background; defaults to the theme background.
  final Color? backgroundColor;

  /// Whether the bottom of the screen moves up with the on-screen keyboard.
  final bool resizeToAvoidBottomInset;

  /// Whether the body extends behind [bottomNavigationBar].
  final bool extendBody;

  /// Whether the body extends behind [appBar], which then floats over it.
  final bool extendBodyBehindAppBar;

  // WHY: Static methods with findAncestorStateOfType instead of
  // ScaffoldMessenger — avoids Material dependency and follows the same
  // pattern as Flutter's Scaffold.of(context) but without GlobalKey.
  /// Opens [drawer] of the nearest scaffold above [context].
  static void openDrawer(BuildContext context) {
    final state = context.findAncestorStateOfType<_VScaffoldState>();
    state?._openDrawer();
  }

  /// Closes [drawer] of the nearest scaffold above [context].
  static void closeDrawer(BuildContext context) {
    final state = context.findAncestorStateOfType<_VScaffoldState>();
    state?._closeDrawer();
  }

  /// Opens [endDrawer] of the nearest scaffold above [context].
  static void openEndDrawer(BuildContext context) {
    final state = context.findAncestorStateOfType<_VScaffoldState>();
    state?._openEndDrawer();
  }

  /// Closes [endDrawer] of the nearest scaffold above [context].
  static void closeEndDrawer(BuildContext context) {
    final state = context.findAncestorStateOfType<_VScaffoldState>();
    state?._closeEndDrawer();
  }

  @override
  State<VScaffold> createState() => _VScaffoldState();
}

class _VScaffoldState extends State<VScaffold> with TickerProviderStateMixin {
  bool _isDrawerOpen = false;
  bool _isEndDrawerOpen = false;

  // WHY: Each drawer owns its controller. With one shared controller, closing
  // one drawer reversed the animation of the other and left it open but
  // invisible behind a full-screen backdrop.
  late final AnimationController _drawerController;
  late final AnimationController _endDrawerController;
  late final Animation<double> _drawerAnimation;
  late final Animation<double> _endDrawerAnimation;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(vsync: this);
    _endDrawerController = AnimationController(vsync: this);
    _drawerAnimation = CurvedAnimation(
      parent: _drawerController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _endDrawerAnimation = CurvedAnimation(
      parent: _endDrawerController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _drawerController.duration = theme.animations.normal;
    _endDrawerController.duration = theme.animations.normal;
  }

  @override
  void dispose() {
    _drawerController
      ..stop()
      ..dispose();
    _endDrawerController
      ..stop()
      ..dispose();
    super.dispose();
  }

  void _openDrawer() {
    if (widget.drawer == null) return;
    setState(() => _isDrawerOpen = true);
    unawaited(_drawerController.forward());
  }

  void _closeDrawer() {
    if (!_isDrawerOpen) return;
    unawaited(
      _drawerController.reverse().then((_) {
        if (mounted) {
          setState(() => _isDrawerOpen = false);
        }
      }),
    );
  }

  void _openEndDrawer() {
    if (widget.endDrawer == null) return;
    setState(() => _isEndDrawerOpen = true);
    unawaited(_endDrawerController.forward());
  }

  void _closeEndDrawer() {
    if (!_isEndDrawerOpen) return;
    unawaited(
      _endDrawerController.reverse().then((_) {
        if (mounted) {
          setState(() => _isEndDrawerOpen = false);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final colors = theme.colors;
    final mediaQuery = MediaQuery.of(context);

    final bgColor = widget.backgroundColor ?? colors.background;

    // Calculate bottom inset for keyboard
    final bottomInset = widget.resizeToAvoidBottomInset
        ? mediaQuery.viewInsets.bottom
        : 0.0;

    final hasNav = widget.bottomNavigationBar != null;
    final hasFab = widget.floatingActionButton != null;
    final isDocked =
        widget.floatingActionButtonLocation == VFabLocation.endDocked ||
        widget.floatingActionButtonLocation == VFabLocation.centerDocked;

    // WHY: The scaffold pads the system insets itself (spacers below), so the
    // bars and the body must not pad them a second time. Each child only
    // loses the inset the scaffold actually consumed for it.
    final consumesTop = !widget.extendBodyBehindAppBar;
    final consumesBottom = !widget.extendBody;

    Widget bottomNav() => MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: widget.bottomNavigationBar!,
    );

    return FocusTraversalGroup(
      child: Container(
        color: bgColor,
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Safe area top
                if (consumesTop) SizedBox(height: mediaQuery.padding.top),

                // App bar
                if (widget.appBar != null && consumesTop)
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: widget.appBar!,
                  ),

                // Body
                Expanded(
                  child: Stack(
                    children: [
                      // Body content. When the nav is a Column sibling the
                      // Expanded area already ends above it; when it overlays
                      // (extendBody) the body runs behind it.
                      Positioned.fill(
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: consumesTop,
                          removeBottom: consumesBottom,
                          child: widget.body,
                        ),
                      ),

                      // AppBar overlay (when extendBodyBehindAppBar)
                      if (widget.appBar != null &&
                          widget.extendBodyBehindAppBar)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              SizedBox(height: mediaQuery.padding.top),
                              MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: widget.appBar!,
                              ),
                            ],
                          ),
                        ),

                      // Floating FAB sits above the nav, which ends the body.
                      if (hasFab && !isDocked && !widget.extendBody)
                        _buildFloatingFab(theme),
                    ],
                  ),
                ),

                // Bottom navigation bar
                if (hasNav && !widget.extendBody) bottomNav(),

                // Bottom safe area
                SizedBox(height: mediaQuery.padding.bottom + bottomInset),
              ],
            ),

            // Extended bottom nav (when extendBody); a floating FAB stacks
            // above the nav's measured height.
            if (hasNav && widget.extendBody)
              Positioned(
                bottom: mediaQuery.padding.bottom + bottomInset,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasFab && !isDocked) _buildFloatingFabRow(theme),
                    bottomNav(),
                  ],
                ),
              ),

            // Floating FAB without a nav overlay on an extended body.
            if (hasFab && !isDocked && widget.extendBody && !hasNav)
              Positioned(
                bottom: mediaQuery.padding.bottom + bottomInset,
                left: 0,
                right: 0,
                child: _buildFloatingFabRow(theme),
              ),

            // Docked FAB overlaps the nav, measured from the screen bottom.
            if (hasFab && isDocked)
              _buildDockedFab(theme, mediaQuery, bottomInset),

            // Drawer backdrop
            if (_isDrawerOpen || _isEndDrawerOpen)
              AnimatedBuilder(
                animation: Listenable.merge([
                  _drawerAnimation,
                  _endDrawerAnimation,
                ]),
                builder: (context, child) => GestureDetector(
                  onTap: () {
                    if (_isDrawerOpen) _closeDrawer();
                    if (_isEndDrawerOpen) _closeEndDrawer();
                  },
                  child: Container(
                    color: Color.fromRGBO(
                      0,
                      0,
                      0,
                      0.5 *
                          math.max(
                            _isDrawerOpen ? _drawerAnimation.value : 0.0,
                            _isEndDrawerOpen ? _endDrawerAnimation.value : 0.0,
                          ),
                    ),
                  ),
                ),
              ),

            // Drawer
            if (_isDrawerOpen && widget.drawer != null)
              AnimatedBuilder(
                animation: _drawerAnimation,
                builder: (context, child) => Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  // WHY: Translate by a fraction of the drawer's own width so
                  // a drawer of any width starts fully off screen.
                  child: FractionalTranslation(
                    translation: Offset(_drawerAnimation.value - 1, 0),
                    child: widget.drawer!,
                  ),
                ),
              ),

            // End Drawer
            if (_isEndDrawerOpen && widget.endDrawer != null)
              AnimatedBuilder(
                animation: _endDrawerAnimation,
                builder: (context, child) => Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: FractionalTranslation(
                    translation: Offset(1 - _endDrawerAnimation.value, 0),
                    child: widget.endDrawer!,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Alignment get _fabAlignment {
    switch (widget.floatingActionButtonLocation) {
      case VFabLocation.endFloat:
      case VFabLocation.endDocked:
        return Alignment.centerRight;
      case VFabLocation.centerFloat:
      case VFabLocation.centerDocked:
        return Alignment.center;
      case VFabLocation.startFloat:
        return Alignment.centerLeft;
    }
  }

  /// Floating FAB laid out as a full-width row, `lg` above what follows it.
  Widget _buildFloatingFabRow(VThemeData theme) => Padding(
    padding: EdgeInsets.fromLTRB(
      theme.spacing.lg,
      0,
      theme.spacing.lg,
      theme.spacing.lg,
    ),
    child: Align(alignment: _fabAlignment, child: widget.floatingActionButton!),
  );

  /// Floating FAB positioned inside the body area, `lg` above its bottom.
  Widget _buildFloatingFab(VThemeData theme) => Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: _buildFloatingFabRow(theme),
  );

  Widget _buildDockedFab(
    VThemeData theme,
    MediaQueryData mediaQuery,
    double bottomInset,
  ) {
    final bottom = mediaQuery.padding.bottom + bottomInset + theme.spacing.sm;
    return Positioned(
      left: 0,
      right: 0,
      bottom: bottom,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.lg),
        child: Align(
          alignment: _fabAlignment,
          child: widget.floatingActionButton!,
        ),
      ),
    );
  }
}
