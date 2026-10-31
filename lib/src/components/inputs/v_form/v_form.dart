import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_form_style.dart';

/// When the fields of a [VForm] validate themselves.
enum VFormAutoValidateMode {
  /// No automatic validation.
  disabled,

  /// Validate on every change.
  always,

  /// Validate on user interaction.
  onUserInteraction,
}

/// Vertical stack of form fields that validates and saves them together.
///
/// Wraps Flutter's [Form] with spacing and focus traversal.
///
/// **Basic Usage:**
///
/// ```dart
/// final formKey = GlobalKey<FormState>();
///
/// VForm(
///   formKey: formKey,
///   children: [
///     VTextField(name: 'name', label: 'Name'),
///     VTextField.email(name: 'email', label: 'Email'),
///   ],
/// )
/// ```
///
/// **With Validation:**
///
/// ```dart
/// VForm(
///   autoValidateMode: VFormAutoValidateMode.onUserInteraction,
///   children: [
///     VTextField.email(
///       name: 'email',
///       label: 'Email',
///       required: true,
///       validator: (v) => (v ?? '').contains('@') ? null : 'Invalid email',
///     ),
///   ],
/// )
/// ```
///
/// See also:
///
/// - [VFormField] - Form field wrapper with label, input, and footer.
/// - [VFormBody] - Input body area.
class VForm extends StatefulWidget {
  /// Creates a form wrapper.
  const VForm({
    required this.children,
    super.key,
    this.formKey,
    this.onChanged,
    this.autoValidateMode = VFormAutoValidateMode.disabled,
    this.spacing,
    this.style,
  });

  /// Fields and other widgets stacked vertically.
  final List<Widget> children;

  /// Key to call `validate()`, `save()` or `reset()` on; the form keeps its own when null.
  final GlobalKey<FormState>? formKey;

  /// Called when any field in the form changes.
  final VoidCallback? onChanged;

  /// When fields validate themselves without an explicit submit.
  final VFormAutoValidateMode autoValidateMode;

  /// Gap between children; defaults to the theme's large spacing.
  final double? spacing;

  /// Style override.
  final VFormStyle? style;

  @override
  State<VForm> createState() => _VFormState();
}

class _VFormState extends State<VForm> {
  final _ownKey = GlobalKey<FormState>();

  GlobalKey<FormState> get _formKey => widget.formKey ?? _ownKey;

  AutovalidateMode get _autoValidateMode {
    switch (widget.autoValidateMode) {
      case VFormAutoValidateMode.disabled:
        return AutovalidateMode.disabled;
      case VFormAutoValidateMode.always:
        return AutovalidateMode.always;
      case VFormAutoValidateMode.onUserInteraction:
        return AutovalidateMode.onUserInteraction;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VFormStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    final gap = resolvedStyle?.spacing ?? widget.spacing ?? theme.spacing.lg;

    // Build children with spacing
    final spacedChildren = <Widget>[];
    for (var i = 0; i < widget.children.length; i++) {
      spacedChildren.add(widget.children[i]);
      if (i < widget.children.length - 1) {
        spacedChildren.add(SizedBox(height: gap));
      }
    }

    // WHY: FocusTraversalGroup wraps the Form — ensures Tab key cycles
    // through form fields in visual order without escaping to unrelated
    // page elements. This is critical for keyboard-only form completion.
    return FocusTraversalGroup(
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        onChanged: widget.onChanged,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: spacedChildren,
        ),
      ),
    );
  }
}
