import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vImageComponent() => WidgetbookComponent(
  name: 'VImage',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _imagePlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _ImageShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _ImageSample(),
    ),
  ],
);

Widget _imagePlayground(BuildContext context) {
  final k = context.knobs;
  final width = k.double.slider(
    label: 'width',
    initialValue: 200,
    min: 40,
    max: 400,
  );
  final height = k.double.slider(
    label: 'height',
    initialValue: 200,
    min: 40,
    max: 400,
  );
  final fit = k.object.dropdown<BoxFit>(
    label: 'fit',
    options: BoxFit.values,
    initialOption: BoxFit.cover,
    labelBuilder: (v) => v.name,
  );
  final radius = k.double.slider(
    label: 'borderRadius',
    initialValue: 8,
    max: 100,
  );
  final placeholder = k.boolean(label: 'placeholder');
  final errorWidget = k.boolean(label: 'errorWidget');
  final fadeMs = k.int.slider(
    label: 'fadeInDuration (ms)',
    initialValue: 300,
    max: 2000,
  );
  final cacheWidth = k.int.slider(label: 'cacheWidth', max: 800);
  final cacheHeight = k.int.slider(label: 'cacheHeight', max: 800);
  final semanticLabel = k.string(label: 'semanticLabel');

  return WidgetbookPlayground(
    child: VImage.network(
      'https://picsum.photos/200',
      width: width,
      height: height,
      fit: fit,
      borderRadius: BorderRadius.circular(radius),
      placeholder: placeholder
          ? SizedBox(
              width: width,
              height: height,
              child: const Center(child: Text('Loading...')),
            )
          : null,
      errorWidget: errorWidget
          ? SizedBox(
              width: width,
              height: height,
              child: const Center(child: Text('Error')),
            )
          : null,
      fadeInDuration: Duration(milliseconds: fadeMs),
      cacheWidth: cacheWidth == 0 ? null : cacheWidth,
      cacheHeight: cacheHeight == 0 ? null : cacheHeight,
      semanticLabel: semanticLabel.isEmpty ? null : semanticLabel,
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _ImageShowcase extends StatelessWidget {
  const _ImageShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return WidgetbookPageLayout(
      title: 'VImage',
      description:
          'Displays images with placeholder support and error fallback.',
      children: [
        const WidgetbookSection(
          title: 'Basic',
          children: [
            WidgetbookSubsection(
              title: 'network image',
              labels: ['default'],
              children: [
                VImage.network(
                  'https://picsum.photos/200',
                  width: 200,
                  height: 200,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ],
            ),
          ],
        ),
        const WidgetbookSection(
          title: 'Fit Modes',
          children: [
            WidgetbookSubsection(
              title: 'cover',
              labels: ['VImage fit="cover"'],
              children: [
                VImage.network(
                  'https://picsum.photos/400/200',
                  width: 200,
                  height: 120,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'contain',
              labels: ['VImage fit="contain"'],
              children: [
                VImage.network(
                  'https://picsum.photos/400/201',
                  width: 200,
                  height: 120,
                  fit: BoxFit.contain,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'fill',
              labels: ['VImage fit="fill"'],
              children: [
                VImage.network(
                  'https://picsum.photos/400/202',
                  width: 200,
                  height: 120,
                  fit: BoxFit.fill,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'States',
          children: [
            WidgetbookSubsection(
              title: 'loading',
              labels: const ['VImage.network(placeholder:)'],
              children: [
                VImage.network(
                  'https://picsum.photos/300',
                  width: 150,
                  height: 150,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  placeholder: Container(
                    width: 150,
                    height: 150,
                    color: theme.colors.muted,
                    child: const Center(child: Text('Loading...')),
                  ),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'error',
              labels: const ['VImage.network(errorWidget:)'],
              children: [
                VImage.network(
                  'https://invalid-url-that-will-fail.com/image.jpg',
                  width: 150,
                  height: 150,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  errorWidget: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: theme.colors.muted,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Error',
                        style: TextStyle(color: theme.colors.mutedForeground),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Usage Guidelines
        _buildUsageGuidelines(context),
      ],
    );
  }

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
              'Display user-uploaded images, product photos, or media content with consistent sizing and error handling.',
            ),
            _guidelineRow(
              theme,
              'When not to use',
              'For decorative icons or SVG graphics. Use icon components instead.',
            ),
            _guidelineRow(
              theme,
              'Accessibility',
              'Always provide meaningful semanticLabel. Use empty string only for purely decorative images.',
            ),
            _guidelineRow(
              theme,
              'Fit',
              'Use BoxFit to control how images fill their container',
            ),
            _guidelineRow(
              theme,
              'Size',
              'Always specify width and height to prevent layout shift',
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

class _ImageSample extends StatelessWidget {
  const _ImageSample();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return WidgetbookPageLayout(
      title: 'VImage Samples',
      description: 'Copy-ready code examples.',
      children: [
        const WidgetbookCodeBlock(
          title: 'Basic Usage',
          code: '''VImage.network(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  borderRadius: BorderRadius.circular(8),
)''',
          preview: VImage.network(
            'https://picsum.photos/200',
            width: 150,
            height: 150,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'With Placeholder',
          code: '''VImage.network(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  placeholder: Center(child: VLoadingSpinner(color: theme.colors.primary, size: 24)),
)''',
          preview: VImage.network(
            'https://picsum.photos/201',
            width: 150,
            height: 150,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            placeholder: Container(
              width: 150,
              height: 150,
              color: theme.colors.muted,
              child: const Center(child: Text('Loading...')),
            ),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Error Handling',
          code: '''VImage.network(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  errorWidget: Icon(Icons.error),
)''',
          preview: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: theme.colors.muted,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Error',
                style: TextStyle(color: theme.colors.mutedForeground),
              ),
            ),
          ),
        ),
        const WidgetbookCodeBlock(
          title: 'Gallery grid',
          code: '''Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    VImage.network('https://picsum.photos/120?random=1', width: 120, height: 120, borderRadius: BorderRadius.circular(8)),
    VImage.network('https://picsum.photos/120?random=2', width: 120, height: 120, borderRadius: BorderRadius.circular(8)),
    VImage.network('https://picsum.photos/120?random=3', width: 120, height: 120, borderRadius: BorderRadius.circular(8)),
    VImage.network('https://picsum.photos/120?random=4', width: 120, height: 120, borderRadius: BorderRadius.circular(8)),
  ],
)''',
          preview: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              VImage.network(
                'https://picsum.photos/120?random=1',
                width: 120,
                height: 120,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              VImage.network(
                'https://picsum.photos/120?random=2',
                width: 120,
                height: 120,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              VImage.network(
                'https://picsum.photos/120?random=3',
                width: 120,
                height: 120,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              VImage.network(
                'https://picsum.photos/120?random=4',
                width: 120,
                height: 120,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ],
          ),
        ),
        const WidgetbookCodeBlock(
          title: 'Aspect ratio hero',
          code: '''Column(
  children: [
    VImage.network(
      'https://picsum.photos/400/200',
      width: 300,
      height: 150,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(12),
    ),
    SizedBox(height: 8),
    VImage.network(
      'https://picsum.photos/400/200',
      width: 300,
      height: 150,
      fit: BoxFit.contain,
      borderRadius: BorderRadius.circular(12),
    ),
  ],
)''',
          preview: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VImage.network(
                'https://picsum.photos/400/200',
                width: 300,
                height: 150,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              SizedBox(height: 8),
              VImage.network(
                'https://picsum.photos/400/201',
                width: 300,
                height: 150,
                fit: BoxFit.contain,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ],
          ),
        ),
        const WidgetbookCodeBlock(
          title: 'Image with placeholder',
          code: '''VImage.network(
  'https://picsum.photos/300/200',
  width: 300,
  height: 200,
  borderRadius: BorderRadius.circular(12),
  placeholder: Center(child: VLoadingSpinner()),
  errorWidget: Center(child: Icon(Icons.broken_image)),
)''',
          preview: VImage.network(
            'https://picsum.photos/300/202',
            width: 300,
            height: 200,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ],
    );
  }
}
