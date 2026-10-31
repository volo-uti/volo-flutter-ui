# VAutocomplete

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VAutocomplete

Text input that suggests matching items, in single, multiple or async form.

Typing filters [items]; picking one reports its value. Without
[VAutocomplete.async] the filtering happens locally, by label and keywords.

```dart
VAutocomplete<String>(
  value: selectedCity,
  onChanged: (city) => setState(() => selectedCity = city),
  items: [
    VAutocompleteItem(value: 'seoul', label: 'Seoul'),
    VAutocompleteItem(value: 'busan', label: 'Busan'),
  ],
  placeholder: 'Search city...',
)
```

### Constructors

#### `VAutocomplete`

Creates an autocomplete that picks one [value] from [items].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `name` | `String?` |  |  | Key identifying this autocomplete in debug logs. |
| `items` | `List<VAutocompleteItem<T>>` | `const []` |  | Suggestions filtered locally; empty for [VAutocomplete.async]. |
| `value` | `T?` |  |  | Picked value of a single autocomplete. |
| `onChanged` | `void Function(T?)?` |  |  | Called with the picked value in a single or async autocomplete. |
| `onInputChanged` | `void Function(String)?` |  |  | Called with the current query text whenever the user edits it. |
| `placeholder` | `String?` |  |  | Hint text shown while the input is empty. |
| `label` | `String?` |  |  | Label above the field. |
| `more` | `String?` |  |  | Secondary text at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Help widget shown next to the label. |
| `required` | `bool` | `false` |  | Whether the label carries the [requiredMark]. |
| `requiredMark` | `String` | `'*'` |  | Character appended to the label when [required]. |
| `helper` | `String?` |  |  | Helper text below the field. |
| `error` | `bool` | `false` |  | Whether the field is drawn in the error state. |
| `errorText` | `String?` |  |  | Message below the field while [error] is set. |
| `success` | `bool` | `false` |  | Whether the field is drawn in the success state. |
| `successText` | `String?` |  |  | Message below the field while [success] is set. |
| `extra` | `String?` |  |  | Note below the field that is always visible. |
| `size` | `VAutocompleteSize?` |  |  | Input size; defaults to medium. |
| `allowCustomValue` | `bool` | `false` |  | Whether Enter accepts text that matches no item. |
| `filterFn` | `bool Function(VAutocompleteItem<T>, String)?` |  |  | Replaces the default label and keyword matching. |
| `enabled` | `bool` | `true` |  | Whether the autocomplete reacts to input. |
| `readOnly` | `bool` | `false` |  | Whether the input rejects edits while the value stays visible. |
| `loading` | `bool` | `false` |  | Whether a spinner is shown in the input. |
| `fullWidth` | `bool` | `false` |  | Whether the field fills the available width. |
| `emptyBuilder` | `Widget Function(String)?` |  |  | Builds the content shown when nothing matches the query. |
| `style` | `VAutocompleteStyle?` |  |  | Style override merged over the theme's [VAutocompleteStyle]. |

#### `VAutocomplete.multiple`

Creates an autocomplete that picks several [values], shown as chips.

