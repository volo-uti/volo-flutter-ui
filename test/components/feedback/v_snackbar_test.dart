import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) => VTheme(
    data: VThemeData.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(data: const MediaQueryData(), child: child),
    ),
  );

  group('VSnackbar', () {
    testWidgets('renders default snackbar widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VSnackbar(content: Text('Default snackbar'))),
      );

      expect(find.text('Default snackbar'), findsOneWidget);
    });

    testWidgets('renders success snackbar widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VSnackbar.success(content: Text('Success!'))),
      );

      expect(find.text('Success!'), findsOneWidget);
    });

    testWidgets('renders error snackbar widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VSnackbar.error(content: Text('Error!'))),
      );

      expect(find.text('Error!'), findsOneWidget);
    });

    testWidgets('renders warning snackbar widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VSnackbar.warning(content: Text('Warning!'))),
      );

      expect(find.text('Warning!'), findsOneWidget);
    });

    testWidgets('renders info snackbar widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(const VSnackbar.info(content: Text('Info!'))),
      );

      expect(find.text('Info!'), findsOneWidget);
    });

    testWidgets('renders snackbar with action', (tester) async {
      var actionPressed = false;

      await tester.pumpWidget(
        buildTestWidget(
          VSnackbar(
            content: const Text('Snackbar with action'),
            action: VSnackbarAction(
              label: 'Undo',
              onPressed: () => actionPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Snackbar with action'), findsOneWidget);
      expect(find.text('Undo'), findsOneWidget);

      await tester.tap(find.text('Undo'));
      await tester.pump();

      expect(actionPressed, isTrue);
    });

    testWidgets('renders floating snackbar widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSnackbar(
            content: Text('Floating'),
            behavior: VSnackbarBehavior.floating,
          ),
        ),
      );

      expect(find.text('Floating'), findsOneWidget);
    });

    testWidgets('renders snackbar with widget content', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSnackbar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info, size: 16),
                SizedBox(width: 8),
                Text('Custom content'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Custom content'), findsOneWidget);
    });

    testWidgets('renders snackbar with custom shape', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          VSnackbar(
            content: const Text('Shaped snackbar'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );

      expect(find.text('Shaped snackbar'), findsOneWidget);
    });

    testWidgets('renders snackbar with dismissDirection', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VSnackbar(
            content: Text('Dismissible snackbar'),
            dismissDirection: DismissDirection.down,
          ),
        ),
      );

      expect(find.text('Dismissible snackbar'), findsOneWidget);
    });
  });

  group('VSnackbar Interaction', () {
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

    testWidgets('VSnackbar.show() displays snackbar via overlay', (
      tester,
    ) async {
      final childKey = GlobalKey();
      await tester.pumpWidget(buildOverlayTestWidget(childKey));

      final context = childKey.currentContext!;

      VSnackbar.show(
        context,
        const VSnackbar(content: Text('Show test snackbar')),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Show test snackbar'), findsOneWidget);

      // Cleanup
      VSnackbar.clear(context);
      await tester.pump();
    });

    testWidgets('swiping a snackbar with dismissDirection hides it', (
      tester,
    ) async {
      final childKey = GlobalKey();
      await tester.pumpWidget(buildOverlayTestWidget(childKey));

      final context = childKey.currentContext!;

      VSnackbar.show(
        context,
        const VSnackbar(
          content: Text('Swipe me'),
          dismissDirection: DismissDirection.endToStart,
          duration: Duration.zero,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Swipe me'), findsOneWidget);

      await tester.drag(find.text('Swipe me'), const Offset(-800, 0));
      await tester.pumpAndSettle();

      expect(find.text('Swipe me'), findsNothing);
    });

    testWidgets('action button tap triggers onPressed callback', (
      tester,
    ) async {
      final childKey = GlobalKey();
      await tester.pumpWidget(buildOverlayTestWidget(childKey));

      final context = childKey.currentContext!;
      var actionTapped = false;

      VSnackbar.show(
        context,
        VSnackbar(
          content: const Text('Snackbar with action'),
          action: VSnackbarAction(
            label: 'Action',
            onPressed: () => actionTapped = true,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Action'), findsOneWidget);

      await tester.tap(find.text('Action'));
      await tester.pump();

      expect(actionTapped, isTrue);

      // Cleanup
      VSnackbar.clear(context);
      await tester.pump();
    });

    testWidgets('snackbar auto-dismisses after duration', (tester) async {
      final childKey = GlobalKey();
      await tester.pumpWidget(buildOverlayTestWidget(childKey));

      final context = childKey.currentContext!;

      VSnackbar.show(
        context,
        const VSnackbar(
          content: Text('Auto dismiss test'),
          duration: Duration(seconds: 1),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Auto dismiss test'), findsOneWidget);

      // Wait for duration to pass
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      expect(find.text('Auto dismiss test'), findsNothing);
    });

    testWidgets('VSnackbar.hide() manually closes snackbar', (tester) async {
      final childKey = GlobalKey();
      await tester.pumpWidget(buildOverlayTestWidget(childKey));

      final context = childKey.currentContext!;

      VSnackbar.show(
        context,
        const VSnackbar(
          content: Text('Manual close test'),
          duration: Duration.zero, // Prevent auto-dismiss
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Manual close test'), findsOneWidget);

      // Manually hide
      VSnackbar.hide(context);
      await tester.pump();

      expect(find.text('Manual close test'), findsNothing);
    });
  });

  group('VSnackbar regressions', () {
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

    testWidgets('shows again after the overlay of a sticky one is disposed', (
      tester,
    ) async {
      final firstKey = GlobalKey();
      await tester.pumpWidget(overlayTree(firstKey));
      VSnackbar.show(
        firstKey.currentContext!,
        const VSnackbar(content: Text('sticky'), duration: Duration.zero),
      );
      await tester.pump();
      expect(find.text('sticky'), findsOneWidget);

      // The whole overlay goes away (route popped, app root swapped).
      await tester.pumpWidget(const SizedBox());

      final secondKey = GlobalKey();
      await tester.pumpWidget(overlayTree(secondKey));
      VSnackbar.show(
        secondKey.currentContext!,
        const VSnackbar(content: Text('next'), duration: Duration.zero),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('next'), findsOneWidget);

      VSnackbar.clear(secondKey.currentContext!);
      await tester.pump();
    });

    testWidgets('a timer firing after the overlay is gone does not throw', (
      tester,
    ) async {
      final firstKey = GlobalKey();
      await tester.pumpWidget(overlayTree(firstKey));
      final context = firstKey.currentContext!;
      VSnackbar.show(
        context,
        const VSnackbar(content: Text('a'), duration: Duration(seconds: 1)),
      );
      VSnackbar.show(
        context,
        const VSnackbar(content: Text('b'), duration: Duration(seconds: 1)),
      );
      await tester.pump();

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 2));
      expect(tester.takeException(), isNull);

      final secondKey = GlobalKey();
      await tester.pumpWidget(overlayTree(secondKey));
      VSnackbar.show(
        secondKey.currentContext!,
        const VSnackbar(content: Text('c'), duration: Duration.zero),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('c'), findsOneWidget);

      VSnackbar.clear(secondKey.currentContext!);
      await tester.pump();
    });

    testWidgets('the action runs once and dismisses the snackbar', (
      tester,
    ) async {
      final childKey = GlobalKey();
      await tester.pumpWidget(overlayTree(childKey));
      var undone = 0;
      VSnackbar.show(
        childKey.currentContext!,
        VSnackbar(
          content: const Text('Item deleted'),
          duration: Duration.zero,
          action: VSnackbarAction(label: 'Undo', onPressed: () => undone++),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Undo'));
      await tester.pump();

      expect(undone, 1);
      expect(find.text('Item deleted'), findsNothing);
      expect(find.text('Undo'), findsNothing);
    });

    testWidgets('a label replaces the message in semantics instead of adding', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestWidget(
          const VSnackbar.success(
            content: Text('Saved'),
            semanticLabel: 'Saved',
          ),
        ),
      );

      expect(tester.getSemantics(find.text('Saved')).label, 'Saved');
      handle.dispose();
    });
  });
}
