part of 'widgetbook_components.dart';

/// Widgetbook section.
///
/// A section that groups and displays components together.
class WidgetbookSection extends StatelessWidget {
  const WidgetbookSection({
    required this.title,
    required this.children,
    this.description,
    this.spacing = 16,
    super.key,
  });

  /// Section title.
  final String title;

  /// Section description (optional).
  final String? description;

  /// List of child widgets.
  final List<Widget> children;

  /// Spacing between child widgets.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.typography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colors.foreground,
          ),
        ),
        if (description != null && description!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            description!,
            style: theme.typography.bodySmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
        SizedBox(height: spacing),
        for (int i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1) SizedBox(height: spacing),
        ],
      ],
    );
  }
}

/// Widgetbook subsection.
///
/// A labeled subsection with a diagonal hatch background.
class WidgetbookSubsection extends StatelessWidget {
  const WidgetbookSubsection({
    required this.title,
    required this.labels,
    required this.children,
    this.spacing = 16,
    this.fullWidth = false,
    super.key,
  });

  /// Subsection title.
  final String title;

  /// List of type labels.
  final List<String> labels;

  /// Content widgets.
  final List<Widget> children;

  /// Spacing between title and content.
  final double spacing;

  /// When true, children fill the full width (Column layout instead of Wrap).
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '$title = ',
              style: theme.typography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colors.foreground,
              ),
            ),
            for (int i = 0; i < labels.length; i++) _TypeLabel(labels[i]),
          ],
        ),
        SizedBox(height: spacing),
        _buildContentArea(theme),
      ],
    );
  }

  Widget _buildContentArea(VThemeData theme) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CustomPaint(
        painter: _DiagonalHatchPainter(
          background: theme.colors.card,
          hatchColor: theme.colors.border.withValues(alpha: 0.3),
          hatchSpacing: 16,
          hatchStrokeWidth: 1,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: DefaultTextStyle(
              style: theme.typography.bodyMedium.copyWith(
                color: theme.colors.foreground,
                decoration: TextDecoration.none,
              ),
              child: fullWidth
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int i = 0; i < children.length; i++) ...[
                          children[i],
                          if (i < children.length - 1)
                            const SizedBox(height: 12),
                        ],
                      ],
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        // WHY: a widget that reads its constraints (LayoutBuilder)
                        // cannot be measured by IntrinsicWidth, so cap the width.
                        children: children
                            .map(
                              (child) => ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 360,
                                ),
                                child: child,
                              ),
                            )
                            .toList(),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );

    return content;
  }
}

/// Foundation table header cell.
///
/// Styled header cell for design token showcase tables.
class FoundationTableHeader extends StatelessWidget {
  const FoundationTableHeader(this.text, {super.key});

  /// Header label text.
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        text,
        style: theme.typography.labelMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colors.foreground,
        ),
      ),
    );
  }
}

class _TypeLabel extends StatelessWidget {
  const _TypeLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.muted,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: theme.typography.labelSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colors.foreground,
          ),
        ),
      ),
    );
  }
}

class _DiagonalHatchPainter extends CustomPainter {
  const _DiagonalHatchPainter({
    required this.background,
    required this.hatchColor,
    this.hatchSpacing = 10,
    this.hatchStrokeWidth = 0.125,
  });

  final Color background;
  final Color hatchColor;
  final double hatchSpacing;
  final double hatchStrokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = background;
    canvas.drawRect(Offset.zero & size, bg);

    final line = Paint()
      ..color = hatchColor
      ..strokeWidth = hatchStrokeWidth;

    // Exact 45-degree '/' direction diagonal hatch
    canvas
      ..save()
      ..rotate(-math.pi / 4);
    final width = size.width;
    final height = size.height;
    final diag = math.sqrt(width * width + height * height);
    for (var y = -diag; y <= diag; y += hatchSpacing) {
      final p1 = Offset(-diag, y);
      final p2 = Offset(diag, y);
      canvas.drawLine(p1, p2, line);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DiagonalHatchPainter oldDelegate) =>
      background != oldDelegate.background ||
      hatchColor != oldDelegate.hatchColor ||
      hatchSpacing != oldDelegate.hatchSpacing ||
      hatchStrokeWidth != oldDelegate.hatchStrokeWidth;
}
