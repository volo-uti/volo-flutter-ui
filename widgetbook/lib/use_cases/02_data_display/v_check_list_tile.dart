import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vCheckListTileComponent() => WidgetbookComponent(
  name: 'VCheckListTile',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _checkListTilePlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _CheckListTileShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _CheckListTileSample(),
    ),
  ],
);

Widget _checkListTilePlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_TileVariant>(
    label: 'variant',
    options: _TileVariant.values,
    initialOption: _TileVariant.trailing,
    labelBuilder: (v) => v.name,
  );
  final title = k.string(label: 'title', initialValue: 'Notifications');
  final subtitle = k.string(label: 'subtitle', initialValue: 'Receive updates');
  final secondary = k.boolean(label: 'secondary');
  final selected = k.boolean(label: 'selected');
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final changeable = k.boolean(label: 'onChanged', initialValue: true);
  final tristate = k.boolean(label: 'tristate');
  final value = k.boolean(label: 'value', initialValue: true);

  final titleWidget = Text(title);
  final subtitleWidget = subtitle.isEmpty ? null : Text(subtitle);
  const secondaryIcon = Icon(IconData(0xe7f4, fontFamily: 'MaterialIcons'));

  return WidgetbookPlayground(
    child: SizedBox(
      width: 420,
      child: switch (variant) {
        _TileVariant.trailing => VCheckListTile(
          title: titleWidget,
          subtitle: subtitleWidget,
          secondary: secondary ? secondaryIcon : null,
          value: value,
          selected: selected,
          enabled: enabled,
          tristate: tristate,
          onChanged: changeable ? (_) {} : null,
        ),
        _TileVariant.leading => VCheckListTile.leading(
          title: titleWidget,
          subtitle: subtitleWidget,
          secondary: secondary ? secondaryIcon : null,
          value: value,
          selected: selected,
          enabled: enabled,
          tristate: tristate,
          onChanged: changeable ? (_) {} : null,
        ),
        _TileVariant.card => VCheckListTile.card(
          title: titleWidget,
          subtitle: subtitleWidget,
          secondary: secondary ? secondaryIcon : null,
          value: value,
          selected: selected,
          enabled: enabled,
          tristate: tristate,
          onChanged: changeable ? (_) {} : null,
        ),
      },
    ),
  );
}

enum _TileVariant { trailing, leading, card }

// =============================================================================
// Showcase
// =============================================================================

