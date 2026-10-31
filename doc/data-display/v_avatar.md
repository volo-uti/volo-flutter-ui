# VAvatar, VAvatarGroup

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VAvatar

Round or rounded picture, initials or icon that identifies a person or entity.

Build it with [VAvatar.image], [VAvatar.text] or [VAvatar.icon]. When an
image fails to load, it falls back to [errorWidget], then the text or icon.

```dart
VAvatar.image(
  imageProvider: NetworkImage('https://example.com/avatar.jpg'),
  size: VAvatarSize.lg,
  semanticLabel: 'Kim Min',
  onTap: openProfile,
)
```

See also:

- [VAvatarGroup], which overlaps several avatars.
- [VAvatarSize] and [VAvatarShape], the size and shape presets.

### Constructors

#### `VAvatar.image`

Avatar showing a picture from an [ImageProvider].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `imageProvider` | `ImageProvider<Object>?` |  | yes | Picture to show; null on text and icon avatars. |
| `size` | `VAvatarSize` | `VAvatarSize.md` |  | Diameter preset of the avatar. |
| `shape` | `VAvatarShape` | `VAvatarShape.circle` |  | Outline of the avatar. |
| `backgroundColor` | `Color?` |  |  | Fill color behind the content; defaults to the muted color. |
| `foregroundColor` | `Color?` |  |  | Color of the initials or icon; defaults to the muted foreground. |
| `onTap` | `void Function()?` |  |  | Called when the avatar is tapped; the avatar shrinks slightly while pressed. |
| `placeholder` | `Widget?` |  |  | Widget shown while the image loads; defaults to a person icon. |
| `errorWidget` | `Widget?` |  |  | Widget shown when the image fails to load. |
| `semanticLabel` | `String?` |  |  | Label announced by screen readers. |
| `style` | `VAvatarStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VAvatar.text`

Avatar showing up to two uppercase initials.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `text` | `String?` |  | yes | Initials to show; only the first two user-perceived characters are used. |
| `size` | `VAvatarSize` | `VAvatarSize.md` |  | Diameter preset of the avatar. |
| `shape` | `VAvatarShape` | `VAvatarShape.circle` |  | Outline of the avatar. |
| `backgroundColor` | `Color?` |  |  | Fill color behind the content; defaults to the muted color. |
| `foregroundColor` | `Color?` |  |  | Color of the initials or icon; defaults to the muted foreground. |
| `onTap` | `void Function()?` |  |  | Called when the avatar is tapped; the avatar shrinks slightly while pressed. |
| `semanticLabel` | `String?` |  |  | Label announced by screen readers. |
| `style` | `VAvatarStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VAvatar.icon`

Avatar showing an icon.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `icon` | `IconData?` |  | yes | Icon to show; null on image and text avatars. |
| `size` | `VAvatarSize` | `VAvatarSize.md` |  | Diameter preset of the avatar. |
| `shape` | `VAvatarShape` | `VAvatarShape.circle` |  | Outline of the avatar. |
| `backgroundColor` | `Color?` |  |  | Fill color behind the content; defaults to the muted color. |
| `foregroundColor` | `Color?` |  |  | Color of the initials or icon; defaults to the muted foreground. |
| `onTap` | `void Function()?` |  |  | Called when the avatar is tapped; the avatar shrinks slightly while pressed. |
| `semanticLabel` | `String?` |  |  | Label announced by screen readers. |
| `style` | `VAvatarStyle?` |  |  | Per-instance style override merged over the theme style. |

## VAvatarGroup

Row of overlapping avatars with a "+N" tile for the ones that do not fit.

```dart
VAvatarGroup(
  max: 3,
  overlap: 0.3,
  children: [
    VAvatar.text('A'),
    VAvatar.text('B'),
    VAvatar.text('C'),
    VAvatar.text('D'), // Counted in the "+1" tile.
  ],
)
```

### Constructors

#### `VAvatarGroup`

Creates a group of overlapping avatars.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `children` | `List<VAvatar>` |  | yes | Avatars to show, in order. |
| `max` | `int` | `4` |  | Number of avatars shown before the rest collapse into a "+N" tile.<br>A negative value counts as 0, so every avatar collapses into the tile. |
| `overlap` | `double` | `0.3` |  | Fraction of each avatar covered by the next one, from 0 to 1. |
| `size` | `VAvatarSize` | `VAvatarSize.md` |  | Diameter preset of every avatar in the group.<br>Each avatar is drawn at this diameter, whatever its own size says. |

## VAvatarSize

Diameter presets for a [VAvatar].

### Values

| Value | Description |
|---|---|
| `xs` | 24px |
| `sm` | 32px |
| `md` | 40px |
| `lg` | 48px |
| `xl` | 64px |

## VAvatarShape

Outline of a [VAvatar].

### Values

| Value | Description |
|---|---|
| `circle` | Circle. |
| `rounded` | Rounded rectangle. |
| `square` | Square. |

## VAvatarStyle

Style override for [VAvatar].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VAvatarStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text / icon foreground color. |
| `borderColor` | `Color?` |  |  | Border color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |

### Members

| Member | Description |
|---|---|
| `VAvatarStyle copyWith({Color? backgroundColor, Color? foregroundColor, Color? borderColor, BorderRadius? borderRadius})` | Creates a copy with only the specified properties changed. |
