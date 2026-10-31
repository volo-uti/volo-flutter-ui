import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vStackComponent() => WidgetbookComponent(
  name: 'VStack',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _stackPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _StackShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _StackSample(),
    ),
  ],
);

Widget _stackPlayground(BuildContext context) {
  final k = context.knobs;
  final direction = k.object.dropdown<Axis>(
    label: 'direction',
    options: Axis.values,
    initialOption: Axis.vertical,
    labelBuilder: (v) => v.name,
  );
  final spacing = k.double.slider(label: 'spacing', initialValue: 8, max: 48);
  final mainAxisAlignment = k.object.dropdown<MainAxisAlignment>(
    label: 'mainAxisAlignment',
    options: MainAxisAlignment.values,
    initialOption: MainAxisAlignment.start,
    labelBuilder: (v) => v.name,
  );
  final crossAxisAlignment = k.object.dropdown<CrossAxisAlignment>(
    label: 'crossAxisAlignment',
    options: CrossAxisAlignment.values,
    initialOption: CrossAxisAlignment.center,
    labelBuilder: (v) => v.name,
  );
  final mainAxisSize = k.object.dropdown<MainAxisSize>(
    label: 'mainAxisSize',
    options: MainAxisSize.values,
    initialOption: MainAxisSize.max,
    labelBuilder: (v) => v.name,
  );
  final verticalDirection = k.object.dropdown<VerticalDirection>(
    label: 'verticalDirection',
    options: VerticalDirection.values,
    initialOption: VerticalDirection.down,
    labelBuilder: (v) => v.name,
  );
  final textDirection = k.objectOrNull.dropdown<TextDirection>(
    label: 'textDirection',
    options: TextDirection.values,
    labelBuilder: (v) => v.name,
  );

  const children = [
    VBox.card(padding: EdgeInsets.all(8), child: Text('Item 1')),
    VBox.card(padding: EdgeInsets.all(8), child: Text('Item 2')),
    VBox.card(padding: EdgeInsets.all(8), child: Text('Item 3')),
  ];

  final stack = switch (direction) {
    Axis.horizontal => VStack.horizontal(
      spacing: spacing,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      children: children,
    ),
    Axis.vertical => VStack.vertical(
      spacing: spacing,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      children: children,
    ),
  };

  return WidgetbookPlayground(
    layout: PlaygroundLayout.stretch,
    child: SizedBox(height: 240, child: stack),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _StackShowcase extends StatelessWidget {
  const _StackShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VStack',
    description:
        'Arranges children in a vertical or horizontal stack with configurable spacing.',
    children: [
      const WidgetbookSection(
        title: 'Direction',
        children: [
          WidgetbookSubsection(
            title: 'vertical',
            labels: ['VStack.vertical()'],
            children: [
              VStack.vertical(
                spacing: 8,
                children: [
                  VBox.card(
                    padding: EdgeInsets.all(12),
                    child: Text('Vertical 1'),
                  ),
                  VBox.card(
                    padding: EdgeInsets.all(12),
                    child: Text('Vertical 2'),
                  ),
                  VBox.card(
                    padding: EdgeInsets.all(12),
                    child: Text('Vertical 3'),
                  ),
                ],
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'horizontal',
            labels: ['VStack.horizontal()'],
            children: [
              VStack.horizontal(
                spacing: 8,
                children: [
                  VBox.card(padding: EdgeInsets.all(12), child: Text('A')),
                  VBox.card(padding: EdgeInsets.all(12), child: Text('B')),
                  VBox.card(padding: EdgeInsets.all(12), child: Text('C')),
                ],
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Alignment',
        children: [
          WidgetbookSubsection(
            title: 'crossAxisAlignment',
            labels: ['center'],
            children: [
              VStack.vertical(
                spacing: 8,
                children: [Text('Center'), Text('Aligned'), Text('Text')],
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Nested',
        children: [
          WidgetbookSubsection(
            title: 'nested stacks',
            labels: ['2x2 grid'],
            children: [
              VStack.vertical(
                spacing: 16,
                children: [
                  VStack.horizontal(
                    spacing: 8,
                    children: [
                      VBox.card(padding: EdgeInsets.all(12), child: Text('1')),
                      VBox.card(padding: EdgeInsets.all(12), child: Text('2')),
                    ],
                  ),
                  VStack.horizontal(
                    spacing: 8,
                    children: [
                      VBox.card(padding: EdgeInsets.all(12), child: Text('3')),
                      VBox.card(padding: EdgeInsets.all(12), child: Text('4')),
                    ],
                  ),
                ],
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
              'Use to arrange child widgets in a line',
            ),
            _guidelineRow(
              theme,
              'vertical',
              'Vertical arrangement (VStack.vertical)',
            ),
            _guidelineRow(
              theme,
              'horizontal',
              'Horizontal arrangement (VStack.horizontal)',
            ),
            _guidelineRow(
              theme,
              'spacing',
              'Set spacing between children via the spacing property',
            ),
            _guidelineRow(
              theme,
              'mainAxis',
              'Set main axis alignment with mainAxisAlignment',
            ),
            _guidelineRow(
              theme,
              'crossAxis',
              'Set cross axis alignment with crossAxisAlignment',
            ),
            _guidelineRow(
              theme,
              'Nested',
              'Nest stacks to create grid layouts',
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

class _StackSample extends StatelessWidget {
  const _StackSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VStack Samples',
    description: 'Copy-ready code examples.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Vertical',
        code: '''VStack.vertical(
  spacing: 8,
  children: [
    Text('Item 1'),
    Text('Item 2'),
    Text('Item 3'),
  ],
)''',
        preview: VStack.vertical(
          spacing: 8,
          children: [Text('Item 1'), Text('Item 2'), Text('Item 3')],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Horizontal',
        code: '''VStack.horizontal(
  spacing: 8,
  children: [
    VBox.card(child: Text('A')),
    VBox.card(child: Text('B')),
    VBox.card(child: Text('C')),
  ],
)''',
        preview: VStack.horizontal(
          spacing: 8,
          children: [
            VBox.card(padding: EdgeInsets.all(12), child: Text('A')),
            VBox.card(padding: EdgeInsets.all(12), child: Text('B')),
            VBox.card(padding: EdgeInsets.all(12), child: Text('C')),
          ],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Alignment Settings',
        code: '''VStack.vertical(
  spacing: 8,
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.center,
  children: [...],
)''',
        preview: SizedBox(
          height: 80,
          child: VStack.vertical(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Center'), Text('Aligned')],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Form layout',
        code: '''VStack.vertical(
  spacing: 12,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    VTextField(name: 'name', placeholder: 'Enter your name'),
    VTextField(name: 'email', placeholder: 'Enter your email'),
    VTextField(name: 'password', placeholder: 'Enter password'),
    SizedBox(height: 4),
    VButton(onPressed: () {}, child: Text('Submit')),
  ],
)''',
        preview: SizedBox(
          width: 280,
          child: VStack.vertical(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VTextField(name: 'name', placeholder: 'Enter your name'),
              const VTextField(name: 'email', placeholder: 'Enter your email'),
              const SizedBox(height: 4),
              VButton(onPressed: () {}, child: const Text('Submit')),
            ],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Button row',
        code: '''VStack.horizontal(
  spacing: 8,
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    VButton.ghost(onPressed: () {}, child: Text('Cancel')),
    VButton.outlined(onPressed: () {}, child: Text('Delete')),
    VButton(onPressed: () {}, child: Text('Save')),
  ],
)''',
        preview: VStack.horizontal(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            VButton.ghost(onPressed: () {}, child: const Text('Cancel')),
            VButton.outlined(onPressed: () {}, child: const Text('Delete')),
            VButton(onPressed: () {}, child: const Text('Save')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Vertical form layout',
        code: '''VStack.vertical(
  spacing: 16,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    VTextField(label: 'Name', placeholder: 'Enter name'),
    VTextField(label: 'Email', placeholder: 'Enter email'),
    VButton(onPressed: () {}, fullWidth: true, child: Text('Submit')),
  ],
)''',
        preview: SizedBox(
          width: 280,
          child: VStack.vertical(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Name: ___'),
              const Text('Email: ___'),
              VButton(
                onPressed: () {},
                fullWidth: true,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
