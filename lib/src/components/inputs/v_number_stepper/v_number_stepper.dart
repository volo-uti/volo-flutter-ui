import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_icon_button/v_icon_button.dart';
import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_number_stepper_style.dart';

/// Number stepper size; it sets the size of both buttons.
enum VNumberStepperSize {
  /// Extra small.
  xs,

  /// Small.
  sm,

  /// Medium.
  md,

  /// Large.
  lg,

  /// Extra large.
  xl,
}

/// Plus and minus buttons around a whole number.
///
/// The buttons step it within a range, and the widget keeps no value of its
/// own: [onChanged] reports `value ± step`,
/// clamped to [min] and [max], and the parent passes it back as [value]. A
/// button turns off at its end of the range. Screen readers see one node with
/// the value and increase and decrease actions.
///
/// ```dart
/// VNumberStepper(
///   value: quantity,
///   min: 1,
///   max: 9,
///   semanticLabel: 'Quantity',
///   onChanged: (v) => setState(() => quantity = v),
/// )
/// ```
///
/// Inside a form, draw it from a [VFormValueField] to validate and save it.
class VNumberStepper extends StatelessWidget {
  /// Creates a number stepper.
  const VNumberStepper({
    required this.value,
    required this.onChanged,
    super.key,
    this.min = 0,
    this.max,
    this.step = 1,
    this.enabled = true,
    this.size = VNumberStepperSize.md,
    this.semanticLabel,
    this.style,
  }) : assert(step > 0, 'step must be positive'),
       assert(max == null || max >= min, 'max must not be below min');

  /// Current value.
  final int value;

  /// Called with the new value; `null` turns both buttons off.
  final ValueChanged<int>? onChanged;

  /// Smallest value; the minus button turns off at it.
  final int min;

  /// Largest value, or `null` for no limit; the plus button turns off at it.
  final int? max;

  /// Amount one press adds or takes away.
  final int step;

  /// Whether the buttons react; false turns both off.
  final bool enabled;

  /// Size of both buttons.
  final VNumberStepperSize size;

  /// Label screen readers announce with the value, such as 'Quantity'.
  final String? semanticLabel;

  /// Style override merged over the theme's [VNumberStepperStyle].
  final VNumberStepperStyle? style;

  bool get _active => enabled && onChanged != null;

  bool get _canDecrease => _active && value > min;

  bool get _canIncrease => _active && (max == null || value < max!);

  int get _decreased => math.max(min, value - step);

  int get _increased =>
      max == null ? value + step : math.min(max!, value + step);

  void _decrease() => onChanged!(_decreased);

  void _increase() => onChanged!(_increased);

  VIconButtonSize get _buttonSize => switch (size) {
    VNumberStepperSize.xs => VIconButtonSize.xs,
    VNumberStepperSize.sm => VIconButtonSize.sm,
    VNumberStepperSize.md => VIconButtonSize.md,
    VNumberStepperSize.lg => VIconButtonSize.lg,
    VNumberStepperSize.xl => VIconButtonSize.xl,
  };

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final themeStyle = theme.componentOverrides.get<VNumberStepperStyle>();
    final resolved = themeStyle?.merge(style) ?? style;

    final iconSize = switch (size) {
      VNumberStepperSize.xs => theme.sizes.xs.iconSize,
      VNumberStepperSize.sm => theme.sizes.sm.iconSize,
      VNumberStepperSize.md => theme.sizes.md.iconSize,
      VNumberStepperSize.lg => theme.sizes.lg.iconSize,
      VNumberStepperSize.xl => theme.sizes.xl.iconSize,
    };
    final textStyle = theme.typography.bodyMedium
        .copyWith(
          color: resolved?.foregroundColor ?? theme.colors.foreground,
          fontWeight: FontWeight.w600,
          fontFeatures: const [FontFeature.tabularFigures()],
        )
        .merge(resolved?.textStyle);
    final spacing = resolved?.spacing ?? theme.spacing.xs;

    Widget button(Key key, Widget icon, VoidCallback? onPressed) =>
        ExcludeSemantics(
          child: VIconButton.outlined(
            key: key,
            icon: icon,
            size: _buttonSize,
            enabled: onPressed != null,
            onPressed: onPressed,
            style: resolved?.buttonStyle,
          ),
        );

    return Semantics(
      container: true,
      excludeSemantics: true,
      enabled: _active,
      label: semanticLabel,
      value: '$value',
      increasedValue: _canIncrease ? '$_increased' : null,
      decreasedValue: _canDecrease ? '$_decreased' : null,
      onIncrease: _canIncrease ? _increase : null,
      onDecrease: _canDecrease ? _decrease : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(
            const ValueKey('VNumberStepper.decrement'),
            VIcons.minus(size: iconSize),
            _canDecrease ? _decrease : null,
          ),
          SizedBox(width: spacing),
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: resolved?.valueMinWidth ?? iconSize * 2,
            ),
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          ),
          SizedBox(width: spacing),
          button(
            const ValueKey('VNumberStepper.increment'),
            VIcons.plus(size: iconSize),
            _canIncrease ? _increase : null,
          ),
        ],
      ),
    );
  }
}
