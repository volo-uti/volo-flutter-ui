# VBottomSheet, VSideSheet, VSheet

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VBottomSheet

Sheet that slides up from the bottom and can be dragged to resize or dismiss.

```dart
VBottomSheet.show(
  context,
  title: Text('Title'),
  snapPoints: [0.3, 0.6, 0.9],
  child: ListView(
    children: [
      VListTile(title: Text('Item 1')),
      VListTile(title: Text('Item 2')),
      VListTile(title: Text('Item 3')),
    ],
  ),
);
```

**Close with Result:**

```dart
final result = await VBottomSheet.show<String>(
  context,
  child: Column(
    children: [
      VButton(
        onPressed: () => VBottomSheet.close(context, 'option1'),
        child: Text('Option 1'),
      ),
      VButton(
        onPressed: () => VBottomSheet.close(context, 'option2'),
        child: Text('Option 2'),
      ),
    ],
  ),
);
print('Selected option: $result');
```

See also:

- [VSideSheet], an overlay sheet that slides from the side
- [VSheet], a convenience class providing sheet-related static methods

### Constructors

#### `VBottomSheet`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content shown inside the sheet. |
| `title` | `Widget?` |  |  | Heading shown below the handle, usually a [Text]. |
| `showHandle` | `bool` | `true` |  | Whether to draw the drag handle at the top of the sheet. |
| `initialSize` | `double` | `0.5` |  | Starting height as a fraction of the screen height (0.0 - 1.0). |
| `minSize` | `double` | `0.25` |  | Smallest height fraction; releasing a drag below it closes the sheet. |
| `maxSize` | `double` | `0.9` |  | Largest height fraction reachable by dragging. |
| `snapPoints` | `List<double>?` |  |  | Height fractions the sheet snaps to, nearest first, when a drag ends. |
| `barrierDismissible` | `bool` | `true` |  | Whether tapping outside the sheet closes it. |
| `style` | `VSheetStyle?` |  |  | Style override. |

### Members

| Member | Description |
|---|---|
| `static Future<T?> show<T>(BuildContext context, {required Widget child, Widget? title, bool showHandle = true, double initialSize = 0.5, double minSize = 0.25, double maxSize = 0.9, List<double>? snapPoints, bool barrierDismissible = true, VSheetStyle? style})` | Shows a bottom sheet and completes with the value passed to [close]. |
| `static void close<T>(BuildContext context, [T? result])` | Closes the sheet.<br>Closes the current sheet and optionally returns a result value. |

## VSideSheet

Panel that slides in from the left or right edge, for filters and detail views.

```dart
VSideSheet.show(
  context,
  side: VSheetSide.right,
  width: 320,
  child: ListView(
    children: [
      VListTile(
        leading: Icon(Icons.home),
        title: Text('Home'),
        onTap: () => VSideSheet.close(context),
      ),
      VListTile(
        leading: Icon(Icons.settings),
        title: Text('Settings'),
        onTap: () => VSideSheet.close(context),
      ),
    ],
  ),
);
```

See also:

- [VBottomSheet], an overlay sheet that slides up from the bottom
- [VSheet], a convenience class providing sheet-related static methods

### Constructors

#### `VSideSheet`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes | Content shown inside the sheet. |
| `side` | `VSheetSide` | `VSheetSide.left` |  | Edge the sheet slides in from. Defaults to [VSheetSide.left]. |
| `width` | `double` | `280` |  | Sheet width in logical pixels. Defaults to 280. |
| `barrierDismissible` | `bool` | `true` |  | Whether tapping outside the sheet closes it. |
| `style` | `VSheetStyle?` |  |  | Style override. |

### Members

| Member | Description |
|---|---|
| `static Future<T?> show<T>(BuildContext context, {required Widget child, VSheetSide side = VSheetSide.left, double width = 280, bool barrierDismissible = true, VSheetStyle? style})` | Shows a side sheet and completes with the value passed to [close]. |
| `static void close<T>(BuildContext context, [T? result])` | Closes the sheet.<br>Closes the current sheet and optionally returns a result value. |

## VSheet

Overlay that slides in from a screen edge: [VSheet.bottom] or [VSheet.side].

```dart
final choice = await VSheet.showBottom<String>(
  context,
  VSheet.bottom(
    title: Text('Select an Option'),
    child: OptionsWidget(),
  ),
);
```

## Variants

### VSheet.bottom

A sheet that slides up from the bottom. Supports drag-to-resize.

```dart
VSheet.bottom(
  title: Text('Title'),
  showHandle: true,
  initialSize: 0.5,
  snapPoints: [0.3, 0.6, 0.9],
  child: ContentWidget(),
)
```

### VSheet.side

A sheet that slides from the side. Used for navigation drawers and similar patterns.

```dart
VSheet.side(
  side: VSheetSide.right,
  width: 320,
  child: FilterPanel(),
)
```

## Close with Result

```dart
final result = await VSheet.showBottom<String>(
  context,
  VSheet.bottom(
    child: Column(
      children: [
        VButton(
          onPressed: () => VSheet.close(context, 'option1'),
          child: Text('Option 1'),
        ),
      ],
    ),
  ),
);
```

See also:

- [VBottomSheet], the bottom sheet widget class
- [VSideSheet], the side sheet widget class

### Constructors

#### `VSheet`

Default constructor.

#### `VSheet.bottom`

Creates a bottom sheet.

Creates a sheet that slides up from the bottom.

```dart
VSheet.bottom(
  title: Text('Title'),
  child: ContentWidget(),
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes |  |
| `title` | `Widget?` |  |  |  |
| `showHandle` | `bool` | `true` |  |  |
| `initialSize` | `double` | `0.5` |  |  |
| `minSize` | `double` | `0.25` |  |  |
| `maxSize` | `double` | `0.9` |  |  |
| `snapPoints` | `List<double>?` |  |  |  |
| `barrierDismissible` | `bool` | `true` |  |  |
| `style` | `VSheetStyle?` |  |  |  |

#### `VSheet.side`

Creates a side sheet.

Creates a sheet that slides from the side.

```dart
VSheet.side(
  side: VSheetSide.right,
  width: 320,
  child: FilterPanel(),
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `child` | `Widget` |  | yes |  |
| `side` | `VSheetSide` | `VSheetSide.left` |  |  |
| `width` | `double` | `280` |  |  |
| `barrierDismissible` | `bool` | `true` |  |  |
| `style` | `VSheetStyle?` |  |  |  |

### Members

| Member | Description |
|---|---|
| `static Future<T?> showBottom<T>(BuildContext context, VBottomSheet sheet)` | Shows a bottom sheet.<br>Displays a sheet that slides up from the bottom. |
| `static Future<T?> showSide<T>(BuildContext context, VSideSheet sheet)` | Shows a side sheet.<br>Displays a sheet that slides from the side. |
| `static void close<T>(BuildContext context, [T? result])` | Closes the sheet.<br>Closes the currently open sheet. Works for both bottom sheets and side sheets. |

## VSheetSide

Side sheet direction.

Specifies the display direction of [VSideSheet]:
- [left] - Slides from the left (default)
- [right] - Slides from the right

### Values

| Value | Description |
|---|---|
| `left` | Slides from the left (default). |
| `right` | Slides from the right. |

## VSheetStyle

Style override for [VSheet].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VSheetStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `elevation` | `double?` |  |  | Elevation (shadow depth). |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |

### Members

| Member | Description |
|---|---|
| `VSheetStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, BorderRadius? borderRadius, double? elevation, EdgeInsets? padding})` | Creates a copy with only the specified properties changed. |
