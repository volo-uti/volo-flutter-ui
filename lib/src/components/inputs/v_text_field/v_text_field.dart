import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/feedback/v_loading_spinner/v_loading_spinner.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_form_body/v_form_body.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_form_body/v_form_body_style.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_form_field/v_form_field.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_form_field/v_form_field_style.dart';
import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'package:volo_flutter_ui/src/utils/v_debug.dart';

import 'v_text_field_style.dart';

/// Single-line text input with label, helper text, validation and built-in variants.
///
/// For several lines use VTextArea.
///
/// **Basic Usage:**
///
/// ```dart
/// VTextField(
///   name: 'email',
///   label: 'Email',
///   placeholder: 'example@email.com',
///   onChanged: (value) {},
/// )
/// ```
///
/// **Variants:**
///
/// - [VTextField] - Default text field
/// - [VTextField.email] - Email input (keyboard optimized)
/// - [VTextField.password] - Password input (show/hide toggle)
/// - [VTextField.search] - Search input (search icon, clear button)
/// - [VTextField.number] - Number input (numeric keyboard)
/// - [VTextField.phone] - Phone number input (phone keyboard)
/// - [VTextField.url] - URL input (URL keyboard)
///
/// **Password Field:**
///
/// ```dart
/// VTextField.password(
///   name: 'password',
///   label: 'Password',
///   placeholder: 'Enter your password',
/// )
/// ```
class VTextField extends StatefulWidget {
  /// Default text field.
  const VTextField({
    required this.name,
    super.key,
    this.value = '',
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSaved,
    this.onSubmitted,
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
    this.leading,
    this.suffix,
    this.trailing,
    this.type = VFormBodyType.outlined,
    this.color = VFormBodyColor.primary,
    this.size = VFormBodySize.md,
    this.corner = VFormBodyCorner.rounded,
    this.fullWidth = false,
    this.clearable = false,
    this.autofocus = false,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.loading = false,
    this.required = false,
    this.requiredMark = '*',
    this.floatingLabel = false,
    this.validator,
    this.inputFormatters,
    this.textInputAction,
    this.obscureText = false,
    this.keyboardType,
    this.semanticLabel,
    this.style,
  }) : _inputType = _VTextFieldInputType.text;

  /// Email input field.
  const VTextField.email({
    required this.name,
    super.key,
    this.value = '',
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSaved,
    this.onSubmitted,
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
    this.leading,
    this.suffix,
    this.trailing,
    this.type = VFormBodyType.outlined,
    this.color = VFormBodyColor.primary,
    this.size = VFormBodySize.md,
    this.corner = VFormBodyCorner.rounded,
    this.fullWidth = false,
    this.clearable = false,
    this.autofocus = false,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.loading = false,
    this.required = false,
    this.requiredMark = '*',
    this.floatingLabel = false,
    this.validator,
    this.inputFormatters,
    this.textInputAction,
    this.semanticLabel,
    this.style,
  }) : _inputType = _VTextFieldInputType.email,
       obscureText = false,
       keyboardType = TextInputType.emailAddress;

  /// Password input field.
  const VTextField.password({
    required this.name,
    super.key,
    this.value = '',
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSaved,
    this.onSubmitted,
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
    this.leading,
    this.suffix,
    this.trailing,
    this.type = VFormBodyType.outlined,
    this.color = VFormBodyColor.primary,
    this.size = VFormBodySize.md,
    this.corner = VFormBodyCorner.rounded,
    this.fullWidth = false,
    this.clearable = false,
    this.autofocus = false,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.loading = false,
    this.required = false,
    this.requiredMark = '*',
    this.floatingLabel = false,
    this.validator,
    this.inputFormatters,
    this.textInputAction,
    this.semanticLabel,
    this.style,
  }) : _inputType = _VTextFieldInputType.password,
       obscureText = true,
       keyboardType = null;

  /// Search input field.
  const VTextField.search({
    required this.name,
    super.key,
    this.value = '',
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSaved,
    this.onSubmitted,
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
    this.leading,
    this.suffix,
    this.trailing,
    this.type = VFormBodyType.outlined,
    this.color = VFormBodyColor.primary,
    this.size = VFormBodySize.md,
    this.corner = VFormBodyCorner.rounded,
    this.fullWidth = false,
    this.clearable = false,
    this.autofocus = false,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.loading = false,
    this.required = false,
    this.requiredMark = '*',
    this.floatingLabel = false,
    this.validator,
    this.inputFormatters,
    this.textInputAction = TextInputAction.search,
    this.semanticLabel,
    this.style,
  }) : _inputType = _VTextFieldInputType.search,
       obscureText = false,
       keyboardType = null;

