import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_avatar_style.dart';

/// Diameter presets for a [VAvatar].
enum VAvatarSize {
  /// 24px
  xs,

  /// 32px
  sm,

  /// 40px
  md,

  /// 48px
  lg,

  /// 64px
  xl,
}

/// Outline of a [VAvatar].
enum VAvatarShape {
  /// Circle.
  circle,

  /// Rounded rectangle.
  rounded,

  /// Square.
  square,
}

/// Round or rounded picture, initials or icon that identifies a person or entity.
///
/// Build it with [VAvatar.image], [VAvatar.text] or [VAvatar.icon]. When an
/// image fails to load, it falls back to [errorWidget], then the text or icon.
///
/// ```dart
/// VAvatar.image(
///   imageProvider: NetworkImage('https://example.com/avatar.jpg'),
///   size: VAvatarSize.lg,
///   semanticLabel: 'Kim Min',
///   onTap: openProfile,
/// )
/// ```
///
/// See also:
///
/// - [VAvatarGroup], which overlaps several avatars.
/// - [VAvatarSize] and [VAvatarShape], the size and shape presets.
class VAvatar extends StatefulWidget {
  /// Avatar showing a picture from an [ImageProvider].
  const VAvatar.image({
    required this.imageProvider,
    super.key,
    this.size = VAvatarSize.md,
    this.shape = VAvatarShape.circle,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.placeholder,
    this.errorWidget,
    this.semanticLabel,
    this.style,
  }) : text = null,
       icon = null;

  /// Avatar showing up to two uppercase initials.
  const VAvatar.text(
    this.text, {
    super.key,
    this.size = VAvatarSize.md,
    this.shape = VAvatarShape.circle,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.semanticLabel,
    this.style,
  }) : imageProvider = null,
       icon = null,
       placeholder = null,
       errorWidget = null;

  /// Avatar showing an icon.
  const VAvatar.icon(
    this.icon, {
    super.key,
    this.size = VAvatarSize.md,
    this.shape = VAvatarShape.circle,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.semanticLabel,
    this.style,
  }) : imageProvider = null,
       text = null,
       placeholder = null,
       errorWidget = null;

  /// Picture to show; null on text and icon avatars.
  final ImageProvider? imageProvider;

  /// Initials to show; only the first two user-perceived characters are used.
  final String? text;

  /// Icon to show; null on image and text avatars.
  final IconData? icon;

  /// Diameter preset of the avatar.
  final VAvatarSize size;

  /// Outline of the avatar.
  final VAvatarShape shape;

  /// Fill color behind the content; defaults to the muted color.
  final Color? backgroundColor;

  /// Color of the initials or icon; defaults to the muted foreground.
  final Color? foregroundColor;

  /// Called when the avatar is tapped; the avatar shrinks slightly while pressed.
  final VoidCallback? onTap;

  /// Widget shown while the image loads; defaults to a person icon.
  final Widget? placeholder;

  /// Widget shown when the image fails to load.
  final Widget? errorWidget;

  /// Label announced by screen readers.
  final String? semanticLabel;

  /// Per-instance style override merged over the theme style.
  final VAvatarStyle? style;

  @override
  State<VAvatar> createState() => _VAvatarState();
}

class _VAvatarState extends State<VAvatar> {
  bool _isPressed = false;
  bool _hasImageError = false;

  double get _diameter {
    final sizes = VTheme.of(context).sizes;
    switch (widget.size) {
      case VAvatarSize.xs:
        return sizes.xs.height;
      case VAvatarSize.sm:
        return sizes.sm.height;
      case VAvatarSize.md:
        return sizes.md.height;
      case VAvatarSize.lg:
        return sizes.lg.height;
      case VAvatarSize.xl:
        return sizes.xl.height;
    }
  }

  double get _fontSize {
    final sizes = VTheme.of(context).sizes;
    switch (widget.size) {
      case VAvatarSize.xs:
        return sizes.xs.fontSize;
      case VAvatarSize.sm:
        return sizes.sm.fontSize;
      case VAvatarSize.md:
        return sizes.md.fontSize;
      case VAvatarSize.lg:
        return sizes.lg.fontSize;
      case VAvatarSize.xl:
        return sizes.xl.fontSize;
    }
  }

  double get _iconSize {
    final sizes = VTheme.of(context).sizes;
    switch (widget.size) {
      case VAvatarSize.xs:
        return sizes.xs.iconSize;
      case VAvatarSize.sm:
        return sizes.sm.iconSize;
      case VAvatarSize.md:
        return sizes.md.iconSize;
      case VAvatarSize.lg:
        return sizes.lg.iconSize;
      case VAvatarSize.xl:
        return sizes.xl.iconSize;
    }
  }

  BorderRadius get _borderRadius {
    switch (widget.shape) {
      case VAvatarShape.circle:
        return BorderRadius.circular(_diameter / 2);
      case VAvatarShape.rounded:
        return VTheme.of(context).radius.mdRadius;
      case VAvatarShape.square:
        return BorderRadius.zero;
    }
  }

  @override
  void didUpdateWidget(VAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A new picture deserves a new try after the previous one failed.
    if (widget.imageProvider != oldWidget.imageProvider) {
      _hasImageError = false;
    }
  }

