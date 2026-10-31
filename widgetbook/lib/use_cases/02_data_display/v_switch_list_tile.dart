import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vSwitchListTileComponent() => WidgetbookComponent(
  name: 'VSwitchListTile',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _switchListTilePlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _SwitchListTileShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _SwitchListTileSample(),
    ),
  ],
);

Widget _switchListTilePlayground(BuildContext context) {
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
  final value = k.boolean(label: 'value', initialValue: true);

  final titleWidget = Text(title);
  final subtitleWidget = subtitle.isEmpty ? null : Text(subtitle);
  const secondaryIcon = Icon(IconData(0xe7f4, fontFamily: 'MaterialIcons'));

  return WidgetbookPlayground(
    child: SizedBox(
      width: 420,
      child: switch (variant) {
        _TileVariant.trailing => VSwitchListTile(
          title: titleWidget,
          subtitle: subtitleWidget,
          secondary: secondary ? secondaryIcon : null,
          value: value,
          selected: selected,
          enabled: enabled,

          onChanged: changeable ? (_) {} : null,
        ),
        _TileVariant.leading => VSwitchListTile.leading(
          title: titleWidget,
          subtitle: subtitleWidget,
          secondary: secondary ? secondaryIcon : null,
          value: value,
          selected: selected,
          enabled: enabled,

          onChanged: changeable ? (_) {} : null,
        ),
        _TileVariant.card => VSwitchListTile.card(
          title: titleWidget,
          subtitle: subtitleWidget,
          secondary: secondary ? secondaryIcon : null,
          value: value,
          selected: selected,
          enabled: enabled,

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

class _SwitchListTileShowcase extends StatelessWidget {
  const _SwitchListTileShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VSwitchListTile',
    description: 'A list tile with an integrated switch for toggling options.',
    children: [
      const WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'trailing',
            labels: ['VSwitchListTile()'],
            children: [_SwitchListTileDemo(variant: 'trailing')],
          ),
          WidgetbookSubsection(
            title: 'leading',
            labels: ['VSwitchListTile.leading()'],
            children: [_SwitchListTileDemo(variant: 'leading')],
          ),
          WidgetbookSubsection(
            title: 'card',
            labels: ['VSwitchListTile.card()'],
            children: [_SwitchListTileDemo(variant: 'card')],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'on',
            labels: ['value: true'],
            children: [
              VSwitchListTile(
                title: Text('On State'),
                subtitle: Text('Switch is turned on'),
                value: true,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'off',
            labels: ['value: false'],
            children: [
              VSwitchListTile(
                title: Text('Off State'),
                subtitle: Text('Switch is turned off'),
                value: false,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'selected',
            labels: ['selected: true'],
            children: [
              VSwitchListTile(
                title: Text('Selected'),
                subtitle: Text('Tile has selected background'),
                value: false,
                selected: true,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: ['enabled: false'],
            children: [
              VSwitchListTile(
                title: Text('Disabled'),
                subtitle: Text('Switch is disabled'),
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
              VSwitchListTile(
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
            labels: const ['VSwitchListTile.leading()', 'secondary'],
            children: [
              VSwitchListTile.leading(
                title: const Text('Location'),
                subtitle: const Text('Allow location access'),
                value: false,
                onChanged: (_) {},
                secondary: const Icon(
                  IconData(0xe0c8, fontFamily: 'MaterialIcons'),
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
              'Toggle settings, enable/disable features, or on/off preferences in a list format.',
            ),
            _guidelineRow(
              theme,
              'When not to use',
              'For multi-select lists where multiple items can be checked. Use VCheckListTile instead.',
            ),
            _guidelineRow(
              theme,
              'Variant',
              'Use trailing (default) for settings lists. Use leading when the switch is the primary visual element.',
            ),
            _guidelineRow(
              theme,
              'Immediate',
              'Changes take effect immediately without form submission',
            ),
            _guidelineRow(theme, 'Binary', 'Use for simple on/off toggles'),
            _guidelineRow(
              theme,
              'Card',
              'Use card variant for visually prominent settings',
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

class _SwitchListTileSample extends StatelessWidget {
  const _SwitchListTileSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VSwitchListTile Samples',
    description: 'Copy-ready code examples.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic Usage',
        code: '''VSwitchListTile(
  title: Text('Notifications'),
  subtitle: Text('Receive push notifications'),
  value: isOn,
  onChanged: (value) => setState(() => isOn = value),
)''',
        preview: _SwitchListTileDemo(variant: 'trailing'),
      ),
      WidgetbookCodeBlock(
        title: 'Leading Position',
        code: '''VSwitchListTile.leading(
  title: Text('Wi-Fi'),
  subtitle: Text('Connected'),
  value: isOn,
  onChanged: (value) => ...,
  secondary: Icon(Icons.wifi),
)''',
        preview: _SwitchListTileDemo(variant: 'leading'),
      ),
      WidgetbookCodeBlock(
        title: 'Card Style',
        code: '''VSwitchListTile.card(
  title: Text('Dark Mode'),
  subtitle: Text('Use dark theme'),
  value: isOn,
  onChanged: (value) => ...,
)''',
        preview: _SwitchListTileDemo(variant: 'card'),
      ),
      WidgetbookCodeBlock(
        title: 'Notification settings',
        code: '''Column(
  children: [
    VSwitchListTile(
      title: Text('Push notifications'),
      subtitle: Text('Receive push alerts on your device'),
      value: pushOn,
      onChanged: (v) => setState(() => pushOn = v),
      secondary: Icon(Icons.notifications_active),
    ),
    VSwitchListTile(
      title: Text('Email notifications'),
      subtitle: Text('Receive daily digest via email'),
      value: emailOn,
      onChanged: (v) => setState(() => emailOn = v),
      secondary: Icon(Icons.email),
    ),
    VSwitchListTile(
      title: Text('SMS alerts'),
      subtitle: Text('Receive critical alerts via SMS'),
      value: smsOn,
      onChanged: (v) => setState(() => smsOn = v),
      secondary: Icon(Icons.sms),
    ),
  ],
)''',
        preview: _NotificationSettingsDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Privacy settings',
        code: '''Column(
  children: [
    VSwitchListTile(
      title: Text('Profile visibility'),
      subtitle: Text('Allow others to see your profile'),
      value: profileVisible,
      onChanged: (v) => ...,
    ),
    VSwitchListTile(
      title: Text('Online status'),
      subtitle: Text('Show when you are online'),
      value: showOnline,
      onChanged: (v) => ...,
    ),
    VSwitchListTile(
      title: Text('Read receipts'),
      subtitle: Text('Let others know you read their messages'),
      value: readReceipts,
      onChanged: (v) => ...,
    ),
  ],
)''',
        preview: _PrivacySettingsDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Feature flags',
        code: '''Column(
  children: [
    VSwitchListTile(
      title: Text('Beta features'),
      subtitle: Text('Try experimental features'),
      value: beta,
      onChanged: (v) => ...,
    ),
    VSwitchListTile(
      title: Text('Analytics'),
      subtitle: Text('Help improve the app'),
      value: analytics,
      onChanged: (v) => ...,
    ),
  ],
)''',
        preview: _FeatureFlagsDemo(),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _SwitchListTileDemo extends StatefulWidget {
  const _SwitchListTileDemo({required this.variant});

  final String variant;

  @override
  State<_SwitchListTileDemo> createState() => _SwitchListTileDemoState();
}

class _SwitchListTileDemoState extends State<_SwitchListTileDemo> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    switch (widget.variant) {
      case 'leading':
        return VSwitchListTile.leading(
          title: const Text('Wi-Fi'),
          subtitle: const Text('Connected'),
          value: _value,
          onChanged: (value) => setState(() => _value = value),
          secondary: const Icon(IconData(0xe63e, fontFamily: 'MaterialIcons')),
        );
      case 'card':
        return VSwitchListTile.card(
          title: const Text('Dark Mode'),
          subtitle: const Text('Use dark theme'),
          value: _value,
          onChanged: (value) => setState(() => _value = value),
        );
      default:
        return VSwitchListTile(
          title: const Text('Notifications'),
          subtitle: const Text('Receive push notifications'),
          value: _value,
          onChanged: (value) => setState(() => _value = value),
        );
    }
  }
}

class _NotificationSettingsDemo extends StatefulWidget {
  const _NotificationSettingsDemo();

  @override
  State<_NotificationSettingsDemo> createState() =>
      _NotificationSettingsDemoState();
}

class _NotificationSettingsDemoState extends State<_NotificationSettingsDemo> {
  bool _push = true;
  bool _email = false;
  bool _sms = false;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      VSwitchListTile(
        title: const Text('Push notifications'),
        subtitle: const Text('Receive push alerts on your device'),
        value: _push,
        onChanged: (v) => setState(() => _push = v),
        secondary: const Icon(IconData(0xe7f7, fontFamily: 'MaterialIcons')),
      ),
      VSwitchListTile(
        title: const Text('Email notifications'),
        subtitle: const Text('Receive daily digest via email'),
        value: _email,
        onChanged: (v) => setState(() => _email = v),
        secondary: const Icon(IconData(0xe0be, fontFamily: 'MaterialIcons')),
      ),
      VSwitchListTile(
        title: const Text('SMS alerts'),
        subtitle: const Text('Receive critical alerts via SMS'),
        value: _sms,
        onChanged: (v) => setState(() => _sms = v),
        secondary: const Icon(IconData(0xe625, fontFamily: 'MaterialIcons')),
      ),
    ],
  );
}

class _PrivacySettingsDemo extends StatefulWidget {
  const _PrivacySettingsDemo();

  @override
  State<_PrivacySettingsDemo> createState() => _PrivacySettingsDemoState();
}

class _PrivacySettingsDemoState extends State<_PrivacySettingsDemo> {
  bool _profile = true;
  bool _online = true;
  bool _read = false;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      VSwitchListTile(
        title: const Text('Profile visibility'),
        subtitle: const Text('Allow others to see your profile'),
        value: _profile,
        onChanged: (v) => setState(() => _profile = v),
      ),
      VSwitchListTile(
        title: const Text('Online status'),
        subtitle: const Text('Show when you are online'),
        value: _online,
        onChanged: (v) => setState(() => _online = v),
      ),
      VSwitchListTile(
        title: const Text('Read receipts'),
        subtitle: const Text('Let others know you read their messages'),
        value: _read,
        onChanged: (v) => setState(() => _read = v),
      ),
    ],
  );
}

class _FeatureFlagsDemo extends StatefulWidget {
  const _FeatureFlagsDemo();

  @override
  State<_FeatureFlagsDemo> createState() => _FeatureFlagsDemoState();
}

class _FeatureFlagsDemoState extends State<_FeatureFlagsDemo> {
  bool _beta = false;
  bool _analytics = true;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      VSwitchListTile(
        title: const Text('Beta features'),
        subtitle: const Text('Try experimental features'),
        value: _beta,
        onChanged: (v) => setState(() => _beta = v),
      ),
      VSwitchListTile(
        title: const Text('Analytics'),
        subtitle: const Text('Help improve the app'),
        value: _analytics,
        onChanged: (v) => setState(() => _analytics = v),
      ),
    ],
  );
}
