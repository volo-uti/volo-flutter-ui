import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VCarousel].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VCarouselStyle implements VComponentStyle {
  const VCarouselStyle({
    this.backgroundColor,
    this.borderRadius,
    this.indicatorActiveColor,
    this.indicatorInactiveColor,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Active indicator dot color.
  final Color? indicatorActiveColor;

  /// Inactive indicator dot color.
  final Color? indicatorInactiveColor;

  /// Creates a copy with only the specified properties changed.
  VCarouselStyle copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    Color? indicatorActiveColor,
    Color? indicatorInactiveColor,
  }) => VCarouselStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    borderRadius: borderRadius ?? this.borderRadius,
    indicatorActiveColor: indicatorActiveColor ?? this.indicatorActiveColor,
    indicatorInactiveColor:
        indicatorInactiveColor ?? this.indicatorInactiveColor,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VCarouselStyle merge(VCarouselStyle? other) {
    if (other == null) return this;
    return VCarouselStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      borderRadius: other.borderRadius ?? borderRadius,
      indicatorActiveColor: other.indicatorActiveColor ?? indicatorActiveColor,
      indicatorInactiveColor:
          other.indicatorInactiveColor ?? indicatorInactiveColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VCarouselStyle &&
        other.backgroundColor == backgroundColor &&
        other.borderRadius == borderRadius &&
        other.indicatorActiveColor == indicatorActiveColor &&
        other.indicatorInactiveColor == indicatorInactiveColor;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    borderRadius,
    indicatorActiveColor,
    indicatorInactiveColor,
  );
}
