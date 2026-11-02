import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_form_field/v_form_field.dart';
import 'package:volo_flutter_ui/src/components/surfaces/v_popover/v_popover.dart';
import 'package:volo_flutter_ui/src/components/surfaces/v_popover/v_popover_style.dart';
import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'package:volo_flutter_ui/src/utils/v_debug.dart';

import 'v_autocomplete_style.dart';

part 'v_autocomplete_state.dart';

/// Three-step size of a [VAutocomplete] input and its option rows.
enum VAutocompleteSize {
  /// Small size.
  sm,

  /// Medium size (default).
  md,

  /// Large size.
  lg,
}

/// One suggestion of a [VAutocomplete], with a value, label and optional extras.
///
/// Two items are equal when their [value]s are equal.
///
/// ```dart
/// VAutocompleteItem(
///   value: 'seoul',
///   label: 'Seoul',
///   subtitle: 'Capital of South Korea',
///   leading: Icon(Icons.location_city),
/// )
/// ```
class VAutocompleteItem<T> {
  /// Creates an autocomplete item.
  const VAutocompleteItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.leading,
    this.enabled = true,
    this.keywords,
  });

  /// Value reported when this item is picked.
  final T value;

  /// Text shown in the option row and matched against the query.
  final String label;

  /// Secondary text below [label].
  final String? subtitle;

  /// Widget shown before the text, such as an icon or avatar.
  final Widget? leading;

  /// Whether this item can be picked.
  final bool enabled;

  /// Extra terms matched against the query besides [label].
  final List<String>? keywords;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VAutocompleteItem<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Builds the chip shown for a picked [value] in [VAutocomplete.multiple].
typedef VAutocompleteChipBuilder<T> = Widget Function(T value);

/// Loads the suggestions for [query] in [VAutocomplete.async].
typedef VAutocompleteSearch<T> =
    Future<List<VAutocompleteItem<T>>> Function(String query);

/// Decides whether [item] matches [query] in a [VAutocomplete].
typedef VAutocompleteFilter<T> =
    bool Function(VAutocompleteItem<T> item, String query);

/// Builds the content shown when no item matches [query].
typedef VAutocompleteEmptyBuilder = Widget Function(String query);

/// Text input that suggests matching items, in single, multiple or async form.
///
/// Typing filters [items]; picking one reports its value. Without
/// [VAutocomplete.async] the filtering happens locally, by label and keywords.
///
/// ```dart
/// VAutocomplete<String>(
///   value: selectedCity,
///   onChanged: (city) => setState(() => selectedCity = city),
///   items: [
///     VAutocompleteItem(value: 'seoul', label: 'Seoul'),
///     VAutocompleteItem(value: 'busan', label: 'Busan'),
///   ],
///   placeholder: 'Search city...',
/// )
/// ```
class VAutocomplete<T> extends StatefulWidget {
  /// Creates an autocomplete that picks one [value] from [items].
  const VAutocomplete({
    super.key,
    this.name,
    this.items = const [],
    this.value,
    this.onChanged,
    this.onInputChanged,
    this.placeholder,
    this.label,
    this.more,
    this.tooltip,
    this.required = false,
    this.requiredMark = '*',
    this.helper,
    this.error = false,
    this.errorText,
    this.success = false,
    this.successText,
    this.extra,
    this.size,
    this.allowCustomValue = false,
    this.filterFn,
    this.enabled = true,
    this.readOnly = false,
    this.loading = false,
    this.fullWidth = false,
    this.emptyBuilder,
    this.style,
  }) : values = const [],
       onValuesChanged = null,
       maxSelection = null,
       chipBuilder = null,
       onSearch = null,
       debounceMs = 300,
       minSearchLength = 1,
       _isMultiple = false,
       _isAsync = false;

  /// Creates an autocomplete that picks several [values], shown as chips.
  ///
  /// ```dart
  /// VAutocomplete<String>.multiple(
  ///   values: selectedList,
  ///   onValuesChanged: (v) => setState(() => selectedList = v),
  ///   items: items,
  ///   maxSelection: 5,
  /// )
  /// ```
  const VAutocomplete.multiple({
    super.key,
    this.name,
    this.items = const [],
    this.values = const [],
    this.onValuesChanged,
    this.maxSelection,
    this.chipBuilder,
    this.onInputChanged,
    this.placeholder,
    this.label,
    this.more,
    this.tooltip,
    this.required = false,
    this.requiredMark = '*',
    this.helper,
    this.error = false,
    this.errorText,
    this.success = false,
    this.successText,
    this.extra,
    this.size,
    this.allowCustomValue = false,
    this.filterFn,
    this.enabled = true,
    this.readOnly = false,
    this.loading = false,
    this.fullWidth = false,
    this.emptyBuilder,
    this.style,
  }) : value = null,
       onChanged = null,
       onSearch = null,
       debounceMs = 300,
       minSearchLength = 1,
       _isMultiple = true,
       _isAsync = false;

