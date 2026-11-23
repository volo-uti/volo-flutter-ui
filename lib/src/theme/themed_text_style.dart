import 'package:flutter/widgets.dart';

import 'v_theme.dart';

/// A [DefaultTextStyle] that replaces the inherited style and keeps the theme font.
///
/// A plain [DefaultTextStyle] drops the family the theme gives the text above
/// it, so widgets that reset the inherited style use this instead. A style that
/// names its own family keeps it, and without a theme family nothing changes.
class ThemedDefaultTextStyle extends StatelessWidget {
  /// Creates a default text style that adds the theme font family.
  const ThemedDefaultTextStyle({
    required this.style,
    required this.child,
    super.key,
    this.textAlign,
  });

  /// Style that replaces the inherited default text style.
  final TextStyle style;

  /// How wrapped lines align.
  final TextAlign? textAlign;

  /// Widget below, whose text uses [style].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final family = VTheme.maybeOf(context)?.typography.fontFamily;
    return DefaultTextStyle(
      style: family == null || style.fontFamily != null
          ? style
          : style.copyWith(fontFamily: family),
      textAlign: textAlign,
      child: child,
    );
  }
}
