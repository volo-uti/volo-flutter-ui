import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vSnackbarComponent() => WidgetbookComponent(
  name: 'VSnackbar',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _snackbarPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _SnackbarShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _SnackbarSample(),
    ),
  ],
);

enum _SnackbarType { neutral, success, error, warning, info }

Widget _snackbarPlayground(BuildContext context) {
  final k = context.knobs;
  final type = k.object.dropdown<_SnackbarType>(
    label: 'type',
    options: _SnackbarType.values,
    labelBuilder: (v) => v.name,
  );
  final content = k.string(
    label: 'content',
    initialValue: 'Action completed successfully.',
  );
  final behavior = k.object.dropdown<VSnackbarBehavior>(
    label: 'behavior',
    options: VSnackbarBehavior.values,
    labelBuilder: (v) => v.name,
  );
  final width = k.doubleOrNull.slider(
    label: 'width',
    min: 200,
    max: 600,
    divisions: 20,
  );
  final backgroundColor = k.colorOrNull(label: 'backgroundColor');
  final dismissDirection = k.objectOrNull.dropdown<DismissDirection>(
    label: 'dismissDirection',
    options: [
      DismissDirection.down,
      DismissDirection.up,
      DismissDirection.startToEnd,
      DismissDirection.endToStart,
    ],
    labelBuilder: (v) => v.name,
  );
  final seconds = k.int.slider(label: 'duration (s)', initialValue: 4, max: 10);
  final hasAction = k.boolean(label: 'action');

  var visible = 0;
  var undone = 0;
  return StatefulBuilder(
    builder: (context, setState) {
      final create = switch (type) {
        _SnackbarType.neutral => VSnackbar.new,
        _SnackbarType.success => VSnackbar.success,
        _SnackbarType.error => VSnackbar.error,
        _SnackbarType.warning => VSnackbar.warning,
        _SnackbarType.info => VSnackbar.info,
      };
      return WidgetbookPlayground(
        info: ['shown: $visible', 'undo taps: $undone'],
        child: VButton(
          onPressed: () => VSnackbar.show(
            context,
            create(
              content: Text(content),
              semanticLabel: content,
              behavior: behavior,
              width: width,
              backgroundColor: backgroundColor,
              dismissDirection: dismissDirection,
              duration: Duration(seconds: seconds),
              onVisible: () => setState(() => visible++),
              action: hasAction
                  ? VSnackbarAction(
                      label: 'Undo',
                      onPressed: () {
                        setState(() => undone++);
                        VSnackbar.hide(context);
                      },
                    )
                  : null,
            ),
          ),
          child: const Text('Show snackbar'),
        ),
      );
    },
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _SnackbarShowcase extends StatelessWidget {
  const _SnackbarShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VSnackbar',
    description:
        'A notification message component that briefly appears at the bottom.',
    children: [
      WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: const ['VSnackbar severity="default"'],
            children: [
              VButton(
                onPressed: () {
                  VSnackbar.show(
                    context,
                    const VSnackbar(content: Text('Default snackbar message.')),
                  );
                },
                child: const Text('Open Default Snackbar'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'success',
            labels: const ['VSnackbar severity="success"'],
            children: [
              VButton(
                onPressed: () => VSnackbar.showSuccess(
                  context,
                  'Operation completed successfully!',
                ),
                child: const Text('Open Success Snackbar'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'error',
            labels: const ['VSnackbar severity="error"'],
            children: [
              VButton(
                onPressed: () =>
                    VSnackbar.showError(context, 'An error has occurred.'),
                child: const Text('Open Error Snackbar'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'warning',
            labels: const ['VSnackbar severity="warning"'],
            children: [
              VButton(
                onPressed: () {
                  VSnackbar.show(
                    context,
                    const VSnackbar.warning(
                      content: Text('Please review before continuing.'),
                    ),
                  );
                },
                child: const Text('Open Warning Snackbar'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'info',
            labels: const ['VSnackbar severity="info"'],
            children: [
              VButton(
                onPressed: () {
                  VSnackbar.show(
                    context,
                    const VSnackbar.info(
                      content: Text('Here is some useful information.'),
                    ),
                  );
                },
                child: const Text('Open Info Snackbar'),
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Behavior',
        children: [
          WidgetbookSubsection(
            title: 'fixed',
            labels: const ['VSnackbar behavior="fixed"'],
            children: [
              VButton(
                onPressed: () {
                  VSnackbar.show(
                    context,
                    const VSnackbar.success(
                      content: Text('Fixed at the bottom of the viewport.'),
                    ),
                  );
                },
                child: const Text('Open Fixed Snackbar'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'floating',
            labels: const ['VSnackbar behavior="floating"'],
            children: [
              VButton(
                onPressed: () {
                  VSnackbar.show(
                    context,
                    const VSnackbar.success(
                      content: Text('Floating snackbar.'),
                      behavior: VSnackbarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Open Floating Snackbar'),
              ),
            ],
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
              'Show brief, non-blocking feedback such as save confirmations or action results.',
            ),
            _guidelineRow(
              theme,
              'When not to use',
              'For persistent messages requiring user acknowledgment. Use VAlert or VAlertDialog instead.',
            ),
            _guidelineRow(
              theme,
              'Duration',
              'Keep duration between 3-5 seconds. Use longer durations for important messages.',
            ),
            _guidelineRow(
              theme,
              'Position',
              'Display at the bottom of the screen to minimize content obstruction',
            ),
            _guidelineRow(
              theme,
              'Timing',
              'Provide enough time for users to read and act',
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

class _SnackbarSample extends StatelessWidget {
  const _SnackbarSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VSnackbar Samples',
    description: 'Copy-paste code examples for VSnackbar.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic usage',
        code: '''VSnackbar.show(
  context,
  VSnackbar(content: Text('Default snackbar message')),
);''',
        preview: VButton(
          onPressed: () {
            VSnackbar.show(
              context,
              const VSnackbar(content: Text('Default snackbar message')),
            );
          },
          child: const Text('Show'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Success snackbar',
        code: '''VSnackbar.showSuccess(context, 'Saved successfully.');''',
        preview: VButton(
          onPressed: () =>
              VSnackbar.showSuccess(context, 'Saved successfully.'),
          child: const Text('Show'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'With action',
        code: '''VSnackbar.show(
  context,
  VSnackbar(
    content: Text('Item deleted.'),
    action: VSnackbarAction(
      label: 'Undo',
      onPressed: () => VSnackbar.hide(context),
    ),
  ),
);''',
        preview: VButton(
          onPressed: () {
            VSnackbar.show(
              context,
              VSnackbar(
                content: const Text('Item deleted.'),
                action: VSnackbarAction(
                  label: 'Undo',
                  onPressed: () => VSnackbar.hide(context),
                ),
              ),
            );
          },
          child: const Text('Show'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Undo action',
        code: '''VSnackbar.show(
  context,
  VSnackbar(
    content: Text('Item moved to trash.'),
    action: VSnackbarAction(
      label: 'Undo',
      onPressed: () => VSnackbar.hide(context),
    ),
  ),
);''',
        preview: VButton(
          onPressed: () {
            VSnackbar.show(
              context,
              VSnackbar(
                content: const Text('Item moved to trash.'),
                action: VSnackbarAction(
                  label: 'Undo',
                  onPressed: () => VSnackbar.hide(context),
                ),
              ),
            );
          },
          child: const Text('Show'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Error notification',
        code: '''VSnackbar.show(
  context,
  VSnackbar.error(
    content: Text('Failed to save changes. Please try again.'),
    action: VSnackbarAction(
      label: 'Retry',
      onPressed: () => retrySave(),
    ),
  ),
);''',
        preview: VButton(
          onPressed: () {
            VSnackbar.show(
              context,
              VSnackbar.error(
                content: const Text(
                  'Failed to save changes. Please try again.',
                ),
                action: VSnackbarAction(
                  label: 'Retry',
                  onPressed: () => VSnackbar.hide(context),
                ),
              ),
            );
          },
          child: const Text('Show'),
        ),
      ),
    ],
  );
}
