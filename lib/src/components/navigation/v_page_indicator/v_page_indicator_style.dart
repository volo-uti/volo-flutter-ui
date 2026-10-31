import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VPageIndicator].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VPageIndicatorThemeStyle implements VComponentStyle {
  const VPageIndicatorThemeStyle({
    this.activeColor,
    this.inactiveColor,
    this.activeSize,
    this.inactiveSize,
  });

  /// Active dot color.
  final Color? activeColor;

  /// Inactive dot color.
  final Color? inactiveColor;

  /// Active dot size.
  final double? activeSize;

  /// Inactive dot size.
  final double? inactiveSize;

  /// Creates a copy with only the specified properties changed.
  VPageIndicatorThemeStyle copyWith({
    Color? activeColor,
    Color? inactiveColor,
    double? activeSize,
    double? inactiveSize,
  }) => VPageIndicatorThemeStyle(
    activeColor: activeColor ?? this.activeColor,
    inactiveColor: inactiveColor ?? this.inactiveColor,
    activeSize: activeSize ?? this.activeSize,
    inactiveSize: inactiveSize ?? this.inactiveSize,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VPageIndicatorThemeStyle merge(VPageIndicatorThemeStyle? other) {
    if (other == null) return this;
    return VPageIndicatorThemeStyle(
      activeColor: other.activeColor ?? activeColor,
      inactiveColor: other.inactiveColor ?? inactiveColor,
      activeSize: other.activeSize ?? activeSize,
      inactiveSize: other.inactiveSize ?? inactiveSize,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VPageIndicatorThemeStyle &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor &&
        other.activeSize == activeSize &&
        other.inactiveSize == inactiveSize;
  }

  @override
  int get hashCode =>
      Object.hash(activeColor, inactiveColor, activeSize, inactiveSize);
}
