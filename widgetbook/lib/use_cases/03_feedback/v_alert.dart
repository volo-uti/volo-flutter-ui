import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vAlertComponent() => WidgetbookComponent(
  name: 'VAlert',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _alertPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _AlertShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _AlertSample(),
    ),
  ],
);

enum _AlertType { neutral, info, success, warning, error }

Widget _alertPlayground(BuildContext context) {
  final k = context.knobs;
  final type = k.object.dropdown<_AlertType>(
    label: 'type',
    options: _AlertType.values,
    labelBuilder: (v) => v.name,
  );
  final variant = k.object.dropdown<VAlertVariant>(
    label: 'variant',
    options: VAlertVariant.values,
    labelBuilder: (v) => v.name,
  );
  final title = k.string(label: 'title', initialValue: 'Alert title');
  final description = k.string(
    label: 'description',
    initialValue: 'This is an alert message.',
  );
  final semanticLabel = k.string(label: 'semanticLabel');
  final hasAction = k.boolean(label: 'action');
  final closable = k.boolean(label: 'onClose', initialValue: true);

  var closes = 0;
  return StatefulBuilder(
    builder: (context, setState) {
      final create = switch (type) {
        _AlertType.neutral => VAlert.new,
        _AlertType.info => VAlert.info,
        _AlertType.success => VAlert.success,
        _AlertType.warning => VAlert.warning,
        _AlertType.error => VAlert.error,
      };
      return WidgetbookPlayground(
        layout: PlaygroundLayout.stretch,
        info: ['closes: $closes'],
        child: create(
          title: title.isEmpty ? null : Text(title),
          description: Text(description),
          variant: variant,
          semanticLabel: semanticLabel.isEmpty ? null : semanticLabel,
          action: hasAction
              ? VButton.outlined(onPressed: () {}, child: const Text('Action'))
              : null,
          onClose: closable ? () => setState(() => closes++) : null,
        ),
      );
    },
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _AlertShowcase extends StatelessWidget {
  const _AlertShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VAlert',
    description:
        'Displays contextual feedback messages with severity-based styling.',
    children: [
      const WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'standard',
            labels: ['VAlert variant="standard"'],
            children: [
              VAlert.info(
                title: Text('Standard'),
                description: Text('This is a standard style alert.'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'filled',
            labels: ['VAlert variant="filled"'],
            children: [
              VAlert.info(
                title: Text('Filled'),
                description: Text('This is a filled style alert.'),
                variant: VAlertVariant.filled,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'outlined',
            labels: ['VAlert variant="outlined"'],
            children: [
              VAlert.info(
                title: Text('Outlined'),
                description: Text('This is an outlined style alert.'),
                variant: VAlertVariant.outlined,
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Severity',
        children: [
          WidgetbookSubsection(
            title: 'success',
            labels: ['VAlert severity="success"'],
            children: [
              VAlert.success(
                title: Text('Success'),
                description: Text('The operation completed successfully.'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'info',
            labels: ['VAlert severity="info"'],
            children: [
              VAlert.info(
                title: Text('Info'),
                description: Text('Here is some helpful information.'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'warning',
            labels: ['VAlert severity="warning"'],
            children: [
              VAlert.warning(
                title: Text('Warning'),
                description: Text('Please review before proceeding.'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'error',
            labels: ['VAlert severity="error"'],
            children: [
              VAlert.error(
                title: Text('Error'),
                description: Text('An error occurred. Please try again.'),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Filled + Severity',
        children: [
          WidgetbookSubsection(
            title: 'all filled',
            labels: ['VAlert variant="filled"'],
            children: [
              VAlert.success(
                title: Text('Success'),
                description: Text('Success message'),
                variant: VAlertVariant.filled,
              ),
              VAlert.info(
                title: Text('Info'),
                description: Text('Info message'),
                variant: VAlertVariant.filled,
              ),
              VAlert.warning(
                title: Text('Warning'),
                description: Text('Warning message'),
                variant: VAlertVariant.filled,
              ),
              VAlert.error(
                title: Text('Error'),
                description: Text('Error message'),
                variant: VAlertVariant.filled,
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Outlined + Severity',
        children: [
          WidgetbookSubsection(
            title: 'all outlined',
            labels: ['VAlert variant="outlined"'],
            children: [
              VAlert.success(
                title: Text('Success'),
                description: Text('Success message'),
                variant: VAlertVariant.outlined,
              ),
              VAlert.info(
                title: Text('Info'),
                description: Text('Info message'),
                variant: VAlertVariant.outlined,
              ),
              VAlert.warning(
                title: Text('Warning'),
                description: Text('Warning message'),
                variant: VAlertVariant.outlined,
              ),
              VAlert.error(
                title: Text('Error'),
                description: Text('Error message'),
                variant: VAlertVariant.outlined,
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Close Button',
        children: [
          WidgetbookSubsection(
            title: 'closable',
            labels: ['VAlert onClose={...}'],
            children: [_DismissableAlertDemo()],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Icon Control',
        children: [
          WidgetbookSubsection(
            title: 'icon hidden',
            labels: ['VAlert icon={false}'],
            children: [
              VAlert(
                title: Text('No Icon'),
                description: Text('This alert has no icon.'),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Title / Content Combinations',
        children: [
          WidgetbookSubsection(
            title: 'title + content',
            labels: ['VAlert title + children'],
            children: [
              VAlert.info(
                title: Text('Alert with Title'),
                description: Text(
                  'Body content is displayed alongside the title.',
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'content only',
            labels: ['VAlert children only'],
            children: [
              VAlert.info(
                description: Text('Only body content without a title.'),
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
          'Show important feedback messages, such as success confirmations, warnings, or errors.',
        ),
        _guidelineRow(
          theme,
          'When not to use',
          'For brief, auto-dismissing notifications. Use VToast instead.',
        ),
        _guidelineRow(
          theme,
          'Severity',
          'Choose the severity that matches the message context: success, info, warning, or error.',
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

class _AlertSample extends StatelessWidget {
  const _AlertSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VAlert Samples',
    description: 'Copy-paste code examples for VAlert.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Basic success alert',
        code: '''VAlert.success(
  title: Text('Saved'),
  description: Text('Your changes have been saved successfully.'),
)''',
        preview: VAlert.success(
          title: Text('Saved'),
          description: Text('Your changes have been saved successfully.'),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Error alert with close',
        code: '''VAlert.error(
  title: Text('Upload Failed'),
  description: Text('File size exceeds 10MB limit.'),
  onClose: () => setState(() => visible = false),
)''',
        preview: _DismissableAlertDemo(),
      ),
      const WidgetbookCodeBlock(
        title: 'Filled warning alert',
        code: '''VAlert.warning(
  title: Text('Caution'),
  description: Text('This action cannot be undone.'),
  variant: VAlertVariant.filled,
)''',
        preview: VAlert.warning(
          title: Text('Caution'),
          description: Text('This action cannot be undone.'),
          variant: VAlertVariant.filled,
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Outlined info alert',
        code: '''VAlert.info(
  description: Text('System maintenance is scheduled for tonight.'),
  variant: VAlertVariant.outlined,
)''',
        preview: VAlert.info(
          description: Text('System maintenance is scheduled for tonight.'),
          variant: VAlertVariant.outlined,
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Alert with action button',
        code: '''VAlert.info(
  title: Text('Update Available'),
  description: Text('A new version has been released.'),
  action: VButton.outlined(onPressed: () {}, child: Text('Update')),
)''',
        preview: VAlert.info(
          title: const Text('Update Available'),
          description: const Text('A new version has been released.'),
          action: VButton.outlined(
            onPressed: () {},
            child: const Text('Update'),
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Form validation alert',
        code: r'''VAlert.error(
  title: Text('Please fix the following errors'),
  description: Text('• Email address is required\n• Password must be at least 8 characters\n• Please agree to the terms of service'),
  variant: VAlertVariant.outlined,
)''',
        preview: VAlert.error(
          title: Text('Please fix the following errors'),
          description: Text(
            '• Email address is required\n• Password must be at least 8 characters\n• Please agree to the terms of service',
          ),
          variant: VAlertVariant.outlined,
        ),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _DismissableAlertDemo extends StatefulWidget {
  const _DismissableAlertDemo();

  @override
  State<_DismissableAlertDemo> createState() => _DismissableAlertDemoState();
}

class _DismissableAlertDemoState extends State<_DismissableAlertDemo> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return VButton(
        onPressed: () => setState(() => _visible = true),
        child: const Text('Show Alert'),
      );
    }

    return VAlert.info(
      title: const Text('Closable'),
      description: const Text('This alert has a close button.'),
      onClose: () => setState(() => _visible = false),
    );
  }
}
