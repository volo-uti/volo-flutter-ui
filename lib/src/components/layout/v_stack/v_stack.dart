import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_stack_style.dart';

/// {@template v_stack}
/// Row or column with a fixed gap between children.
///
/// [VStack.horizontal] builds a [Row] and [VStack.vertical] a [Column]; both
/// insert [spacing] between neighbours. Unlike Flutter's `Stack`, children do
/// not overlap. An empty list renders nothing.
///
/// ## Basic Usage:
///
/// Vertical stack:
///
/// ```dart
/// VStack.vertical(
///   spacing: 8,
///   children: [
///     Text('Item 1'),
///     Text('Item 2'),
///     Text('Item 3'),
///   ],
/// )
/// ```
///
/// ## Variants:
///
/// - [VStack.horizontal] - Horizontal stack (Row-based)
/// - [VStack.vertical] - Vertical stack (Column-based)
///
/// ## Horizontal Stack:
///
/// Horizontal stack:
///
/// ```dart
/// VStack.horizontal(
///   spacing: 16,
///   mainAxisAlignment: MainAxisAlignment.center,
///   children: [
///     Icon(Icons.home),
///     Icon(Icons.search),
///     Icon(Icons.settings),
///   ],
/// )
/// ```
///
/// ## With Alignment:
///
/// Stack with alignment:
///
/// ```dart
/// VStack.vertical(
///   spacing: 12,
///   crossAxisAlignment: CrossAxisAlignment.start,
///   mainAxisSize: MainAxisSize.min,
///   children: [
///     Text('Title', style: TextStyle(fontSize: 20)),
///     Text('Subtitle', style: TextStyle(fontSize: 14)),
///     Text('Description'),
///   ],
/// )
/// ```
///
/// See also:
///
/// - [Row], Flutter built-in horizontal layout
/// - [Column], Flutter built-in vertical layout
/// - [VBox], single child container
/// {@endtemplate}
class VStack extends StatelessWidget {
  /// Horizontal stack (Row-based).
  ///
  /// Arranges children horizontally using [Row].
  ///
  /// ```dart
  /// VStack.horizontal(
  ///   spacing: 8,
  ///   children: [Widget1(), Widget2()],
  /// )
  /// ```
  const VStack.horizontal({
    required this.children,
    super.key,
    this.spacing,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.style,
  }) : _direction = Axis.horizontal;

  /// {@macro v_stack}
  ///
  /// Vertical stack (Column-based).
  ///
  /// Arranges children vertically using [Column].
  ///
  /// ```dart
  /// VStack.vertical(
  ///   spacing: 8,
  ///   children: [Widget1(), Widget2()],
  /// )
  /// ```
  const VStack.vertical({
    required this.children,
    super.key,
    this.spacing,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.style,
  }) : _direction = Axis.vertical;

  /// Widgets laid out in order.
  final List<Widget> children;

  /// Gap between neighbouring children, in logical pixels; defaults to 0.
  final double? spacing;

  /// How children are placed along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How children are placed across the main axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// Whether to fill the main axis or shrink to the children.
  final MainAxisSize mainAxisSize;

  /// Order of horizontal children, for right-to-left layouts.
  final TextDirection? textDirection;

  /// Order of vertical children, top to bottom or reversed.
  final VerticalDirection verticalDirection;

  /// Overrides the theme style, for example the spacing.
  final VStackStyle? style;

  final Axis _direction;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = VTheme.of(context);
    // Apply style overrides
    final themeStyle = theme.componentOverrides.get<VStackStyle>();
    // Precedence: instance style > constructor argument > theme override.
    final baseSpacing = style?.spacing ?? spacing ?? themeStyle?.spacing ?? 0;
    final effectiveSpacing = baseSpacing > 0 ? baseSpacing : 0.0;

    // Build child list with spacing applied
    final spacedChildren = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);

      // Add spacing unless it's the last child
      if (i < children.length - 1 && effectiveSpacing > 0) {
        spacedChildren.add(
          _direction == Axis.horizontal
              ? SizedBox(width: effectiveSpacing)
              : SizedBox(height: effectiveSpacing),
        );
      }
    }

    if (_direction == Axis.horizontal) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        children: spacedChildren,
      );
    } else {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        children: spacedChildren,
      );
    }
  }
}
