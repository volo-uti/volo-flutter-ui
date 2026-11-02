import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VCard].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VCardStyle implements VComponentStyle {
  const VCardStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.shadows,
    this.padding,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Shadows under an elevated card; the theme's medium shadow, large on hover, when null.
  ///
  /// The list replaces both the resting and the hover shadow, and an empty
  /// list draws none. An outlined card draws no shadow. An instance style wins
  /// over the theme override.
  final List<BoxShadow>? shadows;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Creates a copy with only the specified properties changed.
  VCardStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
    EdgeInsets? padding,
  }) => VCardStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    shadows: shadows ?? this.shadows,
    padding: padding ?? this.padding,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VCardStyle merge(VCardStyle? other) {
    if (other == null) return this;
    return VCardStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      shadows: other.shadows ?? shadows,
      padding: other.padding ?? padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VCardStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        listEquals(other.shadows, shadows) &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderColor,
    borderRadius,
    shadows == null ? null : Object.hashAll(shadows!),
    padding,
  );
}
