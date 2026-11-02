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
    this.activeColor,
    this.inactiveColor,
    this.indicatorColor,
    this.indicatorHeight,
    this.padding,
    this.textStyle,
    this.selectedTextStyle,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Selected tab color: its text, or its fill on [VTabs.pills].
  ///
  /// Wins over the color of [selectedTextStyle].
  final Color? activeColor;

  /// Text color of the tabs that are not selected.
  ///
  /// Wins over the color of [textStyle].
  final Color? inactiveColor;

  /// Underline color of [VTabs.underline].
  final Color? indicatorColor;

  /// Underline thickness of [VTabs.underline]; 2 when null.
  final double? indicatorHeight;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Label text style of every tab, merged over the default label style.
  ///
  /// The default is the theme's label medium style in the tab color, semibold
  /// on the selected tab. Only the fields this sets change, so setting a weight
  /// here also changes the selected tab unless [selectedTextStyle] sets one.
  final TextStyle? textStyle;

  /// Label text style of the selected tab, merged over [textStyle].
  final TextStyle? selectedTextStyle;

  /// Creates a copy with only the specified properties changed.
  VTabsStyle copyWith({
    Color? backgroundColor,
    Color? activeColor,
    Color? inactiveColor,
    Color? indicatorColor,
    double? indicatorHeight,
    EdgeInsets? padding,
    TextStyle? textStyle,
    TextStyle? selectedTextStyle,
  }) => VTabsStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    activeColor: activeColor ?? this.activeColor,
    inactiveColor: inactiveColor ?? this.inactiveColor,
    indicatorColor: indicatorColor ?? this.indicatorColor,
    indicatorHeight: indicatorHeight ?? this.indicatorHeight,
    padding: padding ?? this.padding,
    textStyle: textStyle ?? this.textStyle,
    selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VTabsStyle merge(VTabsStyle? other) {
    if (other == null) return this;
    return VTabsStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      activeColor: other.activeColor ?? activeColor,
      inactiveColor: other.inactiveColor ?? inactiveColor,
      indicatorColor: other.indicatorColor ?? indicatorColor,
      indicatorHeight: other.indicatorHeight ?? indicatorHeight,
      padding: other.padding ?? padding,
      textStyle: other.textStyle ?? textStyle,
      selectedTextStyle: other.selectedTextStyle ?? selectedTextStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VTabsStyle &&
        other.backgroundColor == backgroundColor &&
        other.activeColor == activeColor &&
        other.inactiveColor == inactiveColor &&
        other.indicatorColor == indicatorColor &&
        other.indicatorHeight == indicatorHeight &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.selectedTextStyle == selectedTextStyle;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    activeColor,
    inactiveColor,
    indicatorColor,
    indicatorHeight,
    padding,
    textStyle,
    selectedTextStyle,
  );
}
