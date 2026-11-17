import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  minTapTargetSizeTests();
  group('VThemeData', () {
    test('zinc() returns a light theme', () {
      final theme = VThemeData.light();

      expect(theme.brightness, Brightness.light);
      expect(theme.isLight, true);
      expect(theme.isDark, false);
    });

    test('dark() returns a dark theme', () {
      final theme = VThemeData.dark();

      expect(theme.brightness, Brightness.dark);
      expect(theme.isDark, true);
      expect(theme.isLight, false);
    });

    test('all subsystems are included', () {
      final theme = VThemeData.light();

      expect(theme.colors, isNotNull);
      expect(theme.typography, isNotNull);
      expect(theme.spacing, isNotNull);
      expect(theme.radius, isNotNull);
      expect(theme.shadows, isNotNull);
      expect(theme.animations, isNotNull);
      expect(theme.sizes, isNotNull);
    });

    test('copyWith() changes only some properties', () {
      final original = VThemeData.light();
      final modified = original.copyWith(brightness: Brightness.dark);

      expect(modified.brightness, Brightness.dark);
      expect(modified.colors, original.colors);
      expect(modified.typography, original.typography);
    });

    test('lerp() interpolates between two themes', () {
      final light = VThemeData.light();
      final dark = VThemeData.dark();

      final mid = VThemeData.lerp(light, dark, 0.5);

      expect(mid.brightness, Brightness.dark);
      expect(mid.colors, isNotNull);
    });

    test('identical themes are equal', () {
      final a = VThemeData.light();
      final b = VThemeData.light();

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('different themes are not equal', () {
      final light = VThemeData.light();
      final dark = VThemeData.dark();

      expect(light, isNot(dark));
    });
  });
}

void minTapTargetSizeTests() {
  group('VThemeData.minTapTargetSize', () {
    test('defaults to 24', () {
      expect(VThemeData.light().minTapTargetSize, 24);
      expect(VThemeData.dark().minTapTargetSize, 24);
    });

    test('copyWith replaces it and keeps it otherwise', () {
      final base = VThemeData.light();
      expect(base.copyWith(minTapTargetSize: 48).minTapTargetSize, 48);
      expect(base.copyWith().minTapTargetSize, 24);
    });

    test('lerp moves it between the two values', () {
      final a = VThemeData.light();
      final b = a.copyWith(minTapTargetSize: 48);
      expect(VThemeData.lerp(a, b, 0.5).minTapTargetSize, 36);
    });

    test('takes part in equality and hashCode', () {
      final a = VThemeData.light();
      final b = a.copyWith(minTapTargetSize: 48);
      expect(a, isNot(b));
      expect(a, VThemeData.light());
      expect(a.hashCode, VThemeData.light().hashCode);
    });
  });
}
