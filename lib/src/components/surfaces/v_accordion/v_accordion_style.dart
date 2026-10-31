import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VAccordion].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VAccordionStyle implements VComponentStyle {
  const VAccordionStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.headerPadding,
    this.iconColor,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Content padding.
  final EdgeInsets? padding;

  /// Header padding.
  final EdgeInsets? headerPadding;

  /// Expand / collapse icon color.
  final Color? iconColor;

  /// Creates a copy with only the specified properties changed.
  VAccordionStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    EdgeInsets? headerPadding,
    Color? iconColor,
  }) => VAccordionStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    headerPadding: headerPadding ?? this.headerPadding,
    iconColor: iconColor ?? this.iconColor,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VAccordionStyle merge(VAccordionStyle? other) {
    if (other == null) return this;
    return VAccordionStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      headerPadding: other.headerPadding ?? headerPadding,
      iconColor: other.iconColor ?? iconColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VAccordionStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.headerPadding == headerPadding &&
        other.iconColor == iconColor;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderColor,
    borderRadius,
    padding,
    headerPadding,
    iconColor,
  );
}
