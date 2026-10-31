import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _BoxKind { box, card, outlined, elevated }

WidgetbookComponent vBoxComponent() => WidgetbookComponent(
  name: 'VBox',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _boxPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _BoxShowcase(),
    ),
    WidgetbookUseCase(name: 'Sample', builder: (context) => const _BoxSample()),
  ],
);

Widget _boxPlayground(BuildContext context) {
  final k = context.knobs;
  final kind = k.object.dropdown<_BoxKind>(
    label: 'variant',
    options: _BoxKind.values,
    initialOption: _BoxKind.card,
    labelBuilder: (v) => v.name,
  );
  final color = k.colorOrNull(label: 'color');
  final radius = k.doubleOrNull.slider(label: 'borderRadius', max: 48);
  final padding = k.double.slider(label: 'padding', initialValue: 16, max: 48);
  final width = k.doubleOrNull.slider(label: 'width', max: 400);
  final height = k.doubleOrNull.slider(label: 'height', max: 300);
  final alignment = k.object.dropdown<Alignment>(
    label: 'alignment',
    options: const [
      Alignment.topLeft,
      Alignment.topCenter,
      Alignment.topRight,
      Alignment.centerLeft,
      Alignment.center,
      Alignment.centerRight,
      Alignment.bottomLeft,
      Alignment.bottomCenter,
      Alignment.bottomRight,
    ],
    initialOption: Alignment.center,
    labelBuilder: (v) => v.toString(),
  );
  final clip = k.object.dropdown<Clip>(
    label: 'clipBehavior',
    options: Clip.values,
    initialOption: Clip.antiAlias,
    labelBuilder: (v) => v.name,
  );

  const child = Text('Box content');
  final borderRadius = radius == null ? null : BorderRadius.circular(radius);
  final contentPadding = EdgeInsets.all(padding);

  final box = switch (kind) {
    _BoxKind.box => VBox(
      color: color,
      borderRadius: borderRadius,
      padding: contentPadding,
      width: width,
      height: height,
      alignment: alignment,
      clipBehavior: clip,
      child: child,
    ),
    _BoxKind.card => VBox.card(
      color: color,
      borderRadius: borderRadius,
      padding: contentPadding,
      width: width,
      height: height,
      alignment: alignment,
      clipBehavior: clip,
      child: child,
    ),
    _BoxKind.outlined => VBox.outlined(
      color: color,
      borderRadius: borderRadius,
      padding: contentPadding,
      width: width,
      height: height,
      alignment: alignment,
      clipBehavior: clip,
      child: child,
    ),
    _BoxKind.elevated => VBox.elevated(
      color: color,
      borderRadius: borderRadius,
      padding: contentPadding,
      width: width,
      height: height,
      alignment: alignment,
      clipBehavior: clip,
      child: child,
    ),
  };

  return WidgetbookPlayground(child: box);
}

// =============================================================================
// Showcase
// =============================================================================

class _BoxShowcase extends StatelessWidget {
  const _BoxShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VBox',
    description:
        'A container component for layout composition with configurable dimensions.',
    children: [
      const WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: ['VBox()'],
            children: [
              VBox(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Text('A basic transparent box.'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'card',
            labels: ['VBox.card()'],
            children: [
              VBox.card(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Text('A card-style box.'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'outlined',
            labels: ['VBox.outlined()'],
            children: [
              VBox.outlined(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Text('A bordered box.'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'elevated',
            labels: ['VBox.elevated()'],
            children: [
              VBox.elevated(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Text('A box with shadow.'),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'With Constraints',
        children: [
          WidgetbookSubsection(
            title: 'width, height',
            labels: ['fixed size'],
            children: [
              Center(
                child: VBox.card(
                  width: 200,
                  height: 100,
                  alignment: Alignment.center,
                  child: Text('200 x 100'),
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
              'Use when a container is needed to wrap content',
            ),
            _guidelineRow(
              theme,
              'Variant',
              'Choose from card, outlined, or elevated based on the desired style',
            ),
            _guidelineRow(
              theme,
              'default',
              'When only padding/alignment is needed without background or border',
            ),
            _guidelineRow(
              theme,
              'card',
              'A container with a card-style background',
            ),
            _guidelineRow(theme, 'outlined', 'A container with only a border'),
            _guidelineRow(theme, 'elevated', 'A floating style with shadow'),
            _guidelineRow(
              theme,
              'padding',
              'Set internal spacing with EdgeInsets',
            ),
            _guidelineRow(
              theme,
              'alignment',
              'Set child widget alignment with Alignment',
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

class _BoxSample extends StatelessWidget {
  const _BoxSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VBox Samples',
    description: 'Copy-ready code examples.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Basic Usage',
        code: '''VBox(
  padding: EdgeInsets.all(16),
  child: Text('Content'),
)''',
        preview: VBox(padding: EdgeInsets.all(16), child: Text('Content')),
      ),
      const WidgetbookCodeBlock(
        title: 'Card Style',
        code: '''VBox.card(
  padding: EdgeInsets.all(16),
  child: Text('Card Style'),
)''',
        preview: VBox.card(
          padding: EdgeInsets.all(16),
          child: Text('Card Style'),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Fixed Size',
        code: '''VBox.elevated(
  width: 200,
  height: 100,
  alignment: Alignment.center,
  child: Text('200 x 100'),
)''',
        preview: VBox.elevated(
          width: 200,
          height: 100,
          alignment: Alignment.center,
          child: Text('200 x 100'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Card wrapper',
        code: '''VBox.card(
  padding: EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Card Title', style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      Text('This is the card body content wrapped in a VBox.'),
      SizedBox(height: 12),
      VButton(onPressed: () {}, child: Text('Action')),
    ],
  ),
)''',
        preview: VBox.card(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Card Title',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('This is the card body content wrapped in a VBox.'),
              const SizedBox(height: 12),
              VButton(onPressed: () {}, child: const Text('Action')),
            ],
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Centered content',
        code: '''VBox.outlined(
  width: 300,
  height: 120,
  alignment: Alignment.center,
  child: Text('Centered content'),
)''',
        preview: VBox.outlined(
          width: 300,
          height: 120,
          alignment: Alignment.center,
          child: Text('Centered content'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Card-like container',
        code: '''VBox.elevated(
  width: double.infinity,
  padding: EdgeInsets.all(16),
  borderRadius: BorderRadius.circular(12),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Welcome back!', style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 4),
      Text('You have 3 new notifications.'),
    ],
  ),
)''',
        preview: VBox.elevated(
          width: 300,
          padding: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(12),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome back!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('You have 3 new notifications.'),
            ],
          ),
        ),
      ),
    ],
  );
}