class _CheckListTileShowcase extends StatelessWidget {
  const _CheckListTileShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VCheckListTile',
    description: 'A list tile with an integrated checkbox for selection.',
    children: [
      const WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'trailing',
            labels: ['VCheckListTile()'],
            children: [_CheckListTileDemo(variant: 'trailing')],
          ),
          WidgetbookSubsection(
            title: 'leading',
            labels: ['VCheckListTile.leading()'],
            children: [_CheckListTileDemo(variant: 'leading')],
          ),
          WidgetbookSubsection(
            title: 'card',
            labels: ['VCheckListTile.card()'],
            children: [_CheckListTileDemo(variant: 'card')],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'checked',
            labels: ['value: true'],
            children: [
              VCheckListTile(
                title: Text('Checked'),
                subtitle: Text('This item is checked'),
                value: true,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'unchecked',
            labels: ['value: false'],
            children: [
              VCheckListTile(
                title: Text('Unchecked'),
                subtitle: Text('This item is not checked'),
                value: false,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'selected',
            labels: ['selected: true'],
            children: [
              VCheckListTile(
                title: Text('Selected'),
                subtitle: Text('This tile has selected background'),
                value: false,
                selected: true,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: ['enabled: false'],
            children: [
              VCheckListTile(
                title: Text('Disabled'),
                subtitle: Text('This item is disabled'),
                value: false,
                enabled: false,
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'With Secondary',
        children: [
          WidgetbookSubsection(
            title: 'trailing with secondary icon',
            labels: const ['secondary: Icon(...)'],
            children: [
              VCheckListTile(
                title: const Text('Notifications'),
                subtitle: const Text('Receive push alerts'),
                value: true,
                onChanged: (_) {},
                secondary: const Icon(
                  IconData(0xe7f4, fontFamily: 'MaterialIcons'),
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'leading with secondary icon',
            labels: const ['VCheckListTile.leading()', 'secondary'],
            children: [
              VCheckListTile.leading(
                title: const Text('Email Alerts'),
                subtitle: const Text('Get notified by email'),
                value: false,
                onChanged: (_) {},
                secondary: const Icon(
                  IconData(0xe0be, fontFamily: 'MaterialIcons'),
                ),
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Tristate',
        children: [
          WidgetbookSubsection(
            title: 'indeterminate',
            labels: ['tristate: true', 'value: null'],
            children: [
              VCheckListTile(
                title: Text('Select All'),
                subtitle: Text('Some items are checked'),
                value: null,
                tristate: true,
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
              'Multi-select lists like task lists, permission toggles, or filter selections.',
            ),
            _guidelineRow(
              theme,
              'When not to use',
              'For on/off toggles. Use VSwitchListTile instead.',
            ),
            _guidelineRow(
              theme,
              'Trailing',
              'Place checkbox after content for natural left-to-right reading',
            ),
            _guidelineRow(
              theme,
              'Leading',
              'Place checkbox before content when selection is the primary action',
            ),
            _guidelineRow(
              theme,
              'Card',
              'Use card variant when visual distinction is needed',
            ),
            _guidelineRow(
              theme,
              'Secondary',
              'Add secondary icons for additional context or quick actions',
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

class _CheckListTileSample extends StatelessWidget {
  const _CheckListTileSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VCheckListTile Samples',
    description: 'Copy-ready code examples.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic Usage',
        code: '''VCheckListTile(
  title: Text('Receive notifications'),
  subtitle: Text('Get the latest news'),
  value: isChecked,
  onChanged: (value) => setState(() => isChecked = value),
)''',
        preview: _CheckListTileDemo(variant: 'trailing'),
      ),
      WidgetbookCodeBlock(
        title: 'Leading Position',
        code: '''VCheckListTile.leading(
  title: Text('Email notifications'),
  value: isChecked,
  onChanged: (value) => ...,
  secondary: Icon(Icons.email),
)''',
        preview: _CheckListTileDemo(variant: 'leading'),
      ),
      WidgetbookCodeBlock(
        title: 'Card Style',
        code: '''VCheckListTile.card(
  title: Text('Premium Plan'),
  subtitle: Text('Unlimited access to all features'),
  value: isChecked,
  onChanged: (value) => ...,
)''',
        preview: _CheckListTileDemo(variant: 'card'),
      ),
      WidgetbookCodeBlock(
        title: 'Todo list',
        code: '''Column(
  children: [
    VCheckListTile(
      title: Text('Buy groceries'),
      subtitle: Text('Milk, eggs, bread'),
      value: true,
      onChanged: (v) => ...,
    ),
    VCheckListTile(
      title: Text('Clean the house'),
      value: false,
      onChanged: (v) => ...,
    ),
    VCheckListTile(
      title: Text('Walk the dog'),
      subtitle: Text('Evening walk at the park'),
      value: false,
      onChanged: (v) => ...,
    ),
  ],
)''',
        preview: _TodoListDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Permission selector',
        code: '''Column(
  children: [
    VCheckListTile.leading(
      title: Text('Camera'),
      subtitle: Text('Allow access to camera'),
      value: true,
      onChanged: (v) => ...,
      secondary: Icon(Icons.camera_alt),
    ),
    VCheckListTile.leading(
      title: Text('Location'),
      subtitle: Text('Allow location access'),
      value: false,
      onChanged: (v) => ...,
      secondary: Icon(Icons.location_on),
    ),
    VCheckListTile.leading(
      title: Text('Microphone'),
      subtitle: Text('Allow microphone access'),
      value: true,
      onChanged: (v) => ...,
      secondary: Icon(Icons.mic),
    ),
  ],
)''',
        preview: _PermissionSelectorDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Task checklist',
        code: '''Column(
  children: [
    VCheckListTile(
      title: Text('Design mockups'),
      value: true,
      onChanged: (v) => ...,
    ),
    VCheckListTile(
      title: Text('API integration'),
      value: false,
      onChanged: (v) => ...,
    ),
    VCheckListTile(
      title: Text('Write tests'),
      value: false,
      onChanged: (v) => ...,
    ),
  ],
)''',
        preview: _TaskChecklistDemo(),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _CheckListTileDemo extends StatefulWidget {
  const _CheckListTileDemo({required this.variant});

  final String variant;

  @override
  State<_CheckListTileDemo> createState() => _CheckListTileDemoState();
}

class _CheckListTileDemoState extends State<_CheckListTileDemo> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    switch (widget.variant) {
      case 'leading':
        return VCheckListTile.leading(
          title: const Text('Email notifications'),
          subtitle: const Text('Receive important updates via email'),
          value: _checked,
          onChanged: (value) => setState(() => _checked = value ?? false),
          secondary: const Icon(IconData(0xe0be, fontFamily: 'MaterialIcons')),
        );
      case 'card':
        return VCheckListTile.card(
          title: const Text('Premium Plan'),
          subtitle: const Text('Unlimited access to all features'),
          value: _checked,
          onChanged: (value) => setState(() => _checked = value ?? false),
        );
      default:
        return VCheckListTile(
          title: const Text('Receive notifications'),
          subtitle: const Text('Get the latest news'),
          value: _checked,
          onChanged: (value) => setState(() => _checked = value ?? false),
        );
    }
  }
}

class _TodoListDemo extends StatefulWidget {
  const _TodoListDemo();

  @override
  State<_TodoListDemo> createState() => _TodoListDemoState();
}

class _TodoListDemoState extends State<_TodoListDemo> {
  final List<bool> _checked = [true, false, false];

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      VCheckListTile(
        title: const Text('Buy groceries'),
        subtitle: const Text('Milk, eggs, bread'),
        value: _checked[0],
        onChanged: (v) => setState(() => _checked[0] = v ?? false),
      ),
      VCheckListTile(
        title: const Text('Clean the house'),
        value: _checked[1],
        onChanged: (v) => setState(() => _checked[1] = v ?? false),
      ),
      VCheckListTile(
        title: const Text('Walk the dog'),
        subtitle: const Text('Evening walk at the park'),
        value: _checked[2],
        onChanged: (v) => setState(() => _checked[2] = v ?? false),
      ),
    ],
  );
}

class _PermissionSelectorDemo extends StatefulWidget {
  const _PermissionSelectorDemo();

  @override
  State<_PermissionSelectorDemo> createState() =>
      _PermissionSelectorDemoState();
}

class _PermissionSelectorDemoState extends State<_PermissionSelectorDemo> {
  final List<bool> _perms = [true, false, true];

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      VCheckListTile.leading(
        title: const Text('Camera'),
        subtitle: const Text('Allow access to camera'),
        value: _perms[0],
        onChanged: (v) => setState(() => _perms[0] = v ?? false),
        secondary: const Icon(IconData(0xe3b0, fontFamily: 'MaterialIcons')),
      ),
      VCheckListTile.leading(
        title: const Text('Location'),
        subtitle: const Text('Allow location access'),
        value: _perms[1],
        onChanged: (v) => setState(() => _perms[1] = v ?? false),
        secondary: const Icon(IconData(0xe0c8, fontFamily: 'MaterialIcons')),
      ),
      VCheckListTile.leading(
        title: const Text('Microphone'),
        subtitle: const Text('Allow microphone access'),
        value: _perms[2],
        onChanged: (v) => setState(() => _perms[2] = v ?? false),
        secondary: const Icon(IconData(0xe029, fontFamily: 'MaterialIcons')),
      ),
    ],
  );
}

class _TaskChecklistDemo extends StatefulWidget {
  const _TaskChecklistDemo();

  @override
  State<_TaskChecklistDemo> createState() => _TaskChecklistDemoState();
}

class _TaskChecklistDemoState extends State<_TaskChecklistDemo> {
  final List<bool> _tasks = [true, false, false];

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      VCheckListTile(
        title: const Text('Design mockups'),
        value: _tasks[0],
        onChanged: (v) => setState(() => _tasks[0] = v ?? false),
      ),
      VCheckListTile(
        title: const Text('API integration'),
        value: _tasks[1],
        onChanged: (v) => setState(() => _tasks[1] = v ?? false),
      ),
      VCheckListTile(
        title: const Text('Write tests'),
        value: _tasks[2],
        onChanged: (v) => setState(() => _tasks[2] = v ?? false),
      ),
    ],
  );
}
