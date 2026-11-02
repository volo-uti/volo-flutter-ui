import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vAppComponent() => WidgetbookComponent(
  name: 'VApp',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _appPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _AppShowcase(),
    ),
    WidgetbookUseCase(name: 'Sample', builder: (context) => const _AppSample()),
  ],
);

Widget _appPlayground(BuildContext context) {
  final k = context.knobs;
  final themeMode = k.object.dropdown<VAppThemeMode>(
    label: 'themeMode',
    options: VAppThemeMode.values,
    initialOption: VAppThemeMode.light,
    labelBuilder: (v) => v.name,
  );
  final title = k.string(label: 'title', initialValue: 'Playground app');
  final showBanner = k.boolean(label: 'debugShowCheckedModeBanner');
  final color = k.colorOrNull(label: 'color');

  return WidgetbookPlayground(
    info: ['themeMode: ${themeMode.name}'],
    child: SizedBox(
      width: 280,
      height: 200,
      child: VApp(
        // A new key restarts the nested app when a knob changes.
        key: ValueKey((themeMode, title, showBanner, color)),
        themeMode: themeMode,
        title: title,
        debugShowCheckedModeBanner: showBanner,
        color: color,
        home: const _AppPreview(),
      ),
    ),
  );
}

class _AppPreview extends StatelessWidget {
  const _AppPreview();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return ColoredBox(
      color: colors.card,
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VApp',
              style: typography.titleLarge.copyWith(color: colors.foreground),
            ),
            SizedBox(height: theme.spacing.sm),
            Text(
              'Tokens come from the VTheme that VApp installs.',
              style: typography.bodyMedium.copyWith(color: colors.foreground),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Showcase
// =============================================================================

class _AppShowcase extends StatelessWidget {
  const _AppShowcase();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return WidgetbookPageLayout(
      title: 'VApp',
      description:
          'App root that wraps WidgetsApp in VTheme and follows system brightness.',
      children: [
        WidgetbookSection(
          title: 'Theme Modes',
          children: [
            WidgetbookSubsection(
              title: 'system',
              labels: const ['themeMode="system"'],
              children: [
                _ModeCard(
                  mode: 'System',
                  description: 'Follows system brightness setting',
                  colors: colors,
                  typography: typography,
                  theme: theme,
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'light',
              labels: const ['themeMode="light"'],
              children: [
                _ModeCard(
                  mode: 'Light',
                  description: 'Always uses light theme',
                  colors: colors,
                  typography: typography,
                  theme: theme,
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'dark',
              labels: const ['themeMode="dark"'],
              children: [
                _ModeCard(
                  mode: 'Dark',
                  description: 'Always uses dark theme',
                  colors: colors,
                  typography: typography,
                  theme: theme,
                ),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Features',
          children: [
            WidgetbookSubsection(
              title: 'Zero Material Dependency',
              labels: const ['WidgetsApp-based'],
              children: [
                Padding(
                  padding: EdgeInsets.all(theme.spacing.md),
                  child: Text(
                    'VApp uses WidgetsApp internally, not MaterialApp. '
                    'This ensures zero Material Design dependency.',
                    style: typography.bodyMedium,
                  ),
                ),
              ],
            ),
            WidgetbookSubsection(
              title: 'Auto Theme Detection',
              labels: const ['MediaQuery.platformBrightnessOf'],
              children: [
                Padding(
                  padding: EdgeInsets.all(theme.spacing.md),
                  child: Text(
                    'Automatically detects system brightness and applies '
                    'the corresponding light or dark theme.',
                    style: typography.bodyMedium,
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

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.mode,
    required this.description,
    required this.colors,
    required this.typography,
    required this.theme,
  });

  final String mode;
  final String description;
  final VColors colors;
  final VTypography typography;
  final VThemeData theme;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.all(theme.spacing.md),
    child: VCard.outlined(
      padding: EdgeInsets.all(theme.spacing.md),
      borderRadius: theme.radius.mdRadius,
      style: VCardStyle(backgroundColor: colors.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mode, style: typography.titleSmall),
          SizedBox(height: theme.spacing.xs),
          Text(
            description,
            style: typography.bodySmall.copyWith(color: colors.mutedForeground),
          ),
        ],
      ),
    ),
  );
}

// =============================================================================
// Sample
// =============================================================================

class _AppSample extends StatelessWidget {
  const _AppSample();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final typography = theme.typography;

    return WidgetbookPageLayout(
      title: 'Quick Start',
      description: 'Minimal VApp setup to get a themed app running in seconds.',
      children: [
        WidgetbookSection(
          title: 'Code',
          children: [
            Padding(
              padding: EdgeInsets.all(theme.spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Step 1: Wrap your app', style: typography.titleSmall),
                  SizedBox(height: theme.spacing.sm),
                  const WidgetbookCodeBlock(
                    title: 'main.dart',
                    code:
                        'void main() {\n'
                        '  runApp(\n'
                        '    VApp(home: MyHomePage()),\n'
                        '  );\n'
                        '}',
                  ),
                  SizedBox(height: theme.spacing.lg),
                  Text(
                    'With a router config (go_router and the like)',
                    style: typography.titleSmall,
                  ),
                  SizedBox(height: theme.spacing.sm),
                  const WidgetbookCodeBlock(
                    title: 'main.dart',
                    code:
                        'final router = GoRouter(routes: [...]);\n'
                        '\n'
                        'void main() {\n'
                        '  runApp(\n'
                        '    VApp.router(routerConfig: router),\n'
                        '  );\n'
                        '}',
                  ),
                  SizedBox(height: theme.spacing.lg),
                  Text('Step 2: Access tokens', style: typography.titleSmall),
                  SizedBox(height: theme.spacing.sm),
                  const WidgetbookCodeBlock(
                    title: 'my_page.dart',
                    code:
                        'Widget build(BuildContext context) {\n'
                        '  final colors = context.vColors;\n'
                        '  final spacing = context.vSpacing;\n'
                        '  return Container(\n'
                        '    color: colors.background,\n'
                        '    padding: EdgeInsets.all(spacing.md),\n'
                        '  );\n'
                        '}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
