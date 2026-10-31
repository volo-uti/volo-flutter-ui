import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VHoverCard].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VHoverCardStyle implements VComponentStyle {
  const VHoverCardStyle({
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation,
    this.padding,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Elevation (shadow depth).
  final double? elevation;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Creates a copy with only the specified properties changed.
  VHoverCardStyle copyWith({
    Color? backgroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    double? elevation,
    EdgeInsets? padding,
  }) => VHoverCardStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    elevation: elevation ?? this.elevation,
    padding: padding ?? this.padding,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VHoverCardStyle merge(VHoverCardStyle? other) {
    if (other == null) return this;
    return VHoverCardStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      elevation: other.elevation ?? elevation,
      padding: other.padding ?? padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VHoverCardStyle &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.elevation == elevation &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    borderColor,
    borderRadius,
    elevation,
    padding,
  );
}
