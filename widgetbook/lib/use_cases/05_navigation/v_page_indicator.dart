import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vPageIndicatorComponent() => WidgetbookComponent(
  name: 'VPageIndicator',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _pageIndicatorPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _PageIndicatorShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _PageIndicatorSample(),
    ),
  ],
);

Widget _pageIndicatorPlayground(BuildContext context) {
  final k = context.knobs;
  final kind = k.object.dropdown<VPageIndicatorStyle>(
    label: 'style',
    options: VPageIndicatorStyle.values,
    initialOption: VPageIndicatorStyle.dots,
    labelBuilder: (v) => v.name,
  );
  final total = k.int.slider(label: 'total', initialValue: 5, min: 1, max: 12);
  var current = k.int.slider(label: 'current', initialValue: 2, max: 11);
  final interactive = k.boolean(label: 'interactive', initialValue: true);
  final animationDuration = k.duration(
    label: 'animationDuration',
    initialValue: const Duration(milliseconds: 200),
  );
  final activeColor = k.colorOrNull(label: 'activeColor');
  final inactiveColor = k.colorOrNull(label: 'inactiveColor');
  // Dots
  final size = k.double.slider(label: 'size', initialValue: 8, min: 4, max: 24);
  final spacing = k.double.slider(label: 'spacing', initialValue: 6, max: 24);
  final expandActive = k.boolean(label: 'expandActive', initialValue: true);
  final borderWidth = k.double.slider(label: 'borderWidth', max: 4);
  // Number
  final separator = k.object.dropdown<VPageIndicatorSeparator>(
    label: 'separator',
    options: VPageIndicatorSeparator.values,
    initialOption: VPageIndicatorSeparator.slash,
    labelBuilder: (v) => v.name,
  );
  // Line
  final lineHeight = k.double.slider(
    label: 'lineHeight',
    initialValue: 3,
    min: 1,
    max: 12,
  );
  final lineSpacing = k.double.slider(
    label: 'lineSpacing',
    initialValue: 4,
    max: 16,
  );

  return StatefulBuilder(
    builder: (context, setState) {
      final page = current.clamp(0, total - 1);
      void select(int index) => setState(() => current = index);
      final onPageChanged = interactive ? select : null;
      final indicator = switch (kind) {
        VPageIndicatorStyle.dots => VPageIndicator.dots(
          total: total,
          current: page,
          onPageChanged: onPageChanged,
          animationDuration: animationDuration,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          size: size,
          spacing: spacing,
          expandActive: expandActive,
          borderWidth: borderWidth,
        ),
        VPageIndicatorStyle.number => VPageIndicator.number(
          total: total,
          current: page,
          onPageChanged: onPageChanged,
          animationDuration: animationDuration,
          separator: separator,
        ),
        VPageIndicatorStyle.line => SizedBox(
          width: 240,
          child: VPageIndicator.line(
            total: total,
            current: page,
            onPageChanged: onPageChanged,
            animationDuration: animationDuration,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            lineHeight: lineHeight,
            lineSpacing: lineSpacing,
          ),
        ),
      };
      return WidgetbookPlayground(
        info: ['current: $page'],
        child: Center(child: indicator),
      );
    },
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _PageIndicatorShowcase extends StatefulWidget {
  const _PageIndicatorShowcase();

  @override
  State<_PageIndicatorShowcase> createState() => _PageIndicatorShowcaseState();
}

class _PageIndicatorShowcaseState extends State<_PageIndicatorShowcase> {
  int _dotsPage = 2;
  int _numberPage = 2;
  int _linePage = 2;

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VPageIndicator',
    description:
        'Visual indicator showing current position in a paginated series.',
    children: [
      WidgetbookSection(
        title: 'Styles',
        children: [
          WidgetbookSubsection(
            title: 'dots',
            labels: const ['VPageIndicator.dots()'],
            children: [
              VPageIndicator.dots(
                total: 5,
                current: _dotsPage,
                onPageChanged: (i) => setState(() => _dotsPage = i),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'number',
            labels: const ['VPageIndicator.number()'],
            children: [
              VPageIndicator.number(
                total: 5,
                current: _numberPage,
                onPageChanged: (i) => setState(() => _numberPage = i),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'line',
            labels: const ['VPageIndicator.line()'],
            children: [
              SizedBox(
                width: 200,
                child: VPageIndicator.line(
                  total: 5,
                  current: _linePage,
                  onPageChanged: (i) => setState(() => _linePage = i),
                ),
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Dots Customization',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: const ['VPageIndicator.dots()'],
            children: [
              VPageIndicator.dots(
                total: 5,
                current: _dotsPage,
                onPageChanged: (i) => setState(() => _dotsPage = i),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'border',
            labels: const ['VPageIndicator.dots(borderWidth: 2)'],
            children: [
              VPageIndicator.dots(
                total: 5,
                current: _dotsPage,
                onPageChanged: (i) => setState(() => _dotsPage = i),
                size: 10,
                borderWidth: 2,
                borderColor: const Color(0xFF3B82F6),
                inactiveColor: const Color(0x00000000),
                activeColor: const Color(0xFF3B82F6),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'large',
            labels: const ['VPageIndicator.dots(size: 12)'],
            children: [
              VPageIndicator.dots(
                total: 5,
                current: _dotsPage,
                onPageChanged: (i) => setState(() => _dotsPage = i),
                size: 12,
                activeSize: 14,
                spacing: 10,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'expand',
            labels: const ['VPageIndicator.dots(expandActive: true)'],
            children: [
              VPageIndicator.dots(
                total: 5,
                current: _dotsPage,
                onPageChanged: (i) => setState(() => _dotsPage = i),
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Number Separators',
        children: [
          WidgetbookSubsection(
            title: 'slash',
            labels: const ['VPageIndicatorSeparator.slash'],
            children: [
              VPageIndicator.number(
                total: 10,
                current: _numberPage,
                onPageChanged: (i) => setState(() => _numberPage = i),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'of',
            labels: const ['VPageIndicatorSeparator.of'],
            children: [
              VPageIndicator.number(
                total: 10,
                current: _numberPage,
                onPageChanged: (i) => setState(() => _numberPage = i),
                separator: VPageIndicatorSeparator.of,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'dash',
            labels: const ['VPageIndicatorSeparator.dash'],
            children: [
              VPageIndicator.number(
                total: 10,
                current: _numberPage,
                onPageChanged: (i) => setState(() => _numberPage = i),
                separator: VPageIndicatorSeparator.dash,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'pipe',
            labels: const ['VPageIndicatorSeparator.pipe'],
            children: [
              VPageIndicator.number(
                total: 10,
                current: _numberPage,
                onPageChanged: (i) => setState(() => _numberPage = i),
                separator: VPageIndicatorSeparator.pipe,
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Line Style',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: const ['VPageIndicator.line()'],
            children: [
              SizedBox(
                width: 200,
                child: VPageIndicator.line(
                  total: 5,
                  current: _linePage,
                  onPageChanged: (i) => setState(() => _linePage = i),
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'thick',
            labels: const ['VPageIndicator.line(lineHeight: 6)'],
            children: [
              SizedBox(
                width: 200,
                child: VPageIndicator.line(
                  total: 5,
                  current: _linePage,
                  onPageChanged: (i) => setState(() => _linePage = i),
                  lineHeight: 6,
                  lineSpacing: 6,
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'custom color',
            labels: const ['VPageIndicator.line(activeColor: ...)'],
            children: [
              SizedBox(
                width: 200,
                child: VPageIndicator.line(
                  total: 5,
                  current: _linePage,
                  onPageChanged: (i) => setState(() => _linePage = i),
                  activeColor: const Color(0xFF10B981),
                  inactiveColor: const Color(0x3310B981),
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
              'Use to indicate current position in carousels, onboarding, and image galleries',
            ),
            _guidelineRow(
              theme,
              'dots',
              'Most common, suitable for small page counts (5 or fewer recommended)',
            ),
            _guidelineRow(
              theme,
              'number',
              'Suitable for large page counts, provides exact position',
            ),
            _guidelineRow(
              theme,
              'line',
              'Story-style, suitable for progress indication',
            ),
            _guidelineRow(
              theme,
              'VPagination',
              'Use VPagination for table/list navigation instead',
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

class _PageIndicatorSample extends StatelessWidget {
  const _PageIndicatorSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VPageIndicator Samples',
    description: 'Copy-ready code examples.',
    children: [
      WidgetbookCodeBlock(
        title: 'Dots (Default)',
        code: '''VPageIndicator.dots(
  total: 5,
  current: 2,
)''',
        preview: VPageIndicator.dots(total: 5, current: 2),
      ),
      WidgetbookCodeBlock(
        title: 'Dots with Border',
        code: '''VPageIndicator.dots(
  total: 5,
  current: 2,
  size: 10,
  borderWidth: 2,
  borderColor: Colors.blue,
  inactiveColor: Colors.transparent,
  activeColor: Colors.blue,
)''',
        preview: VPageIndicator.dots(
          total: 5,
          current: 2,
          size: 10,
          borderWidth: 2,
          borderColor: Color(0xFF3B82F6),
          inactiveColor: Color(0x00000000),
          activeColor: Color(0xFF3B82F6),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Number Style',
        code: '''VPageIndicator.number(
  total: 10,
  current: 4,
  separator: VPageIndicatorSeparator.of,
)''',
        preview: VPageIndicator.number(
          total: 10,
          current: 4,
          separator: VPageIndicatorSeparator.of,
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Line Style (Stories)',
        code: '''VPageIndicator.line(
  total: 5,
  current: 2,
  lineHeight: 3,
  lineSpacing: 4,
)''',
        preview: SizedBox(
          width: 200,
          child: VPageIndicator.line(total: 5, current: 2),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'With Carousel',
        code: '''VCarousel(
  height: 200,
  indicatorBuilder: (context, total, current) {
    return VPageIndicator.number(
      total: total,
      current: current,
    );
  },
  children: [...],
)''',
        preview: VPageIndicator.number(total: 5, current: 1),
      ),
      WidgetbookCodeBlock(
        title: 'Custom colored dots',
        code: '''VPageIndicator.dots(
  total: 4,
  current: 1,
  size: 12,
  activeSize: 14,
  activeColor: Color(0xFF10B981),
  inactiveColor: Color(0x3310B981),
  spacing: 10,
  expandActive: false,
)''',
        preview: VPageIndicator.dots(
          total: 4,
          current: 1,
          size: 12,
          activeSize: 14,
          activeColor: Color(0xFF10B981),
          inactiveColor: Color(0x3310B981),
          spacing: 10,
          expandActive: false,
        ),
      ),
    ],
  );
}
