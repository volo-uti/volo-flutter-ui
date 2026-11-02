import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../components/widgetbook_components.dart';

typedef _IconBuilder = Widget Function({Color? color, double size});

/// Every VIcons icon, grouped as in the source.
const _groups = <String, Map<String, _IconBuilder>>{
  'Navigation': {
    'chevronLeft': VIcons.chevronLeft,
    'chevronRight': VIcons.chevronRight,
    'chevronUp': VIcons.chevronUp,
    'chevronDown': VIcons.chevronDown,
    'arrowBack': VIcons.arrowBack,
    'arrowUp': VIcons.arrowUp,
    'arrowDown': VIcons.arrowDown,
    'firstPage': VIcons.firstPage,
    'lastPage': VIcons.lastPage,
    'arrowDropDown': VIcons.arrowDropDown,
    'openInNew': VIcons.openInNew,
  },
  'Action': {
    'close': VIcons.close,
    'check': VIcons.check,
    'search': VIcons.search,
    'refresh': VIcons.refresh,
    'edit': VIcons.edit,
    'settings': VIcons.settings,
    'location': VIcons.location,
    'playCircle': VIcons.playCircle,
  },
  'Status': {
    'info': VIcons.info,
    'checkCircle': VIcons.checkCircle,
    'error': VIcons.error,
    'warning': VIcons.warning,
    'priorityHigh': VIcons.priorityHigh,
  },
  'Object': {
    'person': VIcons.person,
    'calendar': VIcons.calendar,
    'visibility': VIcons.visibility,
    'visibilityOff': VIcons.visibilityOff,
    'camera': VIcons.camera,
    'list': VIcons.list,
    'cloud': VIcons.cloud,
    'clock': VIcons.clock,
  },
};

final _all = {for (final g in _groups.values) ...g};

/// Icons component (Foundation).
WidgetbookComponent iconComponent() => WidgetbookComponent(
  name: 'Icons',
  useCases: [
    WidgetbookUseCase(
      name: 'overview',
      builder: (context) => const _IconShowcase(),
    ),
    WidgetbookUseCase(name: 'Playground', builder: _iconPlayground),
  ],
);

Widget _iconPlayground(BuildContext context) {
  final k = context.knobs;
  final name = k.object.dropdown<String>(
    label: 'icon',
    options: _all.keys.toList(),
    initialOption: 'settings',
  );
  final size = k.double.slider(
    label: 'size',
    initialValue: 24,
    min: 12,
    max: 96,
    divisions: 21,
  );
  final color = k.colorOrNull(label: 'color');

  return WidgetbookPlayground(
    info: [
      'VIcons.$name',
      'size: ${size.toStringAsFixed(0)}',
      if (color == null) 'color: IconTheme, else foreground',
    ],
    child: _all[name]!(color: color, size: size),
  );
}

class _IconShowcase extends StatelessWidget {
  const _IconShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final sizes = theme.sizes;

    return WidgetbookPageLayout(
      title: 'Icons',
      description:
          'Vector icons drawn in code on a 24-unit grid with a stroke of '
          'size / 12. Without a color they take the IconTheme color, then the '
          'theme foreground.',
      children: [
        for (final group in _groups.entries)
          WidgetbookSection(
            title: group.key,
            children: [
              Wrap(
                spacing: theme.spacing.lg,
                runSpacing: theme.spacing.lg,
                children: [
                  for (final icon in group.value.entries)
                    _IconTile(name: icon.key, builder: icon.value),
                ],
              ),
            ],
          ),
        WidgetbookSection(
          title: 'Sizes',
          description: 'The icon sizes of the size steps xs to xl.',
          children: [
            Wrap(
              spacing: theme.spacing.xl,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                for (final step in [
                  ('xs', sizes.xs),
                  ('sm', sizes.sm),
                  ('md', sizes.md),
                  ('lg', sizes.lg),
                  ('xl', sizes.xl),
                ])
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VIcons.camera(size: step.$2.iconSize),
                      SizedBox(height: theme.spacing.xs),
                      Text(
                        '${step.$1} ${step.$2.iconSize.toStringAsFixed(0)}',
                        style: theme.typography.labelSmall.copyWith(
                          color: theme.colors.mutedForeground,
                          fontFamily: theme.typography.fontFamilyMono,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Color',
          children: [
            WidgetbookSubsection(
              title: 'color',
              labels: const ['VIcons.clock(color: colors.primary)'],
              children: [VIcons.clock(color: theme.colors.primary)],
            ),
            WidgetbookSubsection(
              title: 'IconTheme',
              labels: const ['IconTheme(color: colors.destructive)'],
              children: [
                IconTheme(
                  data: IconThemeData(color: theme.colors.destructive),
                  child: VIcons.clock(),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'theme foreground',
              labels: const ['VIcons.clock()'],
              children: [VIcons.clock()],
            ),
            const WidgetbookSubsection(
              title: 'VBottomNav',
              labels: ['selected and unselected colors via IconTheme'],
              fullWidth: true,
              children: [_BottomNavSample()],
            ),
          ],
        ),
      ],
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.name, required this.builder});

  final String name;
  final _IconBuilder builder;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    return SizedBox(
      width: 112,
      child: Column(
        children: [
          builder(size: 32),
          SizedBox(height: theme.spacing.sm),
          Text(
            name,
            textAlign: TextAlign.center,
            style: theme.typography.labelSmall.copyWith(
              color: theme.colors.mutedForeground,
              fontFamily: theme.typography.fontFamilyMono,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavSample extends StatefulWidget {
  const _BottomNavSample();

  @override
  State<_BottomNavSample> createState() => _BottomNavSampleState();
}

class _BottomNavSampleState extends State<_BottomNavSample> {
  int _index = 0;

  @override
  Widget build(BuildContext context) => VBottomNav(
    selectedIndex: _index,
    onTap: (i) => setState(() => _index = i),
    items: [
      VBottomNavItem(key: 'capture', icon: VIcons.camera(), label: 'Capture'),
      VBottomNavItem(key: 'log', icon: VIcons.list(), label: 'Log'),
      VBottomNavItem(key: 'collect', icon: VIcons.cloud(), label: 'Collect'),
      VBottomNavItem(key: 'forecast', icon: VIcons.clock(), label: 'Forecast'),
    ],
  );
}
