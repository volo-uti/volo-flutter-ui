import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VBox].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VBoxStyle implements VComponentStyle {
  const VBoxStyle({
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Creates a copy with only the specified properties changed.
  VBoxStyle copyWith({
    Color? backgroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
  }) => VBoxStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    borderColor: borderColor ?? this.borderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VBoxStyle merge(VBoxStyle? other) {
    if (other == null) return this;
    return VBoxStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VBoxStyle &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding;
  }

  @override
  int get hashCode =>
      Object.hash(backgroundColor, borderColor, borderRadius, padding);
}
