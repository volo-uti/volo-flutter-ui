import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VEmptyState].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VEmptyStateStyle implements VComponentStyle {
  const VEmptyStateStyle({
    this.padding,
    this.iconColor,
    this.titleStyle,
    this.descriptionStyle,
  });

  /// Space around the content; defaults to the theme's xxl spacing.
  final EdgeInsets? padding;

  /// Color of an icon that takes the [IconTheme] color.
  final Color? iconColor;

  /// Merged onto the title style (titleMedium in the foreground color).
  final TextStyle? titleStyle;

  /// Merged onto the description style (bodyMedium in the muted color).
  final TextStyle? descriptionStyle;

  /// Creates a copy with only the specified properties changed.
  VEmptyStateStyle copyWith({
    EdgeInsets? padding,
    Color? iconColor,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
  }) => VEmptyStateStyle(
    padding: padding ?? this.padding,
    iconColor: iconColor ?? this.iconColor,
    titleStyle: titleStyle ?? this.titleStyle,
    descriptionStyle: descriptionStyle ?? this.descriptionStyle,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VEmptyStateStyle merge(VEmptyStateStyle? other) {
    if (other == null) return this;
    return VEmptyStateStyle(
      padding: other.padding ?? padding,
      iconColor: other.iconColor ?? iconColor,
      titleStyle: other.titleStyle ?? titleStyle,
      descriptionStyle: other.descriptionStyle ?? descriptionStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VEmptyStateStyle &&
        other.padding == padding &&
        other.iconColor == iconColor &&
        other.titleStyle == titleStyle &&
        other.descriptionStyle == descriptionStyle;
  }

  @override
  int get hashCode =>
      Object.hash(padding, iconColor, titleStyle, descriptionStyle);
}
