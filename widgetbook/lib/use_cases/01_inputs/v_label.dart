import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vLabelComponent() => WidgetbookComponent(
  name: 'VLabel',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _labelPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _LabelShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _LabelSample(),
    ),
  ],
);

Widget _labelPlayground(BuildContext context) {
  final k = context.knobs;
  final text = k.string(label: 'child', initialValue: 'Email address');
  final size = k.object.dropdown<VLabelSize>(
    label: 'size',
    options: VLabelSize.values,
    initialOption: VLabelSize.md,
    labelBuilder: (v) => v.name,
  );
  final required = k.boolean(label: 'required');
  final requiredMark = k.string(label: 'requiredMark', initialValue: '*');

  return WidgetbookPlayground(
    child: VLabel(
      required: required,
      size: size,
      requiredMark: requiredMark,
      child: Text(text),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _LabelShowcase extends StatelessWidget {
  const _LabelShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VLabel',
    description:
        'Label element for form inputs, providing accessible text identification.',
    children: [
      const WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'sm',
            labels: ['size="sm"'],
            children: [VLabel(size: VLabelSize.sm, child: Text('Small Label'))],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: ['size="md"'],
            children: [VLabel(child: Text('Medium Label'))],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: ['size="lg"'],
            children: [VLabel(size: VLabelSize.lg, child: Text('Large Label'))],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Required',
        children: [
          WidgetbookSubsection(
            title: 'optional',
            labels: ['required={false}'],
            children: [VLabel(child: Text('Username'))],
          ),
          WidgetbookSubsection(
            title: 'required',
            labels: ['required'],
            children: [VLabel(required: true, child: Text('Email'))],
          ),
        ],
      ),

      // Usage Guidelines
      WidgetbookSection(
        title: 'Usage Guidelines',
        children: [_UsageGuidelinesTable()],
      ),
    ],
  );
}

class _UsageGuidelinesTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    return Table(
      columnWidths: const {0: FixedColumnWidth(160), 1: FlexColumnWidth()},
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: theme.colors.muted,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          children: [
            _tableHeader(theme, 'Category'),
            _tableHeader(theme, 'Guideline'),
          ],
        ),
        _guidelineRow(
          theme,
          'When to use',
          'Every form input needs a label for accessibility. Use VLabel or VFormField',
        ),
        _guidelineRow(
          theme,
          'Required',
          'Add required prop to show an asterisk indicator for mandatory fields',
        ),
        _guidelineRow(
          theme,
          'vs VFormField',
          'Use VLabel for standalone labels. Use VFormField for label + helper + error',
        ),
        _guidelineRow(
          theme,
          'Content',
          'Keep labels short and descriptive. Use sentence case ("Email address")',
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

class _LabelSample extends StatelessWidget {
  const _LabelSample();

  @override
  Widget build(BuildContext context) => const WidgetbookPageLayout(
    title: 'VLabel Samples',
    description: 'Copy-paste code examples for VLabel.',
    children: [
      WidgetbookCodeBlock(
        title: 'Basic label',
        code: "VLabel(child: Text('Username'))",
        preview: VLabel(child: Text('Username')),
      ),
      WidgetbookCodeBlock(
        title: 'Required indicator',
        code: "VLabel(child: Text('Email'), required: true)",
        preview: VLabel(required: true, child: Text('Email')),
      ),
      WidgetbookCodeBlock(
        title: 'Size comparison',
        code: '''Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    VLabel(child: Text('Small'), size: VLabelSize.sm),
    VLabel(child: Text('Medium'), size: VLabelSize.md),
    VLabel(child: Text('Large'), size: VLabelSize.lg),
  ],
)''',
        preview: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VLabel(size: VLabelSize.sm, child: Text('Small')),
            VLabel(child: Text('Medium')),
            VLabel(size: VLabelSize.lg, child: Text('Large')),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Label with TextField',
        code: '''Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    VLabel(child: Text('Full Name'), required: true),
    SizedBox(height: 4),
    VTextField(
      name: 'fullName',
      placeholder: 'Enter your full name',
    ),
  ],
)''',
        preview: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VLabel(required: true, child: Text('Full Name')),
            SizedBox(height: 4),
            VTextField(name: 'fullName', placeholder: 'Enter your full name'),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Form field label',
        code: '''Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    VLabel(child: Text('Email Address')),
    SizedBox(height: 4),
    VTextField(
      name: 'email',
      placeholder: 'name@example.com',
    ),
  ],
)''',
        preview: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VLabel(child: Text('Email Address')),
            SizedBox(height: 4),
            VTextField(name: 'email', placeholder: 'name@example.com'),
          ],
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Label with badge',
        code: '''VLabel(
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Notifications'),
      SizedBox(width: 8),
      VBadge(label: Text('3')),
    ],
  ),
)''',
        preview: VLabel(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Notifications'),
              SizedBox(width: 8),
              VBadge(label: Text('3')),
            ],
          ),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Required field label',
        code: '''VLabel(
  child: Text('Email address'),
  required: true,
)''',
        preview: VLabel(required: true, child: Text('Email address')),
      ),
    ],
  );
}
