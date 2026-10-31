import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VTable].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VTableStyle implements VComponentStyle {
  const VTableStyle({
    this.headerBackgroundColor,
    this.headerForegroundColor,
    this.rowBackgroundColor,
    this.borderColor,
    this.cellPadding,
    this.headerTextStyle,
  });

  /// Header row background color.
  final Color? headerBackgroundColor;

  /// Header row foreground color.
  final Color? headerForegroundColor;

  /// Data row background color.
  final Color? rowBackgroundColor;

  /// Border color.
  final Color? borderColor;

  /// Cell internal padding.
  final EdgeInsets? cellPadding;

  /// Header text style.
  final TextStyle? headerTextStyle;

  /// Creates a copy with only the specified properties changed.
  VTableStyle copyWith({
    Color? headerBackgroundColor,
    Color? headerForegroundColor,
    Color? rowBackgroundColor,
    Color? borderColor,
    EdgeInsets? cellPadding,
    TextStyle? headerTextStyle,
  }) => VTableStyle(
    headerBackgroundColor: headerBackgroundColor ?? this.headerBackgroundColor,
    headerForegroundColor: headerForegroundColor ?? this.headerForegroundColor,
    rowBackgroundColor: rowBackgroundColor ?? this.rowBackgroundColor,
    borderColor: borderColor ?? this.borderColor,
    cellPadding: cellPadding ?? this.cellPadding,
    headerTextStyle: headerTextStyle ?? this.headerTextStyle,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VTableStyle merge(VTableStyle? other) {
    if (other == null) return this;
    return VTableStyle(
      headerBackgroundColor:
          other.headerBackgroundColor ?? headerBackgroundColor,
      headerForegroundColor:
          other.headerForegroundColor ?? headerForegroundColor,
      rowBackgroundColor: other.rowBackgroundColor ?? rowBackgroundColor,
      borderColor: other.borderColor ?? borderColor,
      cellPadding: other.cellPadding ?? cellPadding,
      headerTextStyle: other.headerTextStyle ?? headerTextStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VTableStyle &&
        other.headerBackgroundColor == headerBackgroundColor &&
        other.headerForegroundColor == headerForegroundColor &&
        other.rowBackgroundColor == rowBackgroundColor &&
        other.borderColor == borderColor &&
        other.cellPadding == cellPadding &&
        other.headerTextStyle == headerTextStyle;
  }

  @override
  int get hashCode => Object.hash(
    headerBackgroundColor,
    headerForegroundColor,
    rowBackgroundColor,
    borderColor,
    cellPadding,
    headerTextStyle,
  );
}
