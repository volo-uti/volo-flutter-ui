# VPopover

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VPopover

Floating panel with interactive content that opens next to its trigger.

Unlike [VTooltip], the content can hold buttons and forms.

```dart
VPopover(
  position: VPopoverPosition.bottomStart,
  content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Popover Title'),
      SizedBox(height: 8),
      Text('Popover content goes here.'),
    ],
  ),
  child: VButton(
    onPressed: null, // the popover opens on tap
    child: Text('Open'),
  ),
)
```

**Positions:**

- [VPopoverPosition.top] - Top center
- [VPopoverPosition.topStart] - Top start
- [VPopoverPosition.topEnd] - Top end
- [VPopoverPosition.bottom] - Bottom center (default)
- [VPopoverPosition.bottomStart] - Bottom start
- [VPopoverPosition.bottomEnd] - Bottom end
- [VPopoverPosition.left] - Left center
- [VPopoverPosition.right] - Right center

**With Controller:**

```dart
final _controller = VPopoverController();

VPopover(
  controller: _controller,
  content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Menu'),
      VButton(
        onPressed: () {
          _controller.hide();
          // Perform action
        },
        child: Text('Select'),
      ),
    ],
  ),
  child: VButton(onPressed: null, child: Text('Menu')),
)
```

**Custom Position:**

```dart
VPopover(
  position: VPopoverPosition.topEnd,
  offset: Offset(0, 12),
  content: Text('Displayed at top end'),
  child: VButton(onPressed: null, child: Text('Open')),
)
```

See also:

- [VPopoverController], programmatic control for the popover
- [VPopoverPosition], popover position enum
- [VTooltip], a simple overlay for informational text

### Constructors

#### `VPopover`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `content` | `Widget` |  | yes | Interactive content shown inside the popover. |
| `child` | `Widget` |  | yes | Trigger widget that anchors the popover and opens it when tapped. |
| `controller` | `VPopoverController?` |  |  | Opens and closes the popover from code; an internal one is created when null. |
| `position` | `VPopoverPosition` | `VPopoverPosition.bottom` |  | Where the popover appears relative to [child]. Defaults to [VPopoverPosition.bottom]. |
| `offset` | `Offset` | `const Offset(0, 8)` |  | Gap between [child] and the popover. Defaults to `Offset(0, 8)`. |
| `barrierDismissible` | `bool` | `true` |  | Whether tapping outside the popover, or pressing Escape, closes it. |
| `barrierColor` | `Color?` |  |  | Color painted behind the popover while open; transparent when null. |
| `triggerOnTap` | `bool` | `true` |  | Whether tapping [child] toggles the popover; set to `false` to use only [controller]. |
| `style` | `VPopoverStyle?` |  |  | Style override. |

## VPopoverPosition

Popover position.

Specifies where the popover is displayed relative to the trigger widget.

### Values

| Value | Description |
|---|---|
| `top` | Top center. |
| `topStart` | Top start (left in LTR, right in RTL). |
| `topEnd` | Top end (right in LTR, left in RTL). |
| `bottom` | Bottom center. |
| `bottomStart` | Bottom start (left in LTR, right in RTL). |
| `bottomEnd` | Bottom end (right in LTR, left in RTL). |
| `left` | Left center. |
| `right` | Right center. |

## VPopoverController

Popover controller.

Programmatically controls the open/close state of a popover.

**Basic Usage:**

```dart
final controller = VPopoverController();

// Open the popover
controller.show();

// Close the popover
controller.hide();

// Toggle the popover
controller.toggle();

// Check the state
if (controller.isOpen) {
  print('Popover is open.');
}
```

**With VPopover:**

```dart
final _popoverController = VPopoverController();

VPopover(
  controller: _popoverController,
  content: Text('Popover content'),
  child: VButton(
    onPressed: null, // Controlled via controller
    child: Text('Open'),
  ),
)

// Open from elsewhere
_popoverController.show();
```

### Constructors

#### `VPopoverController`

### Members

| Member | Description |
|---|---|
| `bool get isOpen` | Whether the popover is open. |
| `void show()` | Opens the popover.<br>Does nothing if already open. |
| `void hide()` | Closes the popover.<br>Does nothing if already closed. |
| `void toggle()` | Toggles the popover.<br>Opens if closed, closes if open. |
| `void rebuild()` | Rebuilds the OverlayEntry.<br>Call when the popover content has changed. |

## VPopoverStyle

Style override for [VPopover].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VPopoverStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `shadows` | `List<BoxShadow>?` |  |  | Shadows under the popover panel; the theme's medium shadow when null.<br>An empty list draws no shadow. An instance style wins over the theme override. |
| `padding` | `EdgeInsets?` |  |  | Internal padding. |

### Members

| Member | Description |
|---|---|
| `VPopoverStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, BorderRadius? borderRadius, List<BoxShadow>? shadows, EdgeInsets? padding})` | Creates a copy with only the specified properties changed. |
