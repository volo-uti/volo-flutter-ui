import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_sheet_style.dart';

/// Side sheet direction.
///
/// Specifies the display direction of [VSideSheet]:
/// - [left] - Slides from the left (default)
/// - [right] - Slides from the right
enum VSheetSide {
  /// Slides from the left (default).
  left,

  /// Slides from the right.
  right,
}

/// {@template v_bottom_sheet}
/// Sheet that slides up from the bottom and can be dragged to resize or dismiss.
///
/// ```dart
/// VBottomSheet.show(
///   context,
///   title: Text('Title'),
///   snapPoints: [0.3, 0.6, 0.9],
///   child: ListView(
///     children: [
///       VListTile(title: Text('Item 1')),
///       VListTile(title: Text('Item 2')),
///       VListTile(title: Text('Item 3')),
///     ],
///   ),
/// );
/// ```
///
/// **Close with Result:**
///
/// ```dart
/// final result = await VBottomSheet.show<String>(
///   context,
///   child: Column(
///     children: [
///       VButton(
///         onPressed: () => VBottomSheet.close(context, 'option1'),
///         child: Text('Option 1'),
///       ),
///       VButton(
///         onPressed: () => VBottomSheet.close(context, 'option2'),
///         child: Text('Option 2'),
///       ),
///     ],
///   ),
/// );
/// print('Selected option: $result');
/// ```
///
/// See also:
///
/// - [VSideSheet], an overlay sheet that slides from the side
/// - [VSheet], a convenience class providing sheet-related static methods
/// {@endtemplate}
class VBottomSheet extends VSheet {
  /// {@macro v_bottom_sheet}
  const VBottomSheet({
    required this.child,
    super.key,
    this.title,
    this.showHandle = true,
    this.initialSize = 0.5,
    this.minSize = 0.25,
    this.maxSize = 0.9,
    this.snapPoints,
    this.barrierDismissible = true,
    this.style,
  });

  /// Content shown inside the sheet.
  final Widget child;

  /// Heading shown below the handle, usually a [Text].
  final Widget? title;

  /// Whether to draw the drag handle at the top of the sheet.
  final bool showHandle;

  /// Starting height as a fraction of the screen height (0.0 - 1.0).
  final double initialSize;

  /// Smallest height fraction; releasing a drag below it closes the sheet.
  final double minSize;

  /// Largest height fraction reachable by dragging.
  final double maxSize;

  /// Height fractions the sheet snaps to, nearest first, when a drag ends.
  final List<double>? snapPoints;

  /// Whether tapping outside the sheet closes it.
  ///
  /// The barrier of the route that [show] or a [VSheet] show helper opens
  /// reads it and handles the tap; a sheet placed in a route of your own
  /// does not close on a tap outside.
  final bool barrierDismissible;

  /// Style override.
  final VSheetStyle? style;

  /// Shows a bottom sheet and completes with the value passed to [close].
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    Widget? title,
    bool showHandle = true,
    double initialSize = 0.5,
    double minSize = 0.25,
    double maxSize = 0.9,
    List<double>? snapPoints,
    bool barrierDismissible = true,
    VSheetStyle? style,
  }) {
    final themeData = VTheme.maybeOf(context);
    final localizations =
        VoloLocalizations.maybeOf(context) ?? const VoloLocalizationsEn();
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: localizations.sheetDismissLabel,
      barrierColor: themeData?.colors.scrim ?? VColors.dark.scrim,
      transitionDuration:
          themeData?.animations.normal ?? VAnimations.defaults.normal,
      pageBuilder: (context, animation, secondaryAnimation) {
        final sheet = VBottomSheet(
          title: title,
          showHandle: showHandle,
          initialSize: initialSize,
          minSize: minSize,
          maxSize: maxSize,
          snapPoints: snapPoints,
          barrierDismissible: barrierDismissible,
          style: style,
          child: child,
        );
        if (themeData != null) {
          return VTheme(
            data: themeData,
            localizations: localizations,
            child: sheet,
          );
        }
        return sheet;
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
          child,
    );
  }

  /// Closes the sheet.
  ///
  /// Closes the current sheet and optionally returns a result value.
  static void close<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }

  @override
  State<VBottomSheet> createState() => _VBottomSheetState();
}

