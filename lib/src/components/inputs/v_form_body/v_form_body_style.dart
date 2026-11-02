import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VFormBody].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VFormBodyStyle implements VComponentStyle {
  const VFormBodyStyle({
    this.spacing,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.focusBorderColor,
    this.borderRadius,
  });

  /// Gap between the leading or trailing slot and the child.
  ///
  /// Defaults to the small spacing token.
  final double? spacing;

  /// Padding inside the box; defaults to the size's horizontal padding.
  final EdgeInsets? padding;

  /// Fill color of the box.
  ///
  /// Defaults to a muted tint for the filled type and to none otherwise.
  final Color? backgroundColor;

  /// Border color while the box is not focused.
  ///
  /// The disabled, error and success colors win over it; defaults to the input
  /// color token.
  final Color? borderColor;

  /// Border color while the box is focused.
  ///
  /// The disabled, error and success colors win over it; defaults to the
  /// accent color of `color`.
  final Color? focusBorderColor;

  /// Corner radius of a rounded box.
  ///
  /// A square or pill `corner` wins over it; defaults to the size's radius
  /// token.
  final BorderRadius? borderRadius;

  /// Creates a copy with only the specified properties changed.
  VFormBodyStyle copyWith({
    double? spacing,
    EdgeInsets? padding,
    Color? backgroundColor,
    Color? borderColor,
    Color? focusBorderColor,
    BorderRadius? borderRadius,
  }) => VFormBodyStyle(
    spacing: spacing ?? this.spacing,
    padding: padding ?? this.padding,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    borderColor: borderColor ?? this.borderColor,
    focusBorderColor: focusBorderColor ?? this.focusBorderColor,
    borderRadius: borderRadius ?? this.borderRadius,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VFormBodyStyle merge(VFormBodyStyle? other) {
    if (other == null) return this;
    return VFormBodyStyle(
      spacing: other.spacing ?? spacing,
      padding: other.padding ?? padding,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      borderColor: other.borderColor ?? borderColor,
      focusBorderColor: other.focusBorderColor ?? focusBorderColor,
      borderRadius: other.borderRadius ?? borderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VFormBodyStyle &&
        other.spacing == spacing &&
        other.padding == padding &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.focusBorderColor == focusBorderColor &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(
    spacing,
    padding,
    backgroundColor,
    borderColor,
    focusBorderColor,
    borderRadius,
  );
}