  /// Creates an autocomplete whose suggestions come from [onSearch].
  ///
  /// ```dart
  /// VAutocomplete<Product>.async(
  ///   value: selectedProduct,
  ///   onChanged: (p) => setState(() => selectedProduct = p),
  ///   onSearch: (query) async => api.searchProducts(query),
  ///   debounceMs: 500,
  /// )
  /// ```
  const VAutocomplete.async({
    required this.onSearch,
    super.key,
    this.name,
    this.value,
    this.onChanged,
    this.onInputChanged,
    this.debounceMs = 300,
    this.minSearchLength = 1,
    this.placeholder,
    this.label,
    this.more,
    this.tooltip,
    this.required = false,
    this.requiredMark = '*',
    this.helper,
    this.error = false,
    this.errorText,
    this.success = false,
    this.successText,
    this.extra,
    this.size,
    this.allowCustomValue = false,
    this.enabled = true,
    this.readOnly = false,
    this.loading = false,
    this.fullWidth = false,
    this.emptyBuilder,
    this.style,
  }) : items = const [],
       values = const [],
       onValuesChanged = null,
       maxSelection = null,
       chipBuilder = null,
       filterFn = null,
       _isMultiple = false,
       _isAsync = true;

  /// Key identifying this autocomplete in debug logs.
  final String? name;

  /// Suggestions filtered locally; empty for [VAutocomplete.async].
  final List<VAutocompleteItem<T>> items;

  /// Picked value of a single autocomplete.
  final T? value;

  /// Called with the picked value in a single or async autocomplete.
  final ValueChanged<T?>? onChanged;

  /// Called with the current query text whenever the user edits it.
  final ValueChanged<String>? onInputChanged;

  /// Picked values of a [VAutocomplete.multiple].
  final List<T> values;

  /// Called with the new list when [VAutocomplete.multiple] adds or removes a value.
  final ValueChanged<List<T>>? onValuesChanged;

  /// Largest number of values a [VAutocomplete.multiple] accepts.
  final int? maxSelection;

  /// Builds the chip of a picked value in [VAutocomplete.multiple].
  final VAutocompleteChipBuilder<T>? chipBuilder;

  /// Loads suggestions for the query in [VAutocomplete.async].
  final VAutocompleteSearch<T>? onSearch;

  /// Milliseconds to wait after typing before [onSearch] runs.
  final int debounceMs;

  /// Shortest query that triggers [onSearch].
  final int minSearchLength;

  /// Hint text shown while the input is empty.
  final String? placeholder;

  /// Label above the field.
  final String? label;

  /// Secondary text at the right end of the label row.
  final String? more;

  /// Help widget shown next to the label.
  final Widget? tooltip;

  /// Whether the label carries the [requiredMark].
  final bool required;

  /// Character appended to the label when [required].
  final String requiredMark;

  /// Helper text below the field.
  final String? helper;

  /// Whether the field is drawn in the error state.
  final bool error;

  /// Message below the field while [error] is set.
  final String? errorText;

  /// Whether the field is drawn in the success state.
  final bool success;

  /// Message below the field while [success] is set.
  final String? successText;

  /// Note below the field that is always visible.
  final String? extra;

  /// Input size; defaults to medium.
  final VAutocompleteSize? size;

  /// Whether Enter accepts text that matches no item.
  final bool allowCustomValue;

  /// Replaces the default label and keyword matching.
  final VAutocompleteFilter<T>? filterFn;

  /// Whether the autocomplete reacts to input.
  final bool enabled;

  /// Whether the input rejects edits while the value stays visible.
  final bool readOnly;

  /// Whether a spinner is shown in the input.
  final bool loading;

  /// Whether the field fills the available width.
  final bool fullWidth;

  /// Builds the content shown when nothing matches the query.
  final VAutocompleteEmptyBuilder? emptyBuilder;

  /// Style override merged over the theme's [VAutocompleteStyle].
  final VAutocompleteStyle? style;

  final bool _isMultiple;
  final bool _isAsync;

  @override
  State<VAutocomplete<T>> createState() => _VAutocompleteState<T>();
}
