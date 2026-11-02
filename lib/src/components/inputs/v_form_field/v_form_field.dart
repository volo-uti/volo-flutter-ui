import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_form_footer/v_form_footer.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_form_header/v_form_header.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_form_header/v_form_header_style.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_form_field_style.dart';

/// Wraps a control with a label above and helper or error text below.
///
/// Composes [VFormHeader], the control and [VFormFooter].
///
/// **Basic Usage:**
///
/// ```dart
/// VFormField(
///   label: 'Email',
///   required: true,
///   helper: 'Enter your company email',
///   child: VFormBody(
///     child: EditableText(...),
///   ),
/// )
/// ```
///
/// **With Error State:**
///
/// ```dart
/// VFormField(
///   label: 'Password',
///   error: true,
///   errorText: 'Must be at least 8 characters',
///   child: VFormBody(...),
/// )
/// ```
///
/// See also:
/// - [VTextField] - Single-line text input
/// - [VTextArea] - Multi-line text input
class VFormField extends StatelessWidget {
  /// Creates a form field.
  const VFormField({
    required this.child,
    super.key,
    this.header,
    this.footer,
    // VFormHeader props
    this.label,
    this.more,
    this.required = false,
    this.requiredMark = '*',
    this.tooltip,
    this.floatingLabel = false,
    // VFormFooter props
    this.helper,
    this.error = false,
    this.errorText,
    this.success = false,
    this.successText,
    this.extra,
    this.counter,
    this.maxLength,
    this.currentLength = 0,
    this.style,
  });

  /// The control to wrap, usually a [VFormBody].
  final Widget child;

  /// Replaces the generated [VFormHeader].
  final Widget? header;

  /// Replaces the generated [VFormFooter].
  final Widget? footer;

  // VFormHeader props

  /// Label text shown above the control.
  final String? label;

  /// Note shown at the right end of the label row.
  final String? more;

  /// Whether to show [requiredMark] after the label.
  final bool required;

  /// Character shown after the label when [required] is true.
  final String requiredMark;

  /// Widget shown next to the label, typically a help icon.
  final Widget? tooltip;

  /// Whether the label floats over the top edge of the control.
  final bool floatingLabel;

  // VFormFooter props

  /// Helper text shown below the control.
  final String? helper;

  /// Whether to show [errorText] in the destructive color.
  final bool error;

  /// Error message, shown when [error] is true.
  final String? errorText;

  /// Whether to show [successText] in the success color.
  final bool success;

  /// Success message, shown when [success] is true.
  final String? successText;

  /// Note that stays visible below the message.
  final String? extra;

  /// Replaces the generated `current/max` counter.
  final Widget? counter;

  /// Character limit; when set, a counter is shown.
  final int? maxLength;

  /// Characters entered so far, used by the generated counter.
  final int currentLength;

  /// Style override merged over the theme's [VFormFieldStyle].
  final VFormFieldStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VFormFieldStyle>();
    final resolvedStyle = themeStyle?.merge(style) ?? style;

    // Spacing between custom header/footer and body
    final fieldSpacing = resolvedStyle?.spacing;

    // Body
    var bodyWidget = child;

    // Wrap with VFormFooter. WHY: always, even when it has nothing to show,
    // so the control keeps its place in the tree when a message appears.
    if (footer == null) {
      bodyWidget = VFormFooter(
        helper: helper,
        error: error,
        errorText: errorText,
        success: success,
        successText: successText,
        extra: extra,
        counter: counter,
        maxLength: maxLength,
        currentLength: currentLength,
        child: bodyWidget,
      );
    } else {
      bodyWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bodyWidget,
          if (fieldSpacing != null) SizedBox(height: fieldSpacing),
          footer!,
        ],
      );
    }

    // Wrap with VFormHeader (always, for the same reason as the footer)
    if (header == null) {
      final labelStyle = resolvedStyle?.labelStyle;
      bodyWidget = VFormHeader(
        label: label,
        more: more,
        required: required,
        requiredMark: requiredMark,
        tooltip: tooltip,
        floatingLabel: floatingLabel,
        style: labelStyle == null
            ? null
            : VFormHeaderStyle(titleStyle: labelStyle),
        child: bodyWidget,
      );
    } else {
      bodyWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header!,
          if (fieldSpacing != null) SizedBox(height: fieldSpacing),
          bodyWidget,
        ],
      );
    }

    return MergeSemantics(child: bodyWidget);
  }
}
