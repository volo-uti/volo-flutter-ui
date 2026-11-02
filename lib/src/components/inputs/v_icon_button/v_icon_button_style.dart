import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VIconButton].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VIconButtonStyle implements VComponentStyle {
  const VIconButtonStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.overlayColor,
    this.iconColor,
    this.iconSize,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text / icon foreground color.
  final Color? foregroundColor;

  /// Border color.
  final Color? borderColor;

  /// Corner radius of the button and its focus ring; defaults to a circle.
  final BorderRadius? borderRadius;

  /// Padding around the icon inside the button.
  ///
  /// The button's diameter stays the size's height.
  final EdgeInsets? padding;

  /// Color laid over the background while the button is hovered or pressed.
  ///
  /// Defaults to a muted tint on hover over a transparent background.
  final Color? overlayColor;

  /// Icon tint color.
  final Color? iconColor;

  /// Icon size.
  final double? iconSize;

  /// Creates a copy with only the specified properties changed.
  VIconButtonStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    Color? overlayColor,
    Color? iconColor,
    double? iconSize,
  }) => VIconButtonStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    overlayColor: overlayColor ?? this.overlayColor,
    iconColor: iconColor ?? this.iconColor,
    iconSize: iconSize ?? this.iconSize,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VIconButtonStyle merge(VIconButtonStyle? other) {
    if (other == null) return this;
    return VIconButtonStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      overlayColor: other.overlayColor ?? overlayColor,
      iconColor: other.iconColor ?? iconColor,
      iconSize: other.iconSize ?? iconSize,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VIconButtonStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.overlayColor == overlayColor &&
        other.iconColor == iconColor &&
        other.iconSize == iconSize;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderColor,
    borderRadius,
    padding,
    overlayColor,
    iconColor,
    iconSize,
  );
}
