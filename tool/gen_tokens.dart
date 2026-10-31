// ignore_for_file: avoid_print
/// DTCG Token Parser for Flutter
///
/// Reads tokens/*.tokens.json files and generates
/// lib/src/theme/v_*.generated.dart files.
///
/// Usage: dart run tool/gen_tokens.dart [--check]
///
/// With --check nothing is written; the run exits 1 when any generated file
/// differs from what the token JSON would produce.
library;

import 'dart:convert';
import 'dart:io';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Convert kebab-case to camelCase.
/// Handles numeric prefixes: "4xl" -> "fourXl", "5xl" -> "fiveXl".
String camelCase(String s) {
  // Map numeric prefixes to words
  const numWords = {
    '2': 'two',
    '3': 'three',
    '4': 'four',
    '5': 'five',
    '6': 'six',
    '7': 'seven',
    '8': 'eight',
    '9': 'nine',
  };

  final parts = s.split('-');
  // Handle first part starting with a digit
  var first = parts.first;
  if (first.isNotEmpty && RegExp(r'^\d').hasMatch(first)) {
    final digit = first[0];
    final rest = first.substring(1);
    first = (numWords[digit] ?? digit) + rest.toUpperCase();
  }

  return first +
      parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
}

/// Parse a hex color string to a 0xAARRGGBB integer.
int parseHex(String hex) {
  final h = hex.replaceFirst('#', '').toUpperCase();
  if (h.length == 6) return int.parse('FF$h', radix: 16);
  if (h.length == 8) {
    // DTCG: last 2 chars are alpha -> convert to AARRGGBB
    final rgb = h.substring(0, 6);
    final alpha = h.substring(6, 8);
    return int.parse('$alpha$rgb', radix: 16);
  }
  throw FormatException('Invalid hex color: $hex');
}

/// Format a hex int as 0xFFRRGGBB string.
String hexStr(int v) =>
    '0x${v.toRadixString(16).toUpperCase().padLeft(8, '0')}';

/// Parse "123px" or "0.5em" -> double.
double parseDimension(String value) =>
    double.parse(value.replaceAll(RegExp(r'[a-z%]+$'), ''));

/// Parse "300ms" -> int milliseconds.
int parseDuration(String value) => int.parse(value.replaceAll('ms', ''));

/// Parse shadow hex color to RGBA values.
/// Returns (r, g, b, opacity) where opacity is 0.0..1.0.
({int r, int g, int b, double opacity}) parseShadowColor(String hex) {
  final h = hex.replaceFirst('#', '').toUpperCase();
  if (h.length == 6) {
    return (
      r: int.parse(h.substring(0, 2), radix: 16),
      g: int.parse(h.substring(2, 4), radix: 16),
      b: int.parse(h.substring(4, 6), radix: 16),
      opacity: 1.0,
    );
  }
  if (h.length == 8) {
    final rgb = h.substring(0, 6);
    final alpha = h.substring(6, 8);
    return (
      r: int.parse(rgb.substring(0, 2), radix: 16),
      g: int.parse(rgb.substring(2, 4), radix: 16),
      b: int.parse(rgb.substring(4, 6), radix: 16),
      opacity: int.parse(alpha, radix: 16) / 255.0,
    );
  }
  throw FormatException('Invalid shadow color: $hex');
}

// ---------------------------------------------------------------------------
// Token reading
// ---------------------------------------------------------------------------

/// Read a single token JSON file and return its entries.
Map<String, dynamic> readTokenFile(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw FileSystemException('Token file not found', path);
  }
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

