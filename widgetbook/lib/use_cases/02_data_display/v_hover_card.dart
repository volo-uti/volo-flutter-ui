import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vHoverCardComponent() => WidgetbookComponent(
  name: 'VHoverCard',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _hoverCardPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _HoverCardShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _HoverCardSample(),
    ),
  ],
);

Widget _hoverCardPlayground(BuildContext context) {
  final k = context.knobs;
  final position = k.object.dropdown<VHoverCardPosition>(
    label: 'position',
    options: VHoverCardPosition.values,
    initialOption: VHoverCardPosition.bottom,
    labelBuilder: (v) => v.name,
  );
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final openMs = k.int.slider(
    label: 'openDelay (ms)',
    initialValue: 700,
    max: 3000,
  );
  final closeMs = k.int.slider(
    label: 'closeDelay (ms)',
    initialValue: 300,
    max: 3000,
  );
  final offsetY = k.double.slider(label: 'offset.dy', initialValue: 8, max: 40);

  return WidgetbookPlayground(
    child: VHoverCard(
      position: position,
      enabled: enabled,
      openDelay: Duration(milliseconds: openMs),
      closeDelay: Duration(milliseconds: closeMs),
      offset: Offset(0, offsetY),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('John Doe'), Text('@johndoe')],
      ),
      child: const VBadge(label: Text('Hover me')),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _HoverCardShowcase extends StatelessWidget {
  const _HoverCardShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return WidgetbookPageLayout(
      title: 'VHoverCard',
      description: 'Displays rich content on hover for previewing information.',
      children: [
        WidgetbookSection(
          title: 'Positions (Basic)',
          children: [
            WidgetbookSubsection(
              title: 'top',
              labels: const ['VHoverCardPosition.top'],
              children: [
                VHoverCard(
                  position: VHoverCardPosition.top,
                  content: _buildUserCard(theme),
                  child: const VBadge(label: Text('Top')),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'bottom',
              labels: const ['VHoverCardPosition.bottom'],
              children: [
                VHoverCard(
                  content: _buildUserCard(theme),
                  child: const VBadge(label: Text('Bottom')),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'left',
              labels: const ['VHoverCardPosition.left'],
              children: [
                VHoverCard(
                  position: VHoverCardPosition.left,
                  content: _buildUserCard(theme),
                  child: const VBadge(label: Text('Left')),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'right',
              labels: const ['VHoverCardPosition.right'],
              children: [
                VHoverCard(
                  position: VHoverCardPosition.right,
                  content: _buildUserCard(theme),
                  child: const VBadge(label: Text('Right')),
                ),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Usage',
          children: [
            WidgetbookSubsection(
              title: 'user mention',
              labels: const ['@username'],
              children: [
                VHoverCard(
                  content: _buildUserCard(theme),
                  child: Text(
                    '@johndoe',
                    style: theme.typography.bodyMedium.copyWith(
                      color: theme.colors.primary,
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'info icon',
              labels: const ['Icon()'],
              children: [
                VHoverCard(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Information',
                        style: theme.typography.titleSmall.copyWith(
                          color: theme.colors.popoverForeground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'This is additional information about the feature.',
                        style: theme.typography.bodySmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  child: const Icon(
                    IconData(0xe88e, fontFamily: 'MaterialIcons'),
                    size: 20,
                  ),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'with link',
              labels: const ['Text link'],
              children: [
                VHoverCard(
                  openDelay: const Duration(milliseconds: 500),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preview: volo-flutter-ui',
                        style: theme.typography.titleSmall.copyWith(
                          color: theme.colors.popoverForeground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'A Flutter UI component library with token-driven components.',
                        style: theme.typography.bodySmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'github.com/example/volo-flutter-ui',
                        style: theme.typography.labelSmall.copyWith(
                          color: theme.colors.primary,
                        ),
                      ),
                    ],
                  ),
                  child: Text(
                    'volo-flutter-ui',
                    style: theme.typography.bodyMedium.copyWith(
                      color: theme.colors.primary,
                      decoration: TextDecoration.underline,
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

  Widget _buildUserCard(VThemeData theme) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colors.muted,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'JD',
                style: theme.typography.labelMedium.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'John Doe',
                style: theme.typography.titleSmall.copyWith(
                  color: theme.colors.popoverForeground,
                ),
              ),
              Text(
                '@johndoe',
                style: theme.typography.bodySmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 12),
      Text(
        'Senior Flutter Developer. Open source enthusiast.',
        style: theme.typography.bodySmall.copyWith(
          color: theme.colors.popoverForeground,
        ),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '128 Following',
            style: theme.typography.labelSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '1.2K Followers',
            style: theme.typography.labelSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
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
              'Preview additional information about a link, user, or resource without navigating away.',
            ),
            _guidelineRow(
              theme,
              'When not to use',
              'For brief label text. Use VTooltip instead. For interactive content, use VPopover.',
            ),
            _guidelineRow(
              theme,
              'Accessibility',
              'Hover cards are not accessible on touch devices. Provide alternative navigation for critical content.',
            ),
            _guidelineRow(
              theme,
              'Timing',
              'Adjust hover delay based on content complexity',
            ),
            _guidelineRow(
              theme,
              'Mobile',
              'Consider tap-based alternatives for touch devices',
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

class _HoverCardSample extends StatelessWidget {
  const _HoverCardSample();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return WidgetbookPageLayout(
      title: 'VHoverCard Samples',
      description: 'Copy-ready code examples.',
      children: [
        WidgetbookCodeBlock(
          title: 'Basic Usage',
          code: '''VHoverCard(
  content: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('John Doe', style: theme.typography.titleSmall),
      Text('@johndoe', style: theme.typography.bodySmall),
    ],
  ),
  child: Text('@johndoe'),
)''',
          preview: VHoverCard(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: theme.typography.titleSmall.copyWith(
                    color: theme.colors.popoverForeground,
                  ),
                ),
                Text(
                  '@johndoe',
                  style: theme.typography.bodySmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
            child: Text(
              '@johndoe',
              style: theme.typography.bodyMedium.copyWith(
                color: theme.colors.primary,
              ),
            ),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Position',
          code: '''VHoverCard(
  position: VHoverCardPosition.right,
  offset: Offset(12, 0),
  content: Text('Info'),
  child: Icon(Icons.info),
)''',
          preview: VHoverCard(
            position: VHoverCardPosition.right,
            offset: const Offset(12, 0),
            content: Text(
              'Additional information',
              style: theme.typography.bodySmall.copyWith(
                color: theme.colors.popoverForeground,
              ),
            ),
            child: const Icon(
              IconData(0xe88e, fontFamily: 'MaterialIcons'),
              size: 20,
            ),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Delay Settings',
          code: '''VHoverCard(
  openDelay: Duration(milliseconds: 500),
  closeDelay: Duration(milliseconds: 200),
  content: Text('Quick preview'),
  child: Text('Hover me'),
)''',
          preview: VHoverCard(
            openDelay: const Duration(milliseconds: 500),
            closeDelay: const Duration(milliseconds: 200),
            content: Text(
              'Quick preview content',
              style: theme.typography.bodySmall.copyWith(
                color: theme.colors.popoverForeground,
              ),
            ),
            child: const Text('Hover me'),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'User profile preview',
          code: '''VHoverCard(
  content: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      VAvatar.text('JD', size: VAvatarSize.lg),
      SizedBox(width: 12),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Jane Doe'),
          Text('@janedoe'),
          SizedBox(height: 4),
          Text('Flutter Developer'),
        ],
      ),
    ],
  ),
  child: Text('@janedoe'),
)''',
          preview: VHoverCard(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const VAvatar.text('JD', size: VAvatarSize.lg),
                const SizedBox(width: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jane Doe',
                      style: theme.typography.titleSmall.copyWith(
                        color: theme.colors.popoverForeground,
                      ),
                    ),
                    Text(
                      '@janedoe',
                      style: theme.typography.bodySmall.copyWith(
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Flutter Developer',
                      style: theme.typography.bodySmall.copyWith(
                        color: theme.colors.popoverForeground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            child: Text(
              '@janedoe',
              style: theme.typography.bodyMedium.copyWith(
                color: theme.colors.primary,
              ),
            ),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Link preview',
          code: '''VHoverCard(
  openDelay: Duration(milliseconds: 500),
  content: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Flutter Documentation'),
      SizedBox(height: 4),
      Text('Build apps for any screen with Flutter.'),
      SizedBox(height: 8),
      Text('flutter.dev'),
    ],
  ),
  child: Text('flutter.dev', style: TextStyle(decoration: TextDecoration.underline)),
)''',
          preview: VHoverCard(
            openDelay: const Duration(milliseconds: 500),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flutter Documentation',
                  style: theme.typography.titleSmall.copyWith(
                    color: theme.colors.popoverForeground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Build apps for any screen with Flutter.',
                  style: theme.typography.bodySmall.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'flutter.dev',
                  style: theme.typography.labelSmall.copyWith(
                    color: theme.colors.primary,
                  ),
                ),
              ],
            ),
            child: Text(
              'flutter.dev',
              style: theme.typography.bodyMedium.copyWith(
                color: theme.colors.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'User profile preview',
          code: '''VHoverCard(
  content: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      VAvatar.text('JD', size: VAvatarSize.md),
      SizedBox(width: 12),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('John Doe'),
          Text('john@example.com'),
        ],
      ),
    ],
  ),
  child: Text('@johndoe'),
)''',
          preview: VHoverCard(
            content: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                VAvatar.text('JD'),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [Text('John Doe'), Text('john@example.com')],
                ),
              ],
            ),
            child: Text(
              '@johndoe',
              style: theme.typography.bodyMedium.copyWith(
                color: theme.colors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
