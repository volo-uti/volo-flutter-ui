import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _BottomNavVariant { standard, labeled }

Widget _bottomNavPlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_BottomNavVariant>(
    label: 'variant',
    options: _BottomNavVariant.values,
    labelBuilder: (v) => v.name,
  );
  final showBadge = k.boolean(label: 'badge');
  final selectedIndex = k.int.slider(
    label: 'selectedIndex',
    max: 3,
    divisions: 3,
  );
  final elevation = k.double.slider(
    label: 'elevation',
    initialValue: 8,
    max: 16,
  );

  var taps = 0;
  int? lastTapped;
  return StatefulBuilder(
    builder: (context, setState) {
      void onTap(int index) => setState(() {
        taps++;
        lastTapped = index;
      });
      final items = _bottomNavItems(showBadge: showBadge);
      return WidgetbookPlayground(
        info: ['taps: $taps', 'onTap index: ${lastTapped ?? '-'}'],
        child: SizedBox(
          width: 400,
          child: switch (variant) {
            _BottomNavVariant.standard => VBottomNav(
              items: items,
              selectedIndex: selectedIndex,
              elevation: elevation,
              onTap: onTap,
            ),
            _BottomNavVariant.labeled => VBottomNav.labeled(
              items: items,
              selectedIndex: selectedIndex,
              elevation: elevation,
              onTap: onTap,
            ),
          },
        ),
      );
    },
  );
}

WidgetbookComponent vBottomNavComponent() => WidgetbookComponent(
  name: 'VBottomNav',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _bottomNavPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _BottomNavShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _BottomNavSample(),
    ),
  ],
);

// =============================================================================
// Showcase
// =============================================================================

class _BottomNavShowcase extends StatelessWidget {
  const _BottomNavShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VBottomNav',
    description:
        'Bottom navigation bar for switching between primary destinations.',
    children: [
      const WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: ['VBottomNav()'],
            children: [_InteractiveBottomNav(variant: 'default')],
          ),
          WidgetbookSubsection(
            title: 'labeled',
            labels: ['VBottomNav.labeled()'],
            children: [_InteractiveBottomNav(variant: 'labeled')],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'With Badge',
        children: [
          WidgetbookSubsection(
            title: 'badge',
            labels: ['dot indicator'],
            children: [
              _InteractiveBottomNav(variant: 'default', showBadge: true),
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
              'Switch between 3-5 primary destinations on mobile screens',
            ),
            _guidelineRow(
              theme,
              'Labels',
              'Show labels for clarity; hide for compact icon-only navigation',
            ),
            _guidelineRow(
              theme,
              'Selection',
              'Always highlight the currently active destination',
            ),
            _guidelineRow(
              theme,
              'Accessibility',
              'Provide descriptive labels for screen readers even when hidden',
            ),
            _guidelineRow(
              theme,
              'Badge',
              'Use badges to indicate new notifications or updates',
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

class _BottomNavSample extends StatelessWidget {
  const _BottomNavSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VBottomNav Samples',
    description: 'Copy-ready code examples.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic Usage',
        code: '''VBottomNav(
  items: [
    VBottomNavItem(key: 'home', icon: Icon(Icons.home), label: 'Home'),
    VBottomNavItem(key: 'search', icon: Icon(Icons.search), label: 'Search'),
    VBottomNavItem(key: 'profile', icon: Icon(Icons.person), label: 'Profile'),
  ],
  selectedIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
)''',
        preview: _InteractiveBottomNav(variant: 'default'),
      ),
      WidgetbookCodeBlock(
        title: 'Labeled Style',
        code: '''VBottomNav.labeled(
  items: [...],
  selectedIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
)''',
        preview: _InteractiveBottomNav(variant: 'labeled'),
      ),
      WidgetbookCodeBlock(
        title: 'With badges',
        code: '''VBottomNav(
  items: [
    VBottomNavItem(
      key: 'home',
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    VBottomNavItem(
      key: 'notifications',
      icon: Icon(Icons.notifications),
      label: 'Alerts',
      badge: Container(
        width: 8, height: 8,
        decoration: BoxDecoration(
          color: Color(0xFFEF4444),
          shape: BoxShape.circle,
        ),
      ),
    ),
    VBottomNavItem(
      key: 'profile',
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
  selectedIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
)''',
        preview: _InteractiveBottomNav(variant: 'default', showBadge: true),
      ),
      WidgetbookCodeBlock(
        title: 'App navigation',
        code: '''VBottomNav(
  items: [
    VBottomNavItem(key: 'home', icon: Icon(Icons.home), label: 'Home'),
    VBottomNavItem(key: 'search', icon: Icon(Icons.search), label: 'Search'),
    VBottomNavItem(key: 'notifications', icon: Icon(Icons.notifications), label: 'Notifications'),
    VBottomNavItem(key: 'profile', icon: Icon(Icons.person), label: 'Profile'),
  ],
  selectedIndex: _selectedIndex,
  onTap: (index) {
    setState(() => _selectedIndex = index);
    _pageController.jumpToPage(index);
  },
)''',
        preview: _InteractiveBottomNav(variant: 'default'),
      ),
      WidgetbookCodeBlock(
        title: 'Bottom nav with badge',
        code: '''VBottomNav(
  items: [
    VBottomNavItem(key: 'home', icon: Icon(Icons.home), label: 'Home'),
    VBottomNavItem(
      key: 'notifications',
      icon: Icon(Icons.notifications),
      label: 'Alerts',
      badge: VBadge.destructive(label: Text('3')),
    ),
    VBottomNavItem(key: 'settings', icon: Icon(Icons.settings), label: 'Settings'),
  ],
  selectedIndex: 0,
  onTap: (i) {},
)''',
        preview: _InteractiveBottomNav(variant: 'default', showBadge: true),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _InteractiveBottomNav extends StatefulWidget {
  const _InteractiveBottomNav({required this.variant, this.showBadge = false});

  final String variant;
  final bool showBadge;

  @override
  State<_InteractiveBottomNav> createState() => _InteractiveBottomNavState();
}

class _InteractiveBottomNavState extends State<_InteractiveBottomNav> {
  int _selectedIndex = 0;

  List<VBottomNavItem> get _items =>
      _bottomNavItems(showBadge: widget.showBadge);

  @override
  Widget build(BuildContext context) {
    switch (widget.variant) {
      case 'labeled':
        return VBottomNav.labeled(
          items: _items,
          selectedIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        );
      default:
        return VBottomNav(
          items: _items,
          selectedIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        );
    }
  }
}

List<VBottomNavItem> _bottomNavItems({bool showBadge = false}) => [
  VBottomNavItem(
    key: 'home',
    icon: const Icon(IconData(0xe88a, fontFamily: 'MaterialIcons')),
    label: 'Home',
    badge: showBadge
        ? Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFEF4444),
              shape: BoxShape.circle,
            ),
          )
        : null,
  ),
  const VBottomNavItem(
    key: 'search',
    icon: Icon(IconData(0xe8b6, fontFamily: 'MaterialIcons')),
    label: 'Search',
  ),
  const VBottomNavItem(
    key: 'favorites',
    icon: Icon(IconData(0xe87d, fontFamily: 'MaterialIcons')),
    label: 'Favorites',
  ),
  const VBottomNavItem(
    key: 'profile',
    icon: Icon(IconData(0xe7fd, fontFamily: 'MaterialIcons')),
    label: 'Profile',
  ),
];
