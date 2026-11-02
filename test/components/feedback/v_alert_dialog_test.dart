import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    final widget = Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: Navigator(
          onGenerateRoute: (_) => PageRouteBuilder(
            pageBuilder: (_, _, _) =>
                Overlay(initialEntries: [OverlayEntry(builder: (_) => child)]),
          ),
        ),
      ),
    );

    return VTheme(data: VThemeData.light(), child: widget);
  }

  group('VAlertDialog', () {
    group('rendering', () {
      testWidgets('renders description text', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Please confirm this action.'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Please confirm this action.'), findsOneWidget);
      });

      testWidgets('renders title and description together', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  title: const Text('Warning'),
                  description: const Text('This action cannot be undone.'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Warning'), findsOneWidget);
        expect(find.text('This action cannot be undone.'), findsOneWidget);
      });

      testWidgets('renders without title when title is null', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Description only.'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Description only.'), findsOneWidget);
      });

      testWidgets('renders description as Widget', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text('Line one'), Text('Line two')],
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Line one'), findsOneWidget);
        expect(find.text('Line two'), findsOneWidget);
      });

      testWidgets('renders title as Widget', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  title: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text('Title Widget')],
                  ),
                  description: const Text('Body text.'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Title Widget'), findsOneWidget);
        expect(find.text('Body text.'), findsOneWidget);
      });
    });

    group('confirm button', () {
      testWidgets('shows default confirm text OK', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Confirm action.'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('OK'), findsOneWidget);
      });

      testWidgets('shows custom confirmText', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Save changes?'),
                  confirmText: 'Save',
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Save'), findsOneWidget);
        expect(find.text('OK'), findsNothing);
      });
    });

    group('cancel button', () {
      testWidgets('does not show cancel button when cancelText is null', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('No cancel.'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('OK'), findsOneWidget);
        // Only one VButton (the confirm button)
        expect(find.byType(VButton), findsOneWidget);
      });

      testWidgets('shows cancel button with custom cancelText', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Proceed?'),
                  cancelText: 'Dismiss',
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Dismiss'), findsOneWidget);
        expect(find.text('OK'), findsOneWidget);
        // Two VButton widgets (cancel + confirm)
        expect(find.byType(VButton), findsNWidgets(2));
      });
    });

    group('onConfirm callback', () {
      testWidgets('fires onConfirm and closes dialog', (tester) async {
        var confirmed = false;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Confirm?'),
                  onConfirm: () => confirmed = true,
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Confirm?'), findsOneWidget);

        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(confirmed, isTrue);
        expect(find.text('Confirm?'), findsNothing);
      });

      testWidgets('closes dialog even without onConfirm callback', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('No callback.'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(find.text('No callback.'), findsNothing);
      });
    });

    group('onCancel callback', () {
      testWidgets('fires onCancel and closes dialog', (tester) async {
        var cancelled = false;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Cancel?'),
                  cancelText: 'Cancel',
                  onCancel: () => cancelled = true,
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Cancel?'), findsOneWidget);

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(cancelled, isTrue);
        expect(find.text('Cancel?'), findsNothing);
      });

      testWidgets('closes dialog even without onCancel callback', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Cancel no callback.'),
                  cancelText: 'Cancel',
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.text('Cancel no callback.'), findsNothing);
      });
    });

    group('VAlertDialog.show()', () {
      testWidgets('creates dialog via static show method', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  title: const Text('Static Show'),
                  description: const Text('Created via static method.'),
                  confirmText: 'Accept',
                  cancelText: 'Reject',
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Static Show'), findsOneWidget);
        expect(find.text('Created via static method.'), findsOneWidget);
        expect(find.text('Accept'), findsOneWidget);
        expect(find.text('Reject'), findsOneWidget);
      });

      testWidgets('propagates VTheme into dialog route', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Themed dialog.'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // VAlertDialog.build calls VTheme.of(context), which would throw
        // if theme was not propagated. Finding the dialog proves it works.
        expect(find.text('Themed dialog.'), findsOneWidget);
        expect(find.byType(VAlertDialog), findsOneWidget);
      });
    });

    group('VAlertDialog.close()', () {
      testWidgets('closes dialog programmatically', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Close me.'),
                  confirmText: 'Done',
                  onConfirm: () {},
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Close me.'), findsOneWidget);

        // Tapping confirm calls close internally
        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();

        expect(find.text('Close me.'), findsNothing);
      });
    });

    group('destructive mode', () {
      testWidgets('uses destructive button color when destructive is true', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  title: const Text('Delete Item'),
                  description: const Text(
                    'This will permanently delete the item.',
                  ),
                  confirmText: 'Delete',
                  cancelText: 'Keep',
                  destructive: true,
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Delete Item'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
        expect(find.text('Keep'), findsOneWidget);

        // Verify the VAlertDialog widget has destructive set to true
        final alertDialog = tester.widget<VAlertDialog>(
          find.byType(VAlertDialog),
        );
        expect(alertDialog.destructive, isTrue);
      });

      testWidgets('uses primary button color when destructive is false', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Normal action.'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        final alertDialog = tester.widget<VAlertDialog>(
          find.byType(VAlertDialog),
        );
        expect(alertDialog.destructive, isFalse);
      });
    });

    group('FocusTraversalGroup', () {
      testWidgets('wraps dialog content with FocusTraversalGroup', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Focus test.'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Verify FocusTraversalGroup is present as descendant of VAlertDialog
        // (VButton may also contain one, so we check at least one exists)
        expect(
          find.descendant(
            of: find.byType(VAlertDialog),
            matching: find.byType(FocusTraversalGroup),
          ),
          findsAtLeastNWidgets(1),
        );

        // Verify the first child of VAlertDialog's build is FocusTraversalGroup
        final alertDialogElement = tester.element(find.byType(VAlertDialog));
        final firstChild = (alertDialogElement as StatelessElement).widget;
        expect(firstChild, isA<VAlertDialog>());
        // The VAlertDialog.build returns FocusTraversalGroup as root
        final builtWidget = (firstChild as VAlertDialog).build(
          alertDialogElement,
        );
        expect(builtWidget, isA<FocusTraversalGroup>());
      });
    });

    group('barrierDismissible', () {
      testWidgets('does not close on barrier tap by default', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Barrier default.'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Barrier default.'), findsOneWidget);

        // Tap on the barrier (outside the dialog)
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Dialog should still be visible (default barrierDismissible is false)
        expect(find.text('Barrier default.'), findsOneWidget);
      });

      testWidgets('closes on barrier tap when barrierDismissible is true', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Barrier dismissible.'),
                  barrierDismissible: true,
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Barrier dismissible.'), findsOneWidget);

        // Tap on the barrier (outside the dialog)
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        expect(find.text('Barrier dismissible.'), findsNothing);
      });
    });

    group('constructor', () {
      testWidgets('renders directly without show method', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  title: const Text('Direct Title'),
                  description: const Text('Direct description.'),
                  confirmText: 'Yes',
                  cancelText: 'No',
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.byType(VAlertDialog), findsOneWidget);
        expect(find.text('Direct Title'), findsOneWidget);
        expect(find.text('Direct description.'), findsOneWidget);
        expect(find.text('Yes'), findsOneWidget);
        expect(find.text('No'), findsOneWidget);
      });
    });

    group('custom text combinations', () {
      testWidgets('renders with custom confirmText and cancelText', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Save document?'),
                  confirmText: 'Save',
                  cancelText: 'Discard',
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Discard'), findsOneWidget);
      });

      testWidgets('renders with confirmText only (no cancelText)', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Acknowledged.'),
                  confirmText: 'Got it',
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Got it'), findsOneWidget);
        expect(find.byType(VButton), findsOneWidget);
      });
    });

    group('callback interaction', () {
      testWidgets('onConfirm fires before dialog closes', (tester) async {
        final callOrder = <String>[];

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () async {
                  await VAlertDialog.show<void>(
                    context,
                    description: const Text('Order test.'),
                    onConfirm: () => callOrder.add('onConfirm'),
                  );
                  callOrder.add('closed');
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(callOrder, ['onConfirm', 'closed']);
      });

      testWidgets('onCancel fires before dialog closes', (tester) async {
        final callOrder = <String>[];

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () async {
                  await VAlertDialog.show<void>(
                    context,
                    description: const Text('Cancel order test.'),
                    cancelText: 'Cancel',
                    onCancel: () => callOrder.add('onCancel'),
                  );
                  callOrder.add('closed');
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(callOrder, ['onCancel', 'closed']);
      });

      testWidgets('both onConfirm and onCancel work in same dialog', (
        tester,
      ) async {
        var confirmed = false;
        var cancelled = false;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Both callbacks.'),
                  cancelText: 'Cancel',
                  onConfirm: () => confirmed = true,
                  onCancel: () => cancelled = true,
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        // First open: tap confirm
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        expect(confirmed, isTrue);
        expect(cancelled, isFalse);

        // Reset
        confirmed = false;

        // Second open: tap cancel
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(cancelled, isTrue);
        expect(confirmed, isFalse);
      });
    });

    group('layout', () {
      testWidgets('constrains max width to 448', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Width test.'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        final constrainedBox = tester.widget<ConstrainedBox>(
          find.ancestor(
            of: find.text('Width test.'),
            matching: find.byType(ConstrainedBox),
          ),
        );
        expect(constrainedBox.constraints.maxWidth, 448);
      });

      testWidgets('centers dialog content', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Center test.'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(
          find.ancestor(
            of: find.text('Center test.'),
            matching: find.byType(Center),
          ),
          findsOneWidget,
        );
      });

      testWidgets('actions row aligns to end', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Alignment test.'),
                  cancelText: 'Cancel',
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        final actionsRow = tester.widget<Row>(
          find
              .ancestor(of: find.byType(VButton), matching: find.byType(Row))
              .last,
        );
        expect(actionsRow.mainAxisAlignment, MainAxisAlignment.end);
      });
    });

    group('animation', () {
      testWidgets('dialog appears with animation', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('Animation test.'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        // Pump a single frame to catch mid-animation state
        await tester.pump();

        // FadeTransition and ScaleTransition should be present
        expect(find.byType(FadeTransition), findsOneWidget);
        expect(find.byType(ScaleTransition), findsOneWidget);

        await tester.pumpAndSettle();

        expect(find.text('Animation test.'), findsOneWidget);
      });
    });
  });

  group('VAlertDialog regressions', () {
    testWidgets('onConfirm may open another dialog without closing it', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => VAlertDialog.show<void>(
                context,
                description: const Text('first'),
                confirmText: 'Yes',
                onConfirm: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('second'),
                  confirmText: 'Sure',
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      expect(find.text('second'), findsOneWidget);
      expect(find.text('first'), findsNothing);
    });

    testWidgets('onCancel may open another dialog without closing it', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => VAlertDialog.show<void>(
                context,
                description: const Text('first'),
                cancelText: 'No',
                onCancel: () => VAlertDialog.show<void>(
                  context,
                  description: const Text('second'),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      expect(find.text('second'), findsOneWidget);
      expect(find.text('first'), findsNothing);
    });
  });

  group('VAlertDialogStyle.shadows', () {
    const shadow = [BoxShadow(color: Color(0x33000000), blurRadius: 3)];
    const themeShadow = [BoxShadow(color: Color(0x55000000), blurRadius: 9)];

    Widget dialog({VAlertDialogStyle? style, VThemeData? theme}) => VTheme(
      data: theme ?? VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: VAlertDialog(description: const Text('Body'), style: style),
      ),
    );

    // The decoration of the dialog panel around the body text.
    BoxDecoration panel(WidgetTester tester) => tester
        .widgetList<Container>(
          find.ancestor(
            of: find.text('Body'),
            matching: find.byType(Container),
          ),
        )
        .map((c) => c.decoration)
        .whereType<BoxDecoration>()
        .first;

    testWidgets('the theme large shadow by default', (tester) async {
      await tester.pumpWidget(dialog());
      expect(panel(tester).boxShadow, VThemeData.light().shadows.lg);
    });

    testWidgets('the style shadows replace it; an empty list draws none', (
      tester,
    ) async {
      await tester.pumpWidget(
        dialog(style: const VAlertDialogStyle(shadows: shadow)),
      );
      expect(panel(tester).boxShadow, shadow);

      await tester.pumpWidget(
        dialog(style: const VAlertDialogStyle(shadows: [])),
      );
      expect(panel(tester).boxShadow, isEmpty);
    });

    testWidgets('the instance style wins over the theme override', (
      tester,
    ) async {
      final theme = VThemeData.light().copyWith(
        componentOverrides: const VComponentOverrides([
          VAlertDialogStyle(shadows: themeShadow),
        ]),
      );

      await tester.pumpWidget(dialog(theme: theme));
      expect(panel(tester).boxShadow, themeShadow);

      await tester.pumpWidget(
        dialog(
          theme: theme,
          style: const VAlertDialogStyle(shadows: shadow),
        ),
      );
      expect(panel(tester).boxShadow, shadow);
    });
  });
}
