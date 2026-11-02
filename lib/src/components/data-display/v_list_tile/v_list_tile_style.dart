import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VListTile].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VListTileStyle implements VComponentStyle {
  const VListTileStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.selectedColor,
    this.borderRadius,
    this.padding,
    this.titleStyle,
    this.subtitleStyle,
    this.leadingWidth,
    this.leadingGap,
    this.trailingGap,
    this.minHeight,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Selected state color.
  final Color? selectedColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Title text style.
  final TextStyle? titleStyle;

  /// Subtitle text style.
  final TextStyle? subtitleStyle;

  /// Width of the leading slot; defaults to the medium size step height (40).
  ///
  /// The slot is at least as tall as the medium size step and centers the
  /// leading widget. An instance style wins over the theme override.
  final double? leadingWidth;

  /// Gap between the leading slot and the text; defaults to large spacing (16).
  ///
  /// An instance style wins over the theme override.
  final double? leadingGap;

  /// Gap between the text and the trailing widget; defaults to large spacing.
  ///
  /// An instance style wins over the theme override.
  final double? trailingGap;

  /// Minimum tile height that replaces the variant's own minimum.
  ///
  /// The variant minimums are 56 (72 with a subtitle), 48 for dense and 88 for
  /// three-line tiles. The tile still grows with its content. An instance
  /// style wins over the theme override.
  final double? minHeight;

  /// Creates a copy with only the specified properties changed.
  VListTileStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? selectedColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    double? leadingWidth,
    double? leadingGap,
    double? trailingGap,
    double? minHeight,
  }) => VListTileStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    selectedColor: selectedColor ?? this.selectedColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    titleStyle: titleStyle ?? this.titleStyle,
    subtitleStyle: subtitleStyle ?? this.subtitleStyle,
    leadingWidth: leadingWidth ?? this.leadingWidth,
    leadingGap: leadingGap ?? this.leadingGap,
    trailingGap: trailingGap ?? this.trailingGap,
    minHeight: minHeight ?? this.minHeight,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VListTileStyle merge(VListTileStyle? other) {
    if (other == null) return this;
    return VListTileStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      selectedColor: other.selectedColor ?? selectedColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      titleStyle: other.titleStyle ?? titleStyle,
      subtitleStyle: other.subtitleStyle ?? subtitleStyle,
      leadingWidth: other.leadingWidth ?? leadingWidth,
      leadingGap: other.leadingGap ?? leadingGap,
      trailingGap: other.trailingGap ?? trailingGap,
      minHeight: other.minHeight ?? minHeight,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VListTileStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.selectedColor == selectedColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.titleStyle == titleStyle &&
        other.subtitleStyle == subtitleStyle &&
        other.leadingWidth == leadingWidth &&
        other.leadingGap == leadingGap &&
        other.trailingGap == trailingGap &&
        other.minHeight == minHeight;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    selectedColor,
    borderRadius,
    padding,
    titleStyle,
    subtitleStyle,
    leadingWidth,
    leadingGap,
    trailingGap,
    minHeight,
  );
}
