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
    this.foregroundColor,
    this.activeColor,
    this.inactiveColor,
    this.borderColor,
    this.indicatorColor,
    this.indicatorHeight,
    this.elevation,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

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

  /// Elevation (shadow depth).
  final double? elevation;

  /// Creates a copy with only the specified properties changed.
  VBottomNavStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? activeColor,
    Color? inactiveColor,
    Color? borderColor,
    Color? indicatorColor,
    double? indicatorHeight,
    double? elevation,
  }) => VBottomNavStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    activeColor: activeColor ?? this.activeColor,
    inactiveColor: inactiveColor ?? this.inactiveColor,
    borderColor: borderColor ?? this.borderColor,
    indicatorColor: indicatorColor ?? this.indicatorColor,
    indicatorHeight: indicatorHeight ?? this.indicatorHeight,
    elevation: elevation ?? this.elevation,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VBottomNavStyle merge(VBottomNavStyle? other) {
    if (other == null) return this;
    return VBottomNavStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      activeColor: other.activeColor ?? activeColor,
      inactiveColor: other.inactiveColor ?? inactiveColor,
      borderColor: other.borderColor ?? borderColor,
      indicatorColor: other.indicatorColor ?? indicatorColor,
      indicatorHeight: other.indicatorHeight ?? indicatorHeight,
      elevation: other.elevation ?? elevation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VBottomNavStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor &&
        other.borderColor == borderColor &&
        other.indicatorColor == indicatorColor &&
        other.indicatorHeight == indicatorHeight &&
        other.elevation == elevation;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    activeColor,
    inactiveColor,
    borderColor,
    indicatorColor,
    indicatorHeight,
    elevation,
  );
}
