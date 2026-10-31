import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';

void main() => runApp(const ExampleApp());

/// Example app demonstrating volo_flutter_ui components.
///
/// Showcases key components: VButton, VTextField, VSelect, VCheckbox,
/// VRadio, VSwitch, VCard, VAlert, VBadge, VAvatar, VProgress, VTabs.
class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => VApp(
    themeMode: VAppThemeMode.light,
    builder: (context, _) => const _DemoPage(),
  );
}

class _DemoPage extends StatefulWidget {
  const _DemoPage();

  @override
  State<_DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<_DemoPage> {
  bool _checkboxValue = false;
  bool _switchValue = false;
  String _radioValue = 'email';
  String? _selectValue;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final colors = theme.colors;
    final spacing = theme.spacing;

    return ColoredBox(
      color: colors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- Header --
              Text(
                'volo_flutter_ui Example',
                style: theme.typography.headlineMedium.copyWith(
                  color: colors.foreground,
                ),
              ),
              SizedBox(height: spacing.xs),
              Text(
                'Component showcase with 9 design token types.',
                style: theme.typography.bodyMedium.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
              SizedBox(height: spacing.xl),

              // -- Buttons --
              const _SectionTitle(title: 'Buttons'),
              SizedBox(height: spacing.sm),
              Wrap(
                spacing: spacing.sm,
                runSpacing: spacing.sm,
                children: [
                  VButton(onPressed: () {}, child: const Text('Primary')),
                  VButton.outlined(
                    onPressed: () {},
                    child: const Text('Outlined'),
                  ),
                  VButton.text(onPressed: () {}, child: const Text('Text')),
                  VButton.ghost(onPressed: () {}, child: const Text('Ghost')),
                  VButton(
                    onPressed: () {},
                    color: VButtonColor.destructive,
                    child: const Text('Destructive'),
                  ),
                  const VButton(loading: true, child: Text('Loading')),
                ],
              ),
              SizedBox(height: spacing.xl),

              // -- Divider --
              const VDivider(),
              SizedBox(height: spacing.md),

              // -- Text Field --
              const _SectionTitle(title: 'Text Field'),
              SizedBox(height: spacing.sm),
              const VTextField(
                name: 'email',
                label: 'Email',
                placeholder: 'you@example.com',
              ),
              SizedBox(height: spacing.md),
              const VTextField.password(
                name: 'password',
                label: 'Password',
                placeholder: 'Enter your password',
              ),
              SizedBox(height: spacing.xl),

              // -- Select --
              const _SectionTitle(title: 'Select'),
              SizedBox(height: spacing.sm),
              VSelect<String>(
                value: _selectValue,
                onChanged: (v) => setState(() => _selectValue = v),
                items: const [
                  VSelectItem(value: 'flutter', label: 'Flutter'),
                  VSelectItem(value: 'react', label: 'React Native'),
                  VSelectItem(value: 'swift', label: 'SwiftUI'),
                  VSelectItem(value: 'kotlin', label: 'Jetpack Compose'),
                ],
                label: 'Framework',
                placeholder: 'Choose a framework',
              ),
              SizedBox(height: spacing.xl),

              // -- Checkbox --
              const _SectionTitle(title: 'Checkbox'),
              SizedBox(height: spacing.sm),
              VCheckbox(
                value: _checkboxValue,
                onChanged: (v) => setState(() => _checkboxValue = v ?? false),
                label: const Text('I agree to the terms and conditions'),
              ),
              SizedBox(height: spacing.xl),

              // -- Radio --
              const _SectionTitle(title: 'Radio'),
              SizedBox(height: spacing.sm),
              VRadio<String>.group(
                options: const [
                  VRadioItem(value: 'email', label: Text('Email')),
                  VRadioItem(value: 'sms', label: Text('SMS')),
                  VRadioItem(value: 'push', label: Text('Push Notification')),
                ],
                groupValue: _radioValue,
                onChanged: (v) {
                  if (v != null) setState(() => _radioValue = v);
                },
              ),
              SizedBox(height: spacing.xl),

              // -- Switch --
              const _SectionTitle(title: 'Switch'),
              SizedBox(height: spacing.sm),
              VSwitch(
                value: _switchValue,
                onChanged: (v) => setState(() => _switchValue = v),
                label: const Text('Enable notifications'),
                sublabel: const Text('Receive push notifications for updates'),
              ),
              SizedBox(height: spacing.xl),

              // -- Divider --
              const VDivider(),
              SizedBox(height: spacing.md),

              // -- Tooltip --
              const _SectionTitle(title: 'Tooltip'),
              SizedBox(height: spacing.sm),
              VTooltip(
                message: 'This is a helpful tooltip',
                child: VButton.outlined(
                  onPressed: () {},
                  child: const Text('Hover me'),
                ),
              ),
              SizedBox(height: spacing.xl),

              // -- Card --
              const _SectionTitle(title: 'Card'),
              SizedBox(height: spacing.sm),
              VCard(
                child: Padding(
                  padding: EdgeInsets.all(spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Card Title',
                        style: theme.typography.titleMedium.copyWith(
                          color: colors.foreground,
                        ),
                      ),
                      SizedBox(height: spacing.xs),
                      Text(
                        'This is a card component with shadow elevation. '
                        'Cards group related content together.',
                        style: theme.typography.bodySmall.copyWith(
                          color: colors.mutedForeground,
                        ),
                      ),
                      SizedBox(height: spacing.md),
                      Wrap(
                        spacing: spacing.sm,
                        children: [
                          VButton.outlined(
                            onPressed: () {},
                            size: VButtonSize.sm,
                            child: const Text('Cancel'),
                          ),
                          VButton(
                            onPressed: () {},
                            size: VButtonSize.sm,
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing.xl),

              // -- Accordion --
              const _SectionTitle(title: 'Accordion'),
              SizedBox(height: spacing.sm),
              const VAccordion(
                children: [
                  VAccordionItem(
                    title: Text('What is volo_flutter_ui?'),
                    content: Text(
                      'A Zero Material Dependencies Flutter UI component library with token-driven theming.',
                    ),
                  ),
                  VAccordionItem(
                    title: Text('Getting Started'),
                    content: Text(
                      'Add volo_flutter_ui to your pubspec.yaml and wrap your app with VApp.',
                    ),
                  ),
                  VAccordionItem(
                    title: Text('Customization'),
                    content: Text(
                      'Override VThemeData tokens to match your brand identity.',
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.xl),

              // -- Divider --
              const VDivider(),
              SizedBox(height: spacing.md),

              // -- Alerts --
              const _SectionTitle(title: 'Alerts'),
              SizedBox(height: spacing.sm),
              const VAlert.info(
                title: Text('Information'),
                description: Text('This is an informational message.'),
              ),
              SizedBox(height: spacing.sm),
              const VAlert.success(
                title: Text('Success'),
                description: Text('Your changes have been saved.'),
              ),
              SizedBox(height: spacing.sm),
              const VAlert.warning(
                title: Text('Warning'),
                description: Text('Your session will expire in 5 minutes.'),
              ),
              SizedBox(height: spacing.sm),
              const VAlert.error(
                title: Text('Error'),
                description: Text('Failed to save. Please try again.'),
              ),
              SizedBox(height: spacing.xl),

              // -- Badge & Avatar --
              const _SectionTitle(title: 'Badge & Avatar'),
              SizedBox(height: spacing.sm),
              Wrap(
                spacing: spacing.md,
                runSpacing: spacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: const [
                  VAvatar.text('KM', size: VAvatarSize.lg),
                  VAvatar.text('AB'),
                  VBadge(label: Text('Default')),
                  VBadge.primary(label: Text('Primary')),
                  VBadge.success(label: Text('Success')),
                  VBadge.warning(label: Text('Warning')),
                  VBadge.destructive(label: Text('Error')),
                ],
              ),
              SizedBox(height: spacing.xl),

              // -- Progress --
              const _SectionTitle(title: 'Progress'),
              SizedBox(height: spacing.sm),
              const VProgress.linear(value: 0.65),
              SizedBox(height: spacing.md),
              Row(
                children: [
                  const VProgress.circular(value: 0.4, size: VProgressSize.sm),
                  SizedBox(width: spacing.md),
                  const VProgress.circular(value: 0.7),
                  SizedBox(width: spacing.md),
                  const VProgress.circular(size: VProgressSize.lg),
                ],
              ),
              SizedBox(height: spacing.xl),

              // -- Tabs --
              const _SectionTitle(title: 'Tabs'),
              SizedBox(height: spacing.sm),
              SizedBox(
                height: 120,
                child: VTabs(
                  tabs: [
                    VTab(
                      label: const Text('Profile'),
                      content: Center(
                        child: Text(
                          'Profile content area',
                          style: theme.typography.bodyMedium.copyWith(
                            color: colors.foreground,
                          ),
                        ),
                      ),
                    ),
                    VTab(
                      label: const Text('Settings'),
                      content: Center(
                        child: Text(
                          'Settings content area',
                          style: theme.typography.bodyMedium.copyWith(
                            color: colors.foreground,
                          ),
                        ),
                      ),
                    ),
                    VTab(
                      label: const Text('About'),
                      content: Center(
                        child: Text(
                          'About content area',
                          style: theme.typography.bodyMedium.copyWith(
                            color: colors.foreground,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing.xl),

              // -- Footer --
              Center(
                child: Text(
                  'volo_flutter_ui v0.0.1',
                  style: theme.typography.labelSmall.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ),
              SizedBox(height: spacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    return Text(
      title,
      style: theme.typography.titleLarge.copyWith(
        color: theme.colors.foreground,
      ),
    );
  }
}
