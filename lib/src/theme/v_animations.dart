import 'package:flutter/widgets.dart';

import 'v_animations.generated.dart';

/// Durations and curves used by component animations.
///
/// Defines consistent animation values used throughout the app.
@immutable
class VAnimations {
  /// Creates animation tokens.
  const VAnimations({
    required this.instant,
    required this.micro,
    required this.fast,
    required this.normal,
    required this.slow,
    required this.slower,
    required this.verySlow,
    required this.extraSlow,
    required this.snackbar,
    required this.toast,
    required this.curveLinear,
    required this.curveEaseIn,
    required this.curveEaseOut,
    required this.curveSmooth,
    required this.curveDefault,
    required this.curveBouncy,
  });

  /// Interpolates between two animation systems (for transitions).
  VAnimations.lerp(VAnimations a, VAnimations b, double t)
    : instant = t < 0.5 ? a.instant : b.instant,
      micro = t < 0.5 ? a.micro : b.micro,
      fast = t < 0.5 ? a.fast : b.fast,
      normal = t < 0.5 ? a.normal : b.normal,
      slow = t < 0.5 ? a.slow : b.slow,
      slower = t < 0.5 ? a.slower : b.slower,
      verySlow = t < 0.5 ? a.verySlow : b.verySlow,
      extraSlow = t < 0.5 ? a.extraSlow : b.extraSlow,
      snackbar = t < 0.5 ? a.snackbar : b.snackbar,
      toast = t < 0.5 ? a.toast : b.toast,
      curveLinear = t < 0.5 ? a.curveLinear : b.curveLinear,
      curveEaseIn = t < 0.5 ? a.curveEaseIn : b.curveEaseIn,
      curveEaseOut = t < 0.5 ? a.curveEaseOut : b.curveEaseOut,
      curveSmooth = t < 0.5 ? a.curveSmooth : b.curveSmooth,
      curveDefault = t < 0.5 ? a.curveDefault : b.curveDefault,
      curveBouncy = t < 0.5 ? a.curveBouncy : b.curveBouncy;

  /// 0ms - Instant (toggle).
  final Duration instant;

  /// 75ms - Micro transition (opacity, tooltip).
  final Duration micro;

  /// 150ms - Fast transition (hover, focus).
  final Duration fast;

  /// 300ms - Default transition (page, modal).
  final Duration normal;

  /// 500ms - Slow transition (complex animations).
  final Duration slow;

  /// 700ms - Slower transition (complex page animations).
  final Duration slower;

  /// 1000ms - Very slow (loading, fade-in).
  final Duration verySlow;

  /// 1500ms - Extra slow (skeleton, progress).
  final Duration extraSlow;

  /// 4000ms - Snackbar display duration.
  final Duration snackbar;

  /// 5000ms - Toast display duration.
  final Duration toast;

  /// Linear curve - constant speed.
  final Curve curveLinear;

  /// Ease-in curve - acceleration.
  final Curve curveEaseIn;

  /// Ease-out curve - deceleration.
  final Curve curveEaseOut;

  /// Smooth curve (easeInOut) - breathing animation.
  final Curve curveSmooth;

  /// Default curve (easeOutCubic) - natural deceleration.
  final Curve curveDefault;

  /// Bouncy curve (elasticOut) - playful spring effect.
  ///
  /// Flutter-only: a compound curve not expressible via cubic-bezier.
  /// Used for button taps, card entrances, and app-specific feel.
  final Curve curveBouncy;

  /// Default animation values.
  ///
  /// Duration/Curve values sourced from DTCG tokens via [VAnimationsDefaults].
  /// [curveBouncy] is Flutter-only (not expressible in cubic-bezier).
  static final VAnimations defaults = VAnimations(
    instant: VAnimationsDefaults.defaults.instant,
    micro: VAnimationsDefaults.defaults.micro,
    fast: VAnimationsDefaults.defaults.fast,
    normal: VAnimationsDefaults.defaults.normal,
    slow: VAnimationsDefaults.defaults.slow,
    slower: VAnimationsDefaults.defaults.slower,
    verySlow: VAnimationsDefaults.defaults.verySlow,
    extraSlow: VAnimationsDefaults.defaults.extraSlow,
    snackbar: VAnimationsDefaults.defaults.snackbar,
    toast: VAnimationsDefaults.defaults.toast,
    curveLinear: VAnimationsDefaults.defaults.curveLinear,
    curveEaseIn: VAnimationsDefaults.defaults.curveEaseIn,
    curveEaseOut: VAnimationsDefaults.defaults.curveEaseOut,
    curveSmooth: VAnimationsDefaults.defaults.curveSmooth,
    curveDefault: VAnimationsDefaults.defaults.curveDefault,
    curveBouncy: Curves.elasticOut,
  );

  /// Creates a copy with only the specified properties changed.
  VAnimations copyWith({
    Duration? instant,
    Duration? micro,
    Duration? fast,
    Duration? normal,
    Duration? slow,
    Duration? slower,
    Duration? verySlow,
    Duration? extraSlow,
    Duration? snackbar,
    Duration? toast,
    Curve? curveLinear,
    Curve? curveEaseIn,
    Curve? curveEaseOut,
    Curve? curveSmooth,
    Curve? curveDefault,
    Curve? curveBouncy,
  }) => VAnimations(
    instant: instant ?? this.instant,
    micro: micro ?? this.micro,
    fast: fast ?? this.fast,
    normal: normal ?? this.normal,
    slow: slow ?? this.slow,
    slower: slower ?? this.slower,
    verySlow: verySlow ?? this.verySlow,
    extraSlow: extraSlow ?? this.extraSlow,
    snackbar: snackbar ?? this.snackbar,
    toast: toast ?? this.toast,
    curveLinear: curveLinear ?? this.curveLinear,
    curveEaseIn: curveEaseIn ?? this.curveEaseIn,
    curveEaseOut: curveEaseOut ?? this.curveEaseOut,
    curveSmooth: curveSmooth ?? this.curveSmooth,
    curveDefault: curveDefault ?? this.curveDefault,
    curveBouncy: curveBouncy ?? this.curveBouncy,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VAnimations &&
        other.instant == instant &&
        other.micro == micro &&
        other.fast == fast &&
        other.normal == normal &&
        other.slow == slow &&
        other.slower == slower &&
        other.verySlow == verySlow &&
        other.extraSlow == extraSlow &&
        other.snackbar == snackbar &&
        other.toast == toast &&
        other.curveLinear == curveLinear &&
        other.curveEaseIn == curveEaseIn &&
        other.curveEaseOut == curveEaseOut &&
        other.curveSmooth == curveSmooth &&
        other.curveDefault == curveDefault &&
        other.curveBouncy == curveBouncy;
  }

  @override
  int get hashCode => Object.hashAll([
    instant,
    micro,
    fast,
    normal,
    slow,
    slower,
    verySlow,
    extraSlow,
    snackbar,
    toast,
    curveLinear,
    curveEaseIn,
    curveEaseOut,
    curveSmooth,
    curveDefault,
    curveBouncy,
  ]);
}
