import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VAnimations', () {
    test('defaults returns default duration values', () {
      final animations = VAnimations.defaults;

      expect(animations.instant, Duration.zero);
      expect(animations.micro, const Duration(milliseconds: 75));
      expect(animations.fast, const Duration(milliseconds: 150));
      expect(animations.normal, const Duration(milliseconds: 300));
      expect(animations.slow, const Duration(milliseconds: 500));
      expect(animations.slower, const Duration(milliseconds: 700));
      expect(animations.verySlow, const Duration(milliseconds: 1000));
      expect(animations.extraSlow, const Duration(milliseconds: 1500));
      expect(animations.snackbar, const Duration(milliseconds: 4000));
      expect(animations.toast, const Duration(milliseconds: 5000));
    });

    test('curves are set correctly', () {
      final animations = VAnimations.defaults;

      expect(animations.curveLinear, const Cubic(0, 0, 1, 1));
      expect(animations.curveEaseIn, const Cubic(0.42, 0, 1, 1));
      expect(animations.curveEaseOut, const Cubic(0, 0, 0.58, 1));
      expect(animations.curveSmooth, const Cubic(0.42, 0, 0.58, 1));
      expect(animations.curveDefault, const Cubic(0.33, 1, 0.68, 1));
      expect(animations.curveBouncy, Curves.elasticOut);
    });

    test('copyWith() changes only specified properties', () {
      final original = VAnimations.defaults;
      final modified = original.copyWith(
        fast: const Duration(milliseconds: 200),
        micro: const Duration(milliseconds: 100),
        curveDefault: const Cubic(0.25, 0.1, 0.25, 1),
      );

      expect(modified.fast, const Duration(milliseconds: 200));
      expect(modified.micro, const Duration(milliseconds: 100));
      expect(modified.curveDefault, const Cubic(0.25, 0.1, 0.25, 1));
      // unchanged
      expect(modified.instant, original.instant);
      expect(modified.normal, original.normal);
      expect(modified.slow, original.slow);
      expect(modified.slower, original.slower);
      expect(modified.curveLinear, original.curveLinear);
      expect(modified.curveEaseIn, original.curveEaseIn);
      expect(modified.curveEaseOut, original.curveEaseOut);
      expect(modified.curveSmooth, original.curveSmooth);
    });

    test('lerp() interpolates between two animations', () {
      final a = VAnimations.defaults;
      final b = a.copyWith(
        fast: const Duration(milliseconds: 250),
        slower: const Duration(milliseconds: 900),
      );

      final beforeMid = VAnimations.lerp(a, b, 0.3);
      expect(beforeMid.fast, a.fast);
      expect(beforeMid.slower, a.slower);

      final afterMid = VAnimations.lerp(a, b, 0.7);
      expect(afterMid.fast, b.fast);
      expect(afterMid.slower, b.slower);
    });

    test('identical animations are equal', () {
      final a = VAnimations.defaults;
      final b = VAnimations.defaults;

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('different animations are not equal', () {
      final a = VAnimations.defaults;
      final b = a.copyWith(micro: const Duration(milliseconds: 50));

      expect(a, isNot(b));
    });
  });
}
