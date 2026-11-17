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
  const VMinTapTarget({required this.child, super.key});

  /// The drawn widget, kept at its own size.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final minSize = VTheme.of(context).minTapTargetSize;
    return _MinTapTarget(minSize: minSize, child: child);
  }
}

class _MinTapTarget extends SingleChildRenderObjectWidget {
  const _MinTapTarget({required this.minSize, super.child});

  final double minSize;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMinTapTarget(minSize);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMinTapTarget renderObject,
  ) {
    renderObject.minSize = minSize;
  }
}

// WHY: Same technique as Material's input padding: the box is grown around the
// child and a hit anywhere in it is forwarded to the child's center, so the
// child reacts to a tap in the grown area.
class _RenderMinTapTarget extends RenderShiftedBox {
  _RenderMinTapTarget(this._minSize, [RenderBox? child]) : super(child);

  double _minSize;

  double get minSize => _minSize;

  set minSize(double value) {
    if (_minSize == value) return;
    _minSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final c = child;
    return c == null ? 0 : math.max(c.getMinIntrinsicWidth(height), _minSize);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final c = child;
    return c == null ? 0 : math.max(c.getMaxIntrinsicWidth(height), _minSize);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final c = child;
    return c == null ? 0 : math.max(c.getMinIntrinsicHeight(width), _minSize);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final c = child;
    return c == null ? 0 : math.max(c.getMaxIntrinsicHeight(width), _minSize);
  }

  Size _grow(BoxConstraints constraints, Size childSize) =>
      constraints.constrain(
        Size(
          math.max(childSize.width, _minSize),
          math.max(childSize.height, _minSize),
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
    if (c == null || !size.contains(position)) return false;
    final center = c.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (result, position) => c.hitTest(result, position: center),
    );
  }
}
