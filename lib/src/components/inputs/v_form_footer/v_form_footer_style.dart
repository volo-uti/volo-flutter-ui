import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VFormFooter].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VFormFooterStyle implements VComponentStyle {
  const VFormFooterStyle({
    this.padding,
    this.spacing,
    this.helperStyle,
    this.errorStyle,
  });

  /// Padding around the message rows; defaults to a small gap above them.
  final EdgeInsets? padding;

  /// Gap above the extra note; defaults to the smallest spacing token.
  final double? spacing;

  /// Text style of the helper text, merged over the label small type style.
  ///
  /// Its color wins over the muted foreground color.
  final TextStyle? helperStyle;

  /// Text style of the error text, merged over the label small type style.
  ///
  /// Its color wins over the destructive color.
  final TextStyle? errorStyle;

  /// Creates a copy with only the specified properties changed.
  VFormFooterStyle copyWith({
    EdgeInsets? padding,
    double? spacing,
    TextStyle? helperStyle,
    TextStyle? errorStyle,
  }) => VFormFooterStyle(
    padding: padding ?? this.padding,
    spacing: spacing ?? this.spacing,
    helperStyle: helperStyle ?? this.helperStyle,
    errorStyle: errorStyle ?? this.errorStyle,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VFormFooterStyle merge(VFormFooterStyle? other) {
    if (other == null) return this;
    return VFormFooterStyle(
      padding: other.padding ?? padding,
      spacing: other.spacing ?? spacing,
      helperStyle: other.helperStyle ?? helperStyle,
      errorStyle: other.errorStyle ?? errorStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VFormFooterStyle &&
        other.padding == padding &&
        other.spacing == spacing &&
        other.helperStyle == helperStyle &&
        other.errorStyle == errorStyle;
  }

  @override
  int get hashCode => Object.hash(padding, spacing, helperStyle, errorStyle);
}
