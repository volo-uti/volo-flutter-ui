import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import 'package:volo_flutter_ui/src/theme/theme.dart';
import 'v_image_style.dart';

/// Image from an asset, URL, file or memory with fade-in, placeholder and error states.
///
/// Pick the source with [VImage.asset], [VImage.network], [VImage.file] or
/// [VImage.memory].
///
/// ```dart
/// VImage.network(
///   'https://example.com/photo.jpg',
///   width: 200,
///   height: 200,
///   borderRadius: BorderRadius.circular(16),
///   placeholder: Center(child: VLoadingSpinner()),
///   semanticLabel: 'Team photo',
/// )
/// ```
class VImage extends StatefulWidget {
  /// Image bundled with the app at [assetPath].
  const VImage.asset(
    this.assetPath, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.semanticLabel,
    this.style,
  }) : _type = _VImageType.asset,
       networkUrl = null,
       file = null,
       bytes = null,
       cacheWidth = null,
       cacheHeight = null,
       headers = null;

  /// Image loaded from the URL [networkUrl].
  const VImage.network(
    this.networkUrl, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.cacheWidth,
    this.cacheHeight,
    this.headers,
    this.semanticLabel,
    this.style,
  }) : _type = _VImageType.network,
       assetPath = null,
       file = null,
       bytes = null;

  /// Image read from the local [file].
  const VImage.file(
    this.file, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.semanticLabel,
    this.style,
  }) : _type = _VImageType.file,
       assetPath = null,
       networkUrl = null,
       bytes = null,
       cacheWidth = null,
       cacheHeight = null,
       headers = null;

  /// Image decoded from [bytes].
  const VImage.memory(
    this.bytes, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.semanticLabel,
    this.style,
  }) : _type = _VImageType.memory,
       assetPath = null,
       networkUrl = null,
       file = null,
       cacheWidth = null,
       cacheHeight = null,
       headers = null;

  final _VImageType _type;

  /// Asset key; set only on [VImage.asset].
  final String? assetPath;

  /// Address to load; set only on [VImage.network].
  final String? networkUrl;

  /// File to read; set only on [VImage.file].
  final File? file;

  /// Encoded image bytes; set only on [VImage.memory].
  final Uint8List? bytes;

  /// Width of the image box; null sizes it from the image.
  final double? width;

  /// Height of the image box; null sizes it from the image.
  final double? height;

  /// How the image is inscribed into its box.
  final BoxFit fit;

  /// Widget shown until the first frame decodes.
  final Widget? placeholder;

  /// Widget shown when loading fails; defaults to a "!" mark.
  final Widget? errorWidget;

  /// Corner radius the image is clipped to.
  final BorderRadius? borderRadius;

  /// Length of the fade-in once the image has loaded.
  final Duration fadeInDuration;

  /// Width in pixels the image is decoded at; only on [VImage.network].
  final int? cacheWidth;

  /// Height in pixels the image is decoded at; only on [VImage.network].
  final int? cacheHeight;

  /// HTTP headers sent with the request; only on [VImage.network].
  final Map<String, String>? headers;

  /// Label announced by screen readers.
  final String? semanticLabel;

  /// Per-instance style override merged over the theme style.
  final VImageStyle? style;

  @override
  State<VImage> createState() => _VImageState();
}

enum _VImageType { asset, network, file, memory }

enum _VImageLoadState { loading, loaded, error }

class _VImageState extends State<VImage> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  _VImageLoadState _loadState = _VImageLoadState.loading;
  late ImageProvider _imageProvider;

  // WHY: Fade-in animation on image load — prevents jarring pop-in especially
  // for network images. The sentinel pattern (same as VTooltip/VHoverCard)
  // substitutes the theme animation token when the caller uses the default.
  /// Sentinel value matching the constructor default for [VImage.fadeInDuration].
  static const Duration _defaultFadeInDuration = Duration(milliseconds: 300);

  /// Returns the effective fade-in duration, preferring the theme token
  /// when the caller uses the constructor default.
  Duration _effectiveFadeInDuration(VThemeData theme) {
    if (widget.fadeInDuration == _defaultFadeInDuration) {
      return theme.animations.normal;
    }
    return widget.fadeInDuration;
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: widget.fadeInDuration,
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _loadImage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = VTheme.maybeOf(context);
    if (theme != null) {
      _fadeController.duration = _effectiveFadeInDuration(theme);
    }
  }

  @override
  void didUpdateWidget(VImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldReload(oldWidget)) {
      _loadState = _VImageLoadState.loading;
      _fadeController.reset();
      _loadImage();
    }
  }

  bool _shouldReload(VImage oldWidget) =>
      widget.assetPath != oldWidget.assetPath ||
      widget.networkUrl != oldWidget.networkUrl ||
      widget.file != oldWidget.file ||
      widget.bytes != oldWidget.bytes;

  void _loadImage() {
    switch (widget._type) {
      case _VImageType.asset:
        _imageProvider = AssetImage(widget.assetPath!);
        break;
      case _VImageType.network:
        _imageProvider = NetworkImage(
          widget.networkUrl!,
          headers: widget.headers,
        );
        break;
      case _VImageType.file:
        _imageProvider = FileImage(widget.file!);
        break;
      case _VImageType.memory:
        _imageProvider = MemoryImage(widget.bytes!);
        break;
    }
  }

  void _onImageLoaded() {
    if (mounted) {
      setState(() {
        _loadState = _VImageLoadState.loaded;
      });
      unawaited(_fadeController.forward());
    }
  }

  void _onImageError() {
    if (mounted) {
      setState(() {
        _loadState = _VImageLoadState.error;
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = VTheme.of(context);
    // Apply style overrides (Level 3 → Level 4 cascade)
    final themeStyle = theme.componentOverrides.get<VImageStyle>();
    final resolvedStyle = themeStyle?.merge(widget.style) ?? widget.style;

    var imageProvider = _imageProvider;

    // PERF: ResizeImage wraps the provider to decode at the target resolution
    // instead of full resolution. This significantly reduces memory usage
    // for large network images displayed in small containers.
    if (widget.cacheWidth != null || widget.cacheHeight != null) {
      imageProvider = ResizeImage(
        imageProvider,
        width: widget.cacheWidth,
        height: widget.cacheHeight,
      );
    }

    Widget imageWidget = Image(
      image: imageProvider,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      // CONSTRAINT: frameBuilder fires for each decoded frame. When
      // wasSynchronouslyLoaded is true (asset/memory), the image is ready
      // immediately so we still apply the fade. When frame != null, at least
      // one frame has decoded (network images report null until first frame).
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          if (_loadState != _VImageLoadState.loaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onImageLoaded();
            });
          }
          return FadeTransition(opacity: _fadeAnimation, child: child);
        }
        return widget.placeholder ?? const SizedBox.shrink();
      },
      errorBuilder: (context, error, stackTrace) {
        if (_loadState != _VImageLoadState.error) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _onImageError();
          });
        }
        return widget.errorWidget ??
            SizedBox(
              width: widget.width,
              height: widget.height,
              child: Center(
                child: Text(
                  '!',
                  style: TextStyle(
                    fontSize: VTheme.of(
                      context,
                    ).typography.headlineSmall.fontSize,
                  ),
                ),
              ),
            );
      },
    );

    final effectiveBorderRadius =
        resolvedStyle?.borderRadius ?? widget.borderRadius;
    if (effectiveBorderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: imageWidget,
      );
    }

    if (widget.semanticLabel != null) {
      imageWidget = Semantics(
        image: true,
        label: widget.semanticLabel,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
