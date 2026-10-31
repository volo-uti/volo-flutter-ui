import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../../src/components/widgetbook_components.dart';

// =============================================================================
// Playground
// =============================================================================

/// VAutocomplete default option data (for JSON editing).
WidgetbookComponent vAutocompleteComponent() => WidgetbookComponent(
  name: 'VAutocomplete',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _autocompletePlayground),
    WidgetbookUseCase(
      name: 'Showcase',
      builder: (context) => const _AutocompleteShowcase(),
    ),
    WidgetbookUseCase(
      name: 'Sample',
      builder: (context) => const _AutocompleteSample(),
    ),
  ],
);

Widget _autocompletePlayground(BuildContext context) {
  final k = context.knobs;
  final multiple = k.boolean(label: 'multiple');
  final size = k.object.dropdown<VAutocompleteSize>(
    label: 'size',
    options: VAutocompleteSize.values,
    initialOption: VAutocompleteSize.md,
    labelBuilder: (v) => v.name,
  );
  final label = k.string(label: 'label', initialValue: 'Fruit');
  final placeholder = k.string(
    label: 'placeholder',
    initialValue: 'Search fruits...',
  );
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
  final allowCustomValue = k.boolean(label: 'allowCustomValue');
  final maxSelection = k.int.slider(
    label: 'maxSelection (0 = unlimited)',
    max: 5,
    divisions: 5,
  );
  var picked = k.objectOrNull.dropdown<String>(
    label: 'value',
    options: [for (final item in _sampleItems) item.value],
    labelBuilder: (v) => v,
  );
  var pickedMany = <String>[];
  String? text(String v) => v.isEmpty ? null : v;

  return StatefulBuilder(
    builder: (context, setState) => WidgetbookPlayground(
      info: [
        if (multiple) 'values: ${pickedMany.join(', ')}' else 'value: $picked',
      ],
      child: SizedBox(
        width: 360,
        child: multiple
            ? VAutocomplete<String>.multiple(
                items: _sampleItems,
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
                allowCustomValue: allowCustomValue,
              )
            : VAutocomplete<String>(
                items: _sampleItems,
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
                allowCustomValue: allowCustomValue,
              ),
      ),
    ),
  );
}

// =============================================================================
// Showcase
// =============================================================================

