import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VSlider].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VSliderStyle implements VComponentStyle {
  const VSliderStyle({
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.trackHeight,
  });

  /// Active track color.
  final Color? activeColor;

  /// Inactive track color.
  final Color? inactiveColor;

  /// Thumb color.
  final Color? thumbColor;

  /// Track height.
  final double? trackHeight;

  /// Creates a copy with only the specified properties changed.
  VSliderStyle copyWith({
    Color? activeColor,
    Color? inactiveColor,
    Color? thumbColor,
    double? trackHeight,
  }) => VSliderStyle(
    activeColor: activeColor ?? this.activeColor,
    inactiveColor: inactiveColor ?? this.inactiveColor,
    thumbColor: thumbColor ?? this.thumbColor,
    trackHeight: trackHeight ?? this.trackHeight,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VSliderStyle merge(VSliderStyle? other) {
    if (other == null) return this;
    return VSliderStyle(
      activeColor: other.activeColor ?? activeColor,
      inactiveColor: other.inactiveColor ?? inactiveColor,
      thumbColor: other.thumbColor ?? thumbColor,
      trackHeight: other.trackHeight ?? trackHeight,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VSliderStyle &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor &&
        other.thumbColor == thumbColor &&
        other.trackHeight == trackHeight;
  }

  @override
  int get hashCode =>
      Object.hash(activeColor, inactiveColor, thumbColor, trackHeight);
}
