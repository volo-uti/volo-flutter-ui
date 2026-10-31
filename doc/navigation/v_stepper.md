# VStepper

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VStepper

Multi-step flow with numbered markers, step content and controls.

Lays out horizontally, vertically or as a compact progress row.

## Basic Usage

A basic horizontal stepper:

```dart
VStepper(
  activeStep: _currentStep,
  steps: [
    VStep(title: Text('Account Info'), content: AccountForm()),
    VStep(title: Text('Personal Info'), content: ProfileForm()),
    VStep(title: Text('Confirmation'), content: ConfirmationView()),
  ],
  onStepContinue: () => setState(() => _currentStep++),
  onStepCancel: () => setState(() => _currentStep--),
)
```

## Variants

Three layouts are supported:

- [VStepper] / [VStepper.horizontal] - Horizontal layout (default)
- [VStepper.vertical] - Vertical layout
- [VStepper.compact] - Compact (progress only)

## Horizontal Stepper

A horizontal stepper:

```dart
VStepper.horizontal(
  activeStep: _step,
  steps: [
    VStep(title: Text('Shipping'), content: AddressForm()),
    VStep(title: Text('Payment'), content: PaymentForm()),
    VStep(title: Text('Complete'), content: OrderComplete()),
  ],
  onStepTapped: (index) => setState(() => _step = index),
)
```

## Step States

Various states can be displayed per step:

```dart
VStepper(
  activeStep: 1,
  steps: [
    VStep(
      title: Text('Completed step'),
      content: Container(),
      state: VStepState.complete,
    ),
    VStep(
      title: Text('Current step'),
      subtitle: Text('Please enter your information'),
      content: CurrentForm(),
      state: VStepState.editing,
    ),
    VStep(
      title: Text('Next step'),
      content: Container(),
      state: VStepState.indexed,
    ),
    VStep(
      title: Text('Error step'),
      content: Container(),
      state: VStepState.error,
    ),
    VStep(
      title: Text('Disabled step'),
      content: Container(),
      state: VStepState.disabled,
    ),
  ],
)
```

## Custom Controls

Configure custom control buttons:

```dart
VStepper(
  activeStep: _step,
  steps: steps,
  controlsBuilder: (context, {onStepContinue, onStepCancel}) {
    return Row(
      children: [
        if (_step > 0)
          VButton.ghost(
            onPressed: onStepCancel,
            child: Text('Back'),
          ),
        Spacer(),
        VButton(
          onPressed: onStepContinue,
          child: Text(_step == steps.length - 1 ? 'Submit' : 'Continue'),
        ),
      ],
    );
  },
)
```

See also:

 * [VProgress], simple progress indicator
 * [VStep], individual step definition
 * [VStepState], step state enumeration

### Constructors

#### `VStepper`

Stepper with markers on top and the active step's content below.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `steps` | `List<VStep>` |  | yes | Steps in order; must not be empty. |
| `activeStep` | `int?` |  |  | Zero-based index of the active step; the first step when null. |
| `onStepTapped` | `void Function(int)?` |  |  | Called with the index of a tapped step; steps are not tappable when null. |
| `onStepContinue` | `void Function()?` |  |  | Called when the continue control is pressed. |
| `onStepCancel` | `void Function()?` |  |  | Called when the back control is pressed. |
| `controlsBuilder` | `Widget Function(BuildContext, {void Function()? onStepCancel, void Function()? onStepContinue})?` |  |  | Replaces the default continue and back buttons. |
| `style` | `VStepperStyle?` |  |  | Overrides the theme's [VStepperStyle] for this stepper. |

#### `VStepper.horizontal`

