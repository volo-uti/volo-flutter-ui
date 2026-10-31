import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_checkbox/v_checkbox.dart';
import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_table_style.dart';

/// Column definition for [VTable]: key, header and width.
///
/// A column takes a fixed [width] or a share of the remaining space through
/// [flex].
///
/// ```dart
/// const VTableColumn(key: 'name', title: Text('Name'), flex: 2)
/// ```
class VTableColumn {
  /// Creates a table column.
  const VTableColumn({
    required this.key,
    required this.title,
    this.width,
    this.flex,
    this.alignment = Alignment.centerLeft,
  });

  /// Identifier that links the column to the keys of [VTableRow.cells].
  final String key;

  /// Header content, typically a [Text] drawn in the header text style.
  final Widget title;

  /// Fixed column width; takes precedence over [flex].
  final double? width;

  /// Share of the remaining width when [width] is null; defaults to 1.
  final int? flex;

  /// Where cell and header content sits inside the column.
  final Alignment alignment;
}

/// Row data for [VTable]: one widget per column key.
///
/// ```dart
/// VTableRow(
///   cells: {
///     'name': const Text('John Doe'),
///     'email': const Text('john@example.com'),
///   },
///   onTap: () => viewUser(),
/// )
/// ```
class VTableRow {
  /// Creates a table row.
  const VTableRow({required this.cells, this.onTap});

  /// Cell widgets keyed by [VTableColumn.key]; missing keys render empty.
  final Map<String, Widget> cells;

  /// Called when the row is tapped; ignored by [VTable.selectable], which toggles selection instead.
  final VoidCallback? onTap;
}

/// Table of rows and columns with an optional sortable header or row selection.
///
/// The plain constructor only displays data. [VTable.sortable] makes headers
/// report taps through [onSort], and [VTable.selectable] adds a checkbox column
/// and reports the new selection through [onSelectionChanged]. Sorting and
/// selection state live in the caller.
///
/// ```dart
/// VTable.sortable(
///   columns: const [
///     VTableColumn(key: 'name', title: Text('Name'), flex: 2),
///     VTableColumn(key: 'email', title: Text('Email'), flex: 3),
///   ],
///   rows: sortedRows,
///   sortColumnKey: sortColumn,
///   sortAscending: ascending,
///   onSort: (key, {required ascending}) => setState(() {
///     sortColumn = key;
///     this.ascending = ascending;
///     sortedRows = sortRows(rows, key, ascending);
///   }),
/// )
/// ```
class VTable extends StatefulWidget {
  /// Creates a read-only table.
  const VTable({
    required this.columns,
    required this.rows,
    super.key,
    this.headerStyle,
    this.rowStyle,
    this.border = true,
    this.showHeader = true,
    this.stickyHeader = false,
    this.striped = false,
    this.dense = false,
    this.style,
  }) : _variant = _VTableVariant.normal,
       sortColumnKey = null,
       sortAscending = true,
       onSort = null,
       selectedRows = const {},
       onSelectionChanged = null,
       multiSelect = true;

  /// Creates a table whose headers report sort requests.
  const VTable.sortable({
    required this.columns,
    required this.rows,
    super.key,
    this.headerStyle,
    this.rowStyle,
    this.border = true,
    this.showHeader = true,
    this.stickyHeader = false,
    this.striped = false,
    this.dense = false,
    this.sortColumnKey,
    this.sortAscending = true,
    this.onSort,
    this.style,
  }) : _variant = _VTableVariant.sortable,
       selectedRows = const {},
       onSelectionChanged = null,
       multiSelect = true;

  /// Creates a table with a checkbox column for row selection.
  const VTable.selectable({
    required this.columns,
    required this.rows,
    super.key,
    this.headerStyle,
    this.rowStyle,
    this.border = true,
    this.showHeader = true,
    this.stickyHeader = false,
    this.striped = false,
    this.dense = false,
    this.selectedRows = const {},
    this.onSelectionChanged,
    this.multiSelect = true,
    this.style,
  }) : _variant = _VTableVariant.selectable,
       sortColumnKey = null,
       sortAscending = true,
       onSort = null;

  final _VTableVariant _variant;

  /// Column definitions, in display order.
  final List<VTableColumn> columns;

  /// Row data; an empty list shows the localized no-data message.
  final List<VTableRow> rows;

  /// Header height, background and text style.
  final VTableHeaderStyle? headerStyle;

  /// Row height and colors.
  final VTableRowStyle? rowStyle;

  /// Whether to draw divider lines between rows.
  final bool border;

  /// Whether to show the header row.
  final bool showHeader;

  /// Whether the header stays fixed while rows scroll; needs bounded height.
  final bool stickyHeader;

  /// Whether odd rows get a tinted background.
  final bool striped;

  /// Whether to use compact row height and padding.
  final bool dense;

  /// Key of the column the rows are sorted by, if any.
  final String? sortColumnKey;

  /// Whether [sortColumnKey] is sorted ascending.
  final bool sortAscending;

  /// Called with the tapped column key and the requested direction.
  final VTableSortCallback? onSort;

  /// Indices of the selected rows.
  final Set<int> selectedRows;

