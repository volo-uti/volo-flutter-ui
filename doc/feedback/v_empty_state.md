# VEmptyState

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VEmptyState

Centered message for an empty list or screen.

Stacks an optional icon, a title, an optional description and an optional
action, centered in the space it gets. When that space has a fixed height
that is too short, for example with large text, the content scrolls
instead of overflowing; inside a scroll view it takes its natural height.
The title is a heading for screen readers.

An icon without its own color takes the muted foreground color through
[IconTheme], so a `VIcons` icon needs only a size.

```dart
VEmptyState(
  icon: VIcons.list(size: 48),
  title: 'No entries yet',
  description: 'Entries you save appear here.',
  action: VButton(onPressed: addEntry, child: const Text('Add entry')),
)
```

### Constructors

#### `VEmptyState`

Creates an empty state with a [title] and an optional icon, text and action.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `String` |  | yes | Short heading that says what is empty; screen readers read it as a heading. |
| `icon` | `Widget?` |  |  | Picture above the title, usually a `VIcons` icon. |
| `description` | `String?` |  |  | Text below the title that says why it is empty or what to do next. |
| `action` | `Widget?` |  |  | Widget below the text, usually one `VButton` for the next step. |
| `style` | `VEmptyStateStyle?` |  |  | Style override.<br>The instance style wins over the theme's [VEmptyStateStyle] override, which wins over the token defaults. |

## VEmptyStateStyle

Style override for [VEmptyState].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VEmptyStateStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `padding` | `EdgeInsets?` |  |  | Space around the content; defaults to the theme's xxl spacing. |
| `iconColor` | `Color?` |  |  | Color of an icon that takes the [IconTheme] color. |
| `titleStyle` | `TextStyle?` |  |  | Merged onto the title style (titleMedium in the foreground color). |
| `descriptionStyle` | `TextStyle?` |  |  | Merged onto the description style (bodyMedium in the muted color). |

### Members

| Member | Description |
|---|---|
| `VEmptyStateStyle copyWith({EdgeInsets? padding, Color? iconColor, TextStyle? titleStyle, TextStyle? descriptionStyle})` | Creates a copy with only the specified properties changed. |