Same as [VStepper], spelled out as the horizontal layout.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `steps` | `List<VStep>` |  | yes | Steps in order; must not be empty. |
| `activeStep` | `int?` |  |  | Zero-based index of the active step; the first step when null. |
| `onStepTapped` | `void Function(int)?` |  |  | Called with the index of a tapped step; steps are not tappable when null. |
| `onStepContinue` | `void Function()?` |  |  | Called when the continue control is pressed. |
| `onStepCancel` | `void Function()?` |  |  | Called when the back control is pressed. |
| `controlsBuilder` | `Widget Function(BuildContext, {void Function()? onStepCancel, void Function()? onStepContinue})?` |  |  | Replaces the default continue and back buttons. |
| `style` | `VStepperStyle?` |  |  | Overrides the theme's [VStepperStyle] for this stepper. |

#### `VStepper.vertical`

Stepper that stacks the steps, each with its title and subtitle.

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `steps` | `List<VStep>` |  | yes | Steps in order; must not be empty. |
| `activeStep` | `int?` |  |  | Zero-based index of the active step; the first step when null. |
| `onStepTapped` | `void Function(int)?` |  |  | Called with the index of a tapped step; steps are not tappable when null. |
| `onStepContinue` | `void Function()?` |  |  | Called when the continue control is pressed. |
| `onStepCancel` | `void Function()?` |  |  | Called when the back control is pressed. |
| `controlsBuilder` | `Widget Function(BuildContext, {void Function()? onStepCancel, void Function()? onStepContinue})?` |  |  | Replaces the default continue and back buttons. |
| `style` | `VStepperStyle?` |  |  | Overrides the theme's [VStepperStyle] for this stepper. |

#### `VStepper.compact`

Row of markers and connectors that shows progress without content.

```dart
VStepper.compact(
  activeStep: 2,
  steps: [
    VStep(title: Text('Step 1'), content: Container()),
    VStep(title: Text('Step 2'), content: Container()),
    VStep(title: Text('Step 3'), content: Container()),
  ],
)
```

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `steps` | `List<VStep>` |  | yes | Steps in order; must not be empty. |
| `activeStep` | `int?` |  |  | Zero-based index of the active step; the first step when null. |
| `onStepTapped` | `void Function(int)?` |  |  | Called with the index of a tapped step; steps are not tappable when null. |
| `style` | `VStepperStyle?` |  |  | Overrides the theme's [VStepperStyle] for this stepper. |

## VStepState

Progress state of one [VStep], which picks its marker.

### Values

| Value | Description |
|---|---|
| `indexed` | Numbered marker (default). |
| `editing` | Pencil marker for the step being edited. |
| `complete` | Check marker for a finished step. |
| `disabled` | Muted marker; the step cannot be tapped. |
| `error` | Exclamation marker for a step with a problem. |

## VStep

One step of a [VStepper] with a title, optional subtitle and content.

```dart
VStep(
  title: Text('Shipping'),
  subtitle: Text('Where should we send it?'),
  state: VStepState.editing,
  content: AddressForm(),
)
```

### Constructors

#### `VStep`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `title` | `Widget` |  | yes | Heading of the step, usually a [Text] that takes the stepper title style. |
| `content` | `Widget` |  | yes | Body shown while the step is the active one. |
| `subtitle` | `Widget?` |  |  | Line under the title, usually a [Text] that takes the muted caption style. |
| `state` | `VStepState` | `VStepState.indexed` |  | Marker and tap behavior of the step. |

## VStepperControlsBuilder

Builds the continue and cancel controls of a [VStepper].

```dart
typedef VStepperControlsBuilder = Widget Function(BuildContext, {void Function()? onStepCancel, void Function()? onStepContinue});
```

## VStepperStyle

Style override for [VStepper].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VStepperStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `activeColor` | `Color?` |  |  | Active step color. |
| `inactiveColor` | `Color?` |  |  | Inactive step color. |
| `completedColor` | `Color?` |  |  | Completed step color. |
| `errorColor` | `Color?` |  |  | Error step color. |
| `connectorColor` | `Color?` |  |  | Connector line color. |

### Members

| Member | Description |
|---|---|
| `VStepperStyle copyWith({Color? activeColor, Color? inactiveColor, Color? completedColor, Color? errorColor, Color? connectorColor})` | Creates a copy with only the specified properties changed. |
