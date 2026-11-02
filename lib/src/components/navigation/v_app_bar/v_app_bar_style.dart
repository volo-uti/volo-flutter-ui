import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VAppBar].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VAppBarStyle implements VComponentStyle {
  const VAppBarStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.elevation,
    this.padding,
    this.titleStyle,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text / icon foreground color.
  final Color? foregroundColor;

  /// Color of a line along the bottom edge of the bar; no line when null.
  ///
  /// The line is as wide as the subtle border token and runs below
  /// [VAppBar.bottom] too. An instance style wins over the theme override.
  final Color? borderColor;

  /// Elevation (shadow depth).
  final double? elevation;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Title text style.
  final TextStyle? titleStyle;

  /// Creates a copy with only the specified properties changed.
  VAppBarStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    double? elevation,
    EdgeInsets? padding,
    TextStyle? titleStyle,
  }) => VAppBarStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    elevation: elevation ?? this.elevation,
    padding: padding ?? this.padding,
    titleStyle: titleStyle ?? this.titleStyle,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VAppBarStyle merge(VAppBarStyle? other) {
    if (other == null) return this;
    return VAppBarStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      elevation: other.elevation ?? elevation,
      padding: other.padding ?? padding,
      titleStyle: other.titleStyle ?? titleStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VAppBarStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.elevation == elevation &&
        other.padding == padding &&
        other.titleStyle == titleStyle;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderColor,
    elevation,
    padding,
    titleStyle,
  );
}
