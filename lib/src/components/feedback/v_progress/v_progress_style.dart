import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VProgress].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VProgressStyle implements VComponentStyle {
  const VProgressStyle({
    this.activeColor,
    this.inactiveColor,
    this.borderRadius,
    this.trackHeight,
  });

  /// Active progress color.
  final Color? activeColor;

  /// Inactive track color.
  final Color? inactiveColor;

  /// Corner radius of the linear bar and its fill; fully round when null.
  ///
  /// The circular ring ignores it. An instance style wins over the theme
  /// override.
  final BorderRadius? borderRadius;

  /// Track height.
  final double? trackHeight;

  /// Creates a copy with only the specified properties changed.
  VProgressStyle copyWith({
    Color? activeColor,
    Color? inactiveColor,
    BorderRadius? borderRadius,
    double? trackHeight,
  }) => VProgressStyle(
    activeColor: activeColor ?? this.activeColor,
    inactiveColor: inactiveColor ?? this.inactiveColor,
    borderRadius: borderRadius ?? this.borderRadius,
    trackHeight: trackHeight ?? this.trackHeight,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VProgressStyle merge(VProgressStyle? other) {
    if (other == null) return this;
    return VProgressStyle(
      activeColor: other.activeColor ?? activeColor,
      inactiveColor: other.inactiveColor ?? inactiveColor,
      borderRadius: other.borderRadius ?? borderRadius,
      trackHeight: other.trackHeight ?? trackHeight,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VProgressStyle &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor &&
        other.borderRadius == borderRadius &&
        other.trackHeight == trackHeight;
  }

  @override
  int get hashCode =>
      Object.hash(activeColor, inactiveColor, borderRadius, trackHeight);
}
