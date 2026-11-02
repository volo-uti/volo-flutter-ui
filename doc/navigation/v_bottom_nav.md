# VBottomNav

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VBottomNav

Bottom navigation bar for primary sections.

{@category Navigation}

## Overview

[VBottomNav] shows 3 to 5 destinations at the bottom of the screen and
reports the tapped index through [onTap].

## Basic Usage

```dart
VBottomNav(
  selectedIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  items: [
    VBottomNavItem(key: 'home', icon: Icon(Icons.home), label: 'Home'),
    VBottomNavItem(key: 'search', icon: Icon(Icons.search), label: 'Search'),
    VBottomNavItem(key: 'profile', icon: Icon(Icons.person), label: 'Profile'),
  ],
)
```

## Variants

- [VBottomNav.new] - Shows the label of the selected item only
- [VBottomNav.labeled] - Shows every label

## Navigation with badges

```dart
VBottomNav(
  selectedIndex: 0,
  onTap: (index) {},
  items: [
    VBottomNavItem(
      key: 'inbox',
      icon: Icon(Icons.inbox),
      label: 'Inbox',
      badge: VBadge(label: Text('5')),
    ),
    VBottomNavItem(key: 'sent', icon: Icon(Icons.send), label: 'Sent'),
    VBottomNavItem(key: 'trash', icon: Icon(Icons.delete), label: 'Trash'),
  ],
)
```

## Always labeled navigation

```dart
VBottomNav.labeled(
  selectedIndex: 0,
  onTap: (index) {},
  items: [
    VBottomNavItem(key: 'home', icon: Icon(Icons.home), label: 'Home'),
    VBottomNavItem(key: 'explore', icon: Icon(Icons.explore), label: 'Explore'),
    VBottomNavItem(key: 'library', icon: Icon(Icons.library_books), label: 'Library'),
  ],
)
```

See also:

- [VBottomNavItem], for individual navigation items
- [VAppBar], for top navigation
- [VTabs], for content switching within a section

### Constructors

#### `VBottomNav`

Creates a bar that shows the label of the selected item only.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `items` | `List<VBottomNavItem>` |  | yes | Destinations to show, at least 3 and at most 5 for a usable layout. |
| `selectedIndex` | `int` | `0` |  | Index of the selected destination, clamped to the item range. |
| `onTap` | `void Function(int)?` |  |  | Called with the index of a tapped destination. |
| `backgroundColor` | `Color?` |  |  | Bar fill color, defaulting to the theme background. |
| `selectedItemColor` | `Color?` |  |  | Icon and label color of the selected item, defaulting to primary. |
| `unselectedItemColor` | `Color?` |  |  | Icon and label color of the other items, defaulting to muted foreground. |
| `elevation` | `double` | `8` |  | Whether the bar casts a shadow, when above 0. |
| `style` | `VBottomNavStyle?` |  |  | Overrides for colors. |

#### `VBottomNav.labeled`

Creates a bar that shows every label.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `items` | `List<VBottomNavItem>` |  | yes | Destinations to show, at least 3 and at most 5 for a usable layout. |
| `selectedIndex` | `int` | `0` |  | Index of the selected destination, clamped to the item range. |
| `onTap` | `void Function(int)?` |  |  | Called with the index of a tapped destination. |
| `backgroundColor` | `Color?` |  |  | Bar fill color, defaulting to the theme background. |
| `selectedItemColor` | `Color?` |  |  | Icon and label color of the selected item, defaulting to primary. |
| `unselectedItemColor` | `Color?` |  |  | Icon and label color of the other items, defaulting to muted foreground. |
| `elevation` | `double` | `8` |  | Whether the bar casts a shadow, when above 0. |
| `style` | `VBottomNavStyle?` |  |  | Overrides for colors. |

## VBottomNavItem

An item displayed in a [VBottomNav].

Destination of a [VBottomNav]: an icon, a label, and an optional badge.

## Basic Usage

```dart
VBottomNavItem(
  key: 'home',
  icon: Icon(Icons.home_outlined),
  label: 'Home',
  activeIcon: Icon(Icons.home),
)
```

### Constructors

#### `VBottomNavItem`

Creates a destination.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `icon` | `Widget` |  | yes | Icon shown while the destination is not selected. |
| `label` | `String` |  | yes | Text under the icon, also the accessibility label.<br>It stays on one line; a label wider than its tab is drawn smaller to fit, and a screen reader still reads it in full. |
| `activeIcon` | `Widget?` |  |  | Icon shown instead of [icon] while selected. |
| `badge` | `Widget?` |  |  | Widget pinned to the icon's top right corner, such as a [VBadge]. |

## VBottomNavStyle

Style override for [VBottomNav].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VBottomNavStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `activeColor` | `Color?` |  |  | Active item color. |
| `inactiveColor` | `Color?` |  |  | Inactive item color. |
| `borderColor` | `Color?` |  |  | Color of the 1px line along the top edge of the bar. |
| `indicatorColor` | `Color?` |  |  | Color of the bar drawn along the top edge of the selected item, or `null` to draw none. |
| `indicatorHeight` | `double?` |  |  | Thickness of the selected item's top bar, 4 when null. Used only when [indicatorColor] is set. |
| `elevation` | `double?` |  |  | Elevation (shadow depth). |

### Members

| Member | Description |
|---|---|
| `VBottomNavStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? activeColor, Color? inactiveColor, Color? borderColor, Color? indicatorColor, double? indicatorHeight, double? elevation})` | Creates a copy with only the specified properties changed. |