/// Recursively extract token entries from a JSON object.
/// Returns a flat map of { name: { $value, $type, ... } }.
///
/// When [skipRoot] is true (default), the top-level group name is not
/// included in the key, so { "color": { "background": ... } } produces
/// "background" instead of "color-background".
Map<String, Map<String, dynamic>> flattenTokens(
  Map<String, dynamic> obj, {
  String prefix = '',
  String? parentType,
  bool skipRoot = true,
}) {
  final result = <String, Map<String, dynamic>>{};

  for (final entry in obj.entries) {
    final key = entry.key;
    if (key.startsWith(r'$')) continue; // skip $type, $description, etc.

    final value = entry.value;
    if (value is Map<String, dynamic>) {
      // Determine type: own $type or parent's
      final type = value[r'$type'] as String? ?? parentType;

      if (value.containsKey(r'$value')) {
        // This is a token leaf
        final tokenName = prefix.isEmpty ? key : '$prefix-$key';
        result[tokenName] = {...value, r'$type': type};
      } else {
        // Nested group
        final groupType = value[r'$type'] as String? ?? parentType;
        // Skip root: at top level (prefix is empty), don't add the group name
        final newPrefix = (skipRoot && prefix.isEmpty)
            ? ''
            : (prefix.isEmpty ? key : '$prefix-$key');
        result.addAll(
          flattenTokens(
            value,
            prefix: newPrefix,
            parentType: groupType,
            skipRoot: false,
          ),
        );
      }
    }
  }
  return result;
}

// ---------------------------------------------------------------------------
// Generators
// ---------------------------------------------------------------------------

/// Generate v_colors.generated.dart
String generateColors(
  Map<String, Map<String, dynamic>> lightTokens,
  Map<String, Map<String, dynamic>> darkTokens,
) {
  final fields = <String>[];
  final lightValues = <String>[];
  final darkValues = <String>[];

  // Use light tokens as the canonical field list
  for (final entry in lightTokens.entries) {
    final name = camelCase(entry.key);
    final lightHex = parseHex(entry.value[r'$value'] as String);

    fields.add('  final Color $name;');

    lightValues.add('    $name: Color(${hexStr(lightHex)}),');

    final darkEntry = darkTokens[entry.key];
    if (darkEntry != null) {
      final darkHex = parseHex(darkEntry[r'$value'] as String);
      darkValues.add('    $name: Color(${hexStr(darkHex)}),');
    }
  }

  final constructorParams = lightTokens.keys
      .map((k) => '    required this.${camelCase(k)},')
      .join('\n');
  final fieldDecls = fields.join('\n');

  return '''// GENERATED BY gen_tokens.dart -- DO NOT EDIT
// Source: tokens/color.tokens.json, tokens/color-dark.tokens.json

import 'package:flutter/widgets.dart';

/// Generated color defaults from DTCG tokens.
@immutable
class VColorsDefaults {
  const VColorsDefaults({
$constructorParams
  });

$fieldDecls

  static const VColorsDefaults zincLight = VColorsDefaults(
${lightValues.join('\n')}
  );

  static const VColorsDefaults zincDark = VColorsDefaults(
${darkValues.join('\n')}
  );
}
''';
}

/// Generate v_radius.generated.dart
String generateRadius(Map<String, Map<String, dynamic>> tokens) {
  final fields = <String>[];
  final values = <String>[];
  final constructorParams = <String>[];

  for (final entry in tokens.entries) {
    final name = camelCase(entry.key);
    final val = parseDimension(entry.value[r'$value'] as String);
    final intVal = val == val.truncateToDouble()
        ? val.toInt().toString()
        : val.toString();

    constructorParams.add('    required this.$name,');
    fields.add('  final double $name;');
    values.add('    $name: $intVal,');
  }

  return '''// GENERATED BY gen_tokens.dart -- DO NOT EDIT
// Source: tokens/radius.tokens.json

import 'package:flutter/widgets.dart';

/// Generated border radius defaults from DTCG tokens.
@immutable
class VRadiusDefaults {
  const VRadiusDefaults({
${constructorParams.join('\n')}
  });

${fields.join('\n')}

  static const VRadiusDefaults defaults = VRadiusDefaults(
${values.join('\n')}
  );
}
''';
}

/// Generate v_spacing.generated.dart
String generateSpacing(Map<String, Map<String, dynamic>> tokens) {
  final fields = <String>[];
  final values = <String>[];
  final constructorParams = <String>[];

  for (final entry in tokens.entries) {
    final name = camelCase(entry.key);
    final val = parseDimension(entry.value[r'$value'] as String);
    final intVal = val == val.truncateToDouble()
        ? val.toInt().toString()
        : val.toString();

    constructorParams.add('    required this.$name,');
    fields.add('  final double $name;');
    values.add('    $name: $intVal,');
  }

  return '''// GENERATED BY gen_tokens.dart -- DO NOT EDIT
// Source: tokens/spacing.tokens.json

import 'package:flutter/widgets.dart';

/// Generated spacing defaults from DTCG tokens.
@immutable
class VSpacingDefaults {
  const VSpacingDefaults({
${constructorParams.join('\n')}
  });

${fields.join('\n')}

  static const VSpacingDefaults defaults = VSpacingDefaults(
${values.join('\n')}
  );
}
''';
}