class _AutocompleteShowcase extends StatelessWidget {
  const _AutocompleteShowcase();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VAutocomplete',
    description:
        'Text input with filtered dropdown suggestions for selecting from a list of options.',
    children: [
      WidgetbookSection(
        title: 'Sizes',
        children: [
          WidgetbookSubsection(
            title: 'sm',
            labels: const ['size="sm"'],
            children: [
              VAutocomplete<String>(
                items: _sampleItems,
                size: VAutocompleteSize.sm,
                placeholder: 'Small',
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'md',
            labels: const ['size="md"'],
            children: [
              VAutocomplete<String>(
                items: _sampleItems,
                size: VAutocompleteSize.md,
                placeholder: 'Medium',
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'lg',
            labels: const ['size="lg"'],
            children: [
              VAutocomplete<String>(
                items: _sampleItems,
                size: VAutocompleteSize.lg,
                placeholder: 'Large',
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Label & Helper Text',
        children: [
          WidgetbookSubsection(
            title: 'placeholder only',
            labels: const ['placeholder'],
            children: [
              VAutocomplete<String>(
                items: _sampleItems,
                placeholder: 'Search fruits',
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'label',
            labels: const ['label="..."'],
            children: [
              VAutocomplete<String>(
                items: _sampleItems,
                label: 'Fruit',
                placeholder: 'Search fruits...',
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'helper text',
            labels: const ['helperText="..."'],
            children: [
              VAutocomplete<String>(
                items: _sampleItems,
                label: 'Fruit',
                placeholder: 'Search fruits...',
                helper: 'Type to filter options',
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'empty text',
            labels: const ['emptyText="..."'],
            children: [
              VAutocomplete<String>(
                items: _sampleItems,
                label: 'Fruit',
                placeholder: 'Search...',
                emptyBuilder: (query) => const Text('No matching fruits found'),
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'States',
        children: [
          WidgetbookSubsection(
            title: 'default',
            labels: const ['default'],
            children: [
              VAutocomplete<String>(
                items: _sampleItems,
                label: 'Fruit',
                placeholder: 'Search fruits...',
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'disabled',
            labels: const ['disabled'],
            children: [
              VAutocomplete<String>(
                items: _sampleItems,
                label: 'Fruit',
                placeholder: 'Search fruits...',
                enabled: false,
              ),
            ],
          ),
          WidgetbookSubsection(
            title: 'error',
            labels: const ['error', 'errorText="..."'],
            children: [
              VAutocomplete<String>(
                items: _sampleItems,
                label: 'Fruit',
                placeholder: 'Search fruits...',
                error: true,
                errorText: 'Please select a valid option',
              ),
            ],
          ),
        ],
      ),
      const WidgetbookSection(
        title: 'Disabled Options',
        children: [
          WidgetbookSubsection(
            title: 'some disabled',
            labels: ['option.disabled'],
            children: [
              VAutocomplete<String>(
                items: [
                  VAutocompleteItem(value: 'apple', label: 'Apple'),
                  VAutocompleteItem(
                    value: 'banana',
                    label: 'Banana',
                    enabled: false,
                  ),
                  VAutocompleteItem(value: 'cherry', label: 'Cherry'),
                  VAutocompleteItem(
                    value: 'grape',
                    label: 'Grape',
                    enabled: false,
                  ),
                  VAutocompleteItem(value: 'mango', label: 'Mango'),
                ],
                label: 'Fruit',
                placeholder: 'Some options disabled',
              ),
            ],
          ),
        ],
      ),
      WidgetbookSection(
        title: 'Full Width',
        children: [
          WidgetbookSubsection(
            title: 'full width',
            labels: const ['fullWidth'],
            children: [
              VAutocomplete<String>(
                items: _sampleItems,
                fullWidth: true,
                placeholder: 'Full width autocomplete',
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
              'Large option lists (10+) where users benefit from type-to-filter search',
            ),
            _guidelineRow(
              theme,
              'vs Select',
              'Use autocomplete when the list is long or users know what they want to search',
            ),
            _guidelineRow(
              theme,
              'Options',
              'Provide VOption[] with value and label. Use disabled for unavailable items',
            ),
            _guidelineRow(
              theme,
              'Empty state',
              'Set emptyBuilder for when no options match the query ("No results found")',
            ),
            _guidelineRow(
              theme,
              'Custom filter',
              'Use filterFn for custom matching logic (e.g., fuzzy search, multi-field)',
            ),
            _guidelineRow(
              theme,
              'Validation',
              'Show error when user submits without selecting or selects an invalid option',
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

class _AutocompleteSample extends StatelessWidget {
  const _AutocompleteSample();

  @override
  Widget build(BuildContext context) => WidgetbookPageLayout(
    title: 'VAutocomplete Samples',
    description: 'Copy-paste code examples for common autocomplete patterns.',
    children: [
      const WidgetbookCodeBlock(
        title: 'Basic autocomplete',
        code: '''VAutocomplete<String>(
  items: [
    VAutocompleteItem(value: 'apple', label: 'Apple'),
    VAutocompleteItem(value: 'banana', label: 'Banana'),
    VAutocompleteItem(value: 'cherry', label: 'Cherry'),
  ],
  placeholder: 'Search fruits...',
)''',
        preview: _SingleSelectionDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'With label and helper text',
        code: '''VAutocomplete<String>(
  items: fruitItems,
  label: 'Fruit',
  placeholder: 'Search...',
  helper: 'Type to filter options',
)''',
        preview: VAutocomplete<String>(
          items: _sampleItems,
          label: 'Fruit',
          placeholder: 'Search...',
          helper: 'Type to filter options',
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Error state',
        code: '''VAutocomplete<String>(
  items: fruitItems,
  label: 'Fruit',
  error: true,
  errorText: 'Please select a valid option',
)''',
        preview: VAutocomplete<String>(
          items: _sampleItems,
          label: 'Fruit',
          error: true,
          errorText: 'Please select a valid option',
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Custom empty text',
        code: '''VAutocomplete<String>(
  items: fruitItems,
  placeholder: 'Search...',
  emptyBuilder: (query) => Text('No matching items found'),
)''',
        preview: VAutocomplete<String>(
          items: _sampleItems,
          placeholder: 'Search...',
          emptyBuilder: (query) => const Text('No matching items found'),
        ),
      ),
      WidgetbookCodeBlock(
        title: 'Full width',
        code: '''VAutocomplete<String>(
  items: fruitItems,
  fullWidth: true,
  placeholder: 'Full width search',
)''',
        preview: VAutocomplete<String>(
          items: _sampleItems,
          fullWidth: true,
          placeholder: 'Full width search',
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'With disabled options',
        code: '''VAutocomplete<String>(
  items: [
    VAutocompleteItem(value: 'apple', label: 'Apple'),
    VAutocompleteItem(value: 'banana', label: 'Banana', enabled: false),
    VAutocompleteItem(value: 'cherry', label: 'Cherry'),
  ],
  placeholder: 'Some options disabled',
)''',
        preview: VAutocomplete<String>(
          items: [
            VAutocompleteItem(value: 'apple', label: 'Apple'),
            VAutocompleteItem(value: 'banana', label: 'Banana', enabled: false),
            VAutocompleteItem(value: 'cherry', label: 'Cherry'),
          ],
          placeholder: 'Some options disabled',
        ),
      ),
      const WidgetbookCodeBlock(
        title: 'Search Form',
        code: '''VForm(
  children: [
    VTextField(name: 'keyword', label: 'Keyword', placeholder: 'Enter keyword'),
    VAutocomplete<String>(
      items: [
        VAutocompleteItem(value: 'flutter', label: 'Flutter'),
        VAutocompleteItem(value: 'dart', label: 'Dart'),
        VAutocompleteItem(value: 'react', label: 'React'),
        VAutocompleteItem(value: 'vue', label: 'Vue'),
      ],
      label: 'Category',
      placeholder: 'Search category...',
      onChanged: (v) {},
    ),
    VButton(onPressed: () {}, child: Text('Search')),
  ],
)''',
        preview: _SearchFormDemo(),
      ),
      WidgetbookCodeBlock(
        title: 'Async search with loading',
        code: '''VAutocomplete<String>(
  items: _results,
  loading: _isSearching,
  placeholder: 'Search users...',
  label: 'Assignee',
  onSearchChanged: (query) async {
    setState(() => _isSearching = true);
    final results = await api.searchUsers(query);
    setState(() {
      _results = results;
      _isSearching = false;
    });
  },
  minSearchLength: 2,
  debounceMs: 500,
)''',
        preview: VAutocomplete<String>(
          items: _sampleItems,
          loading: true,
          placeholder: 'Search users...',
          label: 'Assignee',
        ),
      ),
    ],
  );
}

// =============================================================================
// Helper Data
// =============================================================================

final _sampleItems = [
  const VAutocompleteItem(value: 'apple', label: 'Apple'),
  const VAutocompleteItem(value: 'banana', label: 'Banana'),
  const VAutocompleteItem(value: 'cherry', label: 'Cherry'),
  const VAutocompleteItem(value: 'grape', label: 'Grape'),
  const VAutocompleteItem(value: 'lemon', label: 'Lemon'),
  const VAutocompleteItem(value: 'mango', label: 'Mango'),
  const VAutocompleteItem(value: 'orange', label: 'Orange'),
  const VAutocompleteItem(value: 'peach', label: 'Peach'),
  const VAutocompleteItem(value: 'strawberry', label: 'Strawberry'),
  const VAutocompleteItem(value: 'watermelon', label: 'Watermelon'),
];

// =============================================================================
// Helper Widgets
// =============================================================================

class _SingleSelectionDemo extends StatefulWidget {
  const _SingleSelectionDemo();

  @override
  State<_SingleSelectionDemo> createState() => _SingleSelectionDemoState();
}

class _SingleSelectionDemoState extends State<_SingleSelectionDemo> {
  String? _value;

  @override
  Widget build(BuildContext context) => VAutocomplete<String>(
    items: _sampleItems,
    value: _value,
    onChanged: (value) => setState(() => _value = value),
    placeholder: 'Search fruits...',
  );
}

class _SearchFormDemo extends StatefulWidget {
  const _SearchFormDemo();

  @override
  State<_SearchFormDemo> createState() => _SearchFormDemoState();
}

class _SearchFormDemoState extends State<_SearchFormDemo> {
  String? _category;

  static const _categoryItems = [
    VAutocompleteItem(value: 'flutter', label: 'Flutter'),
    VAutocompleteItem(value: 'dart', label: 'Dart'),
    VAutocompleteItem(value: 'react', label: 'React'),
    VAutocompleteItem(value: 'vue', label: 'Vue'),
  ];

  @override
  Widget build(BuildContext context) => VForm(
    children: [
      const VTextField(
        name: 'keyword',
        label: 'Keyword',
        placeholder: 'Enter keyword',
      ),
      VAutocomplete<String>(
        items: _categoryItems,
        value: _category,
        onChanged: (value) => setState(() => _category = value),
        label: 'Category',
        placeholder: 'Search category...',
      ),
      VButton(onPressed: () {}, child: const Text('Search')),
    ],
  );
}
