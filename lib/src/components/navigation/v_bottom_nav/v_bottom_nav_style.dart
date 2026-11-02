import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VBottomNav].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VBottomNavStyle implements VComponentStyle {
  const VBottomNavStyle({
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.borderColor,
    this.indicatorColor,
    this.indicatorHeight,
    this.shadows,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Active item color.
  final Color? activeColor;

  /// Inactive item color.
  final Color? inactiveColor;

  /// Color of the 1px line along the top edge of the bar.
  final Color? borderColor;

  /// Color of the bar drawn along the top edge of the selected item, or
  /// `null` to draw none.
  final Color? indicatorColor;

  /// Thickness of the selected item's top bar, 4 when null. Used only when
  /// [indicatorColor] is set.
  final double? indicatorHeight;

  /// Shadows under the bar; the theme's small shadow when null.
  ///
  /// An empty list draws no shadow, and [VBottomNav.elevation] at 0 turns the
  /// shadow off whatever this holds. An instance style wins over the theme
  /// override.
  final List<BoxShadow>? shadows;

  /// Creates a copy with only the specified properties changed.
  VBottomNavStyle copyWith({
    Color? backgroundColor,
    Color? activeColor,
    Color? inactiveColor,
    Color? borderColor,
    Color? indicatorColor,
    double? indicatorHeight,
    List<BoxShadow>? shadows,
  }) => VBottomNavStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    activeColor: activeColor ?? this.activeColor,
    inactiveColor: inactiveColor ?? this.inactiveColor,
    borderColor: borderColor ?? this.borderColor,
    indicatorColor: indicatorColor ?? this.indicatorColor,
    indicatorHeight: indicatorHeight ?? this.indicatorHeight,
    shadows: shadows ?? this.shadows,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VBottomNavStyle merge(VBottomNavStyle? other) {
    if (other == null) return this;
    return VBottomNavStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      activeColor: other.activeColor ?? activeColor,
      inactiveColor: other.inactiveColor ?? inactiveColor,
      borderColor: other.borderColor ?? borderColor,
      indicatorColor: other.indicatorColor ?? indicatorColor,
      indicatorHeight: other.indicatorHeight ?? indicatorHeight,
      shadows: other.shadows ?? shadows,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VBottomNavStyle &&
        other.backgroundColor == backgroundColor &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor &&
        other.borderColor == borderColor &&
        other.indicatorColor == indicatorColor &&
        other.indicatorHeight == indicatorHeight &&
        listEquals(other.shadows, shadows);
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    activeColor,
    inactiveColor,
    borderColor,
    indicatorColor,
    indicatorHeight,
    shadows == null ? null : Object.hashAll(shadows!),
  );
}
