import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VTabs].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VTabsStyle implements VComponentStyle {
  const VTabsStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.activeColor,
    this.inactiveColor,
    this.indicatorColor,
    this.indicatorHeight,
    this.padding,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Active tab color.
  final Color? activeColor;

  /// Inactive tab color.
  final Color? inactiveColor;

  /// Tab indicator color.
  final Color? indicatorColor;

  /// Tab indicator height.
  final double? indicatorHeight;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Creates a copy with only the specified properties changed.
  VTabsStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? activeColor,
    Color? inactiveColor,
    Color? indicatorColor,
    double? indicatorHeight,
    EdgeInsets? padding,
  }) => VTabsStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    activeColor: activeColor ?? this.activeColor,
    inactiveColor: inactiveColor ?? this.inactiveColor,
    indicatorColor: indicatorColor ?? this.indicatorColor,
    indicatorHeight: indicatorHeight ?? this.indicatorHeight,
    padding: padding ?? this.padding,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VTabsStyle merge(VTabsStyle? other) {
    if (other == null) return this;
    return VTabsStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      activeColor: other.activeColor ?? activeColor,
      inactiveColor: other.inactiveColor ?? inactiveColor,
      indicatorColor: other.indicatorColor ?? indicatorColor,
      indicatorHeight: other.indicatorHeight ?? indicatorHeight,
      padding: other.padding ?? padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VTabsStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor &&
        other.indicatorColor == indicatorColor &&
        other.indicatorHeight == indicatorHeight &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    activeColor,
    inactiveColor,
    indicatorColor,
    indicatorHeight,
    padding,
  );
}
