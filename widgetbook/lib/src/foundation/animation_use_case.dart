import 'package:flutter/material.dart';
import 'package:volo_flutter_ui/volo_flutter_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import '../components/widgetbook_components.dart';

/// Animation component (Foundation).
WidgetbookComponent animationComponent() => WidgetbookComponent(
  name: 'Animation',
  useCases: [
    WidgetbookUseCase(
      name: 'overview',
      builder: (context) => const _AnimationShowcase(),
    ),
  ],
);

class _AnimationShowcase extends StatefulWidget {
  const _AnimationShowcase();

  @override
  State<_AnimationShowcase> createState() => _AnimationShowcaseState();
}

class _AnimationShowcaseState extends State<_AnimationShowcase> {
  int _durationKey = 0;
  int _curveKey = 0;

  void _replayDuration() {
    setState(() => _durationKey++);
  }

  void _replayCurve() {
    setState(() => _curveKey++);
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    final animations = theme.animations;

    return WidgetbookPageLayout(
      title: 'Animation',
      description:
          'Motion brings life to the UI. Use consistent durations and easing curves to create natural interactions.',
      children: [
        _DurationSection(
          key: ValueKey('duration_$_durationKey'),
          animations: animations,
          onReplay: _replayDuration,
        ),
        _CurveSection(
          key: ValueKey('curve_$_curveKey'),
          animations: animations,
          onReplay: _replayCurve,
        ),
        WidgetbookSection(
          title: 'Transitions',
          description:
              'Pre-composed transition tokens combining duration, delay, and timing function.',
          children: [
            Table(
              columnWidths: const {
                0: FixedColumnWidth(100),
                1: FixedColumnWidth(80),
                2: FixedColumnWidth(60),
                3: FixedColumnWidth(100),
                4: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: theme.colors.muted,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  children: const [
                    FoundationTableHeader('Name'),
                    FoundationTableHeader('Duration'),
                    FoundationTableHeader('Delay'),
                    FoundationTableHeader('Timing'),
                    FoundationTableHeader('Usage'),
                  ],
                ),
                _buildTransitionRow(
                  context,
                  'micro',
                  '75ms',
                  '0ms',
                  'ease-out',
                  'Micro-interaction (ripple, toggle, checkbox)',
                ),
                _buildTransitionRow(
                  context,
                  'fast',
                  '150ms',
                  '0ms',
                  'ease-out',
                  'Quick feedback (hover, focus)',
                ),
                _buildTransitionRow(
                  context,
                  'normal',
                  '300ms',
                  '0ms',
                  'ease-in-out',
                  'Standard transition (modal, dropdown)',
                ),
                _buildTransitionRow(
                  context,
                  'slow',
                  '500ms',
                  '0ms',
                  'ease-in-out',
                  'Complex or attention-grabbing',
                ),
                _buildTransitionRow(
                  context,
                  'emphasized',
                  '300ms',
                  '0ms',
                  'emphasized',
                  'Dramatic entrance with emphasized deceleration',
                ),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Micro Interactions',
          description: 'Recommended animation settings per component.',
          children: [
            Table(
              columnWidths: const {
                0: FlexColumnWidth(),
                1: FixedColumnWidth(100),
                2: FixedColumnWidth(100),
                3: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: theme.colors.muted,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  children: const [
                    FoundationTableHeader('Action'),
                    FoundationTableHeader('Duration'),
                    FoundationTableHeader('Curve'),
                    FoundationTableHeader('Effect'),
                  ],
                ),
                _buildMicroInteractionRow(
                  context,
                  'Button hover',
                  'fast',
                  'ease-out',
                  'Scale 1.02',
                ),
                _buildMicroInteractionRow(
                  context,
                  'Button press',
                  'fast',
                  'ease-out',
                  'Scale 0.98',
                ),
                _buildMicroInteractionRow(
                  context,
                  'Modal open',
                  'normal',
                  'ease-in-out',
                  'Scale + Fade',
                ),
                _buildMicroInteractionRow(
                  context,
                  'Toast appear',
                  'normal',
                  'ease-out',
                  'Slide up + Fade',
                ),
                _buildMicroInteractionRow(
                  context,
                  'Success feedback',
                  'normal',
                  'emphasized',
                  'Scale',
                ),
                _buildMicroInteractionRow(
                  context,
                  'Loading pulse',
                  'slow',
                  'ease-in-out',
                  'Opacity',
                ),
              ],
            ),
          ],
        ),
        WidgetbookSection(
          title: 'Usage Guidelines',
          description: 'Guidelines to consider when applying animations.',
          children: [
            Table(
              columnWidths: const {
                0: FixedColumnWidth(120),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(2),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: theme.colors.muted,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  children: const [
                    FoundationTableHeader('Duration'),
                    FoundationTableHeader('When to use'),
                    FoundationTableHeader('Examples'),
                  ],
                ),
                _buildGuidelineRow(
                  context,
                  'instant (0ms)',
                  'Instant feedback',
                  'Checkbox toggle, radio select, color change',
                ),
                _buildGuidelineRow(
                  context,
                  'micro (75ms)',
                  'Micro-interactions',
                  'Ripple effect, switch toggle, checkbox check',
                ),
                _buildGuidelineRow(
                  context,
                  'fast (150ms)',
                  'Quick micro interactions',
                  'Button hover, focus ring, tooltip appear',
                ),
                _buildGuidelineRow(
                  context,
                  'normal (300ms)',
                  'Standard UI transitions',
                  'Modal open/close, accordion expand, page transition',
                ),
                _buildGuidelineRow(
                  context,
                  'slow (500ms)',
                  'Complex sequence animations',
                  'Skeleton loading, onboarding',
                ),
                _buildGuidelineRow(
                  context,
                  'slower (700ms)',
                  'Multi-step sequences',
                  'Elaborate entrance, staggered animations',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  TableRow _buildTransitionRow(
    BuildContext context,
    String name,
    String duration,
    String delay,
    String timing,
    String usage,
  ) {
    final theme = VTheme.of(context);
    return TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colors.border)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            name,
            style: theme.typography.labelMedium.copyWith(
              fontFamily: theme.typography.fontFamilyMono,
              fontWeight: FontWeight.bold,
              color: theme.colors.foreground,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            duration,
            style: theme.typography.labelSmall.copyWith(
              fontFamily: theme.typography.fontFamilyMono,
              color: theme.colors.foreground,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            delay,
            style: theme.typography.labelSmall.copyWith(
              fontFamily: theme.typography.fontFamilyMono,
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            timing,
            style: theme.typography.labelSmall.copyWith(
              fontFamily: theme.typography.fontFamilyMono,
              color: theme.colors.foreground,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            usage,
            style: theme.typography.bodySmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildMicroInteractionRow(
    BuildContext context,
    String action,
    String duration,
    String curve,
    String effect,
  ) {
    final theme = VTheme.of(context);
    return TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colors.border)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            action,
            style: theme.typography.bodySmall.copyWith(
              color: theme.colors.foreground,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            duration,
            style: theme.typography.labelSmall.copyWith(
              fontFamily: theme.typography.fontFamilyMono,
              color: theme.colors.foreground,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            curve,
            style: theme.typography.labelSmall.copyWith(
              fontFamily: theme.typography.fontFamilyMono,
              color: theme.colors.foreground,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            effect,
            style: theme.typography.bodySmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildGuidelineRow(
    BuildContext context,
    String duration,
    String whenToUse,
    String examples,
  ) {
    final theme = VTheme.of(context);
    return TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colors.border)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            duration,
            style: theme.typography.labelMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colors.foreground,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            whenToUse,
            style: theme.typography.bodySmall.copyWith(
              color: theme.colors.foreground,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            examples,
            style: theme.typography.bodySmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}

class _DurationSection extends StatelessWidget {
  const _DurationSection({
    required this.animations,
    required this.onReplay,
    super.key,
  });

  final VAnimations animations;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Duration',
              style: theme.typography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colors.foreground,
              ),
            ),
            const SizedBox(width: 8),
            Semantics(
              button: true,
              label: 'Replay animation',
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onReplay,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colors.muted,
                      borderRadius: theme.radius.smRadius,
                    ),
                    child: Icon(
                      Icons.replay,
                      size: 16,
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Animation durations. Choose the appropriate duration based on interaction complexity.',
          style: theme.typography.bodySmall.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            _DurationDemo(
              name: 'instant',
              duration: animations.instant,
              description: '0ms\nInstant toggle',
              usage: 'Toggle, checkbox',
            ),
            _DurationDemo(
              name: 'micro',
              duration: animations.micro,
              description: '75ms\nMicro-interaction (ripple, checkbox, switch)',
              usage: 'Ripple, switch',
            ),
            _DurationDemo(
              name: 'fast',
              duration: animations.fast,
              description: '150ms\nHover, focus feedback',
              usage: 'Hover, focus',
            ),
            _DurationDemo(
              name: 'normal',
              duration: animations.normal,
              description: '300ms\nModal, dropdown, page section',
              usage: 'Modal, dropdown',
            ),
            _DurationDemo(
              name: 'slow',
              duration: animations.slow,
              description: '500ms\nPage transition, complex animation',
              usage: 'Page transition',
            ),
            _DurationDemo(
              name: 'slower',
              duration: animations.slower,
              description: '700ms\nMulti-step sequence, elaborate entrance',
              usage: 'Elaborate entrance',
            ),
            _DurationDemo(
              name: 'verySlow',
              duration: animations.verySlow,
              description: '1000ms\nLoading, fade-in',
              usage: 'Loading state',
            ),
            _DurationDemo(
              name: 'extraSlow',
              duration: animations.extraSlow,
              description: '1500ms\nSkeleton, progress',
              usage: 'Skeleton, progress',
            ),
            _DurationDemo(
              name: 'snackbar',
              duration: animations.snackbar,
              description: '4000ms\nSnackbar display',
              usage: 'Snackbar auto-dismiss',
            ),
            _DurationDemo(
              name: 'toast',
              duration: animations.toast,
              description: '5000ms\nToast display',
              usage: 'Toast auto-dismiss',
            ),
          ],
        ),
      ],
    );
  }
}

class _CurveSection extends StatelessWidget {
  const _CurveSection({
    required this.animations,
    required this.onReplay,
    super.key,
  });

  final VAnimations animations;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Easing Curves',
              style: theme.typography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colors.foreground,
              ),
            ),
            const SizedBox(width: 8),
            Semantics(
              button: true,
              label: 'Replay animation',
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onReplay,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colors.muted,
                      borderRadius: theme.radius.smRadius,
                    ),
                    child: Icon(
                      Icons.replay,
                      size: 16,
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Easing curves define the acceleration/deceleration of animations. Use appropriate curves to create natural motion.',
          style: theme.typography.bodySmall.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            _CurveDemo(
              name: 'linear',
              curve: animations.curveLinear,
              description: 'cubic(0, 0, 1, 1)\nNo acceleration',
              usage: 'Color, opacity, progress',
            ),
            _CurveDemo(
              name: 'ease-in',
              curve: animations.curveEaseIn,
              description: 'cubic(0.42, 0, 1, 1)\nAccelerate (exit)',
              usage: 'Move off-screen',
            ),
            _CurveDemo(
              name: 'ease-out',
              curve: animations.curveEaseOut,
              description: 'cubic(0, 0, 0.58, 1)\nDecelerate (enter)',
              usage: 'Move on-screen',
            ),
            _CurveDemo(
              name: 'ease-in-out',
              curve: animations.curveSmooth,
              description: 'cubic(0.42, 0, 0.58, 1)\nSymmetric transition',
              usage: 'Default animation',
            ),
            _CurveDemo(
              name: 'emphasized',
              curve: animations.curveDefault,
              description: 'cubic(0.33, 1, 0.68, 1)\nDramatic deceleration',
              usage: 'Hero entrance',
            ),
            _CurveDemo(
              name: 'bouncy',
              curve: animations.curveBouncy,
              description: 'Flutter elasticOut\nSpring overshoot',
              usage: 'Button tap, card entrance',
            ),
          ],
        ),
      ],
    );
  }
}

class _DurationDemo extends StatefulWidget {
  const _DurationDemo({
    required this.name,
    required this.duration,
    required this.description,
    required this.usage,
  });

  final String name;
  final Duration duration;
  final String description;
  final String usage;

  @override
  State<_DurationDemo> createState() => _DurationDemoState();
}

class _DurationDemoState extends State<_DurationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Use actual duration, minimum 100ms for instant
    final animDuration = widget.duration.inMilliseconds > 0
        ? widget.duration
        : const Duration(milliseconds: 100);

    _controller = AnimationController(vsync: this, duration: animDuration)
      ..forward(); // Play once, no repeat
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Animation preview box
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: theme.colors.muted,
              borderRadius: theme.radius.mdRadius,
              border: Border.all(color: theme.colors.border),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Stack(
                children: [
                  // Background track
                  Positioned(
                    left: 16,
                    right: 16,
                    top: 42,
                    child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: theme.colors.border.withValues(alpha: 0.3),
                        borderRadius: theme.radius.mdRadius,
                      ),
                    ),
                  ),
                  // Animated bar
                  Positioned(
                    left: 16,
                    top: 42,
                    child: Container(
                      width: 16 + (_controller.value * (180 - 48)),
                      height: 16,
                      decoration: BoxDecoration(
                        color: theme.colors.primary,
                        borderRadius: theme.radius.mdRadius,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.name,
            style: theme.typography.labelMedium.copyWith(
              fontFamily: theme.typography.fontFamilyMono,
              fontWeight: FontWeight.bold,
              color: theme.colors.foreground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.description,
            style: theme.typography.labelSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colors.accent,
              borderRadius: theme.radius.smRadius,
            ),
            child: Text(
              widget.usage,
              style: theme.typography.labelSmall.copyWith(
                color: theme.colors.accentForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurveDemo extends StatefulWidget {
  const _CurveDemo({
    required this.name,
    required this.curve,
    required this.description,
    required this.usage,
  });

  final String name;
  final Curve curve;
  final String description;
  final String usage;

  @override
  State<_CurveDemo> createState() => _CurveDemoState();
}

class _CurveDemoState extends State<_CurveDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _controller.forward(); // Play once, no repeat
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);

    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Curve visualization
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: theme.colors.muted,
              borderRadius: theme.radius.mdRadius,
              border: Border.all(color: theme.colors.border),
            ),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => Stack(
                children: [
                  // Grid lines
                  CustomPaint(
                    size: const Size(180, 100),
                    painter: _GridPainter(color: theme.colors.border),
                  ),
                  // Ball animation
                  Positioned(
                    left: 16 + (_animation.value * (180 - 48)),
                    top: 100 - 24 - (_animation.value * (100 - 48)),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: theme.colors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.name,
            style: theme.typography.labelMedium.copyWith(
              fontFamily: theme.typography.fontFamilyMono,
              fontWeight: FontWeight.bold,
              color: theme.colors.foreground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.description,
            style: theme.typography.labelSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colors.accent,
              borderRadius: theme.radius.smRadius,
            ),
            child: Text(
              widget.usage,
              style: theme.typography.labelSmall.copyWith(
                color: theme.colors.accentForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    // Horizontal lines
    for (var i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Vertical lines
    for (var i = 1; i < 6; i++) {
      final x = size.width * i / 6;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
