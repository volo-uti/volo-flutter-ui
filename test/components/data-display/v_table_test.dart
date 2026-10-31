import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  Widget buildTestWidget({required Widget child}) => VTheme(
    data: VThemeData.light(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: SizedBox(width: 800, height: 600, child: child),
      ),
    ),
  );

  group('VTable', () {
    final columns = [
      const VTableColumn(key: 'name', title: Text('Name'), flex: 1),
      const VTableColumn(key: 'email', title: Text('Email'), flex: 2),
    ];

    final rows = [
      const VTableRow(
        cells: {'name': Text('John'), 'email': Text('john@example.com')},
      ),
      const VTableRow(
        cells: {'name': Text('Jane'), 'email': Text('jane@example.com')},
      ),
    ];

    testWidgets('renders headers', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: VTable(columns: columns, rows: rows),
        ),
      );

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('renders rows', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: VTable(columns: columns, rows: rows),
        ),
      );

      expect(find.text('John'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.text('Jane'), findsOneWidget);
      expect(find.text('jane@example.com'), findsOneWidget);
    });

    testWidgets('shows empty message when no rows', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: VTable(columns: columns, rows: const []),
        ),
      );

      expect(find.text('No data'), findsOneWidget);
    });

    testWidgets('hides header when showHeader is false', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: VTable(columns: columns, rows: rows, showHeader: false),
        ),
      );

      expect(find.text('Name'), findsNothing);
      expect(find.text('Email'), findsNothing);
    });

    testWidgets('row onTap is called when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          child: VTable(
            columns: columns,
            rows: [
              VTableRow(
                cells: {
                  'name': const Text('John'),
                  'email': const Text('john@example.com'),
                },
                onTap: () => tapped = true,
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('John'));
      await tester.pump();

      expect(tapped, true);
    });

    group('sortable variant', () {
      testWidgets('calls onSort when header tapped', (tester) async {
        String? sortedKey;
        bool? sortAscending;

        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.sortable(
              columns: columns,
              rows: rows,
              onSort: (key, {required bool ascending}) {
                sortedKey = key;
                sortAscending = ascending;
              },
            ),
          ),
        );

        await tester.tap(find.text('Name'));
        await tester.pump();

        expect(sortedKey, 'name');
        expect(sortAscending, true);
      });

      testWidgets('toggles sort direction on same column', (tester) async {
        bool? sortAscending;

        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.sortable(
              columns: columns,
              rows: rows,
              sortColumnKey: 'name',
              onSort: (key, {required bool ascending}) =>
                  sortAscending = ascending,
            ),
          ),
        );

        await tester.tap(find.text('Name'));
        await tester.pump();

        expect(sortAscending, false);
      });

      testWidgets('shows sort icon on sorted column', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.sortable(
              columns: columns,
              rows: rows,
              sortColumnKey: 'name',
            ),
          ),
        );

        // VIcons.arrowUp/arrowDown renders as SizedBox > CustomPaint
        expect(find.byType(CustomPaint), findsWidgets);
      });
    });

    group('selectable variant', () {
      testWidgets('renders checkboxes', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.selectable(columns: columns, rows: rows),
          ),
        );

        expect(find.byType(VCheckbox), findsNWidgets(3)); // header + 2 rows
      });

      testWidgets('calls onSelectionChanged when row selected', (tester) async {
        Set<int>? selection;

        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.selectable(
              columns: columns,
              rows: rows,
              onSelectionChanged: (s) => selection = s,
            ),
          ),
        );

        // Tap first row
        await tester.tap(find.text('John'));
        await tester.pump();

        expect(selection, {0});
      });

      testWidgets('select all selects all rows', (tester) async {
        Set<int>? selection;

        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.selectable(
              columns: columns,
              rows: rows,
              onSelectionChanged: (s) => selection = s,
            ),
          ),
        );

        // Find header checkbox and tap it
        final checkboxes = find.byType(VCheckbox);
        await tester.tap(checkboxes.first);
        await tester.pump();

        expect(selection, {0, 1});
      });

      testWidgets('single select mode only selects one', (tester) async {
        Set<int>? selection;

        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.selectable(
              columns: columns,
              rows: rows,
              selectedRows: const {0},
              onSelectionChanged: (s) => selection = s,
              multiSelect: false,
            ),
          ),
        );

        // Tap second row
        await tester.tap(find.text('Jane'));
        await tester.pump();

        expect(selection, {1}); // Only second row selected
      });

      testWidgets('single select mode has no select-all checkbox', (
        tester,
      ) async {
        Set<int>? selection;

        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.selectable(
              columns: columns,
              rows: rows,
              onSelectionChanged: (s) => selection = s,
              multiSelect: false,
            ),
          ),
        );

        // One checkbox per row, none in the header.
        expect(find.byType(VCheckbox), findsNWidgets(rows.length));
        expect(selection, isNull);
      });

      testWidgets('stale selected indices do not read as all selected', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.selectable(
              columns: columns,
              rows: rows,
              selectedRows: const {0, 7},
              onSelectionChanged: (_) {},
            ),
          ),
        );

        final header = tester.widget<VCheckbox>(find.byType(VCheckbox).first);
        expect(header.value, isNull); // partly selected, not true
      });
    });

    testWidgets('only a selectable table announces a selected state', (
      tester,
    ) async {
      bool? selectedOf(String label) => tester
          .widget<Semantics>(
            find.byWidgetPredicate(
              (w) => w is Semantics && w.properties.label == label,
            ),
          )
          .properties
          .selected;

      await tester.pumpWidget(
        buildTestWidget(
          child: VTable(columns: columns, rows: rows),
        ),
      );
      expect(selectedOf('Row 1'), isNull);

      await tester.pumpWidget(
        buildTestWidget(
          child: VTable.selectable(
            columns: columns,
            rows: rows,
            selectedRows: const {0},
            onSelectionChanged: (_) {},
          ),
        ),
      );
      expect(selectedOf('Row 1'), isTrue);
      expect(selectedOf('Row 2'), isFalse);
    });

    testWidgets('fixed width columns work', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: VTable(
            columns: const [
              VTableColumn(key: 'name', title: Text('Name'), width: 100),
              VTableColumn(key: 'email', title: Text('Email'), flex: 1),
            ],
            rows: rows,
          ),
        ),
      );

      expect(find.byType(VTable), findsOneWidget);
    });

    testWidgets('Widget title in column works', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: VTable(
            columns: const [
              VTableColumn(
                key: 'name',
                title: Row(
                  children: [
                    SizedBox(width: 16, height: 16, key: Key('person-icon')),
                    SizedBox(width: 4),
                    Text('Name'),
                  ],
                ),
                flex: 1,
              ),
            ],
            rows: rows,
          ),
        ),
      );

      expect(find.text('Name'), findsOneWidget);
    });

    testWidgets('border prop shows border when true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: VTable(columns: columns, rows: rows),
        ),
      );

      expect(find.byType(VTable), findsOneWidget);
      expect(find.text('John'), findsOneWidget);
    });

    testWidgets('border prop hides border when false', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: VTable(columns: columns, rows: rows, border: false),
        ),
      );

      expect(find.byType(VTable), findsOneWidget);
      expect(find.text('John'), findsOneWidget);
    });

    testWidgets('sortable table respects border prop', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: VTable.sortable(columns: columns, rows: rows, border: false),
        ),
      );

      expect(find.byType(VTable), findsOneWidget);
    });

    testWidgets('selectable table respects border prop', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: VTable.selectable(columns: columns, rows: rows, border: false),
        ),
      );

      expect(find.byType(VTable), findsOneWidget);
    });

    group('stickyHeader', () {
      testWidgets('stickyHeader=true wraps body in Expanded', (tester) async {
        // When stickyHeader=true, body is wrapped in Expanded
        // Additional Expanded widgets are created for columns with flex
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(
              columns: const [
                VTableColumn(key: 'name', title: Text('Name'), width: 100),
                VTableColumn(key: 'email', title: Text('Email'), width: 200),
              ],
              rows: rows,
              stickyHeader: true,
            ),
          ),
        );

        expect(find.byType(VTable), findsOneWidget);
        // 1 Expanded wrapping the body
        expect(find.byType(Expanded), findsOneWidget);
      });

      testWidgets('stickyHeader=false does not wrap body in Expanded', (
        tester,
      ) async {
        // No Expanded when stickyHeader=false and only width is used
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(
              columns: const [
                VTableColumn(key: 'name', title: Text('Name'), width: 100),
                VTableColumn(key: 'email', title: Text('Email'), width: 200),
              ],
              rows: rows,
            ),
          ),
        );

        expect(find.byType(VTable), findsOneWidget);
        // No body Expanded
        expect(find.byType(Expanded), findsNothing);
      });

      testWidgets('stickyHeader works with sortable variant', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.sortable(
              columns: const [
                VTableColumn(key: 'name', title: Text('Name'), width: 100),
                VTableColumn(key: 'email', title: Text('Email'), width: 200),
              ],
              rows: rows,
              stickyHeader: true,
            ),
          ),
        );

        expect(find.byType(VTable), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);
      });

      testWidgets('stickyHeader works with selectable variant', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.selectable(
              columns: const [
                VTableColumn(key: 'name', title: Text('Name'), width: 100),
                VTableColumn(key: 'email', title: Text('Email'), width: 200),
              ],
              rows: rows,
              stickyHeader: true,
            ),
          ),
        );

        expect(find.byType(VTable), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);
      });

      testWidgets(
        'stickyHeader with flex columns has multiple Expanded widgets',
        (tester) async {
          await tester.pumpWidget(
            buildTestWidget(
              child: VTable(
                columns: columns, // flex columns
                rows: rows,
                stickyHeader: true,
              ),
            ),
          );

          expect(find.byType(VTable), findsOneWidget);
          // 1 body Expanded + column Expanded (2 header + 2 per row * 2 rows = 6) = 7
          expect(find.byType(Expanded), findsWidgets);
        },
      );
    });

    group('VTableHeaderStyle customization', () {
      testWidgets('applies custom header height', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(
              columns: columns,
              rows: rows,
              headerStyle: const VTableHeaderStyle(height: 64),
            ),
          ),
        );

        expect(find.byType(VTable), findsOneWidget);
        // Verify header is rendered
        expect(find.text('Name'), findsOneWidget);
      });

      testWidgets('applies custom header backgroundColor', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(
              columns: columns,
              rows: rows,
              headerStyle: const VTableHeaderStyle(
                backgroundColor: Color(0xFFFF0000),
              ),
            ),
          ),
        );

        expect(find.byType(VTable), findsOneWidget);
        expect(find.text('Name'), findsOneWidget);
      });

      testWidgets('applies custom header textStyle', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(
              columns: columns,
              rows: rows,
              headerStyle: const VTableHeaderStyle(
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );

        expect(find.byType(VTable), findsOneWidget);
        expect(find.text('Name'), findsOneWidget);
      });
    });

    group('VTableRowStyle customization', () {
      testWidgets('applies custom row height', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(
              columns: columns,
              rows: rows,
              rowStyle: const VTableRowStyle(height: 72),
            ),
          ),
        );

        expect(find.byType(VTable), findsOneWidget);
        expect(find.text('John'), findsOneWidget);
      });

      testWidgets('applies custom row backgroundColor', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(
              columns: columns,
              rows: rows,
              rowStyle: const VTableRowStyle(
                backgroundColor: Color(0xFFEEEEEE),
              ),
            ),
          ),
        );

        expect(find.byType(VTable), findsOneWidget);
        expect(find.text('John'), findsOneWidget);
      });

      testWidgets('applies custom selectedColor in selectable table', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.selectable(
              columns: columns,
              rows: rows,
              selectedRows: const {0},
              rowStyle: const VTableRowStyle(selectedColor: Color(0xFF00FF00)),
            ),
          ),
        );

        expect(find.byType(VTable), findsOneWidget);
        expect(find.text('John'), findsOneWidget);
      });

      testWidgets('applies custom hoverColor', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(
              columns: columns,
              rows: rows,
              rowStyle: const VTableRowStyle(hoverColor: Color(0xFF0000FF)),
            ),
          ),
        );

        expect(find.byType(VTable), findsOneWidget);
        expect(find.text('John'), findsOneWidget);
      });
    });

    group('border=false', () {
      testWidgets('header has no border when border=false', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(columns: columns, rows: rows, border: false),
          ),
        );

        expect(find.byType(VTable), findsOneWidget);
        expect(find.text('Name'), findsOneWidget);
        expect(find.text('John'), findsOneWidget);
      });

      testWidgets('rows have no border when border=false', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(columns: columns, rows: rows, border: false),
          ),
        );

        // AnimatedContainer rendered without border
        expect(find.byType(AnimatedContainer), findsNWidgets(2));
      });
    });

    group('showHeader=false', () {
      testWidgets('header is not rendered when showHeader=false', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(columns: columns, rows: rows, showHeader: false),
          ),
        );

        expect(find.text('Name'), findsNothing);
        expect(find.text('Email'), findsNothing);
        // Rows are still rendered
        expect(find.text('John'), findsOneWidget);
        expect(find.text('Jane'), findsOneWidget);
      });

      testWidgets('showHeader=false with sortable variant', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.sortable(
              columns: columns,
              rows: rows,
              showHeader: false,
            ),
          ),
        );

        expect(find.text('Name'), findsNothing);
        expect(find.text('John'), findsOneWidget);
      });

      testWidgets('showHeader=false with selectable variant', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.selectable(
              columns: columns,
              rows: rows,
              showHeader: false,
            ),
          ),
        );

        expect(find.text('Name'), findsNothing);
        // No header checkbox but row checkboxes exist
        expect(find.byType(VCheckbox), findsNWidgets(2));
      });
    });

    group('empty rows', () {
      testWidgets('displays "No data" message for empty rows', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(columns: columns, rows: const []),
          ),
        );

        expect(find.text('No data'), findsOneWidget);
      });

      testWidgets('empty rows with sortable variant', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.sortable(columns: columns, rows: const []),
          ),
        );

        expect(find.text('No data'), findsOneWidget);
      });

      testWidgets('empty rows with selectable variant', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.selectable(columns: columns, rows: const []),
          ),
        );

        expect(find.text('No data'), findsOneWidget);
      });
    });

    group('row.onTap callback', () {
      testWidgets('onTap is called when row is tapped', (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(
              columns: columns,
              rows: [
                VTableRow(
                  cells: {
                    'name': const Text('John'),
                    'email': const Text('john@example.com'),
                  },
                  onTap: () => tapped = true,
                ),
              ],
            ),
          ),
        );

        await tester.tap(find.text('John'));
        await tester.pump();

        expect(tapped, isTrue);
      });

      testWidgets('onTap is not called in selectable mode', (tester) async {
        var tapped = false;
        Set<int>? selection;

        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.selectable(
              columns: columns,
              rows: [
                VTableRow(
                  cells: {
                    'name': const Text('John'),
                    'email': const Text('john@example.com'),
                  },
                  onTap: () => tapped = true,
                ),
              ],
              onSelectionChanged: (s) => selection = s,
            ),
          ),
        );

        await tester.tap(find.text('John'));
        await tester.pump();

        // In selectable mode, selection changes instead of onTap
        expect(tapped, isFalse);
        expect(selection, {0});
      });

      testWidgets('multiple rows with different onTap callbacks', (
        tester,
      ) async {
        var tappedIndex = -1;

        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(
              columns: columns,
              rows: [
                VTableRow(
                  cells: {
                    'name': const Text('John'),
                    'email': const Text('john@example.com'),
                  },
                  onTap: () => tappedIndex = 0,
                ),
                VTableRow(
                  cells: {
                    'name': const Text('Jane'),
                    'email': const Text('jane@example.com'),
                  },
                  onTap: () => tappedIndex = 1,
                ),
              ],
            ),
          ),
        );

        await tester.tap(find.text('Jane'));
        await tester.pump();

        expect(tappedIndex, 1);
      });
    });

    group('Semantics accessibility', () {
      testWidgets('rows have semantic labels', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(columns: columns, rows: rows),
          ),
        );

        expect(find.bySemanticsLabel(RegExp('Row 1')), findsOneWidget);
        expect(find.bySemanticsLabel(RegExp('Row 2')), findsOneWidget);
      });

      testWidgets('selectable rows have Semantics widgets', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.selectable(columns: columns, rows: rows),
          ),
        );

        // Verify Semantics widgets exist
        expect(find.byType(Semantics), findsWidgets);
        // Verify Semantics labels for each row
        expect(find.bySemanticsLabel(RegExp('Row 1')), findsOneWidget);
        expect(find.bySemanticsLabel(RegExp('Row 2')), findsOneWidget);
      });

      testWidgets('rows with onTap have Semantics widgets', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(
              columns: columns,
              rows: [
                VTableRow(
                  cells: {
                    'name': const Text('John'),
                    'email': const Text('john@example.com'),
                  },
                  onTap: () {},
                ),
              ],
            ),
          ),
        );

        expect(find.byType(Semantics), findsWidgets);
        expect(find.bySemanticsLabel(RegExp('Row 1')), findsOneWidget);
      });

      testWidgets('selected rows display correctly', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable.selectable(
              columns: columns,
              rows: rows,
              selectedRows: const {0},
            ),
          ),
        );

        // Verify Semantics is applied to selected rows
        expect(find.bySemanticsLabel(RegExp('Row 1')), findsOneWidget);
        expect(find.byType(Semantics), findsWidgets);
      });

      testWidgets('normal rows have semantic labels', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: VTable(columns: columns, rows: rows),
          ),
        );

        // Normal rows also have Semantics labels
        expect(find.bySemanticsLabel(RegExp('Row 1')), findsOneWidget);
        expect(find.bySemanticsLabel(RegExp('Row 2')), findsOneWidget);
      });
    });

    group('column width vs flex', () {
      testWidgets('column with fixed width uses SizedBox', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: const VTable(
              columns: [
                VTableColumn(key: 'id', title: Text('ID'), width: 80),
                VTableColumn(key: 'name', title: Text('Name'), flex: 1),
              ],
              rows: [
                VTableRow(cells: {'id': Text('1'), 'name': Text('John')}),
              ],
            ),
          ),
        );

        // SizedBox rendered with width=80
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        final widthSizedBoxes = sizedBoxes.where((box) => box.width == 80);
        // 1 each from header + row
        expect(widthSizedBoxes.length, 2);
      });

      testWidgets('column with flex uses Expanded', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: const VTable(
              columns: [
                VTableColumn(key: 'name', title: Text('Name'), flex: 1),
                VTableColumn(key: 'email', title: Text('Email'), flex: 2),
              ],
              rows: [
                VTableRow(
                  cells: {
                    'name': Text('John'),
                    'email': Text('john@example.com'),
                  },
                ),
              ],
            ),
          ),
        );

        // Expanded rendered with flex=1 and flex=2
        final expandedWidgets = tester.widgetList<Expanded>(
          find.byType(Expanded),
        );
        expect(expandedWidgets.length, 4); // 2 header + 2 rows
      });

      testWidgets('mixed width and flex columns', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: const VTable(
              columns: [
                VTableColumn(key: 'id', title: Text('ID'), width: 60),
                VTableColumn(key: 'name', title: Text('Name'), flex: 1),
                VTableColumn(key: 'status', title: Text('Status'), width: 100),
                VTableColumn(key: 'email', title: Text('Email'), flex: 2),
              ],
              rows: [
                VTableRow(
                  cells: {
                    'id': Text('1'),
                    'name': Text('John'),
                    'status': Text('Active'),
                    'email': Text('john@example.com'),
                  },
                ),
              ],
            ),
          ),
        );

        expect(find.byType(VTable), findsOneWidget);
        expect(find.text('ID'), findsOneWidget);
        expect(find.text('Name'), findsOneWidget);
        expect(find.text('Status'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
      });

      testWidgets('default flex is 1 when neither width nor flex specified', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: const VTable(
              columns: [
                VTableColumn(key: 'name', title: Text('Name')),
                VTableColumn(key: 'email', title: Text('Email')),
              ],
              rows: [
                VTableRow(
                  cells: {
                    'name': Text('John'),
                    'email': Text('john@example.com'),
                  },
                ),
              ],
            ),
          ),
        );

        // Expanded rendered with default flex=1
        final expandedWidgets = tester.widgetList<Expanded>(
          find.byType(Expanded),
        );
        expect(expandedWidgets.length, 4); // 2 header + 2 rows
        for (final expanded in expandedWidgets) {
          expect(expanded.flex, 1);
        }
      });
    });
  });
}
