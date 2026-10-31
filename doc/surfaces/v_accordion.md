# VAccordion

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VAccordion

Stack of collapsible sections where tapping a header shows or hides its content.

```dart
VAccordion(
  onExpansionChanged: (expanded) => debugPrint('open: $expanded'),
  children: [
    VAccordionItem(
      title: Text('Section 1'),
      content: Text('Content of the first section.'),
    ),
    VAccordionItem(
      title: Text('Section 2'),
      content: Text('Content of the second section.'),
    ),
  ],
)
```

**Variants:**

- [VAccordion] - Default. Separated by dividers
- [VAccordion.separated] - Separated. Each item as an individual card
- [VAccordion.bordered] - Bordered. Wrapped with an outer border

**Multiple Expanded:**

```dart
VAccordion(
  allowMultiple: true,
  initialExpanded: [0, 1],
  children: [
    VAccordionItem(title: Text('Section 1'), content: Text('Content 1')),
    VAccordionItem(title: Text('Section 2'), content: Text('Content 2')),
    VAccordionItem(title: Text('Section 3'), content: Text('Content 3')),
  ],
)
```

**Separated Style:**

```dart
VAccordion.separated(
  children: [
    VAccordionItem(
      leading: Icon(Icons.person),
      title: Text('Profile Settings'),
      subtitle: Text('Manage name, email, etc.'),
      content: ProfileSettingsContent(),
    ),
    VAccordionItem(
      leading: Icon(Icons.notifications),
      title: Text('Notification Settings'),
      subtitle: Text('Manage push notifications'),
      content: NotificationSettingsContent(),
    ),
  ],
)
```

See also:

- [VAccordionItem], individual items used in the accordion
- [VCard], a container for grouping related content

### Constructors

#### `VAccordion`

Creates a default accordion. Items are separated by dividers.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<VAccordionItem>` |  | yes | List of items.<br>A list of [VAccordionItem] instances. |
| `allowMultiple` | `bool` | `false` |  | Allow multiple expanded.<br>When `true`, multiple items can be expanded simultaneously. When `false`, expanding one item automatically collapses the others. |
| `initialExpanded` | `List<int>?` |  |  | Initially expanded indices.<br>A list of item indices that should be expanded on first render. Indices past the end of [children] are ignored, and when [allowMultiple] is `false` only the first index in the list is used. |
| `onExpansionChanged` | `void Function(List<int>)?` |  |  | Called with the sorted indices of all expanded items after a header is tapped. |
| `divider` | `bool` | `true` |  | Whether to show dividers between items.<br>Ignored for [VAccordion.separated]. |
| `style` | `VAccordionStyle?` |  |  | Style override. |

#### `VAccordion.separated`

Separated accordion.

Each item is displayed as an individual card.
Visual separation is provided by spacing between items.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<VAccordionItem>` |  | yes | List of items.<br>A list of [VAccordionItem] instances. |
| `allowMultiple` | `bool` | `false` |  | Allow multiple expanded.<br>When `true`, multiple items can be expanded simultaneously. When `false`, expanding one item automatically collapses the others. |
| `initialExpanded` | `List<int>?` |  |  | Initially expanded indices.<br>A list of item indices that should be expanded on first render. Indices past the end of [children] are ignored, and when [allowMultiple] is `false` only the first index in the list is used. |
| `onExpansionChanged` | `void Function(List<int>)?` |  |  | Called with the sorted indices of all expanded items after a header is tapped. |
| `style` | `VAccordionStyle?` |  |  | Style override. |

#### `VAccordion.bordered`

Bordered accordion.

Wrapped with an outer border giving a grouped appearance.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<VAccordionItem>` |  | yes | List of items.<br>A list of [VAccordionItem] instances. |
| `allowMultiple` | `bool` | `false` |  | Allow multiple expanded.<br>When `true`, multiple items can be expanded simultaneously. When `false`, expanding one item automatically collapses the others. |
| `initialExpanded` | `List<int>?` |  |  | Initially expanded indices.<br>A list of item indices that should be expanded on first render. Indices past the end of [children] are ignored, and when [allowMultiple] is `false` only the first index in the list is used. |
| `onExpansionChanged` | `void Function(List<int>)?` |  |  | Called with the sorted indices of all expanded items after a header is tapped. |
| `divider` | `bool` | `true` |  | Whether to show dividers between items.<br>Ignored for [VAccordion.separated]. |
| `style` | `VAccordionStyle?` |  |  | Style override. |

## VAccordionItem

One collapsible section of a [VAccordion]: header slots plus hidden content.

```dart
VAccordionItem(
  leading: Icon(Icons.info),
  title: Text('Shipping'),
  subtitle: Text('Delivery times and fees'),
  content: Text('Orders ship within two business days.'),
)
```

### Constructors

#### `VAccordionItem`

Creates an accordion item.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Header title, usually a [Text]. |
| `content` | `Widget` |  | yes | Expandable content.<br>The widget displayed when the item is expanded. |
| `subtitle` | `Widget?` |  |  | Smaller line shown below [title]. |
| `leading` | `Widget?` |  |  | Leading icon.<br>A widget displayed to the left of the title. |
| `enabled` | `bool` | `true` |  | Whether the header reacts to taps.<br>When `false`, taps are ignored and the item is drawn at 50% opacity. |
| `id` | `Object?` |  |  | Identity that keeps this item's expanded state when the list changes.<br>Give each item a unique id when items are inserted, removed or reordered. Without one, the state follows the item's position in the list. |

## VAccordionStyle

Style override for [VAccordion].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VAccordionStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `padding` | `EdgeInsets?` |  |  | Content padding. |
| `headerPadding` | `EdgeInsets?` |  |  | Header padding. |
| `iconColor` | `Color?` |  |  | Expand / collapse icon color. |

### Members

| Member | Description |
|---|---|
| `VAccordionStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, BorderRadius? borderRadius, EdgeInsets? padding, EdgeInsets? headerPadding, Color? iconColor})` | Creates a copy with only the specified properties changed. |
