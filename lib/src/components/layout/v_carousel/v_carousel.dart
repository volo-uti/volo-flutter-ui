import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:volo_flutter_ui/src/components/navigation/v_page_indicator/v_page_indicator.dart';
import 'package:volo_flutter_ui/src/theme/theme.dart';

import 'v_carousel_style.dart';

/// Builds a custom page indicator for [VCarousel].
///
/// [total] is the slide count and [current] the zero-based visible slide.
typedef VCarouselIndicatorBuilder =
    Widget Function(BuildContext context, int total, int current);

/// Where [VCarousel] draws its page indicator.
enum VCarouselIndicatorPosition {
  /// Bottom inside the carousel.
  bottom,

  /// Below the carousel.
  belowCarousel,

  /// Overlay on the carousel.
  overlay,

  /// Hidden.
  none,
}

/// {@template v_carousel}
/// Swipeable slides with indicator, auto-play and arrow keys.
///
/// A [PageView] of [children] that also pages by tapping a slide, by the
/// indicator dots and by Left, Right, Home and End. [onPageChanged] reports
/// the visible slide. With [loop] false, auto-play and arrow keys stop at the
/// last slide.
///
/// ## Basic Usage:
///
/// Default carousel (80% viewport):
///
/// ```dart
/// VCarousel(
///   height: 200,
///   children: [
///     Image.network('https://example.com/image1.jpg'),
///     Image.network('https://example.com/image2.jpg'),
///     Image.network('https://example.com/image3.jpg'),
///   ],
/// )
/// ```
///
/// ## Variants:
///
/// - [VCarousel.new] - Default carousel (80% viewport, peek on both sides)
/// - [VCarousel.fullWidth] - Full width carousel (100% viewport)
/// - [VCarousel.card] - Card gallery carousel (85% viewport)
/// - [VCarousel.hero] - Hero banner carousel (auto-play, loop)
///
/// ## Full Width Banner:
///
/// Full width banner carousel:
///
/// ```dart
/// VCarousel.fullWidth(
///   height: 300,
///   autoPlay: true,
///   loop: true,
///   children: [
///     Container(color: Colors.red),
///     Container(color: Colors.green),
///     Container(color: Colors.blue),
///   ],
/// )
/// ```
///
/// ## Hero Banner:
///
/// Auto-playing hero banner:
///
/// ```dart
/// VCarousel.hero(
///   height: 250,
///   autoPlayInterval: Duration(seconds: 5),
///   children: [
///     Image.network('https://example.com/hero1.jpg', fit: BoxFit.cover),
///     Image.network('https://example.com/hero2.jpg', fit: BoxFit.cover),
///   ],
/// )
/// ```
///
/// ## Custom Indicator:
///
/// ```dart
/// VCarousel(
///   height: 200,
///   indicatorBuilder: (context, total, current) {
///     return VPageIndicator.number(
///       total: total,
///       current: current,
///     );
///   },
///   children: [...],
/// )
/// ```
///
/// See also:
///
/// - [VCarouselIndicatorPosition], indicator position options
/// - [VPageIndicator], custom indicator
/// - [PageController], controller for page control
/// - [VCarouselIndicatorBuilder], signature of [indicatorBuilder]
/// {@endtemplate}
class VCarousel extends StatefulWidget {
  /// {@macro v_carousel}
  ///
  /// Default carousel (80% viewport).
  const VCarousel({
    required this.children,
    super.key,
    this.controller,
    this.onPageChanged,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.height,
    this.aspectRatio,
    this.viewportFraction = 0.8,
    this.padEnds = true,
    this.showIndicator = true,
    this.indicatorPosition = VCarouselIndicatorPosition.bottom,
    this.indicatorBuilder,
    this.loop = false,
    this.pageSpacing = 8,
    this.style,
  });

  /// Full width carousel (100% viewport).
  ///
  /// Uses full width without peek on sides.
  ///
  /// ```dart
  /// VCarousel.fullWidth(
  ///   height: 300,
  ///   children: bannerWidgets,
  /// )
  /// ```
  const VCarousel.fullWidth({
    required this.children,
    super.key,
    this.controller,
    this.onPageChanged,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.height,
    this.aspectRatio,
    this.showIndicator = true,
    this.indicatorPosition = VCarouselIndicatorPosition.bottom,
    this.indicatorBuilder,
    this.loop = false,
    this.pageSpacing = 0,
    this.style,
  }) : viewportFraction = 1.0,
       padEnds = false;

  /// Card gallery carousel (85% viewport).
  ///
  /// Next/previous cards are slightly visible on both sides.
  ///
  /// ```dart
  /// VCarousel.card(
  ///   height: 200,
  ///   children: cardWidgets,
  /// )
  /// ```
  const VCarousel.card({
    required this.children,
    super.key,
    this.controller,
    this.onPageChanged,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.height,
    this.aspectRatio,
    this.showIndicator = true,
    this.indicatorPosition = VCarouselIndicatorPosition.bottom,
    this.indicatorBuilder,
    this.loop = false,
    this.pageSpacing = 12,
    this.style,
  }) : viewportFraction = 0.85,
       padEnds = true;

