# VScaffold

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VScaffold

Screen frame with app bar, body, bottom nav, drawers, FAB.

Replaces `Scaffold` without Material. It pads the top and bottom safe
areas and the keyboard, and places [floatingActionButton] at
[floatingActionButtonLocation]. Open and close the drawers from any
descendant with [VScaffold.openDrawer] and [VScaffold.closeDrawer].

## Basic Usage:

```dart
VScaffold(
  appBar: VAppBar(title: Text('Home')),
  body: Center(child: Text('Hello World')),
  bottomNavigationBar: VBottomNav(
    selectedIndex: 0,
    onTap: (index) {},
    items: [
      VBottomNavItem(key: 'home', icon: Icon(Icons.home), label: 'Home'),
      VBottomNavItem(key: 'search', icon: Icon(Icons.search), label: 'Search'),
    ],
  ),
)
```

## With FAB:

```dart
VScaffold(
  body: ListView.builder(...),
  floatingActionButton: VFab(
    onPressed: () {},
    icon: Icon(Icons.add),
  ),
  floatingActionButtonLocation: VFabLocation.centerFloat,
)
```

## With Drawer:

```dart
VScaffold(
  appBar: VAppBar(
    leading: Builder(
      builder: (context) => VIconButton(
        icon: Icon(Icons.menu),
        onPressed: () => VScaffold.openDrawer(context),
      ),
    ),
    title: Text('Menu'),
  ),
  drawer: VDrawer(child: ListView(...)),
  body: Center(child: Text('Content')),
)
```

See also:

- [VFabLocation], FAB position options
- [VAppBar], app bar widget
- [VBottomNav], bottom navigation widget
- [VDrawer], drawer widget

### Constructors

#### `VScaffold`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `body` | `Widget` |  | yes | Main content, placed between the app bar and the bottom navigation. |
| `appBar` | `PreferredSizeWidget?` |  |  | Bar shown at the top of the screen. |
| `bottomNavigationBar` | `Widget?` |  |  | Navigation shown at the bottom, above the safe area. |
| `drawer` | `Widget?` |  |  | Panel that slides in from the left edge, opened by [openDrawer]. |
| `endDrawer` | `Widget?` |  |  | Panel that slides in from the right edge, opened by [openEndDrawer]. |
| `floatingActionButton` | `Widget?` |  |  | Floating button placed at [floatingActionButtonLocation]. |
| `floatingActionButtonLocation` | `VFabLocation` | `VFabLocation.endFloat` |  | Where [floatingActionButton] sits; docked values overlap the bottom nav. |
| `backgroundColor` | `Color?` |  |  | Screen background; defaults to the theme background. |
| `resizeToAvoidBottomInset` | `bool` | `true` |  | Whether the bottom of the screen moves up with the on-screen keyboard. |
| `extendBody` | `bool` | `false` |  | Whether the body extends behind [bottomNavigationBar]. |
| `extendBodyBehindAppBar` | `bool` | `false` |  | Whether the body extends behind [appBar], which then floats over it. |

### Members

| Member | Description |
|---|---|
| `static void openDrawer(BuildContext context)` | Opens [drawer] of the nearest scaffold above [context]. |
| `static void closeDrawer(BuildContext context)` | Closes [drawer] of the nearest scaffold above [context]. |
| `static void openEndDrawer(BuildContext context)` | Opens [endDrawer] of the nearest scaffold above [context]. |
| `static void closeEndDrawer(BuildContext context)` | Closes [endDrawer] of the nearest scaffold above [context]. |

## VFabLocation

Where [VScaffold] places its floating action button.

### Values

| Value | Description |
|---|---|
| `endFloat` | Bottom right (default). |
| `centerFloat` | Bottom center. |
| `startFloat` | Bottom left. |
| `endDocked` | Bottom right (overlapping BottomNav). |
| `centerDocked` | Bottom center (overlapping BottomNav). |

## VScaffoldStyle

Style override for [VScaffold].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VScaffoldStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color for the scaffold body. |
| `drawerBackgroundColor` | `Color?` |  |  | Background color for the drawer. |
| `bottomNavBackgroundColor` | `Color?` |  |  | Background color for the bottom navigation bar. |

### Members

| Member | Description |
|---|---|
| `VScaffoldStyle copyWith({Color? backgroundColor, Color? drawerBackgroundColor, Color? bottomNavBackgroundColor})` | Creates a copy with only the specified properties changed. |
