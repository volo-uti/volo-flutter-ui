import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vDialogComponent() => WidgetbookComponent(
  name: 'VDialog',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _dialogPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _DialogShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _DialogSample(),
    ),
  ],
);

enum _DialogType { alert, confirm, custom }

Widget _dialogPlayground(BuildContext context) {
  final k = context.knobs;
  final type = k.object.dropdown<_DialogType>(
    label: 'type',
    options: _DialogType.values,
    labelBuilder: (v) => v.name,
  );
  final title = k.string(label: 'title', initialValue: 'Confirm action');
  final content = k.string(
    label: 'content',
    initialValue: 'Are you sure you want to proceed?',
  );
  final semanticLabel = k.string(label: 'semanticLabel');
  final cancelText = k.string(label: 'cancelText', initialValue: 'Cancel');
  final confirmText = k.string(label: 'confirmText', initialValue: 'Confirm');
  final destructive = k.boolean(label: 'destructive');
  final alignment = k.object.dropdown<VDialogActionsAlignment>(
    label: 'actionsAlignment',
    options: VDialogActionsAlignment.values,
    initialOption: VDialogActionsAlignment.end,
    labelBuilder: (v) => v.name,
  );
  final actionsExpanded = k.boolean(label: 'actionsExpanded');
  final barrierDismissible = k.boolean(
    label: 'barrierDismissible',
    initialValue: true,
  );
  final barrierColor = k.colorOrNull(label: 'barrierColor');

  var result = 'none';
  return StatefulBuilder(
    builder: (context, setState) {
      final titleWidget = title.isEmpty ? null : Text(title);
      final label = semanticLabel.isEmpty ? null : semanticLabel;
      void confirm() => setState(() => result = 'confirm');
      void cancel() => setState(() => result = 'cancel');
      final dialog = switch (type) {
        _DialogType.alert => VDialog.alert(
          title: titleWidget,
          content: Text(content),
          confirmText: confirmText,
          onConfirm: confirm,
          semanticLabel: label,
          actionsAlignment: alignment,
          actionsExpanded: actionsExpanded,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
        ),
        _DialogType.confirm => VDialog.confirm(
          title: titleWidget,
          content: Text(content),
          cancelText: cancelText,
          confirmText: confirmText,
          onCancel: cancel,
          onConfirm: confirm,
          destructive: destructive,
          semanticLabel: label,
          actionsAlignment: alignment,
          actionsExpanded: actionsExpanded,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
        ),
        _DialogType.custom => VDialog.custom(
          title: titleWidget,
          content: Text(content),
          semanticLabel: label,
          actions: [
            VButton.ghost(
              onPressed: () => VDialog.close<void>(context),
              child: const Text('Later'),
            ),
            VButton(
              onPressed: () {
                confirm();
                VDialog.close<void>(context);
              },
              child: Text(confirmText),
            ),
          ],
          actionsAlignment: alignment,
          actionsExpanded: actionsExpanded,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
        ),
      };
      return WidgetbookPlayground(
        info: ['last result: $result'],
        child: VButton(
          onPressed: () => unawaited(VDialog.show<void>(context, dialog)),
          child: const Text('Open dialog'),
        ),
      );
    },
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _DialogShowcase extends StatelessWidget {
  const _DialogShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VDialog',
    description:
        'A modal dialog with backdrop, focus trap, and keyboard support using a compound component pattern.',
    children: [
      WidgetbookSection(
        title: 'Basic Structure',
        children: [
          WidgetbookSubsection(
            title: 'default dialog',
            labels: const ['VDialog compound pattern'],
            children: [
              VButton(
                onPressed: () {
                  unawaited(
                    VDialog.show<void>(
                      context,
                      VDialog.custom(
                        title: const Text('Dialog Title'),
                        content: const Text(
                          'A description explaining the purpose of this dialog.\n\nBody content is displayed here.',
                        ),
                        actions: [
                          VButton.outlined(
                            onPressed: () => VDialog.close<void>(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('Open Basic Dialog'),
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Dialog Types',
        children: [
          WidgetbookSubsection(
            title: 'simple dialog',
            labels: const ['VDialog simple'],
            children: [
              VButton(
                onPressed: () {
                  unawaited(
                    VDialog.show<void>(
                      context,
                      const VDialog.alert(
                        title: Text('Notice'),
                        content: Text('The operation has been completed.'),
                      ),
                    ),
                  );
                },
                child: const Text('Simple Dialog'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'form dialog',
            labels: const ['VDialog form content'],
            children: [
              VButton(
                onPressed: () {
                  unawaited(
                    VDialog.show<void>(
                      context,
                      VDialog.custom(
                        title: const Text('Edit Profile'),
                        content: const Text('Enter your changes and save.'),
                        actions: [
                          VButton.outlined(
                            onPressed: () => VDialog.close<void>(context),
                            child: const Text('Cancel'),
                          ),
                          VButton(
                            onPressed: () => VDialog.close<void>(context),
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('Edit Profile'),
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
          'Present focused content requiring user attention, such as forms, confirmations, or detailed views.',
        ),
        _guidelineRow(
          theme,
          'When not to use',
          'For destructive confirmations where the user must explicitly act. Use VAlertDialog instead.',
        ),
        _guidelineRow(
          theme,
          'Accessibility',
          'Focus is trapped inside the dialog. Pressing Escape or clicking the backdrop closes it.',
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

class _DialogSample extends StatelessWidget {
  const _DialogSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VDialog Samples',
    description: 'Copy-paste code examples for VDialog.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic dialog',
        code: '''VDialog.show(
  context,
  VDialog.alert(
    title: Text('Title'),
    content: Text('Description text'),
  ),
);''',
        preview: VButton(
          onPressed: () {
            unawaited(
              VDialog.show<void>(
                context,
                const VDialog.alert(
                  title: Text('Title'),
                  content: Text('Description text'),
                ),
              ),
            );
          },
          child: const Text('Open'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Confirmation dialog',
        code: '''VDialog.show(
  context,
  VDialog.confirm(
    title: Text('Delete Item'),
    content: Text('Are you sure you want to delete this item?'),
    cancelText: 'Cancel',
    confirmText: 'Delete',
    destructive: true,
  ),
);''',
        preview: VButton(
          color: VButtonColor.destructive,
          onPressed: () {
            unawaited(
              VDialog.show<void>(
                context,
                const VDialog.confirm(
                  title: Text('Delete Item'),
                  content: Text('Are you sure you want to delete this item?'),
                  cancelText: 'Cancel',
                  confirmText: 'Delete',
                  destructive: true,
                ),
              ),
            );
          },
          child: const Text('Delete'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Form dialog',
        code: '''VDialog.show(
  context,
  VDialog.custom(
    title: Text('New Item'),
    content: Text('Enter the new item details.'),
    actions: [
      VButton.outlined(onPressed: () => VDialog.close(context), child: Text('Cancel')),
      VButton(onPressed: () => VDialog.close(context), child: Text('Add')),
    ],
  ),
);''',
        preview: VButton(
          onPressed: () {
            unawaited(
              VDialog.show<void>(
                context,
                VDialog.custom(
                  title: const Text('New Item'),
                  content: const Text('Enter the new item details.'),
                  actions: [
                    VButton.outlined(
                      onPressed: () => VDialog.close<void>(context),
                      child: const Text('Cancel'),
                    ),
                    VButton(
                      onPressed: () => VDialog.close<void>(context),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Text('Add New Item'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Image preview dialog',
        code: '''VDialog.show(
  context,
  VDialog.custom(
    title: Text('Image Preview'),
    content: Column(
      children: [
        Container(
          width: 280,
          height: 200,
          color: Colors.grey[200],
          child: Center(child: Icon(Icons.image, size: 64)),
        ),
        SizedBox(height: 8),
        Text('photo_2024.jpg'),
      ],
    ),
    actions: [
      VButton.outlined(onPressed: () => VDialog.close(context), child: Text('Close')),
      VButton(onPressed: () => VDialog.close(context), child: Text('Download')),
    ],
  ),
);''',
        preview: VButton(
          onPressed: () {
            unawaited(
              VDialog.show<void>(
                context,
                VDialog.custom(
                  title: const Text('Image Preview'),
                  content: const Column(
                    children: [
                      SizedBox(
                        width: 280,
                        height: 200,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Color(0xFFE5E7EB)),
                          child: Center(
                            child: Text(
                              'Image Placeholder',
                              style: TextStyle(color: Color(0xFF9CA3AF)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('photo_2024.jpg'),
                    ],
                  ),
                  actions: [
                    VButton.outlined(
                      onPressed: () => VDialog.close<void>(context),
                      child: const Text('Close'),
                    ),
                    VButton(
                      onPressed: () => VDialog.close<void>(context),
                      child: const Text('Download'),
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Text('Preview Image'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Multi-step dialog',
        code: '''VDialog.show(
  context,
  VDialog.custom(
    title: Text('Step 1 of 3: Account Setup'),
    content: Text('Enter your basic information to get started.'),
    actions: [
      VButton.outlined(onPressed: () => VDialog.close(context), child: Text('Cancel')),
      VButton(onPressed: () => goToNextStep(), child: Text('Next')),
    ],
  ),
);''',
        preview: VButton(
          onPressed: () {
            unawaited(
              VDialog.show<void>(
                context,
                VDialog.custom(
                  title: const Text('Step 1 of 3: Account Setup'),
                  content: const Text(
                    'Enter your basic information to get started.',
                  ),
                  actions: [
                    VButton.outlined(
                      onPressed: () => VDialog.close<void>(context),
                      child: const Text('Cancel'),
                    ),
                    VButton(
                      onPressed: () => VDialog.close<void>(context),
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Text('Start Wizard'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Form dialog',
        code: '''VDialog.show(
  context,
  VDialog.custom(
    title: Text('Create New Item'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VTextField(label: 'Name', placeholder: 'Enter name'),
        SizedBox(height: 12),
        VTextField(label: 'Description', placeholder: 'Enter description'),
      ],
    ),
    actions: [
      VButton.outlined(onPressed: () => VDialog.close(context), child: Text('Cancel')),
      VButton(onPressed: () {}, child: Text('Create')),
    ],
  ),
);''',
        preview: VButton(
          onPressed: () {
            unawaited(
              VDialog.show<void>(
                context,
                VDialog.custom(
                  title: const Text('Create New Item'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Name: ___'),
                      SizedBox(height: 12),
                      Text('Description: ___'),
                    ],
                  ),
                  actions: [
                    VButton.outlined(
                      onPressed: () => VDialog.close<void>(context),
                      child: const Text('Cancel'),
                    ),
                    VButton(
                      onPressed: () => VDialog.close<void>(context),
                      child: const Text('Create'),
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Text('New Item'),
        ),
      ),
    ],
  );
}
