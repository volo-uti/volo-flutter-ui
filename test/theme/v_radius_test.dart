import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  group('VRadius', () {
    test('defaults returns default radii', () {
      final radius = VRadius.defaults;

      expect(radius.none, 0);
      expect(radius.sm, 4);
      expect(radius.md, 8);
      expect(radius.lg, 12);
      expect(radius.card, 16);
      expect(radius.full, 9999);
    });

    test('copyWith() changes only some properties', () {
      final original = VRadius.defaults;
      final modified = original.copyWith(md: 10);

      expect(modified.md, 10);
      expect(modified.lg, original.lg);
    });

    test('lerp() interpolates between two radii', () {
      final a = VRadius.defaults;
      final b = a.copyWith(md: 16);
      final mid = VRadius.lerp(a, b, 0.5);

      expect(mid.md, 12);
    });

    test('identical radii are equal', () {
      final a = VRadius.defaults;
      final b = VRadius.defaults;

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });
}
