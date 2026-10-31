import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui_widgetbook/main.dart';
import 'package:widgetbook/widgetbook.dart';

/// Opens every Widgetbook use case once and fails on any framework error.
///
/// A use case that throws while it is built (for example a knob with a null
/// initial value) shows a blank canvas in the catalog, so this is the only
/// guard against shipping one.
void main() {
  testWidgets('every use case opens without an error', (tester) async {
    tester.view
      ..physicalSize = const Size(1600, 1000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    var current = '';
    final errors = <String>[];
    final previous = FlutterError.onError;
    FlutterError.onError = (details) {
      final message = details.exceptionAsString();
      // The test environment draws text with a fixed-width font, so small
      // layouts overflow there. That is not a defect of a use case.
      if (message.contains('overflowed')) return;
      errors.add('$current: $message');
      // Keep the binding's own bookkeeping, which also catches async errors.
      previous?.call(details);
    };
    addTearDown(() => FlutterError.onError = previous);

    await tester.pumpWidget(const WidgetbookApp());
    await tester.pump(const Duration(milliseconds: 500));

    final state = WidgetbookState.of(
      tester.element(find.byType(Navigator).first),
    );
    final paths = [
      for (final node in state.root.leaves.whereType<WidgetbookUseCase>())
        node.path,
    ]..sort();
    expect(paths.length, greaterThan(150));

    for (final path in paths) {
      current = path;
      // Widgetbook offers no public way to open a use case from code.
      // ignore: invalid_use_of_internal_member
      state.updatePath(path);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 400));
      // Already recorded above; clear it so the next use case starts clean.
      tester.takeException();
    }

    // Dispose the catalog so timers of the last use cases are cancelled.
    await tester.pumpWidget(const SizedBox());
    current = 'after dispose';
    await tester.pump(const Duration(seconds: 10));
    tester.takeException();

    expect(errors, isEmpty, reason: errors.join('\n'));
  });
}
