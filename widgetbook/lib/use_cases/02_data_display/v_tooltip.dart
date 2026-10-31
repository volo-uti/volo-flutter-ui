import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vTooltipComponent() => WidgetbookComponent(
  name: 'VTooltip',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _tooltipPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _TooltipShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _TooltipSample(),
    ),
  ],
);

Widget _tooltipPlayground(BuildContext context) {
  final k = context.knobs;
  final message = k.string(label: 'message', initialValue: 'Tooltip text');
  final rich = k.boolean(label: 'richMessage');
  final position = k.object.dropdown<VTooltipPosition>(
    label: 'position',
    options: VTooltipPosition.values,
    initialOption: VTooltipPosition.top,
    labelBuilder: (v) => v.name,
  );
  final waitMs = k.int.slider(
    label: 'waitDuration (ms)',
    initialValue: 500,
    max: 3000,
  );
  final showMs = k.int.slider(
    label: 'showDuration (ms)',
    initialValue: 1500,
    max: 5000,
  );
  final maxWidth = k.double.slider(
    label: 'maxWidth',
    initialValue: 280,
    min: 80,
    max: 400,
  );

  return WidgetbookPlayground(
    child: VTooltip(
      message: rich ? null : message,
      richMessage: rich
          ? Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                const Icon(
                  IconData(0xe88e, fontFamily: 'MaterialIcons'),
                  size: 14,
                ),
                Text(message),
              ],
            )
          : null,
      position: position,
      waitDuration: Duration(milliseconds: waitMs),
      showDuration: Duration(milliseconds: showMs),
      maxWidth: maxWidth,
      child: VButton(onPressed: () {}, child: const Text('Hover me')),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _TooltipShowcase extends StatelessWidget {
  const _TooltipShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VTooltip',
    description:
        'Displays informational text on hover or focus relative to its trigger element.',
    children: [
      const WidgetbookSection(
        title: 'Placement',
        children: [
          WidgetbookSubsection(
            title: 'top',
            labels: ['VTooltip placement="top"'],
            children: [
              VTooltip(
                message: 'Top tooltip',
                child: VBadge(label: Text('Top')),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'bottom',
            labels: ['VTooltip placement="bottom"'],
            children: [
              VTooltip(
                message: 'Bottom tooltip',
                position: VTooltipPosition.bottom,
                child: VBadge(label: Text('Bottom')),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'left',
            labels: ['VTooltip placement="left"'],
            children: [
              VTooltip(
                message: 'Left tooltip',
                position: VTooltipPosition.left,
                child: VBadge(label: Text('Left')),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'right',
            labels: ['VTooltip placement="right"'],
            children: [
              VTooltip(
                message: 'Right tooltip',
                position: VTooltipPosition.right,
                child: VBadge(label: Text('Right')),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Delay',
        children: [
          WidgetbookSubsection(
            title: 'instant (0ms)',
            labels: ['VTooltip delay={0}'],
            children: [
              VTooltip(
                message: 'Shows instantly',
                waitDuration: Duration.zero,
                child: VBadge(label: Text('No Delay')),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'default (200ms)',
            labels: ['VTooltip delay={200}'],
            children: [
              VTooltip(
                message: 'Shows after 200ms',
                waitDuration: Duration(milliseconds: 200),
                child: VBadge(label: Text('Default Delay')),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'slow (500ms)',
            labels: ['VTooltip delay={500}'],
            children: [
              VTooltip(
                message: 'Shows after 500ms',
                child: VBadge(label: Text('Slow Delay')),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Content Types',
        children: [
          WidgetbookSubsection(
            title: 'short text',
            labels: ['VTooltip content="Save"'],
            children: [
              VTooltip(
                message: 'Save',
                child: VBadge(label: Text('Hover me')),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'long text',
            labels: ['VTooltip content="..."'],
            children: [
              VTooltip(
                message:
                    'Clicking this button will save all your current changes to the server.',
                child: VBadge(label: Text('Hover me')),
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
          'Provide brief supplementary information for icon-only buttons, truncated labels, or controls needing extra context.',
        ),
        _guidelineRow(
          theme,
          'When not to use',
          'For critical information that must be visible at all times. Use inline text or VAlert instead.',
        ),
        _guidelineRow(
          theme,
          'Accessibility',
          'Tooltips should supplement, not replace, visible labels. Always provide aria-label on icon-only triggers.',
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

class _TooltipSample extends StatelessWidget {
  const _TooltipSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VTooltip Samples',
    description: 'Copy-paste code examples for VTooltip.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic tooltip',
        code: '''VTooltip(
  message: 'Save',
  child: VButton(onPressed: () {}, child: Text('Save')),
)''',
        preview: VTooltip(
          message: 'Save',
          child: VButton(onPressed: () {}, child: const Text('Save')),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Placement bottom',
        code: '''VTooltip(
  message: 'Shows below',
  position: VTooltipPosition.bottom,
  child: VButton(onPressed: () {}, child: Text('Bottom tooltip')),
)''',
        preview: VTooltip(
          message: 'Shows below',
          position: VTooltipPosition.bottom,
          child: VButton(onPressed: () {}, child: const Text('Bottom tooltip')),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Icon button with tooltip',
        code: '''VTooltip(
  message: 'Delete',
  child: VIconButton(
    icon: Icon(Icons.delete),
    onPressed: () {},
  ),
)''',
        preview: VTooltip(
          message: 'Delete',
          child: VIconButton(
            icon: const Icon(IconData(0xe872, fontFamily: 'MaterialIcons')),
            onPressed: () {},
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'No delay tooltip',
        code: '''VTooltip(
  message: 'Instant tooltip',
  waitDuration: Duration.zero,
  child: VButton(onPressed: () {}, child: Text('Instant')),
)''',
        preview: VTooltip(
          message: 'Instant tooltip',
          waitDuration: Duration.zero,
          child: VButton(onPressed: () {}, child: const Text('Instant')),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Toolbar icon group',
        code: '''Row(
  children: [
    VTooltip(message: 'Bold', child: VIconButton(icon: Text('B'), onPressed: () {})),
    VTooltip(message: 'Italic', child: VIconButton(icon: Text('I'), onPressed: () {})),
    VTooltip(message: 'Underline', child: VIconButton(icon: Text('U'), onPressed: () {})),
  ],
)''',
        preview: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VTooltip(
              message: 'Bold',
              child: VIconButton(
                icon: const Text(
                  'B',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
              ),
            ),
            VTooltip(
              message: 'Italic',
              child: VIconButton(
                icon: const Text(
                  'I',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                onPressed: () {},
              ),
            ),
            VTooltip(
              message: 'Underline',
              child: VIconButton(
                icon: const Text(
                  'U',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Truncated text tooltip',
        code: '''VTooltip(
  message: 'This is the full text that was truncated due to limited space',
  child: SizedBox(
    width: 120,
    child: Text(
      'This is the full text that was truncated due to limited space',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    ),
  ),
)''',
        preview: VTooltip(
          message:
              'This is the full text that was truncated due to limited space',
          child: SizedBox(
            width: 120,
            child: Text(
              'This is the full text that was truncated due to limited space',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Icon with tooltip',
        code: '''VTooltip(
  message: 'Settings',
  child: Icon(Icons.settings),
)''',
        preview: VTooltip(
          message: 'Settings',
          child: Text('\u2699', style: TextStyle(fontSize: 24)),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Form field tooltip',
        code: '''VTextField(
  name: 'apiKey',
  label: 'API Key',
  tooltip: VTooltip(
    message: 'Find your API key in Settings > Developer > API Keys',
    child: Icon(Icons.help_outline, size: 16),
  ),
  placeholder: 'Enter API key',
)''',
        preview: SizedBox(
          width: 300,
          child: VTextField(
            name: 'apiKey',
            label: 'API Key',
            tooltip: VTooltip(
              message: 'Find your API key in Settings > Developer > API Keys',
              child: Text('?', style: TextStyle(fontSize: 14)),
            ),
            placeholder: 'Enter API key',
          ),
        ),
      ),
    ],
  );
}