/// Generate v_shadows.generated.dart
String generateShadows(
  Map<String, Map<String, dynamic>> lightTokens,
  Map<String, Map<String, dynamic>> darkTokens,
) {
  String shadowLine(Map<String, dynamic> val) {
    final color = parseShadowColor(val['color'] as String);
    final offsetX = parseDimension(val['offsetX'] as String);
    final offsetY = parseDimension(val['offsetY'] as String);
    final blur = parseDimension(val['blur'] as String);
    final spread = parseDimension(val['spread'] as String);

    // Format opacity to reasonable precision
    final opStr = color.opacity
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '.0');

    final offsetStr = (offsetX == 0 && offsetY == 0)
        ? ''
        : '\n        offset: Offset(${offsetX.toInt()}, ${offsetY.toInt()}),';

    final spreadStr = spread != 0
        ? '\n        spreadRadius: ${spread.toInt()},'
        : '';

    return '''BoxShadow(
        color: Color.fromRGBO(${color.r}, ${color.g}, ${color.b}, $opStr),
        blurRadius: ${blur.toInt()},$spreadStr$offsetStr
      )''';
  }

  final fields = <String>[];
  final constructorParams = <String>[];
  final lightValues = <String>[];
  final darkValues = <String>[];

  for (final entry in lightTokens.entries) {
    final name = camelCase(entry.key);
    constructorParams.add('    required this.$name,');
    fields.add('  final List<BoxShadow> $name;');

    final val = entry.value[r'$value'] as Map<String, dynamic>;
    lightValues.add('    $name: [${shadowLine(val)}],');

    final darkEntry = darkTokens[entry.key];
    if (darkEntry != null) {
      final darkVal = darkEntry[r'$value'] as Map<String, dynamic>;
      darkValues.add('    $name: [${shadowLine(darkVal)}],');
    }
  }

  return '''// GENERATED BY gen_tokens.dart -- DO NOT EDIT
// Source: tokens/shadow.tokens.json, tokens/shadow-dark.tokens.json

import 'package:flutter/widgets.dart';

/// Generated shadow defaults from DTCG tokens.
@immutable
class VShadowsDefaults {
  const VShadowsDefaults({
${constructorParams.join('\n')}
  });

${fields.join('\n')}

  static const VShadowsDefaults light = VShadowsDefaults(
${lightValues.join('\n')}
  );

  static const VShadowsDefaults dark = VShadowsDefaults(
${darkValues.join('\n')}
  );
}
''';
}

/// Generate v_animations.generated.dart
String generateAnimations(
  Map<String, Map<String, dynamic>> durationTokens,
  Map<String, Map<String, dynamic>> easingTokens,
) {
  final constructorParams = <String>[];
  final fields = <String>[];
  final values = <String>[];

  // Durations
  for (final entry in durationTokens.entries) {
    final name = camelCase(entry.key);
    final ms = parseDuration(entry.value[r'$value'] as String);

    constructorParams.add('    required this.$name,');
    fields.add('  final Duration $name;');

    if (ms == 0) {
      values.add('    $name: Duration.zero,');
    } else {
      values.add('    $name: Duration(milliseconds: $ms),');
    }
  }

  // Easings -> curves
  // Map DTCG easing names to Dart field names
  final easingNameMap = {
    'linear': 'curveLinear',
    'ease-in': 'curveEaseIn',
    'ease-out': 'curveEaseOut',
    'ease-in-out': 'curveSmooth',
    'emphasized': 'curveDefault',
  };

  for (final entry in easingTokens.entries) {
    final dartName =
        easingNameMap[entry.key] ??
        'curve${camelCase(entry.key)[0].toUpperCase()}${camelCase(entry.key).substring(1)}';
    final bezier = entry.value[r'$value'] as List<dynamic>;

    constructorParams.add('    required this.$dartName,');
    fields.add('  final Curve $dartName;');
    values.add(
      '    $dartName: Cubic(${bezier[0]}, ${bezier[1]}, ${bezier[2]}, ${bezier[3]}),',
    );
  }

  return '''// GENERATED BY gen_tokens.dart -- DO NOT EDIT
// Source: tokens/duration.tokens.json, tokens/cubic-bezier.tokens.json

import 'package:flutter/widgets.dart';

/// Generated animation defaults from DTCG tokens.
@immutable
class VAnimationsDefaults {
  const VAnimationsDefaults({
${constructorParams.join('\n')}
  });

${fields.join('\n')}

  static const VAnimationsDefaults defaults = VAnimationsDefaults(
${values.join('\n')}
  );
}
''';
}