  /// Called with the new selection when a row or the header checkbox is toggled.
  final ValueChanged<Set<int>>? onSelectionChanged;

  /// Whether several rows can be selected at once.
  final bool multiSelect;

  /// Per-instance style override merged over the theme's [VTableStyle].
  final VTableStyle? style;

  @override
  State<VTable> createState() => _VTableState();
}

/// Signature for [VTable.onSort]: the column [key] and the requested direction.
typedef VTableSortCallback =
    void Function(String key, {required bool ascending});

enum _VTableVariant { normal, sortable, selectable }

/// Header height, background and text style of a [VTable].
///
/// ```dart
/// VTableHeaderStyle(
///   backgroundColor: colors.muted,
///   textStyle: typography.labelMedium,
///   height: 48,
/// )
/// ```
class VTableHeaderStyle {
  /// Creates a header style.
  const VTableHeaderStyle({
    this.backgroundColor,
    this.textStyle,
    this.height = 48,
  });

  /// Background color.
  final Color? backgroundColor;

  /// Text style.
  final TextStyle? textStyle;

  /// Height.
  final double height;
}

/// Row height and colors of a [VTable].
///
/// ```dart
/// VTableRowStyle(
///   backgroundColor: colors.background,
///   selectedColor: colors.accent,
///   hoverColor: colors.muted,
///   height: 52,
/// )
/// ```
class VTableRowStyle {
  /// Creates a row style.
  const VTableRowStyle({
    this.backgroundColor,
    this.selectedColor,
    this.hoverColor,
    this.height = 52,
  });

  /// Background color.
  final Color? backgroundColor;

  /// Selected color.
  final Color? selectedColor;

  /// Hover color.
  final Color? hoverColor;

  /// Height.
  final double height;
}

class _VTableState extends State<VTable> {
  int? _hoveredRow;

  void _handleSort(String key) {
    if (widget._variant != _VTableVariant.sortable) return;
    if (widget.onSort == null) return;

    if (widget.sortColumnKey == key) {
      widget.onSort!(key, ascending: !widget.sortAscending);
    } else {
      widget.onSort!(key, ascending: true);
    }
  }

  void _handleRowSelect(int index) {
    if (widget._variant != _VTableVariant.selectable) return;
    if (widget.onSelectionChanged == null) return;

    final newSelection = Set<int>.from(widget.selectedRows);

    if (widget.multiSelect) {
      if (newSelection.contains(index)) {
        newSelection.remove(index);
      } else {
        newSelection.add(index);
      }
    } else {
      if (newSelection.contains(index)) {
        newSelection.clear();
      } else {
        newSelection
          ..clear()
          ..add(index);
      }
    }

    widget.onSelectionChanged!(newSelection);
  }

  void _handleSelectAll(bool? value) {
    if (widget.onSelectionChanged == null) return;
    // Selecting every row would break the single-selection contract.
    if (!widget.multiSelect) return;

    if (value ?? false) {
      widget.onSelectionChanged!(
        Set.from(List.generate(widget.rows.length, (i) => i)),
      );
    } else {
      widget.onSelectionChanged!({});
    }
  }

