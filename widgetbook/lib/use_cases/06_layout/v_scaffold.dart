import 'package:flutter/material.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vScaffoldComponent() => WidgetbookComponent(
  name: 'VScaffold',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _scaffoldPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _ScaffoldShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _ScaffoldSample(),
    ),
  ],
);

Widget _scaffoldPlayground(BuildContext context) {
  final k = context.knobs;
  final showAppBar = k.boolean(label: 'appBar', initialValue: true);
  final showBottomNav = k.boolean(label: 'bottomNavigationBar');
  final showFab = k.boolean(label: 'floatingActionButton');
  final fabLocation = k.object.dropdown<VFabLocation>(
    label: 'floatingActionButtonLocation',
    options: VFabLocation.values,
    initialOption: VFabLocation.endFloat,
    labelBuilder: (v) => v.name,
  );
  final backgroundColor = k.colorOrNull(label: 'backgroundColor');
  final resizeToAvoidBottomInset = k.boolean(
    label: 'resizeToAvoidBottomInset',
    initialValue: true,
  );
  final extendBody = k.boolean(label: 'extendBody');
  final extendBodyBehindAppBar = k.boolean(label: 'extendBodyBehindAppBar');

  return WidgetbookPlayground(
    child: SizedBox(
      height: 300,
      child: VScaffold(
        appBar: showAppBar ? const VAppBar(title: Text('Title')) : null,
        bottomNavigationBar: showBottomNav
            ? VBottomNav(
                onTap: (_) {},
                items: const [
                  VBottomNavItem(
                    key: 'home',
                    icon: Icon(IconData(0xe88a, fontFamily: 'MaterialIcons')),
                    label: 'Home',
                  ),
                  VBottomNavItem(
                    key: 'search',
                    icon: Icon(IconData(0xe8b6, fontFamily: 'MaterialIcons')),
                    label: 'Search',
                  ),
                  VBottomNavItem(
                    key: 'profile',
                    icon: Icon(IconData(0xe7fd, fontFamily: 'MaterialIcons')),
                    label: 'Profile',
                  ),
                ],
              )
            : null,
        floatingActionButton: showFab
            ? VFab(
                onPressed: () {},
                icon: const Icon(IconData(0xe145, fontFamily: 'MaterialIcons')),
              )
            : null,
        floatingActionButtonLocation: fabLocation,
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        body: const Center(child: Text('Body Area')),
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _ScaffoldShowcase extends StatelessWidget {
  const _ScaffoldShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VScaffold',
    description:
        'A scaffold component that provides the base layout for app screens.',
    children: [
      const WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: ['VScaffold()'],
            children: [
              SizedBox(
                height: 200,
                child: VScaffold(
                  appBar: VAppBar(title: Text('Title')),
                  body: Center(child: Text('Body Area')),
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'scrollable body',
            labels: ['VScaffold(body: CustomScrollView)'],
            children: [SizedBox(height: 280, child: _ScrollableScaffoldDemo())],
          ),
          WidgetbookSubsection(
            title: 'tabs in the body',
            labels: ['VScaffold(body: VTabs)'],
            children: [SizedBox(height: 320, child: _TabsScaffoldDemo())],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'With Bottom Navigation',
        children: [
          WidgetbookSubsection(
            title: 'bottomNavigationBar',
            labels: ['VBottomNav'],
            children: [
              SizedBox(height: 280, child: _InteractiveScaffoldWithBottomNav()),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'FAB Location',
        children: [
          WidgetbookSubsection(
            title: 'endFloat',
            labels: const ['VFabLocation.endFloat'],
            children: [
              SizedBox(
                height: 160,
                child: VScaffold(
                  appBar: const VAppBar(title: Text('endFloat')),
                  floatingActionButton: VFab(
                    onPressed: () {},
                    icon: const Icon(
                      IconData(0xe145, fontFamily: 'MaterialIcons'),
                    ),
                  ),
                  body: const Center(child: Text('Bottom Right')),
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'centerFloat',
            labels: const ['VFabLocation.centerFloat'],
            children: [
              SizedBox(
                height: 160,
                child: VScaffold(
                  appBar: const VAppBar(title: Text('centerFloat')),
                  floatingActionButtonLocation: VFabLocation.centerFloat,
                  floatingActionButton: VFab(
                    onPressed: () {},
                    icon: const Icon(
                      IconData(0xe145, fontFamily: 'MaterialIcons'),
                    ),
                  ),
                  body: const Center(child: Text('Bottom Center')),
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'startFloat',
            labels: const ['VFabLocation.startFloat'],
            children: [
              SizedBox(
                height: 160,
                child: VScaffold(
                  appBar: const VAppBar(title: Text('startFloat')),
                  floatingActionButtonLocation: VFabLocation.startFloat,
                  floatingActionButton: VFab(
                    onPressed: () {},
                    icon: const Icon(
                      IconData(0xe145, fontFamily: 'MaterialIcons'),
                    ),
                  ),
                  body: const Center(child: Text('Bottom Left')),
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'endDocked',
            labels: const ['VFabLocation.endDocked'],
            children: [
              SizedBox(
                height: 200,
                child: VScaffold(
                  appBar: const VAppBar(title: Text('endDocked')),
                  floatingActionButtonLocation: VFabLocation.endDocked,
                  floatingActionButton: VFab(
                    onPressed: () {},
                    icon: const Icon(
                      IconData(0xe145, fontFamily: 'MaterialIcons'),
                    ),
                  ),
                  bottomNavigationBar: VBottomNav(
                    items: const [
                      VBottomNavItem(
                        key: 'home',
                        icon: Icon(
                          IconData(0xe88a, fontFamily: 'MaterialIcons'),
                        ),
                        label: 'Home',
                      ),
                      VBottomNavItem(
                        key: 'search',
                        icon: Icon(
                          IconData(0xe8b6, fontFamily: 'MaterialIcons'),
                        ),
                        label: 'Search',
                      ),
                      VBottomNavItem(
                        key: 'profile',
                        icon: Icon(
                          IconData(0xe7fd, fontFamily: 'MaterialIcons'),
                        ),
                        label: 'Profile',
                      ),
                    ],
                  ),
                  body: const Center(child: Text('End Docked')),
                ),
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'centerDocked',
            labels: const ['VFabLocation.centerDocked'],
            children: [
              SizedBox(
                height: 200,
                child: VScaffold(
                  appBar: const VAppBar(title: Text('centerDocked')),
                  floatingActionButtonLocation: VFabLocation.centerDocked,
                  floatingActionButton: VFab(
                    onPressed: () {},
                    icon: const Icon(
                      IconData(0xe145, fontFamily: 'MaterialIcons'),
                    ),
                  ),
                  bottomNavigationBar: VBottomNav(
                    items: const [
                      VBottomNavItem(
                        key: 'home',
                        icon: Icon(
                          IconData(0xe88a, fontFamily: 'MaterialIcons'),
                        ),
                        label: 'Home',
                      ),
                      VBottomNavItem(
                        key: 'search',
                        icon: Icon(
                          IconData(0xe8b6, fontFamily: 'MaterialIcons'),
                        ),
                        label: 'Search',
                      ),
                      VBottomNavItem(
                        key: 'profile',
                        icon: Icon(
                          IconData(0xe7fd, fontFamily: 'MaterialIcons'),
                        ),
                        label: 'Profile',
                      ),
                    ],
                  ),
                  body: const Center(child: Text('Center Docked')),
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
              'Use to set up the base structure of a screen',
            ),
            _guidelineRow(
              theme,
              'appBar + body',
              'The basic combination of app bar and body area',
            ),
            _guidelineRow(
              theme,
              'bottomNav',
              'Add when tab-based navigation is needed',
            ),
            _guidelineRow(
              theme,
              'FAB',
              'Use floatingActionButton when a primary action button is needed',
            ),
            _guidelineRow(
              theme,
              'FAB Location',
              'Use centerFloat for center placement; default is bottom right',
            ),
            _guidelineRow(
              theme,
              'extendBody',
              'Use when the body should extend behind the bottom nav',
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

class _ScaffoldSample extends StatelessWidget {
  const _ScaffoldSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VScaffold Samples',
    description: 'Copy-ready code examples.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Basic Usage',
        code: '''VScaffold(
  appBar: VAppBar(title: Text('Title')),
  body: Center(child: Text('Body')),
)''',
        preview: SizedBox(
          height: 150,
          child: VScaffold(
            appBar: VAppBar(title: Text('Title')),
            body: Center(child: Text('Body')),
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'With FAB',
        code: '''VScaffold(
  appBar: VAppBar(title: Text('Title')),
  floatingActionButton: VFab(
    onPressed: () {},
    icon: Icon(Icons.add),
  ),
  body: Content(),
)''',
        preview: SizedBox(
          height: 150,
          child: VScaffold(
            appBar: const VAppBar(title: Text('Title')),
            floatingActionButton: VFab(
              onPressed: () {},
              icon: const Icon(IconData(0xe145, fontFamily: 'MaterialIcons')),
            ),
            body: const Center(child: Text('Body')),
          ),
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Scrollable body',
        code: '''VScaffold(
  body: CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: VAppBar(title: Text('Title')),
      ),
      SliverList(...),
    ],
  ),
)''',
        preview: SizedBox(height: 200, child: _ScrollableScaffoldDemo()),
      ),
      const WidgetbookCodeBlock(
        title: 'Tabs in the body',
        code: '''VScaffold(
  appBar: VAppBar(title: Text('Tab Screen')),
  body: VTabs(
    tabs: [
      VTab(label: Text('Home'), content: HomeTab()),
      VTab(label: Text('Search'), content: SearchTab()),
    ],
  ),
)''',
        preview: SizedBox(height: 320, child: _TabsScaffoldDemo()),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _InteractiveScaffoldWithBottomNav extends StatefulWidget {
  const _InteractiveScaffoldWithBottomNav();

  @override
  State<_InteractiveScaffoldWithBottomNav> createState() =>
      _InteractiveScaffoldWithBottomNavState();
}

class _InteractiveScaffoldWithBottomNavState
    extends State<_InteractiveScaffoldWithBottomNav> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) => VScaffold(
    appBar: const VAppBar(title: Text('Bottom Navigation')),
    bottomNavigationBar: VBottomNav(
      selectedIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        VBottomNavItem(
          key: 'home',
          icon: Icon(IconData(0xe88a, fontFamily: 'MaterialIcons')),
          label: 'Home',
        ),
        VBottomNavItem(
          key: 'search',
          icon: Icon(IconData(0xe8b6, fontFamily: 'MaterialIcons')),
          label: 'Search',
        ),
        VBottomNavItem(
          key: 'profile',
          icon: Icon(IconData(0xe7fd, fontFamily: 'MaterialIcons')),
          label: 'Profile',
        ),
      ],
    ),
    body: Center(child: Text('Selected Tab: $_selectedIndex')),
  );
}

class _ScrollableScaffoldDemo extends StatelessWidget {
  const _ScrollableScaffoldDemo();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    return VScaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: VAppBar(
              title: const Text('Scrollable body'),
              backgroundColor: theme.colors.primary,
              foregroundColor: theme.colors.primaryForeground,
              centerTitle: true,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => VListTile(
                title: Text('Item ${index + 1}'),
                subtitle: const Text('Scroll to see the app bar effect'),
              ),
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabsScaffoldDemo extends StatelessWidget {
  const _TabsScaffoldDemo();

  @override
  Widget build(BuildContext context) => const VScaffold(
    appBar: VAppBar(title: Text('Tab Screen')),
    body: VTabs(
      tabs: [
        VTab(
          label: Text('Home'),
          content: Center(child: Text('Home Tab Content')),
        ),
        VTab(
          label: Text('Search'),
          content: Center(child: Text('Search Tab Content')),
        ),
        VTab(
          label: Text('Settings'),
          content: Center(child: Text('Settings Tab Content')),
        ),
      ],
    ),
  );
}