/// Generate v_sizes.generated.dart
String generateSizes(Map<String, Map<String, dynamic>> tokens) {
  final sizeEntries = <String, Map<String, dynamic>>{};

  for (final entry in tokens.entries) {
    final name = entry.key;
    final val = entry.value;
    final height = parseDimension(val[r'$value'] as String);
    final preset =
        (val[r'$extensions'] as Map<String, dynamic>?)?['volo.preset']
            as Map<String, dynamic>?;

    sizeEntries[name] = {
      'height': height,
      if (preset != null) ...{
        'paddingX': parseDimension(preset['paddingX'] as String),
        'paddingY': parseDimension(preset['paddingY'] as String),
        'fontSize': parseDimension(preset['fontSize'] as String),
        'iconSize': parseDimension(preset['iconSize'] as String),
        'gap': parseDimension(preset['gap'] as String),
        'radius': parseDimension(preset['radius'] as String),
      },
    };
  }

  // Build VComponentSize entries for all 5 sizes
  final sizesToGenerate = ['xs', 'sm', 'md', 'lg', 'xl'];
  final sizeValues = <String>[];

  for (final size in sizesToGenerate) {
    final data = sizeEntries[size];
    if (data == null) continue;

    final h = (data['height'] as double).toInt();
    final px = (data['paddingX'] as double).toInt();
    final py = (data['paddingY'] as double).toInt();
    final fs = (data['fontSize'] as double).toInt();
    final is_ = (data['iconSize'] as double).toInt();
    final sp = (data['gap'] as double).toInt();
    final rd = (data['radius'] as double).toInt();

    sizeValues.add('''    $size: VComponentSizeDefaults(
      height: $h,
      paddingHorizontal: $px,
      paddingVertical: $py,
      fontSize: $fs,
      iconSize: $is_,
      spacing: $sp,
      borderRadius: $rd,
    )''');
  }

  return '''// GENERATED BY gen_tokens.dart -- DO NOT EDIT
// Source: tokens/component-size.tokens.json

import 'package:flutter/widgets.dart';

/// Generated component size defaults from DTCG tokens.
@immutable
class VComponentSizeDefaults {
  const VComponentSizeDefaults({
    required this.height,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.fontSize,
    required this.iconSize,
    required this.spacing,
    required this.borderRadius,
  });

  final double height;
  final double paddingHorizontal;
  final double paddingVertical;
  final double fontSize;
  final double iconSize;
  final double spacing;
  final double borderRadius;
}

/// Generated size scale defaults from DTCG tokens.
@immutable
class VSizesDefaults {
  const VSizesDefaults({required this.xs, required this.sm, required this.md, required this.lg, required this.xl});

  final VComponentSizeDefaults xs;
  final VComponentSizeDefaults sm;
  final VComponentSizeDefaults md;
  final VComponentSizeDefaults lg;
  final VComponentSizeDefaults xl;

  static const VSizesDefaults defaults = VSizesDefaults(
${sizeValues.join(',\n')},
  );
}
''';
}

/// Parse gradient direction from extension to Alignment name.
String _alignmentFromName(String name) {
  const map = {
    'topLeft': 'Alignment.topLeft',
    'topCenter': 'Alignment.topCenter',
    'topRight': 'Alignment.topRight',
    'centerLeft': 'Alignment.centerLeft',
    'center': 'Alignment.center',
    'centerRight': 'Alignment.centerRight',
    'bottomLeft': 'Alignment.bottomLeft',
    'bottomCenter': 'Alignment.bottomCenter',
    'bottomRight': 'Alignment.bottomRight',
  };
  return map[name] ?? 'Alignment.topLeft';
}

