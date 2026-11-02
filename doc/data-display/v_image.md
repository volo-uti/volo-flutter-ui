# VImage

Import: `package:volo_flutter_ui/volo_flutter_ui.dart`

## VImage

Image from an asset, URL, file or memory with fade-in, placeholder and error states.

Pick the source with [VImage.asset], [VImage.network], [VImage.file] or
[VImage.memory].

```dart
VImage.network(
  'https://example.com/photo.jpg',
  width: 200,
  height: 200,
  borderRadius: BorderRadius.circular(16),
  placeholder: Center(child: VLoadingSpinner()),
  semanticLabel: 'Team photo',
)
```

### Constructors

#### `VImage.asset`

Image bundled with the app at [assetPath].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `assetPath` | `String?` |  | yes | Asset key; set only on [VImage.asset]. |
| `width` | `double?` |  |  | Width of the image box; null sizes it from the image. |
| `height` | `double?` |  |  | Height of the image box; null sizes it from the image. |
| `fit` | `BoxFit` | `BoxFit.cover` |  | How the image is inscribed into its box. |
| `placeholder` | `Widget?` |  |  | Widget shown until the first frame decodes. |
| `errorWidget` | `Widget?` |  |  | Widget shown when loading fails; defaults to a "!" mark. |
| `borderRadius` | `BorderRadius?` |  |  | Corner radius the image is clipped to. |
| `fadeInDuration` | `Duration` | `const Duration(milliseconds: 300)` |  | Length of the fade-in once the image has loaded. |
| `semanticLabel` | `String?` |  |  | Label announced by screen readers. |
| `style` | `VImageStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VImage.network`

Image loaded from the URL [networkUrl].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `networkUrl` | `String?` |  | yes | Address to load; set only on [VImage.network]. |
| `width` | `double?` |  |  | Width of the image box; null sizes it from the image. |
| `height` | `double?` |  |  | Height of the image box; null sizes it from the image. |
| `fit` | `BoxFit` | `BoxFit.cover` |  | How the image is inscribed into its box. |
| `placeholder` | `Widget?` |  |  | Widget shown until the first frame decodes. |
| `errorWidget` | `Widget?` |  |  | Widget shown when loading fails; defaults to a "!" mark. |
| `borderRadius` | `BorderRadius?` |  |  | Corner radius the image is clipped to. |
| `fadeInDuration` | `Duration` | `const Duration(milliseconds: 300)` |  | Length of the fade-in once the image has loaded. |
| `cacheWidth` | `int?` |  |  | Width in pixels the image is decoded at; only on [VImage.network]. |
| `cacheHeight` | `int?` |  |  | Height in pixels the image is decoded at; only on [VImage.network]. |
| `headers` | `Map<String, String>?` |  |  | HTTP headers sent with the request; only on [VImage.network]. |
| `semanticLabel` | `String?` |  |  | Label announced by screen readers. |
| `style` | `VImageStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VImage.file`

Image read from the local [file].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `file` | `File?` |  | yes | File to read; set only on [VImage.file]. |
| `width` | `double?` |  |  | Width of the image box; null sizes it from the image. |
| `height` | `double?` |  |  | Height of the image box; null sizes it from the image. |
| `fit` | `BoxFit` | `BoxFit.cover` |  | How the image is inscribed into its box. |
| `placeholder` | `Widget?` |  |  | Widget shown until the first frame decodes. |
| `errorWidget` | `Widget?` |  |  | Widget shown when loading fails; defaults to a "!" mark. |
| `borderRadius` | `BorderRadius?` |  |  | Corner radius the image is clipped to. |
| `fadeInDuration` | `Duration` | `const Duration(milliseconds: 300)` |  | Length of the fade-in once the image has loaded. |
| `semanticLabel` | `String?` |  |  | Label announced by screen readers. |
| `style` | `VImageStyle?` |  |  | Per-instance style override merged over the theme style. |

#### `VImage.memory`

Image decoded from [bytes].

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `bytes` | `Uint8List?` |  | yes | Encoded image bytes; set only on [VImage.memory]. |
| `width` | `double?` |  |  | Width of the image box; null sizes it from the image. |
| `height` | `double?` |  |  | Height of the image box; null sizes it from the image. |
| `fit` | `BoxFit` | `BoxFit.cover` |  | How the image is inscribed into its box. |
| `placeholder` | `Widget?` |  |  | Widget shown until the first frame decodes. |
| `errorWidget` | `Widget?` |  |  | Widget shown when loading fails; defaults to a "!" mark. |
| `borderRadius` | `BorderRadius?` |  |  | Corner radius the image is clipped to. |
| `fadeInDuration` | `Duration` | `const Duration(milliseconds: 300)` |  | Length of the fade-in once the image has loaded. |
| `semanticLabel` | `String?` |  |  | Label announced by screen readers. |
| `style` | `VImageStyle?` |  |  | Per-instance style override merged over the theme style. |

## VImageStyle

Style override for [VImage].

All properties are nullable — `null` means "use the theme default".
Supports cascade: theme override → instance override.

### Constructors

#### `VImageStyle`

| Parameter | Type | Default | Required | Description |
|---|---|---|---|---|
| `borderRadius` | `BorderRadius?` |  |  | Border radius. |
| `backgroundColor` | `Color?` |  |  | Fill behind the image box; none when null.<br>It shows while the image loads, after an error and through transparent pixels, clipped to the corner radius. An instance style wins over the theme override. |

### Members

| Member | Description |
|---|---|
| `VImageStyle copyWith({BorderRadius? borderRadius, Color? backgroundColor})` | Creates a copy with only the specified properties changed. |
