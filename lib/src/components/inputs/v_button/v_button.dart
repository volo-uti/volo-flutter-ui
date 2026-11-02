import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/feedback/v_loading_spinner/v_loading_spinner.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_button_group/v_button_group.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_button_style.dart';

part 'v_button_variants.dart';

/// Keys that press a focused button.
const Map<ShortcutActivator, Intent> _activateShortcuts =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    };

/// Button size.
enum VButtonSize {
  /// Extra small size (24px).
  xs,

  /// Small size (32px).
  sm,

  /// Medium size (40px).
  md,

  /// Large size (48px).
  lg,

  /// Extra large size (56px).
  xl,
}

/// Button corner style.
enum VButtonCorner {
  /// Square corners.
  square,

  /// Rounded corners (default).
  rounded,

  /// Pill shape, fully rounded at any height.
  pill,

  /// Circle (for square buttons).
  circle,
}

/// Button color.
enum VButtonColor {
  /// Primary color.
  primary,

  /// Secondary color.
  secondary,

  /// Tertiary color.
  tertiary,

  /// Destructive/delete color.
  destructive,
}

/// Loading indicator position.
enum VButtonLoadingPosition {
  /// Center (hides child).
  center,

  /// Start (leading position).
  start,

  /// End (trailing position).
  end,
}

/// Button alignment.
enum VButtonAlign {
  /// Left alignment.
  left,

  /// Center alignment (default).
  center,

  /// Right alignment.
  right,
}

// WHY: Named constructors for variants (VButton.outlined, VButton.ghost, etc.)
// instead of a variant enum parameter — this matches Flutter's convention
// (e.g. TextButton, OutlinedButton) and enables const constructors while
// keeping the _variant field private. Consumers never see the internal enum.
/// Button with filled, outlined, text, ghost, icon and link variants.
///
/// Pass any widget as `child`; plain `Text` and `Icon` children are styled for you.
///
/// **Basic Usage:**
///
/// ```dart
/// VButton(
///   onPressed: () {},
///   child: Text('Save'),
/// )
/// ```
///
/// **Variants:**
///
/// - [VButton] - Default button (filled background)
/// - [VButton.outlined] - Outlined button
/// - [VButton.text] - Text button without background
/// - [VButton.ghost] - Ghost button (transparent, accent hover)
/// - [VButton.icon] - Square icon button
/// - [VButton.link] - Underlined link style
///
/// **With Icon:**
///
/// ```dart
/// VButton(
///   onPressed: () {},
///   leading: Icon(Icons.download),
///   child: Text('Download'),
/// )
/// ```
///
/// **Loading State:**
///
/// ```dart
/// VButton(
///   onPressed: () {},
///   loading: true,
///   child: Text('Saving...'),
/// )
/// ```
class VButton extends StatefulWidget {
  /// Creates a filled button.
  const VButton({
    required this.child,
    super.key,
    this.onPressed,
    this.onLongPress,
    this.leading,
    this.trailing,
    this.color = VButtonColor.primary,
    this.size,
    this.corner = VButtonCorner.rounded,
    this.align = VButtonAlign.center,
    this.leadingGap,
    this.trailingGap,
    this.fullWidth = false,
    this.enabled = true,
    this.loading = false,
    this.loadingIndicator,
    this.loadingPosition = VButtonLoadingPosition.center,
    this.tooltip,
    this.semanticLabel,
    this.style,
  }) : _variant = _VButtonVariant.filled;

  /// Creates an outlined button.
  const VButton.outlined({
    required this.child,
    super.key,
    this.onPressed,
    this.onLongPress,
    this.leading,
    this.trailing,
    this.color = VButtonColor.primary,
    this.size,
    this.corner = VButtonCorner.rounded,
    this.align = VButtonAlign.center,
    this.leadingGap,
    this.trailingGap,
    this.fullWidth = false,
    this.enabled = true,
    this.loading = false,
    this.loadingIndicator,
    this.loadingPosition = VButtonLoadingPosition.center,
    this.tooltip,
    this.semanticLabel,
    this.style,
  }) : _variant = _VButtonVariant.outlined;

  /// Creates a text button without background.
  const VButton.text({
    required this.child,
    super.key,
    this.onPressed,
    this.onLongPress,
    this.leading,
    this.trailing,
    this.color = VButtonColor.primary,
    this.size,
    this.corner = VButtonCorner.rounded,
    this.align = VButtonAlign.center,
    this.leadingGap,
    this.trailingGap,
    this.fullWidth = false,
    this.enabled = true,
    this.loading = false,
    this.loadingIndicator,
    this.loadingPosition = VButtonLoadingPosition.center,
    this.tooltip,
    this.semanticLabel,
    this.style,
  }) : _variant = _VButtonVariant.text;

