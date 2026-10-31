import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VColors', () {
    test('light has light colors', () {
      final colors = VColors.light;

      expect(colors.background, const Color(0xFFFAFAFA));
      expect(colors.foreground, const Color(0xFF18181B));
      expect(colors.primary, const Color(0xFF5B5EF0));
      expect(colors.primaryForeground, const Color(0xFFFFFFFF));
    });

    test('dark has dark colors', () {
      final colors = VColors.dark;

      expect(colors.background, const Color(0xFF0F0F10));
      expect(colors.foreground, const Color(0xFFFAFAFA));
      expect(colors.primary, const Color(0xFF818CF8));
      expect(colors.primaryForeground, const Color(0xFF1E1B4B));
    });

    test('copyWith() changes only some properties', () {
      final original = VColors.light;
      final modified = original.copyWith(background: const Color(0xFF000000));

      expect(modified.background, const Color(0xFF000000));
      expect(modified.foreground, original.foreground);
    });

    test('lerp() interpolates between two colors', () {
      final mid = VColors.lerp(VColors.light, VColors.dark, 0.5);

      expect(mid.background, isNotNull);
      expect(mid.foreground, isNotNull);
    });

    test('identical colors are equal', () {
      final a = VColors.light;
      final b = VColors.light;

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('different colors are not equal', () {
      final light = VColors.light;
      final dark = VColors.dark;

      expect(light, isNot(dark));
    });
  });

  group('VColors contrast (WCAG AA, 4.5:1 for text)', () {
    double ratio(Color a, Color b) {
      final la = a.computeLuminance();
      final lb = b.computeLuminance();
      final lighter = la > lb ? la : lb;
      final darker = la > lb ? lb : la;
      return (lighter + 0.05) / (darker + 0.05);
    }

    // Every foreground/background pair that components draw text with.
    // Excluded on purpose: disabledForeground on disabled (disabled controls
    // are exempt from WCAG 1.4.3) and warning as a text color on a surface
    // (warning is only used as a fill or an icon color).
    final pairs = <String, (Color Function(VColors), Color Function(VColors))>{
      'primaryForeground on primary': (
        (c) => c.primaryForeground,
        (c) => c.primary,
      ),
      'secondaryForeground on secondary': (
        (c) => c.secondaryForeground,
        (c) => c.secondary,
      ),
      'tertiaryForeground on tertiary': (
        (c) => c.tertiaryForeground,
        (c) => c.tertiary,
      ),
      'accentForeground on accent': (
        (c) => c.accentForeground,
        (c) => c.accent,
      ),
      'destructiveForeground on destructive': (
        (c) => c.destructiveForeground,
        (c) => c.destructive,
      ),
      'successForeground on success': (
        (c) => c.successForeground,
        (c) => c.success,
      ),
      'warningForeground on warning': (
        (c) => c.warningForeground,
        (c) => c.warning,
      ),
      'errorForeground on error': ((c) => c.errorForeground, (c) => c.error),
      'infoForeground on info': ((c) => c.infoForeground, (c) => c.info),
      'foreground on background': ((c) => c.foreground, (c) => c.background),
      'foreground on muted': ((c) => c.foreground, (c) => c.muted),
      'cardForeground on card': ((c) => c.cardForeground, (c) => c.card),
      'popoverForeground on popover': (
        (c) => c.popoverForeground,
        (c) => c.popover,
      ),
      'mutedForeground on background': (
        (c) => c.mutedForeground,
        (c) => c.background,
      ),
      'mutedForeground on card': ((c) => c.mutedForeground, (c) => c.card),
      'mutedForeground on popover': (
        (c) => c.mutedForeground,
        (c) => c.popover,
      ),
      'mutedForeground on muted': ((c) => c.mutedForeground, (c) => c.muted),
      for (final surface in ['background', 'card', 'popover'])
        for (final role in [
          'primary',
          'destructive',
          'error',
          'success',
          'info',
        ])
          '$role text on $surface': (
            (c) => _role(c, role),
            (c) => _role(c, surface),
          ),
    };

    for (final entry in {
      'light': VColors.light,
      'dark': VColors.dark,
    }.entries) {
      for (final pair in pairs.entries) {
        test('${entry.key}: ${pair.key}', () {
          final fg = pair.value.$1(entry.value);
          final bg = pair.value.$2(entry.value);
          expect(ratio(fg, bg), greaterThanOrEqualTo(4.5));
        });
      }
    }
  });
}

Color _role(VColors c, String name) => switch (name) {
  'primary' => c.primary,
  'destructive' => c.destructive,
  'error' => c.error,
  'success' => c.success,
  'info' => c.info,
  'background' => c.background,
  'card' => c.card,
  'popover' => c.popover,
  _ => throw ArgumentError(name),
};
