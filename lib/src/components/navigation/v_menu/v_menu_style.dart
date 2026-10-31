import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

// WHY: All style fields nullable — follows the cascade pattern where null
// means "inherit from the next level up" (generated token → custom token →
// component override → instance). Non-null values at any level win.
/// Style override for [VMenu].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VMenuStyle implements VComponentStyle {
  const VMenuStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation,
    this.padding,
    this.itemPadding,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Elevation (shadow depth).
  final double? elevation;

  /// Menu container padding.
  final EdgeInsets? padding;

  /// Individual item padding.
  final EdgeInsets? itemPadding;

  /// Creates a copy with only the specified properties changed.
  VMenuStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    double? elevation,
    EdgeInsets? padding,
    EdgeInsets? itemPadding,
  }) => VMenuStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    elevation: elevation ?? this.elevation,
    padding: padding ?? this.padding,
    itemPadding: itemPadding ?? this.itemPadding,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VMenuStyle merge(VMenuStyle? other) {
    if (other == null) return this;
    return VMenuStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      elevation: other.elevation ?? elevation,
      padding: other.padding ?? padding,
      itemPadding: other.itemPadding ?? itemPadding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VMenuStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.elevation == elevation &&
        other.padding == padding &&
        other.itemPadding == itemPadding;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderColor,
    borderRadius,
    elevation,
    padding,
    itemPadding,
  );
}
