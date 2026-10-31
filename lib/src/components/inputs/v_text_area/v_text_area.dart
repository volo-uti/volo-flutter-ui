import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_form_field/v_form_field.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_text_area_style.dart';

/// Multi-line text input with label, helper text and optional character counter.
///
/// For a single line use VTextField.
///
/// **Basic Usage:**
///
/// ```dart
/// VTextArea(
///   label: 'Content',
///   placeholder: 'Enter content',
///   onChanged: (value) {},
/// )
/// ```
///
/// **With Line Limits:**
///
/// ```dart
/// VTextArea(
///   label: 'Memo',
///   minLines: 3,
///   maxLines: 10,
///   maxLength: 500,
///   showCounter: true,
/// )
/// ```
///
/// See also:
/// - [VTextField] - Single-line text input
class VTextArea extends StatefulWidget {
  /// Creates a text area.
  const VTextArea({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.more,
    this.tooltip,
    this.placeholder,
    this.helper,
    this.error = false,
    this.errorText,
    this.success = false,
    this.successText,
    this.extra,
    this.minLines = 3,
    this.maxLines,
    this.maxLength,
    this.showCounter = false,
    this.enabled = true,
    this.readOnly = false,
    this.fullWidth = false,
    this.required = false,
    this.requiredMark = '*',
    this.onChanged,
    this.onSubmitted,
    this.semanticLabel,
    this.style,
  });

  /// Controller for the text; the field creates one when null.
  final TextEditingController? controller;

  /// Focus node; the field creates one when null.
  final FocusNode? focusNode;

  /// Label text shown above the field.
  final String? label;

  /// Note shown at the right end of the label row.
  final String? more;

  /// Widget shown next to the label, typically a help icon.
  final Widget? tooltip;

  /// Hint text shown while the field is empty.
  final String? placeholder;

  /// Helper text shown below the field.
  final String? helper;

  /// Whether the field shows [errorText] and the error border.
  final bool error;

  /// Error message, shown when [error] is true.
  final String? errorText;

  /// Whether the field shows [successText] and the success border.
  final bool success;

  /// Success message, shown when [success] is true.
  final String? successText;

  /// Note that stays visible below the message.
  final String? extra;

  /// Minimum number of lines.
  final int minLines;

  /// Maximum number of lines (null for unlimited).
  final int? maxLines;

  /// Maximum character count.
  final int? maxLength;

  /// Whether to show a `current/max` counter below the field.
  final bool showCounter;

  /// Whether the text area accepts input. When false it is dimmed and ignores taps.
  final bool enabled;

  /// Whether the text can be selected but not edited.
  final bool readOnly;

  /// Whether the field stretches to the available width.
  final bool fullWidth;

  /// Whether to show [requiredMark] after the label.
  final bool required;

  /// Character shown after the label when [required] is true.
  final String requiredMark;

  /// Called with the new text on every edit.
  final ValueChanged<String>? onChanged;

  /// Called with the text when the user submits.
  final ValueChanged<String>? onSubmitted;

  /// Accessibility label.
  final String? semanticLabel;

  /// Style override.
  final VTextAreaStyle? style;

  @override
  State<VTextArea> createState() => _VTextAreaState();
}

