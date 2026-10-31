import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Overlay(initialEntries: [OverlayEntry(builder: (_) => child)]),
      ),
    ),
  );

  group('VToast', () {
    testWidgets('renders default toast widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VToast(message: Text('Default toast'))),
      );

      expect(find.text('Default toast'), findsOneWidget);
    });

    testWidgets('renders success toast widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VToast.success(message: Text('Success!'))),
      );

      expect(find.text('Success!'), findsOneWidget);
    });

    testWidgets('renders error toast widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VToast.error(message: Text('Error!'))),
      );

      expect(find.text('Error!'), findsOneWidget);
    });

    testWidgets('renders warning toast widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VToast.warning(message: Text('Warning!'))),
      );

      expect(find.text('Warning!'), findsOneWidget);
    });

    testWidgets('renders info toast widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VToast.info(message: Text('Info!'))),
      );

      expect(find.text('Info!'), findsOneWidget);
    });

    testWidgets('renders toast with action', (tester) async {
      var actionPressed = false;

      await tester.pumpWidget(
        buildTestWidget(
          VToast(
            message: const Text('Toast with action'),
            action: VToastAction(
              label: 'Undo',
              onPressed: () => actionPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Toast with action'), findsOneWidget);
      expect(find.text('Undo'), findsOneWidget);

      await tester.tap(find.text('Undo'));
      await tester.pump();

      expect(actionPressed, isTrue);
    });

    testWidgets('renders toast with widget message', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VToast(
            message: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info, size: 16),
                SizedBox(width: 8),
                Text('Custom message'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Custom message'), findsOneWidget);
    });
  });

  group('VToast Interaction', () {
    Widget buildOverlayTestWidget(GlobalKey childKey) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: Overlay(
            initialEntries: [
              OverlayEntry(builder: (_) => SizedBox.shrink(key: childKey)),
            ],
          ),
        ),
      ),
    );

    testWidgets('VToast.show() displays toast via overlay', (tester) async {
      final childKey = GlobalKey();
      await tester.pumpWidget(buildOverlayTestWidget(childKey));

      final context = childKey.currentContext!;

      VToast.show(context, const VToast(message: Text('Show test toast')));

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Show test toast'), findsOneWidget);

      // Cleanup
      VToast.dismiss(context);
      await tester.pump();
    });

    testWidgets('toast auto-dismisses after duration', (tester) async {
      final childKey = GlobalKey();
      await tester.pumpWidget(buildOverlayTestWidget(childKey));

      final context = childKey.currentContext!;

      VToast.show(
        context,
        const VToast(
          message: Text('Auto dismiss toast'),
          duration: Duration(seconds: 1),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Auto dismiss toast'), findsOneWidget);

      // Wait for duration to pass
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      expect(find.text('Auto dismiss toast'), findsNothing);
    });

    testWidgets('multiple toasts replace previous one', (tester) async {
      final childKey = GlobalKey();
      await tester.pumpWidget(buildOverlayTestWidget(childKey));

      final context = childKey.currentContext!;

      // Show first toast
      VToast.show(
        context,
        const VToast(
          message: Text('First toast'),
          duration: Duration.zero, // No auto-dismiss
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('First toast'), findsOneWidget);

      // Show second toast - should replace first
      VToast.show(
        context,
        const VToast(message: Text('Second toast'), duration: Duration.zero),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // First toast should be replaced
      expect(find.text('First toast'), findsNothing);
      expect(find.text('Second toast'), findsOneWidget);

      // Show third toast - should replace second
      VToast.show(
        context,
        const VToast(message: Text('Third toast'), duration: Duration.zero),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Second toast'), findsNothing);
      expect(find.text('Third toast'), findsOneWidget);

      // Cleanup
      VToast.dismiss(context);
      await tester.pump();
    });
  });

  group('VToast regressions', () {
    Widget overlayTree(GlobalKey childKey) => VTheme(
      data: VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: Overlay(
            initialEntries: [
              OverlayEntry(builder: (_) => SizedBox.shrink(key: childKey)),
            ],
          ),
        ),
      ),
    );

    testWidgets('the action runs once and dismisses the toast', (tester) async {
      final childKey = GlobalKey();
      await tester.pumpWidget(overlayTree(childKey));
      var undone = 0;
      VToast.show(
        childKey.currentContext!,
        VToast(
          message: const Text('Item deleted'),
          duration: Duration.zero,
          action: VToastAction(label: 'Undo', onPressed: () => undone++),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Undo'));
      await tester.pump();

      expect(undone, 1);
      expect(find.text('Item deleted'), findsNothing);
    });

    testWidgets('showing again after its overlay was disposed does not throw', (
      tester,
    ) async {
      final firstKey = GlobalKey();
      await tester.pumpWidget(overlayTree(firstKey));
      VToast.show(
        firstKey.currentContext!,
        const VToast(message: Text('sticky'), duration: Duration.zero),
      );
      await tester.pump();

      await tester.pumpWidget(const SizedBox());

      final secondKey = GlobalKey();
      await tester.pumpWidget(overlayTree(secondKey));
      VToast.show(
        secondKey.currentContext!,
        const VToast(message: Text('next'), duration: Duration.zero),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);
      expect(find.text('next'), findsOneWidget);

      VToast.dismiss(secondKey.currentContext!);
      await tester.pump();
    });

    testWidgets('showSuccess announces the message once', (tester) async {
      final handle = tester.ensureSemantics();
      final childKey = GlobalKey();
      await tester.pumpWidget(overlayTree(childKey));
      VToast.showSuccess(childKey.currentContext!, 'Upload complete');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        tester.getSemantics(find.text('Upload complete')).label,
        'Upload complete',
      );

      VToast.dismiss(childKey.currentContext!);
      await tester.pump();
      handle.dispose();
    });
  });
}
