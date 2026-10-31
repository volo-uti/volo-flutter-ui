import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

WidgetbookComponent vSelectComponent() => WidgetbookComponent(
  name: 'VSelect',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _selectPlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _SelectShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _SelectSample(),
    ),
  ],
);

Widget _selectPlayground(BuildContext context) {
  final k = context.knobs;
  final multiple = k.boolean(label: 'multiple');
  final size = k.object.dropdown<VSelectSize>(
    label: 'size',
    options: VSelectSize.values,
    initialOption: VSelectSize.md,
    labelBuilder: (v) => v.name,
  );
  final label = k.string(label: 'label', initialValue: 'Fruit');
  final placeholder = k.string(label: 'placeholder', initialValue: 'Pick one');
  final helper = k.string(label: 'helper');
  final error = k.boolean(label: 'error');
  final errorText = k.string(label: 'errorText', initialValue: 'Required');
  final success = k.boolean(label: 'success');
  final successText = k.string(
    label: 'successText',
    initialValue: 'Looks good',
  );
  final extra = k.string(label: 'extra');
  final required = k.boolean(label: 'required');
  final fullWidth = k.boolean(label: 'fullWidth');
  final enabled = k.boolean(label: 'enabled', initialValue: true);
  final readOnly = k.boolean(label: 'readOnly');
  final loading = k.boolean(label: 'loading');
  final searchable = k.boolean(label: 'searchable');
  final matchTriggerWidth = k.boolean(
    label: 'matchTriggerWidth',
    initialValue: true,
  );
  final position = k.object.dropdown<VPopoverPosition>(
    label: 'popoverPosition',
    options: VPopoverPosition.values,
    initialOption: VPopoverPosition.bottomEnd,
    labelBuilder: (v) => v.name,
  );
  final maxSelection = k.int.slider(
    label: 'maxSelection (0 = unlimited)',
    max: 5,
    divisions: 5,
  );
  var picked = k.objectOrNull.dropdown<String>(
    label: 'value',
    options: const ['apple', 'banana', 'cherry'],
    labelBuilder: (v) => v,
  );
  var pickedMany = <String>[];
  String? text(String v) => v.isEmpty ? null : v;
  const items = [
    VSelectItem(value: 'apple', label: 'Apple'),
    VSelectItem(value: 'banana', label: 'Banana'),
    VSelectItem(value: 'cherry', label: 'Cherry'),
    VSelectItem(value: 'grape', label: 'Grape', enabled: false),
    VSelectItem(value: 'lemon', label: 'Lemon'),
  ];

  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      info: [
        if (multiple) 'values: ${pickedMany.join(', ')}' else 'value: $picked',
      ],
      child: SizedBox(
        width: 320,
        child: multiple
            ? VSelect<String>.multiple(
                items: items,
                values: pickedMany,
                onValuesChanged: (v) => setState(() => pickedMany = v),
                maxSelection: maxSelection == 0 ? null : maxSelection,
                placeholder: text(placeholder),
                label: text(label),
                helper: text(helper),
                error: error,
                errorText: text(errorText),
                success: success,
                successText: text(successText),
                extra: text(extra),
                required: required,
                size: size,
                enabled: enabled,
                readOnly: readOnly,
                loading: loading,
                fullWidth: fullWidth,
                searchable: searchable,
                matchTriggerWidth: matchTriggerWidth,
                popoverPosition: position,
              )
            : VSelect<String>(
                items: items,
                value: picked,
                onChanged: (v) => setState(() => picked = v),
                placeholder: text(placeholder),
                label: text(label),
                helper: text(helper),
                error: error,
                errorText: text(errorText),
                success: success,
                successText: text(successText),
                extra: text(extra),
                required: required,
                size: size,
                enabled: enabled,
                readOnly: readOnly,
                loading: loading,
                fullWidth: fullWidth,
                searchable: searchable,
                matchTriggerWidth: matchTriggerWidth,
                popoverPosition: position,
              ),
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _SelectShowcase extends StatelessWidget {
  const _SelectShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VSelect',
    description:
        'Dropdown menu for selecting one or multiple options from a list.',
    children: [
      const WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'sm',
            labels: ['size="sm"'],
            children: [
              VSelect<String>(
                items: [
                  VSelectItem(value: 'a', label: 'Option A'),
                  VSelectItem(value: 'b', label: 'Option B'),
                ],
                placeholder: 'Small',
                size: VSelectSize.sm,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: ['size="md"'],
            children: [
              VSelect<String>(
                items: [
                  VSelectItem(value: 'a', label: 'Option A'),
                  VSelectItem(value: 'b', label: 'Option B'),
                ],
                placeholder: 'Medium',
                size: VSelectSize.md,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: ['size="lg"'],
            children: [
              VSelect<String>(
                items: [
                  VSelectItem(value: 'a', label: 'Option A'),
                  VSelectItem(value: 'b', label: 'Option B'),
                ],
                placeholder: 'Large',
                size: VSelectSize.lg,
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Selection Mode',
        children: [
          WidgetbookSubsection(
            title: 'single',
            labels: ['multiple={false}'],
            children: [_SelectDemo()],
          ),
          WidgetbookSubsection(
            title: 'multiple',
            labels: ['multiple'],
            children: [_MultipleSelectDemo()],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: ['default'],
            children: [_SelectDemo()],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: ['disabled'],
            children: [
              VSelect<String>(
                items: [
                  VSelectItem(value: 'ko', label: 'Korean'),
                  VSelectItem(value: 'en', label: 'English'),
                ],
                value: 'ko',
                placeholder: 'Disabled',
                enabled: false,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled item',
            labels: ['VSelectItem disabled'],
            children: [
              VSelect<String>(
                items: [
                  VSelectItem(value: 'a', label: 'Available'),
                  VSelectItem(value: 'b', label: 'Unavailable', enabled: false),
                ],
                placeholder: 'Has disabled item',
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'error',
            labels: ['error', 'errorText="..."'],
            children: [
              VSelect<String>(
                items: [
                  VSelectItem(value: 'ko', label: 'Korean'),
                  VSelectItem(value: 'en', label: 'English'),
                ],
                placeholder: 'Error state',
                error: true,
                errorText: 'Please select a language',
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Pre-selected Value',
        children: [
          WidgetbookSubsection(
            title: 'default value',
            labels: ['defaultValue="..."'],
            children: [
              VSelect<String>(
                items: [
                  VSelectItem(value: 'react', label: 'React'),
                  VSelectItem(value: 'vue', label: 'Vue'),
                  VSelectItem(value: 'svelte', label: 'Svelte'),
                ],
                value: 'vue',
                placeholder: 'Select framework',
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
              'Selecting from 5+ options, or when space is limited for radio buttons',
            ),
            _guidelineRow(
              theme,
              'vs Radio',
              'Use select for 5+ options. Use radio for 2-4 visible options',
            ),
            _guidelineRow(
              theme,
              'Placeholder',
              'Use descriptive placeholder like "Select a country" instead of "Select..."',
            ),
            _guidelineRow(
              theme,
              'Groups',
              'Group related options with VSelectGroup and VSelectLabel for long lists',
            ),
            _guidelineRow(
              theme,
              'Multiple',
              'Enable for multi-select scenarios (tags, filters). Show selected count',
            ),
            _guidelineRow(
              theme,
              'Disabled items',
              'Disable unavailable options rather than hiding them',
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

class _SelectSample extends StatelessWidget {
  const _SelectSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VSelect Samples',
    description: 'Copy-paste code examples for common select patterns.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Basic select',
        code: '''VSelect<String>(
  items: [
    VSelectItem(value: 'apple', label: 'Apple'),
    VSelectItem(value: 'banana', label: 'Banana'),
    VSelectItem(value: 'cherry', label: 'Cherry'),
  ],
  value: selectedFruit,
  onChanged: (value) => setState(() => selectedFruit = value),
  placeholder: 'Select a fruit',
)''',
        preview: _SelectDemo(),
      ),
      const WidgetbookCodeBlock(
        title: 'Multi-select',
        code: '''VSelect<String>.multiple(
  items: [
    VSelectItem(value: 'react', label: 'React'),
    VSelectItem(value: 'vue', label: 'Vue'),
    VSelectItem(value: 'angular', label: 'Angular'),
  ],
  values: selectedFrameworks,
  onValuesChanged: (values) => setState(() => selectedFrameworks = values),
  placeholder: 'Select frameworks',
)''',
        preview: _MultipleSelectDemo(),
      ),
      const WidgetbookCodeBlock(
        title: 'Grouped options',
        code: '''VSelect<String>(
  items: [
    VSelectItem(value: 'frontend', label: 'Frontend'),
    VSelectItem(value: 'backend', label: 'Backend'),
    VSelectItem(value: 'ui', label: 'UI Designer'),
    VSelectItem(value: 'ux', label: 'UX Researcher'),
  ],
  placeholder: 'Choose a role',
)''',
        preview: _SelectDemo(),
      ),
      const WidgetbookCodeBlock(
        title: 'Controlled select',
        code: '''VSelect<String>(
  items: [
    VSelectItem(value: 'draft', label: 'Draft'),
    VSelectItem(value: 'published', label: 'Published'),
    VSelectItem(value: 'archived', label: 'Archived'),
  ],
  value: status,
  onChanged: (value) => setState(() => status = value),
  placeholder: 'Select status',
)''',
        preview: _SelectDemo(),
      ),
      const WidgetbookCodeBlock(
        title: 'Registration Form',
        code: '''VForm(
  children: [
    VTextField(name: 'name', label: 'Name', placeholder: 'Enter your name'),
    VSelect<String>(
      items: [
        VSelectItem(value: 'us', label: 'United States'),
        VSelectItem(value: 'kr', label: 'South Korea'),
        VSelectItem(value: 'jp', label: 'Japan'),
        VSelectItem(value: 'de', label: 'Germany'),
      ],
      label: 'Country',
      placeholder: 'Select country',
      onChanged: (v) {},
    ),
    VButton(onPressed: () {}, child: Text('Register')),
  ],
)''',
        preview: _RegistrationFormDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Country selector',
        code: '''VSelect<String>(
  items: [
    VSelectItem(value: 'us', label: 'United States'),
    VSelectItem(value: 'ca', label: 'Canada'),
    VSelectItem(value: 'mx', label: 'Mexico'),
    VSelectItem(value: 'kr', label: 'South Korea'),
    VSelectItem(value: 'jp', label: 'Japan'),
    VSelectItem(value: 'cn', label: 'China'),
  ],
  label: 'Country',
  placeholder: 'Select your country',
  searchable: true,
  onChanged: (v) {},
)''',
        preview: VSelect<String>(
          items: const [
            VSelectItem(value: 'us', label: 'United States'),
            VSelectItem(value: 'ca', label: 'Canada'),
            VSelectItem(value: 'mx', label: 'Mexico'),
            VSelectItem(value: 'kr', label: 'South Korea'),
            VSelectItem(value: 'jp', label: 'Japan'),
            VSelectItem(value: 'cn', label: 'China'),
          ],
          label: 'Country',
          placeholder: 'Select your country',
          searchable: true,
          onChanged: (v) {},
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Filter dropdown',
        code: '''VSelect<String>(
  items: [
    VSelectItem(value: 'all', label: 'All'),
    VSelectItem(value: 'active', label: 'Active'),
    VSelectItem(value: 'inactive', label: 'Inactive'),
    VSelectItem(value: 'pending', label: 'Pending'),
  ],
  value: 'all',
  label: 'Status',
  placeholder: 'Filter by status',
  size: VSelectSize.sm,
  onChanged: (v) {},
)''',
        preview: VSelect<String>(
          items: const [
            VSelectItem(value: 'all', label: 'All'),
            VSelectItem(value: 'active', label: 'Active'),
            VSelectItem(value: 'inactive', label: 'Inactive'),
            VSelectItem(value: 'pending', label: 'Pending'),
          ],
          value: 'all',
          label: 'Status',
          placeholder: 'Filter by status',
          size: VSelectSize.sm,
          onChanged: (v) {},
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Grouped options',
        code: '''VSelect<String>(
  items: [
    VSelectItem(value: 'all', label: 'All', group: 'Status'),
    VSelectItem(value: 'active', label: 'Active', group: 'Status'),
    VSelectItem(value: 'pending', label: 'Pending', group: 'Status'),
    VSelectItem(value: 'archived', label: 'Archived', group: 'Status'),
  ],
  placeholder: 'Select status',
  onChanged: (v) {},
)''',
        preview: VSelect<String>(
          items: const [
            VSelectItem(value: 'all', label: 'All'),
            VSelectItem(value: 'active', label: 'Active'),
            VSelectItem(value: 'pending', label: 'Pending'),
            VSelectItem(value: 'archived', label: 'Archived'),
          ],
          placeholder: 'Select status',
          onChanged: (v) {},
        ),
      ),
    ],
  );
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _SelectDemo extends StatefulWidget {
  const _SelectDemo();

  @override
  State<_SelectDemo> createState() => _SelectDemoState();
}

class _SelectDemoState extends State<_SelectDemo> {
  String? _selected;

  @override
  Widget build(BuildContext context) => VSelect<String>(
    items: const [
      VSelectItem(value: 'ko', label: 'Korean'),
      VSelectItem(value: 'en', label: 'English'),
      VSelectItem(value: 'ja', label: 'Japanese'),
      VSelectItem(value: 'zh', label: 'Chinese'),
    ],
    value: _selected,
    onChanged: (value) => setState(() => _selected = value),
    placeholder: 'Select language',
    label: 'Language',
  );
}

class _MultipleSelectDemo extends StatefulWidget {
  const _MultipleSelectDemo();

  @override
  State<_MultipleSelectDemo> createState() => _MultipleSelectDemoState();
}

class _MultipleSelectDemoState extends State<_MultipleSelectDemo> {
  List<String> _selected = [];

  @override
  Widget build(BuildContext context) => VSelect<String>.multiple(
    items: const [
      VSelectItem(value: 'red', label: 'Red'),
      VSelectItem(value: 'green', label: 'Green'),
      VSelectItem(value: 'blue', label: 'Blue'),
      VSelectItem(value: 'yellow', label: 'Yellow'),
    ],
    values: _selected,
    onValuesChanged: (values) => setState(() => _selected = values),
    placeholder: 'Select colors',
    label: 'Colors',
  );
}

class _RegistrationFormDemo extends StatefulWidget {
  const _RegistrationFormDemo();

  @override
  State<_RegistrationFormDemo> createState() => _RegistrationFormDemoState();
}

class _RegistrationFormDemoState extends State<_RegistrationFormDemo> {
  String? _country;

  @override
  Widget build(BuildContext context) => VForm(
    children: [
      const VTextField(
        name: 'name',
        label: 'Name',
        placeholder: 'Enter your name',
      ),
      VSelect<String>(
        items: const [
          VSelectItem(value: 'us', label: 'United States'),
          VSelectItem(value: 'kr', label: 'South Korea'),
          VSelectItem(value: 'jp', label: 'Japan'),
          VSelectItem(value: 'de', label: 'Germany'),
        ],
        value: _country,
        onChanged: (value) => setState(() => _country = value),
        label: 'Country',
        placeholder: 'Select country',
      ),
      VButton(onPressed: () {}, child: const Text('Register')),
    ],
  );
}
