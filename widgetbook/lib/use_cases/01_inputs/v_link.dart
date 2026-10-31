import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vLinkComponent() => WidgetbookComponent(
  name: 'VLink',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _linkPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _LinkShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _LinkSample(),
    ),
  ],
);

Widget _linkPlayground(BuildContext context) {
  final k = context.knobs;
  final text = k.string(label: 'child', initialValue: 'Click here');
  final underline = k.object.dropdown<VLinkUnderline>(
    label: 'underline',
    options: VLinkUnderline.values,
    initialOption: VLinkUnderline.always,
    labelBuilder: (v) => v.name,
  );
  final color = k.object.dropdown<VLinkColor>(
    label: 'color',
    options: VLinkColor.values,
    labelBuilder: (v) => v.name,
  );
  final semanticLabel = k.string(label: 'semanticLabel');
  final pressable = k.boolean(label: 'onTap', initialValue: true);

  var taps = 0;
  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      info: ['taps: $taps'],
      child: VLink(
        onTap: pressable ? () => setState(() => taps++) : null,
        underline: underline,
        color: color,
        semanticLabel: semanticLabel.isEmpty ? null : semanticLabel,
        child: Text(text),
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _LinkShowcase extends StatelessWidget {
  const _LinkShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VLink',
    description:
        'Styled anchor element with polymorphic support for framework routers like Next.js Link.',
    children: [
      WidgetbookSection(
        title: 'Underline',
        children: [
          WidgetbookSubsection(
            title: 'always',
            labels: const ['underline="always"'],
            children: [
              VLink(child: const Text('Always underlined'), onTap: () {}),
            ],
          ),
          WidgetbookSubsection(
            title: 'hover',
            labels: const ['underline="hover"'],
            children: [
              VLink(
                onTap: () {},
                underline: VLinkUnderline.hover,
                child: const Text('Underline on hover'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'none',
            labels: const ['underline="none"'],
            children: [
              VLink(
                onTap: () {},
                underline: VLinkUnderline.none,
                child: const Text('No underline'),
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Color',
        children: [
          WidgetbookSubsection(
            title: 'primary',
            labels: const ['color="primary"'],
            children: [VLink(child: const Text('Primary link'), onTap: () {})],
          ),
          WidgetbookSubsection(
            title: 'secondary',
            labels: const ['color="secondary"'],
            children: [
              VLink(
                onTap: () {},
                color: VLinkColor.secondary,
                child: const Text('Secondary link'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'inherit',
            labels: const ['color="inherit"'],
            children: [
              VLink(
                onTap: () {},
                color: VLinkColor.inherit,
                child: const Text('Inherit color link'),
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Combinations',
        children: [
          WidgetbookSubsection(
            title: 'secondary + always',
            labels: const ['color="secondary" underline="always"'],
            children: [
              VLink(
                onTap: () {},
                color: VLinkColor.secondary,
                child: const Text('Secondary always-underlined'),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'primary + none',
            labels: const ['color="primary" underline="none"'],
            children: [
              VLink(
                onTap: () {},
                underline: VLinkUnderline.none,
                child: const Text('Primary no-underline'),
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
          'Inline navigation links, external references, or router integration',
        ),
        _guidelineRow(
          theme,
          'Underline',
          'Use "hover" for clean UI, "always" for accessibility emphasis',
        ),
        _guidelineRow(
          theme,
          'Color inherit',
          'Use color="inherit" when link should match parent text color',
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

class _LinkSample extends StatelessWidget {
  const _LinkSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VLink Samples',
    description: 'Copy-paste code examples for VLink.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic link',
        code: "VLink(child: Text('About'), onTap: () {})",
        preview: VLink(child: const Text('About'), onTap: () {}),
      ),
      WidgetbookCodeBlock(
        title: 'Inline links',
        code: '''Row(
  children: [
    Text('See the '),
    VLink(child: Text('documentation'), onTap: () {}),
    Text(' for more info.'),
  ],
)''',
        preview: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('See the '),
            VLink(child: const Text('documentation'), onTap: () {}),
            const Text(' for more info.'),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Color variants',
        code: '''Column(
  children: [
    VLink(child: Text('Primary'), onTap: () {}, color: VLinkColor.primary),
    VLink(child: Text('Secondary'), onTap: () {}, color: VLinkColor.secondary),
    VLink(child: Text('Inherit'), onTap: () {}, color: VLinkColor.inherit),
  ],
)''',
        preview: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VLink(child: const Text('Primary'), onTap: () {}),
            VLink(
              onTap: () {},
              color: VLinkColor.secondary,
              child: const Text('Secondary'),
            ),
            VLink(
              onTap: () {},
              color: VLinkColor.inherit,
              child: const Text('Inherit'),
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'External link with icon',
        code: '''Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    VLink(child: Text('Open in new tab'), onTap: () {}),
    SizedBox(width: 4),
    Text('\u2197'),
  ],
)''',
        preview: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VLink(child: const Text('Open in new tab'), onTap: () {}),
            const SizedBox(width: 4),
            const Text('\u2197'),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Navigation links',
        code: '''Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    VLink(child: Text('Home'), onTap: () {}, underline: VLinkUnderline.hover),
    SizedBox(height: 8),
    VLink(child: Text('Products'), onTap: () {}, underline: VLinkUnderline.hover),
    SizedBox(height: 8),
    VLink(child: Text('About'), onTap: () {}, underline: VLinkUnderline.hover),
    SizedBox(height: 8),
    VLink(child: Text('Contact'), onTap: () {}, underline: VLinkUnderline.hover),
  ],
)''',
        preview: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VLink(
              onTap: () {},
              underline: VLinkUnderline.hover,
              child: const Text('Home'),
            ),
            const SizedBox(height: 8),
            VLink(
              onTap: () {},
              underline: VLinkUnderline.hover,
              child: const Text('Products'),
            ),
            const SizedBox(height: 8),
            VLink(
              onTap: () {},
              underline: VLinkUnderline.hover,
              child: const Text('About'),
            ),
            const SizedBox(height: 8),
            VLink(
              onTap: () {},
              underline: VLinkUnderline.hover,
              child: const Text('Contact'),
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Breadcrumb navigation',
        code: '''Row(
  children: [
    VLink(child: Text('Home'), onTap: () {}),
    Text(' / '),
    VLink(child: Text('Products'), onTap: () {}),
    Text(' / '),
    VLink(child: Text('Details')),
  ],
)''',
        preview: Row(
          children: [
            VLink(child: const Text('Home'), onTap: () {}),
            const Text(' / '),
            VLink(child: const Text('Products'), onTap: () {}),
            const Text(' / '),
            const VLink(child: Text('Details')),
          ],
        ),
      ),
    ],
  );
}
