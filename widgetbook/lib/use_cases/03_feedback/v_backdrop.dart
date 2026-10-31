import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vBackdropComponent() => WidgetbookComponent(
  name: 'VBackdrop',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _backdropPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _BackdropShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _BackdropSample(),
    ),
  ],
);

Widget _backdropPlayground(BuildContext context) {
  final k = context.knobs;
  final color = k.colorOrNull(label: 'color');
  final opacity = k.double.slider(
    label: 'opacity',
    initialValue: 0.5,
    max: 1,
    divisions: 20,
  );
  final tappable = k.boolean(label: 'onTap', initialValue: true);

  var visible = true;
  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      info: [if (visible) 'backdrop shown' else 'backdrop closed'],
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            Center(
              child: VButton(
                onPressed: () => setState(() => visible = true),
                child: const Text('Show backdrop'),
              ),
            ),
            if (visible)
              Positioned.fill(
                child: VBackdrop(
                  color: color,
                  opacity: opacity,
                  onTap: tappable
                      ? () => setState(() => visible = false)
                      : null,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _BackdropPreview extends StatefulWidget {
  const _BackdropPreview({this.opacity = 0.5});

  final double opacity;

  @override
  State<_BackdropPreview> createState() => _BackdropPreviewState();
}

class _BackdropPreviewState extends State<_BackdropPreview> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 200,
    child: Stack(
      children: [
        Center(
          child: VButton(
            onPressed: () => setState(() => _visible = true),
            child: const Text('Show Backdrop'),
          ),
        ),
        if (_visible)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _visible = false),
              child: VBackdrop(opacity: widget.opacity),
            ),
          ),
      ],
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _BackdropShowcase extends StatelessWidget {
  const _BackdropShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VBackdrop',
    description:
        'A full-screen overlay displayed behind modals, drawers, or side panels.',
    children: [
      const WidgetbookSection(
        title: 'Basic Behavior',
        children: [
          WidgetbookSubsection(
            title: 'open/close',
            labels: ['VBackdrop open: boolean'],
            children: [SizedBox(height: 200, child: _BackdropPreview())],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'closed',
            labels: const ['VBackdrop open={false}'],
            children: [
              Container(
                width: 200,
                height: 130,
                decoration: BoxDecoration(
                  border: Border.all(color: VTheme.of(context).colors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Backdrop: closed',
                    style: VTheme.of(context).typography.bodySmall.copyWith(
                      color: VTheme.of(context).colors.mutedForeground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'open',
            labels: const ['VBackdrop open={true}'],
            children: [
              Container(
                width: 200,
                height: 130,
                decoration: BoxDecoration(
                  border: Border.all(color: VTheme.of(context).colors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Backdrop: open',
                        style: VTheme.of(context).typography.bodySmall.copyWith(
                          color: VTheme.of(context).colors.mutedForeground,
                        ),
                      ),
                    ),
                    const Positioned.fill(child: VBackdrop()),
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
          'Behind modals, drawers, or any overlay component that requires focus from the user.',
        ),
        _guidelineRow(
          theme,
          'When not to use',
          'As a standalone component without an associated overlay content.',
        ),
        _guidelineRow(
          theme,
          'Interaction',
          'Provide an onTap handler to allow dismissal by tapping the backdrop area.',
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

class _BackdropSample extends StatelessWidget {
  const _BackdropSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VBackdrop Samples',
    description: 'Copy-paste code examples for VBackdrop.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Basic backdrop',
        code: '''Stack(
  children: [
    // Page content
    VBackdrop(onTap: () => close()),
  ],
)''',
        preview: SizedBox(height: 150, child: _BackdropPreview()),
      ),
      const WidgetbookCodeBlock(
        title: 'Backdrop behind modal',
        code: '''Stack(
  children: [
    // Page content
    VBackdrop(onTap: () => close()),
    Center(child: Text('Modal content')),
  ],
)''',
        preview: SizedBox(height: 150, child: _BackdropPreview()),
      ),
      const WidgetbookCodeBlock(
        title: 'Custom style',
        code: '''VBackdrop(
  opacity: 0.7,
  onPressed: () => close(),
)''',
        preview: SizedBox(height: 150, child: _BackdropPreview(opacity: 0.7)),
      ),
      const WidgetbookCodeBlock(
        title: 'Loading overlay',
        code: '''Stack(
  children: [
    // Page content
    Positioned.fill(child: VBackdrop(opacity: 0.6)),
    Center(
      child: VLoadingSpinner(
        color: Colors.white,
        size: 48,
      ),
    ),
  ],
)''',
        preview: _LoadingOverlayPreview(),
      ),
      const WidgetbookCodeBlock(
        title: 'Click to dismiss',
        code: '''Stack(
  children: [
    // Page content behind
    Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => showOverlay = false),
        child: VBackdrop(),
      ),
    ),
    Center(child: Text('Tap backdrop to close')),
  ],
)''',
        preview: SizedBox(height: 150, child: _BackdropPreview()),
      ),
      WidgetbookCodeBlock(
        title: 'Loading overlay',
        code: '''Stack(
  children: [
    Positioned.fill(child: VBackdrop(opacity: 0.5)),
    Center(
      child: VLoadingSpinner(size: 48),
    ),
  ],
)''',
        preview: Builder(
          builder: (context) {
            final theme = VTheme.of(context);
            return SizedBox(
              height: 150,
              child: Stack(
                children: [
                  const Center(child: Text('Content behind backdrop')),
                  const Positioned.fill(child: VBackdrop()),
                  Center(
                    child: VLoadingSpinner(
                      color: theme.colors.primary,
                      size: 48,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}

class _LoadingOverlayPreview extends StatefulWidget {
  const _LoadingOverlayPreview();

  @override
  State<_LoadingOverlayPreview> createState() => _LoadingOverlayPreviewState();
}

class _LoadingOverlayPreviewState extends State<_LoadingOverlayPreview> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          Center(
            child: VButton(
              onPressed: () => setState(() => _visible = true),
              child: const Text('Show Loading'),
            ),
          ),
          if (_visible) ...[
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _visible = false),
                child: const VBackdrop(opacity: 0.6),
              ),
            ),
            Center(
              child: VLoadingSpinner(
                color: theme.colors.primaryForeground,
                size: 48,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
