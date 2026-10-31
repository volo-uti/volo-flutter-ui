import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _CarouselKind { standard, fullWidth, card, hero }

WidgetbookComponent vCarouselComponent() => WidgetbookComponent(
  name: 'VCarousel',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _carouselPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _CarouselShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _CarouselSample(),
    ),
  ],
);

Widget _carouselPlayground(BuildContext context) {
  final k = context.knobs;
  final kind = k.object.dropdown<_CarouselKind>(
    label: 'variant',
    options: _CarouselKind.values,
    initialOption: _CarouselKind.standard,
    labelBuilder: (v) => v.name,
  );
  final height = k.double.slider(
    label: 'height',
    initialValue: 200,
    min: 100,
    max: 320,
  );
  final autoPlay = k.boolean(label: 'autoPlay');
  final autoPlayInterval = k.duration(
    label: 'autoPlayInterval',
    initialValue: const Duration(seconds: 3),
  );
  final loop = k.boolean(label: 'loop');
  final showIndicator = k.boolean(label: 'showIndicator', initialValue: true);
  final indicatorPosition = k.object.dropdown<VCarouselIndicatorPosition>(
    label: 'indicatorPosition',
    options: VCarouselIndicatorPosition.values,
    initialOption: VCarouselIndicatorPosition.bottom,
    labelBuilder: (v) => v.name,
  );
  final viewportFraction = k.double.slider(
    label: 'viewportFraction (standard)',
    initialValue: 0.8,
    min: 0.5,
    max: 1,
  );
  final pageSpacing = k.double.slider(
    label: 'pageSpacing',
    initialValue: 8,
    max: 32,
  );

  final items = _buildCarouselItems();
  final carousel = switch (kind) {
    _CarouselKind.standard => VCarousel(
      key: ValueKey(viewportFraction),
      height: height,
      autoPlay: autoPlay,
      autoPlayInterval: autoPlayInterval,
      loop: loop,
      showIndicator: showIndicator,
      indicatorPosition: indicatorPosition,
      viewportFraction: viewportFraction,
      pageSpacing: pageSpacing,
      children: items,
    ),
    _CarouselKind.fullWidth => VCarousel.fullWidth(
      height: height,
      autoPlay: autoPlay,
      autoPlayInterval: autoPlayInterval,
      loop: loop,
      showIndicator: showIndicator,
      indicatorPosition: indicatorPosition,
      pageSpacing: pageSpacing,
      children: items,
    ),
    _CarouselKind.card => VCarousel.card(
      height: height,
      autoPlay: autoPlay,
      autoPlayInterval: autoPlayInterval,
      loop: loop,
      showIndicator: showIndicator,
      indicatorPosition: indicatorPosition,
      pageSpacing: pageSpacing,
      children: items,
    ),
    _CarouselKind.hero => VCarousel.hero(
      height: height,
      autoPlay: autoPlay,
      autoPlayInterval: autoPlayInterval,
      loop: loop,
      showIndicator: showIndicator,
      indicatorPosition: indicatorPosition,
      pageSpacing: pageSpacing,
      children: items,
    ),
  };
  return WidgetbookPlayground(
    layout: PlaygroundLayout.stretch,
    child: KeyedSubtree(key: ValueKey(kind), child: carousel),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _CarouselShowcase extends StatelessWidget {
  const _CarouselShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VCarousel',
    description: 'A slideshow component for cycling through content panels.',
    children: [
      WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: const ['VCarousel()'],
            fullWidth: true,
            children: [VCarousel(height: 120, children: _buildCarouselItems())],
          ),
          WidgetbookSubsection(
            title: 'fullWidth',
            labels: const ['VCarousel.fullWidth()'],
            fullWidth: true,
            children: [
              VCarousel.fullWidth(height: 120, children: _buildCarouselItems()),
            ],
          ),
          WidgetbookSubsection(
            title: 'card',
            labels: const ['VCarousel.card()'],
            fullWidth: true,
            children: [
              VCarousel.card(height: 120, children: _buildCarouselItems()),
            ],
          ),
          WidgetbookSubsection(
            title: 'hero',
            labels: const ['VCarousel.hero()'],
            fullWidth: true,
            children: [
              VCarousel.hero(height: 140, children: _buildCarouselItems()),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Indicator Position',
        children: [
          WidgetbookSubsection(
            title: 'bottom',
            labels: const ['VCarouselIndicatorPosition.bottom'],
            fullWidth: true,
            children: [VCarousel(height: 100, children: _buildCarouselItems())],
          ),
          WidgetbookSubsection(
            title: 'belowCarousel',
            labels: const ['VCarouselIndicatorPosition.belowCarousel'],
            fullWidth: true,
            children: [
              VCarousel(
                height: 100,
                indicatorPosition: VCarouselIndicatorPosition.belowCarousel,
                children: _buildCarouselItems(),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'overlay',
            labels: const ['VCarouselIndicatorPosition.overlay'],
            fullWidth: true,
            children: [
              VCarousel.fullWidth(
                height: 120,
                indicatorPosition: VCarouselIndicatorPosition.overlay,
                children: _buildCarouselItems(),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'none',
            labels: const ['VCarouselIndicatorPosition.none'],
            fullWidth: true,
            children: [
              VCarousel(
                height: 100,
                indicatorPosition: VCarouselIndicatorPosition.none,
                children: _buildCarouselItems(),
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
              'Use when displaying content in slides (banners, image galleries, etc.)',
            ),
            _guidelineRow(
              theme,
              'indicator',
              'Show an indicator so users can see the current position',
            ),
            _guidelineRow(
              theme,
              'autoPlay',
              'Use auto-play cautiously; ensure users retain control',
            ),
            _guidelineRow(
              theme,
              'loop',
              'Only use loop: true when content should cycle continuously',
            ),
            _guidelineRow(
              theme,
              'height',
              'Set an appropriate height for the content; avoid too large or too small',
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

class _CarouselSample extends StatelessWidget {
  const _CarouselSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VCarousel Samples',
    description: 'Copy-ready code examples.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic Usage',
        code: '''VCarousel(
  height: 150,
  children: [
    Container(color: Colors.blue, child: Text('1')),
    Container(color: Colors.green, child: Text('2')),
    Container(color: Colors.red, child: Text('3')),
  ],
)''',
        preview: VCarousel(height: 120, children: _buildCarouselItems()),
      ),
      WidgetbookCodeBlock(
        title: 'Full Width',
        code: '''VCarousel.fullWidth(
  height: 150,
  children: [...],
)''',
        preview: VCarousel.fullWidth(
          height: 120,
          children: _buildCarouselItems(),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Auto Play',
        code: '''VCarousel.hero(
  height: 180,
  autoPlay: true,
  loop: true,
  children: [...],
)''',
        preview: VCarousel.hero(height: 140, children: _buildCarouselItems()),
      ),
      WidgetbookCodeBlock(
        title: 'Number Indicator',
        code: '''VCarousel(
  height: 150,
  indicatorBuilder: (context, total, current) {
    return VPageIndicator.number(
      total: total,
      current: current,
    );
  },
  children: [...],
)''',
        preview: VCarousel(
          height: 120,
          indicatorBuilder: (context, total, current) =>
              VPageIndicator.number(total: total, current: current),
          children: _buildCarouselItems(),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Line Indicator (Stories)',
        code: '''VCarousel.fullWidth(
  height: 150,
  indicatorPosition: VCarouselIndicatorPosition.overlay,
  indicatorBuilder: (context, total, current) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: VPageIndicator.line(
        total: total,
        current: current,
        activeColor: Colors.white,
        inactiveColor: Colors.white.withOpacity(0.3),
      ),
    );
  },
  children: [...],
)''',
        preview: VCarousel.fullWidth(
          height: 140,
          indicatorPosition: VCarouselIndicatorPosition.overlay,
          indicatorBuilder: (context, total, current) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: VPageIndicator.line(
              total: total,
              current: current,
              activeColor: const Color(0xFFFFFFFF),
              inactiveColor: const Color(0x4DFFFFFF),
            ),
          ),
          children: _buildCarouselItems(),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Custom Dots',
        code: '''VCarousel(
  height: 150,
  indicatorBuilder: (context, total, current) {
    return VPageIndicator.dots(
      total: total,
      current: current,
      size: 10,
      spacing: 8,
      borderWidth: 2,
      borderColor: Colors.blue,
      activeColor: Colors.blue,
      inactiveColor: Colors.transparent,
    );
  },
  children: [...],
)''',
        preview: VCarousel(
          height: 120,
          indicatorBuilder: (context, total, current) => VPageIndicator.dots(
            total: total,
            current: current,
            size: 10,
            spacing: 8,
            borderWidth: 2,
            borderColor: const Color(0xFF3B82F6),
            activeColor: const Color(0xFF3B82F6),
            inactiveColor: const Color(0x00000000),
          ),
          children: _buildCarouselItems(),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Card variant with loop',
        code: '''VCarousel.card(
  height: 180,
  autoPlay: true,
  autoPlayInterval: Duration(seconds: 4),
  loop: true,
  children: [
    VImage.network('https://picsum.photos/400/180?1'),
    VImage.network('https://picsum.photos/400/180?2'),
    VImage.network('https://picsum.photos/400/180?3'),
  ],
)''',
        preview: VCarousel.card(
          height: 120,
          loop: true,
          children: _buildCarouselItems(),
        ),
      ),
    ],
  );
}

// =============================================================================
// Helper Functions
// =============================================================================

List<Widget> _buildCarouselItems() {
  final colors = [
    const Color(0xFF3B82F6),
    const Color(0xFF10B981),
    const Color(0xFFF59E0B),
    const Color(0xFFEF4444),
    const Color(0xFF8B5CF6),
  ];

  return List.generate(
    5,
    (index) => Container(
      decoration: BoxDecoration(
        color: colors[index],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'Slide ${index + 1}',
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