  /// Hero banner carousel.
  ///
  /// Auto-play and infinite loop are enabled by default.
  /// Overlay indicator is displayed.
  ///
  /// ```dart
  /// VCarousel.hero(
  ///   height: 250,
  ///   children: heroImages,
  /// )
  /// ```
  const VCarousel.hero({
    required this.children,
    super.key,
    this.controller,
    this.onPageChanged,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.height,
    this.aspectRatio,
    this.showIndicator = true,
    this.indicatorPosition = VCarouselIndicatorPosition.overlay,
    this.indicatorBuilder,
    this.loop = true,
    this.pageSpacing = 0,
    this.style,
  }) : viewportFraction = 1.0,
       padEnds = false;

  /// Slides, one per page; an empty list renders nothing.
  final List<Widget> children;

  /// Controls the visible page; the carousel creates its own when null.
  final PageController? controller;

  /// Called with the zero-based index when the visible slide changes.
  final ValueChanged<int>? onPageChanged;

  /// Whether slides advance on their own every [autoPlayInterval].
  final bool autoPlay;

  /// Time between automatic slide changes.
  final Duration autoPlayInterval;

  /// Fixed height; wins over [aspectRatio] and defaults to 200 when both are null.
  final double? height;

  /// Width divided by height, used when [height] is null.
  final double? aspectRatio;

  /// Share of the width one slide takes; below 1 the neighbours peek in.
  final double viewportFraction;

  /// Whether the first and last slide are centered by padding the ends.
  final bool padEnds;

  /// Whether the page indicator is shown.
  final bool showIndicator;

  /// Where the page indicator is drawn.
  final VCarouselIndicatorPosition indicatorPosition;

  /// Builds the page indicator instead of the default dots.
  ///
  /// If not provided, default [VPageIndicator.dots] is used.
  ///
  /// ```dart
  /// VCarousel(
  ///   indicatorBuilder: (context, total, current) {
  ///     return VPageIndicator.number(
  ///       total: total,
  ///       current: current,
  ///     );
  ///   },
  ///   children: [...],
  /// )
  /// ```
  final VCarouselIndicatorBuilder? indicatorBuilder;

  /// Whether auto-play and arrow keys wrap from the last slide to the first.
  final bool loop;

  /// Horizontal gap between slides.
  final double pageSpacing;

  /// Overrides the theme style, for example the indicator colors.
  final VCarouselStyle? style;

  @override
  State<VCarousel> createState() => _VCarouselState();
}

class _VCarouselState extends State<VCarousel> {
  // WHY: PageController with viewportFraction — controls how much of adjacent
  // pages peek into view. Default 0.8 shows 10% of prev/next slides, giving
  // users a visual cue that more content exists (affordance principle).
  late PageController _pageController;

  /// The controller created by this state, or null when the caller owns it.
  PageController? _ownedController;
  int _currentPage = 0;

  /// Last page passed to [VCarousel.onPageChanged], to report each page once.
  int _reportedPage = 0;
  Timer? _autoPlayTimer;
  final FocusNode _focusNode = FocusNode();

  /// Updated to theme.animations.normal in didChangeDependencies.
  Duration _animationDuration = VAnimations.defaults.normal;
  Curve _animationCurve = VAnimations.defaults.curveSmooth;

  int _clampPage(int page) {
    final last = widget.children.length - 1;
    return last < 0 ? 0 : page.clamp(0, last);
  }

