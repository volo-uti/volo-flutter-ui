import 'package:flutter/foundation.dart';
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
    this.shadows,
    this.overlayColor,
    this.iconColor,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text / icon foreground color.
  final Color? foregroundColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Shadows under the FAB; the theme's medium shadow, large while pressed, when null.
  ///
  /// The list replaces both, and an empty list draws none. [VFab.elevation]
  /// wins over it, and an instance style wins over the theme override.
  final List<BoxShadow>? shadows;

  /// Color laid over the fill while the FAB is hovered or pressed; none when null.
  ///
  /// An instance style wins over the theme override.
  final Color? overlayColor;

  /// Color of the icon; the FAB's foreground color when null.
  ///
  /// The label keeps the foreground color. An instance style wins over the
  /// theme override.
  final Color? iconColor;

  /// Creates a copy with only the specified properties changed.
  VFabStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
    Color? overlayColor,
    Color? iconColor,
  }) => VFabStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderRadius: borderRadius ?? this.borderRadius,
    shadows: shadows ?? this.shadows,
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
      shadows: other.shadows ?? shadows,
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
        listEquals(other.shadows, shadows) &&
        other.overlayColor == overlayColor &&
        other.iconColor == iconColor;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderRadius,
    shadows == null ? null : Object.hashAll(shadows!),
    overlayColor,
    iconColor,
  );
}
