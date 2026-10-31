# v_animations

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VAnimations

Durations and curves used by component animations.

Defines consistent animation values used throughout the app.

### Constructors

#### `VAnimations`

Creates animation tokens.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `instant` | `Duration` |  | yes | 0ms - Instant (toggle). |
| `micro` | `Duration` |  | yes | 75ms - Micro transition (opacity, tooltip). |
| `fast` | `Duration` |  | yes | 150ms - Fast transition (hover, focus). |
| `normal` | `Duration` |  | yes | 300ms - Default transition (page, modal). |
| `slow` | `Duration` |  | yes | 500ms - Slow transition (complex animations). |
| `slower` | `Duration` |  | yes | 700ms - Slower transition (complex page animations). |
| `verySlow` | `Duration` |  | yes | 1000ms - Very slow (loading, fade-in). |
| `extraSlow` | `Duration` |  | yes | 1500ms - Extra slow (skeleton, progress). |
| `snackbar` | `Duration` |  | yes | 4000ms - Snackbar display duration. |
| `toast` | `Duration` |  | yes | 5000ms - Toast display duration. |
| `curveLinear` | `Curve` |  | yes | Linear curve - constant speed. |
| `curveEaseIn` | `Curve` |  | yes | Ease-in curve - acceleration. |
| `curveEaseOut` | `Curve` |  | yes | Ease-out curve - deceleration. |
| `curveSmooth` | `Curve` |  | yes | Smooth curve (easeInOut) - breathing animation. |
| `curveDefault` | `Curve` |  | yes | Default curve (easeOutCubic) - natural deceleration. |
| `curveBouncy` | `Curve` |  | yes | Bouncy curve (elasticOut) - playful spring effect.<br>Flutter-only: a compound curve not expressible via cubic-bezier. Used for button taps, card entrances, and app-specific feel. |

#### `VAnimations.lerp`

Interpolates between two animation systems (for transitions).

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `a` | `VAnimations` |  | yes |  |
| `b` | `VAnimations` |  | yes |  |
| `t` | `double` |  | yes |  |

### Members

| Member | Description |
|---|---|
| `static VAnimations defaults` | Default animation values.<br>Duration/Curve values sourced from DTCG tokens via [VAnimationsDefaults]. [curveBouncy] is Flutter-only (not expressible in cubic-bezier). |
| `VAnimations copyWith({Duration? instant, Duration? micro, Duration? fast, Duration? normal, Duration? slow, Duration? slower, Duration? verySlow, Duration? extraSlow, Duration? snackbar, Duration? toast, Curve? curveLinear, Curve? curveEaseIn, Curve? curveEaseOut, Curve? curveSmooth, Curve? curveDefault, Curve? curveBouncy})` | Creates a copy with only the specified properties changed. |
