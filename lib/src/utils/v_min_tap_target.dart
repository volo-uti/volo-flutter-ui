import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../theme/v_theme.dart';

/// Grows its own box to at least the theme's `minTapTargetSize` on both axes
/// and centers [child] in it, leaving the child drawn at its own size.
///
/// Wrap the drawn part of a tappable widget with it from the inside of the
/// widget's gesture and semantics, so the area that reacts to a tap and the
/// semantics rectangle are both at least the minimum while the look is
/// unchanged. A tap anywhere in the grown box reaches [child].
///
/// A child that is already at least as large as the minimum is not changed.
class VMinTapTarget extends StatelessWidget {
  /// Creates a wrapper that keeps [child] at least the theme's minimum tap
  /// target size.
  const VMinTapTarget({required this.child, this.growLayout = true, super.key});

  /// Whether the box grows to the minimum size.
  ///
  /// When false the box keeps [child]'s size, so the surrounding layout does
  /// not change; only a tap within the minimum-sized area around the child
  /// (and inside the parent's own bounds) still reaches [child]. Pair it with
  /// [VMinTapTargetSemantics] to widen the semantics rectangle as well.
  final bool growLayout;

  /// The drawn widget, kept at its own size.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final minSize = VTheme.of(context).minTapTargetSize;
    return _MinTapTarget(
      minSize: minSize,
      growLayout: growLayout,
      child: child,
    );
  }
}

class _MinTapTarget extends SingleChildRenderObjectWidget {
  const _MinTapTarget({
    required this.minSize,
    required this.growLayout,
    super.child,
  });

  final double minSize;
  final bool growLayout;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMinTapTarget(minSize: minSize, growLayout: growLayout);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMinTapTarget renderObject,
  ) {
    renderObject
      ..minSize = minSize
      ..growLayout = growLayout;
  }
}

// WHY: Same technique as Material's input padding: the box is grown around the
// child and a hit anywhere in it is forwarded to the child's center, so the
// child reacts to a tap in the grown area.
class _RenderMinTapTarget extends RenderShiftedBox {
  _RenderMinTapTarget({required this._minSize, required this._growLayout})
    : super(null);

  double _minSize;
  bool _growLayout;

  bool get growLayout => _growLayout;

  set growLayout(bool value) {
    if (_growLayout == value) return;
    _growLayout = value;
    markNeedsLayout();
  }

  double get minSize => _minSize;

  set minSize(double value) {
    if (_minSize == value) return;
    _minSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final c = child;
    return c == null ? 0 : math.max(c.getMinIntrinsicWidth(height), _grow0);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final c = child;
    return c == null ? 0 : math.max(c.getMaxIntrinsicWidth(height), _grow0);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final c = child;
    return c == null ? 0 : math.max(c.getMinIntrinsicHeight(width), _grow0);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final c = child;
    return c == null ? 0 : math.max(c.getMaxIntrinsicHeight(width), _grow0);
  }

  double get _grow0 => _growLayout ? _minSize : 0;

  Size _grow(BoxConstraints constraints, Size childSize) =>
      constraints.constrain(
        Size(
          math.max(childSize.width, _grow0),
          math.max(childSize.height, _grow0),
        ),
      );

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final c = child;
    if (c == null) return Size.zero;
    return _grow(constraints, c.getDryLayout(constraints));
  }

  @override
  double? computeDryBaseline(
    BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    final c = child;
    if (c == null) return null;
    final childBaseline = c.getDryBaseline(constraints, baseline);
    if (childBaseline == null) return null;
    final childSize = c.getDryLayout(constraints);
    final grown = _grow(constraints, childSize);
    return childBaseline + (grown.height - childSize.height) / 2;
  }

  @override
  void performLayout() {
    final c = child;
    if (c == null) {
      size = Size.zero;
      return;
    }
    c.layout(constraints, parentUsesSize: true);
    size = _grow(constraints, c.size);
    (c.parentData! as BoxParentData).offset = Alignment.center.alongOffset(
      size - c.size as Offset,
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (super.hitTest(result, position: position)) return true;
    final c = child;
    if (c == null) return false;
    final area = _growLayout
        ? Offset.zero & size
        : Rect.fromCenter(
            center: size.center(Offset.zero),
            width: math.max(size.width, _minSize),
            height: math.max(size.height, _minSize),
          );
    if (!area.contains(position)) return false;
    final center = c.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (result, position) => c.hitTest(result, position: center),
    );
  }
}

/// Semantics node whose rectangle is at least the theme's minimum tap target.
///
/// Use it instead of [Semantics] around a [VMinTapTarget] with `growLayout`
/// false: the node is reported at the minimum size around its child while the
/// layout stays as it is.
class VMinTapTargetSemantics extends StatelessWidget {
  /// Creates a semantics node of at least the minimum tap target size.
  const VMinTapTargetSemantics({
    required this.child,
    this.label,
    this.button = true,
    this.enabled,
    this.selected,
    this.toggled,
    this.inMutuallyExclusiveGroup,
    super.key,
  });

  /// The widget the node describes.
  final Widget child;

  /// The label a screen reader announces.
  final String? label;

  /// Whether the node is a button.
  final bool button;

  /// Whether the node is enabled; unset when null.
  final bool? enabled;

  /// Whether the node is selected; unset when null.
  final bool? selected;

  /// Whether the node is toggled on; unset when null.
  final bool? toggled;

  /// Whether the node is in a mutually exclusive group; unset when null.
  final bool? inMutuallyExclusiveGroup;

  @override
  Widget build(BuildContext context) => _MinTapSemantics(
    minSize: VTheme.of(context).minTapTargetSize,
    properties: SemanticsProperties(
      button: button,
      label: label,
      enabled: enabled,
      selected: selected,
      toggled: toggled,
      inMutuallyExclusiveGroup: inMutuallyExclusiveGroup,
    ),
    textDirection: Directionality.maybeOf(context),
    child: child,
  );
}

class _MinTapSemantics extends SingleChildRenderObjectWidget {
  const _MinTapSemantics({
    required this.minSize,
    required this.properties,
    required this.textDirection,
    super.child,
  });

  final double minSize;
  final SemanticsProperties properties;
  final TextDirection? textDirection;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMinTapSemantics(
        minSize: minSize,
        properties: properties,
        textDirection: textDirection,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMinTapSemantics renderObject,
  ) {
    renderObject
      ..minSize = minSize
      ..properties = properties
      ..textDirection = textDirection;
  }
}

class _RenderMinTapSemantics extends RenderSemanticsAnnotations {
  _RenderMinTapSemantics({
    required this._minSize,
    required super.properties,
    super.textDirection,
  }) : super(container: true);

  double _minSize;

  double get minSize => _minSize;

  set minSize(double value) {
    if (_minSize == value) return;
    _minSize = value;
    markNeedsSemanticsUpdate();
  }

  @override
  Rect get semanticBounds => Rect.fromCenter(
    center: size.center(Offset.zero),
    width: math.max(size.width, _minSize),
    height: math.max(size.height, _minSize),
  );
}
