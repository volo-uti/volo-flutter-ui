part of 'widgetbook_components.dart';

/// Widgetbook code block.
///
/// Displays copyable code examples with an optional preview.
class WidgetbookCodeBlock extends StatefulWidget {
  const WidgetbookCodeBlock({
    required this.title,
    required this.code,
    this.preview,
    this.fullWidth = false,
    this.language = 'dart',
    super.key,
  });

  /// Code block title.
  final String title;

  /// Code content.
  final String code;

  /// Preview widget (optional).
  final Widget? preview;

  /// When true, preview fills full width (for fullWidth demos).
  final bool fullWidth;

  /// Code language (default: dart).
  final String language;

  @override
  State<WidgetbookCodeBlock> createState() => _WidgetbookCodeBlockState();
}

class _WidgetbookCodeBlockState extends State<WidgetbookCodeBlock> {
  bool _copied = false;

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _copied = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + Copy button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: theme.typography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colors.foreground,
              ),
            ),
            GestureDetector(
              onTap: _copyToClipboard,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _copied ? Icons.check : Icons.copy,
                    size: 14,
                    color: theme.colors.mutedForeground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _copied ? 'Copied' : 'Copy',
                    style: theme.typography.bodySmall.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Preview (if available)
        if (widget.preview != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colors.card,
              border: Border.all(color: theme.colors.border),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: DefaultTextStyle(
              style: theme.typography.bodyMedium.copyWith(
                color: theme.colors.foreground,
                decoration: TextDecoration.none,
              ),
              child: widget.fullWidth
                  ? widget.preview!
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: widget.preview,
                    ),
            ),
          ),
        ],

        // Code block — no Stack/Positioned to avoid LayoutBuilder intrinsic dimension conflict
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colors.foreground,
            borderRadius: widget.preview != null
                ? const BorderRadius.vertical(bottom: Radius.circular(8))
                : BorderRadius.circular(8),
          ),
          child: Text(
            widget.code,
            style: TextStyle(
              fontFamily: theme.typography.fontFamilyMono,
              fontSize: 13,
              height: 1.5,
              color: theme.colors.background,
            ),
          ),
        ),
      ],
    );
  }
}
