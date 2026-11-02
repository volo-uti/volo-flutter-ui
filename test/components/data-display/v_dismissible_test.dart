import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

/// Localizations with a marked dismiss label.
class _MarkedLocalizations extends VoloLocalizationsEn {
  const _MarkedLocalizations();

  @override
  String get dismissibleActionLabel => '[remove]';
}

/// A list of rows that removes a row when it is dismissed.
class _RowList extends StatefulWidget {
  const _RowList({
    this.confirmDismiss,
    this.direction = DismissDirection.endToStart,
    this.dismissLabel,
    this.style,
  });

  final ConfirmDismissCallback? confirmDismiss;
  final DismissDirection direction;
  final String? dismissLabel;
  final VDismissibleStyle? style;

  @override
  State<_RowList> createState() => _RowListState();
}

class _RowListState extends State<_RowList> {
  final rows = ['Milk', 'Eggs'];
  final dismissed = <String, DismissDirection>{};

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      for (final row in rows)
        VDismissible(
          key: ValueKey(row),
          direction: widget.direction,
          confirmDismiss: widget.confirmDismiss,
          dismissLabel: widget.dismissLabel,
          style: widget.style,
          onDismissed: (direction) => setState(() {
            rows.remove(row);
            dismissed[row] = direction;
          }),
          child: VListTile(title: Text(row)),
        ),
    ],
  );
}

