import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VAlertDialog].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VAlertDialogStyle implements VComponentStyle {
  const VAlertDialogStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.elevation,
    this.padding,
    this.titleStyle,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Elevation (shadow depth).
  final double? elevation;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Title text style.
  final TextStyle? titleStyle;

  /// Creates a copy with only the specified properties changed.
  VAlertDialogStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadius? borderRadius,
    double? elevation,
    EdgeInsets? padding,
    TextStyle? titleStyle,
  }) => VAlertDialogStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderRadius: borderRadius ?? this.borderRadius,
    elevation: elevation ?? this.elevation,
    padding: padding ?? this.padding,
    titleStyle: titleStyle ?? this.titleStyle,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VAlertDialogStyle merge(VAlertDialogStyle? other) {
    if (other == null) return this;
    return VAlertDialogStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderRadius: other.borderRadius ?? borderRadius,
      elevation: other.elevation ?? elevation,
      padding: other.padding ?? padding,
      titleStyle: other.titleStyle ?? titleStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VAlertDialogStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderRadius == borderRadius &&
        other.elevation == elevation &&
        other.padding == padding &&
        other.titleStyle == titleStyle;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderRadius,
    elevation,
    padding,
    titleStyle,
  );
}
