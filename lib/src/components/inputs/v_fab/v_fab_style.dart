import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VFab].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VFabStyle implements VComponentStyle {
  const VFabStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.elevation,
    this.overlayColor,
    this.iconColor,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text / icon foreground color.
  final Color? foregroundColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Elevation (shadow depth).
  final double? elevation;

  /// Press / hover overlay color.
  final Color? overlayColor;

  /// Icon tint color.
  final Color? iconColor;

  /// Creates a copy with only the specified properties changed.
  VFabStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadius? borderRadius,
    double? elevation,
    Color? overlayColor,
    Color? iconColor,
  }) => VFabStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderRadius: borderRadius ?? this.borderRadius,
    elevation: elevation ?? this.elevation,
    overlayColor: overlayColor ?? this.overlayColor,
    iconColor: iconColor ?? this.iconColor,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VFabStyle merge(VFabStyle? other) {
    if (other == null) return this;
    return VFabStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderRadius: other.borderRadius ?? borderRadius,
      elevation: other.elevation ?? elevation,
      overlayColor: other.overlayColor ?? overlayColor,
      iconColor: other.iconColor ?? iconColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VFabStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderRadius == borderRadius &&
        other.elevation == elevation &&
        other.overlayColor == overlayColor &&
        other.iconColor == iconColor;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderRadius,
    elevation,
    overlayColor,
    iconColor,
  );
}
