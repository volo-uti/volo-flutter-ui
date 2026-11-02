import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VLink].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VLinkStyle implements VComponentStyle {
  const VLinkStyle({this.foregroundColor, this.hoverColor, this.textStyle});

  /// Text foreground color.
  final Color? foregroundColor;

  /// Color on hover.
  final Color? hoverColor;

  /// Text style.
  final TextStyle? textStyle;

  /// Creates a copy with only the specified properties changed.
  VLinkStyle copyWith({
    Color? foregroundColor,
    Color? hoverColor,
    TextStyle? textStyle,
  }) => VLinkStyle(
    foregroundColor: foregroundColor ?? this.foregroundColor,
    hoverColor: hoverColor ?? this.hoverColor,
    textStyle: textStyle ?? this.textStyle,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VLinkStyle merge(VLinkStyle? other) {
    if (other == null) return this;
    return VLinkStyle(
      foregroundColor: other.foregroundColor ?? foregroundColor,
      hoverColor: other.hoverColor ?? hoverColor,
      textStyle: other.textStyle ?? textStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VLinkStyle &&
        other.foregroundColor == foregroundColor &&
        other.hoverColor == hoverColor &&
        other.textStyle == textStyle;
  }

  @override
  int get hashCode => Object.hash(foregroundColor, hoverColor, textStyle);
}
