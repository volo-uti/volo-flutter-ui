import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vTableComponent() => WidgetbookComponent(
  name: 'VTable',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _tablePlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _TableShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _TableSample(),
    ),
  ],
);

Widget _tablePlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_TableVariant>(
    label: 'variant',
    options: _TableVariant.values,
    initialOption: _TableVariant.normal,
    labelBuilder: (v) => v.name,
  );
  final border = k.boolean(label: 'border', initialValue: true);
  final showHeader = k.boolean(label: 'showHeader', initialValue: true);
  final striped = k.boolean(label: 'striped');
  final dense = k.boolean(label: 'dense');
  final ascending = k.boolean(label: 'sortAscending', initialValue: true);
  final multiSelect = k.boolean(label: 'multiSelect', initialValue: true);

  const columns = [
    VTableColumn(key: 'name', title: Text('Name'), flex: 2),
    VTableColumn(key: 'role', title: Text('Role'), flex: 2),
    VTableColumn(key: 'status', title: Text('Status')),
  ];
  const people = [
    ('Alice', 'Designer', 'Active'),
    ('Bob', 'Engineer', 'Away'),
    ('Carol', 'Manager', 'Active'),
  ];
  final rows = [
    for (final (name, role, status) in people)
      VTableRow(
        cells: {'name': Text(name), 'role': Text(role), 'status': Text(status)},
        onTap: () {},
      ),
  ];

  return WidgetbookPlayground(
    child: SizedBox(
      width: 520,
      child: switch (variant) {
        _TableVariant.normal => VTable(
          columns: columns,
          rows: rows,
          border: border,
          showHeader: showHeader,
          striped: striped,
          dense: dense,
        ),
        _TableVariant.sortable => VTable.sortable(
          columns: columns,
          rows: rows,
          border: border,
          showHeader: showHeader,
          striped: striped,
          dense: dense,
          sortColumnKey: 'name',
          sortAscending: ascending,
          onSort: (key, {required ascending}) {},
        ),
        _TableVariant.selectable => VTable.selectable(
          columns: columns,
          rows: rows,
          border: border,
          showHeader: showHeader,
          striped: striped,
          dense: dense,
          selectedRows: const {0},
          multiSelect: multiSelect,
          onSelectionChanged: (_) {},
        ),
      },
    ),
  );
}

enum _TableVariant { normal, sortable, selectable }

// =============================================================================
// Showcase
// =============================================================================

class _TableShowcase extends StatelessWidget {
  const _TableShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VTable',
    description:
        'Displays tabular data with configurable columns, borders, and styling.',
    children: [
      const WidgetbookSection(
        title: 'Basic',
        children: [
          WidgetbookSubsection(
            title: 'default table',
            labels: ['basic'],
            fullWidth: true,
            children: [
              SizedBox(
                height: 220,
                child: VTable(
                  columns: [
                    VTableColumn(key: 'name', title: Text('Name'), flex: 2),
                    VTableColumn(key: 'email', title: Text('Email'), flex: 3),
                    VTableColumn(key: 'role', title: Text('Role'), flex: 1),
                  ],
                  rows: [
                    VTableRow(
                      cells: {
                        'name': Text('John Doe'),
                        'email': Text('hong@example.com'),
                        'role': Text('Admin'),
                      },
                    ),
                    VTableRow(
                      cells: {
                        'name': Text('Bob Smith'),
                        'email': Text('kim@example.com'),
                        'role': Text('User'),
                      },
                    ),
                    VTableRow(
                      cells: {
                        'name': Text('Jane Lee'),
                        'email': Text('lee@example.com'),
                        'role': Text('User'),
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'sortable',
            labels: ['with sorting'],
            fullWidth: true,
            children: [SizedBox(height: 220, child: _SortableTableDemo())],
          ),
          WidgetbookSubsection(
            title: 'selectable',
            labels: ['with selection'],
            fullWidth: true,
            children: [SizedBox(height: 220, child: _SelectableTableDemo())],
          ),
        ],
      ),

      // Usage Guidelines
      _buildUsageGuidelines(context),
    ],
  );

  Widget _buildUsageGuidelines(BuildContext context) {
    final theme = VTheme.of(context);
    return WidgetbookSection(
      title: 'Usage Guidelines',
      children: [
        Table(
          columnWidths: const {0: FixedColumnWidth(120), 1: FlexColumnWidth()},
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: theme.colors.muted,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              children: [
                _tableHeader(theme, 'Category'),
                _tableHeader(theme, 'Guideline'),
              ],
            ),
            _guidelineRow(
              theme,
              'When to use',
              'Display structured data sets like user lists, product inventories, or analytics data.',
            ),
            _guidelineRow(
              theme,
              'When not to use',
              'For simple key-value pairs. Use VListTile or a description list instead.',
            ),
            _guidelineRow(
              theme,
              'Sorting',
              'Enable column sorting for data exploration',
            ),
            _guidelineRow(
              theme,
              'Selection',
              'Add row selection for batch operations',
            ),
          ],
        ),
      ],
    );
  }

  Widget _tableHeader(VThemeData theme, String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Text(
      text,
      style: theme.typography.labelMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colors.foreground,
      ),
    ),
  );

  TableRow _guidelineRow(VThemeData theme, String category, String guideline) =>
      TableRow(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: theme.colors.border)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              category,
              style: theme.typography.labelMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colors.foreground,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              guideline,
              style: theme.typography.bodySmall.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ),
        ],
      );
}

