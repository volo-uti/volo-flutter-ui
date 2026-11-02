import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/v_component_style.dart';

/// Style override for [VAutocomplete].
///
/// All properties are nullable — `null` means "use the theme default".
/// Supports cascade: theme override → instance override.
@immutable
class VAutocompleteStyle implements VComponentStyle {
  const VAutocompleteStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.focusBorderColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.dropdownBackgroundColor,
  });

  /// Background fill color.
  final Color? backgroundColor;

  /// Color of the typed text; wins over the color of [textStyle].
  ///
  /// The placeholder keeps the muted color. An instance style wins over the
  /// theme override.
  final Color? foregroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border color when focused.
  final Color? focusBorderColor;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Internal padding.
  final EdgeInsets? padding;

  /// Text style of the input, merged over the body type style at the size's font size.
  ///
  /// The placeholder uses it too, in the muted color. An instance style wins
  /// over the theme override.
  final TextStyle? textStyle;

  /// Background color of the suggestion panel; defaults to the popover color.
  ///
  /// It wins over the theme's `VPopoverStyle.backgroundColor`. An instance
  /// style wins over the theme override.
  final Color? dropdownBackgroundColor;

  /// Creates a copy with only the specified properties changed.
  VAutocompleteStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    Color? focusBorderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    TextStyle? textStyle,
    Color? dropdownBackgroundColor,
  }) => VAutocompleteStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    borderColor: borderColor ?? this.borderColor,
    focusBorderColor: focusBorderColor ?? this.focusBorderColor,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    textStyle: textStyle ?? this.textStyle,
    dropdownBackgroundColor:
        dropdownBackgroundColor ?? this.dropdownBackgroundColor,
  );

  /// Merges [other] on top of this style. Non-null values in [other] win.
  @override
  VAutocompleteStyle merge(VAutocompleteStyle? other) {
    if (other == null) return this;
    return VAutocompleteStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      borderColor: other.borderColor ?? borderColor,
      focusBorderColor: other.focusBorderColor ?? focusBorderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      textStyle: other.textStyle ?? textStyle,
      dropdownBackgroundColor:
          other.dropdownBackgroundColor ?? dropdownBackgroundColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VAutocompleteStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.focusBorderColor == focusBorderColor &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.textStyle == textStyle &&
        other.dropdownBackgroundColor == dropdownBackgroundColor;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderColor,
    focusBorderColor,
    borderRadius,
    padding,
    textStyle,
    dropdownBackgroundColor,
  );
}
