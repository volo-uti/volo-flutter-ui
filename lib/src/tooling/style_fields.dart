// Pure Dart (no Flutter): used by `dart run tool/style_fields.dart`.
import 'dart:io';

import 'package:volo_flutter_ui/src/tooling/dart_source.dart';

/// Style fields read only by a widget in another component folder, with why.
///
/// Keys are `Class.field`. Keep the list short: a field belongs to the widget
/// that owns the style.
const styleFieldsReadElsewhere = <String, String>{};

/// A field declared by a style class in a `v_x_style.dart` file.
class StyleField {
  /// Creates a field record.
  const StyleField(this.className, this.name, this.line);

  /// Declaring class, e.g. `VButtonStyle`.
  final String className;

  /// Field name, e.g. `padding`.
  final String name;

  /// Line of the field name in the style file.
  final int line;

  /// `Class.field`.
  String get id => '$className.$name';
}

/// Instance fields of the classes named `...Style` in [source], in order.
List<StyleField> styleFieldsOf(String source) {
  final code = blankCommentsAndStrings(source);
  final fields = <StyleField>[];
  for (final c in RegExp(r'\bclass\s+(\w+Style)\b[^{;]*\{').allMatches(code)) {
    final top = _classTopLevel(code, c.end);
    for (final f in _field.allMatches(top)) {
      final name = f[1]!;
      final at = f[0]!.split('=').first.lastIndexOf(RegExp('\\b$name\\b'));
      fields.add(StyleField(c[1]!, name, lineOf(code, c.end + f.start + at)));
    }
  }
  return fields;
}

// `final Type name;` at the top level of a class body; static fields and
// fields without `final` are not style fields.
final _field = RegExp(
  r'(?:^|;)\s*(?:@\w+(?:\([^)]*\))?\s*)*(?:late\s+)?final\s+(?:[^;=]+?\s+)?(\w+)\s*(?:=[^;]*)?(?=;)',
);

/// The class body that starts at [start] with nested blocks replaced by
/// spaces and each block edge by `;`, so offsets match [code].
String _classTopLevel(String code, int start) {
  final out = StringBuffer();
  var depth = 0;
  for (var i = start; i < code.length; i++) {
    final ch = code[i];
    if (ch == '{') {
      out.write(depth++ == 0 ? ';' : ' ');
    } else if (ch == '}') {
      if (depth == 0) break;
      out.write(--depth == 0 ? ';' : ' ');
    } else {
      out.write(depth == 0 || ch == '\n' ? ch : ' ');
    }
  }
  return out.toString();
}

/// Fields of [className] that [sources] read as `<style>.field`.
///
/// A receiver counts as a [className] value when it is declared with that type,
/// fetched with `get<className>()`, built with `className(...)`, or assigned
/// from one of those (`themeStyle?.merge(widget.style) ?? widget.style`).
/// Fields declared with the type in any of [sources] also count when read
/// through `widget.`, so a `State` in another file is covered.
Set<String> styleFieldReads(String className, Iterable<String> sources) {
  final codes = [for (final s in sources) blankCommentsAndStrings(s)];
  final typed = RegExp('\\b$className\\s*\\??\\s+(?:get\\s+)?(\\w+)\\b');
  final widgetFields = {
    for (final c in codes)
      for (final m in typed.allMatches(c)) m[1]!,
  };
  final reads = <String>{};
  for (final code in codes) {
    final names = {for (final m in typed.allMatches(code)) m[1]!};
    _addAssigned(code, className, names, widgetFields);
    final receivers = [
      'get<$className>\\(\\)',
      '\\b$className\\([^()]*\\)',
      if (names.isNotEmpty)
        '(?:\\bthis\\s*\\.\\s*|(?<!\\.\\s*))\\b(?:${_alt(names)})(?:\\([^()]*\\))?',
      if (widgetFields.isNotEmpty)
        '\\bwidget\\s*\\.\\s*(?:${_alt(widgetFields)})\\b',
    ];
    final read = RegExp(
      '(?:${receivers.join('|')})\\s*!?\\s*\\??\\s*\\.\\s*([a-zA-Z_]\\w*)',
    );
    for (final m in read.allMatches(code)) {
      reads.add(m[1]!);
    }
  }
  return reads;
}

