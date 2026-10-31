import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vAvatarComponent() => WidgetbookComponent(
  name: 'VAvatar',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _avatarPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _AvatarShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _AvatarSample(),
    ),
  ],
);

Widget _avatarPlayground(BuildContext context) {
  final k = context.knobs;
  final shape = k.object.dropdown<VAvatarShape>(
    label: 'shape',
    options: VAvatarShape.values,
    initialOption: VAvatarShape.circle,
    labelBuilder: (v) => v.name,
  );
  final size = k.object.dropdown<VAvatarSize>(
    label: 'size',
    options: VAvatarSize.values,
    initialOption: VAvatarSize.md,
    labelBuilder: (v) => v.name,
  );
  final backgroundColor = k.colorOrNull(label: 'backgroundColor');
  final foregroundColor = k.colorOrNull(label: 'foregroundColor');
  final text = k.string(label: 'text', initialValue: 'KM');
  final tappable = k.boolean(label: 'onTap');
  final semanticLabel = k.string(label: 'semanticLabel');

  return WidgetbookPlayground(
    child: VAvatar.text(
      text,
      size: size,
      shape: shape,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      onTap: tappable ? () {} : null,
      semanticLabel: semanticLabel.isEmpty ? null : semanticLabel,
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _AvatarShowcase extends StatelessWidget {
  const _AvatarShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VAvatar',
    description: 'Displays user profile images or initials as an avatar.',
    children: [
      const WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'xs',
            labels: ['VAvatar size="xs"'],
            children: [VAvatar.text('XS', size: VAvatarSize.xs)],
          ),
          WidgetbookSubsection(
            title: 'sm',
            labels: ['VAvatar size="sm"'],
            children: [VAvatar.text('SM', size: VAvatarSize.sm)],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: ['VAvatar size="md"'],
            children: [VAvatar.text('MD')],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: ['VAvatar size="lg"'],
            children: [VAvatar.text('LG', size: VAvatarSize.lg)],
          ),
          WidgetbookSubsection(
            title: 'xl',
            labels: ['VAvatar size="xl"'],
            children: [VAvatar.text('XL', size: VAvatarSize.xl)],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Shapes',
        children: [
          WidgetbookSubsection(
            title: 'circle',
            labels: ['VAvatar shape="circle"'],
            children: [
              VAvatar.text('AB'),
              VAvatar.text('CD', size: VAvatarSize.lg),
            ],
          ),
          WidgetbookSubsection(
            title: 'rounded',
            labels: ['VAvatar shape="rounded"'],
            children: [
              VAvatar.text('AB', shape: VAvatarShape.rounded),
              VAvatar.text(
                'CD',
                shape: VAvatarShape.rounded,
                size: VAvatarSize.lg,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'square',
            labels: ['VAvatar shape="square"'],
            children: [
              VAvatar.text('AB', shape: VAvatarShape.square),
              VAvatar.text(
                'CD',
                shape: VAvatarShape.square,
                size: VAvatarSize.lg,
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Content Types',
        children: [
          WidgetbookSubsection(
            title: 'image',
            labels: ['VAvatar src="..."'],
            children: [
              VAvatar.image(
                imageProvider: NetworkImage('https://i.pravatar.cc/80?img=1'),
              ),
              VAvatar.image(
                imageProvider: NetworkImage('https://i.pravatar.cc/80?img=2'),
                size: VAvatarSize.lg,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'initials fallback',
            labels: ['VAvatar fallback="JD"'],
            children: [
              VAvatar.text('JD'),
              VAvatar.text('KM', size: VAvatarSize.lg),
            ],
          ),
          WidgetbookSubsection(
            title: 'icon fallback',
            labels: ['VAvatar fallback={<Icon />}'],
            children: [
              VAvatar.icon(IconData(0xe7fd, fontFamily: 'MaterialIcons')),
              VAvatar.icon(
                IconData(0xe838, fontFamily: 'MaterialIcons'),
                size: VAvatarSize.lg,
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Size + Shape Combinations',
        children: [
          WidgetbookSubsection(
            title: 'all combinations',
            labels: ['size x shape'],
            children: [
              VAvatar.text('SC', size: VAvatarSize.sm),
              VAvatar.text('MC'),
              VAvatar.text('LC', size: VAvatarSize.lg),
              VAvatar.text(
                'SR',
                size: VAvatarSize.sm,
                shape: VAvatarShape.rounded,
              ),
              VAvatar.text('MR', shape: VAvatarShape.rounded),
              VAvatar.text(
                'LR',
                size: VAvatarSize.lg,
                shape: VAvatarShape.rounded,
              ),
              VAvatar.text(
                'SS',
                size: VAvatarSize.sm,
                shape: VAvatarShape.square,
              ),
              VAvatar.text('MS', shape: VAvatarShape.square),
              VAvatar.text(
                'LS',
                size: VAvatarSize.lg,
                shape: VAvatarShape.square,
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
          'Display user profile images, initials, or placeholder icons in lists, cards, or headers.',
        ),
        _guidelineRow(
          theme,
          'When not to use',
          'For decorative images or logos unrelated to a user identity. Use a standard Image instead.',
        ),
        _guidelineRow(
          theme,
          'Accessibility',
          'Always provide an alt prop when using src. Fallback initials are announced by screen readers.',
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

class _AvatarSample extends StatelessWidget {
  const _AvatarSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VAvatar Samples',
    description: 'Copy-paste code examples for VAvatar.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic image avatar',
        code: '''VAvatar.image(
  imageProvider: NetworkImage('https://...'),
)''',
        preview: Row(
          children: [
            VAvatar.image(
              imageProvider: NetworkImage('https://i.pravatar.cc/80?img=3'),
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Initials fallback',
        code: '''VAvatar.text('JD', size: VAvatarSize.lg)''',
        preview: Row(children: [VAvatar.text('JD', size: VAvatarSize.lg)]),
      ),
      WidgetbookCodeBlock(
        title: 'Square avatar',
        code: '''VAvatar.text('AB', shape: VAvatarShape.square)''',
        preview: Row(
          children: [VAvatar.text('AB', shape: VAvatarShape.square)],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Avatar group',
        code: '''VAvatarGroup(
  max: 3,
  children: [
    VAvatar.text('A'),
    VAvatar.text('B'),
    VAvatar.text('C'),
    VAvatar.text('D'),
  ],
)''',
        preview: Row(
          children: [
            VAvatarGroup(
              max: 3,
              children: [
                VAvatar.text('A'),
                VAvatar.text('B'),
                VAvatar.text('C'),
                VAvatar.text('D'),
              ],
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Sizes list',
        code: '''VAvatar.text('S', size: VAvatarSize.sm)
VAvatar.text('M', size: VAvatarSize.md)
VAvatar.text('L', size: VAvatarSize.lg)''',
        preview: Row(
          children: [
            VAvatar.text('S', size: VAvatarSize.sm),
            SizedBox(width: 12),
            VAvatar.text('M'),
            SizedBox(width: 12),
            VAvatar.text('L', size: VAvatarSize.lg),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Profile header',
        code: '''Row(
  children: [
    VAvatar.image(
      imageProvider: NetworkImage('https://...'),
      size: VAvatarSize.lg,
    ),
    SizedBox(width: 12),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Senior Developer', style: TextStyle(color: Colors.grey)),
      ],
    ),
  ],
)''',
        preview: Row(
          children: [
            VAvatar.image(
              imageProvider: NetworkImage('https://i.pravatar.cc/80?img=5'),
              size: VAvatarSize.lg,
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text('Senior Developer', style: TextStyle(fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Avatar stack',
        code: '''VAvatarGroup(
  max: 3,
  children: [
    VAvatar.text('A', size: VAvatarSize.sm),
    VAvatar.text('B', size: VAvatarSize.sm),
    VAvatar.text('C', size: VAvatarSize.sm),
    VAvatar.text('D', size: VAvatarSize.sm),
    VAvatar.text('E', size: VAvatarSize.sm),
  ],
)''',
        preview: VAvatarGroup(
          max: 3,
          children: [
            VAvatar.text('A', size: VAvatarSize.sm),
            VAvatar.text('B', size: VAvatarSize.sm),
            VAvatar.text('C', size: VAvatarSize.sm),
            VAvatar.text('D', size: VAvatarSize.sm),
            VAvatar.text('E', size: VAvatarSize.sm),
          ],
        ),
      ),
    ],
  );
}
