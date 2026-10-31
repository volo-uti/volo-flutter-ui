import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_button/v_button.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_button_group_style.dart';

// ── VButtonGroupScope (InheritedWidget for group → button data propagation) ──

/// Size and corner radius a [VButtonGroup] hands down to each child [VButton].
class VButtonGroupData {
  /// Creates the data a group shares with one of its buttons.
  const VButtonGroupData({this.size, this.borderRadius});

  /// Button size shared across the entire group.
  final VButtonSize? size;

  /// Border radius computed based on position within the group (first/middle/last).
  final BorderRadius? borderRadius;
}

/// Inherited scope that makes a [VButtonGroupData] visible to descendants.
class VButtonGroupScope extends InheritedWidget {
  /// Creates a scope exposing [data] to [child].
  const VButtonGroupScope({
    required this.data,
    required super.child,
    super.key,
  });

  /// Data exposed to descendants.
  final VButtonGroupData data;

  /// Returns the data from the nearest [VButtonGroupScope].
  static VButtonGroupData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VButtonGroupScope>()?.data;

  @override
  bool updateShouldNotify(VButtonGroupScope oldWidget) =>
      data.size != oldWidget.data.size ||
      data.borderRadius != oldWidget.data.borderRadius;
}

// ── VButtonGroup ──

/// Direction in which a [VButtonGroup] lays out its buttons.
enum VButtonGroupOrientation {
  /// Horizontal layout (default).
  horizontal,

  /// Vertical layout.
  vertical,
}

/// Row or column of [VButton]s joined into one segmented control.
///
/// Gives the buttons connected corner radii and a shared size.
///
/// ```dart
/// VButtonGroup(
///   children: [
///     VButton(onPressed: () {}, child: Text('Left')),
///     VButton(onPressed: () {}, child: Text('Center')),
///     VButton(onPressed: () {}, child: Text('Right')),
///   ],
/// )
/// ```
class VButtonGroup extends StatelessWidget {
  /// Creates a button group.
  const VButtonGroup({
    required this.children,
    super.key,
    this.orientation = VButtonGroupOrientation.horizontal,
    this.size,
    this.spacing = 0,
    this.style,
  });

  /// Buttons in display order.
  final List<Widget> children;

  /// Direction of the layout.
  final VButtonGroupOrientation orientation;

  /// Size shared by all child buttons.
  final VButtonSize? size;

  /// Gap between buttons; zero keeps them connected.
  final double spacing;

  /// Style override merged over the theme's [VButtonGroupStyle].
  final VButtonGroupStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VButtonGroupStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;

    final isHorizontal = orientation == VButtonGroupOrientation.horizontal;

    // Resolve border radius from size token
    final sizeToken = switch (size) {
      VButtonSize.xs => theme.sizes.xs,
      VButtonSize.sm => theme.sizes.sm,
      VButtonSize.lg => theme.sizes.lg,
      VButtonSize.xl => theme.sizes.xl,
      _ => theme.sizes.md,
    };
    final r = sizeToken.borderRadius;

    // Apply resolvedStyle overrides
    final effectiveSpacing = resolvedStyle?.spacing ?? spacing;

    // Build children with per-position border-radius via VButtonGroupScope
    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      final isFirst = i == 0;
      final isLast = i == children.length - 1;
      final isSingle = children.length == 1;

      BorderRadius borderRadius;
      if (isSingle) {
        borderRadius = BorderRadius.circular(r);
      } else if (isFirst) {
        borderRadius = isHorizontal
            ? BorderRadius.only(
                topLeft: Radius.circular(r),
                bottomLeft: Radius.circular(r),
              )
            : BorderRadius.only(
                topLeft: Radius.circular(r),
                topRight: Radius.circular(r),
              );
      } else if (isLast) {
        borderRadius = isHorizontal
            ? BorderRadius.only(
                topRight: Radius.circular(r),
                bottomRight: Radius.circular(r),
              )
            : BorderRadius.only(
                bottomLeft: Radius.circular(r),
                bottomRight: Radius.circular(r),
              );
      } else {
        borderRadius = BorderRadius.zero;
      }

      final child = VButtonGroupScope(
        data: VButtonGroupData(size: size, borderRadius: borderRadius),
        child: children[i],
      );

      if (!isFirst && effectiveSpacing > 0) {
        items.add(
          SizedBox(
            width: isHorizontal ? effectiveSpacing : 0,
            height: isHorizontal ? 0 : effectiveSpacing,
          ),
        );
      }

      items.add(child);
    }

    return FocusTraversalGroup(
      child: Semantics(
        container: true,
        child: isHorizontal
            ? Row(mainAxisSize: MainAxisSize.min, children: items)
            : Column(mainAxisSize: MainAxisSize.min, children: items),
      ),
    );
  }
}
