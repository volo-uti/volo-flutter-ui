import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

enum _AccordionVariant { normal, separated, bordered }

WidgetbookComponent vAccordionComponent() => WidgetbookComponent(
  name: 'VAccordion',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _accordionPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _AccordionShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _AccordionSample(),
    ),
  ],
);

Widget _accordionPlayground(BuildContext context) {
  final k = context.knobs;
  final variant = k.object.dropdown<_AccordionVariant>(
    label: 'variant',
    options: _AccordionVariant.values,
    labelBuilder: (v) => v.name,
  );
  final allowMultiple = k.boolean(label: 'allowMultiple');
  final divider = k.boolean(label: 'divider', initialValue: true);
  final lastEnabled = k.boolean(label: 'item 3 enabled', initialValue: true);

  var expanded = <int>[];
  return StatefulBuilder(
    builder: (context, setState) {
      final items = [
        const VAccordionItem(
          title: Text('Section 1'),
          content: Text('Content for section 1.'),
        ),
        const VAccordionItem(
          title: Text('Section 2'),
          content: Text('Content for section 2.'),
        ),
        VAccordionItem(
          title: const Text('Section 3'),
          enabled: lastEnabled,
          content: const Text('Content for section 3.'),
        ),
      ];
      void onChanged(List<int> v) => setState(() => expanded = v);
      return WidgetbookPlayground(
        info: ['expanded: $expanded'],
        child: switch (variant) {
          _AccordionVariant.normal => VAccordion(
            allowMultiple: allowMultiple,
            divider: divider,
            onExpansionChanged: onChanged,
            children: items,
          ),
          _AccordionVariant.separated => VAccordion.separated(
            allowMultiple: allowMultiple,
            onExpansionChanged: onChanged,
            children: items,
          ),
          _AccordionVariant.bordered => VAccordion.bordered(
            allowMultiple: allowMultiple,
            divider: divider,
            onExpansionChanged: onChanged,
            children: items,
          ),
        },
      );
    },
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _AccordionShowcase extends StatelessWidget {
  const _AccordionShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VAccordion',
    description: 'Collapsible content sections built with compound components.',
    children: [
      const WidgetbookSection(
        title: 'Type',
        children: [
          WidgetbookSubsection(
            title: 'single',
            labels: ['VAccordion(type="single")'],
            children: [
              VAccordion(
                children: [
                  VAccordionItem(
                    title: Text('Section 1'),
                    content: Text('Only one section can be open at a time.'),
                  ),
                  VAccordionItem(
                    title: Text('Section 2'),
                    content: Text('Opening this section closes the other.'),
                  ),
                  VAccordionItem(
                    title: Text('Section 3'),
                    content: Text(
                      'Single mode allows one expanded item at a time.',
                    ),
                  ),
                ],
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'multiple',
            labels: ['VAccordion(type="multiple")'],
            children: [
              VAccordion(
                allowMultiple: true,
                initialExpanded: [0, 1],
                children: [
                  VAccordionItem(
                    title: Text('Section 1'),
                    content: Text(
                      'Multiple sections can be open simultaneously.',
                    ),
                  ),
                  VAccordionItem(
                    title: Text('Section 2'),
                    content: Text('This section is also open by default.'),
                  ),
                  VAccordionItem(
                    title: Text('Section 3'),
                    content: Text('Click to expand this section as well.'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      const WidgetbookSection(
        title: 'Disabled',
        children: [
          WidgetbookSubsection(
            title: 'disabled item',
            labels: ['VAccordionItem(enabled: false)'],
            children: [
              VAccordion(
                children: [
                  VAccordionItem(
                    title: Text('Enabled item'),
                    content: Text('This item works normally.'),
                  ),
                  VAccordionItem(
                    title: Text('Disabled item'),
                    enabled: false,
                    content: Text('This content is not accessible.'),
                  ),
                  VAccordionItem(
                    title: Text('Another enabled item'),
                    content: Text('This item also works normally.'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      const WidgetbookSection(
        title: 'Default Value',
        children: [
          WidgetbookSubsection(
            title: 'pre-expanded',
            labels: ['VAccordion(defaultValue="item-2")'],
            children: [
              VAccordion(
                initialExpanded: [1],
                children: [
                  VAccordionItem(
                    title: Text('First item'),
                    content: Text('This item is closed by default.'),
                  ),
                  VAccordionItem(
                    title: Text('Second item (default open)'),
                    content: Text('This item is expanded by default.'),
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
              'Show/hide sections of content like FAQs, settings panels',
            ),
            _guidelineRow(
              theme,
              'Single mode',
              'Use when only one section should be visible at a time',
            ),
            _guidelineRow(
              theme,
              'Multiple mode',
              'Use when users may need to compare content across sections',
            ),
            _guidelineRow(
              theme,
              'Disabled',
              'Disable items that are temporarily unavailable',
            ),
            _guidelineRow(
              theme,
              'Default value',
              'Pre-expand the most relevant section for the user',
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

class _AccordionSample extends StatelessWidget {
  const _AccordionSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VAccordion Samples',
    description: 'Copy-paste code examples for common accordion patterns.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Basic accordion',
        code: '''VAccordion(
  children: [
    VAccordionItem(title: Text('Section 1'), content: Text('Content 1')),
    VAccordionItem(title: Text('Section 2'), content: Text('Content 2')),
  ],
)''',
        preview: VAccordion(
          children: [
            VAccordionItem(
              title: Text('Section 1'),
              content: Text('Content 1'),
            ),
            VAccordionItem(
              title: Text('Section 2'),
              content: Text('Content 2'),
            ),
          ],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'FAQ pattern',
        code: '''VAccordion(
  children: [
    VAccordionItem(
      title: Text('What is Volo Flutter UI?'),
      content: Text('A modern design system for Flutter.'),
    ),
    VAccordionItem(
      title: Text('How do I install it?'),
      content: Text('flutter pub add volo_flutter_ui'),
    ),
  ],
)''',
        preview: VAccordion(
          children: [
            VAccordionItem(
              title: Text('What is Volo Flutter UI?'),
              content: Text('A modern design system for Flutter.'),
            ),
            VAccordionItem(
              title: Text('How do I install it?'),
              content: Text('flutter pub add volo_flutter_ui'),
            ),
          ],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Multiple mode',
        code: '''VAccordion(
  allowMultiple: true,
  initialExpanded: [0, 1],
  children: [
    VAccordionItem(title: Text('FAQ 1'), content: Text('Answer 1')),
    VAccordionItem(title: Text('FAQ 2'), content: Text('Answer 2')),
  ],
)''',
        preview: VAccordion(
          allowMultiple: true,
          initialExpanded: [0, 1],
          children: [
            VAccordionItem(title: Text('FAQ 1'), content: Text('Answer 1')),
            VAccordionItem(title: Text('FAQ 2'), content: Text('Answer 2')),
          ],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Settings accordion',
        code: '''VAccordion(
  allowMultiple: true,
  children: [
    VAccordionItem(
      title: Text('Account'),
      content: Column(
        children: [
          Text('Manage your account settings, change password, and update email.'),
        ],
      ),
    ),
    VAccordionItem(
      title: Text('Notifications'),
      content: Column(
        children: [
          Text('Configure push notifications, email alerts, and sound preferences.'),
        ],
      ),
    ),
    VAccordionItem(
      title: Text('Privacy'),
      content: Column(
        children: [
          Text('Control who can see your profile, posts, and activity status.'),
        ],
      ),
    ),
  ],
)''',
        preview: VAccordion(
          allowMultiple: true,
          children: [
            VAccordionItem(
              title: Text('Account'),
              content: Text(
                'Manage your account settings, change password, and update email.',
              ),
            ),
            VAccordionItem(
              title: Text('Notifications'),
              content: Text(
                'Configure push notifications, email alerts, and sound preferences.',
              ),
            ),
            VAccordionItem(
              title: Text('Privacy'),
              content: Text(
                'Control who can see your profile, posts, and activity status.',
              ),
            ),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Nested content',
        code: '''VAccordion(
  children: [
    VAccordionItem(
      title: Text('Shipping Address'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('John Doe'),
          Text('123 Main Street'),
          Text('New York, NY 10001'),
          SizedBox(height: 8),
          VButton.outlined(onPressed: () {}, child: Text('Edit Address')),
        ],
      ),
    ),
    VAccordionItem(
      title: Text('Payment Method'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Visa ending in 4242'),
          Text('Expires 12/2027'),
        ],
      ),
    ),
  ],
)''',
        preview: VAccordion(
          children: [
            VAccordionItem(
              title: const Text('Shipping Address'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('John Doe'),
                  const Text('123 Main Street'),
                  const Text('New York, NY 10001'),
                  const SizedBox(height: 8),
                  VButton.outlined(
                    onPressed: () {},
                    child: const Text('Edit Address'),
                  ),
                ],
              ),
            ),
            const VAccordionItem(
              title: Text('Payment Method'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Visa ending in 4242'),
                  Text('Expires 12/2027'),
                ],
              ),
            ),
          ],
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'FAQ accordion',
        code: '''VAccordion(
  children: [
    VAccordionItem(
      title: Text('How do I reset my password?'),
      content: Text('Go to Settings > Security > Reset Password.'),
    ),
    VAccordionItem(
      title: Text('How do I cancel my subscription?'),
      content: Text('Go to Settings > Billing > Cancel Plan.'),
    ),
    VAccordionItem(
      title: Text('Can I get a refund?'),
      content: Text('Refunds are available within 30 days of purchase.'),
    ),
  ],
)''',
        preview: VAccordion(
          children: [
            VAccordionItem(
              title: Text('How do I reset my password?'),
              content: Text('Go to Settings > Security > Reset Password.'),
            ),
            VAccordionItem(
              title: Text('How do I cancel my subscription?'),
              content: Text('Go to Settings > Billing > Cancel Plan.'),
            ),
            VAccordionItem(
              title: Text('Can I get a refund?'),
              content: Text(
                'Refunds are available within 30 days of purchase.',
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
