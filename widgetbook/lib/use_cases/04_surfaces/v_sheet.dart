import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _SheetVariant { bottom, side }

WidgetbookComponent vSheetComponent() => WidgetbookComponent(
  name: 'VSheet',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _sheetPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _SheetShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _SheetSample(),
    ),
  ],
);

Widget _sheetPlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_SheetVariant>(
    label: 'variant',
    options: _SheetVariant.values,
    labelBuilder: (v) => v.name,
  );
  final side = k.object.dropdown<VSheetSide>(
    label: 'side',
    options: VSheetSide.values,
    labelBuilder: (v) => v.name,
  );
  final width = k.double.slider(
    label: 'width',
    initialValue: 280,
    min: 200,
    max: 480,
  );
  final title = k.string(label: 'title', initialValue: 'Sheet Title');
  final showHandle = k.boolean(label: 'showHandle', initialValue: true);
  final initialSize = k.double.slider(
    label: 'initialSize',
    initialValue: 0.5,
    min: 0.1,
    max: 1,
  );
  final minSize = k.double.slider(
    label: 'minSize',
    initialValue: 0.25,
    min: 0.1,
    max: 1,
  );
  final maxSize = k.double.slider(
    label: 'maxSize',
    initialValue: 0.9,
    min: 0.1,
    max: 1,
  );
  final barrierDismissible = k.boolean(
    label: 'barrierDismissible',
    initialValue: true,
  );

  return WidgetbookPlayground(
    child: VButton(
      onPressed: () {
        switch (variant) {
          case _SheetVariant.bottom:
            unawaited(
              VBottomSheet.show<void>(
                context,
                title: title.isEmpty ? null : Text(title),
                showHandle: showHandle,
                initialSize: initialSize,
                minSize: minSize,
                maxSize: maxSize,
                barrierDismissible: barrierDismissible,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Bottom sheet content'),
                ),
              ),
            );
          case _SheetVariant.side:
            unawaited(
              VSideSheet.show<void>(
                context,
                side: side,
                width: width,
                barrierDismissible: barrierDismissible,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Side sheet content'),
                ),
              ),
            );
        }
      },
      child: Text(
        variant == _SheetVariant.bottom ? 'Bottom Sheet' : 'Side Sheet',
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _SheetShowcase extends StatelessWidget {
  const _SheetShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VSheet',
    description:
        'A generic surface container with minimal styling, more lightweight than VCard.',
    children: [
      WidgetbookSection(
        title: 'Variants',
        children: [
          WidgetbookSubsection(
            title: 'filled',
            labels: const ['variant="filled"'],
            children: [
              Builder(
                builder: (ctx) {
                  final theme = VTheme.of(ctx);
                  return VButton(
                    onPressed: () {
                      unawaited(
                        VBottomSheet.show<void>(
                          ctx,
                          title: const Text('Select Option'),
                          child: DefaultTextStyle(
                            style: theme.typography.bodyMedium.copyWith(
                              color: theme.colors.foreground,
                              decoration: TextDecoration.none,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: VStack.vertical(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: 12,
                                children: [
                                  VListTile(
                                    leading: const Icon(
                                      IconData(
                                        0xe413,
                                        fontFamily: 'MaterialIcons',
                                      ),
                                    ),
                                    title: const Text('Take Photo'),
                                    onTap: () => VBottomSheet.close<void>(ctx),
                                  ),
                                  VListTile(
                                    leading: const Icon(
                                      IconData(
                                        0xe3f4,
                                        fontFamily: 'MaterialIcons',
                                      ),
                                    ),
                                    title: const Text('Choose from Gallery'),
                                    onTap: () => VBottomSheet.close<void>(ctx),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('Bottom Sheet'),
                  );
                },
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'outlined',
            labels: const ['variant="outlined"'],
            children: [
              Builder(
                builder: (ctx) {
                  final theme = VTheme.of(ctx);
                  return VButton(
                    onPressed: () {
                      unawaited(
                        VSideSheet.show<void>(
                          ctx,
                          side: VSheetSide.right,
                          width: 320,
                          child: DefaultTextStyle(
                            style: theme.typography.bodyMedium.copyWith(
                              color: theme.colors.foreground,
                              decoration: TextDecoration.none,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: VStack.vertical(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 16,
                                children: [
                                  Text(
                                    'Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'This is a side sheet sliding in from the right.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('Side Sheet'),
                  );
                },
              ),
            ],
          ),
        ],
      ),

      WidgetbookSection(
        title: 'All Variants Comparison',
        children: [
          WidgetbookSubsection(
            title: 'side by side',
            labels: const ['filled', 'outlined'],
            children: [
              Builder(
                builder: (ctx) {
                  final theme = VTheme.of(ctx);
                  return VButton(
                    onPressed: () {
                      unawaited(
                        VBottomSheet.show<void>(
                          ctx,
                          title: const Text('Filled (Bottom Sheet)'),
                          child: DefaultTextStyle(
                            style: theme.typography.bodyMedium.copyWith(
                              color: theme.colors.foreground,
                              decoration: TextDecoration.none,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('Bottom sheet content'),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('Bottom Sheet'),
                  );
                },
              ),
              Builder(
                builder: (ctx) {
                  final theme = VTheme.of(ctx);
                  return VButton.outlined(
                    onPressed: () {
                      unawaited(
                        VSideSheet.show<void>(
                          ctx,
                          child: DefaultTextStyle(
                            style: theme.typography.bodyMedium.copyWith(
                              color: theme.colors.foreground,
                              decoration: TextDecoration.none,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: VStack.vertical(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 16,
                                children: [
                                  Text(
                                    'Menu',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  VListTile(title: Text('Home')),
                                  VListTile(title: Text('Profile')),
                                  VListTile(title: Text('Settings')),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('Side Sheet'),
                  );
                },
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
              'Lightweight background container for layout sections',
            ),
            _guidelineRow(
              theme,
              'Filled',
              'Use for subtle background grouping without strong borders',
            ),
            _guidelineRow(
              theme,
              'Outlined',
              'Use for visually distinct sections with border separation',
            ),
            _guidelineRow(
              theme,
              'vs VCard',
              'Prefer VSheet for layout wrappers; VCard for content cards',
            ),
            _guidelineRow(
              theme,
              'Polymorphic',
              'Use as="section" or as="aside" for semantic HTML',
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

class _SheetSample extends StatelessWidget {
  const _SheetSample();

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final defaultTextStyle = theme.typography.bodyMedium.copyWith(
      color: theme.colors.foreground,
      decoration: TextDecoration.none,
    );

    return WidgetbookPageLayout(
      title: 'VSheet Samples',
      description: 'Copy-paste code examples for common sheet patterns.',
      children: [
        WidgetbookCodeBlock(
          title: 'Basic usage',
          code: '''VBottomSheet.show(
  context,
  title: const Text('Options'),
  child: Column(
    children: [
      VListTile(title: Text('Option 1')),
      VListTile(title: Text('Option 2')),
    ],
  ),
);''',
          preview: VButton(
            onPressed: () {
              unawaited(
                VBottomSheet.show<void>(
                  context,
                  title: const Text('Options'),
                  child: DefaultTextStyle(
                    style: defaultTextStyle,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Bottom sheet content'),
                    ),
                  ),
                ),
              );
            },
            child: const Text('Show'),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Outlined sheet',
          code: '''VSideSheet.show(
  context,
  side: VSheetSide.left,
  child: Column(children: [...]),
);''',
          preview: VButton(
            onPressed: () {
              unawaited(
                VSideSheet.show<void>(
                  context,
                  child: DefaultTextStyle(
                    style: defaultTextStyle,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Side sheet content'),
                    ),
                  ),
                ),
              );
            },
            child: const Text('Show'),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Nested sheets',
          code: '''VBottomSheet.show(
  context,
  title: const Text('Outer Sheet'),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Inner content'),
  ),
);''',
          preview: VButton(
            onPressed: () {
              unawaited(
                VBottomSheet.show<void>(
                  context,
                  title: const Text('Outer Sheet'),
                  child: DefaultTextStyle(
                    style: defaultTextStyle,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Inner content'),
                    ),
                  ),
                ),
              );
            },
            child: const Text('Show'),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Polymorphic sheet',
          code: '''VSideSheet.show(
  context,
  side: VSheetSide.right,
  child: Text('Renders as side sheet.'),
);''',
          preview: VButton(
            onPressed: () {
              unawaited(
                VSideSheet.show<void>(
                  context,
                  side: VSheetSide.right,
                  child: DefaultTextStyle(
                    style: defaultTextStyle,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Renders as side sheet.'),
                    ),
                  ),
                ),
              );
            },
            child: const Text('Show'),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Page container',
          code: '''VBottomSheet.show(
  context,
  title: const Text('Page Options'),
  initialSize: 0.7,
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Select an action for this page.'),
        SizedBox(height: 16),
        VButton(onPressed: () {}, child: Text('Share')),
        SizedBox(height: 8),
        VButton.outlined(onPressed: () {}, child: Text('Print')),
      ],
    ),
  ),
);''',
          preview: VButton(
            onPressed: () {
              unawaited(
                VBottomSheet.show<void>(
                  context,
                  title: const Text('Page Options'),
                  initialSize: 0.7,
                  child: DefaultTextStyle(
                    style: defaultTextStyle,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Select an action for this page.'),
                          const SizedBox(height: 16),
                          VButton(
                            onPressed: () => VBottomSheet.close<void>(context),
                            child: const Text('Share'),
                          ),
                          const SizedBox(height: 8),
                          VButton.outlined(
                            onPressed: () => VBottomSheet.close<void>(context),
                            child: const Text('Print'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            child: const Text('Show'),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Sidebar panel',
          code: '''VSideSheet.show(
  context,
  side: VSheetSide.left,
  width: 280,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.all(16),
        child: Text('Navigation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      VListTile(title: Text('Dashboard'), onTap: () {}),
      VListTile(title: Text('Projects'), onTap: () {}),
      VListTile(title: Text('Settings'), onTap: () {}),
    ],
  ),
);''',
          preview: VButton(
            onPressed: () {
              unawaited(
                VSideSheet.show<void>(
                  context,
                  child: DefaultTextStyle(
                    style: defaultTextStyle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Navigation',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        VListTile(
                          title: const Text('Dashboard'),
                          onTap: () => VSideSheet.close<void>(context),
                        ),
                        VListTile(
                          title: const Text('Projects'),
                          onTap: () => VSideSheet.close<void>(context),
                        ),
                        VListTile(
                          title: const Text('Settings'),
                          onTap: () => VSideSheet.close<void>(context),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: const Text('Show'),
          ),
        ),
        WidgetbookCodeBlock(
          title: 'Bottom sheet',
          code: '''VBottomSheet.show(
  context,
  child: Padding(
    padding: EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Share', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        VListTile(title: Text('Copy link'), onTap: () {}),
        VListTile(title: Text('Share via email'), onTap: () {}),
        VListTile(title: Text('Share via message'), onTap: () {}),
      ],
    ),
  ),
);''',
          preview: VButton(
            onPressed: () {
              unawaited(
                VBottomSheet.show<void>(
                  context,
                  child: DefaultTextStyle(
                    style: defaultTextStyle,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Share',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          VListTile(
                            title: const Text('Copy link'),
                            onTap: () => VBottomSheet.close<void>(context),
                          ),
                          VListTile(
                            title: const Text('Share via email'),
                            onTap: () => VBottomSheet.close<void>(context),
                          ),
                          VListTile(
                            title: const Text('Share via message'),
                            onTap: () => VBottomSheet.close<void>(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            child: const Text('Show'),
          ),
        ),
      ],
    );
  }
}