  /// Number input field.
  const VTextField.number({
    required this.name,
    super.key,
    this.value = '',
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSaved,
    this.onSubmitted,
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
    this.leading,
    this.suffix,
    this.trailing,
    this.type = VFormBodyType.outlined,
    this.color = VFormBodyColor.primary,
    this.size = VFormBodySize.md,
    this.corner = VFormBodyCorner.rounded,
    this.fullWidth = false,
    this.clearable = false,
    this.autofocus = false,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.loading = false,
    this.required = false,
    this.requiredMark = '*',
    this.floatingLabel = false,
    this.validator,
    this.inputFormatters,
    this.textInputAction,
    this.semanticLabel,
    this.style,
  }) : _inputType = _VTextFieldInputType.number,
       obscureText = false,
       keyboardType = TextInputType.number;

  /// Phone number input field.
  const VTextField.phone({
    required this.name,
    super.key,
    this.value = '',
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSaved,
    this.onSubmitted,
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
    this.leading,
    this.suffix,
    this.trailing,
    this.type = VFormBodyType.outlined,
    this.color = VFormBodyColor.primary,
    this.size = VFormBodySize.md,
    this.corner = VFormBodyCorner.rounded,
    this.fullWidth = false,
    this.clearable = false,
    this.autofocus = false,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.loading = false,
    this.required = false,
    this.requiredMark = '*',
    this.floatingLabel = false,
    this.validator,
    this.inputFormatters,
    this.textInputAction,
    this.semanticLabel,
    this.style,
  }) : _inputType = _VTextFieldInputType.phone,
       obscureText = false,
       keyboardType = TextInputType.phone;

  /// URL input field.
  const VTextField.url({
    required this.name,
    super.key,
    this.value = '',
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSaved,
    this.onSubmitted,
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
    this.leading,
    this.suffix,
    this.trailing,
    this.type = VFormBodyType.outlined,
    this.color = VFormBodyColor.primary,
    this.size = VFormBodySize.md,
    this.corner = VFormBodyCorner.rounded,
    this.fullWidth = false,
    this.clearable = false,
    this.autofocus = false,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.loading = false,
    this.required = false,
    this.requiredMark = '*',
    this.floatingLabel = false,
    this.validator,
    this.inputFormatters,
    this.textInputAction,
    this.semanticLabel,
    this.style,
  }) : _inputType = _VTextFieldInputType.url,
       obscureText = false,
       keyboardType = TextInputType.url;

  /// Name that identifies the field within its form and in debug logs.
  final String name;

  /// Initial text, ignored when [controller] is given.
  final String value;

  /// Controller for the text; the field creates one when null.
  final TextEditingController? controller;

  /// Focus node; the field creates one when null.
  final FocusNode? focusNode;

  /// Called with the new text on every edit.
  final ValueChanged<String>? onChanged;

  /// Called with the text when the enclosing [VForm] saves.
  final FormFieldSetter<String>? onSaved;

  /// Called with the text when the user submits.
  final ValueChanged<String>? onSubmitted;

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

  /// Whether the field shows the error border and [errorText].
  final bool error;

  /// Error message, shown when [error] is true or [validator] fails.
  final String? errorText;

  /// Whether the field shows the success border and [successText].
  final bool success;

  /// Success message, shown when [success] is true.
  final String? successText;

  /// Note that stays visible below the message.
  final String? extra;

  /// Widget shown before the text.
  final Widget? leading;

  /// Text shown after the input, such as a unit.
  final String? suffix;

  /// Widget shown after the input and its built-in buttons.
  final Widget? trailing;

  /// Visual type: outlined, filled or underline.
  final VFormBodyType type;

  /// Accent color used for focus and borders.
  final VFormBodyColor color;

  /// Minimum height preset; the field grows with the text scale.
  final VFormBodySize size;

  /// Corner shape.
  final VFormBodyCorner corner;

  /// Whether the field stretches to the available width.
  final bool fullWidth;

  /// Whether a clear button appears while the field has text.
  final bool clearable;

  /// Whether the field takes focus when first built.
  final bool autofocus;

