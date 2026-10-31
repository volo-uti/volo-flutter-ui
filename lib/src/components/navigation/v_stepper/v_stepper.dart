import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/inputs/v_button/v_button.dart';
import 'package:volo_flutter_ui/src/icons/v_icons.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_stepper_style.dart';

/// Progress state of one [VStep], which picks its marker.
enum VStepState {
  /// Numbered marker (default).
  indexed,

  /// Pencil marker for the step being edited.
  editing,

  /// Check marker for a finished step.
  complete,

  /// Muted marker; the step cannot be tapped.
  disabled,

  /// Exclamation marker for a step with a problem.
  error,
}

/// One step of a [VStepper] with a title, optional subtitle and content.
///
/// ```dart
/// VStep(
///   title: Text('Shipping'),
///   subtitle: Text('Where should we send it?'),
///   state: VStepState.editing,
///   content: AddressForm(),
/// )
/// ```
class VStep {
  const VStep({
    required this.title,
    required this.content,
    this.subtitle,
    this.state = VStepState.indexed,
  });

  /// Heading of the step, usually a [Text] that takes the stepper title style.
  final Widget title;

  /// Line under the title, usually a [Text] that takes the muted caption style.
  final Widget? subtitle;

  /// Body shown while the step is the active one.
  final Widget content;

  /// Marker and tap behavior of the step.
  final VStepState state;
}

/// Builds the continue and cancel controls of a [VStepper].
typedef VStepperControlsBuilder =
    Widget Function(
      BuildContext context, {
      VoidCallback? onStepContinue,
      VoidCallback? onStepCancel,
    });

/// {@template v_stepper}
/// Multi-step flow with numbered markers, step content and controls.
///
/// Lays out horizontally, vertically or as a compact progress row.
///
/// ## Basic Usage
///
/// A basic horizontal stepper:
///
/// ```dart
/// VStepper(
///   activeStep: _currentStep,
///   steps: [
///     VStep(title: Text('Account Info'), content: AccountForm()),
///     VStep(title: Text('Personal Info'), content: ProfileForm()),
///     VStep(title: Text('Confirmation'), content: ConfirmationView()),
///   ],
///   onStepContinue: () => setState(() => _currentStep++),
///   onStepCancel: () => setState(() => _currentStep--),
/// )
/// ```
///
/// ## Variants
///
/// Three layouts are supported:
///
/// - [VStepper] / [VStepper.horizontal] - Horizontal layout (default)
/// - [VStepper.vertical] - Vertical layout
/// - [VStepper.compact] - Compact (progress only)
///
/// ## Horizontal Stepper
///
/// A horizontal stepper:
///
/// ```dart
/// VStepper.horizontal(
///   activeStep: _step,
///   steps: [
///     VStep(title: Text('Shipping'), content: AddressForm()),
///     VStep(title: Text('Payment'), content: PaymentForm()),
///     VStep(title: Text('Complete'), content: OrderComplete()),
///   ],
///   onStepTapped: (index) => setState(() => _step = index),
/// )
/// ```
///
/// ## Step States
///
/// Various states can be displayed per step:
///
/// ```dart
/// VStepper(
///   activeStep: 1,
///   steps: [
///     VStep(
///       title: Text('Completed step'),
///       content: Container(),
///       state: VStepState.complete,
///     ),
///     VStep(
///       title: Text('Current step'),
///       subtitle: Text('Please enter your information'),
///       content: CurrentForm(),
///       state: VStepState.editing,
///     ),
///     VStep(
///       title: Text('Next step'),
///       content: Container(),
///       state: VStepState.indexed,
///     ),
///     VStep(
///       title: Text('Error step'),
///       content: Container(),
///       state: VStepState.error,
///     ),
///     VStep(
///       title: Text('Disabled step'),
///       content: Container(),
///       state: VStepState.disabled,
///     ),
///   ],
/// )
/// ```
///
/// ## Custom Controls
///
/// Configure custom control buttons:
///
/// ```dart
/// VStepper(
///   activeStep: _step,
///   steps: steps,
///   controlsBuilder: (context, {onStepContinue, onStepCancel}) {
///     return Row(
///       children: [
///         if (_step > 0)
///           VButton.ghost(
///             onPressed: onStepCancel,
///             child: Text('Back'),
///           ),
///         Spacer(),
///         VButton(
///           onPressed: onStepContinue,
///           child: Text(_step == steps.length - 1 ? 'Submit' : 'Continue'),
///         ),
///       ],
///     );
///   },
/// )
/// ```
///
/// See also:
///
///  * [VProgress], simple progress indicator
///  * [VStep], individual step definition
///  * [VStepState], step state enumeration
/// {@endtemplate}
class VStepper extends StatelessWidget {
  /// Stepper with markers on top and the active step's content below.
  const VStepper({
    required this.steps,
    super.key,
    this.activeStep,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
    this.style,
  }) : assert(steps.length > 0, 'VStepper: steps must not be empty'),
       assert(
         activeStep == null || (activeStep >= 0 && activeStep < steps.length),
         'VStepper: activeStep must be between 0 and steps.length - 1',
       ),
       _direction = Axis.horizontal,
       _isCompact = false;

