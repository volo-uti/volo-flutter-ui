part of 'widgetbook_components.dart';

/// Playground layout mode.
enum PlaygroundLayout {
  /// Center aligned.
  center,

  /// Start (left) aligned.
  start,

  /// Stretch to full width.
  stretch,
}

/// Widgetbook playground.
///
/// An area for displaying components that can be controlled via Knobs.
/// Shows current configuration values as Info Chips at the bottom.
class WidgetbookPlayground extends StatelessWidget {
  const WidgetbookPlayground({
    required this.child,
    this.info = const [],
    this.padding = const EdgeInsets.all(24),
    this.layout = PlaygroundLayout.center,
    this.backgroundColor,
    super.key,
  });

  /// Component to display.
  final Widget child;

  /// List of information to display at the bottom.
  final List<String> info;

  /// Internal padding.
  final EdgeInsetsGeometry padding;

  /// Layout mode.
  final PlaygroundLayout layout;

  /// Background color (default: theme.colors.card).
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final bgColor = backgroundColor ?? theme.colors.card;

    return LayoutBuilder(
      builder: (context, constraints) {
        var content = child;

        // Handle ellipsis for Text widgets
        if (child is Text) {
          final t = child as Text;
          if (t.data != null) {
            content = Text(
              t.data!,
              key: t.key,
              style: t.style,
              strutStyle: t.strutStyle,
              textAlign: t.textAlign,
              textDirection: t.textDirection,
              locale: t.locale,
              softWrap: t.softWrap ?? true,
              textScaler: t.textScaler,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              semanticsLabel: t.semanticsLabel,
              textWidthBasis: t.textWidthBasis,
              textHeightBehavior: t.textHeightBehavior,
            );
          }
        }

        return DecoratedBox(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colors.border),
          ),
          child: Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Playground',
                  style: theme.typography.titleMedium.copyWith(
                    color: theme.colors.info,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                DefaultTextStyle(
                  style: theme.typography.bodyMedium.copyWith(
                    color: theme.colors.foreground,
                    decoration: TextDecoration.none,
                  ),
                  child: switch (layout) {
                    PlaygroundLayout.stretch => SizedBox(
                      width: double.infinity,
                      child: content,
                    ),
                    PlaygroundLayout.center => SizedBox(
                      width: double.infinity,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth,
                        ),
                        child: Center(child: content),
                      ),
                    ),
                    PlaygroundLayout.start => SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: content,
                      ),
                    ),
                  },
                ),
                if (info.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: info.map(_InfoChip.new).toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = VTheme.of(context).colors;
    if (label.contains('@fixed')) {
      return VChip(
        size: VChipSize.sm,
        label: Text(label.replaceAll('@fixed', '')),
      );
    }
    return VChip(
      size: VChipSize.sm,
      style: VChipStyle(
        backgroundColor: colors.info.withValues(alpha: 0.1),
        foregroundColor: colors.info,
      ),
      label: Text(label),
    );
  }
}