  /// Maximum number of characters; also shows a `current/max` counter.
  final int? maxLength;

  /// Whether the field accepts input. When false it is dimmed and ignores taps.
  final bool enabled;

  /// Whether the text can be selected but not edited.
  final bool readOnly;

  /// Whether a spinner is shown in the trailing area.
  final bool loading;

  /// Whether to show [requiredMark] after the label.
  final bool required;

  /// Character shown after the label when [required] is true.
  final String requiredMark;

  /// Whether the label floats over the top edge of the field.
  final bool floatingLabel;

  /// Returns an error message for invalid text, or null; run by the enclosing [VForm].
  final FormFieldValidator<String>? validator;

  /// Formatters applied to the text as the user types.
  final List<TextInputFormatter>? inputFormatters;

  /// Action button shown on the software keyboard.
  final TextInputAction? textInputAction;

  /// Whether the text is hidden, as for passwords.
  final bool obscureText;

  /// Keyboard layout to request.
  final TextInputType? keyboardType;

  /// Accessibility label.
  final String? semanticLabel;

  /// Style override merged over the theme's [VTextFieldStyle].
  ///
  /// Its box fields reach the [VFormBody] and its labelStyle the label.
  final VTextFieldStyle? style;

  /// Internal input type.
  final _VTextFieldInputType _inputType;

  @override
  State<VTextField> createState() => _VTextFieldState();
}

/// Form field that tells the text field when its form resets.
class _VTextFormField extends FormField<String> {
  const _VTextFormField({
    required super.builder,
    required this.onFormReset,
    super.key,
    super.initialValue,
    super.validator,
    super.onSaved,
    super.enabled,
  });

  final VoidCallback onFormReset;

  @override
  FormFieldState<String> createState() => _VTextFormFieldState();
}

class _VTextFormFieldState extends FormFieldState<String> {
  @override
  void reset() {
    super.reset();
    (widget as _VTextFormField).onFormReset();
  }
}

enum _VTextFieldInputType { text, email, password, search, number, phone, url }