  /// Same as [VStepper], spelled out as the horizontal layout.
  const VStepper.horizontal({
    required this.steps,
    super.key,
    this.activeStep,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
    this.style,
  }) : assert(steps.length > 0, 'VStepper: steps must not be empty'),
       assert(
         activeStep == null || (activeStep >= 0 && activeStep < steps.length),
         'VStepper: activeStep must be between 0 and steps.length - 1',
       ),
       _direction = Axis.horizontal,
       _isCompact = false;

  /// Stepper that stacks the steps, each with its title and subtitle.
  const VStepper.vertical({
    required this.steps,
    super.key,
    this.activeStep,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
    this.style,
  }) : assert(steps.length > 0, 'VStepper: steps must not be empty'),
       assert(
         activeStep == null || (activeStep >= 0 && activeStep < steps.length),
         'VStepper: activeStep must be between 0 and steps.length - 1',
       ),
       _direction = Axis.vertical,
       _isCompact = false;

  /// Row of markers and connectors that shows progress without content.
  ///
  /// ```dart
  /// VStepper.compact(
  ///   activeStep: 2,
  ///   steps: [
  ///     VStep(title: Text('Step 1'), content: Container()),
  ///     VStep(title: Text('Step 2'), content: Container()),
  ///     VStep(title: Text('Step 3'), content: Container()),
  ///   ],
  /// )
  /// ```
  const VStepper.compact({
    required this.steps,
    super.key,
    this.activeStep,
    this.onStepTapped,
    this.style,
  }) : assert(steps.length > 0, 'VStepper: steps must not be empty'),
       assert(
         activeStep == null || (activeStep >= 0 && activeStep < steps.length),
         'VStepper: activeStep must be between 0 and steps.length - 1',
       ),
       _direction = Axis.horizontal,
       _isCompact = true,
       onStepContinue = null,
       onStepCancel = null,
       controlsBuilder = null;

  final Axis _direction;
  final bool _isCompact;

  /// Steps in order; must not be empty.
  final List<VStep> steps;

  /// Zero-based index of the active step; the first step when null.
  final int? activeStep;

  int get _effectiveActiveStep => activeStep ?? 0;

  /// Called with the index of a tapped step; steps are not tappable when null.
  final ValueChanged<int>? onStepTapped;

  /// Called when the continue control is pressed.
  final VoidCallback? onStepContinue;

  /// Called when the back control is pressed.
  final VoidCallback? onStepCancel;

  /// Replaces the default continue and back buttons.
  final VStepperControlsBuilder? controlsBuilder;

  /// Overrides the theme's [VStepperStyle] for this stepper.
  final VStepperStyle? style;

  int get _effectiveCurrentStep =>
      _effectiveActiveStep.clamp(0, steps.length - 1);

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget result;
    if (_isCompact) {
      result = _buildCompact(context);
    } else if (_direction == Axis.horizontal) {
      result = _buildHorizontal(context);
    } else {
      result = _buildVertical(context);
    }

