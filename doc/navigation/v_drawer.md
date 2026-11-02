# VDrawer

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VDrawer

Side panel with a header, content and footer for app navigation.

{@category Navigation}

## Overview

[VDrawer] is the panel itself, not the sliding: place it in a scaffold's
drawer slot or beside the content. [onClose] runs when Escape is pressed.

## Basic Usage

```dart
VDrawer(
  header: UserHeader(name: 'John Doe'),
  child: Column(
    children: [
      VListTile(title: Text('Home'), onTap: () => navigate('/home')),
      VListTile(title: Text('Settings'), onTap: () => navigate('/settings')),
    ],
  ),
)
```

## Variants

- [VDrawer.new] - Default drawer sliding from left
- [VDrawer.end] - Drawer sliding from right side
- [VDrawer.persistent] - Fixed drawer for desktop layouts (no elevation)

## Drawer with header and footer

```dart
VDrawer(
  header: Container(
    padding: EdgeInsets.all(16),
    child: Row(
      children: [
        CircleAvatar(child: Icon(Icons.person)),
        SizedBox(width: 12),
        Text('Welcome, User'),
      ],
    ),
  ),
  footer: VButton(
    child: Text('Logout'),
    onPressed: () => logout(),
  ),
  child: ListView(
    children: [
      VListTile(title: Text('Dashboard'), onTap: () {}),
      VListTile(title: Text('Projects'), onTap: () {}),
      VListTile(title: Text('Settings'), onTap: () {}),
    ],
  ),
)
```

## Right-side drawer

```dart
VDrawer.end(
  child: NotificationsList(),
)
```

## Persistent drawer for desktop

```dart
Row(
  children: [
    VDrawer.persistent(
      width: 256,
      child: NavigationMenu(),
    ),
    Expanded(child: MainContent()),
  ],
)
```

See also:

- [VAppBar], for top navigation bar
- [VBottomNav], for bottom navigation
- [VMenu], for popup menu options

### Constructors

#### `VDrawer`

Creates a panel for the start side.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Main content, filling the space between header and footer. |
| `header` | `Widget?` |  |  | Widget above [child], such as a user summary. |
| `footer` | `Widget?` |  |  | Widget below [child], such as a logout button. |
| `width` | `double?` |  |  | Width in logical pixels, defaulting to 320 and capped at 80% of the screen. |
| `backgroundColor` | `Color?` |  |  | Fill color, defaulting to the theme background. |
| `elevation` | `double` | `16` |  | Whether the panel casts a shadow, when above 0. |
| `semanticLabel` | `String?` |  |  | Screen reader label, defaulting to "Navigation drawer". |
| `onClose` | `void Function()?` |  |  | Called when Escape is pressed while the panel has focus. |
| `style` | `VDrawerStyle?` |  |  | Overrides for background, text color, elevation and corner radius. |

#### `VDrawer.end`

Creates a panel for the end side, with rounded start corners.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Main content, filling the space between header and footer. |
| `header` | `Widget?` |  |  | Widget above [child], such as a user summary. |
| `footer` | `Widget?` |  |  | Widget below [child], such as a logout button. |
| `width` | `double?` |  |  | Width in logical pixels, defaulting to 320 and capped at 80% of the screen. |
| `backgroundColor` | `Color?` |  |  | Fill color, defaulting to the theme background. |
| `elevation` | `double` | `16` |  | Whether the panel casts a shadow, when above 0. |
| `semanticLabel` | `String?` |  |  | Screen reader label, defaulting to "Navigation drawer". |
| `onClose` | `void Function()?` |  |  | Called when Escape is pressed while the panel has focus. |
| `style` | `VDrawerStyle?` |  |  | Overrides for background, text color, elevation and corner radius. |

#### `VDrawer.persistent`

Creates a flush, shadowless panel that stays beside the content.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Main content, filling the space between header and footer. |
| `header` | `Widget?` |  |  | Widget above [child], such as a user summary. |
| `footer` | `Widget?` |  |  | Widget below [child], such as a logout button. |
| `width` | `double?` |  |  | Width in logical pixels, defaulting to 320 and capped at 80% of the screen. |
| `backgroundColor` | `Color?` |  |  | Fill color, defaulting to the theme background. |
| `semanticLabel` | `String?` |  |  | Screen reader label, defaulting to "Navigation drawer". |
| `onClose` | `void Function()?` |  |  | Called when Escape is pressed while the panel has focus. |
| `style` | `VDrawerStyle?` |  |  | Overrides for background, text color, elevation and corner radius. |

## VDrawerStyle

Style override for [VDrawer].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VDrawerStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Color of the panel's text and icons; when null they keep what they inherit.<br>Children that set their own color keep it. An instance style wins over the theme override. |
| `elevation` | `double?` |  |  | Elevation (shadow depth). |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |

### Members

| Member | Description |
|---|---|
| `VDrawerStyle copyWith({Color? backgroundColor, Color? foregroundColor, double? elevation, BorderRadius? borderRadius})` | Creates a copy with only the specified properties changed. |
