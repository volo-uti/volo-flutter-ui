import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vPopoverComponent() => WidgetbookComponent(
  name: 'VPopover',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _popoverPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _PopoverShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _PopoverSample(),
    ),
  ],
);

Widget _popoverPlayground(BuildContext context) {
  final k = context.knobs;
  final position = k.object.dropdown<VPopoverPosition>(
    label: 'position',
    options: VPopoverPosition.values,
    initialOption: VPopoverPosition.bottom,
    labelBuilder: (v) => v.name,
  );
  final offsetDistance = k.double.slider(
    label: 'offset',
    initialValue: 8,
    max: 32,
  );
  final triggerOnTap = k.boolean(label: 'triggerOnTap', initialValue: true);
  final barrierDismissible = k.boolean(
    label: 'barrierDismissible',
    initialValue: true,
  );
  final barrier = k.boolean(label: 'barrierColor');
  final controller = VPopoverController();

  return WidgetbookPlayground(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VPopover(
          controller: controller,
          position: position,
          offset: Offset(0, offsetDistance),
          triggerOnTap: triggerOnTap,
          barrierDismissible: barrierDismissible,
          barrierColor: barrier ? const Color(0x33000000) : null,
          content: const Text('Popover content'),
          child: const VButton(child: Text('Open Popover')),
        ),
        if (!triggerOnTap) ...[
          const SizedBox(height: 16),
          VButton.outlined(
            onPressed: controller.toggle,
            child: const Text('Toggle via controller'),
          ),
        ],
      ],
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _PopoverShowcase extends StatelessWidget {
  const _PopoverShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VPopover',
    description: 'Floating content panel attached to a trigger element.',
    children: [
      const WidgetbookSection(
        title: 'Placement',
        children: [
          WidgetbookSubsection(
            title: 'directional placement',
            labels: [
              'placement="top"',
              'placement="bottom"',
              'placement="left"',
              'placement="right"',
            ],
            children: [
              VPopover(
                position: VPopoverPosition.top,
                content: Text('placement="top"'),
                child: VButton(child: Text('top')),
              ),
              VPopover(
                content: Text('placement="bottom"'),
                child: VButton(child: Text('bottom')),
              ),
              VPopover(
                position: VPopoverPosition.left,
                content: Text('placement="left"'),
                child: VButton(child: Text('left')),
              ),
              VPopover(
                position: VPopoverPosition.right,
                content: Text('placement="right"'),
                child: VButton(child: Text('right')),
              ),
            ],
          ),
        ],
      ),

      const WidgetbookSection(
        title: 'Align',
        children: [
          WidgetbookSubsection(
            title: 'content alignment',
            labels: ['align="start"', 'align="center"', 'align="end"'],
            children: [
              VPopover(
                position: VPopoverPosition.bottomStart,
                content: Text('align="start"'),
                child: VButton(child: Text('start')),
              ),
              VPopover(
                content: Text('align="center"'),
                child: VButton(child: Text('center')),
              ),
              VPopover(
                position: VPopoverPosition.bottomEnd,
                content: Text('align="end"'),
                child: VButton(child: Text('end')),
              ),
            ],
          ),
        ],
      ),

      const WidgetbookSection(
        title: 'Close Button',
        children: [
          WidgetbookSubsection(
            title: 'with VPopoverClose',
            labels: ['VPopoverClose()'],
            children: [
              VPopover(
                content: VStack.vertical(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      'Notification',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('You have a new update available.'),
                  ],
                ),
                child: VButton(child: Text('Open Popover')),
              ),
            ],
          ),
        ],
      ),

      const WidgetbookSection(
        title: 'Side Offset',
        children: [
          WidgetbookSubsection(
            title: 'custom offset',
            labels: ['sideOffset={16}'],
            children: [
              VPopover(
                offset: Offset(0, 16),
                content: Text('16px gap between trigger and content.'),
                child: VButton(child: Text('Offset 16px')),
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
              'Contextual information, mini forms, or tooltips on click',
            ),
            _guidelineRow(
              theme,
              'Placement',
              'Choose placement based on available screen space',
            ),
            _guidelineRow(
              theme,
              'Close button',
              'Include VPopoverClose for explicit dismiss action',
            ),
            _guidelineRow(
              theme,
              'Side offset',
              'Adjust spacing between trigger and content as needed',
            ),
            _guidelineRow(
              theme,
              'Accessibility',
              'Focus is trapped inside the popover when open',
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

class _PopoverSample extends StatelessWidget {
  const _PopoverSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VPopover Samples',
    description: 'Copy-paste code examples for common popover patterns.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Basic popover',
        code: '''VPopover(
  position: VPopoverPosition.bottom,
  content: Text('Popover content'),
  child: VButton(onPressed: null, child: Text('Open')),
)''',
        preview: VPopover(
          content: Text('Popover content'),
          child: VButton(child: Text('Open')),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'With close button',
        code: '''VPopover(
  position: VPopoverPosition.bottom,
  content: Column(
    children: [
      Text('Notification'),
      Text('You have new messages.'),
      VButton(child: Text('Got it')),
    ],
  ),
  child: VButton(onPressed: null, child: Text('Notifications')),
)''',
        preview: VPopover(
          content: VStack.vertical(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                'Notification',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text('You have new messages.'),
            ],
          ),
          child: VButton(child: Text('Notifications')),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Form popover',
        code: '''VPopover(
  position: VPopoverPosition.bottom,
  content: Column(
    children: [
      Text('Settings'),
      VTextField(name: 'name', placeholder: 'Enter your name'),
      VButton(child: Text('Save')),
    ],
  ),
  child: VButton(onPressed: null, child: Text('Settings')),
)''',
        preview: VPopover(
          content: VStack.vertical(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text('Settings', style: TextStyle(fontWeight: FontWeight.w600)),
              Text('Configure your preferences here.'),
            ],
          ),
          child: VButton(child: Text('Settings')),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Color picker trigger',
        code: '''VPopover(
  position: VPopoverPosition.bottom,
  content: Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      _ColorSwatch(color: Colors.red),
      _ColorSwatch(color: Colors.blue),
      _ColorSwatch(color: Colors.green),
      _ColorSwatch(color: Colors.orange),
      _ColorSwatch(color: Colors.purple),
      _ColorSwatch(color: Colors.teal),
    ],
  ),
  child: VButton.outlined(child: Text('Pick Color')),
)''',
        preview: VPopover(
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ColorSwatch(color: Color(0xFFEF4444)),
              _ColorSwatch(color: Color(0xFF3B82F6)),
              _ColorSwatch(color: Color(0xFF22C55E)),
              _ColorSwatch(color: Color(0xFFF97316)),
              _ColorSwatch(color: Color(0xFF8B5CF6)),
              _ColorSwatch(color: Color(0xFF14B8A6)),
            ],
          ),
          child: VButton.outlined(child: Text('Pick Color')),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Info popover',
        code: '''VPopover(
  position: VPopoverPosition.right,
  content: SizedBox(
    width: 200,
    child: Text('This field is required for account verification. '
        'We will never share your information with third parties.'),
  ),
  child: Icon(Icons.info_outline, size: 20),
)''',
        preview: VPopover(
          position: VPopoverPosition.right,
          content: SizedBox(
            width: 200,
            child: Text(
              'This field is required for account verification. '
              'We will never share your information with third parties.',
            ),
          ),
          child: VButton.outlined(child: Text('Info')),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Action menu popover',
        code: '''VPopover(
  position: VPopoverPosition.bottom,
  content: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      VListTile(title: Text('Edit'), onTap: () {}),
      VListTile(title: Text('Duplicate'), onTap: () {}),
      VDivider(),
      VListTile(title: Text('Delete'), onTap: () {}),
    ],
  ),
  child: VButton.outlined(child: Text('Actions')),
)''',
        preview: VPopover(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VListTile(title: const Text('Edit'), onTap: () {}),
              VListTile(title: const Text('Duplicate'), onTap: () {}),
              const VDivider(),
              VListTile(title: const Text('Delete'), onTap: () {}),
            ],
          ),
          child: const VButton.outlined(child: Text('Actions')),
        ),
      ),
    ],
  );
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 32,
    height: 32,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0x33000000)),
      ),
    ),
  );
}
