import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/l10n/volo_localizations.dart';
import 'package:volo_flutter_ui/src/l10n/volo_localizations_en.dart';
import 'v_theme.dart';
import 'v_theme_data.dart';

// CONSTRAINT: ImplicitlyAnimatedWidget requires forEachTween to register
// all animated properties. The framework calls this during didUpdateWidget
// to detect changes and create interpolation tweens automatically.
/// {@template v_animated_theme}
/// Animates a [VTheme] when its [data] changes.
///
/// Interpolates between theme data using [VThemeData.lerp] for
/// smooth transitions when theme changes.
///
/// ## Basic Usage:
///
/// Animated theme switching:
///
/// ```dart
/// AnimatedVTheme(
///   data: isDark ? VThemeData.dark() : VThemeData.light(),
///   duration: Duration(milliseconds: 300),
///   child: MyApp(),
/// )
/// ```
///
/// ## Custom Curve:
///
/// With easing curve:
///
/// ```dart
/// AnimatedVTheme(
///   data: themeData,
///   duration: Duration(milliseconds: 500),
///   curve: Curves.easeInOut,
///   child: MyApp(),
/// )
/// ```
///
/// See also:
///
/// - [VTheme], the static theme provider
/// - [VThemeData], complete theme data with lerp support
/// - [VThemeDataTween], the tween used for interpolation
/// {@endtemplate}
class AnimatedVTheme extends ImplicitlyAnimatedWidget {
  /// {@macro v_animated_theme}
  const AnimatedVTheme({
    required this.data,
    required this.child,
    super.key,
    super.duration = const Duration(milliseconds: 200),
    super.curve = Curves.linear,
    super.onEnd,
    this.localizations,
  });

  /// The theme data to animate towards.
  final VThemeData data;

  /// Strings for descendants; defaults to the enclosing theme's, else English.
  final VoloLocalizations? localizations;

  /// The widget subtree that receives the animated theme.
  final Widget child;

  @override
  AnimatedWidgetBaseState<AnimatedVTheme> createState() =>
      _AnimatedVThemeState();
}

class _AnimatedVThemeState extends AnimatedWidgetBaseState<AnimatedVTheme> {
  VThemeDataTween? _data;

  // CONSTRAINT: forEachTween must use dynamic cast because the framework's
  // TweenVisitor callback returns dynamic. The visitor pattern ensures only
  // changed properties create new Tween instances (the rest are reused).
  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data =
        visitor(
              _data,
              widget.data,
              (dynamic value) => VThemeDataTween(begin: value as VThemeData),
            )
            as VThemeDataTween?;
  }

  @override
  Widget build(BuildContext context) => VTheme(
    data: _data!.evaluate(animation),
    localizations:
        widget.localizations ??
        VoloLocalizations.maybeOf(context) ??
        const VoloLocalizationsEn(),
    child: widget.child,
  );
}

/// Tween that interpolates between two [VThemeData] values.
///
/// Uses [VThemeData.lerp] for smooth theme transitions.
///
/// ```dart
/// final tween = VThemeDataTween(
///   begin: VThemeData.light(),
///   end: VThemeData.dark(),
/// );
/// final midTheme = tween.lerp(0.5);
/// ```
class VThemeDataTween extends Tween<VThemeData> {
  /// Creates a [VThemeDataTween].
  VThemeDataTween({super.begin, super.end});

  @override
  VThemeData lerp(double t) => VThemeData.lerp(begin!, end!, t);
}
