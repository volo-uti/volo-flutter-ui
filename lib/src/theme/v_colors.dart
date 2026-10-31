import 'package:flutter/widgets.dart';

import 'v_colors.generated.dart';

/// Semantic color roles for one brightness.
///
/// Defines semantic colors used throughout the app.
/// Each color is categorized by its purpose.
@immutable
class VColors {
  /// Creates a color set.
  const VColors({
    required this.background,
    required this.foreground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.tertiary,
    required this.tertiaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.success,
    required this.successForeground,
    required this.warning,
    required this.warningForeground,
    required this.error,
    required this.errorForeground,
    required this.info,
    required this.infoForeground,
    required this.border,
    required this.input,
    required this.ring,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.disabled,
    required this.disabledForeground,
    required this.scrim,
  });

  /// Interpolates between two color systems (for animations).
  VColors.lerp(VColors a, VColors b, double t)
    : background = Color.lerp(a.background, b.background, t)!,
      foreground = Color.lerp(a.foreground, b.foreground, t)!,
      primary = Color.lerp(a.primary, b.primary, t)!,
      primaryForeground = Color.lerp(
        a.primaryForeground,
        b.primaryForeground,
        t,
      )!,
      secondary = Color.lerp(a.secondary, b.secondary, t)!,
      secondaryForeground = Color.lerp(
        a.secondaryForeground,
        b.secondaryForeground,
        t,
      )!,
      tertiary = Color.lerp(a.tertiary, b.tertiary, t)!,
      tertiaryForeground = Color.lerp(
        a.tertiaryForeground,
        b.tertiaryForeground,
        t,
      )!,
      muted = Color.lerp(a.muted, b.muted, t)!,
      mutedForeground = Color.lerp(a.mutedForeground, b.mutedForeground, t)!,
      accent = Color.lerp(a.accent, b.accent, t)!,
      accentForeground = Color.lerp(a.accentForeground, b.accentForeground, t)!,
      destructive = Color.lerp(a.destructive, b.destructive, t)!,
      destructiveForeground = Color.lerp(
        a.destructiveForeground,
        b.destructiveForeground,
        t,
      )!,
      success = Color.lerp(a.success, b.success, t)!,
      successForeground = Color.lerp(
        a.successForeground,
        b.successForeground,
        t,
      )!,
      warning = Color.lerp(a.warning, b.warning, t)!,
      warningForeground = Color.lerp(
        a.warningForeground,
        b.warningForeground,
        t,
      )!,
      error = Color.lerp(a.error, b.error, t)!,
      errorForeground = Color.lerp(a.errorForeground, b.errorForeground, t)!,
      info = Color.lerp(a.info, b.info, t)!,
      infoForeground = Color.lerp(a.infoForeground, b.infoForeground, t)!,
      border = Color.lerp(a.border, b.border, t)!,
      input = Color.lerp(a.input, b.input, t)!,
      ring = Color.lerp(a.ring, b.ring, t)!,
      card = Color.lerp(a.card, b.card, t)!,
      cardForeground = Color.lerp(a.cardForeground, b.cardForeground, t)!,
      popover = Color.lerp(a.popover, b.popover, t)!,
      popoverForeground = Color.lerp(
        a.popoverForeground,
        b.popoverForeground,
        t,
      )!,
      disabled = Color.lerp(a.disabled, b.disabled, t)!,
      disabledForeground = Color.lerp(
        a.disabledForeground,
        b.disabledForeground,
        t,
      )!,
      scrim = Color.lerp(a.scrim, b.scrim, t)!;

  /// Creates [VColors] from generated [VColorsDefaults].
  VColors._fromDefaults(VColorsDefaults d)
    : background = d.background,
      foreground = d.foreground,
      primary = d.primary,
      primaryForeground = d.primaryForeground,
      secondary = d.secondary,
      secondaryForeground = d.secondaryForeground,
      tertiary = d.tertiary,
      tertiaryForeground = d.tertiaryForeground,
      muted = d.muted,
      mutedForeground = d.mutedForeground,
      accent = d.accent,
      accentForeground = d.accentForeground,
      destructive = d.destructive,
      destructiveForeground = d.destructiveForeground,
      success = d.success,
      successForeground = d.successForeground,
      warning = d.warning,
      warningForeground = d.warningForeground,
      error = d.error,
      errorForeground = d.errorForeground,
      info = d.info,
      infoForeground = d.infoForeground,
      border = d.border,
      input = d.input,
      ring = d.ring,
      card = d.card,
      cardForeground = d.cardForeground,
      popover = d.popover,
      popoverForeground = d.popoverForeground,
      disabled = d.disabled,
      disabledForeground = d.disabledForeground,
      scrim = d.scrim;

  // ===== Background & Foreground =====

  /// Page background color.
  final Color background;

  /// Default text color.
  final Color foreground;

  // ===== Primary =====

  /// Primary action color (main CTA).
  final Color primary;

  /// Text color on primary.
  final Color primaryForeground;

  // ===== Secondary =====

  /// Secondary action color.
  final Color secondary;

  /// Text color on secondary.
  final Color secondaryForeground;

  // ===== Tertiary =====

  /// Tertiary action color.
  final Color tertiary;

  /// Text color on tertiary.
  final Color tertiaryForeground;

  // ===== Muted =====

  /// Muted area color (background, placeholder).
  final Color muted;

  /// Muted text color (hint, supplementary text).
  final Color mutedForeground;

  // ===== Accent =====

  /// Accent color (hover, selected state).
  final Color accent;

  /// Text color on accent.
  final Color accentForeground;

  // ===== Destructive =====

