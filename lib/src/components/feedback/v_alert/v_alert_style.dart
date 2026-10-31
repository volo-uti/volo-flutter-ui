import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VAlert].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VAlertStyle implements VComponentStyle {
  const VAlertStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.iconColor,
    this.titleStyle,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Icon tint color.
  final Color? iconColor;

  /// Title text style.
  final TextStyle? titleStyle;

  /// Creates a copy with only the specified properties changed.
  VAlertStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    Color? iconColor,
    TextStyle? titleStyle,
  }) => VAlertStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    iconColor: iconColor ?? this.iconColor,
    titleStyle: titleStyle ?? this.titleStyle,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VAlertStyle merge(VAlertStyle? other) {
    if (other == null) return this;
    return VAlertStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      iconColor: other.iconColor ?? iconColor,
      titleStyle: other.titleStyle ?? titleStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VAlertStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.iconColor == iconColor &&
        other.titleStyle == titleStyle;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderColor,
    borderRadius,
    padding,
    iconColor,
    titleStyle,
  );
}