  /// Creates a square button sized for an icon child.
  const VButton.icon({
    required this.child,
    super.key,
    this.onPressed,
    this.onLongPress,
    this.leading,
    this.trailing,
    this.color = VButtonColor.primary,
    this.size,
    this.corner = VButtonCorner.rounded,
    this.align = VButtonAlign.center,
    this.leadingGap,
    this.trailingGap,
    this.fullWidth = false,
    this.enabled = true,
    this.loading = false,
    this.loadingIndicator,
    this.loadingPosition = VButtonLoadingPosition.center,
    this.tooltip,
    this.semanticLabel,
    this.style,
  }) : _variant = _VButtonVariant.icon;

  /// Creates a transparent button that shows the accent color on hover.
  const VButton.ghost({
    required this.child,
    super.key,
    this.onPressed,
    this.onLongPress,
    this.leading,
    this.trailing,
    this.color = VButtonColor.primary,
    this.size,
    this.corner = VButtonCorner.rounded,
    this.align = VButtonAlign.center,
    this.leadingGap,
    this.trailingGap,
    this.fullWidth = false,
    this.enabled = true,
    this.loading = false,
    this.loadingIndicator,
    this.loadingPosition = VButtonLoadingPosition.center,
    this.tooltip,
    this.semanticLabel,
    this.style,
  }) : _variant = _VButtonVariant.ghost;

  /// Creates an underlined link-style button.
  const VButton.link({
    required this.child,
    super.key,
    this.onPressed,
    this.onLongPress,
    this.leading,
    this.trailing,
    this.color = VButtonColor.primary,
    this.size,
    this.corner = VButtonCorner.rounded,
    this.align = VButtonAlign.center,
    this.leadingGap,
    this.trailingGap,
    this.fullWidth = false,
    this.enabled = true,
    this.loading = false,
    this.loadingIndicator,
    this.loadingPosition = VButtonLoadingPosition.center,
    this.tooltip,
    this.semanticLabel,
    this.style,
  }) : _variant = _VButtonVariant.link;

  /// Content of the button; a plain `Text` or `Icon` picks up the button's
  /// color, size and weight.
  ///
  /// When the button is narrower than the label, the label wraps.
  final Widget child;

  /// Called when the button is tapped; `null` renders it disabled.
  final VoidCallback? onPressed;

  /// Called when the button is long-pressed; falls back to showing [tooltip].
  final VoidCallback? onLongPress;

  /// Widget shown before [child], typically an icon.
  final Widget? leading;

  /// Widget shown after [child], typically an icon.
  final Widget? trailing;

  /// Color role of the button.
  final VButtonColor color;

  /// Minimum height and text size preset.
  ///
  /// Defaults to the enclosing [VButtonGroup]'s size, else [VButtonSize.md].
  /// The height is a minimum: the button grows with the text scale and when a
  /// long label wraps onto more lines.
  final VButtonSize? size;

  /// Corner radius style.
  ///
  /// [VButtonCorner.rounded] takes [VButtonStyle.borderRadius] when one is set.
  final VButtonCorner corner;

  /// Horizontal alignment of the content inside the button.
  final VButtonAlign align;

  /// Gap between [leading] and [child].
  ///
  /// Wins over [VButtonStyle.gap]; defaults to the size's spacing token.
  final double? leadingGap;

  /// Gap between [child] and [trailing].
  ///
  /// Wins over [VButtonStyle.gap]; defaults to the size's spacing token.
  final double? trailingGap;

  /// Whether the button stretches to the full available width.
  final bool fullWidth;

  /// Whether the button reacts to input; `false` dims it and blocks presses.
  final bool enabled;

  /// Whether a loading indicator is shown and presses are blocked.
  final bool loading;

  /// Replaces the default spinner while [loading] is true.
  final Widget? loadingIndicator;

  /// Where the loading indicator appears relative to [child].
  final VButtonLoadingPosition loadingPosition;

  /// Text shown in a floating label on long press.
  final String? tooltip;

  /// Label announced by screen readers instead of the child's own text.
  final String? semanticLabel;

  /// Per-instance style override merged over the theme's [VButtonStyle].
  final VButtonStyle? style;

  final _VButtonVariant _variant;

  @override
  State<VButton> createState() => _VButtonState();
}
