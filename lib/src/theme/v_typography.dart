import 'package:flutter/widgets.dart';

import 'v_typography.generated.dart';

/// Font families and the Material 3 text style scale.
///
/// Defines text styles used throughout the app.
/// Based on the Material Design 3 type scale.
@immutable
class VTypography {
  /// Creates typography tokens.
  const VTypography({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    this.fontFamily,
    this.fontFamilyMono,
  });

  /// Interpolates between two typographies (for animations).
  VTypography.lerp(VTypography a, VTypography b, double t)
    : fontFamily = t < 0.5 ? a.fontFamily : b.fontFamily,
      fontFamilyMono = t < 0.5 ? a.fontFamilyMono : b.fontFamilyMono,
      displayLarge = TextStyle.lerp(a.displayLarge, b.displayLarge, t)!,
      displayMedium = TextStyle.lerp(a.displayMedium, b.displayMedium, t)!,
      displaySmall = TextStyle.lerp(a.displaySmall, b.displaySmall, t)!,
      headlineLarge = TextStyle.lerp(a.headlineLarge, b.headlineLarge, t)!,
      headlineMedium = TextStyle.lerp(a.headlineMedium, b.headlineMedium, t)!,
      headlineSmall = TextStyle.lerp(a.headlineSmall, b.headlineSmall, t)!,
      titleLarge = TextStyle.lerp(a.titleLarge, b.titleLarge, t)!,
      titleMedium = TextStyle.lerp(a.titleMedium, b.titleMedium, t)!,
      titleSmall = TextStyle.lerp(a.titleSmall, b.titleSmall, t)!,
      bodyLarge = TextStyle.lerp(a.bodyLarge, b.bodyLarge, t)!,
      bodyMedium = TextStyle.lerp(a.bodyMedium, b.bodyMedium, t)!,
      bodySmall = TextStyle.lerp(a.bodySmall, b.bodySmall, t)!,
      labelLarge = TextStyle.lerp(a.labelLarge, b.labelLarge, t)!,
      labelMedium = TextStyle.lerp(a.labelMedium, b.labelMedium, t)!,
      labelSmall = TextStyle.lerp(a.labelSmall, b.labelSmall, t)!;

  /// Default font family.
  ///
  /// When `null`, Flutter uses the platform's default system font.
  final String? fontFamily;

  /// Monospace font family (for code and numbers).
  ///
  /// When `null`, Flutter uses the platform's default monospace font.
  final String? fontFamilyMono;

  // ===== Display (Hero Text) =====

  /// Display large (57px, Bold).
  final TextStyle displayLarge;

  /// Display medium (45px, Bold).
  final TextStyle displayMedium;

  /// Display small (36px, Bold).
  final TextStyle displaySmall;

  // ===== Headline (Headings) =====

  /// Headline large (32px, Bold).
  final TextStyle headlineLarge;

  /// Headline medium (28px, Bold) - page title.
  final TextStyle headlineMedium;

  /// Headline small (24px, SemiBold) - section title.
  final TextStyle headlineSmall;

  // ===== Title (Subtitles) =====

  /// Title large (22px, SemiBold) - card title.
  final TextStyle titleLarge;

  /// Title medium (16px, SemiBold) - subtitle.
  final TextStyle titleMedium;

  /// Title small (14px, SemiBold) - label.
  final TextStyle titleSmall;

  // ===== Body =====

  /// Body large (16px, Regular).
  final TextStyle bodyLarge;

  /// Body medium (14px, Regular) - default text.
  final TextStyle bodyMedium;

  /// Body small (12px, Regular) - secondary text.
  final TextStyle bodySmall;

  // ===== Label =====

  /// Label large (14px, Medium) - button text.
  final TextStyle labelLarge;

  /// Label medium (12px, Medium) - badge text.
  final TextStyle labelMedium;

  /// Label small (11px, Medium) - caption.
  final TextStyle labelSmall;

  /// Default typography values.
  ///
  /// [fontFamily] and [fontFamilyMono] are null (platform default system font).
  /// TextStyle values are sourced from DTCG tokens via [VTypographyDefaults].
  static const VTypography defaults = VTypography(
    displayLarge: VTypographyDefaults.displayLarge,
    displayMedium: VTypographyDefaults.displayMedium,
    displaySmall: VTypographyDefaults.displaySmall,
    headlineLarge: VTypographyDefaults.headlineLarge,
    headlineMedium: VTypographyDefaults.headlineMedium,
    headlineSmall: VTypographyDefaults.headlineSmall,
    titleLarge: VTypographyDefaults.titleLarge,
    titleMedium: VTypographyDefaults.titleMedium,
    titleSmall: VTypographyDefaults.titleSmall,
    bodyLarge: VTypographyDefaults.bodyLarge,
    bodyMedium: VTypographyDefaults.bodyMedium,
    bodySmall: VTypographyDefaults.bodySmall,
    labelLarge: VTypographyDefaults.labelLarge,
    labelMedium: VTypographyDefaults.labelMedium,
    labelSmall: VTypographyDefaults.labelSmall,
  );

  /// Creates a copy with only the specified properties changed.
  VTypography copyWith({
    String? fontFamily,
    String? fontFamilyMono,
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
  }) => VTypography(
    fontFamily: fontFamily ?? this.fontFamily,
    fontFamilyMono: fontFamilyMono ?? this.fontFamilyMono,
    displayLarge: displayLarge ?? this.displayLarge,
    displayMedium: displayMedium ?? this.displayMedium,
    displaySmall: displaySmall ?? this.displaySmall,
    headlineLarge: headlineLarge ?? this.headlineLarge,
    headlineMedium: headlineMedium ?? this.headlineMedium,
    headlineSmall: headlineSmall ?? this.headlineSmall,
    titleLarge: titleLarge ?? this.titleLarge,
    titleMedium: titleMedium ?? this.titleMedium,
    titleSmall: titleSmall ?? this.titleSmall,
    bodyLarge: bodyLarge ?? this.bodyLarge,
    bodyMedium: bodyMedium ?? this.bodyMedium,
    bodySmall: bodySmall ?? this.bodySmall,
    labelLarge: labelLarge ?? this.labelLarge,
    labelMedium: labelMedium ?? this.labelMedium,
    labelSmall: labelSmall ?? this.labelSmall,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VTypography &&
        other.fontFamily == fontFamily &&
        other.fontFamilyMono == fontFamilyMono &&
        other.displayLarge == displayLarge &&
        other.displayMedium == displayMedium &&
        other.displaySmall == displaySmall &&
        other.headlineLarge == headlineLarge &&
        other.headlineMedium == headlineMedium &&
        other.headlineSmall == headlineSmall &&
        other.titleLarge == titleLarge &&
        other.titleMedium == titleMedium &&
        other.titleSmall == titleSmall &&
        other.bodyLarge == bodyLarge &&
        other.bodyMedium == bodyMedium &&
        other.bodySmall == bodySmall &&
        other.labelLarge == labelLarge &&
        other.labelMedium == labelMedium &&
        other.labelSmall == labelSmall;
  }

  @override
  int get hashCode => Object.hashAll([
    fontFamily,
    fontFamilyMono,
    displayLarge,
    displayMedium,
    displaySmall,
    headlineLarge,
    headlineMedium,
    headlineSmall,
    titleLarge,
    titleMedium,
    titleSmall,
    bodyLarge,
    bodyMedium,
    bodySmall,
    labelLarge,
    labelMedium,
    labelSmall,
  ]);
}
