# VTable

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VTable

Table of rows and columns with an optional sortable header or row selection.

The plain constructor only displays data. [VTable.sortable] makes headers
report taps through [onSort], and [VTable.selectable] adds a checkbox column
and reports the new selection through [onSelectionChanged]. Sorting and
selection state live in the caller.

```dart
VTable.sortable(
  columns: const [
    VTableColumn(key: 'name', title: Text('Name'), flex: 2),
    VTableColumn(key: 'email', title: Text('Email'), flex: 3),
  ],
  rows: sortedRows,
  sortColumnKey: sortColumn,
  sortAscending: ascending,
  onSort: (key, {required ascending}) => setState(() {
    sortColumn = key;
    this.ascending = ascending;
    sortedRows = sortRows(rows, key, ascending);
  }),
)
```

### Constructors

#### `VTable`

Creates a read-only table.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `columns` | `List<VTableColumn>` |  | yes | Column definitions, in display order. |
| `rows` | `List<VTableRow>` |  | yes | Row data; an empty list shows the localized no-data message. |
| `headerStyle` | `VTableHeaderStyle?` |  |  | Header height, background and text style. |
| `rowStyle` | `VTableRowStyle?` |  |  | Row height and colors. |
| `border` | `bool` | `true` |  | Whether to draw divider lines between rows. |
| `showHeader` | `bool` | `true` |  | Whether to show the header row. |
| `stickyHeader` | `bool` | `false` |  | Whether the header stays fixed while rows scroll; needs bounded height. |
| `striped` | `bool` | `false` |  | Whether odd rows get a tinted background. |
| `dense` | `bool` | `false` |  | Whether to use compact row height and padding. |
| `style` | `VTableStyle?` |  |  | Per-instance style override merged over the theme's [VTableStyle]. |

#### `VTable.sortable`

Creates a table whose headers report sort requests.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `columns` | `List<VTableColumn>` |  | yes | Column definitions, in display order. |
| `rows` | `List<VTableRow>` |  | yes | Row data; an empty list shows the localized no-data message. |
| `headerStyle` | `VTableHeaderStyle?` |  |  | Header height, background and text style. |
| `rowStyle` | `VTableRowStyle?` |  |  | Row height and colors. |
| `border` | `bool` | `true` |  | Whether to draw divider lines between rows. |
| `showHeader` | `bool` | `true` |  | Whether to show the header row. |
| `stickyHeader` | `bool` | `false` |  | Whether the header stays fixed while rows scroll; needs bounded height. |
| `striped` | `bool` | `false` |  | Whether odd rows get a tinted background. |
| `dense` | `bool` | `false` |  | Whether to use compact row height and padding. |
| `sortColumnKey` | `String?` |  |  | Key of the column the rows are sorted by, if any. |
| `sortAscending` | `bool` | `true` |  | Whether [sortColumnKey] is sorted ascending. |
| `onSort` | `void Function(String, {required bool ascending})?` |  |  | Called with the tapped column key and the requested direction. |
| `style` | `VTableStyle?` |  |  | Per-instance style override merged over the theme's [VTableStyle]. |

#### `VTable.selectable`

Creates a table with a checkbox column for row selection.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `columns` | `List<VTableColumn>` |  | yes | Column definitions, in display order. |
| `rows` | `List<VTableRow>` |  | yes | Row data; an empty list shows the localized no-data message. |
| `headerStyle` | `VTableHeaderStyle?` |  |  | Header height, background and text style. |
| `rowStyle` | `VTableRowStyle?` |  |  | Row height and colors. |
| `border` | `bool` | `true` |  | Whether to draw divider lines between rows. |
| `showHeader` | `bool` | `true` |  | Whether to show the header row. |
| `stickyHeader` | `bool` | `false` |  | Whether the header stays fixed while rows scroll; needs bounded height. |
| `striped` | `bool` | `false` |  | Whether odd rows get a tinted background. |
| `dense` | `bool` | `false` |  | Whether to use compact row height and padding. |
| `selectedRows` | `Set<int>` | `const {}` |  | Indices of the selected rows. |
| `onSelectionChanged` | `void Function(Set<int>)?` |  |  | Called with the new selection when a row or the header checkbox is toggled. |
| `multiSelect` | `bool` | `true` |  | Whether several rows can be selected at once. |
| `style` | `VTableStyle?` |  |  | Per-instance style override merged over the theme's [VTableStyle]. |

## VTableColumn

Column definition for [VTable]: key, header and width.

A column takes a fixed [width] or a share of the remaining space through
[flex].

```dart
const VTableColumn(key: 'name', title: Text('Name'), flex: 2)
```

### Constructors

#### `VTableColumn`

Creates a table column.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Header content, typically a [Text] drawn in the header text style. |
| `width` | `double?` |  |  | Fixed column width; takes precedence over [flex]. |
| `flex` | `int?` |  |  | Share of the remaining width when [width] is null; defaults to 1. |
| `alignment` | `Alignment` | `Alignment.centerLeft` |  | Where cell and header content sits inside the column. |

## VTableRow

Row data for [VTable]: one widget per column key.

```dart
VTableRow(
  cells: {
    'name': const Text('John Doe'),
    'email': const Text('john@example.com'),
  },
  onTap: () => viewUser(),
)
```

### Constructors

#### `VTableRow`

Creates a table row.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `cells` | `Map<String, Widget>` |  | yes | Cell widgets keyed by [VTableColumn.key]; missing keys render empty. |
| `onTap` | `void Function()?` |  |  | Called when the row is tapped; ignored by [VTable.selectable], which toggles selection instead. |

## VTableSortCallback

Signature for [VTable.onSort]: the column [key] and the requested direction.

```dart
typedef VTableSortCallback = void Function(String, {required bool ascending});
```

## VTableHeaderStyle

Header height, background and text style of a [VTable].

```dart
VTableHeaderStyle(
  backgroundColor: colors.muted,
  textStyle: typography.labelMedium,
  height: 48,
)
```

### Constructors

#### `VTableHeaderStyle`

Creates a header style.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background color. |
| `textStyle` | `TextStyle?` |  |  | Text style. |
| `height` | `double` | `48` |  | Height. |

## VTableRowStyle

Row height and colors of a [VTable].

```dart
VTableRowStyle(
  backgroundColor: colors.background,
  selectedColor: colors.accent,
  hoverColor: colors.muted,
  height: 52,
)
```

### Constructors

#### `VTableRowStyle`

Creates a row style.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background color. |
| `selectedColor` | `Color?` |  |  | Selected color. |
| `hoverColor` | `Color?` |  |  | Hover color. |
| `height` | `double` | `52` |  | Height. |

## VTableStyle

Style override for [VTable].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VTableStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `headerBackgroundColor` | `Color?` |  |  | Header row background color. |
| `headerForegroundColor` | `Color?` |  |  | Header row foreground color. |
| `rowBackgroundColor` | `Color?` |  |  | Data row background color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `cellPadding` | `EdgeInsets?` |  |  | Cell internal padding. |
| `headerTextStyle` | `TextStyle?` |  |  | Header text style. |

### Members

| Member | Description |
|---|---|
| `VTableStyle copyWith({Color? headerBackgroundColor, Color? headerForegroundColor, Color? rowBackgroundColor, Color? borderColor, EdgeInsets? cellPadding, TextStyle? headerTextStyle})` | Creates a copy with only the specified properties changed. |
