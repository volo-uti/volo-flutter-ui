# VCommand, VCommandInput, VCommandList, VCommandEmpty, VCommandGroup, VCommandItem, VCommandSeparator, VCommandShortcut

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VCommand

Searchable command palette, inline or as a Cmd+K dialog.

Typing filters the items, arrows move the highlight and Enter runs the
highlighted item's [VCommandItem.onTap].

```dart
VCommand(
  placeholder: 'Type a command...',
  children: [
    VCommandInput(),
    VCommandList(
      children: [
        VCommandGroup(
          heading: 'Suggestions',
          children: [
            VCommandItem(
              value: 'calendar',
              leading: Icon(Icons.calendar_today),
              onTap: () => openCalendar(),
              child: Text('Calendar'),
            ),
          ],
        ),
      ],
    ),
  ],
)
```

Use [VCommand.dialog] for a modal palette driven by [open] and
[onOpenChanged].

### Constructors

#### `VCommand`

Command palette drawn in place, always visible.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | [VCommandInput], [VCommandList] and any other widgets, in order. |
| `placeholder` | `String?` |  |  | Hint shown in the search field while it is empty.<br>A [VCommandInput.placeholder] takes precedence. |
| `emptyBuilder` | `Widget Function(String)?` |  |  | Builds the empty state when no item matches the query. |
| `filter` | `bool Function(VCommandItemData, String)?` |  |  | Replaces the default case-insensitive match on value and keywords. |
| `loading` | `bool` | `false` |  | Whether a spinner is shown next to the search field. |
| `style` | `VCommandStyle?` |  |  | Overrides the theme's [VCommandStyle] for this palette. |

#### `VCommand.dialog`

Command palette shown in a modal dialog while [open] is true.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | [VCommandInput], [VCommandList] and any other widgets, in order. |
| `open` | `bool` | `false` |  | Whether the dialog is shown; always true for the inline form. |
| `onOpenChanged` | `void Function(bool)?` |  |  | Called with false when the dialog asks to close (Escape, scrim tap, pick). |
| `placeholder` | `String?` |  |  | Hint shown in the search field while it is empty.<br>A [VCommandInput.placeholder] takes precedence. |
| `emptyBuilder` | `Widget Function(String)?` |  |  | Builds the empty state when no item matches the query. |
| `filter` | `bool Function(VCommandItemData, String)?` |  |  | Replaces the default case-insensitive match on value and keywords. |
| `loading` | `bool` | `false` |  | Whether a spinner is shown next to the search field. |
| `style` | `VCommandStyle?` |  |  | Overrides the theme's [VCommandStyle] for this palette. |

## VCommandInput

Search field marker inside a [VCommand]; the palette draws the field.

### Constructors

#### `VCommandInput`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `placeholder` | `String?` |  |  | Hint shown while the field is empty. |
| `autofocus` | `bool` | `true` |  | Whether the field takes focus when first shown. |

## VCommandList

Scrollable results region of a [VCommand] holding groups and items.

### Constructors

#### `VCommandList`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | [VCommandItem], [VCommandGroup], [VCommandSeparator] and [VCommandEmpty]. |

## VCommandEmpty

Custom empty state shown by a [VCommandList] when nothing matches.

### Constructors

#### `VCommandEmpty`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget?` |  |  | Content to show; the localized "no results" text when null. |

## VCommandGroup

Labeled group of [VCommandItem] rows inside a [VCommandList].

### Constructors

#### `VCommandGroup`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Items of the group. |
| `heading` | `String?` |  |  | Small caption above the group. |

## VCommandItem

One selectable command row in a [VCommand].

```dart
VCommandItem(
  value: 'calendar',
  keywords: ['date', 'agenda'],
  leading: Icon(Icons.calendar_today),
  trailing: VCommandShortcut(keys: ['Ctrl', 'K']),
  onTap: () => openCalendar(),
  child: Text('Calendar'),
)
```

### Constructors

#### `VCommandItem`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `String` |  | yes | Text matched against the query. |
| `child` | `Widget` |  | yes | Content of the row, usually a [Text] that takes the palette text style. |
| `onTap` | `void Function()?` |  |  | Called when the row is tapped or chosen with Enter. |
| `leading` | `Widget?` |  |  | Widget before the child, such as an icon. |
| `trailing` | `Widget?` |  |  | Widget after the child, such as a [VCommandShortcut]. |
| `enabled` | `bool` | `true` |  | Whether the row can be selected; false hides it from results. |
| `keywords` | `List<String>?` |  |  | Extra words that also match the query. |

## VCommandSeparator

Thin line between groups of results in a [VCommandList].

### Constructors

#### `VCommandSeparator`

## VCommandShortcut

Row of keycap chips that shows a keyboard shortcut.

### Constructors

#### `VCommandShortcut`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `keys` | `List<String>` |  | yes | Key labels, one chip each, such as `['Ctrl', 'K']`. |

## VCommandFilter

Decides whether [item] matches [query] in a [VCommand].

```dart
typedef VCommandFilter = bool Function(VCommandItemData, String);
```

## VCommandEmptyBuilder

Builds the content shown by a [VCommand] when nothing matches [query].

```dart
typedef VCommandEmptyBuilder = Widget Function(String);
```

## VCommandItemData

Snapshot of a [VCommandItem] handed to a [VCommandFilter].

### Constructors

#### `VCommandItemData`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `value` | `String` |  | yes | Text matched against the query. |
| `keywords` | `List<String>?` |  |  | Extra words that also match the query. |
| `enabled` | `bool` | `true` |  | Whether the item can be selected. |
| `onTap` | `void Function()?` |  |  | Called when the item is selected. |

## VCommandStyle

Style override for [VCommand].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VCommandStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `shadows` | `List<BoxShadow>?` |  |  | Shadows under the palette panel; when null the dialog has the large shadow.<br>The inline palette draws no shadow when null. An empty list draws none. An instance style wins over the theme override. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `inputTextStyle` | `TextStyle?` |  |  | Search input text style. |

### Members

| Member | Description |
|---|---|
| `VCommandStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, BorderRadius? borderRadius, List<BoxShadow>? shadows, EdgeInsets? padding, TextStyle? inputTextStyle})` | Creates a copy with only the specified properties changed. |
