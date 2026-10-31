# VSection, VSectionHeader, VSectionFooter

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VSection

Rows grouped under a header, with optional footer.

[header] and [footer] are widgets; a plain [Text] there takes the section
title and caption styles. [VSection.card] puts the group on a card and
[VSection.inset] indents the rows.

## Basic Usage:

```dart
VSection(
  header: Text('Settings'),
  children: [
    VListTile(title: Text('Profile')),
    VListTile(title: Text('Notifications')),
  ],
)
```

## Variants:

- [VSection.new] - Default transparent section
- [VSection.card] - Card style section
- [VSection.inset] - Indented section

## Card Section:

```dart
VSection.card(
  header: VSectionHeader(
    title: Text('Account Settings'),
    trailing: TextButton(
      onPressed: () {},
      child: Text('More'),
    ),
  ),
  divider: true,
  children: [
    VListTile(title: Text('Profile')),
    VListTile(title: Text('Privacy')),
    VListTile(title: Text('Notifications')),
  ],
)
```

## With Footer:

```dart
VSection(
  header: Text('Terms'),
  footer: Text('By using this app, you agree to our terms.'),
  children: [
    VSwitchListTile(
      title: Text('Accept Terms'),
      value: true,
      onChanged: (v) {},
    ),
  ],
)
```

See also:

- [VSectionHeader], section header widget
- [VSectionFooter], section footer widget
- [VBox], single child container

### Constructors

#### `VSection`

Section with a transparent background.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Rows of the section, laid out top to bottom. |
| `header` | `Widget?` |  |  | Widget shown above the rows, in the section title style. |
| `footer` | `Widget?` |  |  | Widget shown below the rows, in the muted caption style. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Space between the section edge and its content. |
| `margin` | `EdgeInsetsGeometry?` |  |  | Space around the section. |
| `divider` | `bool` | `false` |  | Whether a thin line is drawn between neighbouring [children]. |
| `backgroundColor` | `Color?` |  |  | Background color; the card variant defaults to the card color. |
| `borderRadius` | `BorderRadiusGeometry?` |  |  | Corner radius; the card variant defaults to `theme.radius.card`. |
| `style` | `VSectionStyle?` |  |  | Overrides the theme style, for example the title style and padding. |

#### `VSection.card`

Card style section.

Section drawn on a card background with rounded corners.

```dart
VSection.card(
  header: Text('Settings'),
  children: settingItems,
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Rows of the section, laid out top to bottom. |
| `header` | `Widget?` |  |  | Widget shown above the rows, in the section title style. |
| `footer` | `Widget?` |  |  | Widget shown below the rows, in the muted caption style. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Space between the section edge and its content. |
| `margin` | `EdgeInsetsGeometry?` |  |  | Space around the section. |
| `divider` | `bool` | `false` |  | Whether a thin line is drawn between neighbouring [children]. |
| `backgroundColor` | `Color?` |  |  | Background color; the card variant defaults to the card color. |
| `borderRadius` | `BorderRadiusGeometry?` |  |  | Corner radius; the card variant defaults to `theme.radius.card`. |
| `style` | `VSectionStyle?` |  |  | Overrides the theme style, for example the title style and padding. |

#### `VSection.inset`

Section whose rows are indented by an extra horizontal padding.

```dart
VSection.inset(
  header: Text('Details'),
  children: detailItems,
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<Widget>` |  | yes | Rows of the section, laid out top to bottom. |
| `header` | `Widget?` |  |  | Widget shown above the rows, in the section title style. |
| `footer` | `Widget?` |  |  | Widget shown below the rows, in the muted caption style. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Space between the section edge and its content. |
| `margin` | `EdgeInsetsGeometry?` |  |  | Space around the section. |
| `divider` | `bool` | `false` |  | Whether a thin line is drawn between neighbouring [children]. |
| `backgroundColor` | `Color?` |  |  | Background color; the card variant defaults to the card color. |
| `borderRadius` | `BorderRadiusGeometry?` |  |  | Corner radius; the card variant defaults to `theme.radius.card`. |
| `style` | `VSectionStyle?` |  |  | Overrides the theme style, for example the title style and padding. |

## VSectionHeader

Section heading with a title, an optional subtitle and a trailing action.

[title] and [subtitle] are widgets; a plain [Text] takes the section title
and caption styles. Use it as [VSection.header].

## Basic Usage:

```dart
VSectionHeader(
  title: Text('Settings'),
  subtitle: Text('Modify app settings'),
)
```

## With Trailing Action:

```dart
VSectionHeader(
  title: Text('Recent Activity'),
  trailing: TextButton(
    onPressed: () {},
    child: Text('See All'),
  ),
)
```

See also:

- [VSection], section container widget
- [VSectionFooter], section footer widget

### Constructors

#### `VSectionHeader`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Main heading, in the section title style. |
| `subtitle` | `Widget?` |  |  | Line below [title], in the muted caption style. |
| `trailing` | `Widget?` |  |  | Widget at the end of the row, such as a "See All" button. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Space around the header; none by default. |

## VSectionFooter

Muted caption under a section, for hints and legal text.

[child] is a widget; a plain [Text] takes the caption style. Use it as
[VSection.footer].

## Basic Usage:

```dart
VSectionFooter(
  child: Text('Additional information here'),
)
```

## With Custom Widget:

```dart
VSectionFooter(
  child: Row(
    children: [
      Icon(Icons.info, size: 16),
      SizedBox(width: 8),
      Text('Learn more about this feature'),
    ],
  ),
)
```

See also:

- [VSection], section container widget
- [VSectionHeader], section header widget

### Constructors

#### `VSectionFooter`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Caption content, in the muted caption style. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Space around the footer; none by default. |

## VSectionStyle

Style override for [VSection].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VSectionStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |
| `titleStyle` | `TextStyle?` |  |  | Section title text style. |

### Members

| Member | Description |
|---|---|
| `VSectionStyle copyWith({Color? backgroundColor, EdgeInsets? padding, TextStyle? titleStyle})` | Creates a copy with only the specified properties changed. |
