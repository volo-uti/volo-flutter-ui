import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vLoadingSpinnerComponent() => WidgetbookComponent(
  name: 'VLoadingSpinner',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _loadingSpinnerPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _LoadingSpinnerShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _LoadingSpinnerSample(),
    ),
  ],
);

Widget _loadingSpinnerPlayground(BuildContext context) {
  final k = context.knobs;
  final size = k.double.slider(
    label: 'size',
    initialValue: 48,
    min: 12,
    max: 96,
  );
  final strokeWidth = k.double.slider(
    label: 'strokeWidth',
    initialValue: 4,
    min: 1,
    max: 12,
  );
  final color = k.object.dropdown<Color>(
    label: 'color',
    options: [
      VTheme.of(context).colors.primary,
      VTheme.of(context).colors.destructive,
      VTheme.of(context).colors.foreground,
    ],
    labelBuilder: (c) => switch (c) {
      _ when c == VTheme.of(context).colors.destructive => 'destructive',
      _ when c == VTheme.of(context).colors.foreground => 'foreground',
      _ => 'primary',
    },
  );

  return WidgetbookPlayground(
    child: VLoadingSpinner(color: color, size: size, strokeWidth: strokeWidth),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _LoadingSpinnerShowcase extends StatelessWidget {
  const _LoadingSpinnerShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final colors = theme.colors;

    return WidgetbookPageLayout(
      title: 'VLoadingSpinner',
      description:
          'Arc-based loading animation with customizable size and color.',
      children: [
        WidgetbookSection(
          title: 'Sizes',
          children: [
            WidgetbookSubsection(
              title: 'small',
              labels: const ['size=16'],
              children: [VLoadingSpinner(color: colors.primary, size: 16)],
            ),
            WidgetbookSubsection(
              title: 'medium',
              labels: const ['size=32'],
              children: [VLoadingSpinner(color: colors.primary, size: 32)],
            ),
            WidgetbookSubsection(
              title: 'large',
              labels: const ['size=48'],
              children: [VLoadingSpinner(color: colors.primary, size: 48)],
            ),
            WidgetbookSubsection(
              title: 'extra large',
              labels: const ['size=64'],
              children: [VLoadingSpinner(color: colors.primary, size: 64)],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Colors',
          children: [
            WidgetbookSubsection(
              title: 'primary',
              labels: const ['color=primary'],
              children: [VLoadingSpinner(color: colors.primary, size: 32)],
            ),
            WidgetbookSubsection(
              title: 'success',
              labels: const ['color=success'],
              children: [VLoadingSpinner(color: colors.success, size: 32)],
            ),
            WidgetbookSubsection(
              title: 'error',
              labels: const ['color=error'],
              children: [VLoadingSpinner(color: colors.error, size: 32)],
            ),
            WidgetbookSubsection(
              title: 'foreground',
              labels: const ['color=foreground'],
              children: [VLoadingSpinner(color: colors.foreground, size: 32)],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Custom Stroke',
          children: [
            WidgetbookSubsection(
              title: 'thin',
              labels: const ['strokeWidth=1'],
              children: [
                VLoadingSpinner(
                  color: colors.primary,
                  size: 48,
                  strokeWidth: 1,
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'thick',
              labels: const ['strokeWidth=6'],
              children: [
                VLoadingSpinner(
                  color: colors.primary,
                  size: 48,
                  strokeWidth: 6,
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

class _LoadingSpinnerSample extends StatelessWidget {
  const _LoadingSpinnerSample();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final colors = theme.colors;

    return WidgetbookPageLayout(
      title: 'VLoadingSpinner Samples',
      description: 'Copy-paste code examples for VLoadingSpinner.',
      children: [
        WidgetbookCodeBlock(
          title: 'Basic spinner',
          code: '''VLoadingSpinner(
  color: theme.colors.primary,
  size: 32,
)''',
          preview: SizedBox(
            width: 64,
            height: 64,
            child: VLoadingSpinner(color: colors.primary, size: 32),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Large colored spinner',
          code: '''VLoadingSpinner(
  color: theme.colors.success,
  size: 64,
)''',
          preview: SizedBox(
            width: 80,
            height: 80,
            child: VLoadingSpinner(color: colors.success, size: 64),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Custom stroke width',
          code: '''VLoadingSpinner(
  color: theme.colors.primary,
  size: 48,
  strokeWidth: 2,
)''',
          preview: SizedBox(
            width: 64,
            height: 64,
            child: VLoadingSpinner(
              color: colors.primary,
              size: 48,
              strokeWidth: 2,
            ),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Button loading state',
          code: '''VButton(
  onPressed: null,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      VLoadingSpinner(color: Colors.white, size: 16),
      SizedBox(width: 8),
      Text('Saving...'),
    ],
  ),
)''',
          preview: VButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                VLoadingSpinner(color: colors.primaryForeground, size: 16),
                const SizedBox(width: 8),
                const Text('Saving...'),
              ],
            ),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Page loading',
          code: '''Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      VLoadingSpinner(color: theme.colors.primary, size: 48),
      SizedBox(height: 16),
      Text('Loading...'),
    ],
  ),
)''',
          preview: SizedBox(
            height: 120,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VLoadingSpinner(color: colors.primary, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Loading...',
                    style: theme.typography.bodySmall.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Inline loading',
          code: '''Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    VLoadingSpinner(size: 16),
    SizedBox(width: 8),
    Text('Saving...'),
  ],
)''',
          preview: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              VLoadingSpinner(color: colors.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                'Saving...',
                style: theme.typography.bodySmall.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
