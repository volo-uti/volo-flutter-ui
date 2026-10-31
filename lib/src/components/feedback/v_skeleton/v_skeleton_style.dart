import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VSkeleton].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VSkeletonStyle implements VComponentStyle {
  const VSkeletonStyle({
    this.baseColor,
    this.highlightColor,
    this.borderRadius,
  });

  /// Base shimmer color.
  final Color? baseColor;

  /// Highlight shimmer color.
  final Color? highlightColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Creates a copy with only the specified properties changed.
  VSkeletonStyle copyWith({
    Color? baseColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
  }) => VSkeletonStyle(
    baseColor: baseColor ?? this.baseColor,
    highlightColor: highlightColor ?? this.highlightColor,
    borderRadius: borderRadius ?? this.borderRadius,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VSkeletonStyle merge(VSkeletonStyle? other) {
    if (other == null) return this;
    return VSkeletonStyle(
      baseColor: other.baseColor ?? baseColor,
      highlightColor: other.highlightColor ?? highlightColor,
      borderRadius: other.borderRadius ?? borderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VSkeletonStyle &&
        other.baseColor == baseColor &&
        other.highlightColor == highlightColor &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(baseColor, highlightColor, borderRadius);
}
