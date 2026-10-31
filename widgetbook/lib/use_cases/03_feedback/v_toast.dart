import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vToastComponent() => WidgetbookComponent(
  name: 'VToast',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _toastPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _ToastShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _ToastSample(),
    ),
  ],
);

enum _ToastType { neutral, success, error, warning, info }

Widget _toastPlayground(BuildContext context) {
  final k = context.knobs;
  final type = k.object.dropdown<_ToastType>(
    label: 'type',
    options: _ToastType.values,
    labelBuilder: (v) => v.name,
  );
  final message = k.string(
    label: 'message',
    initialValue: 'This is a toast message.',
  );
  final position = k.object.dropdown<VToastPosition>(
    label: 'position',
    options: VToastPosition.values,
    initialOption: VToastPosition.bottom,
    labelBuilder: (v) => v.name,
  );
  final seconds = k.int.slider(label: 'duration (s)', initialValue: 5, max: 10);
  final dismissible = k.boolean(label: 'dismissible', initialValue: true);
  final hasAction = k.boolean(label: 'action');

  var undone = 0;
  return StatefulBuilder(
    builder: (context, setState) {
      final create = switch (type) {
        _ToastType.neutral => VToast.new,
        _ToastType.success => VToast.success,
        _ToastType.error => VToast.error,
        _ToastType.warning => VToast.warning,
        _ToastType.info => VToast.info,
      };
      return WidgetbookPlayground(
        info: ['undo taps: $undone'],
        child: VButton(
          onPressed: () => VToast.show(
            context,
            create(
              message: Text(message),
              semanticLabel: message,
              position: position,
              duration: Duration(seconds: seconds),
              dismissible: dismissible,
              action: hasAction
                  ? VToastAction(
                      label: 'Undo',
                      onPressed: () {
                        setState(() => undone++);
                        VToast.dismiss(context);
                      },
                    )
                  : null,
            ),
          ),
          child: const Text('Show toast'),
        ),
      );
    },
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _ToastShowcase extends StatelessWidget {
  const _ToastShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VToast',
    description:
        'Displays brief notification messages to the user. Triggered via the toast() function.',
    children: [
      WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: const ['toast.default()'],
            children: [
              VButton(
                onPressed: () {
                  VToast.show(
                    context,
                    const VToast(
                      message: Text('This is a default toast message.'),
                    ),
                  );
                },
                child: const Text('Default'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'success',
            labels: const ['toast.success()'],
            children: [
              VButton(
                onPressed: () => VToast.showSuccess(
                  context,
                  'Operation completed successfully!',
                ),
                child: const Text('Success'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'info',
            labels: const ['toast.info()'],
            children: [
              VButton(
                onPressed: () => VToast.showInfo(
                  context,
                  'Here is some useful information.',
                ),
                child: const Text('Info'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'warning',
            labels: const ['toast.warning()'],
            children: [
              VButton(
                onPressed: () => VToast.showWarning(
                  context,
                  'Please review this before continuing.',
                ),
                child: const Text('Warning'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'error',
            labels: const ['toast.error()'],
            children: [
              VButton(
                onPressed: () =>
                    VToast.showError(context, 'An error has occurred!'),
                child: const Text('Error'),
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Duration',
        children: [
          WidgetbookSubsection(
            title: 'short (2s)',
            labels: const ['toast duration: 2000'],
            children: [
              VButton(
                onPressed: () {
                  VToast.show(
                    context,
                    const VToast.info(
                      message: Text('Disappears in 2 seconds'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('2 seconds'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'default (5s)',
            labels: const ['toast duration: 5000'],
            children: [
              VButton(
                onPressed: () =>
                    VToast.showInfo(context, 'Disappears in 5 seconds'),
                child: const Text('5 seconds (default)'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'persistent',
            labels: const ['toast duration: 0'],
            children: [
              VButton(
                onPressed: () {
                  VToast.show(
                    context,
                    const VToast.info(
                      message: Text('Dismiss manually by clicking close'),
                      duration: Duration.zero,
                    ),
                  );
                },
                child: const Text('Manual dismiss'),
              ),
            ],
          ),
        ],
      ),

      // Usage Guidelines
      WidgetbookSection(
        title: 'Usage Guidelines',
        children: [_UsageGuidelinesTable()],
      ),
    ],
  );
}

class _UsageGuidelinesTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    return Table(
      columnWidths: const {0: FixedColumnWidth(160), 1: FlexColumnWidth()},
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: theme.colors.muted,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          children: [
            _tableHeader(theme, 'Category'),
            _tableHeader(theme, 'Guideline'),
          ],
        ),
        _guidelineRow(
          theme,
          'When to use',
          'Show brief, non-blocking feedback like save confirmations, error notifications, or status updates.',
        ),
        _guidelineRow(
          theme,
          'When not to use',
          'For persistent important messages that require user acknowledgment. Use VAlert or VAlertDialog instead.',
        ),
        _guidelineRow(
          theme,
          'Setup',
          'Place <VToaster /> once in your app root. Use toast.success(), toast.error(), etc. to trigger.',
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

class _ToastSample extends StatelessWidget {
  const _ToastSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VToast Samples',
    description: 'Copy-paste code examples for VToast.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic success toast',
        code: '''VToast.showSuccess(context, 'Saved successfully!');''',
        preview: VButton(
          onPressed: () => VToast.showSuccess(context, 'Saved successfully!'),
          child: const Text('Show Success Toast'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Error toast',
        code:
            '''VToast.showError(context, 'Network error occurred. Please try again.');''',
        preview: VButton(
          color: VButtonColor.destructive,
          onPressed: () => VToast.showError(
            context,
            'Network error occurred. Please try again.',
          ),
          child: const Text('Show Error Toast'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Custom duration',
        code: '''VToast.show(
  context,
  VToast.info(
    message: Text('Disappears shortly'),
    duration: Duration(seconds: 2),
  ),
);''',
        preview: VButton(
          onPressed: () {
            VToast.show(
              context,
              const VToast.info(
                message: Text('Disappears shortly'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: const Text('2 Second Toast'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Persistent toast (manual dismiss)',
        code: '''VToast.show(
  context,
  VToast.warning(
    message: Text('Dismiss manually'),
    duration: Duration.zero,
  ),
);''',
        preview: VButton(
          onPressed: () {
            VToast.show(
              context,
              const VToast.warning(
                message: Text('Dismiss manually'),
                duration: Duration.zero,
              ),
            );
          },
          child: const Text('Persistent Toast'),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Toaster setup (app root)',
        code: '''// main.dart
// VToastOverlay is automatically managed by VApp.
// Use VToast.show(context, ...) anywhere in the widget tree.''',
        preview: Text('Place VToastOverlay once in your app root.'),
      ),
      WidgetbookCodeBlock(
        title: 'All types at once',
        code: '''VToast.show(context, VToast(message: Text('Default message')));
VToast.showSuccess(context, 'Success message');
VToast.showInfo(context, 'Info message');
VToast.showWarning(context, 'Warning message');
VToast.showError(context, 'Error message');''',
        preview: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            VButton.outlined(
              onPressed: () => VToast.show(
                context,
                const VToast(message: Text('Default message')),
              ),
              child: const Text('Default'),
            ),
            VButton.outlined(
              onPressed: () => VToast.showSuccess(context, 'Success message'),
              child: const Text('Success'),
            ),
            VButton.outlined(
              onPressed: () => VToast.showInfo(context, 'Info message'),
              child: const Text('Info'),
            ),
            VButton.outlined(
              onPressed: () => VToast.showWarning(context, 'Warning message'),
              child: const Text('Warning'),
            ),
            VButton.outlined(
              onPressed: () => VToast.showError(context, 'Error message'),
              child: const Text('Error'),
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Toast with action',
        code: '''VToast.show(
  context,
  VToast.success(
    message: Text('Item deleted'),
    action: VToastAction(
      label: 'Undo',
      onPressed: () => restoreItem(),
    ),
  ),
);''',
        preview: VButton(
          onPressed: () {
            VToast.show(
              context,
              VToast.success(
                message: const Text('Item deleted'),
                action: VToastAction(
                  label: 'Undo',
                  onPressed: () => VToast.dismiss(context),
                ),
              ),
            );
          },
          child: const Text('Delete with Undo'),
        ),
      ),
    ],
  );
}
