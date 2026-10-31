import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _ProgressVariant { linear, circular }

WidgetbookComponent vProgressComponent() => WidgetbookComponent(
  name: 'VProgress',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _progressPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _ProgressShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _ProgressSample(),
    ),
  ],
);

Widget _progressPlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_ProgressVariant>(
    label: 'variant',
    options: _ProgressVariant.values,
    labelBuilder: (v) => v.name,
  );
  final size = k.object.dropdown<VProgressSize>(
    label: 'size',
    options: VProgressSize.values,
    initialOption: VProgressSize.md,
    labelBuilder: (v) => v.name,
  );
  final indeterminate = k.boolean(label: 'indeterminate');
  final value = k.double.slider(
    label: 'value',
    initialValue: 0.6,
    max: 1,
    divisions: 20,
  );

  return WidgetbookPlayground(
    info: [
      if (indeterminate)
        'value: null'
      else
        'value: ${value.toStringAsFixed(2)}',
    ],
    child: switch (variant) {
      _ProgressVariant.linear => SizedBox(
        width: 240,
        child: VProgress.linear(
          value: indeterminate ? null : value,
          size: size,
        ),
      ),
      _ProgressVariant.circular => VProgress.circular(
        value: indeterminate ? null : value,
        size: size,
      ),
    },
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _ProgressShowcase extends StatelessWidget {
  const _ProgressShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VProgress',
    description:
        'Indicates progress of an operation with linear or circular variants.',
    children: [
      const WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'linear',
            labels: ['VProgress variant="linear"'],
            children: [
              SizedBox(width: 200, child: VProgress.linear(value: 0.6)),
            ],
          ),
          WidgetbookSubsection(
            title: 'circular',
            labels: ['VProgress variant="circular"'],
            children: [VProgress.circular(value: 0.6)],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Sizes (Linear)',
        children: [
          WidgetbookSubsection(
            title: 'sm',
            labels: ['VProgress size="sm"'],
            children: [
              SizedBox(
                width: 200,
                child: VProgress.linear(value: 0.6, size: VProgressSize.sm),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: ['VProgress size="md"'],
            children: [
              SizedBox(width: 200, child: VProgress.linear(value: 0.6)),
            ],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: ['VProgress size="lg"'],
            children: [
              SizedBox(
                width: 200,
                child: VProgress.linear(value: 0.6, size: VProgressSize.lg),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Sizes (Circular)',
        children: [
          WidgetbookSubsection(
            title: 'sm / md / lg',
            labels: ['VProgress variant="circular" size'],
            children: [
              VProgress.circular(value: 0.6, size: VProgressSize.sm),
              VProgress.circular(value: 0.6),
              VProgress.circular(value: 0.6, size: VProgressSize.lg),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Colors',
        children: [
          WidgetbookSubsection(
            title: 'primary',
            labels: ['VProgress color="primary"'],
            children: [
              SizedBox(width: 200, child: VProgress.linear(value: 0.6)),
            ],
          ),
          WidgetbookSubsection(
            title: 'secondary',
            labels: ['VProgress color="secondary"'],
            children: [
              SizedBox(width: 200, child: VProgress.linear(value: 0.6)),
            ],
          ),
          WidgetbookSubsection(
            title: 'destructive',
            labels: ['VProgress color="destructive"'],
            children: [
              SizedBox(width: 200, child: VProgress.linear(value: 0.6)),
            ],
          ),
          WidgetbookSubsection(
            title: 'success',
            labels: ['VProgress color="success"'],
            children: [
              SizedBox(width: 200, child: VProgress.linear(value: 0.6)),
            ],
          ),
          WidgetbookSubsection(
            title: 'warning',
            labels: ['VProgress color="warning"'],
            children: [
              SizedBox(width: 200, child: VProgress.linear(value: 0.6)),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Determinate Values',
        children: [
          WidgetbookSubsection(
            title: 'progress steps',
            labels: ['VProgress value: 0-100'],
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    VProgress.linear(value: 0),
                    SizedBox(height: 12),
                    VProgress.linear(value: 0.25),
                    SizedBox(height: 12),
                    VProgress.linear(value: 0.5),
                    SizedBox(height: 12),
                    VProgress.linear(value: 0.75),
                    SizedBox(height: 12),
                    VProgress.linear(value: 1),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Indeterminate',
        children: [
          WidgetbookSubsection(
            title: 'linear',
            labels: ['VProgress indeterminate'],
            children: [SizedBox(width: 200, child: VProgress.linear())],
          ),
          WidgetbookSubsection(
            title: 'circular',
            labels: ['VProgress indeterminate variant="circular"'],
            children: [VProgress.circular()],
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
          'Show progress for file uploads, form submissions, or any long-running operation.',
        ),
        _guidelineRow(
          theme,
          'When not to use',
          'For skeleton loading placeholders. Use VSkeleton instead.',
        ),
        _guidelineRow(
          theme,
          'Indeterminate',
          'Use indeterminate mode when the total duration or amount is unknown.',
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

class _ProgressSample extends StatelessWidget {
  const _ProgressSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VProgress Samples',
    description: 'Copy-paste code examples for VProgress.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic progress bar',
        code: '''VProgress.linear(value: 0.6)''',
        preview: SizedBox(width: 200, child: VProgress.linear(value: 0.6)),
      ),
      WidgetbookCodeBlock(
        title: 'Loading spinner (circular)',
        code: '''VProgress.circular()''',
        preview: Row(children: [VProgress.circular()]),
      ),
      WidgetbookCodeBlock(
        title: 'File upload progress',
        code: '''Column(
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text('Uploading...'), Text('75%')],
    ),
    VProgress.linear(value: 0.75),
  ],
)''',
        preview: SizedBox(
          width: 200,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Uploading...'), Text('75%')],
              ),
              SizedBox(height: 4),
              VProgress.linear(value: 0.75),
            ],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Indeterminate loading bar',
        code: '''VProgress.linear()''',
        preview: SizedBox(width: 200, child: VProgress.linear()),
      ),
      WidgetbookCodeBlock(
        title: 'Color comparison',
        code: '''VProgress.linear(value: 0.8)
VProgress.linear(value: 0.6)
VProgress.linear(value: 0.3)''',
        preview: SizedBox(
          width: 200,
          child: Column(
            children: [
              VProgress.linear(value: 0.8),
              SizedBox(height: 12),
              VProgress.linear(value: 0.6),
              SizedBox(height: 12),
              VProgress.linear(value: 0.3),
            ],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Circular size comparison',
        code: '''VProgress.circular(value: 0.75, size: VProgressSize.sm)
VProgress.circular(value: 0.75, size: VProgressSize.md)
VProgress.circular(value: 0.75, size: VProgressSize.lg)''',
        preview: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VProgress.circular(value: 0.75, size: VProgressSize.sm),
            SizedBox(width: 16),
            VProgress.circular(value: 0.75),
            SizedBox(width: 16),
            VProgress.circular(value: 0.75, size: VProgressSize.lg),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'File upload progress',
        code: '''Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('report.pdf'),
    SizedBox(height: 4),
    Row(
      children: [
        Expanded(child: VProgress.linear(value: 0.45, size: VProgressSize.sm)),
        SizedBox(width: 8),
        Text('45%'),
      ],
    ),
    SizedBox(height: 2),
    Text('2.3 MB / 5.1 MB', style: TextStyle(fontSize: 12)),
  ],
)''',
        preview: SizedBox(
          width: 260,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('report.pdf'),
              SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: VProgress.linear(
                      value: 0.45,
                      size: VProgressSize.sm,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('45%'),
                ],
              ),
              SizedBox(height: 2),
              Text('2.3 MB / 5.1 MB', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    ],
  );
}
