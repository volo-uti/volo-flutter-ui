import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vAlertDialogComponent() => WidgetbookComponent(
  name: 'VAlertDialog',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _alertDialogPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _AlertDialogShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _AlertDialogSample(),
    ),
  ],
);

Widget _alertDialogPlayground(BuildContext context) {
  final k = context.knobs;
  final title = k.string(label: 'title', initialValue: 'Are you sure?');
  final description = k.string(
    label: 'description',
    initialValue: 'This action cannot be undone.',
  );
  final cancelText = k.string(label: 'cancelText', initialValue: 'Cancel');
  final confirmText = k.string(label: 'confirmText', initialValue: 'Confirm');
  final destructive = k.boolean(label: 'destructive');
  final barrierDismissible = k.boolean(label: 'barrierDismissible');

  var result = 'none';
  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      info: ['last result: $result'],
      child: VButton(
        onPressed: () => unawaited(
          VAlertDialog.show<void>(
            context,
            title: title.isEmpty ? null : Text(title),
            description: Text(description),
            cancelText: cancelText.isEmpty ? null : cancelText,
            confirmText: confirmText.isEmpty ? null : confirmText,
            destructive: destructive,
            barrierDismissible: barrierDismissible,
            onCancel: () => setState(() => result = 'cancel'),
            onConfirm: () => setState(() => result = 'confirm'),
          ),
        ),
        child: const Text('Open alert dialog'),
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _AlertDialogShowcase extends StatelessWidget {
  const _AlertDialogShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VAlertDialog',
    description:
        'A modal dialog for critical actions requiring explicit user confirmation. Cannot be dismissed by backdrop click or Escape.',
    children: [
      WidgetbookSection(
        title: 'Basic Structure',
        children: [
          WidgetbookSubsection(
            title: 'delete confirmation',
            labels: const ['VAlertDialog compound pattern'],
            children: [
              VButton(
                color: VButtonColor.destructive,
                onPressed: () {
                  unawaited(
                    VAlertDialog.show<void>(
                      context,
                      title: const Text('Are you absolutely sure?'),
                      description: const Text(
                        'This action cannot be undone. Your account and all associated data will be permanently deleted.',
                      ),
                      cancelText: 'Cancel',
                      confirmText: 'Delete',
                      destructive: true,
                    ),
                  );
                },
                child: const Text('Delete Account'),
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Use Cases',
        children: [
          WidgetbookSubsection(
            title: 'discard changes',
            labels: const ['VAlertDialog discard changes'],
            children: [
              VButton.outlined(
                onPressed: () {
                  unawaited(
                    VAlertDialog.show<void>(
                      context,
                      title: const Text('You have unsaved changes'),
                      description: const Text(
                        'If you leave now, all changes will be lost. Do you want to continue?',
                      ),
                      cancelText: 'Keep Editing',
                      confirmText: 'Discard',
                      destructive: true,
                    ),
                  );
                },
                child: const Text('Discard Changes'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'delete item',
            labels: const ['VAlertDialog delete item'],
            children: [
              VButton(
                color: VButtonColor.destructive,
                onPressed: () {
                  unawaited(
                    VAlertDialog.show<void>(
                      context,
                      title: const Text('Delete this item?'),
                      description: const Text(
                        'This item will be permanently deleted. This action cannot be undone.',
                      ),
                      cancelText: 'Cancel',
                      confirmText: 'Delete',
                      destructive: true,
                    ),
                  );
                },
                child: const Text('Delete Item'),
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
          'For destructive or irreversible actions that require explicit user confirmation before proceeding.',
        ),
        _guidelineRow(
          theme,
          'When not to use',
          'For general content display or non-destructive forms. Use VDialog instead.',
        ),
        _guidelineRow(
          theme,
          'Accessibility',
          'Cannot be dismissed by Escape or backdrop click. Users must explicitly choose an action.',
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

class _AlertDialogSample extends StatelessWidget {
  const _AlertDialogSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VAlertDialog Samples',
    description: 'Copy-paste code examples for VAlertDialog.',
    children: [
      WidgetbookCodeBlock(
        title: 'Delete confirmation',
        code: '''VAlertDialog.show(
  context,
  title: Text('Are you sure?'),
  description: Text('This action cannot be undone'),
  cancelText: 'Cancel',
  confirmText: 'Delete',
  destructive: true,
)''',
        preview: VButton(
          color: VButtonColor.destructive,
          onPressed: () {
            unawaited(
              VAlertDialog.show<void>(
                context,
                title: const Text('Are you sure?'),
                description: const Text('This action cannot be undone'),
                cancelText: 'Cancel',
                confirmText: 'Delete',
                destructive: true,
              ),
            );
          },
          child: const Text('Delete'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Logout confirmation',
        code: '''VAlertDialog.show(
  context,
  title: Text('Log Out'),
  description: Text('Are you sure you want to log out?'),
  cancelText: 'Cancel',
  confirmText: 'Log Out',
)''',
        preview: VButton.outlined(
          onPressed: () {
            unawaited(
              VAlertDialog.show<void>(
                context,
                title: const Text('Log Out'),
                description: const Text('Are you sure you want to log out?'),
                cancelText: 'Cancel',
                confirmText: 'Log Out',
              ),
            );
          },
          child: const Text('Log Out'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Payment confirmation',
        code: r'''VAlertDialog.show(
  context,
  title: Text('Confirm Payment'),
  description: Text('You will be charged $29.99. Continue?'),
  cancelText: 'Cancel',
  confirmText: 'Pay',
)''',
        preview: VButton(
          onPressed: () {
            unawaited(
              VAlertDialog.show<void>(
                context,
                title: const Text('Confirm Payment'),
                description: const Text(
                  r'You will be charged $29.99. Continue?',
                ),
                cancelText: 'Cancel',
                confirmText: 'Pay',
              ),
            );
          },
          child: const Text('Pay Now'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Unsaved changes warning',
        code: '''VAlertDialog.show(
  context,
  title: Text('Unsaved Changes'),
  description: Text('You have unsaved changes. If you leave this page, your changes will be lost.'),
  cancelText: 'Stay',
  confirmText: 'Leave',
  destructive: true,
)''',
        preview: VButton.outlined(
          onPressed: () {
            unawaited(
              VAlertDialog.show<void>(
                context,
                title: const Text('Unsaved Changes'),
                description: const Text(
                  'You have unsaved changes. If you leave this page, your changes will be lost.',
                ),
                cancelText: 'Stay',
                confirmText: 'Leave',
                destructive: true,
              ),
            );
          },
          child: const Text('Leave Page'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Destructive with input',
        code: '''VAlertDialog.show(
  context,
  title: Text('Delete Project'),
  description: Text('This will permanently delete the project and all its data. Type the project name to confirm.'),
  cancelText: 'Cancel',
  confirmText: 'Delete Forever',
  destructive: true,
)''',
        preview: VButton(
          color: VButtonColor.destructive,
          onPressed: () {
            unawaited(
              VAlertDialog.show<void>(
                context,
                title: const Text('Delete Project'),
                description: const Text(
                  'This will permanently delete the project and all its data. Type the project name to confirm.',
                ),
                cancelText: 'Cancel',
                confirmText: 'Delete Forever',
                destructive: true,
              ),
            );
          },
          child: const Text('Delete Project'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Confirmation dialog',
        code: '''VAlertDialog.show(
  context,
  title: Text('Discard Changes?'),
  description: Text('You have unsaved changes. Are you sure you want to leave?'),
  cancelText: 'Keep Editing',
  confirmText: 'Discard',
)''',
        preview: VButton.outlined(
          onPressed: () {
            unawaited(
              VAlertDialog.show<void>(
                context,
                title: const Text('Discard Changes?'),
                description: const Text(
                  'You have unsaved changes. Are you sure you want to leave?',
                ),
                cancelText: 'Keep Editing',
                confirmText: 'Discard',
              ),
            );
          },
          child: const Text('Discard Changes'),
        ),
      ),
    ],
  );
}
