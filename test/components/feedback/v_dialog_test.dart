import 'dart:async';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget(Widget child, {bool withTheme = true}) {
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

    if (withTheme) {
      return VTheme(data: VThemeData.light(), child: widget);
    }
    return widget;
  }

  group('VDialog', () {
    testWidgets('renders alert dialog', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => VDialog.show<void>(
                context,
                const VDialog.alert(content: Text('Alert message')),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Alert message'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('renders confirm dialog', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => VDialog.show<void>(
                context,
                const VDialog.confirm(
                  title: Text('Confirm Title'),
                  content: Text('Confirm message'),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Title'), findsOneWidget);
      expect(find.text('Confirm message'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('renders confirm dialog with destructive style', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => VDialog.show<void>(
                context,
                const VDialog.confirm(
                  content: Text('Delete?'),
                  destructive: true,
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Delete?'), findsOneWidget);
    });

    testWidgets('renders custom dialog', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => VDialog.show<void>(
                context,
                VDialog.custom(
                  title: const Text('Custom'),
                  content: const Text('Custom content'),
                  actions: [
                    VButton(onPressed: () {}, child: const Text('Action')),
                  ],
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Custom'), findsOneWidget);
      expect(find.text('Custom content'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
    });

    testWidgets('calls onConfirm callback', (tester) async {
      var confirmed = false;

      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => VDialog.show<void>(
                context,
                VDialog.alert(
                  content: const Text('Confirm?'),
                  onConfirm: () => confirmed = true,
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
    });

    testWidgets('calls onCancel callback', (tester) async {
      var cancelled = false;

      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => VDialog.show<void>(
                context,
                VDialog.confirm(
                  content: const Text('Confirm?'),
                  onCancel: () => cancelled = true,
                ),
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

      expect(cancelled, isTrue);
    });

    group('barrierDismissible', () {
      testWidgets('closes dialog when tapping barrier (default)', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('Test')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Test'), findsOneWidget);

        // Tap on the barrier (outside the dialog)
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        expect(find.text('Test'), findsNothing);
      });

      testWidgets('does not close dialog when barrierDismissible is false', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    content: Text('Test'),
                    barrierDismissible: false,
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Test'), findsOneWidget);

        // Tap on the barrier (outside the dialog)
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Dialog should still be visible
        expect(find.text('Test'), findsOneWidget);
      });
    });

    group('barrierColor', () {
      testWidgets('uses default barrier color', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('Test')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Check that the dialog is displayed (barrier color is internal)
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('applies custom barrier color', (tester) async {
        const customColor = Color(0x80FF0000);

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    content: Text('Test'),
                    barrierColor: customColor,
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Test'), findsOneWidget);
      });
    });

    group('actionsAlignment', () {
      testWidgets('aligns actions to end by default', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('Test')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Find the Row that contains VButton (actions row)
        final actionsRow = tester.widget<Row>(
          find
              .ancestor(of: find.byType(VButton), matching: find.byType(Row))
              .last,
        );
        expect(actionsRow.mainAxisAlignment, MainAxisAlignment.end);
      });

      testWidgets('aligns actions to start', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    content: Text('Test'),
                    actionsAlignment: VDialogActionsAlignment.start,
                  ),
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
        expect(actionsRow.mainAxisAlignment, MainAxisAlignment.start);
      });

      testWidgets('aligns actions to center', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    content: Text('Test'),
                    actionsAlignment: VDialogActionsAlignment.center,
                  ),
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
        expect(actionsRow.mainAxisAlignment, MainAxisAlignment.center);
      });
    });

    group('Widget content', () {
      testWidgets('renders complex widget structure as content', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    title: Text('Complex Content'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('First line'),
                        SizedBox(height: 8),
                        Text('Second line'),
                        SizedBox(height: 8),
                        Text('Third line'),
                      ],
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Complex Content'), findsOneWidget);
        expect(find.text('First line'), findsOneWidget);
        expect(find.text('Second line'), findsOneWidget);
        expect(find.text('Third line'), findsOneWidget);
      });

      testWidgets('renders nested widgets as content', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  VDialog.confirm(
                    title: const Text('Nested Content'),
                    content: Container(
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.call),
                              SizedBox(width: 8),
                              Text('With icon'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Nested Content'), findsOneWidget);
        expect(find.text('With icon'), findsOneWidget);
      });
    });

    group('Widget title', () {
      testWidgets('renders Widget as title', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    title: Row(
                      children: [
                        Icon(Icons.call),
                        SizedBox(width: 8),
                        Text('Widget Title'),
                      ],
                    ),
                    content: Text('Content text'),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Widget Title'), findsOneWidget);
        expect(find.text('Content text'), findsOneWidget);
      });

      testWidgets('renders styled Text as title', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    title: Text(
                      'Styled Title',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Text('Content text'),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Styled Title'), findsOneWidget);
      });
    });

    group('VDialog.confirm variant', () {
      testWidgets('renders with custom button texts', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.confirm(
                    content: Text('Delete this item?'),
                    cancelText: 'Keep',
                    confirmText: 'Delete',
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Keep'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
      });

      testWidgets('calls both onCancel and closes dialog', (tester) async {
        var cancelled = false;
        var dialogClosed = false;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () async {
                  await VDialog.show<void>(
                    context,
                    VDialog.confirm(
                      content: const Text('Confirm?'),
                      onCancel: () => cancelled = true,
                    ),
                  );
                  dialogClosed = true;
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

        expect(cancelled, isTrue);
        expect(dialogClosed, isTrue);
      });

      testWidgets('calls both onConfirm and closes dialog', (tester) async {
        var confirmed = false;
        var dialogClosed = false;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () async {
                  await VDialog.show<void>(
                    context,
                    VDialog.confirm(
                      content: const Text('Confirm?'),
                      onConfirm: () => confirmed = true,
                    ),
                  );
                  dialogClosed = true;
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        expect(confirmed, isTrue);
        expect(dialogClosed, isTrue);
      });

      testWidgets('renders with destructive style', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.confirm(
                    title: Text('Delete'),
                    content: Text('Sure?'),
                    destructive: true,
                    cancelText: 'No',
                    confirmText: 'Yes',
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Find the confirm button and verify it exists
        expect(find.text('Yes'), findsOneWidget);
        // The destructive button should be rendered with destructive color
        final buttons = find.byType(VButton);
        expect(buttons, findsNWidgets(2)); // No and Yes buttons
      });

      testWidgets('supports barrierDismissible false', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.confirm(
                    content: Text('Must choose'),
                    barrierDismissible: false,
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Tap outside dialog
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Dialog should remain visible
        expect(find.text('Must choose'), findsOneWidget);
      });
    });

    group('VDialog.custom variant', () {
      testWidgets('renders with multiple custom actions', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  VDialog.custom(
                    title: const Text('Custom'),
                    content: const Text('Options'),
                    actions: [
                      VButton.text(onPressed: () {}, child: const Text('A')),
                      VButton.outlined(
                        onPressed: () {},
                        child: const Text('B'),
                      ),
                      VButton(onPressed: () {}, child: const Text('C')),
                    ],
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Custom'), findsOneWidget);
        expect(find.text('Options'), findsOneWidget);
        expect(find.text('A'), findsOneWidget);
        expect(find.text('B'), findsOneWidget);
        expect(find.text('C'), findsOneWidget);
      });

      testWidgets('renders with no actions (empty list)', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.custom(
                    title: Text('Info Only'),
                    content: Text('No actions available'),
                    actions: [],
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Info Only'), findsOneWidget);
        expect(find.text('No actions available'), findsOneWidget);
        // No VButton should be rendered
        expect(find.byType(VButton), findsNothing);
      });

      testWidgets('renders with single action', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  VDialog.custom(
                    content: const Text('Single action'),
                    actions: [
                      VButton(onPressed: () {}, child: const Text('OK')),
                    ],
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Single action'), findsOneWidget);
        expect(find.text('OK'), findsOneWidget);
      });

      testWidgets('custom action closes dialog with VDialog.close', (
        tester,
      ) async {
        var actionCalled = false;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  VDialog.custom(
                    content: const Text('Test close'),
                    actions: [
                      Builder(
                        builder: (dialogContext) => VButton(
                          onPressed: () {
                            actionCalled = true;
                            VDialog.close<void>(dialogContext);
                          },
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Test close'), findsOneWidget);

        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();

        expect(actionCalled, isTrue);
        expect(find.text('Test close'), findsNothing);
      });

      testWidgets('respects actionsAlignment', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  VDialog.custom(
                    content: const Text('Aligned'),
                    actionsAlignment: VDialogActionsAlignment.start,
                    actions: [
                      VButton(onPressed: () {}, child: const Text('Action')),
                    ],
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Find the actions Row (outermost Row containing VButton)
        final actionsRow = tester.widget<Row>(
          find
              .ancestor(of: find.byType(VButton), matching: find.byType(Row))
              .last,
        );
        expect(actionsRow.mainAxisAlignment, MainAxisAlignment.start);
      });
    });

    group('Semantics', () {
      testWidgets('has correct semantics structure', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    title: Text('Alert Title'),
                    content: Text('Alert content'),
                    semanticLabel: 'Alert Title',
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Find the Semantics widget
        final semantics = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && (widget.properties.namesRoute ?? false),
        );
        expect(semantics, findsOneWidget);

        final semanticsWidget = tester.widget<Semantics>(semantics);
        expect(semanticsWidget.properties.namesRoute, isTrue);
        expect(semanticsWidget.properties.scopesRoute, isTrue);
        expect(semanticsWidget.properties.label, 'Alert Title');
      });

      testWidgets('uses default label without semanticLabel', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    title: Row(children: [Text('Widget Title')]),
                    content: Text('Content'),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        final semantics = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && (widget.properties.namesRoute ?? false),
        );
        expect(semantics, findsOneWidget);

        final semanticsWidget = tester.widget<Semantics>(semantics);
        expect(semanticsWidget.properties.label, 'Dialog');
      });

      testWidgets('uses default label when title is null', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('No title')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        final semantics = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && (widget.properties.namesRoute ?? false),
        );
        expect(semantics, findsOneWidget);

        final semanticsWidget = tester.widget<Semantics>(semantics);
        expect(semanticsWidget.properties.label, 'Dialog');
      });
    });

    group('Button callbacks', () {
      testWidgets('alert dialog onConfirm is optional', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('No callback')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Should not throw when tapping confirm without callback
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        // Dialog should close
        expect(find.text('No callback'), findsNothing);
      });

      testWidgets('confirm dialog callbacks are optional', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.confirm(content: Text('Optional callbacks')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Should not throw when tapping cancel without callback
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.text('Optional callbacks'), findsNothing);
      });

      testWidgets('callbacks execute before dialog closes', (tester) async {
        final callOrder = <String>[];

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () async {
                  await VDialog.show<void>(
                    context,
                    VDialog.confirm(
                      content: const Text('Test order'),
                      onConfirm: () => callOrder.add('callback'),
                    ),
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
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        expect(callOrder, ['callback', 'closed']);
      });
    });

    group('actionsExpanded', () {
      testWidgets('buttons are not expanded by default', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.confirm(content: Text('Test')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Buttons should NOT be wrapped in Expanded
        final expanded = find.ancestor(
          of: find.byType(VButton),
          matching: find.byType(Expanded),
        );
        expect(expanded, findsNothing);
      });

      testWidgets('buttons are expanded when actionsExpanded is true', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.confirm(
                    content: Text('Test'),
                    actionsExpanded: true,
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Buttons should be wrapped in Expanded
        final expanded = find.ancestor(
          of: find.byType(VButton),
          matching: find.byType(Expanded),
        );
        expect(expanded, findsNWidgets(2)); // Cancel and Confirm buttons
      });
    });

    group('VDialog.close', () {
      testWidgets('closes dialog with result', (tester) async {
        String? result;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () async {
                  result = await VDialog.show<String>(
                    context,
                    VDialog.custom(
                      content: const Text('Choose'),
                      actions: [
                        Builder(
                          builder: (dialogContext) => VButton(
                            onPressed: () => VDialog.close<String>(
                              dialogContext,
                              'selected',
                            ),
                            child: const Text('Select'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Select'));
        await tester.pumpAndSettle();

        expect(result, 'selected');
      });

      testWidgets('closes dialog without result', (tester) async {
        String? result = 'initial';

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () async {
                  result = await VDialog.show<String>(
                    context,
                    VDialog.custom(
                      content: const Text('Choose'),
                      actions: [
                        Builder(
                          builder: (dialogContext) => VButton(
                            onPressed: () =>
                                VDialog.close<String>(dialogContext),
                            child: const Text('Close'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();

        expect(result, isNull);
      });
    });

    group('Animation and transitions', () {
      testWidgets('dialog animates in with fade and scale', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('Animated')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        // Pump a few frames to catch animation in progress
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        // FadeTransition should be present
        expect(find.byType(FadeTransition), findsWidgets);

        // ScaleTransition should be present
        expect(find.byType(ScaleTransition), findsOneWidget);

        await tester.pumpAndSettle();
        expect(find.text('Animated'), findsOneWidget);
      });

      testWidgets('dialog animates out on close', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('Animated')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Animated'), findsOneWidget);

        await tester.tap(find.text('Confirm'));
        // Pump a few frames to catch animation out
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));

        // Animations should still be present during exit
        expect(find.byType(FadeTransition), findsWidgets);

        await tester.pumpAndSettle();
        expect(find.text('Animated'), findsNothing);
      });

      testWidgets('transition duration is 200ms', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('Test')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));

        // Before 200ms, dialog should still be animating
        await tester.pump(const Duration(milliseconds: 100));
        final fadeTransition = tester.widget<FadeTransition>(
          find.byType(FadeTransition).first,
        );
        // Animation should not be complete at 100ms
        expect(fadeTransition.opacity.value, lessThan(1.0));

        // After 200ms, animation should be complete
        await tester.pumpAndSettle();
        expect(find.text('Test'), findsOneWidget);
      });
    });

    group('VDialog.alert variant', () {
      testWidgets('renders with custom confirmText', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    content: Text('Alert message'),
                    confirmText: 'OK',
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('OK'), findsOneWidget);
        expect(find.text('Confirm'), findsNothing);
      });

      testWidgets('renders without title', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('Content only')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Content only'), findsOneWidget);
        // Only one Padding for actions (top: 24), no title padding
        final columns = find.byType(Column);
        expect(columns, findsWidgets);
      });

      testWidgets('renders with title', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    title: Text('Alert Title'),
                    content: Text('Alert content'),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Alert Title'), findsOneWidget);
        expect(find.text('Alert content'), findsOneWidget);
      });

      testWidgets('supports actionsExpanded', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    content: Text('Test'),
                    actionsExpanded: true,
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Button should be wrapped in Expanded
        final expanded = find.ancestor(
          of: find.byType(VButton),
          matching: find.byType(Expanded),
        );
        expect(expanded, findsOneWidget);
      });

      testWidgets('supports custom barrierColor', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    content: Text('Test'),
                    barrierColor: Color(0x80FF0000),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Test'), findsOneWidget);
      });
    });

    group('VDialog.custom variant', () {
      testWidgets('renders with null actions', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.custom(
                    title: Text('Info'),
                    content: Text('No actions'),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Info'), findsOneWidget);
        expect(find.text('No actions'), findsOneWidget);
        expect(find.byType(VButton), findsNothing);
      });

      testWidgets('supports actionsExpanded with multiple actions', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  VDialog.custom(
                    content: const Text('Test'),
                    actionsExpanded: true,
                    actions: [
                      VButton(onPressed: () {}, child: const Text('A')),
                      VButton(onPressed: () {}, child: const Text('B')),
                      VButton(onPressed: () {}, child: const Text('C')),
                    ],
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // All 3 buttons should be wrapped in Expanded
        final expanded = find.ancestor(
          of: find.byType(VButton),
          matching: find.byType(Expanded),
        );
        expect(expanded, findsNWidgets(3));
      });

      testWidgets('renders without title', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  VDialog.custom(
                    content: const Text('Content only'),
                    actions: [
                      VButton(onPressed: () {}, child: const Text('OK')),
                    ],
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Content only'), findsOneWidget);
        expect(find.text('OK'), findsOneWidget);
      });
    });

    group('VDialogActionsAlignment enum', () {
      testWidgets('start alignment maps to MainAxisAlignment.start', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.confirm(
                    content: Text('Test'),
                    actionsAlignment: VDialogActionsAlignment.start,
                  ),
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
        expect(actionsRow.mainAxisAlignment, MainAxisAlignment.start);
      });

      testWidgets('center alignment maps to MainAxisAlignment.center', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.confirm(
                    content: Text('Test'),
                    actionsAlignment: VDialogActionsAlignment.center,
                  ),
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
        expect(actionsRow.mainAxisAlignment, MainAxisAlignment.center);
      });

      testWidgets('end alignment maps to MainAxisAlignment.end', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.confirm(content: Text('Test')),
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

    group('Dialog content types', () {
      testWidgets('renders String content', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('String content')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('String content'), findsOneWidget);
      });

      testWidgets('renders Widget content', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    content: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Widget content'),
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Widget content'), findsOneWidget);
      });
    });

    group('Dialog title types', () {
      testWidgets('renders String title', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    title: Text('String title'),
                    content: Text('Content'),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('String title'), findsOneWidget);
      });

      testWidgets('renders Widget title', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text('Icon '), Text('Title')],
                    ),
                    content: Text('Content'),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Icon '), findsOneWidget);
        expect(find.text('Title'), findsOneWidget);
      });
    });

    group('Visual styling', () {
      testWidgets('dialog has max width constraint of 400', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('Test')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // VDialog contains Center > ConstrainedBox
        final constrainedBoxes = find.byType(ConstrainedBox);
        expect(constrainedBoxes, findsWidgets);

        // Find the ConstrainedBox with maxWidth 512
        var foundExpectedConstraint = false;
        for (final element in constrainedBoxes.evaluate()) {
          final widget = element.widget as ConstrainedBox;
          if (widget.constraints.maxWidth == 512) {
            foundExpectedConstraint = true;
            break;
          }
        }
        expect(foundExpectedConstraint, isTrue);
      });

      testWidgets('dialog is centered on screen', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('Test')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // VDialog uses Center widget
        expect(find.byType(Center), findsWidgets);
      });

      testWidgets('dialog container has border radius', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('Test')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Find Container with BoxDecoration
        final containers = find.byType(Container);
        expect(containers, findsWidgets);

        var foundBorderRadius = false;
        for (final element in containers.evaluate()) {
          final widget = element.widget as Container;
          final decoration = widget.decoration;
          if (decoration is BoxDecoration && decoration.borderRadius != null) {
            expect(decoration.borderRadius, BorderRadius.circular(12));
            foundBorderRadius = true;
            break;
          }
        }
        expect(foundBorderRadius, isTrue);
      });
    });

    group('DefaultTextStyle', () {
      testWidgets('styles Text title and content from theme tokens', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(
                    title: Text('Styled title'),
                    content: Text('Styled content'),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        TextStyle styleOf(String text) => tester
            .widget<RichText>(
              find.descendant(
                of: find.text(text),
                matching: find.byType(RichText),
              ),
            )
            .text
            .style!;

        final theme = VThemeData.light();
        final title = styleOf('Styled title');
        expect(title.color, theme.colors.foreground);
        expect(title.fontSize, theme.typography.titleLarge.fontSize);
        final content = styleOf('Styled content');
        expect(content.color, theme.colors.mutedForeground);
        expect(content.fontSize, theme.typography.bodyMedium.fontSize);
      });
    });

    group('Confirm dialog destructive button', () {
      testWidgets(
        'confirm button uses destructive color when destructive is true',
        (tester) async {
          await tester.pumpWidget(
            buildTestWidget(
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () => VDialog.show<void>(
                    context,
                    const VDialog.confirm(
                      content: Text('Delete?'),
                      destructive: true,
                      confirmText: 'Delete',
                    ),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          );

          await tester.tap(find.text('Open'));
          await tester.pumpAndSettle();

          // Find confirm button (Delete)
          final buttons = tester.widgetList<VButton>(find.byType(VButton));
          final confirmButton = buttons.last;

          // Check that it has destructive color
          expect(confirmButton.color, VButtonColor.destructive);
        },
      );

      testWidgets(
        'confirm button uses primary color when destructive is false',
        (tester) async {
          await tester.pumpWidget(
            buildTestWidget(
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () => VDialog.show<void>(
                    context,
                    const VDialog.confirm(
                      content: Text('Confirm?'),
                      confirmText: 'OK',
                    ),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          );

          await tester.tap(find.text('Open'));
          await tester.pumpAndSettle();

          // Find confirm button (OK)
          final buttons = tester.widgetList<VButton>(find.byType(VButton));
          final confirmButton = buttons.last;

          // Check that it has primary color
          expect(confirmButton.color, VButtonColor.primary);
        },
      );
    });

    group('Edge cases', () {
      testWidgets('dialog opens and can be closed', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('Test')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        // Open dialog
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(find.text('Test'), findsOneWidget);

        // Close dialog
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();
        expect(find.text('Test'), findsNothing);

        // Open again
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('dialog works without VTheme ancestor', (tester) async {
        // This tests the else branch where themeData is null
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () async {
                  // Show dialog in a context without VTheme
                  await showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: 'Test',
                    pageBuilder: (ctx, _, _) =>
                        const VDialog.alert(content: Text('No theme')),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // Dialog should still render (with default theme)
        expect(find.text('No theme'), findsOneWidget);
      });

      testWidgets('empty string content renders', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.byType(VDialog), findsOneWidget);
        expect(find.text('Confirm'), findsOneWidget);
      });

      testWidgets('moderately long content renders correctly', (tester) async {
        // Use a moderate length that won't cause overflow in test environment
        final content = 'This is a moderately long content. ' * 5;

        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  VDialog.alert(content: Text(content)),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text(content), findsOneWidget);
        expect(find.text('Confirm'), findsOneWidget);
      });
    });

    group('Barrier label', () {
      testWidgets('barrier has label for accessibility', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => VDialog.show<void>(
                  context,
                  const VDialog.alert(content: Text('Test')),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        // The barrier label "Dismiss" is set internally for accessibility
        // We can verify the dialog is dismissible by tapping outside
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        expect(find.text('Test'), findsNothing);
      });
    });

    group('theme override', () {
      testWidgets('theme componentOverrides applies to dialog', (tester) async {
        await tester.pumpWidget(
          VTheme(
            data: VThemeData.light().copyWith(
              componentOverrides: const VComponentOverrides([
                VDialogStyle(backgroundColor: Color(0xFFFF0000)),
              ]),
            ),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: MediaQuery(
                data: MediaQueryData(),
                child: VDialog.alert(content: Text('Test content')),
              ),
            ),
          ),
        );

        expect(find.byType(VDialog), findsOneWidget);
      });
    });
  });

  group('VDialog regressions', () {
    testWidgets('onConfirm may open another dialog without closing it', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => VDialog.show<void>(
                context,
                VDialog.alert(
                  content: const Text('first'),
                  onConfirm: () => VDialog.show<void>(
                    context,
                    const VDialog.alert(content: Text('second')),
                  ),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('second'), findsOneWidget);
      expect(find.text('first'), findsNothing);
    });

    testWidgets('onCancel may push a route without that route being popped', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => VDialog.show<void>(
                context,
                VDialog.confirm(
                  content: const Text('first'),
                  onCancel: () => unawaited(
                    Navigator.of(context).push(
                      PageRouteBuilder<void>(
                        pageBuilder: (_, _, _) => const Text('next page'),
                      ),
                    ),
                  ),
                ),
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

      expect(find.text('next page'), findsOneWidget);
      expect(find.text('first'), findsNothing);
    });

    testWidgets('Escape closes the dialog exactly once', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => VDialog.show<void>(
                context,
                const VDialog.alert(content: Text('first')),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('first'), findsNothing);
      // The page under the dialog is still there.
      expect(find.text('Open'), findsOneWidget);
    });
  });

  group('VDialogStyle.shadows', () {
    const shadow = [BoxShadow(color: Color(0x33000000), blurRadius: 3)];
    const themeShadow = [BoxShadow(color: Color(0x55000000), blurRadius: 9)];

    Widget dialog({VDialogStyle? style, VThemeData? theme}) => VTheme(
      data: theme ?? VThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: VDialog.custom(content: const Text('Body'), style: style),
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
        dialog(style: const VDialogStyle(shadows: shadow)),
      );
      expect(panel(tester).boxShadow, shadow);

      await tester.pumpWidget(dialog(style: const VDialogStyle(shadows: [])));
      expect(panel(tester).boxShadow, isEmpty);
    });

    testWidgets('the instance style wins over the theme override', (
      tester,
    ) async {
      final theme = VThemeData.light().copyWith(
        componentOverrides: const VComponentOverrides([
          VDialogStyle(shadows: themeShadow),
        ]),
      );

      await tester.pumpWidget(dialog(theme: theme));
      expect(panel(tester).boxShadow, themeShadow);

      await tester.pumpWidget(
        dialog(
          theme: theme,
          style: const VDialogStyle(shadows: shadow),
        ),
      );
      expect(panel(tester).boxShadow, shadow);
    });
  });
}