  /// Destructive action color (delete, warning).
  final Color destructive;

  /// Text color on destructive.
  final Color destructiveForeground;

  // ===== Status Colors =====

  /// Success status color.
  final Color success;

  /// Text color on success.
  final Color successForeground;

  /// Warning status color.
  final Color warning;

  /// Text color on warning.
  final Color warningForeground;

  /// Error status color.
  final Color error;

  /// Text color on error.
  final Color errorForeground;

  /// Info status color.
  final Color info;

  /// Text color on info.
  final Color infoForeground;

  // ===== UI Colors =====

  /// Default border color.
  final Color border;

  /// Input field border color.
  final Color input;

  /// Focus ring color.
  final Color ring;

  // ===== Surface Colors =====

  /// Card background color.
  final Color card;

  /// Card text color.
  final Color cardForeground;

  /// Popover background color.
  final Color popover;

  /// Popover text color.
  final Color popoverForeground;

  // ===== State Colors =====

  /// Disabled element color.
  final Color disabled;

  /// Text color on disabled.
  final Color disabledForeground;

  /// Modal/dialog backdrop overlay color.
  final Color scrim;

  // ===== Constants =====

  /// Fully transparent color.
  ///
  /// Use instead of `Color(0x00000000)` for consistency and token compliance.
  static const Color transparent = Color(0x00000000);

  // ===== Default Themes =====

  /// Light mode colors.
  ///
  /// Values sourced from DTCG tokens via [VColorsDefaults].
  static final VColors light = VColors._fromDefaults(VColorsDefaults.zincLight);

  /// Dark mode colors.
  ///
  /// Values sourced from DTCG tokens via [VColorsDefaults].
  static final VColors dark = VColors._fromDefaults(VColorsDefaults.zincDark);

  /// Creates a copy with only the specified properties changed.
  VColors copyWith({
    Color? background,
    Color? foreground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? tertiary,
    Color? tertiaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? destructiveForeground,
    Color? success,
    Color? successForeground,
    Color? warning,
    Color? warningForeground,
    Color? error,
    Color? errorForeground,
    Color? info,
    Color? infoForeground,
    Color? border,
    Color? input,
    Color? ring,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? disabled,
    Color? disabledForeground,
    Color? scrim,
  }) => VColors(
    background: background ?? this.background,
    foreground: foreground ?? this.foreground,
    primary: primary ?? this.primary,
    primaryForeground: primaryForeground ?? this.primaryForeground,
    secondary: secondary ?? this.secondary,
    secondaryForeground: secondaryForeground ?? this.secondaryForeground,
    tertiary: tertiary ?? this.tertiary,
    tertiaryForeground: tertiaryForeground ?? this.tertiaryForeground,
    muted: muted ?? this.muted,
    mutedForeground: mutedForeground ?? this.mutedForeground,
    accent: accent ?? this.accent,
    accentForeground: accentForeground ?? this.accentForeground,
    destructive: destructive ?? this.destructive,
    destructiveForeground: destructiveForeground ?? this.destructiveForeground,
    success: success ?? this.success,
    successForeground: successForeground ?? this.successForeground,
    warning: warning ?? this.warning,
    warningForeground: warningForeground ?? this.warningForeground,
    error: error ?? this.error,
    errorForeground: errorForeground ?? this.errorForeground,
    info: info ?? this.info,
    infoForeground: infoForeground ?? this.infoForeground,
    border: border ?? this.border,
    input: input ?? this.input,
    ring: ring ?? this.ring,
    card: card ?? this.card,
    cardForeground: cardForeground ?? this.cardForeground,
    popover: popover ?? this.popover,
    popoverForeground: popoverForeground ?? this.popoverForeground,
    disabled: disabled ?? this.disabled,
    disabledForeground: disabledForeground ?? this.disabledForeground,
    scrim: scrim ?? this.scrim,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VColors &&
        other.background == background &&
        other.foreground == foreground &&
        other.primary == primary &&
        other.primaryForeground == primaryForeground &&
        other.secondary == secondary &&
        other.secondaryForeground == secondaryForeground &&
        other.tertiary == tertiary &&
        other.tertiaryForeground == tertiaryForeground &&
        other.muted == muted &&
        other.mutedForeground == mutedForeground &&
        other.accent == accent &&
        other.accentForeground == accentForeground &&
        other.destructive == destructive &&
        other.destructiveForeground == destructiveForeground &&
        other.success == success &&
        other.successForeground == successForeground &&
        other.warning == warning &&
        other.warningForeground == warningForeground &&
        other.error == error &&
        other.errorForeground == errorForeground &&
        other.info == info &&
        other.infoForeground == infoForeground &&
        other.border == border &&
        other.input == input &&
        other.ring == ring &&
        other.card == card &&
        other.cardForeground == cardForeground &&
        other.popover == popover &&
        other.popoverForeground == popoverForeground &&
        other.disabled == disabled &&
        other.disabledForeground == disabledForeground &&
        other.scrim == scrim;
  }

  @override
  int get hashCode => Object.hashAll([
    background,
    foreground,
    primary,
    primaryForeground,
    secondary,
    secondaryForeground,
    tertiary,
    tertiaryForeground,
    muted,
    mutedForeground,
    accent,
    accentForeground,
    destructive,
    destructiveForeground,
    success,
    successForeground,
    warning,
    warningForeground,
    error,
    errorForeground,
    info,
    infoForeground,
    border,
    input,
    ring,
    card,
    cardForeground,
    popover,
    popoverForeground,
    disabled,
    disabledForeground,
    scrim,
  ]);
}