// =============================================================================
// Sample
// =============================================================================

class _TableSample extends StatelessWidget {
  const _TableSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VTable Samples',
    description: 'Copy-ready code examples.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic Usage',
        code: '''VTable(
  columns: [
    VTableColumn(key: 'name', title: Text('Name')),
    VTableColumn(key: 'email', title: Text('Email')),
  ],
  rows: [
    VTableRow(cells: {
      'name': Text('John Doe'),
      'email': Text('hong@example.com'),
    }),
  ],
)''',
        preview: SizedBox(
          height: 100,
          child: VTable(
            columns: [
              VTableColumn(key: 'name', title: Text('Name'), flex: 1),
              VTableColumn(key: 'email', title: Text('Email'), flex: 2),
            ],
            rows: [
              VTableRow(
                cells: {
                  'name': Text('John Doe'),
                  'email': Text('hong@example.com'),
                },
              ),
            ],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Sortable',
        code: '''VTable.sortable(
  columns: [...],
  rows: [...],
  sortColumnKey: 'name',
  sortAscending: true,
  onSort: (key, ascending) { ... },
)''',
        preview: SizedBox(height: 220, child: _SortableTableDemo()),
      ),
      WidgetbookCodeBlock(
        title: 'Selectable',
        code: '''VTable.selectable(
  columns: [...],
  rows: [...],
  selectedRows: selectedSet,
  onSelectionChanged: (rows) { ... },
)''',
        preview: SizedBox(height: 220, child: _SelectableTableDemo()),
      ),
      WidgetbookCodeBlock(
        title: 'User management table',
        code: '''VTable(
  columns: [
    VTableColumn(key: 'name', title: Text('Name'), flex: 2),
    VTableColumn(key: 'email', title: Text('Email'), flex: 3),
    VTableColumn(key: 'role', title: Text('Role'), flex: 1),
    VTableColumn(key: 'status', title: Text('Status'), flex: 1),
  ],
  rows: [
    VTableRow(cells: {
      'name': Text('Alice Kim'),
      'email': Text('alice@example.com'),
      'role': Text('Admin'),
      'status': VBadge.success(label: Text('Active')),
    }),
    VTableRow(cells: {
      'name': Text('Bob Park'),
      'email': Text('bob@example.com'),
      'role': Text('Editor'),
      'status': VBadge.warning(label: Text('Pending')),
    }),
    VTableRow(cells: {
      'name': Text('Charlie Lee'),
      'email': Text('charlie@example.com'),
      'role': Text('Viewer'),
      'status': VBadge.destructive(label: Text('Inactive')),
    }),
  ],
)''',
        preview: SizedBox(
          height: 220,
          child: VTable(
            columns: [
              VTableColumn(key: 'name', title: Text('Name'), flex: 2),
              VTableColumn(key: 'email', title: Text('Email'), flex: 3),
              VTableColumn(key: 'role', title: Text('Role'), flex: 1),
              VTableColumn(key: 'status', title: Text('Status'), flex: 1),
            ],
            rows: [
              VTableRow(
                cells: {
                  'name': Text('Alice Kim'),
                  'email': Text('alice@example.com'),
                  'role': Text('Admin'),
                  'status': VBadge.success(label: Text('Active')),
                },
              ),
              VTableRow(
                cells: {
                  'name': Text('Bob Park'),
                  'email': Text('bob@example.com'),
                  'role': Text('Editor'),
                  'status': VBadge.warning(label: Text('Pending')),
                },
              ),
              VTableRow(
                cells: {
                  'name': Text('Charlie Lee'),
                  'email': Text('charlie@example.com'),
                  'role': Text('Viewer'),
                  'status': VBadge.destructive(label: Text('Inactive')),
                },
              ),
            ],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Sortable columns',
        code: '''VTable.sortable(
  columns: [
    VTableColumn(key: 'product', title: Text('Product'), flex: 2),
    VTableColumn(key: 'price', title: Text('Price'), flex: 1),
    VTableColumn(key: 'stock', title: Text('Stock'), flex: 1),
  ],
  rows: [...],
  sortColumnKey: 'price',
  sortAscending: true,
  onSort: (key, {ascending}) { ... },
)''',
        preview: SizedBox(height: 220, child: _SortableProductTableDemo()),
      ),
      WidgetbookCodeBlock(
        title: 'Empty state',
        code: '''Column(
  children: [
    VTable(
      columns: [
        VTableColumn(key: 'name', title: Text('Name'), flex: 2),
        VTableColumn(key: 'email', title: Text('Email'), flex: 3),
      ],
      rows: [],
    ),
    SizedBox(height: 24),
    Icon(Icons.inbox, size: 48),
    SizedBox(height: 8),
    Text('No data available'),
  ],
)''',
        preview: SizedBox(
          height: 180,
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: VTable(
                  columns: [
                    VTableColumn(key: 'name', title: Text('Name'), flex: 2),
                    VTableColumn(key: 'email', title: Text('Email'), flex: 3),
                  ],
                  rows: [],
                ),
              ),
              SizedBox(height: 24),
              Icon(IconData(0xe156, fontFamily: 'MaterialIcons'), size: 48),
              SizedBox(height: 8),
              Text('No data available'),
            ],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Sortable table',
        code: '''VTable(
  columns: [
    VTableColumn(key: 'name', title: Text('Name'), flex: 2),
    VTableColumn(key: 'role', title: Text('Role'), flex: 2),
    VTableColumn(key: 'status', title: Text('Status'), flex: 1),
  ],
  rows: [
    VTableRow(cells: {'name': Text('Alice'), 'role': Text('Developer'), 'status': Text('Active')}),
    VTableRow(cells: {'name': Text('Bob'), 'role': Text('Designer'), 'status': Text('Away')}),
    VTableRow(cells: {'name': Text('Carol'), 'role': Text('PM'), 'status': Text('Active')}),
  ],
)''',
        preview: SizedBox(
          height: 200,
          child: VTable(
            columns: [
              VTableColumn(key: 'name', title: Text('Name'), flex: 2),
              VTableColumn(key: 'role', title: Text('Role'), flex: 2),
              VTableColumn(key: 'status', title: Text('Status'), flex: 1),
            ],
            rows: [
              VTableRow(
                cells: {
                  'name': Text('Alice'),
                  'role': Text('Developer'),
                  'status': Text('Active'),
                },
              ),
              VTableRow(
                cells: {
                  'name': Text('Bob'),
                  'role': Text('Designer'),
                  'status': Text('Away'),
                },
              ),
              VTableRow(
                cells: {
                  'name': Text('Carol'),
                  'role': Text('PM'),
                  'status': Text('Active'),
                },
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _SortableTableDemo extends StatefulWidget {
  const _SortableTableDemo();

  @override
  State<_SortableTableDemo> createState() => _SortableTableDemoState();
}

class _SortableTableDemoState extends State<_SortableTableDemo> {
  String? _sortKey = 'name';
  bool _ascending = true;

  @override
  Widget build(BuildContext context) => VTable.sortable(
    sortColumnKey: _sortKey,
    sortAscending: _ascending,
    onSort: (key, {bool ascending = true}) {
      setState(() {
        _sortKey = key;
        _ascending = ascending;
      });
    },
    columns: const [
      VTableColumn(key: 'name', title: Text('Name'), flex: 2),
      VTableColumn(key: 'age', title: Text('Age'), flex: 1),
    ],
    rows: const [
      VTableRow(cells: {'name': Text('John Doe'), 'age': Text('30')}),
      VTableRow(cells: {'name': Text('Bob Smith'), 'age': Text('25')}),
      VTableRow(cells: {'name': Text('Jane Lee'), 'age': Text('35')}),
    ],
  );
}

class _SelectableTableDemo extends StatefulWidget {
  const _SelectableTableDemo();

  @override
  State<_SelectableTableDemo> createState() => _SelectableTableDemoState();
}

class _SelectableTableDemoState extends State<_SelectableTableDemo> {
  Set<int> _selectedRows = {};

  @override
  Widget build(BuildContext context) => VTable.selectable(
    selectedRows: _selectedRows,
    onSelectionChanged: (rows) => setState(() => _selectedRows = rows),
    columns: const [
      VTableColumn(key: 'task', title: Text('Task'), flex: 3),
      VTableColumn(key: 'status', title: Text('Status'), flex: 1),
    ],
    rows: const [
      VTableRow(
        cells: {
          'task': Text('Build design system'),
          'status': VBadge.success(label: Text('Done')),
        },
      ),
      VTableRow(
        cells: {
          'task': Text('API development'),
          'status': VBadge.warning(label: Text('In Progress')),
        },
      ),
      VTableRow(
        cells: {
          'task': Text('Write tests'),
          'status': VBadge(label: Text('Pending')),
        },
      ),
    ],
  );
}

class _SortableProductTableDemo extends StatefulWidget {
  const _SortableProductTableDemo();

  @override
  State<_SortableProductTableDemo> createState() =>
      _SortableProductTableDemoState();
}

class _SortableProductTableDemoState extends State<_SortableProductTableDemo> {
  String? _sortKey = 'price';
  bool _ascending = true;

  @override
  Widget build(BuildContext context) => VTable.sortable(
    sortColumnKey: _sortKey,
    sortAscending: _ascending,
    onSort: (key, {bool ascending = true}) {
      setState(() {
        _sortKey = key;
        _ascending = ascending;
      });
    },
    columns: const [
      VTableColumn(key: 'product', title: Text('Product'), flex: 2),
      VTableColumn(key: 'price', title: Text('Price'), flex: 1),
      VTableColumn(key: 'stock', title: Text('Stock'), flex: 1),
    ],
    rows: const [
      VTableRow(
        cells: {
          'product': Text('Wireless Mouse'),
          'price': Text(r'$29.99'),
          'stock': Text('142'),
        },
      ),
      VTableRow(
        cells: {
          'product': Text('Mechanical Keyboard'),
          'price': Text(r'$89.99'),
          'stock': Text('58'),
        },
      ),
      VTableRow(
        cells: {
          'product': Text('USB-C Hub'),
          'price': Text(r'$45.00'),
          'stock': Text('203'),
        },
      ),
    ],
  );
}