  Widget _buildHeaderCell(
    VTableColumn column,
    VColors colors,
    VTypography typography, {
    VTableStyle? resolvedStyle,
  }) {
    final headerFg =
        resolvedStyle?.headerForegroundColor ?? colors.mutedForeground;
    Widget content;
    content = DefaultTextStyle.merge(
      style:
          resolvedStyle?.headerTextStyle ??
          widget.headerStyle?.textStyle ??
          typography.labelMedium.copyWith(color: headerFg),
      child: column.title,
    );

    // Add sort icon
    if (widget._variant == _VTableVariant.sortable) {
      final isSorted = widget.sortColumnKey == column.key;
      content = GestureDetector(
        onTap: () => _handleSort(column.key),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            content,
            if (isSorted) ...[
              SizedBox(width: VTheme.of(context).spacing.xs),
              if (widget.sortAscending)
                VIcons.arrowUp(
                  size: VTheme.of(context).sizes.xs.iconSize,
                  color: colors.foreground,
                )
              else
                VIcons.arrowDown(
                  size: VTheme.of(context).sizes.xs.iconSize,
                  color: colors.foreground,
                ),
            ],
          ],
        ),
      );
    }

    return Align(alignment: column.alignment, child: content);
  }

  Widget _buildCell(VTableColumn column, VTableRow row, VColors colors) {
    final cell = row.cells[column.key];
    return Align(
      alignment: column.alignment,
      child: cell ?? const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VTableStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;
    final colors = theme.colors;
    final typography = theme.typography;

    if (widget.rows.isEmpty) {
      return FocusTraversalGroup(
        child: Container(
          padding: EdgeInsets.all(theme.spacing.xxxl),
          alignment: Alignment.center,
          child: Text(
            VoloLocalizations.of(context).tableNoData,
            style: typography.bodyMedium.copyWith(
              color: colors.mutedForeground,
            ),
          ),
        ),
      );
    }

    // Build header
    Widget? header;
    if (widget.showHeader) {
      final headerCells = <Widget>[];

      if (widget._variant == _VTableVariant.selectable) {
        // Stale indices left over after rows shrank must not read as "all".
        final allSelected = List<int>.generate(
          widget.rows.length,
          (i) => i,
        ).every(widget.selectedRows.contains);
        final someSelected = widget.selectedRows.isNotEmpty && !allSelected;

        headerCells.add(
          SizedBox(
            width: theme.sizes.lg.height,
            // Single selection has no select-all; the cell stays empty so the
            // columns keep lining up with the rows.
            child: widget.multiSelect
                ? Center(
                    child: VCheckbox(
                      value: allSelected ? true : (someSelected ? null : false),
                      onChanged: _handleSelectAll,
                    ),
                  )
                : null,
          ),
        );
      }

      for (final column in widget.columns) {
        var cell = _buildHeaderCell(
          column,
          colors,
          typography,
          resolvedStyle: resolvedStyle,
        );

        if (column.width != null) {
          cell = SizedBox(width: column.width, child: cell);
        } else {
          cell = Expanded(flex: column.flex ?? 1, child: cell);
        }

        headerCells.add(cell);
      }

      header = Container(
        height: widget.headerStyle?.height ?? theme.sizes.lg.height,
        padding:
            resolvedStyle?.cellPadding ??
            EdgeInsets.symmetric(horizontal: theme.spacing.lg),
        decoration: BoxDecoration(
          color:
              resolvedStyle?.headerBackgroundColor ??
              widget.headerStyle?.backgroundColor ??
              colors.muted,
          border: widget.border
              ? Border(
                  bottom: BorderSide(
                    color: resolvedStyle?.borderColor ?? colors.border,
                  ),
                )
              : null,
        ),
        child: Row(children: headerCells),
      );
    }

    // Build rows
    Widget buildRow(int index) {
      final row = widget.rows[index];
      final isSelected = widget.selectedRows.contains(index);
      final isHovered = _hoveredRow == index;

      Color bgColor;
      if (isSelected) {
        bgColor = widget.rowStyle?.selectedColor ?? colors.accent;
      } else if (isHovered) {
        bgColor =
            widget.rowStyle?.hoverColor ?? colors.muted.withValues(alpha: 0.5);
      } else if (widget.striped && index.isOdd) {
        bgColor = colors.muted.withValues(alpha: 0.3);
      } else {
        bgColor =
            resolvedStyle?.rowBackgroundColor ??
            widget.rowStyle?.backgroundColor ??
            VColors.transparent;
      }

      final rowCells = <Widget>[];

      if (widget._variant == _VTableVariant.selectable) {
        rowCells.add(
          SizedBox(
            width: theme.sizes.lg.height,
            child: Center(
              child: VCheckbox(
                value: isSelected,
                onChanged: (_) => _handleRowSelect(index),
              ),
            ),
          ),
        );
      }

      for (final column in widget.columns) {
        var cell = _buildCell(column, row, colors);

        if (column.width != null) {
          cell = SizedBox(width: column.width, child: cell);
        } else {
          cell = Expanded(flex: column.flex ?? 1, child: cell);
        }

        rowCells.add(cell);
      }

      final Widget rowWidget = Semantics(
        button:
            widget._variant == _VTableVariant.selectable || row.onTap != null,
        // Only a selectable table has a selected state to announce.
        selected: widget._variant == _VTableVariant.selectable
            ? isSelected
            : null,
        label: VoloLocalizations.of(context).tableRowLabel(index + 1),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hoveredRow = index),
          onExit: (_) => setState(() => _hoveredRow = null),
          child: GestureDetector(
            onTap: () {
              if (widget._variant == _VTableVariant.selectable) {
                _handleRowSelect(index);
              } else {
                row.onTap?.call();
              }
            },
            child: AnimatedContainer(
              duration: theme.animations.fast,
              height: widget.dense
                  ? (widget.rowStyle?.height ?? theme.sizes.md.height)
                  : (widget.rowStyle?.height ??
                        (theme.sizes.lg.height + theme.spacing.xs)),
              padding:
                  resolvedStyle?.cellPadding ??
                  EdgeInsets.symmetric(
                    horizontal: widget.dense
                        ? theme.spacing.md
                        : theme.spacing.lg,
                  ),
              decoration: BoxDecoration(
                color: bgColor,
                border: widget.border
                    ? Border(
                        bottom: BorderSide(
                          color: (resolvedStyle?.borderColor ?? colors.border)
                              .withValues(alpha: 0.5),
                        ),
                      )
                    : null,
              ),
              child: Row(children: rowCells),
            ),
          ),
        ),
      );

      return rowWidget;
    }

    final Widget body = ListView.builder(
      shrinkWrap: !widget.stickyHeader,
      itemCount: widget.rows.length,
      itemBuilder: (context, index) => buildRow(index),
    );

    if (widget.stickyHeader && header != null) {
      return FocusTraversalGroup(
        child: Column(
          children: [
            header,
            Expanded(child: body),
          ],
        ),
      );
    }

    return FocusTraversalGroup(
      child: Column(mainAxisSize: MainAxisSize.min, children: [?header, body]),
    );
  }
}
