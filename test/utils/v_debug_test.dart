import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  setUp(() {
    VDebug.enabled = false;
    VDebug.categories = {};
  });

  group('VDebug', () {
    test('does not log when disabled', () {
      final logs = <String>[];
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) logs.add(message);
      };

      VDebug.log(
        category: VDebugCategory.input,
        component: 'VTextField',
        action: 'changed',
        value: 'test',
      );

      expect(logs, isEmpty);

      debugPrint = debugPrintSynchronously;
    });

    test('logs when enabled in debug mode', () {
      final logs = <String>[];
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) logs.add(message);
      };

      VDebug.enabled = true;

      VDebug.log(
        category: VDebugCategory.input,
        component: 'VTextField',
        action: 'changed',
        value: 'hello',
      );

      expect(logs, hasLength(1));
      expect(logs.first, contains('[DEBUG]'));
      expect(logs.first, contains('VTextField'));
      expect(logs.first, contains('changed'));
      expect(logs.first, contains('hello'));

      debugPrint = debugPrintSynchronously;
    });

    test('includes name when provided', () {
      final logs = <String>[];
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) logs.add(message);
      };

      VDebug.enabled = true;

      VDebug.log(
        category: VDebugCategory.input,
        component: 'VCheckbox',
        name: 'remember',
        action: 'changed',
        value: true,
      );

      expect(logs.first, contains('VCheckbox[remember]'));
      expect(logs.first, contains('=> true'));

      debugPrint = debugPrintSynchronously;
    });

    test('omits value when null', () {
      final logs = <String>[];
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) logs.add(message);
      };

      VDebug.enabled = true;

      VDebug.log(
        category: VDebugCategory.feedback,
        component: 'VDialog',
        action: 'opened',
      );

      expect(logs.first, contains('opened'));
      expect(logs.first, isNot(contains('=>')));

      debugPrint = debugPrintSynchronously;
    });

    test('filters by category when categories is non-empty', () {
      final logs = <String>[];
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) logs.add(message);
      };

      VDebug.enabled = true;
      VDebug.categories = {VDebugCategory.navigation};

      // Input category — should be filtered
      VDebug.log(
        category: VDebugCategory.input,
        component: 'VTextField',
        action: 'changed',
      );
      expect(logs, isEmpty);

      // Navigation category — should pass
      VDebug.log(
        category: VDebugCategory.navigation,
        component: 'VTabs',
        action: 'selected',
        value: 2,
      );
      expect(logs, hasLength(1));
      expect(logs.first, contains('VTabs'));

      debugPrint = debugPrintSynchronously;
    });

    test('logs all categories when categories is empty', () {
      final logs = <String>[];
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) logs.add(message);
      };

      VDebug.enabled = true;
      VDebug.categories = {};

      for (final category in VDebugCategory.values) {
        VDebug.log(
          category: category,
          component: 'Test',
          action: category.name,
        );
      }

      expect(logs, hasLength(VDebugCategory.values.length));

      debugPrint = debugPrintSynchronously;
    });

    test('time format is HH:mm:ss.SSS', () {
      final logs = <String>[];
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) logs.add(message);
      };

      VDebug.enabled = true;

      VDebug.log(
        category: VDebugCategory.input,
        component: 'VSwitch',
        action: 'toggled',
      );

      // Pattern: [HH:mm:ss.SSS]
      expect(logs.first, matches(RegExp(r'\[\d{2}:\d{2}:\d{2}\.\d{3}\]')));

      debugPrint = debugPrintSynchronously;
    });
  });

  group('VDebugCategory', () {
    test('has expected values', () {
      expect(VDebugCategory.values, hasLength(3));
      expect(
        VDebugCategory.values.map((e) => e.name),
        containsAll(['input', 'navigation', 'feedback']),
      );
    });
  });
}