```dart
VAutocomplete<String>.multiple(
  values: selectedList,
  onValuesChanged: (v) => setState(() => selectedList = v),
  items: items,
  maxSelection: 5,
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `name` | `String?` |  |  | Key identifying this autocomplete in debug logs. |
| `items` | `List<VAutocompleteItem<T>>` | `const []` |  | Suggestions filtered locally; empty for [VAutocomplete.async]. |
| `values` | `List<T>` | `const []` |  | Picked values of a [VAutocomplete.multiple]. |
| `onValuesChanged` | `void Function(List<T>)?` |  |  | Called with the new list when [VAutocomplete.multiple] adds or removes a value. |
| `maxSelection` | `int?` |  |  | Largest number of values a [VAutocomplete.multiple] accepts. |
| `chipBuilder` | `Widget Function(T)?` |  |  | Builds the chip of a picked value in [VAutocomplete.multiple]. |
| `onInputChanged` | `void Function(String)?` |  |  | Called with the current query text whenever the user edits it. |
| `placeholder` | `String?` |  |  | Hint text shown while the input is empty. |
| `label` | `String?` |  |  | Label above the field. |
| `more` | `String?` |  |  | Secondary text at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Help widget shown next to the label. |
| `required` | `bool` | `false` |  | Whether the label carries the [requiredMark]. |
| `requiredMark` | `String` | `'*'` |  | Character appended to the label when [required]. |
| `helper` | `String?` |  |  | Helper text below the field. |
| `error` | `bool` | `false` |  | Whether the field is drawn in the error state. |
| `errorText` | `String?` |  |  | Message below the field while [error] is set. |
| `success` | `bool` | `false` |  | Whether the field is drawn in the success state. |
| `successText` | `String?` |  |  | Message below the field while [success] is set. |
| `extra` | `String?` |  |  | Note below the field that is always visible. |
| `size` | `VAutocompleteSize?` |  |  | Input size; defaults to medium. |
| `allowCustomValue` | `bool` | `false` |  | Whether Enter accepts text that matches no item. |
| `filterFn` | `bool Function(VAutocompleteItem<T>, String)?` |  |  | Replaces the default label and keyword matching. |
| `enabled` | `bool` | `true` |  | Whether the autocomplete reacts to input. |
| `readOnly` | `bool` | `false` |  | Whether the input rejects edits while the value stays visible. |
| `loading` | `bool` | `false` |  | Whether a spinner is shown in the input. |
| `fullWidth` | `bool` | `false` |  | Whether the field fills the available width. |
| `emptyBuilder` | `Widget Function(String)?` |  |  | Builds the content shown when nothing matches the query. |
| `style` | `VAutocompleteStyle?` |  |  | Style override merged over the theme's [VAutocompleteStyle]. |

#### `VAutocomplete.async`

Creates an autocomplete whose suggestions come from [onSearch].

```dart
VAutocomplete<Product>.async(
  value: selectedProduct,
  onChanged: (p) => setState(() => selectedProduct = p),
  onSearch: (query) async => api.searchProducts(query),
  debounceMs: 500,
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `onSearch` | `Future<List<VAutocompleteItem<T>>> Function(String)?` |  | yes | Loads suggestions for the query in [VAutocomplete.async]. |
| `name` | `String?` |  |  | Key identifying this autocomplete in debug logs. |
| `value` | `T?` |  |  | Picked value of a single autocomplete. |
| `onChanged` | `void Function(T?)?` |  |  | Called with the picked value in a single or async autocomplete. |
| `onInputChanged` | `void Function(String)?` |  |  | Called with the current query text whenever the user edits it. |
| `debounceMs` | `int` | `300` |  | Milliseconds to wait after typing before [onSearch] runs. |
| `minSearchLength` | `int` | `1` |  | Shortest query that triggers [onSearch]. |
| `placeholder` | `String?` |  |  | Hint text shown while the input is empty. |
| `label` | `String?` |  |  | Label above the field. |
| `more` | `String?` |  |  | Secondary text at the right end of the label row. |
| `tooltip` | `Widget?` |  |  | Help widget shown next to the label. |
| `required` | `bool` | `false` |  | Whether the label carries the [requiredMark]. |
| `requiredMark` | `String` | `'*'` |  | Character appended to the label when [required]. |
| `helper` | `String?` |  |  | Helper text below the field. |
| `error` | `bool` | `false` |  | Whether the field is drawn in the error state. |
| `errorText` | `String?` |  |  | Message below the field while [error] is set. |
| `success` | `bool` | `false` |  | Whether the field is drawn in the success state. |
| `successText` | `String?` |  |  | Message below the field while [success] is set. |
| `extra` | `String?` |  |  | Note below the field that is always visible. |
| `size` | `VAutocompleteSize?` |  |  | Input size; defaults to medium. |
| `allowCustomValue` | `bool` | `false` |  | Whether Enter accepts text that matches no item. |
| `enabled` | `bool` | `true` |  | Whether the autocomplete reacts to input. |
| `readOnly` | `bool` | `false` |  | Whether the input rejects edits while the value stays visible. |
| `loading` | `bool` | `false` |  | Whether a spinner is shown in the input. |
| `fullWidth` | `bool` | `false` |  | Whether the field fills the available width. |
| `emptyBuilder` | `Widget Function(String)?` |  |  | Builds the content shown when nothing matches the query. |
| `style` | `VAutocompleteStyle?` |  |  | Style override merged over the theme's [VAutocompleteStyle]. |

## VAutocompleteSize

Three-step size of a [VAutocomplete] input and its option rows.

### Values

| Value | Description |
|---|---|
| `sm` | Small size. |
| `md` | Medium size (default). |
| `lg` | Large size. |

## VAutocompleteItem

One suggestion of a [VAutocomplete], with a value, label and optional extras.

Two items are equal when their [value]s are equal.

```dart
VAutocompleteItem(
  value: 'seoul',
  label: 'Seoul',
  subtitle: 'Capital of South Korea',
  leading: Icon(Icons.location_city),
)
```

### Constructors

#### `VAutocompleteItem`

Creates an autocomplete item.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `T` |  | yes | Value reported when this item is picked. |
| `label` | `String` |  | yes | Text shown in the option row and matched against the query. |
| `subtitle` | `String?` |  |  | Secondary text below [label]. |
| `leading` | `Widget?` |  |  | Widget shown before the text, such as an icon or avatar. |
| `enabled` | `bool` | `true` |  | Whether this item can be picked. |
| `keywords` | `List<String>?` |  |  | Extra terms matched against the query besides [label]. |

## VAutocompleteChipBuilder

Builds the chip shown for a picked [value] in [VAutocomplete.multiple].

```dart
typedef VAutocompleteChipBuilder = Widget Function(T);
```

## VAutocompleteSearch

Loads the suggestions for [query] in [VAutocomplete.async].

```dart
typedef VAutocompleteSearch = Future<List<VAutocompleteItem<T>>> Function(String);
```

## VAutocompleteFilter

Decides whether [item] matches [query] in a [VAutocomplete].

```dart
typedef VAutocompleteFilter = bool Function(VAutocompleteItem<T>, String);
```

## VAutocompleteEmptyBuilder

Builds the content shown when no item matches [query].

```dart
typedef VAutocompleteEmptyBuilder = Widget Function(String);
```

## VAutocompleteStyle

Style override for [VAutocomplete].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VAutocompleteStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `focusBorderColor` | `Color?` |  |  | Border color when focused. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `textStyle` | `TextStyle?` |  |  | Text style. |
| `dropdownBackgroundColor` | `Color?` |  |  | Dropdown menu background color. |

### Members

| Member | Description |
|---|---|
| `VAutocompleteStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, Color? focusBorderColor, BorderRadius? borderRadius, EdgeInsets? padding, TextStyle? textStyle, Color? dropdownBackgroundColor})` | Creates a copy with only the specified properties changed. |