String _alt(Iterable<String> names) => names.map(RegExp.escape).join('|');

/// Adds to [names] the variables in [code] assigned a [className] value,
/// until no new one appears.
void _addAssigned(
  String code,
  String className,
  Set<String> names,
  Set<String> widgetFields,
) {
  final assign = RegExp(
    r'(?:\b(?:final|var|late)\s+)?\b(\w+)\s*(?<![=!<>])=(?![=>])\s*([^;]+);',
  );
  for (;;) {
    final sources = [
      'get<$className>\\(\\)',
      '\\b$className\\(',
      if (names.isNotEmpty)
        '(?:\\bthis\\s*\\.\\s*|(?<!\\.\\s*))\\b(?:${_alt(names)})\\b',
      if (widgetFields.isNotEmpty)
        '\\bwidget\\s*\\.\\s*(?:${_alt(widgetFields)})\\b',
    ];
    final source = RegExp(sources.join('|'));
    var added = false;
    for (final m in assign.allMatches(code)) {
      final name = m[1]!;
      if (names.contains(name)) continue;
      final rhs = m[2]!;
      final hits = source.allMatches(rhs).toList();
      if (hits.isEmpty) continue;
      // `x = style?.padding` reads a field; only merges keep the style.
      final readsMember = hits.any(
        (h) => RegExp(
          r'^(?:\([^()]*\))?\s*!?\s*\??\s*\.\s*(?!merge\b|copyWith\b|lerp\b)\w',
        ).hasMatch(rhs.substring(h.end)),
      );
      if (readsMember) continue;
      names.add(name);
      added = true;
    }
    if (!added) return;
  }
}

/// `path:line Class.field` for every field in [styleSource] that no file in
/// [siblingSources] reads, except those in [readElsewhere].
///
/// An entry of [readElsewhere] that the folder does read, or that no style
/// declares, is reported too, so the list cannot go stale.
List<String> unreadStyleFields(
  String stylePath,
  String styleSource,
  Iterable<String> siblingSources, {
  Map<String, String> readElsewhere = styleFieldsReadElsewhere,
}) {
  final found = <String>[];
  final fields = styleFieldsOf(styleSource);
  final byClass = <String, Set<String>>{};
  for (final f in fields) {
    final reads = byClass.putIfAbsent(
      f.className,
      () => styleFieldReads(f.className, siblingSources),
    );
    final read = reads.contains(f.name);
    final allowed = readElsewhere.containsKey(f.id);
    if (!read && !allowed) {
      found.add('$stylePath:${f.line} ${f.id}');
    } else if (read && allowed) {
      found.add(
        '$stylePath:${f.line} ${f.id} is read in its own folder: '
        'remove it from styleFieldsReadElsewhere',
      );
    }
  }
  return found;
}

/// [unreadStyleFields] for every `v_x/v_x_style.dart` under [componentsDir].
///
/// Paths are printed relative to [root]; entries of [readElsewhere] that no
/// style declares are reported at the end.
List<String> scanStyleFields(
  String componentsDir, {
  String root = '.',
  Map<String, String> readElsewhere = styleFieldsReadElsewhere,
}) {
  final found = <String>[];
  final declared = <String>{};
  final styles =
      Directory(componentsDir)
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('_style.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  final prefix = root.endsWith('/') ? root : '$root/';
  for (final style in styles) {
    final source = style.readAsStringSync();
    declared.addAll(styleFieldsOf(source).map((f) => f.id));
    final siblings = style.parent
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart') && f.path != style.path)
        .map((f) => f.readAsStringSync());
    final path = style.path.startsWith(prefix)
        ? style.path.substring(prefix.length)
        : style.path;
    found.addAll(
      unreadStyleFields(path, source, siblings, readElsewhere: readElsewhere),
    );
  }
  for (final id in readElsewhere.keys) {
    if (!declared.contains(id)) {
      found.add('styleFieldsReadElsewhere names $id, which no style declares');
    }
  }
  return found;
}
