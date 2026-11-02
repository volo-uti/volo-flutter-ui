import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vDismissibleComponent() => WidgetbookComponent(
  name: 'VDismissible',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _dismissiblePlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _DismissibleShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _DismissibleSample(),
    ),
  ],
);

Widget _dismissiblePlayground(BuildContext context) {
  final k = context.knobs;
  final direction = k.object.dropdown<DismissDirection>(
    label: 'direction',
    options: DismissDirection.values,
    initialOption: DismissDirection.endToStart,
    labelBuilder: (v) => v.name,
  );
  final dismissLabel = k.string(label: 'dismissLabel');
  final confirm = k.boolean(label: 'confirmDismiss (keeps the row)');

  return WidgetbookPlayground(
    layout: PlaygroundLayout.stretch,
    info: ['direction: ${direction.name}'],
    child: _RowList(
      // A new key restarts the list when a knob changes.
      key: ValueKey((direction, dismissLabel, confirm)),
      direction: direction,
      dismissLabel: dismissLabel.isEmpty ? null : dismissLabel,
      confirmDismiss: confirm ? (_) async => false : null,
    ),
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _RowList extends StatefulWidget {
  const _RowList({
    super.key,
    this.direction = DismissDirection.endToStart,
    this.dismissLabel,
    this.confirmDismiss,
    this.background,
    this.askFirst = false,
  });

  final DismissDirection direction;
  final String? dismissLabel;
  final ConfirmDismissCallback? confirmDismiss;
  final Widget? background;

  /// Confirms each dismissal in a VAlertDialog.
  final bool askFirst;

  @override
  State<_RowList> createState() => _RowListState();
}

class _RowListState extends State<_RowList> {
  static const _all = ['Milk', 'Eggs', 'Bread'];
  final _rows = [..._all];

  Future<bool> _ask(String row) async {
    var confirmed = false;
    await VAlertDialog.show<void>(
      context,
      description: Text('Delete $row?'),
      confirmText: 'Delete',
      cancelText: 'Cancel',
      destructive: true,
      onConfirm: () => confirmed = true,
    );
    return confirmed;
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final row in _rows)
          VDismissible(
            key: ValueKey(row),
            direction: widget.direction,
            dismissLabel: widget.dismissLabel,
            confirmDismiss: widget.askFirst
                ? (_) => _ask(row)
                : widget.confirmDismiss,
            background: widget.background,
            onDismissed: (_) => setState(() => _rows.remove(row)),
            child: ColoredBox(
              color: theme.colors.card,
              child: VListTile(title: Text(row)),
            ),
          ),
        SizedBox(height: theme.spacing.sm),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: VButton.outlined(
            onPressed: _rows.length == _all.length
                ? null
                : () => setState(
                    () => _rows
                      ..clear()
                      ..addAll(_all),
                  ),
            child: const Text('Reset rows'),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Showcase
// =============================================================================

class _DismissibleShowcase extends StatelessWidget {
  const _DismissibleShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    return WidgetbookPageLayout(
      title: 'VDismissible',
      description:
          'A row that a swipe removes. Screen readers get a custom action with '
          'the same name.',
      children: [
        const WidgetbookSection(
          title: 'Directions',
          children: [
            WidgetbookSubsection(
              title: 'endToStart',
              labels: ['direction: DismissDirection.endToStart'],
              fullWidth: true,
              children: [_RowList()],
            ),
            WidgetbookSubsection(
              title: 'horizontal',
              labels: ['direction: DismissDirection.horizontal'],
              fullWidth: true,
              children: [_RowList(direction: DismissDirection.horizontal)],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Label and background',
          children: [
            const WidgetbookSubsection(
              title: 'dismissLabel',
              labels: ['dismissLabel: Archive'],
              fullWidth: true,
              children: [_RowList(dismissLabel: 'Archive')],
            ),
            WidgetbookSubsection(
              title: 'background',
              labels: const ['background: your own widget'],
              fullWidth: true,
              children: [
                _RowList(
                  dismissLabel: 'Archive',
                  background: ColoredBox(color: theme.colors.info),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// =============================================================================
// Sample
// =============================================================================

class _DismissibleSample extends StatelessWidget {
  const _DismissibleSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VDismissible Samples',
    description: 'Copy-paste code examples for VDismissible.',
    children: [
      WidgetbookCodeBlock(
        title: 'Swipe to delete',
        code: '''ListView(
  children: [
    for (final entry in entries)
      VDismissible(
        key: ValueKey(entry.id),
        onDismissed: (_) => setState(() => entries.remove(entry)),
        child: VListTile(title: Text(entry.title)),
      ),
  ],
)''',
        preview: _RowList(),
      ),
      WidgetbookCodeBlock(
        title: 'Ask first',
        code: r'''VDismissible(
  key: ValueKey(entry.id),
  confirmDismiss: (_) async {
    var confirmed = false;
    await VAlertDialog.show<void>(
      context,
      description: Text('Delete ${entry.title}?'),
      confirmText: 'Delete',
      cancelText: 'Cancel',
      destructive: true,
      onConfirm: () => confirmed = true,
    );
    return confirmed;
  },
  onDismissed: (_) => setState(() => entries.remove(entry)),
  child: VListTile(title: Text(entry.title)),
)''',
        preview: _RowList(askFirst: true),
      ),
    ],
  );
}
