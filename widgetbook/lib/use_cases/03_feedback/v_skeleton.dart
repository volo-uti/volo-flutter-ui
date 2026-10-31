import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _SkeletonVariant { rectangular, text, circular }

WidgetbookComponent vSkeletonComponent() => WidgetbookComponent(
  name: 'VSkeleton',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _skeletonPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _SkeletonShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _SkeletonSample(),
    ),
  ],
);

Widget _skeletonPlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_SkeletonVariant>(
    label: 'variant',
    options: _SkeletonVariant.values,
    labelBuilder: (v) => v.name,
  );
  final animation = k.object.dropdown<VSkeletonAnimation>(
    label: 'animation',
    options: VSkeletonAnimation.values,
    initialOption: VSkeletonAnimation.pulse,
    labelBuilder: (v) => v.name,
  );
  final width = k.double.slider(
    label: 'width',
    initialValue: 200,
    min: 40,
    max: 400,
  );
  final height = k.double.slider(
    label: 'height',
    initialValue: 80,
    min: 8,
    max: 200,
  );
  final size = k.double.slider(
    label: 'size',
    initialValue: 40,
    min: 16,
    max: 120,
  );
  final lines = k.int.slider(label: 'lines', initialValue: 3, min: 1, max: 8);
  final spacing = k.double.slider(label: 'spacing', initialValue: 8, max: 24);

  return WidgetbookPlayground(
    child: switch (variant) {
      _SkeletonVariant.rectangular => VSkeleton.rectangular(
        width: width,
        height: height,
        animation: animation,
      ),
      _SkeletonVariant.text => VSkeleton.text(
        width: width,
        lines: lines,
        spacing: spacing,
        animation: animation,
      ),
      _SkeletonVariant.circular => VSkeleton.circular(
        size: size,
        animation: animation,
      ),
    },
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _SkeletonShowcase extends StatelessWidget {
  const _SkeletonShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VSkeleton',
    description: 'Placeholder component displayed while content is loading.',
    children: [
      const WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'text',
            labels: ['VSkeleton variant="text"'],
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VSkeleton.rectangular(width: 200),
                    SizedBox(height: 8),
                    VSkeleton.rectangular(width: 150),
                  ],
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'circular',
            labels: ['VSkeleton variant="circular"'],
            children: [VSkeleton.circular(), VSkeleton.circular(size: 56)],
          ),
          WidgetbookSubsection(
            title: 'rectangular',
            labels: ['VSkeleton variant="rectangular"'],
            children: [VSkeleton.rectangular(width: 200, height: 120)],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Animations',
        children: [
          WidgetbookSubsection(
            title: 'pulse (default)',
            labels: ['VSkeleton animation="pulse"'],
            children: [VSkeleton.rectangular(width: 200, height: 80)],
          ),
          WidgetbookSubsection(
            title: 'wave',
            labels: ['VSkeleton animation="wave"'],
            children: [
              VSkeleton.rectangular(
                width: 200,
                height: 80,
                animation: VSkeletonAnimation.wave,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'none',
            labels: ['VSkeleton animation={false}'],
            children: [
              VSkeleton.rectangular(
                width: 200,
                height: 80,
                animation: VSkeletonAnimation.none,
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Custom Dimensions',
        children: [
          WidgetbookSubsection(
            title: 'circular sizes',
            labels: ['VSkeleton width/height'],
            children: [
              VSkeleton.circular(size: 32),
              VSkeleton.circular(size: 48),
              VSkeleton.circular(size: 64),
            ],
          ),
          WidgetbookSubsection(
            title: 'text widths',
            labels: ['VSkeleton width'],
            children: [
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VSkeleton.rectangular(),
                    SizedBox(height: 8),
                    VSkeleton.rectangular(width: 180),
                    SizedBox(height: 8),
                    VSkeleton.rectangular(width: 150),
                    SizedBox(height: 8),
                    VSkeleton.rectangular(width: 120),
                  ],
                ),
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
          'Display placeholder shapes while content is being fetched or computed.',
        ),
        _guidelineRow(
          theme,
          'When not to use',
          'For determinate progress indicators. Use VProgress instead.',
        ),
        _guidelineRow(
          theme,
          'Layout',
          'Match skeleton dimensions to the final content to minimize layout shift on load.',
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

class _SkeletonSample extends StatelessWidget {
  const _SkeletonSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VSkeleton Samples',
    description: 'Copy-paste code examples for VSkeleton.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Text loading',
        code: '''VSkeleton.text(lines: 2)''',
        preview: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSkeleton.rectangular(width: 200),
              SizedBox(height: 8),
              VSkeleton.rectangular(width: 150),
            ],
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Card placeholder',
        code: '''Row(
  children: [
    VSkeleton.circular(size: 48),
    SizedBox(width: 16),
    Column(children: [
      VSkeleton.rectangular(width: 150, height: 16),
      VSkeleton.rectangular(width: 100, height: 12),
      VSkeleton.rectangular(width: 200, height: 80),
    ]),
  ],
)''',
        preview: SizedBox(
          width: 250,
          child: VStack.horizontal(
            spacing: 12,
            children: [
              VSkeleton.circular(size: 48),
              Expanded(
                child: VStack.vertical(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    VSkeleton.rectangular(width: 150),
                    VSkeleton.rectangular(width: 100, height: 12),
                    VSkeleton.rectangular(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'List item loading',
        code: '''Column(
  children: List.generate(3, (i) => Row(
    children: [
      VSkeleton.circular(size: 40),
      Column(children: [
        VSkeleton.rectangular(width: 120, height: 14),
        VSkeleton.rectangular(width: 80, height: 10),
      ]),
    ],
  )),
)''',
        preview: SizedBox(
          width: 250,
          child: Column(
            children: List.generate(
              3,
              (i) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: VStack.horizontal(
                  spacing: 12,
                  children: [
                    VSkeleton.circular(),
                    Expanded(
                      child: VStack.vertical(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          VSkeleton.rectangular(width: 120, height: 14),
                          VSkeleton.rectangular(width: 80, height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Image area loading',
        code: '''VSkeleton.rectangular(width: 200, height: 200)''',
        preview: VSkeleton.rectangular(width: 200, height: 200),
      ),
      const WidgetbookCodeBlock(
        title: 'Wave animation',
        code: '''VSkeleton.rectangular(
  width: 200,
  height: 100,
  animation: VSkeletonAnimation.wave,
)''',
        preview: VSkeleton.rectangular(
          width: 200,
          height: 100,
          animation: VSkeletonAnimation.wave,
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Profile page skeleton',
        code: '''Column(
  children: [
    // Avatar
    VSkeleton.circular(size: 80),
    SizedBox(height: 16),
    // Name
    VSkeleton.rectangular(width: 160, height: 20),
    SizedBox(height: 8),
    // Bio lines
    VSkeleton.rectangular(width: 240, height: 14),
    VSkeleton.rectangular(width: 200, height: 14),
    SizedBox(height: 16),
    // Stats row
    Row(children: [
      VSkeleton.rectangular(width: 80, height: 40),
      VSkeleton.rectangular(width: 80, height: 40),
      VSkeleton.rectangular(width: 80, height: 40),
    ]),
  ],
)''',
        preview: SizedBox(
          width: 280,
          child: VStack.vertical(
            spacing: 8,
            children: [
              VSkeleton.circular(size: 80),
              SizedBox(height: 8),
              VSkeleton.rectangular(width: 160, height: 20),
              SizedBox(height: 4),
              VSkeleton.rectangular(width: 240, height: 14),
              VSkeleton.rectangular(width: 200, height: 14),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VSkeleton.rectangular(width: 70, height: 40),
                  SizedBox(width: 12),
                  VSkeleton.rectangular(width: 70, height: 40),
                  SizedBox(width: 12),
                  VSkeleton.rectangular(width: 70, height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Card skeleton',
        code: '''SizedBox(
  width: 280,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      VSkeleton.rectangular(width: 280, height: 160),
      SizedBox(height: 12),
      VSkeleton.rectangular(width: 200, height: 18),
      SizedBox(height: 8),
      VSkeleton.rectangular(width: 260, height: 14),
      VSkeleton.rectangular(width: 180, height: 14),
    ],
  ),
)''',
        preview: SizedBox(
          width: 280,
          child: VStack.vertical(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              VSkeleton.rectangular(width: 280, height: 160),
              SizedBox(height: 4),
              VSkeleton.rectangular(width: 200, height: 18),
              VSkeleton.rectangular(width: 260, height: 14),
              VSkeleton.rectangular(width: 180, height: 14),
            ],
          ),
        ),
      ),
    ],
  );
}