/// Generate v_gradients.generated.dart
String generateGradients(Map<String, Map<String, dynamic>> tokens) {
  final fields = <String>[];
  final values = <String>[];
  final constructorParams = <String>[];

  for (final entry in tokens.entries) {
    final name = camelCase(entry.key);
    final stops = entry.value[r'$value'] as List<dynamic>;

    constructorParams.add('    required this.$name,');
    fields.add('  final LinearGradient $name;');

    final colorStrs = <String>[];
    for (final stop in stops) {
      final s = stop as Map<String, dynamic>;
      final color = parseHex(s['color'] as String);
      colorStrs.add('Color(${hexStr(color)})');
    }

    // Parse direction from extension or use default
    final extensions = entry.value[r'$extensions'] as Map<String, dynamic>?;
    final direction = extensions?['volo.direction'] as Map<String, dynamic>?;
    final beginAlign = _alignmentFromName(
      direction?['begin'] as String? ?? 'topLeft',
    );
    final endAlign = _alignmentFromName(
      direction?['end'] as String? ?? 'bottomRight',
    );

    values.add('''    $name: LinearGradient(
      begin: $beginAlign,
      end: $endAlign,
      colors: [${colorStrs.join(', ')}],
    ),''');
  }

  return '''// GENERATED BY gen_tokens.dart -- DO NOT EDIT
// Source: tokens/gradient.tokens.json

import 'package:flutter/widgets.dart';

/// Generated gradient defaults from DTCG tokens.
@immutable
class VGradientsDefaults {
  const VGradientsDefaults({
${constructorParams.join('\n')}
  });

${fields.join('\n')}

  static const VGradientsDefaults defaults = VGradientsDefaults(
${values.join('\n')}
  );
}
''';
}

/// Generate v_typography.generated.dart from composite typography tokens.
String generateTypography(
  Map<String, Map<String, dynamic>> fontFamilyTokens,
  Map<String, dynamic> typographyJson,
) {
  // Font families: keys are "family-sans", "family-mono" (from { font: { family: { sans, mono } } })
  final sans =
      (fontFamilyTokens['family-sans']?[r'$value'] as List<dynamic>?)?.first
          as String? ??
      'Pretendard Variable';
  final mono =
      (fontFamilyTokens['family-mono']?[r'$value'] as List<dynamic>?)?.first
          as String? ??
      'JetBrains Mono';

  // Read typography composite entries
  final typographyTokens = typographyJson['typography'] as Map<String, dynamic>;
  final textStyles = <String>[];

  // Define ordered keys to match existing output order (5 categories x 3 sizes)
  final orderedKeys = [
    'display-lg',
    'display-md',
    'display-sm',
    'headline-lg',
    'headline-md',
    'headline-sm',
    'title-lg',
    'title-md',
    'title-sm',
    'body-lg',
    'body-md',
    'body-sm',
    'label-lg',
    'label-md',
    'label-sm',
  ];

  for (final key in orderedKeys) {
    final token = typographyTokens[key];
    if (token == null) continue;

    final val =
        (token as Map<String, dynamic>)[r'$value'] as Map<String, dynamic>;

    // Convert key to Dart name: display-lg -> displayLarge
    final parts = key.split('-');
    final cat = parts[0];
    final size = parts.length > 1 ? parts[1] : '';
    final dartName =
        '$cat${size == 'lg'
            ? 'Large'
            : size == 'md'
            ? 'Medium'
            : size == 'sm'
            ? 'Small'
            : ''}';

    final fs = parseDimension(val['fontSize'] as String);
    final fontWeight = val['fontWeight'] as int;
    final lineHeight = (val['lineHeight'] as num).toDouble();
    final letterSpacing = parseDimension(val['letterSpacing'] as String);
    final letterSpacingStr = letterSpacing != 0
        ? '\n    letterSpacing: $letterSpacing,'
        : '';

    textStyles.add('''  static const TextStyle $dartName = TextStyle(
    fontSize: ${fs == fs.truncateToDouble() ? fs.toInt() : fs},
    fontWeight: FontWeight.w$fontWeight,$letterSpacingStr
    height: $lineHeight,
  );''');
  }

  return '''// GENERATED BY gen_tokens.dart -- DO NOT EDIT
// Source: tokens/typography.tokens.json

import 'package:flutter/widgets.dart';

/// Generated typography defaults from DTCG tokens.
class VTypographyDefaults {
  VTypographyDefaults._();

  static const String fontFamilySans = '$sans';
  static const String fontFamilyMono = '$mono';

${textStyles.join('\n\n')}
}
''';
}

