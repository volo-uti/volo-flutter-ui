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
    required TextStyle displayLarge,
    required TextStyle displayMedium,
    required TextStyle displaySmall,
    required TextStyle headlineLarge,
    required TextStyle headlineMedium,
    required TextStyle headlineSmall,
    required TextStyle titleLarge,
    required TextStyle titleMedium,
    required TextStyle titleSmall,
    required TextStyle bodyLarge,
    required TextStyle bodyMedium,
    required TextStyle bodySmall,
    required TextStyle labelLarge,
    required TextStyle labelMedium,
    required TextStyle labelSmall,
    this.fontFamily,
    this.fontFamilyMono,
  }) : _displayLarge = displayLarge,
       _displayMedium = displayMedium,
       _displaySmall = displaySmall,
       _headlineLarge = headlineLarge,
       _headlineMedium = headlineMedium,
       _headlineSmall = headlineSmall,
       _titleLarge = titleLarge,
       _titleMedium = titleMedium,
       _titleSmall = titleSmall,
       _bodyLarge = bodyLarge,
       _bodyMedium = bodyMedium,
       _bodySmall = bodySmall,
       _labelLarge = labelLarge,
       _labelMedium = labelMedium,
       _labelSmall = labelSmall;

  /// Interpolates between two typographies (for animations).
  VTypography.lerp(VTypography a, VTypography b, double t)
    : fontFamily = t < 0.5 ? a.fontFamily : b.fontFamily,
      fontFamilyMono = t < 0.5 ? a.fontFamilyMono : b.fontFamilyMono,
      _displayLarge = TextStyle.lerp(a._displayLarge, b._displayLarge, t)!,
      _displayMedium = TextStyle.lerp(a._displayMedium, b._displayMedium, t)!,
      _displaySmall = TextStyle.lerp(a._displaySmall, b._displaySmall, t)!,
      _headlineLarge = TextStyle.lerp(a._headlineLarge, b._headlineLarge, t)!,
      _headlineMedium = TextStyle.lerp(
        a._headlineMedium,
        b._headlineMedium,
        t,
      )!,
      _headlineSmall = TextStyle.lerp(a._headlineSmall, b._headlineSmall, t)!,
      _titleLarge = TextStyle.lerp(a._titleLarge, b._titleLarge, t)!,
      _titleMedium = TextStyle.lerp(a._titleMedium, b._titleMedium, t)!,
      _titleSmall = TextStyle.lerp(a._titleSmall, b._titleSmall, t)!,
      _bodyLarge = TextStyle.lerp(a._bodyLarge, b._bodyLarge, t)!,
      _bodyMedium = TextStyle.lerp(a._bodyMedium, b._bodyMedium, t)!,
      _bodySmall = TextStyle.lerp(a._bodySmall, b._bodySmall, t)!,
      _labelLarge = TextStyle.lerp(a._labelLarge, b._labelLarge, t)!,
      _labelMedium = TextStyle.lerp(a._labelMedium, b._labelMedium, t)!,
      _labelSmall = TextStyle.lerp(a._labelSmall, b._labelSmall, t)!;

  /// Default font family.
  ///
  /// Every text style of this typography and every text under the theme that
  /// names no family of its own uses it. When `null`, Flutter uses the
  /// platform's default system font.
  final String? fontFamily;

  /// Monospace font family (for code and numbers).
  ///
  /// When `null`, Flutter uses the platform's default monospace font.
  final String? fontFamilyMono;

  // ===== Display (Hero Text) =====

  /// Display large (57px, Bold).
  TextStyle get displayLarge => _withFamily(_displayLarge);

  final TextStyle _displayLarge;

  /// Display medium (45px, Bold).
  TextStyle get displayMedium => _withFamily(_displayMedium);

  final TextStyle _displayMedium;

  /// Display small (36px, Bold).
  TextStyle get displaySmall => _withFamily(_displaySmall);

  final TextStyle _displaySmall;

  // ===== Headline (Headings) =====

  /// Headline large (32px, Bold).
  TextStyle get headlineLarge => _withFamily(_headlineLarge);

  final TextStyle _headlineLarge;

  /// Headline medium (28px, Bold) - page title.
  TextStyle get headlineMedium => _withFamily(_headlineMedium);

  final TextStyle _headlineMedium;

  /// Headline small (24px, SemiBold) - section title.
  TextStyle get headlineSmall => _withFamily(_headlineSmall);

  final TextStyle _headlineSmall;

  // ===== Title (Subtitles) =====

  /// Title large (22px, SemiBold) - card title.
  TextStyle get titleLarge => _withFamily(_titleLarge);

  final TextStyle _titleLarge;

  /// Title medium (16px, SemiBold) - subtitle.
  TextStyle get titleMedium => _withFamily(_titleMedium);

  final TextStyle _titleMedium;

  /// Title small (14px, SemiBold) - label.
  TextStyle get titleSmall => _withFamily(_titleSmall);

  final TextStyle _titleSmall;

  // ===== Body =====

  /// Body large (16px, Regular).
  TextStyle get bodyLarge => _withFamily(_bodyLarge);

  final TextStyle _bodyLarge;

  /// Body medium (14px, Regular) - default text.
  TextStyle get bodyMedium => _withFamily(_bodyMedium);

  final TextStyle _bodyMedium;

  /// Body small (12px, Regular) - secondary text.
  TextStyle get bodySmall => _withFamily(_bodySmall);

  final TextStyle _bodySmall;

  // ===== Label =====

  /// Label large (14px, Medium) - button text.
  TextStyle get labelLarge => _withFamily(_labelLarge);

  final TextStyle _labelLarge;

  /// Label medium (12px, Medium) - badge text.
  TextStyle get labelMedium => _withFamily(_labelMedium);

  final TextStyle _labelMedium;

  /// Label small (11px, Medium) - caption.
  TextStyle get labelSmall => _withFamily(_labelSmall);

  final TextStyle _labelSmall;

  // WHY: the text styles carry the theme font, so widgets that hand a style
  // straight to EditableText or replace DefaultTextStyle still draw with it.
  // A style that names its own family keeps it.
  TextStyle _withFamily(TextStyle style) {
    final family = fontFamily;
    if (family == null || style.fontFamily != null) return style;
    return style.copyWith(fontFamily: family);
  }

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
    displayLarge: displayLarge ?? _displayLarge,
    displayMedium: displayMedium ?? _displayMedium,
    displaySmall: displaySmall ?? _displaySmall,
    headlineLarge: headlineLarge ?? _headlineLarge,
    headlineMedium: headlineMedium ?? _headlineMedium,
    headlineSmall: headlineSmall ?? _headlineSmall,
    titleLarge: titleLarge ?? _titleLarge,
    titleMedium: titleMedium ?? _titleMedium,
    titleSmall: titleSmall ?? _titleSmall,
    bodyLarge: bodyLarge ?? _bodyLarge,
    bodyMedium: bodyMedium ?? _bodyMedium,
    bodySmall: bodySmall ?? _bodySmall,
    labelLarge: labelLarge ?? _labelLarge,
    labelMedium: labelMedium ?? _labelMedium,
    labelSmall: labelSmall ?? _labelSmall,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VTypography &&
        other.fontFamily == fontFamily &&
        other.fontFamilyMono == fontFamilyMono &&
        other._displayLarge == _displayLarge &&
        other._displayMedium == _displayMedium &&
        other._displaySmall == _displaySmall &&
        other._headlineLarge == _headlineLarge &&
        other._headlineMedium == _headlineMedium &&
        other._headlineSmall == _headlineSmall &&
        other._titleLarge == _titleLarge &&
        other._titleMedium == _titleMedium &&
        other._titleSmall == _titleSmall &&
        other._bodyLarge == _bodyLarge &&
        other._bodyMedium == _bodyMedium &&
        other._bodySmall == _bodySmall &&
        other._labelLarge == _labelLarge &&
        other._labelMedium == _labelMedium &&
        other._labelSmall == _labelSmall;
  }

  @override
  int get hashCode => Object.hashAll([
    fontFamily,
    fontFamilyMono,
    _displayLarge,
    _displayMedium,
    _displaySmall,
    _headlineLarge,
    _headlineMedium,
    _headlineSmall,
    _titleLarge,
    _titleMedium,
    _titleSmall,
    _bodyLarge,
    _bodyMedium,
    _bodySmall,
    _labelLarge,
    _labelMedium,
    _labelSmall,
  ]);
}
