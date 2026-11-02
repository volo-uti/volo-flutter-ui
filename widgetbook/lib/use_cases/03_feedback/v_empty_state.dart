import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vEmptyStateComponent() => WidgetbookComponent(
  name: 'VEmptyState',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _emptyStatePlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _EmptyStateShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _EmptyStateSample(),
    ),
  ],
);

Widget _emptyStatePlayground(BuildContext context) {
  final k = context.knobs;
  final hasIcon = k.boolean(label: 'icon', initialValue: true);
  final title = k.string(label: 'title', initialValue: 'No entries yet');
  final description = k.string(
    label: 'description',
    initialValue: 'Entries you save appear here.',
  );
  final hasAction = k.boolean(label: 'action', initialValue: true);
  final height = k.double.slider(
    label: 'box height',
    initialValue: 360,
    min: 160,
    max: 560,
    divisions: 20,
  );

  var presses = 0;
  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      layout: PlaygroundLayout.stretch,
      info: ['action presses: $presses'],
      child: SizedBox(
        height: height,
        child: VEmptyState(
          icon: hasIcon ? VIcons.list(size: 48) : null,
          title: title,
          description: description.isEmpty ? null : description,
          action: hasAction
              ? VButton(
                  onPressed: () => setState(() => presses++),
                  child: const Text('Add entry'),
                )
              : null,
        ),
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _EmptyStateShowcase extends StatelessWidget {
  const _EmptyStateShowcase();

  @override
  Widget build(BuildContext context) {
    final colors = VTheme.of(context).colors;
    return WidgetbookPageLayout(
      title: 'VEmptyState',
      description:
          'A centered message for a list or screen with nothing to show yet.',
      children: [
        WidgetbookSection(
          title: 'Parts',
          children: [
            const WidgetbookSubsection(
              title: 'title only',
              labels: ['VEmptyState(title)'],
              children: [
                SizedBox(
                  height: 160,
                  child: VEmptyState(title: 'No notifications'),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'icon and description',
              labels: const ['icon', 'description'],
              children: [
                SizedBox(
                  height: 240,
                  child: VEmptyState(
                    icon: VIcons.search(size: 48),
                    title: 'No results',
                    description: 'Try a shorter search or another word.',
                  ),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'with action',
              labels: const ['icon', 'description', 'action'],
              children: [
                SizedBox(
                  height: 300,
                  child: VEmptyState(
                    icon: VIcons.camera(size: 48),
                    title: 'No photos yet',
                    description: 'Photos you take appear here, newest first.',
                    action: VButton(
                      onPressed: () {},
                      child: const Text('Take a photo'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Style',
          children: [
            WidgetbookSubsection(
              title: 'iconColor',
              labels: const ['VEmptyStateStyle(iconColor: colors.primary)'],
              children: [
                SizedBox(
                  height: 240,
                  child: VEmptyState(
                    icon: VIcons.cloud(size: 48),
                    title: 'Nothing synced',
                    description: 'Connect to sync your entries.',
                    style: VEmptyStateStyle(iconColor: colors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// =============================================================================
// Sample
// =============================================================================

class _EmptyStateSample extends StatelessWidget {
  const _EmptyStateSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VEmptyState Samples',
    description: 'Copy-paste code examples for VEmptyState.',
    children: [
      WidgetbookCodeBlock(
        title: 'Empty list with an action',
        code: '''entries.isEmpty
    ? VEmptyState(
        icon: VIcons.list(size: 48),
        title: 'No entries yet',
        description: 'Entries you save appear here.',
        action: VButton(
          onPressed: addEntry,
          child: const Text('Add entry'),
        ),
      )
    : EntryList(entries: entries)''',
        preview: SizedBox(
          height: 300,
          child: VEmptyState(
            icon: VIcons.list(size: 48),
            title: 'No entries yet',
            description: 'Entries you save appear here.',
            action: VButton(onPressed: () {}, child: const Text('Add entry')),
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'No search results',
        code: '''VEmptyState(
  icon: VIcons.search(size: 48),
  title: 'No results',
  description: 'Try a shorter search or another word.',
)''',
        preview: SizedBox(
          height: 240,
          child: VEmptyState(
            icon: VIcons.search(size: 48),
            title: 'No results',
            description: 'Try a shorter search or another word.',
          ),
        ),
      ),
    ],
  );
}
