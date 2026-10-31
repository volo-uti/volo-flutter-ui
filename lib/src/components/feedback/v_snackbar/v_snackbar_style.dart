import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VSnackbar].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VSnackbarStyle implements VComponentStyle {
  const VSnackbarStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.actionColor,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Text foreground color.
  final Color? foregroundColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Text style.
  final TextStyle? textStyle;

  /// Action button color.
  final Color? actionColor;

  /// Creates a copy with only the specified properties changed.
  VSnackbarStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    TextStyle? textStyle,
    Color? actionColor,
  }) => VSnackbarStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    textStyle: textStyle ?? this.textStyle,
    actionColor: actionColor ?? this.actionColor,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VSnackbarStyle merge(VSnackbarStyle? other) {
    if (other == null) return this;
    return VSnackbarStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      textStyle: other.textStyle ?? textStyle,
      actionColor: other.actionColor ?? actionColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VSnackbarStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.actionColor == actionColor;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderRadius,
    padding,
    textStyle,
    actionColor,
  );
}
