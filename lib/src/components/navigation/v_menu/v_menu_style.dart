import 'package:flutter/foundation.dart';
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
    this.padding,
    this.itemPadding,
    this.minWidth,
    this.borderWidth,
    this.shadows,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Menu container padding.
  final EdgeInsets? padding;

  /// Individual item padding.
  final EdgeInsets? itemPadding;

  /// Minimum width of the menu panel; 180 when null.
  ///
  /// The panel still grows to fit its widest row. An instance style wins over
  /// the theme override.
  final double? minWidth;

  /// Width of the panel border; 1 when null.
  ///
  /// An instance style wins over the theme override.
  final double? borderWidth;

  /// Shadows under the panel; the theme's large shadow when null.
  ///
  /// An empty list draws no shadow. An instance style wins over the theme
  /// override.
  final List<BoxShadow>? shadows;

  /// Creates a copy with only the specified properties changed.
  VMenuStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    EdgeInsets? itemPadding,
    double? minWidth,
    double? borderWidth,
    List<BoxShadow>? shadows,
  }) => VMenuStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    itemPadding: itemPadding ?? this.itemPadding,
    minWidth: minWidth ?? this.minWidth,
    borderWidth: borderWidth ?? this.borderWidth,
    shadows: shadows ?? this.shadows,
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
      padding: other.padding ?? padding,
      itemPadding: other.itemPadding ?? itemPadding,
      minWidth: other.minWidth ?? minWidth,
      borderWidth: other.borderWidth ?? borderWidth,
      shadows: other.shadows ?? shadows,
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
        other.padding == padding &&
        other.itemPadding == itemPadding &&
        other.minWidth == minWidth &&
        other.borderWidth == borderWidth &&
        listEquals(other.shadows, shadows);
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderColor,
    borderRadius,
    padding,
    itemPadding,
    minWidth,
    borderWidth,
    shadows == null ? null : Object.hashAll(shadows!),
  );
}
