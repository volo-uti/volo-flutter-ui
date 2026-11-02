import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VButton].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VButtonStyle implements VComponentStyle {
  const VButtonStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.iconColor,
    this.gap,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text / icon foreground color.
  ///
  /// Wins over the color of [textStyle]; defaults to the variant's color.
  final Color? foregroundColor;

  /// Border color.
  final Color? borderColor;

  /// Corner radius of a [VButtonCorner.rounded] button.
  ///
  /// A [VButtonGroup] position and a square, pill or circle `corner` win over
  /// it; defaults to the size's radius token.
  final BorderRadius? borderRadius;

  /// Padding around the content.
  ///
  /// Defaults to the size's horizontal padding. `VButton.icon` ignores it, since
  /// it is a fixed square.
  final EdgeInsets? padding;

  /// Label text style, merged over the size's font size and medium weight.
  final TextStyle? textStyle;

  /// Color of the leading, trailing and child icons.
  ///
  /// Defaults to [foregroundColor].
  final Color? iconColor;

  /// Gap between an icon and the label.
  ///
  /// `leadingGap` and `trailingGap` win over it; defaults to the size's spacing
  /// token.
  final double? gap;

  /// Creates a copy with only the specified properties changed.
  VButtonStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    TextStyle? textStyle,
    Color? iconColor,
    double? gap,
  }) => VButtonStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    textStyle: textStyle ?? this.textStyle,
    iconColor: iconColor ?? this.iconColor,
    gap: gap ?? this.gap,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VButtonStyle merge(VButtonStyle? other) {
    if (other == null) return this;
    return VButtonStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      textStyle: other.textStyle ?? textStyle,
      iconColor: other.iconColor ?? iconColor,
      gap: other.gap ?? gap,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VButtonStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.iconColor == iconColor &&
        other.gap == gap;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderColor,
    borderRadius,
    padding,
    textStyle,
    iconColor,
    gap,
  );
}
