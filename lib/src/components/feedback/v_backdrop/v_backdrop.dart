import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_backdrop_style.dart';

/// Full-size scrim that dims the content behind a modal surface.
///
/// Fills its parent and reports taps, so it usually sits at the bottom of a
/// [Stack] under a dialog or drawer.
///
/// ```dart
/// Stack(
///   children: [
///     VBackdrop(onTap: () => setState(() => open = false)),
///     const Center(child: Text('Modal content')),
///   ],
/// )
/// ```
class VBackdrop extends StatelessWidget {
  /// Creates a backdrop filled with [color] at [opacity].
  const VBackdrop({
    super.key,
    this.onTap,
    this.color,
    this.opacity = 0.5,
    this.style,
  });

  /// Style override.
  final VBackdropStyle? style;

  /// Called when the backdrop is tapped, typically to close the surface above.
  final VoidCallback? onTap;

  /// Scrim color; defaults to the theme's scrim color.
  final Color? color;

  /// Opacity applied to the scrim color, from 0 to 1.
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VBackdropStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;
    final backdropColor = resolvedStyle?.color ?? color ?? theme.colors.scrim;

    // WHY: excludeSemantics on backdrop — the overlay is purely visual;
    // screen readers should focus on the modal content above, not announce
    // "Backdrop" during navigation. The semantic label exists for testing.
    return Semantics(
      label: VoloLocalizations.of(context).backdropLabel,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(color: backdropColor.withValues(alpha: opacity)),
      ),
    );
  }
}
