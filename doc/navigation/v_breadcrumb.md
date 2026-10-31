# VBreadcrumb

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VBreadcrumb

Shows the current location hierarchy.

{@category Navigation}

## Overview

[VBreadcrumb] lists the path to the current page as a trail of links
separated by a divider, so users can jump back to a parent level.

## Basic Usage

```dart
VBreadcrumb(
  items: [
    VBreadcrumbItem(label: Text('Home'), onTap: () => goHome()),
    VBreadcrumbItem(label: Text('Products'), onTap: () => goProducts()),
    VBreadcrumbItem(label: Text('Electronics')), // Current page (no onTap)
  ],
)
```

## Breadcrumb with icons

```dart
VBreadcrumb(
  items: [
    VBreadcrumbItem(
      label: Text('Home'),
      icon: Icon(Icons.home),
      onTap: () => goHome(),
    ),
    VBreadcrumbItem(label: Text('Settings'), onTap: () => goSettings()),
    VBreadcrumbItem(label: Text('Profile')),
  ],
)
```

## Breadcrumb with custom separator

```dart
VBreadcrumb(
  separator: Icon(Icons.chevron_right, size: 16),
  items: [
    VBreadcrumbItem(label: Text('Dashboard'), onTap: () {}),
    VBreadcrumbItem(label: Text('Analytics'), onTap: () {}),
    VBreadcrumbItem(label: Text('Reports')),
  ],
)
```

## Collapsed breadcrumb with maxItems

When there are many items, use [maxItems] to collapse middle items:

```dart
VBreadcrumb(
  maxItems: 4,
  items: [
    VBreadcrumbItem(label: Text('Home'), onTap: () {}),
    VBreadcrumbItem(label: Text('Category'), onTap: () {}),
    VBreadcrumbItem(label: Text('Subcategory'), onTap: () {}),
    VBreadcrumbItem(label: Text('Product'), onTap: () {}),
    VBreadcrumbItem(label: Text('Details')),
  ],
)
// Displays: Home / ... / Product / Details
```

See also:

- [VBreadcrumbItem], for individual breadcrumb items
- [VAppBar], for top navigation bar
- [VTabs], for content switching

### Constructors

#### `VBreadcrumb`

Creates a trail from [items], with the last one as the current page.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `items` | `List<VBreadcrumbItem>` |  | yes | Levels of the trail, from the root to the current page. |
| `separator` | `Widget?` |  |  | Widget between levels, defaulting to a slash. |
| `maxItems` | `int?` |  |  | Most levels to show before the middle ones collapse into an ellipsis. |
| `style` | `VBreadcrumbStyle?` |  |  | Overrides for separator, link and current colors and the text style. |

## VBreadcrumbItem

An item displayed in a [VBreadcrumb].

One level of a [VBreadcrumb] trail: a label, an optional icon and a tap.

## Basic Usage

```dart
VBreadcrumbItem(
  label: Text('Products'),
  icon: Icon(Icons.shopping_bag),
  onTap: () => Navigator.pushNamed(context, '/products'),
)
```

### Constructors

#### `VBreadcrumbItem`

Creates a breadcrumb level.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `Widget` |  | yes | Name of the level, usually a [Text].<br>A plain [Text] picks up the theme's body style and the item color. |
| `icon` | `Widget?` |  |  | Icon shown before the label. |
| `onTap` | `void Function()?` |  |  | Called when the level is tapped; a level without it is not a link. |
| `active` | `bool` | `false` |  | Whether this item is drawn as the current location.<br>The last item is always current; this marks an earlier one as current. |

## VBreadcrumbStyle

Style override for [VBreadcrumb].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VBreadcrumbStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `foregroundColor` | `Color?` |  |  | Default item foreground color. |
| `activeColor` | `Color?` |  |  | Active (current) item color. |
| `separatorColor` | `Color?` |  |  | Separator color. |
| `textStyle` | `TextStyle?` |  |  | Text style. |

### Members

| Member | Description |
|---|---|
| `VBreadcrumbStyle copyWith({Color? foregroundColor, Color? activeColor, Color? separatorColor, TextStyle? textStyle})` | Creates a copy with only the specified properties changed. |
