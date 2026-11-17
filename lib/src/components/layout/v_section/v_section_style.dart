import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VSection].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VSectionStyle implements VComponentStyle {
  const VSectionStyle({
    this.backgroundColor,
    this.padding,
    this.titleStyle,
    this.dividerIndent,
    this.dividerEndIndent,
    this.dividerColor,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Section title text style.
  final TextStyle? titleStyle;

  /// Space before the start of the line between rows; defaults to `spacing.md`.
  final double? dividerIndent;

  /// Space after the end of the line between rows; defaults to `spacing.md`.
  final double? dividerEndIndent;

  /// Color of the line between rows; defaults to the border color.
  final Color? dividerColor;

  /// Creates a copy with only the specified properties changed.
  VSectionStyle copyWith({
    Color? backgroundColor,
    EdgeInsets? padding,
    TextStyle? titleStyle,
    double? dividerIndent,
    double? dividerEndIndent,
    Color? dividerColor,
  }) => VSectionStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    padding: padding ?? this.padding,
    titleStyle: titleStyle ?? this.titleStyle,
    dividerIndent: dividerIndent ?? this.dividerIndent,
    dividerEndIndent: dividerEndIndent ?? this.dividerEndIndent,
    dividerColor: dividerColor ?? this.dividerColor,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VSectionStyle merge(VSectionStyle? other) {
    if (other == null) return this;
    return VSectionStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      padding: other.padding ?? padding,
      titleStyle: other.titleStyle ?? titleStyle,
      dividerIndent: other.dividerIndent ?? dividerIndent,
      dividerEndIndent: other.dividerEndIndent ?? dividerEndIndent,
      dividerColor: other.dividerColor ?? dividerColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VSectionStyle &&
        other.backgroundColor == backgroundColor &&
        other.padding == padding &&
        other.titleStyle == titleStyle &&
        other.dividerIndent == dividerIndent &&
        other.dividerEndIndent == dividerEndIndent &&
        other.dividerColor == dividerColor;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    padding,
    titleStyle,
    dividerIndent,
    dividerEndIndent,
    dividerColor,
  );
}