    return FocusTraversalGroup(child: result);
  }

  Widget _buildCompact(BuildContext context) {
    final theme = VTheme.of(context);
    final colors = theme.colors;
    final compactThemeStyle = theme.componentOverrides.get<VStepperStyle>();
    final compactResolvedStyle = compactThemeStyle?.merge(style) ?? style;
    final connectorActiveColor =
        compactResolvedStyle?.connectorColor ?? colors.primary;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.lg,
        vertical: theme.spacing.sm,
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Connector
            final stepIndex = index ~/ 2;
            final isCompleted = stepIndex < _effectiveCurrentStep;
            return Expanded(
              child: Container(
                height: 2,
                color: isCompleted ? connectorActiveColor : colors.border,
              ),
            );
          }
          final stepIndex = index ~/ 2;
          return _buildStepMarker(context, stepIndex);
        }),
      ),
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    final theme = VTheme.of(context);
    final colors = theme.colors;
    final horzThemeStyle = theme.componentOverrides.get<VStepperStyle>();
    final horzResolvedStyle = horzThemeStyle?.merge(style) ?? style;
    final connectorActiveColor =
        horzResolvedStyle?.connectorColor ?? colors.primary;

    return Column(
      children: [
        // Step indicators
        Padding(
          padding: EdgeInsets.all(theme.spacing.lg),
          child: Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                // Connector
                final stepIndex = index ~/ 2;
                final isCompleted = stepIndex < _effectiveCurrentStep;
                return Expanded(
                  child: Container(
                    height: 1,
                    color: isCompleted ? connectorActiveColor : colors.border,
                  ),
                );
              }
              final stepIndex = index ~/ 2;
              return _buildStepMarker(context, stepIndex);
            }),
          ),
        ),
        // Current step content
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(theme.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: steps[_effectiveCurrentStep].content),
                SizedBox(height: theme.spacing.lg),
                _buildControls(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVertical(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: List.generate(
      steps.length,
      (index) => _buildVerticalStep(context, index),
    ),
  );

  Widget _buildVerticalStep(BuildContext context, int index) {
    final theme = VTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final vertThemeStyle = theme.componentOverrides.get<VStepperStyle>();
    final vertResolvedStyle = vertThemeStyle?.merge(style) ?? style;

    final step = steps[index];
    final isActive = index == _effectiveCurrentStep;
    final isLast = index == steps.length - 1;

    final titleStyle = typography.bodyLarge.copyWith(
      fontWeight: FontWeight.w500,
      color: step.state == VStepState.disabled
          ? colors.mutedForeground
          : colors.foreground,
    );
    final subtitleStyle = typography.bodySmall.copyWith(
      color: colors.mutedForeground,
    );

    final stepLabel = VoloLocalizations.of(
      context,
    ).stepperStepOf(index + 1, steps.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Focus(
          onKeyEvent: (node, event) => _activateOnKey(
            event,
            step.state != VStepState.disabled && onStepTapped != null
                ? () => onStepTapped!(index)
                : null,
          ),
          child: Builder(
            builder: (focusContext) {
              final isFocused = Focus.of(focusContext).hasFocus;
              final isTappable =
                  step.state != VStepState.disabled && onStepTapped != null;
              return Semantics(
                button: onStepTapped != null,
                enabled: step.state != VStepState.disabled,
                label: stepLabel,
                child: GestureDetector(
                  onTap: isTappable ? () => onStepTapped!(index) : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.spacing.lg,
                      vertical: theme.spacing.sm,
                    ),
                    decoration: isFocused && isTappable
                        ? BoxDecoration(
                            borderRadius: theme.radius.smRadius,
                            border: Border.all(color: colors.ring, width: 2),
                          )
                        : null,
                    child: Row(
                      children: [
                        _buildStepIcon(context, index),
                        SizedBox(width: theme.spacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DefaultTextStyle.merge(
                                style: titleStyle,
                                child: step.title,
                              ),
                              if (step.subtitle != null)
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: theme.spacing.xxs,
                                  ),
                                  child: DefaultTextStyle.merge(
                                    style: subtitleStyle,
                                    child: step.subtitle!,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Content and connector
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connector line
            SizedBox(
              width: theme.sizes.lg.height,
              child: Center(
                child: isLast
                    ? null
                    : Container(
                        width: 1,
                        height: isActive ? null : theme.sizes.md.height,
                        constraints: isActive
                            ? BoxConstraints(minHeight: theme.sizes.md.height)
                            : null,
                        color: index < _effectiveCurrentStep
                            ? (vertResolvedStyle?.connectorColor ??
                                  colors.primary)
                            : colors.border,
                      ),
              ),
            ),
            // Content
            if (isActive)
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: theme.spacing.lg,
                    bottom: theme.spacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      step.content,
                      SizedBox(height: theme.spacing.lg),
                      _buildControls(context),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // Enter and Space activate a focused step, like a tap.
  KeyEventResult _activateOnKey(KeyEvent event, VoidCallback? onTap) {
    if (onTap != null &&
        event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.numpadEnter ||
            event.logicalKey == LogicalKeyboardKey.space)) {
      onTap();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // Marker of the horizontal and compact layouts; tappable like the header of
  // the vertical layout when [onStepTapped] is set.
  Widget _buildStepMarker(BuildContext context, int index) {
    final icon = _buildStepIcon(context, index);
    final onStepTapped = this.onStepTapped;
    if (onStepTapped == null) return icon;

    final theme = VTheme.of(context);
    final step = steps[index];
    final isTappable = step.state != VStepState.disabled;
    final onTap = isTappable ? () => onStepTapped(index) : null;

    return Focus(
      canRequestFocus: isTappable,
      onKeyEvent: (node, event) => _activateOnKey(event, onTap),
      child: Builder(
        builder: (focusContext) {
          final isFocused = Focus.of(focusContext).hasFocus;
          return Semantics(
            button: true,
            enabled: isTappable,
            label: VoloLocalizations.of(
              context,
            ).stepperStepOf(index + 1, steps.length),
            onTap: onTap,
            excludeSemantics: true,
            child: GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: DecoratedBox(
                decoration: isFocused && isTappable
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colors.ring, width: 2),
                      )
                    : const BoxDecoration(),
                child: icon,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepIcon(BuildContext context, int index) {
    final theme = VTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    // Resolve style overrides
    final iconThemeStyle = theme.componentOverrides.get<VStepperStyle>();
    final iconResolvedStyle = iconThemeStyle?.merge(style) ?? style;

    final step = steps[index];
    final isActive = index == _effectiveCurrentStep;
    final isCompleted =
        step.state == VStepState.complete ||
        (index < _effectiveCurrentStep &&
            step.state != VStepState.error &&
            step.state != VStepState.disabled &&
            step.state != VStepState.editing);

    Color bgColor;
    Color fgColor;
    Widget child;

    if (step.state == VStepState.error) {
      bgColor = iconResolvedStyle?.errorColor ?? colors.destructive;
      fgColor = colors.destructiveForeground;
      child = VIcons.priorityHigh(
        color: colors.destructiveForeground,
        size: theme.sizes.sm.iconSize,
      );
    } else if (isCompleted) {
      bgColor = iconResolvedStyle?.completedColor ?? colors.primary;
      fgColor = colors.primaryForeground;
      child = VIcons.check(color: fgColor, size: theme.sizes.sm.iconSize);
    } else if (step.state == VStepState.editing) {
      bgColor = iconResolvedStyle?.activeColor ?? colors.primary;
      fgColor = colors.primaryForeground;
      child = VIcons.edit(color: fgColor, size: theme.sizes.xs.iconSize);
    } else if (step.state == VStepState.disabled) {
      bgColor = colors.muted;
      fgColor = iconResolvedStyle?.inactiveColor ?? colors.mutedForeground;
      child = Text(
        '${index + 1}',
        style: typography.labelSmall.copyWith(color: fgColor),
      );
    } else if (isActive) {
      bgColor = iconResolvedStyle?.activeColor ?? colors.primary;
      fgColor = colors.primaryForeground;
      child = Text(
        '${index + 1}',
        style: typography.labelSmall.copyWith(color: fgColor),
      );
    } else {
      bgColor = VColors.transparent;
      fgColor = iconResolvedStyle?.inactiveColor ?? colors.foreground;
      child = Text(
        '${index + 1}',
        style: typography.labelSmall.copyWith(color: fgColor),
      );
    }

    final isOutlined =
        !isActive &&
        !isCompleted &&
        step.state != VStepState.error &&
        step.state != VStepState.editing &&
        step.state != VStepState.disabled;

    return Container(
      width: theme.sizes.sm.height,
      height: theme.sizes.sm.height,
      decoration: BoxDecoration(
        color: isOutlined ? VColors.transparent : bgColor,
        shape: BoxShape.circle,
        border: isOutlined
            ? Border.all(color: colors.border, width: 1.5)
            : null,
      ),
      child: Center(child: child),
    );
  }

  Widget _buildControls(BuildContext context) {
    if (controlsBuilder != null) {
      return controlsBuilder!(
        context,
        onStepContinue: onStepContinue,
        onStepCancel: onStepCancel,
      );
    }

    final l10n = VoloLocalizations.of(context);
    final isFirst = _effectiveCurrentStep == 0;
    final isLast = _effectiveCurrentStep == steps.length - 1;

    return Row(
      children: [
        if (!isFirst)
          Padding(
            padding: EdgeInsetsDirectional.only(
              end: VTheme.of(context).spacing.sm,
            ),
            child: VButton.outlined(
              onPressed: onStepCancel,
              child: Text(l10n.stepperPrevious),
            ),
          ),
        VButton(
          onPressed: onStepContinue,
          child: Text(isLast ? l10n.stepperComplete : l10n.stepperNext),
        ),
      ],
    );
  }
}
