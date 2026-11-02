import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VDrawer].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VDrawerStyle implements VComponentStyle {
  const VDrawerStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.borderRadius,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Color of the panel's text and icons; when null they keep what they inherit.
  ///
  /// Children that set their own color keep it. An instance style wins over
  /// the theme override.
  final Color? foregroundColor;

  /// Elevation (shadow depth).
  final double? elevation;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Creates a copy with only the specified properties changed.
  VDrawerStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    BorderRadius? borderRadius,
  }) => VDrawerStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    elevation: elevation ?? this.elevation,
    borderRadius: borderRadius ?? this.borderRadius,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VDrawerStyle merge(VDrawerStyle? other) {
    if (other == null) return this;
    return VDrawerStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      elevation: other.elevation ?? elevation,
      borderRadius: other.borderRadius ?? borderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VDrawerStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.elevation == elevation &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode =>
      Object.hash(backgroundColor, foregroundColor, elevation, borderRadius);
}
