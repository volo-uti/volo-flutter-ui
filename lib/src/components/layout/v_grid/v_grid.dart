import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_grid_style.dart';

/// {@template v_grid}
/// Scrollable grid by column count, tile width or delegate.
///
/// A [GridView] with one [spacing] value for both axes, built through
/// [VGrid.count], [VGrid.extent] or [VGrid.custom].
///
/// ## Basic Usage:
///
/// 3-column fixed grid:
///
/// ```dart
/// VGrid.count(
///   crossAxisCount: 3,
///   spacing: 8,
///   children: [
///     Container(color: Colors.red),
///     Container(color: Colors.green),
///     Container(color: Colors.blue),
///   ],
/// )
/// ```
///
/// ## Variants:
///
/// - [VGrid.count] - Fixed column count grid
/// - [VGrid.extent] - Max column width grid
/// - [VGrid.custom] - Custom delegate grid
///
/// ## Extent Grid:
///
/// Responsive grid based on max width:
///
/// ```dart
/// VGrid.extent(
///   maxCrossAxisExtent: 150,
///   spacing: 16,
///   childAspectRatio: 1.5,
///   children: productCards,
/// )
/// ```
///
/// ## Custom Delegate:
///
/// Grid using a custom delegate:
///
/// ```dart
/// VGrid.custom(
///   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
///     crossAxisCount: 2,
///     mainAxisSpacing: 8,
///     crossAxisSpacing: 8,
///   ),
///   children: items,
/// )
/// ```
///
/// See also:
///
/// - [GridView], Flutter built-in grid widget
/// - [SliverGridDelegate], grid layout delegate
/// {@endtemplate}
class VGrid extends StatelessWidget {
  /// {@macro v_grid}
  ///
  /// Fixed column count grid.
  ///
  /// ```dart
  /// VGrid.count(
  ///   crossAxisCount: 4,
  ///   spacing: 8,
  ///   children: items,
  /// )
  /// ```
  const VGrid.count({
    required this.children,
    required int crossAxisCount,
    super.key,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.spacing,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.physics,
    this.primary,
    this.reverse = false,
    this.style,
  }) : _crossAxisCount = crossAxisCount,
       _maxCrossAxisExtent = null,
       _gridDelegate = null;

  /// Max column width grid.
  ///
  /// Column count adjusts automatically based on screen size.
  ///
  /// ```dart
  /// VGrid.extent(
  ///   maxCrossAxisExtent: 200,
  ///   spacing: 12,
  ///   children: items,
  /// )
  /// ```
  const VGrid.extent({
    required this.children,
    required double maxCrossAxisExtent,
    super.key,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.spacing,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.physics,
    this.primary,
    this.reverse = false,
    this.style,
  }) : _crossAxisCount = null,
       _maxCrossAxisExtent = maxCrossAxisExtent,
       _gridDelegate = null;

  /// Custom delegate grid.
  ///
  /// Directly specify a [SliverGridDelegate] for complex layouts.
  ///
  /// ```dart
  /// VGrid.custom(
  ///   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  ///     crossAxisCount: 3,
  ///     mainAxisSpacing: 10,
  ///     crossAxisSpacing: 10,
  ///   ),
  ///   children: items,
  /// )
  /// ```
  const VGrid.custom({
    required this.children,
    required SliverGridDelegate gridDelegate,
    super.key,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.spacing,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.physics,
    this.primary,
    this.reverse = false,
    this.style,
  }) : _crossAxisCount = null,
       _maxCrossAxisExtent = null,
       _gridDelegate = gridDelegate;

  /// Tiles laid out in the grid.
  final List<Widget> children;

  /// Gap between rows; falls back to [spacing] when null.
  final double? mainAxisSpacing;

  /// Gap between columns; falls back to [spacing] when null.
  final double? crossAxisSpacing;

  /// Gap between rows and columns, unless the axis value is set; defaults to 0.
  final double? spacing;

  /// Width divided by height of each tile; ignored by [mainAxisExtent].
  final double childAspectRatio;

  /// Fixed tile extent along the main axis, replacing [childAspectRatio].
  final double? mainAxisExtent;

  /// Space around the whole grid.
  final EdgeInsetsGeometry? padding;

  /// Axis the grid scrolls along.
  final Axis scrollDirection;

  /// Whether the grid is as tall as its tiles instead of filling its parent.
  final bool shrinkWrap;

  /// How the grid reacts to user scrolling.
  final ScrollPhysics? physics;

  /// Whether this grid uses the primary scroll controller.
  final bool? primary;

  /// Whether tiles start from the opposite end of the scroll axis.
  final bool reverse;

  /// Overrides the theme style, for example the spacing.
  final VGridStyle? style;

  final int? _crossAxisCount;
  final double? _maxCrossAxisExtent;
  final SliverGridDelegate? _gridDelegate;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides
    final themeStyle = theme.componentOverrides.get<VGridStyle>();
    // Precedence: instance style > constructor argument > theme override.
    final baseSpacing = style?.spacing ?? spacing ?? themeStyle?.spacing ?? 0;

    final effectiveMainAxisSpacing = mainAxisSpacing ?? baseSpacing;
    final effectiveCrossAxisSpacing = crossAxisSpacing ?? baseSpacing;

    // Effective ratio value (use 1.0 if <= 0)
    final effectiveAspectRatio = childAspectRatio > 0 ? childAspectRatio : 1.0;

    // Determine grid delegate
    final SliverGridDelegate delegate;

    if (_gridDelegate != null) {
      delegate = _gridDelegate;
    } else if (_crossAxisCount != null) {
      // Count mode
      final effectiveCount = _crossAxisCount > 0 ? _crossAxisCount : 1;
      delegate = SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: effectiveCount,
        mainAxisSpacing: effectiveMainAxisSpacing,
        crossAxisSpacing: effectiveCrossAxisSpacing,
        childAspectRatio: effectiveAspectRatio,
        mainAxisExtent: mainAxisExtent,
      );
    } else if (_maxCrossAxisExtent != null) {
      // Extent mode
      final effectiveExtent = _maxCrossAxisExtent > 0
          ? _maxCrossAxisExtent
          : 100.0;
      delegate = SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: effectiveExtent,
        mainAxisSpacing: effectiveMainAxisSpacing,
        crossAxisSpacing: effectiveCrossAxisSpacing,
        childAspectRatio: effectiveAspectRatio,
        mainAxisExtent: mainAxisExtent,
      );
    } else {
      // Default: 2 columns
      delegate = SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: effectiveMainAxisSpacing,
        crossAxisSpacing: effectiveCrossAxisSpacing,
        childAspectRatio: effectiveAspectRatio,
        mainAxisExtent: mainAxisExtent,
      );
    }

    return GridView(
      gridDelegate: delegate,
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      physics: physics,
      primary: primary,
      reverse: reverse,
      padding: padding,
      children: children,
    );
  }
}