class _VTextFieldState extends State<VTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = true;
  bool _hasFocus = false;
  final _fieldKey = GlobalKey<FormFieldState<String>>();

  // Text the enclosing VForm resets to.
  late String _initialText;
  // Last text seen, so selection-only changes do not rebuild.
  late String _lastText;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.value);
    _initialText = _controller.text;
    _lastText = _controller.text;
    _controller.addListener(_handleControllerChanged);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _hasFocus = _focusNode.hasFocus;
    _obscureText = widget.obscureText;
  }

  // WHY: The text also changes in code (controller.text = ..., clear, a form
  // reset). The counter, the placeholder, the clear button and the enclosing
  // form's value must follow, not only edits that come from the keyboard.
  void _handleControllerChanged() {
    final text = _controller.text;
    if (text == _lastText) return;
    _lastText = text;
    if (!mounted) return;
    void sync() {
      if (!mounted) return;
      setState(() {});
      final field = _fieldKey.currentState;
      if (field != null && field.value != text) field.didChange(text);
    }

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      // Changed while the tree is building: wait for the frame to end.
      SchedulerBinding.instance.addPostFrameCallback((_) => sync());
    } else {
      sync();
    }
  }

  @override
  void didUpdateWidget(VTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      // Only dispose internally created controllers (do not dispose externally provided ones)
      // Assign the new controller first before disposing to ensure reference safety
      final shouldDisposeOld =
          oldWidget.controller == null && _controller != widget.controller;
      final oldController = shouldDisposeOld ? _controller : null;
      _controller.removeListener(_handleControllerChanged);
      _controller =
          widget.controller ?? TextEditingController(text: widget.value);
      _controller.addListener(_handleControllerChanged);
      oldController?.dispose();
      _initialText = _controller.text;
      _lastText = _controller.text;
      // The enclosing form must see the new controller's text.
      final field = _fieldKey.currentState;
      if (field != null && field.value != _controller.text) {
        final text = _controller.text;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted) _fieldKey.currentState?.didChange(text);
        });
      }
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
    VDebug.log(
      category: VDebugCategory.input,
      component: 'VTextField',
      name: widget.name,
      action: 'changed',
      value: value,
    );

    widget.onChanged?.call(value);
  }

  void _handleClear() {
    _controller.clear();
    _handleChanged('');
    _focusNode.requestFocus();
  }

  // Puts the text back to what it was when the field was built.
  void _handleFormReset() {
    if (_controller.text != _initialText) _controller.text = _initialText;
  }

  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  VComponentSize _sizeToken(VThemeData theme) => switch (widget.size) {
    VFormBodySize.sm => theme.sizes.sm,
    VFormBodySize.lg => theme.sizes.lg,
    _ => theme.sizes.md,
  };

  Widget _buildTrailingSection(VThemeData theme) {
    final colors = theme.colors;
    final sizeToken = _sizeToken(theme);
    final trailing = <Widget>[];

    // Suffix text
    if (widget.suffix != null) {
      trailing.add(
        Padding(
          padding: EdgeInsets.only(right: theme.spacing.xs),
          child: Text(
            widget.suffix!,
            style: TextStyle(color: colors.mutedForeground),
          ),
        ),
      );
    }

    // Clear button
    if (widget.clearable && _controller.text.isNotEmpty && !widget.readOnly) {
      trailing.add(
        Semantics(
          button: true,
          label: VoloLocalizations.of(context).clearTextLabel,
          excludeSemantics: true,
          onTap: _handleClear,
          child: GestureDetector(
            onTap: _handleClear,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: theme.spacing.xs),
              child: _ClearIcon(
                color: colors.mutedForeground,
                size: sizeToken.iconSize,
              ),
            ),
          ),
        ),
      );
    }

    // Action icon (per type)
    if (widget._inputType == _VTextFieldInputType.password) {
      final l10n = VoloLocalizations.of(context);
      trailing.add(
        Semantics(
          button: true,
          label: _obscureText ? l10n.showPasswordLabel : l10n.hidePasswordLabel,
          excludeSemantics: true,
          onTap: _toggleObscure,
          child: GestureDetector(
            onTap: _toggleObscure,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: theme.spacing.xs),
              child: _EyeIcon(
                open: !_obscureText,
                color: colors.mutedForeground,
                size: sizeToken.iconSize,
              ),
            ),
          ),
        ),
      );
    } else if (widget._inputType == _VTextFieldInputType.search) {
      trailing.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.xs),
          child: _SearchIcon(
            color: colors.mutedForeground,
            size: sizeToken.iconSize,
          ),
        ),
      );
    }

    // Loading indicator
    if (widget.loading) {
      trailing.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.xs),
          child: VLoadingSpinner(
            color: colors.mutedForeground,
            size: sizeToken.iconSize,
          ),
        ),
      );
    }

    // User trailing widget
    if (widget.trailing != null) {
      trailing.add(widget.trailing!);
    }

    if (trailing.isEmpty) return const SizedBox.shrink();

    return Row(mainAxisSize: MainAxisSize.min, children: trailing);
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VTextFieldStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    final colors = theme.colors;
    final typography = theme.typography;

    // foregroundColor wins over the textStyle's color, which wins over the
    // token; a hintStyle's color wins over the muted placeholder color.
    final baseTextStyle = _getTextStyle(typography);
    final textStyle = (resolvedStyle?.textStyle ?? baseTextStyle).copyWith(
      color:
          resolvedStyle?.foregroundColor ??
          resolvedStyle?.textStyle?.color ??
          colors.foreground,
    );
    final hintStyle = resolvedStyle?.hintStyle;
    final placeholderStyle = (hintStyle ?? textStyle).copyWith(
      color: hintStyle?.color ?? colors.mutedForeground,
    );

    // The box and the label take their part of the style.
    final bodyStyle = resolvedStyle == null
        ? null
        : VFormBodyStyle(
            backgroundColor: resolvedStyle.backgroundColor,
            borderColor: resolvedStyle.borderColor,
            focusBorderColor: resolvedStyle.focusBorderColor,
            borderRadius: resolvedStyle.borderRadius,
            padding: resolvedStyle.padding,
          );
    final fieldStyle = resolvedStyle?.labelStyle == null
        ? null
        : VFormFieldStyle(labelStyle: resolvedStyle!.labelStyle);
    final cursorColor = resolvedStyle?.cursorColor ?? colors.primary;

    Widget inputWidget = EditableText(
      controller: _controller,
      focusNode: _focusNode,
      style: textStyle,
      cursorColor: cursorColor,
      backgroundCursorColor: colors.muted,
      obscureText: widget._inputType == _VTextFieldInputType.password
          ? _obscureText
          : widget.obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly || !widget.enabled,
      inputFormatters: [
        if (widget.maxLength != null)
          LengthLimitingTextInputFormatter(widget.maxLength),
        ...?widget.inputFormatters,
      ],
      onChanged: _handleChanged,
      onSubmitted: widget.onSubmitted,
    );

    // WHY: A disabled field must not take focus or keystrokes, not only
    // ignore the pointer.
    inputWidget = ExcludeFocus(excluding: !widget.enabled, child: inputWidget);

    // Placeholder
    inputWidget = Stack(
      alignment: AlignmentDirectional.centerStart,
      children: [
        if (_controller.text.isEmpty && widget.placeholder != null)
          IgnorePointer(
            child: Text(widget.placeholder!, style: placeholderStyle),
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

    // Wrap with VFormBody
    Widget buildBody({required bool invalid}) => _TapToFocus(
      // A tap anywhere in the box focuses the field, not only on the text line.
      focusNode: _focusNode,
      enabled: widget.enabled && !widget.readOnly,
      child: VFormBody(
        type: widget.type,
        color: widget.color,
        size: widget.size,
        corner: widget.corner,
        fullWidth: widget.fullWidth,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        focused: _hasFocus,
        error: invalid,
        success: widget.success,
        leading: widget.leading,
        trailing: _buildTrailingSection(theme),
        style: bodyStyle,
        child: inputWidget,
      ),
    );

    // WHY: FormField lets an enclosing VForm run validator and onSaved.
    return FocusTraversalGroup(
      child: _VTextFormField(
        key: _fieldKey,
        initialValue: _initialText,
        enabled: widget.enabled,
        // The controller is the source of truth: read it at validate and save
        // time, so a value set in code is never missed.
        validator: widget.validator == null || !widget.enabled
            ? null
            : (_) => widget.validator!(_controller.text),
        onSaved: widget.onSaved == null
            ? null
            : (_) => widget.onSaved!(_controller.text),
        onFormReset: _handleFormReset,
        builder: (state) => VFormField(
          label: widget.label,
          more: widget.more,
          tooltip: widget.tooltip,
          required: widget.required,
          requiredMark: widget.requiredMark,
          floatingLabel: widget.floatingLabel,
          helper: widget.helper,
          error: widget.error || state.hasError,
          errorText: state.errorText ?? widget.errorText,
          success: widget.success,
          successText: widget.successText,
          extra: widget.extra,
          maxLength: widget.maxLength,
          currentLength: _controller.text.length,
          style: fieldStyle,
          child: buildBody(invalid: widget.error || state.hasError),
        ),
      ),
    );
  }

  TextStyle _getTextStyle(VTypography typography) {
    switch (widget.size) {
      case VFormBodySize.sm:
        return typography.bodySmall;
      case VFormBodySize.md:
        return typography.bodyMedium;
      case VFormBodySize.lg:
        return typography.bodyLarge;
    }
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

/// Clear icon.
class _ClearIcon extends StatelessWidget {
  const _ClearIcon({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size), painter: _ClearIconPainter(color));
}

class _ClearIconPainter extends CustomPainter {
  _ClearIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final center = size.center(Offset.zero);
    const radius = 6.0;

    // Circle
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = color.withValues(alpha: 0.2),
    );

    // X
    const offset = radius * 0.5;
    canvas
      ..drawLine(
        Offset(center.dx - offset, center.dy - offset),
        Offset(center.dx + offset, center.dy + offset),
        paint,
      )
      ..drawLine(
        Offset(center.dx + offset, center.dy - offset),
        Offset(center.dx - offset, center.dy + offset),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant _ClearIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Eye icon.
class _EyeIcon extends StatelessWidget {
  const _EyeIcon({required this.open, required this.color, required this.size});

  final bool open;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => open
      ? VIcons.visibility(color: color, size: size)
      : VIcons.visibilityOff(color: color, size: size);
}

/// Search icon.
class _SearchIcon extends StatelessWidget {
  const _SearchIcon({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size), painter: _SearchIconPainter(color));
}

class _SearchIconPainter extends CustomPainter {
  _SearchIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas
      // Circle
      ..drawCircle(
        Offset(size.width * 0.4, size.height * 0.4),
        size.width * 0.3,
        paint,
      )
      // Handle
      ..drawLine(
        Offset(size.width * 0.6, size.height * 0.6),
        Offset(size.width - 2, size.height - 2),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant _SearchIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