/// Generate v_borders.generated.dart
String generateBorders(
  Map<String, Map<String, dynamic>> lightTokens,
  Map<String, Map<String, dynamic>> darkTokens,
) {
  final borderNames = <String>[];
  final constructorParams = <String>[];
  final fields = <String>[];
  final lightValues = <String>[];
  final darkValues = <String>[];

  for (final entry in lightTokens.entries) {
    final name = entry.key == 'default'
        ? 'defaultBorder'
        : camelCase(entry.key);
    borderNames.add(name);
    constructorParams.add('    required this.$name,');
    fields.add('  final VBorderStyleDefaults $name;');

    final val = entry.value[r'$value'] as Map<String, dynamic>;
    final color = parseHex(val['color'] as String);
    final width = parseDimension(val['width'] as String);
    final widthInt = width == width.truncateToDouble()
        ? width.toInt().toString()
        : width.toString();

    lightValues.add(
      '    $name: VBorderStyleDefaults(color: Color(${hexStr(color)}), width: $widthInt),',
    );

    final darkEntry = darkTokens[entry.key];
    if (darkEntry != null) {
      final darkVal = darkEntry[r'$value'] as Map<String, dynamic>;
      final darkColor = parseHex(darkVal['color'] as String);
      final darkWidth = parseDimension(darkVal['width'] as String);
      final darkWidthInt = darkWidth == darkWidth.truncateToDouble()
          ? darkWidth.toInt().toString()
          : darkWidth.toString();
      darkValues.add(
        '    $name: VBorderStyleDefaults(color: Color(${hexStr(darkColor)}), width: $darkWidthInt),',
      );
    }
  }

  return '''// GENERATED BY gen_tokens.dart -- DO NOT EDIT
// Source: tokens/border.tokens.json

import 'package:flutter/widgets.dart';

/// Generated border defaults from DTCG tokens.
@immutable
class VBorderStyleDefaults {
  const VBorderStyleDefaults({
    required this.color,
    required this.width,
  });

  final Color color;
  final double width;
}

/// Generated border preset defaults from DTCG tokens.
@immutable
class VBordersDefaults {
  const VBordersDefaults({
${constructorParams.join('\n')}
  });

${fields.join('\n')}

  static const VBordersDefaults light = VBordersDefaults(
${lightValues.join('\n')}
  );

  static const VBordersDefaults dark = VBordersDefaults(
${darkValues.join('\n')}
  );
}
''';
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

/// Set by --check: collect stale files instead of writing.
bool _checkOnly = false;
final List<String> _stale = [];

void main(List<String> args) {
  _checkOnly = args.contains('--check');
  final stopwatch = Stopwatch()..start();

  // Resolve paths relative to package root
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final packageRoot = scriptDir.parent;
  final tokensDir = Directory('${packageRoot.path}/lib/src/theme/tokens');
  final outputDir = Directory('${packageRoot.path}/lib/src/theme');

  if (!tokensDir.existsSync()) {
    print(
      'ERROR: lib/src/theme/tokens/ directory not found at ${tokensDir.path}',
    );
    print('Token files should be co-located with generated code.');
    exit(1);
  }

  print('Reading tokens from: ${tokensDir.path}');

  // --- Colors ---
  final colorLight = flattenTokens(
    readTokenFile('${tokensDir.path}/color.tokens.json'),
  );
  final colorDark = flattenTokens(
    readTokenFile('${tokensDir.path}/color-dark.tokens.json'),
  );
  _writeFile(
    '${outputDir.path}/v_colors.generated.dart',
    generateColors(colorLight, colorDark),
  );

  // --- Radius ---
  final radius = flattenTokens(
    readTokenFile('${tokensDir.path}/radius.tokens.json'),
  );
  _writeFile(
    '${outputDir.path}/v_radius.generated.dart',
    generateRadius(radius),
  );

  // --- Spacing ---
  final spacing = flattenTokens(
    readTokenFile('${tokensDir.path}/spacing.tokens.json'),
  );
  _writeFile(
    '${outputDir.path}/v_spacing.generated.dart',
    generateSpacing(spacing),
  );

  // --- Shadows ---
  final shadowLight = flattenTokens(
    readTokenFile('${tokensDir.path}/shadow.tokens.json'),
  );
  final shadowDark = flattenTokens(
    readTokenFile('${tokensDir.path}/shadow-dark.tokens.json'),
  );
  _writeFile(
    '${outputDir.path}/v_shadows.generated.dart',
    generateShadows(shadowLight, shadowDark),
  );

  // --- Animations (duration + easing) ---
  final duration = flattenTokens(
    readTokenFile('${tokensDir.path}/duration.tokens.json'),
  );
  final easing = flattenTokens(
    readTokenFile('${tokensDir.path}/cubic-bezier.tokens.json'),
  );
  _writeFile(
    '${outputDir.path}/v_animations.generated.dart',
    generateAnimations(duration, easing),
  );

  // --- Sizes (component-size) ---
  final sizes = flattenTokens(
    readTokenFile('${tokensDir.path}/component-size.tokens.json'),
  );
  _writeFile('${outputDir.path}/v_sizes.generated.dart', generateSizes(sizes));

  // --- Typography (composite) ---
  final fontFamily = flattenTokens(
    readTokenFile('${tokensDir.path}/font-family.tokens.json'),
  );
  final typography = readTokenFile('${tokensDir.path}/typography.tokens.json');
  _writeFile(
    '${outputDir.path}/v_typography.generated.dart',
    generateTypography(fontFamily, typography),
  );

  // --- Gradients ---
  final gradients = flattenTokens(
    readTokenFile('${tokensDir.path}/gradient.tokens.json'),
  );
  _writeFile(
    '${outputDir.path}/v_gradients.generated.dart',
    generateGradients(gradients),
  );

  // --- Borders ---
  final borderData = readTokenFile('${tokensDir.path}/border.tokens.json');
  final borderLight = flattenTokens({'border': borderData['border']});
  final borderDark = flattenTokens({'border-dark': borderData['border-dark']});
  // Normalize dark keys: remove "border-dark-" prefix, keep just the name
  final borderDarkNormalized = <String, Map<String, dynamic>>{};
  for (final entry in borderDark.entries) {
    // border-dark-default -> default, border-dark-strong -> strong
    final normalizedKey = entry.key.replaceFirst('border-dark-', '');
    borderDarkNormalized[normalizedKey] = entry.value;
  }
  // Also normalize light keys: border-default -> default
  final borderLightNormalized = <String, Map<String, dynamic>>{};
  for (final entry in borderLight.entries) {
    final normalizedKey = entry.key.replaceFirst('border-', '');
    borderLightNormalized[normalizedKey] = entry.value;
  }
  _writeFile(
    '${outputDir.path}/v_borders.generated.dart',
    generateBorders(borderLightNormalized, borderDarkNormalized),
  );

  stopwatch.stop();
  if (_checkOnly) {
    if (_stale.isNotEmpty) {
      print('Stale generated files (run `make tokens`):');
      for (final f in _stale) {
        print('  - $f');
      }
      exit(1);
    }
    print('Generated token files are up to date.');
    return;
  }
  print('Generated 9 files in ${stopwatch.elapsedMilliseconds}ms');
}

/// Formats [content] with the running Dart SDK's formatter so the output
/// matches what `dart format` leaves in the repository. The text goes through
/// a sibling temp file so the package's formatter settings apply.
String _format(String path, String content) {
  final tmp = File('$path.tmp.dart')..writeAsStringSync(content);
  try {
    final result = Process.runSync(Platform.resolvedExecutable, [
      'format',
      tmp.path,
    ]);
    if (result.exitCode != 0) {
      throw StateError('dart format failed for $path: ${result.stderr}');
    }
    return tmp.readAsStringSync();
  } finally {
    tmp.deleteSync();
  }
}

void _writeFile(String path, String rawContent) {
  final content = _format(path, rawContent);
  if (_checkOnly) {
    final f = File(path);
    if (!f.existsSync() || f.readAsStringSync() != content) _stale.add(path);
    return;
  }
  File(path).writeAsStringSync(content);
  print('  -> $path');
}