class _VBottomSheetState extends State<VBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late double _currentSize;

  @override
  void initState() {
    super.initState();
    _currentSize = widget.initialSize.clamp(widget.minSize, widget.maxSize);
    _controller = AnimationController(vsync: this);
    _slideAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _controller.duration = theme.animations.normal;
    if (_controller.value == 0) {
      unawaited(_controller.forward());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    final delta = -details.primaryDelta! / screenHeight;
    setState(() {
      _currentSize = (_currentSize + delta).clamp(0.0, widget.maxSize);
    });
  }

  // WHY: Snap-to-nearest on drag end — without snapping, the sheet stops
  // at arbitrary heights which looks unfinished. Snapping to predefined
  // points (e.g. 30%, 60%, 90%) gives a polished, predictable feel.
  // Dragging below minSize auto-dismisses (common mobile pattern).
  void _handleDragEnd(DragEndDetails details) {
    if (_currentSize < widget.minSize) {
      _close();
      return;
    }

    if (widget.snapPoints != null && widget.snapPoints!.isNotEmpty) {
      final nearest = widget.snapPoints!.reduce(
        (a, b) => (a - _currentSize).abs() < (b - _currentSize).abs() ? a : b,
      );
      setState(() {
        _currentSize = nearest.clamp(widget.minSize, widget.maxSize);
      });
    }
  }

  void _close() {
    unawaited(
      _controller.reverse().then((_) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides
    final themeStyle = theme.componentOverrides.get<VSheetStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;
    final colors = theme.colors;
    final screenHeight = MediaQuery.of(context).size.height;

    final bgColor = resolvedStyle?.backgroundColor ?? colors.card;
    final fgColor = resolvedStyle?.foregroundColor ?? colors.foreground;
    final sheetBorderRadius =
        resolvedStyle?.borderRadius ??
        BorderRadius.vertical(top: Radius.circular(theme.radius.lg));

    final defaultTextStyle = theme.typography.bodyMedium.copyWith(
      color: fgColor,
      decoration: TextDecoration.none,
    );

    final titleWidget = widget.title == null
        ? null
        : DefaultTextStyle(
            style: theme.typography.titleMedium.copyWith(
              color: fgColor,
              decoration: TextDecoration.none,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.lg,
                vertical: theme.spacing.sm,
              ),
              child: widget.title!,
            ),
          );

    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: DefaultTextStyle(
        style: defaultTextStyle,
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              final slideOffset =
                  _slideAnimation.value * screenHeight * _currentSize;
              // WHY: No tap layer of its own — the barrier of the route that
              // show() opens takes taps outside the sheet and carries the
              // dismiss label for screen readers.
              return Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -slideOffset,
                    height: screenHeight * _currentSize,
                    child: GestureDetector(
                      onVerticalDragUpdate: _handleDragUpdate,
                      onVerticalDragEnd: _handleDragEnd,
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: sheetBorderRadius,
                        ),
                        child: Column(
                          children: [
                            if (widget.showHandle)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: theme.spacing.sm,
                                ),
                                child: Container(
                                  width: theme.spacing.fourXL,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: colors.muted,
                                    borderRadius: theme.radius.xsRadius,
                                  ),
                                ),
                              ),
                            ?titleWidget,
                            Expanded(child: widget.child),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// {@template v_side_sheet}
/// Panel that slides in from the left or right edge, for filters and detail views.
///
/// ```dart
/// VSideSheet.show(
///   context,
///   side: VSheetSide.right,
///   width: 320,
///   child: ListView(
///     children: [
///       VListTile(
///         leading: Icon(Icons.home),
///         title: Text('Home'),
///         onTap: () => VSideSheet.close(context),
///       ),
///       VListTile(
///         leading: Icon(Icons.settings),
///         title: Text('Settings'),
///         onTap: () => VSideSheet.close(context),
///       ),
///     ],
///   ),
/// );
/// ```
///
/// See also:
///
/// - [VBottomSheet], an overlay sheet that slides up from the bottom
/// - [VSheet], a convenience class providing sheet-related static methods
/// {@endtemplate}
class VSideSheet extends VSheet {
  /// {@macro v_side_sheet}
  const VSideSheet({
    required this.child,
    super.key,
    this.side = VSheetSide.left,
    this.width = 280,
    this.barrierDismissible = true,
    this.style,
  });

  /// Content shown inside the sheet.
  final Widget child;

  /// Edge the sheet slides in from. Defaults to [VSheetSide.left].
  final VSheetSide side;

  /// Sheet width in logical pixels. Defaults to 280.
  final double width;

  /// Whether tapping outside the sheet closes it.
  ///
  /// The barrier of the route that [show] or a [VSheet] show helper opens
  /// reads it and handles the tap; a sheet placed in a route of your own
  /// does not close on a tap outside.
  final bool barrierDismissible;

  /// Style override.
  final VSheetStyle? style;

  /// Shows a side sheet and completes with the value passed to [close].
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    VSheetSide side = VSheetSide.left,
    double width = 280,
    bool barrierDismissible = true,
    VSheetStyle? style,
  }) {
    final themeData = VTheme.maybeOf(context);
    final localizations =
        VoloLocalizations.maybeOf(context) ?? const VoloLocalizationsEn();
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: localizations.sheetDismissLabel,
      barrierColor: themeData?.colors.scrim ?? VColors.dark.scrim,
      transitionDuration:
          themeData?.animations.normal ?? VAnimations.defaults.normal,
      pageBuilder: (context, animation, secondaryAnimation) {
        final sheet = VSideSheet(
          side: side,
          width: width,
          barrierDismissible: barrierDismissible,
          style: style,
          child: child,
        );
        if (themeData != null) {
          return VTheme(
            data: themeData,
            localizations: localizations,
            child: sheet,
          );
        }
        return sheet;
      },
    );
  }

  /// Closes the sheet.
  ///
  /// Closes the current sheet and optionally returns a result value.
  static void close<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }

  @override
  State<VSideSheet> createState() => _VSideSheetState();
}