class _VTextAreaState extends State<VTextArea> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _lastText = _controller.text;
    _controller.addListener(_handleControllerChanged);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _hasFocus = _focusNode.hasFocus;
  }

  // Last text seen, so selection-only changes do not rebuild.
  late String _lastText;

  // WHY: The text also changes in code (controller.text = ..., clear); the
  // placeholder, the counter and the height must follow.
  void _handleControllerChanged() {
    if (_controller.text == _lastText) return;
    _lastText = _controller.text;
    if (!mounted) return;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    } else {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(VTextArea oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_handleControllerChanged);
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_handleControllerChanged);
      _lastText = _controller.text;
    }

    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_handleFocusChange);
      if (oldWidget.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_handleFocusChange);
      _hasFocus = _focusNode.hasFocus;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _focusNode.removeListener(_handleFocusChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  void _handleChanged(String value) {
    widget.onChanged?.call(value);
  }

  double _calculateHeight(VTypography typography, double verticalPadding) {
    final defaultFontSize = VTypography.defaults.bodyMedium.fontSize ?? 14.0;
    final lineHeight =
        (typography.bodyMedium.fontSize ?? defaultFontSize) * 1.5;
    final padding = verticalPadding * 2;

    final lineCount = _controller.text.split('\n').length;
    final effectiveMinLines = widget.minLines;
    final effectiveMaxLines = widget.maxLines ?? lineCount;

    var displayLines = lineCount;
    if (displayLines < effectiveMinLines) {
      displayLines = effectiveMinLines;
    }
    if (widget.maxLines != null && displayLines > effectiveMaxLines) {
      displayLines = effectiveMaxLines;
    }

    return (lineHeight * displayLines) + padding;
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VTextAreaStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    final colors = theme.colors;
    final typography = theme.typography;

    final textStyle = (resolvedStyle?.textStyle ?? typography.bodyMedium)
        .copyWith(color: resolvedStyle?.foregroundColor ?? colors.foreground);
    final placeholderStyle = (resolvedStyle?.hintStyle ?? textStyle).copyWith(
      color: colors.mutedForeground,
    );

    final height = _calculateHeight(typography, theme.spacing.sm);

    Widget inputWidget = EditableText(
      controller: _controller,
      focusNode: _focusNode,
      style: textStyle,
      cursorColor: colors.primary,
      backgroundCursorColor: colors.muted,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      readOnly: widget.readOnly || !widget.enabled,
      inputFormatters: [
        if (widget.maxLength != null)
          LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      onChanged: _handleChanged,
    );

    // WHY: A disabled field must not take focus or keystrokes, not only
    // ignore the pointer.
    inputWidget = ExcludeFocus(excluding: !widget.enabled, child: inputWidget);

    // Placeholder
    inputWidget = Stack(
      children: [
        if (_controller.text.isEmpty && widget.placeholder != null)
          Padding(
            padding: EdgeInsets.only(top: theme.spacing.xxs),
            child: IgnorePointer(
              child: Text(widget.placeholder!, style: placeholderStyle),
            ),
          ),
        inputWidget,
      ],
    );

    // Announce the field: the semantic label, else the visible label.
    inputWidget = Semantics(
      textField: true,
      label: widget.semanticLabel ?? widget.label,
      child: inputWidget,
    );

    // Enable scrolling
    inputWidget = SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: theme.spacing.sm),
        child: inputWidget,
      ),
    );

    // Border color computation
    Color borderColor;
    if (!widget.enabled) {
      borderColor = colors.muted;
    } else if (widget.error) {
      borderColor = colors.destructive;
    } else if (_hasFocus) {
      borderColor = resolvedStyle?.focusBorderColor ?? colors.primary;
    } else {
      borderColor = resolvedStyle?.borderColor ?? colors.input;
    }

    // Custom body
    Widget bodyWidget = AnimatedContainer(
      duration: theme.animations.fast,
      curve: theme.animations.curveEaseOut,
      height: height,
      width: widget.fullWidth ? double.infinity : null,
      padding:
          resolvedStyle?.padding ??
          EdgeInsets.symmetric(horizontal: theme.spacing.lg),
      decoration: BoxDecoration(
        color: resolvedStyle?.backgroundColor,
        border: Border.all(color: borderColor, width: _hasFocus ? 2 : 1),
        borderRadius: resolvedStyle?.borderRadius ?? theme.radius.mdRadius,
      ),
      child: Opacity(
        opacity: widget.enabled ? 1.0 : 0.5,
        child: IgnorePointer(ignoring: !widget.enabled, child: inputWidget),
      ),
    );

    // A tap anywhere in the box focuses the field, not only on a text line.
    bodyWidget = _TapToFocus(
      focusNode: _focusNode,
      enabled: widget.enabled && !widget.readOnly,
      child: bodyWidget,
    );

    // Determine counter visibility
    final showCounter = widget.showCounter || widget.maxLength != null;

    // Wrap with VFormField
    return FocusTraversalGroup(
      child: VFormField(
        label: widget.label,
        more: widget.more,
        tooltip: widget.tooltip,
        required: widget.required,
        requiredMark: widget.requiredMark,
        helper: widget.helper,
        error: widget.error,
        errorText: widget.errorText,
        success: widget.success,
        successText: widget.successText,
        extra: widget.extra,
        maxLength: showCounter ? widget.maxLength : null,
        currentLength: _controller.text.length,
        child: bodyWidget,
      ),
    );
  }
}

/// Focuses a node when the child is tapped anywhere.
///
/// Built on [RawGestureDetector] so the child tree keeps a single
/// [GestureDetector] per real button.
class _TapToFocus extends StatelessWidget {
  const _TapToFocus({
    required this.focusNode,
    required this.enabled,
    required this.child,
  });

  final FocusNode focusNode;
  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) => RawGestureDetector(
    behavior: HitTestBehavior.translucent,
    gestures: enabled
        ? <Type, GestureRecognizerFactory>{
            TapGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                  TapGestureRecognizer.new,
                  (recognizer) => recognizer.onTap = focusNode.requestFocus,
                ),
          }
        : const <Type, GestureRecognizerFactory>{},
    child: child,
  );
}
