import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VBreadcrumb].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VBreadcrumbStyle implements VComponentStyle {
  const VBreadcrumbStyle({
    this.foregroundColor,
    this.activeColor,
    this.separatorColor,
    this.textStyle,
  });

  /// Default item foreground color.
  final Color? foregroundColor;

  /// Active (current) item color.
  final Color? activeColor;

  /// Separator color.
  final Color? separatorColor;

  /// Text style.
  final TextStyle? textStyle;

  /// Creates a copy with only the specified properties changed.
  VBreadcrumbStyle copyWith({
    Color? foregroundColor,
    Color? activeColor,
    Color? separatorColor,
    TextStyle? textStyle,
  }) => VBreadcrumbStyle(
    foregroundColor: foregroundColor ?? this.foregroundColor,
    activeColor: activeColor ?? this.activeColor,
    separatorColor: separatorColor ?? this.separatorColor,
    textStyle: textStyle ?? this.textStyle,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VBreadcrumbStyle merge(VBreadcrumbStyle? other) {
    if (other == null) return this;
    return VBreadcrumbStyle(
      foregroundColor: other.foregroundColor ?? foregroundColor,
      activeColor: other.activeColor ?? activeColor,
      separatorColor: other.separatorColor ?? separatorColor,
      textStyle: other.textStyle ?? textStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VBreadcrumbStyle &&
        other.foregroundColor == foregroundColor &&
        other.activeColor == activeColor &&
        other.separatorColor == separatorColor &&
        other.textStyle == textStyle;
  }

  @override
  int get hashCode =>
      Object.hash(foregroundColor, activeColor, separatorColor, textStyle);
}
