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

  /// Top border color.
  final Color? borderColor;

  /// Elevation (shadow depth).
  final double? elevation;

  /// Creates a copy with only the specified properties changed.
  VBottomNavStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? activeColor,
    Color? inactiveColor,
    Color? borderColor,
    double? elevation,
  }) => VBottomNavStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    activeColor: activeColor ?? this.activeColor,
    inactiveColor: inactiveColor ?? this.inactiveColor,
    borderColor: borderColor ?? this.borderColor,
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
        other.elevation == elevation;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    activeColor,
    inactiveColor,
    borderColor,
    elevation,
  );
}