void main() {
  Widget buildTestWidget(
    Widget child, {
    VThemeData? theme,
    VoloLocalizations localizations = const VoloLocalizationsEn(),
  }) => VTheme(
    data: theme ?? VThemeData.light(),
    localizations: localizations,
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  _RowListState rowList(WidgetTester tester) =>
      tester.state<_RowListState>(find.byType(_RowList));

  void performDismissAction(WidgetTester tester, String row, String label) =>
      tester.semantics.performAction(
        find.semantics.byLabel(row),
        SemanticsAction.customAction,
        args: CustomSemanticsAction.getIdentifier(
          CustomSemanticsAction(label: label),
        ),
      );

  group('VDismissible', () {
    testWidgets('a swipe removes the row', (tester) async {
      await tester.pumpWidget(buildTestWidget(const _RowList()));

      await tester.drag(find.text('Milk'), const Offset(-600, 0));
      await tester.pumpAndSettle();

      expect(find.text('Milk'), findsNothing);
      expect(find.text('Eggs'), findsOneWidget);
      expect(rowList(tester).dismissed, {'Milk': DismissDirection.endToStart});
    });

    testWidgets('a swipe uncovers the label on the destructive color', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(const _RowList()));

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Milk')),
      );
      await gesture.moveBy(const Offset(-20, 0));
      await gesture.moveBy(const Offset(-180, 0));
      await tester.pump();

      expect(find.text('Delete'), findsOneWidget);
      final box = tester.widget<ColoredBox>(
        find.ancestor(
          of: find.text('Delete'),
          matching: find.byType(ColoredBox),
        ),
      );
      expect(box.color, VThemeData.light().colors.destructive);

      await gesture.moveBy(const Offset(200, 0));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('Milk'), findsOneWidget);
    });

    testWidgets('a screen reader action named Delete removes the row', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(buildTestWidget(const _RowList()));

      expect(
        tester.getSemantics(find.text('Milk')),
        isSemantics(
          label: 'Milk',
          customActions: [const CustomSemanticsAction(label: 'Delete')],
        ),
      );

      performDismissAction(tester, 'Milk', 'Delete');
      await tester.pumpAndSettle();

      expect(find.text('Milk'), findsNothing);
      expect(find.text('Eggs'), findsOneWidget);
      expect(rowList(tester).dismissed, {'Milk': DismissDirection.endToStart});
      handle.dispose();
    });

    testWidgets('the action reports endToStart for a horizontal row', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestWidget(const _RowList(direction: DismissDirection.horizontal)),
      );

      performDismissAction(tester, 'Eggs', 'Delete');
      await tester.pumpAndSettle();

      expect(rowList(tester).dismissed, {'Eggs': DismissDirection.endToStart});
      handle.dispose();
    });

    testWidgets('confirmDismiss false keeps the row after a swipe', (
      tester,
    ) async {
      final asked = <DismissDirection>[];
      await tester.pumpWidget(
        buildTestWidget(
          _RowList(
            confirmDismiss: (direction) async {
              asked.add(direction);
              return false;
            },
          ),
        ),
      );

      await tester.drag(find.text('Milk'), const Offset(-600, 0));
      await tester.pumpAndSettle();

      expect(asked, [DismissDirection.endToStart]);
      expect(find.text('Milk'), findsOneWidget);
      expect(rowList(tester).dismissed, isEmpty);
    });

    testWidgets('confirmDismiss false keeps the row after the action', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final asked = <DismissDirection>[];
      await tester.pumpWidget(
        buildTestWidget(
          _RowList(
            confirmDismiss: (direction) async {
              asked.add(direction);
              return false;
            },
          ),
        ),
      );

      performDismissAction(tester, 'Milk', 'Delete');
      await tester.pumpAndSettle();

      expect(asked, [DismissDirection.endToStart]);
      expect(find.text('Milk'), findsOneWidget);
      expect(rowList(tester).dismissed, isEmpty);
      handle.dispose();
    });

    testWidgets('confirmDismiss true lets the action remove the row', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestWidget(_RowList(confirmDismiss: (_) async => true)),
      );

      performDismissAction(tester, 'Milk', 'Delete');
      await tester.pumpAndSettle();

      expect(find.text('Milk'), findsNothing);
      handle.dispose();
    });

    testWidgets('dismissLabel names the action and the background', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestWidget(const _RowList(dismissLabel: 'Archive')),
      );

      expect(
        tester.getSemantics(find.text('Milk')),
        isSemantics(
          customActions: [const CustomSemanticsAction(label: 'Archive')],
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Milk')),
      );
      await gesture.moveBy(const Offset(-20, 0));
      await gesture.moveBy(const Offset(-180, 0));
      await tester.pump();
      expect(find.text('Archive'), findsOneWidget);
      await gesture.up();
      await tester.pumpAndSettle();
      handle.dispose();
    });

    testWidgets('the default label comes from VoloLocalizations', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestWidget(
          const _RowList(),
          localizations: const _MarkedLocalizations(),
        ),
      );

      performDismissAction(tester, 'Milk', '[remove]');
      await tester.pumpAndSettle();

      expect(find.text('Milk'), findsNothing);
      handle.dispose();
    });

    testWidgets('DismissDirection.none offers no action', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestWidget(const _RowList(direction: DismissDirection.none)),
      );

      expect(
        tester
            .getSemantics(find.text('Milk'))
            .getSemanticsData()
            .customSemanticsActionIds,
        isEmpty,
      );
      handle.dispose();
    });

    testWidgets('the instance style wins over the theme override', (
      tester,
    ) async {
      const themeColor = Color(0xFF00AA00);
      const instanceColor = Color(0xFF0000AA);
      final theme = VThemeData.light().copyWith(
        componentOverrides: const VComponentOverrides([
          VDismissibleStyle(backgroundColor: themeColor),
        ]),
      );
      Future<Color> swipeColor(VDismissibleStyle? style) async {
        await tester.pumpWidget(
          buildTestWidget(_RowList(style: style), theme: theme),
        );
        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Milk')),
        );
        await gesture.moveBy(const Offset(-20, 0));
        await gesture.moveBy(const Offset(-180, 0));
        await tester.pump();
        final color = tester
            .widget<ColoredBox>(
              find.ancestor(
                of: find.text('Delete'),
                matching: find.byType(ColoredBox),
              ),
            )
            .color;
        await gesture.moveBy(const Offset(200, 0));
        await gesture.up();
        await tester.pumpAndSettle();
        return color;
      }

      expect(await swipeColor(null), themeColor);
      expect(
        await swipeColor(
          const VDismissibleStyle(backgroundColor: instanceColor),
        ),
        instanceColor,
      );
    });
  });
}
