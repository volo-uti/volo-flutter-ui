# VBadge

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VBadge

Small pill that shows a status or a short count.

Each named constructor picks a color variant: [VBadge.primary],
[VBadge.secondary], [VBadge.success], [VBadge.warning],
[VBadge.destructive] and [VBadge.outline]. The default is muted.
[VBadge.count] shows a number and caps it at `max`, as in `99+`.

```dart
Row(
  spacing: 8,
  children: [
    VBadge.success(label: Text('Active')),
    VBadge.count(
      count: 120, // Shows '99+'.
      size: VBadgeSize.sm,
      semanticLabel: 'Many unread messages',
    ),
  ],
)
```

See also:

- [VBadgeSize], the badge sizes.

### Constructors

#### `VBadge`

Muted badge on a neutral background.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `Widget` |  | yes | Content shown inside the badge, usually a short [Text].<br>The foreground color, font size and weight come from the badge, so a plain [Text] needs no style. |
| `size` | `VBadgeSize` | `VBadgeSize.md` |  | Height preset of the badge. |
| `invisible` | `bool` | `false` |  | Whether the badge is hidden and takes no space. |
| `semanticLabel` | `String?` |  |  | Screen reader label that replaces the text of [label]. |
| `style` | `VBadgeStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VBadge.primary`

Badge in the primary color.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `Widget` |  | yes | Content shown inside the badge, usually a short [Text].<br>The foreground color, font size and weight come from the badge, so a plain [Text] needs no style. |
| `size` | `VBadgeSize` | `VBadgeSize.md` |  | Height preset of the badge. |
| `invisible` | `bool` | `false` |  | Whether the badge is hidden and takes no space. |
| `semanticLabel` | `String?` |  |  | Screen reader label that replaces the text of [label]. |
| `style` | `VBadgeStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VBadge.secondary`

Badge in the secondary color.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `Widget` |  | yes | Content shown inside the badge, usually a short [Text].<br>The foreground color, font size and weight come from the badge, so a plain [Text] needs no style. |
| `size` | `VBadgeSize` | `VBadgeSize.md` |  | Height preset of the badge. |
| `invisible` | `bool` | `false` |  | Whether the badge is hidden and takes no space. |
| `semanticLabel` | `String?` |  |  | Screen reader label that replaces the text of [label]. |
| `style` | `VBadgeStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VBadge.success`

Badge in the success color.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `Widget` |  | yes | Content shown inside the badge, usually a short [Text].<br>The foreground color, font size and weight come from the badge, so a plain [Text] needs no style. |
| `size` | `VBadgeSize` | `VBadgeSize.md` |  | Height preset of the badge. |
| `invisible` | `bool` | `false` |  | Whether the badge is hidden and takes no space. |
| `semanticLabel` | `String?` |  |  | Screen reader label that replaces the text of [label]. |
| `style` | `VBadgeStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VBadge.warning`

Badge in the warning color.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `Widget` |  | yes | Content shown inside the badge, usually a short [Text].<br>The foreground color, font size and weight come from the badge, so a plain [Text] needs no style. |
| `size` | `VBadgeSize` | `VBadgeSize.md` |  | Height preset of the badge. |
| `invisible` | `bool` | `false` |  | Whether the badge is hidden and takes no space. |
| `semanticLabel` | `String?` |  |  | Screen reader label that replaces the text of [label]. |
| `style` | `VBadgeStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VBadge.destructive`

Badge in the destructive color.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `Widget` |  | yes | Content shown inside the badge, usually a short [Text].<br>The foreground color, font size and weight come from the badge, so a plain [Text] needs no style. |
| `size` | `VBadgeSize` | `VBadgeSize.md` |  | Height preset of the badge. |
| `invisible` | `bool` | `false` |  | Whether the badge is hidden and takes no space. |
| `semanticLabel` | `String?` |  |  | Screen reader label that replaces the text of [label]. |
| `style` | `VBadgeStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VBadge.outline`

Transparent badge with a border.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `label` | `Widget` |  | yes | Content shown inside the badge, usually a short [Text].<br>The foreground color, font size and weight come from the badge, so a plain [Text] needs no style. |
| `size` | `VBadgeSize` | `VBadgeSize.md` |  | Height preset of the badge. |
| `invisible` | `bool` | `false` |  | Whether the badge is hidden and takes no space. |
| `semanticLabel` | `String?` |  |  | Screen reader label that replaces the text of [label]. |
| `style` | `VBadgeStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VBadge.count`

Destructive badge showing [count], or `'$max+'` when it exceeds [max].

A negative [count] shows as 0 and a [max] below 1 counts as 1.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `count` | `int` |  | yes |  |
| `max` | `int` | `99` |  |  |
| `size` | `VBadgeSize` | `VBadgeSize.md` |  | Height preset of the badge. |
| `invisible` | `bool` | `false` |  | Whether the badge is hidden and takes no space. |
| `semanticLabel` | `String?` |  |  | Screen reader label that replaces the text of [label]. |
| `style` | `VBadgeStyle?` |  |  | Per-instance style override merged over the theme style. |

## VBadgeSize

Height presets for a [VBadge].

### Values

| Value | Description |
|---|---|
| `sm` | Small size (18px). |
| `md` | Medium size (22px). |
| `lg` | Large size (26px). |

## VBadgeStyle

Style override for [VBadge].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VBadgeStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `backgroundColor` | `Color?` |  |  | Background fill color. |
| `foregroundColor` | `Color?` |  |  | Text foreground color. |
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `textStyle` | `TextStyle?` |  |  | Text style. |

### Members

| Member | Description |
|---|---|
| `VBadgeStyle copyWith({Color? backgroundColor, Color? foregroundColor, BorderRadius? borderRadius, TextStyle? textStyle})` | Creates a copy with only the specified properties changed. |
