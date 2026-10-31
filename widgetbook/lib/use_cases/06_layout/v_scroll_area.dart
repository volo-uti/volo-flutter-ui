import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _ScrollKind { vertical, horizontal, both }

WidgetbookComponent vScrollAreaComponent() => WidgetbookComponent(
  name: 'VScrollArea',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _scrollAreaPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _ScrollAreaShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _ScrollAreaSample(),
    ),
  ],
);

Widget _scrollAreaPlayground(BuildContext context) {
  final k = context.knobs;
  final kind = k.object.dropdown<_ScrollKind>(
    label: 'direction',
    options: _ScrollKind.values,
    initialOption: _ScrollKind.vertical,
    labelBuilder: (v) => v.name,
  );
  final thickness = k.double.slider(
    label: 'scrollbarThickness',
    initialValue: 6,
    min: 2,
    max: 16,
  );
  final radius = k.double.slider(
    label: 'scrollbarRadius',
    initialValue: 3,
    max: 8,
  );
  final thumbVisibility = k.boolean(label: 'thumbVisibility');
  final trackVisibility = k.boolean(label: 'trackVisibility');
  final thumbColor = k.colorOrNull(label: 'thumbColor');
  final trackColor = k.colorOrNull(label: 'trackColor');
  final padding = k.double.slider(label: 'padding', max: 32);

  final contentPadding = EdgeInsets.all(padding);
  final scrollArea = switch (kind) {
    _ScrollKind.vertical => VScrollArea(
      padding: contentPadding,
      scrollbarThickness: thickness,
      scrollbarRadius: radius,
      thumbVisibility: thumbVisibility,
      trackVisibility: trackVisibility,
      thumbColor: thumbColor,
      trackColor: trackColor,
      child: Column(
        children: List.generate(15, (i) => _ScrollItem(label: 'Item $i')),
      ),
    ),
    _ScrollKind.horizontal => VScrollArea.horizontal(
      padding: contentPadding,
      scrollbarThickness: thickness,
      scrollbarRadius: radius,
      thumbVisibility: thumbVisibility,
      trackVisibility: trackVisibility,
      thumbColor: thumbColor,
      trackColor: trackColor,
      child: Row(
        children: List.generate(
          15,
          (i) => _ScrollItem(label: 'Card $i', width: 80),
        ),
      ),
    ),
    _ScrollKind.both => VScrollArea.both(
      padding: contentPadding,
      scrollbarThickness: thickness,
      scrollbarRadius: radius,
      thumbVisibility: thumbVisibility,
      trackVisibility: trackVisibility,
      thumbColor: thumbColor,
      trackColor: trackColor,
      child: const SizedBox(
        width: 500,
        height: 400,
        child: Center(child: Text('500 x 400')),
      ),
    ),
  };

  return WidgetbookPlayground(
    child: SizedBox(width: 250, height: 150, child: scrollArea),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _ScrollAreaShowcase extends StatelessWidget {
  const _ScrollAreaShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VScrollArea',
    description: 'Custom scrollable container with styled scrollbar.',
    children: [
      const WidgetbookSection(
        title: 'Directions',
        children: [
          WidgetbookSubsection(
            title: 'vertical',
            labels: ['VScrollArea()'],
            children: [_VerticalDemo()],
          ),
          WidgetbookSubsection(
            title: 'horizontal',
            labels: ['VScrollArea.horizontal()'],
            children: [_HorizontalDemo()],
          ),
          WidgetbookSubsection(
            title: 'both',
            labels: ['VScrollArea.both()'],
            children: [_BothDemo()],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Options',
        children: [
          WidgetbookSubsection(
            title: 'always visible',
            labels: ['thumbVisibility: true'],
            children: [_AlwaysVisibleDemo()],
          ),
          WidgetbookSubsection(
            title: 'with track',
            labels: ['trackVisibility: true'],
            children: [_WithTrackDemo()],
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
              'Constrained content areas: sidebars, dropdowns, chat panels, code blocks',
            ),
            _guidelineRow(
              theme,
              'Scrollbar',
              'Use "auto" for most cases. "hover" for cleaner UI. "always" for discoverability',
            ),
            _guidelineRow(
              theme,
              'Max height',
              'Always set maxHeight to constrain the scroll area. Without it, content will expand',
            ),
            _guidelineRow(
              theme,
              'Accessibility',
              'Ensure scrollable area is keyboard-navigable with proper focus management',
            ),
            _guidelineRow(
              theme,
              'Controller',
              'Pass a controller for programmatic scrolling',
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

class _ScrollAreaSample extends StatelessWidget {
  const _ScrollAreaSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VScrollArea Samples',
    description: 'Copy-ready code examples.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic Vertical Scroll',
        code: r'''VScrollArea(
  child: Column(
    children: List.generate(50, (i) => VListTile(title: Text('Item $i'))),
  ),
)''',
        preview: _VerticalDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Horizontal Scroll',
        code: r'''VScrollArea.horizontal(
  child: Row(
    children: List.generate(20, (i) => Container(
      width: 100,
      height: 80,
      margin: EdgeInsets.all(8),
      color: Colors.blue,
      child: Center(child: Text('Card $i')),
    )),
  ),
)''',
        preview: _HorizontalDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Always Visible',
        code: r'''VScrollArea(
  thumbVisibility: true,
  trackVisibility: true,
  child: ListView.builder(
    itemCount: 50,
    itemBuilder: (context, i) => VListTile(title: Text('Item $i')),
  ),
)''',
        preview: _WithTrackDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Custom Style',
        code: '''VScrollArea(
  scrollbarThickness: 8,
  scrollbarRadius: 4,
  thumbColor: theme.colors.primary,
  child: Content(),
)''',
      ),
      WidgetbookCodeBlock(
        title: 'With Controller',
        code: r'''final controller = ScrollController();

VScrollArea(
  controller: controller,
  child: ListView.builder(
    controller: controller,
    itemCount: 100,
    itemBuilder: (context, i) => VListTile(title: Text('Item $i')),
  ),
)''',
      ),
      WidgetbookCodeBlock(
        title: 'Both directions',
        code: '''VScrollArea.both(
  child: SizedBox(
    width: 800,
    height: 600,
    child: VTable(
      columns: [...],
      rows: [...],
    ),
  ),
)''',
        preview: _BothDemo(),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _VerticalDemo extends StatelessWidget {
  const _VerticalDemo();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 250,
    height: 150,
    child: VScrollArea(
      child: Column(
        children: List.generate(15, (i) => _ScrollItem(label: 'Item $i')),
      ),
    ),
  );
}

class _HorizontalDemo extends StatelessWidget {
  const _HorizontalDemo();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 300,
    height: 100,
    child: VScrollArea.horizontal(
      child: Row(
        children: List.generate(
          15,
          (i) => _ScrollItem(label: 'Card $i', width: 80),
        ),
      ),
    ),
  );
}

class _BothDemo extends StatelessWidget {
  const _BothDemo();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return SizedBox(
      width: 250,
      height: 150,
      child: VScrollArea.both(
        child: SizedBox(
          width: 500,
          height: 400,
          child: Container(
            color: theme.colors.muted,
            child: Center(
              child: Text(
                '500 x 400',
                style: theme.typography.headlineMedium.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AlwaysVisibleDemo extends StatelessWidget {
  const _AlwaysVisibleDemo();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 250,
    height: 150,
    child: VScrollArea(
      thumbVisibility: true,
      child: Column(
        children: List.generate(15, (i) => _ScrollItem(label: 'Item $i')),
      ),
    ),
  );
}

class _WithTrackDemo extends StatelessWidget {
  const _WithTrackDemo();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 250,
    height: 150,
    child: VScrollArea(
      thumbVisibility: true,
      trackVisibility: true,
      child: Column(
        children: List.generate(15, (i) => _ScrollItem(label: 'Item $i')),
      ),
    ),
  );
}

class _ScrollItem extends StatelessWidget {
  const _ScrollItem({required this.label, this.width});

  final String label;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Container(
      width: width,
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colors.card,
        borderRadius: BorderRadius.circular(theme.radius.sm),
        border: Border.all(color: theme.colors.border),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: theme.typography.bodySmall.copyWith(
          color: theme.colors.foreground,
        ),
      ),
    );
  }
}
