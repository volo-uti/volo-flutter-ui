import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../components/widgetbook_components.dart';

WidgetbookComponent aboutComponent() => WidgetbookComponent(
  name: 'Volo Flutter UI',
  useCases: [
    WidgetbookUseCase(
      name: 'overview',
      builder: (context) => const _AboutOverview(),
    ),
    WidgetbookUseCase(
      name: 'installation',
      builder: (context) => const _AboutInstallation(),
    ),
    WidgetbookUseCase(
      name: 'components',
      builder: (context) => const _AboutComponents(),
    ),
  ],
);

// =============================================================================
// Overview
// =============================================================================

class _AboutOverview extends StatelessWidget {
  const _AboutOverview();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return WidgetbookPageLayout(
      title: 'Volo Flutter UI',
      description: 'A modern Flutter UI component library',
      children: [
        // Hero Section
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colors.primary,
                theme.colors.primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Volo Flutter UI',
                style: theme.typography.displayLarge.copyWith(
                  color: theme.colors.primaryForeground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Modern • Accessible • Customizable',
                style: theme.typography.titleMedium.copyWith(
                  color: theme.colors.primaryForeground.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _Stat(
                    label: '67',
                    description: 'Components',
                    color: theme.colors.primaryForeground,
                  ),
                  const SizedBox(width: 24),
                  _Stat(
                    label: '6',
                    description: 'Categories',
                    color: theme.colors.primaryForeground,
                  ),
                  const SizedBox(width: 24),
                  _Stat(
                    label: '100%',
                    description: 'Dart/Flutter',
                    color: theme.colors.primaryForeground,
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Features
        WidgetbookSection(title: 'Key Features', children: [_FeatureGrid()]),

        // Design Principles
        const WidgetbookSection(
          title: 'Design Principles',
          children: [
            _PrincipleItem(
              number: '01',
              title: 'Consistency',
              description:
                  'All components follow the same design tokens and patterns.',
            ),
            _PrincipleItem(
              number: '02',
              title: 'Accessibility',
              description: 'WCAG 2.2 compliant, accessible to all users.',
            ),
            _PrincipleItem(
              number: '03',
              title: 'Customization',
              description:
                  'Easily customize the entire design system via theme provider.',
            ),
            _PrincipleItem(
              number: '04',
              title: 'Performance',
              description:
                  'Optimized rendering and efficient rebuilds for smooth UX.',
            ),
          ],
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.description,
    required this.color,
  });

  final String label;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.typography.headlineMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          description,
          style: theme.typography.labelSmall.copyWith(
            color: color.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    final features = [
      (
        '🎨',
        'Theme System',
        'Fully customizable colors, typography, spacing via VTheme',
      ),
      (
        '📱',
        'Responsive',
        'Mobile, tablet, desktop — all screen sizes supported',
      ),
      (
        '♿',
        'Accessible',
        'Semantics, keyboard navigation, screen reader support',
      ),
      ('🌙', 'Dark Mode', 'Automatic light/dark mode switching'),
      ('🧩', 'Composable', 'Compose components to build complex UIs'),
      ('📖', 'Well Documented', 'Comprehensive doc comments and code examples'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 16) / 2;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: features
              .map(
                (f) => Container(
                  width: cardWidth,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colors.border),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f.$1, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              f.$2,
                              style: theme.typography.titleSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colors.foreground,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              f.$3,
                              style: theme.typography.bodySmall.copyWith(
                                color: theme.colors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _PrincipleItem extends StatelessWidget {
  const _PrincipleItem({
    required this.number,
    required this.title,
    required this.description,
  });

  final String number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: theme.typography.titleMedium.copyWith(
                color: theme.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.typography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colors.foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.typography.bodyMedium.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Installation
// =============================================================================

class _AboutInstallation extends StatelessWidget {
  const _AboutInstallation();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'Installation',
    description: 'How to add Volo Flutter UI to your project',
    children: [
      WidgetbookCodeBlock(
        title: '1. Add dependency to pubspec.yaml',
        code: '''dependencies:
  volo_flutter_ui: ^1.0.0''',
      ),
      WidgetbookCodeBlock(
        title: '2. Install the package',
        code: '''flutter pub get''',
        language: 'bash',
      ),
      WidgetbookCodeBlock(
        title: '3. Wrap your app in VApp',
        code: '''import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const VApp(
      home: HomeScreen(),
    );
  }
}''',
      ),
      WidgetbookCodeBlock(
        title: '4. Use components',
        code: '''import 'package:volo_flutter_ui/volo_flutter_ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VScaffold(
      appBar: VAppBar(title: Text('Volo Flutter UI')),
      body: Center(
        child: VButton(
          onPressed: () {},
          child: Text('Hello Volo Flutter UI!'),
        ),
      ),
    );
  }
}''',
      ),
    ],
  );
}

// =============================================================================
// Components
// =============================================================================

class _AboutComponents extends StatelessWidget {
  const _AboutComponents();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    final categories = [
      const _CategoryInfo(
        name: 'Inputs',
        icon: '✏️',
        count: 18,
        components: [
          'VButton',
          'VIconButton',
          'VFab',
          'VCheckbox',
          'VRadio',
          'VSwitch',
          'VToggleButton',
          'VSlider',
          'VTextField',
          'VTextArea',
          'VSelect',
          'VAutocomplete',
          'VDatePicker',
          'VCalendar',
          'VFormField',
          'VFormHeader',
          'VFormBody',
          'VFormFooter',
        ],
      ),
      const _CategoryInfo(
        name: 'Data Display',
        icon: '📊',
        count: 12,
        components: [
          'VImage',
          'VAvatar',
          'VBadge',
          'VChip',
          'VDivider',
          'VHoverCard',
          'VListTile',
          'VCheckListTile',
          'VSwitchListTile',
          'VSettingTile',
          'VTooltip',
          'VTable',
        ],
      ),
      const _CategoryInfo(
        name: 'Feedback',
        icon: '💬',
        count: 7,
        components: [
          'VProgress',
          'VAlert',
          'VDialog',
          'VSkeleton',
          'VToast',
          'VSnackbar',
          'VStepper',
        ],
      ),
      const _CategoryInfo(
        name: 'Surfaces',
        icon: '🎴',
        count: 4,
        components: ['VCard', 'VAccordion', 'VSheet', 'VPopover'],
      ),
      const _CategoryInfo(
        name: 'Navigation',
        icon: '🧭',
        count: 9,
        components: [
          'VAppBar',
          'VBottomNav',
          'VBreadcrumb',
          'VCommand',
          'VDrawer',
          'VMenu',
          'VPageIndicator',
          'VPagination',
          'VTabs',
        ],
      ),
      const _CategoryInfo(
        name: 'Layout',
        icon: '📐',
        count: 8,
        components: [
          'VScaffold',
          'VBox',
          'VStack',
          'VGrid',
          'VSection',
          'VCarousel',
          'VResizable',
          'VScrollArea',
        ],
      ),
    ];

    return WidgetbookPageLayout(
      title: 'Components',
      description: '58 UI components across 6 categories.',
      children: [
        // Summary
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colors.muted,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: categories
                .map(
                  (c) => Column(
                    children: [
                      Text(c.icon, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 8),
                      Text(
                        '${c.count}',
                        style: theme.typography.headlineSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colors.foreground,
                        ),
                      ),
                      Text(
                        c.name,
                        style: theme.typography.labelSmall.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),

        const SizedBox(height: 24),

        // Category Details
        ...categories.map(
          (category) => WidgetbookSection(
            title: '${category.icon} ${category.name}',
            description: '${category.count} components',
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: category.components
                    .map(
                      (name) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colors.card,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.colors.border),
                        ),
                        child: Text(
                          name,
                          style: theme.typography.labelMedium.copyWith(
                            color: theme.colors.foreground,
                            fontFamily: theme.typography.fontFamilyMono,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryInfo {
  const _CategoryInfo({
    required this.name,
    required this.icon,
    required this.count,
    required this.components,
  });

  final String name;
  final String icon;
  final int count;
  final List<String> components;
}