  String get _displayText {
    final text = widget.text;
    if (text == null) return '';
    // WHY: Cut on grapheme clusters, not UTF-16 units, so an emoji, a flag or a
    // letter with a combining mark is never split in half.
    return Characters(text).take(2).toString().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VAvatarStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;
    final colors = theme.colors;

    var bgColor = widget.backgroundColor ?? colors.muted;
    var fgColor = widget.foregroundColor ?? colors.mutedForeground;
    if (resolvedStyle != null) {
      bgColor = resolvedStyle.backgroundColor ?? bgColor;
      fgColor = resolvedStyle.foregroundColor ?? fgColor;
    }

    Widget content;

    if (widget.imageProvider != null && !_hasImageError) {
      content = Image(
        image: widget.imageProvider!,
        width: _diameter,
        height: _diameter,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _hasImageError = true;
              });
            }
          });
          // Return the same fallback content as _hasImageError = true state (prevents flickering)
          return _buildFallbackContent(fgColor);
        },
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }
          return widget.placeholder ?? _buildFallbackIcon(fgColor);
        },
      );
    } else if (_hasImageError) {
      // Image load failed - fallback including errorWidget
      content = _buildFallbackContent(fgColor);
    } else if (widget.text != null) {
      content = Text(
        _displayText,
        style: TextStyle(
          fontSize: _fontSize,
          fontWeight: FontWeight.w600,
          color: fgColor,
        ),
      );
    } else if (widget.icon != null) {
      content = Icon(widget.icon, size: _iconSize, color: fgColor);
    } else {
      content = _buildFallbackIcon(fgColor);
    }

    Widget avatar = AnimatedContainer(
      duration: theme.animations.fast,
      curve: theme.animations.curveEaseOut,
      width: _diameter,
      height: _diameter,
      transform: _isPressed
          ? (Matrix4.identity()..scaleByDouble(0.95, 0.95, 1, 1))
          : Matrix4.identity(),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: resolvedStyle?.borderRadius ?? _borderRadius,
        border: resolvedStyle?.borderColor != null
            ? Border.all(color: resolvedStyle!.borderColor!)
            : null,
      ),
      child: ClipRRect(
        borderRadius: resolvedStyle?.borderRadius ?? _borderRadius,
        child: Center(child: content),
      ),
    );

    if (widget.onTap != null) {
      avatar = GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: avatar,
      );
    }

    if (widget.semanticLabel != null) {
      avatar = Semantics(
        image: widget.imageProvider != null,
        button: widget.onTap != null,
        label: widget.semanticLabel,
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _buildFallbackIcon(Color color) =>
      VIcons.person(size: _iconSize, color: color);

  /// Fallback content displayed when image loading fails.
  ///
  /// Priority order: errorWidget > text > icon > fallback icon.
  Widget _buildFallbackContent(Color fgColor) {
    if (widget.errorWidget != null) return widget.errorWidget!;
    if (widget.text != null) {
      return Text(
        _displayText,
        style: TextStyle(
          fontSize: _fontSize,
          fontWeight: FontWeight.w600,
          color: fgColor,
        ),
      );
    }
    if (widget.icon != null) {
      return Icon(widget.icon, size: _iconSize, color: fgColor);
    }
    return _buildFallbackIcon(fgColor);
  }
}

/// Row of overlapping avatars with a "+N" tile for the ones that do not fit.
///
/// ```dart
/// VAvatarGroup(
///   max: 3,
///   overlap: 0.3,
///   children: [
///     VAvatar.text('A'),
///     VAvatar.text('B'),
///     VAvatar.text('C'),
///     VAvatar.text('D'), // Counted in the "+1" tile.
///   ],
/// )
/// ```
class VAvatarGroup extends StatelessWidget {
  /// Creates a group of overlapping avatars.
  const VAvatarGroup({
    required this.children,
    super.key,
    this.max = 4,
    this.overlap = 0.3,
    this.size = VAvatarSize.md,
  });

  /// Avatars to show, in order.
  final List<VAvatar> children;

  /// Number of avatars shown before the rest collapse into a "+N" tile.
  ///
  /// A negative value counts as 0, so every avatar collapses into the tile.
  final int max;

  /// Fraction of each avatar covered by the next one, from 0 to 1.
  final double overlap;

  /// Diameter preset of every avatar in the group.
  ///
  /// Each avatar is drawn at this diameter, whatever its own size says.
  final VAvatarSize size;

  double _diameterOf(BuildContext context) {
    final sizes = VTheme.of(context).sizes;
    switch (size) {
      case VAvatarSize.xs:
        return sizes.xs.height;
      case VAvatarSize.sm:
        return sizes.sm.height;
      case VAvatarSize.md:
        return sizes.md.height;
      case VAvatarSize.lg:
        return sizes.lg.height;
      case VAvatarSize.xl:
        return sizes.xl.height;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final colors = theme.colors;

    final diameter = _diameterOf(context);
    final displayCount = max.clamp(0, children.length);
    final remainingCount = children.length - displayCount;
    final overlapOffset = diameter * (1 - overlap);

    return SizedBox(
      width:
          overlapOffset * displayCount +
          diameter * overlap +
          (remainingCount > 0 ? overlapOffset : 0),
      height: diameter,
      child: Stack(
        children: [
          for (int i = 0; i < displayCount; i++)
            Positioned(
              left: i * overlapOffset,
              // The ring is painted inside the avatar's box, so the group keeps
              // its measured size and the ring is not clipped by the Stack.
              child: Container(
                width: diameter,
                height: diameter,
                foregroundDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.background, width: 2),
                ),
                child: children[i],
              ),
            ),
          if (remainingCount > 0)
            Positioned(
              left: displayCount * overlapOffset,
              child: Container(
                width: diameter,
                height: diameter,
                decoration: BoxDecoration(
                  color: colors.muted,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.background, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+$remainingCount',
                    style: TextStyle(
                      fontSize: diameter * 0.3,
                      fontWeight: FontWeight.w600,
                      color: colors.mutedForeground,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