class _VSideSheetState extends State<VSideSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;

  bool get _isLeft => widget.side == VSheetSide.left;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _slideAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _controller.duration = theme.animations.normal;
    if (_controller.value == 0) {
      unawaited(_controller.forward());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides
    final themeStyle = theme.componentOverrides.get<VSheetStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;
    final colors = theme.colors;

    final bgColor = resolvedStyle?.backgroundColor ?? colors.card;
    final fgColor = resolvedStyle?.foregroundColor ?? colors.foreground;

    final defaultTextStyle = theme.typography.bodyMedium.copyWith(
      color: fgColor,
      decoration: TextDecoration.none,
    );

    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: DefaultTextStyle(
        style: defaultTextStyle,
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              final slideOffset =
                  _slideAnimation.value * widget.width * (_isLeft ? -1 : 1);
              // The route's barrier takes taps outside, as for VBottomSheet.
              return Stack(
                children: [
                  Positioned(
                    left: _isLeft ? slideOffset : null,
                    right: _isLeft ? null : slideOffset,
                    top: 0,
                    bottom: 0,
                    width: widget.width,
                    child: Container(color: bgColor, child: widget.child),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// WHY: Abstract base class — VBottomSheet and VSideSheet share the VSheet
// namespace (VSheet.bottom(), VSheet.side()) for a unified API surface,
// but have completely different layout logic (vertical drag vs horizontal slide).
/// {@template v_sheet}
/// Overlay that slides in from a screen edge: [VSheet.bottom] or [VSheet.side].
///
/// ```dart
/// final choice = await VSheet.showBottom<String>(
///   context,
///   VSheet.bottom(
///     title: Text('Select an Option'),
///     child: OptionsWidget(),
///   ),
/// );
/// ```
///
/// ## Variants
///
/// ### VSheet.bottom
///
/// A sheet that slides up from the bottom. Supports drag-to-resize.
///
/// ```dart
/// VSheet.bottom(
///   title: Text('Title'),
///   showHandle: true,
///   initialSize: 0.5,
///   snapPoints: [0.3, 0.6, 0.9],
///   child: ContentWidget(),
/// )
/// ```
///
/// ### VSheet.side
///
/// A sheet that slides from the side. Used for navigation drawers and similar patterns.
///
/// ```dart
/// VSheet.side(
///   side: VSheetSide.right,
///   width: 320,
///   child: FilterPanel(),
/// )
/// ```
///
/// ## Close with Result
///
/// ```dart
/// final result = await VSheet.showBottom<String>(
///   context,
///   VSheet.bottom(
///     child: Column(
///       children: [
///         VButton(
///           onPressed: () => VSheet.close(context, 'option1'),
///           child: Text('Option 1'),
///         ),
///       ],
///     ),
///   ),
/// );
/// ```
///
/// See also:
///
/// - [VBottomSheet], the bottom sheet widget class
/// - [VSideSheet], the side sheet widget class
/// {@endtemplate}
abstract class VSheet extends StatefulWidget {
  /// Default constructor.
  const VSheet({super.key});

  /// Creates a bottom sheet.
  ///
  /// Creates a sheet that slides up from the bottom.
  ///
  /// ```dart
  /// VSheet.bottom(
  ///   title: Text('Title'),
  ///   child: ContentWidget(),
  /// )
  /// ```
  factory VSheet.bottom({
    required Widget child,
    Key? key,
    Widget? title,
    bool showHandle = true,
    double initialSize = 0.5,
    double minSize = 0.25,
    double maxSize = 0.9,
    List<double>? snapPoints,
    bool barrierDismissible = true,
    VSheetStyle? style,
  }) => VBottomSheet(
    key: key,
    title: title,
    showHandle: showHandle,
    initialSize: initialSize,
    minSize: minSize,
    maxSize: maxSize,
    snapPoints: snapPoints,
    barrierDismissible: barrierDismissible,
    style: style,
    child: child,
  );

  /// Creates a side sheet.
  ///
  /// Creates a sheet that slides from the side.
  ///
  /// ```dart
  /// VSheet.side(
  ///   side: VSheetSide.right,
  ///   width: 320,
  ///   child: FilterPanel(),
  /// )
  /// ```
  factory VSheet.side({
    required Widget child,
    Key? key,
    VSheetSide side = VSheetSide.left,
    double width = 280,
    bool barrierDismissible = true,
    VSheetStyle? style,
  }) => VSideSheet(
    key: key,
    side: side,
    width: width,
    barrierDismissible: barrierDismissible,
    style: style,
    child: child,
  );

  /// Shows a bottom sheet.
  ///
  /// Displays a sheet that slides up from the bottom.
  ///
  /// ```dart
  /// VSheet.showBottom(context, VSheet.bottom(child: ...));
  /// ```
  static Future<T?> showBottom<T>(BuildContext context, VBottomSheet sheet) {
    final themeData = VTheme.maybeOf(context);
    final localizations =
        VoloLocalizations.maybeOf(context) ?? const VoloLocalizationsEn();
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: sheet.barrierDismissible,
      barrierLabel: localizations.sheetDismissLabel,
      barrierColor: themeData?.colors.scrim ?? VColors.dark.scrim,
      transitionDuration:
          themeData?.animations.normal ?? VAnimations.defaults.normal,
      pageBuilder: (context, animation, secondaryAnimation) {
        if (themeData != null) {
          return VTheme(
            data: themeData,
            localizations: localizations,
            child: sheet,
          );
        }
        return sheet;
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
          child,
    );
  }

  /// Shows a side sheet.
  ///
  /// Displays a sheet that slides from the side.
  ///
  /// ```dart
  /// VSheet.showSide(context, VSheet.side(child: ...));
  /// ```
  static Future<T?> showSide<T>(BuildContext context, VSideSheet sheet) {
    final themeData = VTheme.maybeOf(context);
    final localizations =
        VoloLocalizations.maybeOf(context) ?? const VoloLocalizationsEn();
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: sheet.barrierDismissible,
      barrierLabel: localizations.sheetDismissLabel,
      barrierColor: themeData?.colors.scrim ?? VColors.dark.scrim,
      transitionDuration:
          themeData?.animations.normal ?? VAnimations.defaults.normal,
      pageBuilder: (context, animation, secondaryAnimation) {
        if (themeData != null) {
          return VTheme(
            data: themeData,
            localizations: localizations,
            child: sheet,
          );
        }
        return sheet;
      },
    );
  }

  /// Closes the sheet.
  ///
  /// Closes the currently open sheet.
  /// Works for both bottom sheets and side sheets.
  static void close<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }
}