  PageController _resolveController(int initialPage) {
    final external = widget.controller;
    if (external != null) {
      _ownedController = null;
      return external;
    }
    return _ownedController = PageController(
      initialPage: initialPage,
      viewportFraction: widget.viewportFraction,
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = _resolveController(0);
    // A caller's controller may start on any page.
    _currentPage = _clampPage(
      widget.controller != null ? _pageController.initialPage : 0,
    );
    _reportedPage = _currentPage;
    _startAutoPlay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.of(context);
    _animationDuration = theme.animations.normal;
    _animationCurve = theme.animations.curveSmooth;
  }

  @override
  void didUpdateWidget(VCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    final controllerChanged = widget.controller != oldWidget.controller;
    final fractionChanged =
        widget.controller == null &&
        widget.viewportFraction != oldWidget.viewportFraction;
    if (controllerChanged || fractionChanged) {
      final previous = _ownedController;
      _pageController = _resolveController(_currentPage);
      if (widget.controller != null) {
        _currentPage = _clampPage(_pageController.initialPage);
      }
      if (previous != null) {
        // The PageView still holds the old controller until this frame ends.
        WidgetsBinding.instance.addPostFrameCallback((_) => previous.dispose());
      }
    }

    // Slides were removed beneath the visible page.
    if (widget.children.length != oldWidget.children.length &&
        _currentPage > _clampPage(_currentPage)) {
      _currentPage = _clampPage(_currentPage);
      final page = _currentPage;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_pageController.hasClients) _pageController.jumpToPage(page);
        _reportPage(page);
      });
    }

    if (widget.autoPlay != oldWidget.autoPlay ||
        widget.autoPlayInterval != oldWidget.autoPlayInterval ||
        widget.children.length != oldWidget.children.length) {
      _stopAutoPlay();
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _focusNode.dispose();
    _ownedController?.dispose();
    super.dispose();
  }

  void _reportPage(int page) {
    if (page == _reportedPage) return;
    _reportedPage = page;
    widget.onPageChanged?.call(page);
  }

  /// Handle keyboard events (WCAG 2.2 SC 2.5.7).
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final total = widget.children.length;
    if (total <= 1) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (_currentPage > 0) {
        _animateToPage(_currentPage - 1);
      } else if (widget.loop) {
        _animateToPage(total - 1);
      }
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (_currentPage < total - 1) {
        _animateToPage(_currentPage + 1);
      } else if (widget.loop) {
        _animateToPage(0);
      }
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.home) {
      _animateToPage(0);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.end) {
      _animateToPage(total - 1);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _startAutoPlay() {
    if (!widget.autoPlay || widget.children.length <= 1) return;

    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!mounted || !_pageController.hasClients) return;

      final nextPage = _currentPage + 1;
      if (nextPage >= widget.children.length) {
        if (widget.loop) {
          unawaited(
            _pageController.animateToPage(
              0,
              duration: _animationDuration,
              curve: _animationCurve,
            ),
          );
        }
      } else {
        unawaited(
          _pageController.nextPage(
            duration: _animationDuration,
            curve: _animationCurve,
          ),
        );
      }
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _reportPage(page);
  }

  void _animateToPage(int page) {
    if (page == _currentPage) return;
    unawaited(
      _pageController.animateToPage(
        page,
        duration: _animationDuration,
        curve: _animationCurve,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = VTheme.of(context);
    // Apply style overrides
    final themeStyle = theme.componentOverrides.get<VCarouselStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    // CONSTRAINT: ScrollConfiguration override is needed because Flutter's
    // default scroll behavior only enables touch drag. Adding mouse and
    // trackpad ensures the carousel is swipeable on desktop platforms.
    Widget carousel = ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        padEnds: widget.padEnds,
        itemCount: widget.children.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _animateToPage(index),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.pageSpacing / 2),
            child: widget.children[index],
          ),
        ),
      ),
    );

    // Keyboard support (WCAG 2.2 SC 2.5.7)
    carousel = Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: carousel,
    );

    // Apply height or aspect ratio
    if (widget.height != null) {
      carousel = SizedBox(height: widget.height, child: carousel);
    } else if (widget.aspectRatio != null) {
      carousel = AspectRatio(aspectRatio: widget.aspectRatio!, child: carousel);
    } else {
      carousel = SizedBox(height: 200, child: carousel);
    }

    // Layout based on indicator position
    if (!widget.showIndicator ||
        widget.indicatorPosition == VCarouselIndicatorPosition.none) {
      return carousel;
    }

    final indicator = _buildIndicator(theme, resolvedStyle);

    switch (widget.indicatorPosition) {
      case VCarouselIndicatorPosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            carousel,
            SizedBox(height: theme.spacing.sm),
            indicator,
          ],
        );

      case VCarouselIndicatorPosition.belowCarousel:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            carousel,
            SizedBox(height: theme.spacing.md),
            indicator,
          ],
        );

      case VCarouselIndicatorPosition.overlay:
        return Stack(
          children: [
            carousel,
            Positioned(
              left: 0,
              right: 0,
              bottom: theme.spacing.md,
              child: indicator,
            ),
          ],
        );

      case VCarouselIndicatorPosition.none:
        return carousel;
    }
  }

  Widget _buildIndicator(VThemeData theme, VCarouselStyle? resolvedStyle) {
    // Use custom indicator builder
    if (widget.indicatorBuilder != null) {
      return widget.indicatorBuilder!(
        context,
        widget.children.length,
        _currentPage,
      );
    }

    // Use default VPageIndicator.dots
    return VPageIndicator.dots(
      total: widget.children.length,
      current: _currentPage,
      onPageChanged: _animateToPage,
      activeSize: 8,
      spacing: theme.spacing.xxs * 2,
      activeColor: resolvedStyle?.indicatorActiveColor ?? theme.colors.primary,
      inactiveColor:
          resolvedStyle?.indicatorInactiveColor ??
          theme.colors.mutedForeground.withValues(alpha: 0.3),
    );
  }
}
