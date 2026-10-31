import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_box_style.dart';

/// {@template v_box}
/// Box with padding, color, border or shadow around a child.
///
/// A [Container] whose defaults come from [VTheme] and from the variant:
/// the default box is transparent, [VBox.card], [VBox.outlined] and
/// [VBox.elevated] add the card color, a border or a shadow.
///
/// ## Basic Usage:
///
/// Default transparent box:
///
/// ```dart
/// VBox(
///   padding: EdgeInsets.all(16),
///   child: Text('Hello'),
/// )
/// ```
///
/// ## Variants:
///
/// - [VBox.new] - Default transparent box
/// - [VBox.card] - Card background + border
/// - [VBox.outlined] - Transparent background + border
/// - [VBox.elevated] - Card background + shadow
///
/// ## Card Style Box:
///
/// Card style box:
///
/// ```dart
/// VBox.card(
///   padding: EdgeInsets.all(16),
///   child: Column(
///     children: [
///       Text('Card Title'),
///       Text('Card content goes here'),
///     ],
///   ),
/// )
/// ```
///
/// ## Elevated Box:
///
/// Box with shadow effect:
///
/// ```dart
/// VBox.elevated(
///   padding: EdgeInsets.all(24),
///   borderRadius: BorderRadius.circular(16),
///   child: Text('Elevated content'),
/// )
/// ```
///
/// See also:
///
/// - [VSection], section container with header/footer
/// - [VStack], layout that arranges children in one direction
/// {@endtemplate}
class VBox extends StatelessWidget {
  /// {@macro v_box}
  ///
  /// Transparent box with no border or shadow.
  const VBox({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.color,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
    this.clipBehavior = Clip.none,
    this.style,
  }) : _variant = _VBoxVariant.none,
       _useCardBackground = false,
       _useBorder = false,
       _useShadow = false;

  /// Box with the card background color and a border.
  ///
  /// ```dart
  /// VBox.card(
  ///   padding: EdgeInsets.all(16),
  ///   child: Text('Card content'),
  /// )
  /// ```
  const VBox.card({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.color,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
    this.clipBehavior = Clip.antiAlias,
    this.style,
  }) : _variant = _VBoxVariant.card,
       _useCardBackground = true,
       _useBorder = true,
       _useShadow = false;

  /// Box with a border and a transparent background.
  ///
  /// ```dart
  /// VBox.outlined(
  ///   padding: EdgeInsets.all(12),
  ///   borderRadius: BorderRadius.circular(8),
  ///   child: Text('Outlined content'),
  /// )
  /// ```
  const VBox.outlined({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.color,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
    this.clipBehavior = Clip.antiAlias,
    this.style,
  }) : _variant = _VBoxVariant.outlined,
       _useCardBackground = false,
       _useBorder = true,
       _useShadow = false;

  /// Box with the card background color and a shadow.
  ///
  /// ```dart
  /// VBox.elevated(
  ///   padding: EdgeInsets.all(20),
  ///   child: Text('Elevated content'),
  /// )
  /// ```
  const VBox.elevated({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.color,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
    this.clipBehavior = Clip.antiAlias,
    this.style,
  }) : _variant = _VBoxVariant.elevated,
       _useCardBackground = true,
       _useBorder = false,
       _useShadow = true;

  /// Content placed inside the box.
  final Widget? child;

  /// Inner padding.
  final EdgeInsetsGeometry? padding;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  /// Background color; defaults to the variant color.
  final Color? color;

  /// Border; defaults to the variant border.
  final BoxBorder? border;

  /// Corner radius; defaults to `theme.radius.card` for the variants.
  final BorderRadiusGeometry? borderRadius;

  /// Shadows; defaults to the variant shadow.
  final List<BoxShadow>? boxShadow;

  /// Fixed width of the box.
  final double? width;

  /// Fixed height of the box.
  final double? height;

  /// Extra size constraints applied to the box.
  final BoxConstraints? constraints;

  /// How [child] is aligned inside the box.
  final AlignmentGeometry? alignment;

  /// How [child] is clipped to the box shape (the variants default to [Clip.antiAlias]).
  final Clip clipBehavior;

  /// Overrides the theme style for this box.
  final VBoxStyle? style;

  final _VBoxVariant _variant;
  final bool _useCardBackground;
  final bool _useBorder;
  final bool _useShadow;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Precedence: instance style > constructor argument > theme override >
    // variant default.
    final themeStyle = theme.componentOverrides.get<VBoxStyle>();
    final instanceStyle = style;

    final effectiveColor =
        instanceStyle?.backgroundColor ??
        color ??
        themeStyle?.backgroundColor ??
        (_useCardBackground ? theme.colors.card : null);

    final styleBorderColor =
        instanceStyle?.borderColor ??
        (border == null ? themeStyle?.borderColor : null);
    final effectiveBorder = styleBorderColor != null
        ? Border.all(color: styleBorderColor)
        : border ??
              (_useBorder ? Border.all(color: theme.colors.border) : null);

    final effectiveBorderRadius =
        instanceStyle?.borderRadius ??
        borderRadius ??
        themeStyle?.borderRadius ??
        (_variant != _VBoxVariant.none
            ? BorderRadius.circular(theme.radius.card)
            : null);

    final effectivePadding =
        instanceStyle?.padding ?? padding ?? themeStyle?.padding;

    final effectiveBoxShadow =
        boxShadow ?? (_useShadow ? theme.shadows.md : null);

    // Decoration
    final decoration = BoxDecoration(
      color: effectiveColor,
      border: effectiveBorder,
      borderRadius: effectiveBorderRadius,
      boxShadow: effectiveBoxShadow,
    );

    final Widget result = Container(
      width: width,
      height: height,
      padding: effectivePadding,
      margin: margin,
      constraints: constraints,
      alignment: alignment,
      clipBehavior: clipBehavior,
      decoration: decoration,
      child: child,
    );

    return result;
  }
}

/// VBox variant type.
enum _VBoxVariant {
  /// Default (transparent).
  none,

  /// Card style.
  card,

  /// Outlined only.
  outlined,

  /// Elevated effect.
  elevated,
}
