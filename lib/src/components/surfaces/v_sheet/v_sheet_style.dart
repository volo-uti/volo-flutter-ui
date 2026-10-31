import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VSheet].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VSheetStyle implements VComponentStyle {
  const VSheetStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation,
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

  /// Elevation (shadow depth).
  final double? elevation;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Creates a copy with only the specified properties changed.
  VSheetStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    double? elevation,
    EdgeInsets? padding,
  }) => VSheetStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    elevation: elevation ?? this.elevation,
    padding: padding ?? this.padding,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VSheetStyle merge(VSheetStyle? other) {
    if (other == null) return this;
    return VSheetStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      elevation: other.elevation ?? elevation,
      padding: other.padding ?? padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VSheetStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.elevation == elevation &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderColor,
    borderRadius,
    elevation,
    padding,
  );
}
