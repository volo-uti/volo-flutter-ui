// Pure Dart (no Flutter): shared by the source checks in this folder.

/// [source] with comments, and the text of string literals, turned into spaces.
///
/// Line breaks stay and `${...}` interpolations are kept as code, so offsets and
/// line numbers match [source] and a regular expression only sees code.
String blankCommentsAndStrings(String source) => _Blanker(source).run();

/// Line number (1-based) of [offset] in [text].
int lineOf(String text, int offset) {
  var line = 1;
  for (var i = 0; i < offset && i < text.length; i++) {
    if (text.codeUnitAt(i) == 0x0A) line++;
  }
  return line;
}

class _Blanker {
  _Blanker(this.s) : out = s.codeUnits.toList();

  final String s;
  final List<int> out;

  String run() {
    _code(0, untilBrace: false);
    return String.fromCharCodes(out);
  }

  void _blank(int from, int to) {
    for (var k = from; k < to && k < out.length; k++) {
      if (out[k] != 0x0A) out[k] = 0x20;
    }
  }

  static bool _isIdent(int c) =>
      (c >= 0x30 && c <= 0x39) ||
      (c >= 0x41 && c <= 0x5A) ||
      (c >= 0x61 && c <= 0x7A) ||
      c == 0x5F ||
      c == 0x24;

  /// Walks code from [from]; with [untilBrace], stops at the `}` that closes
  /// an interpolation and returns its index.
  int _code(int from, {required bool untilBrace}) {
    var i = from;
    var depth = 0;
    while (i < s.length) {
      if (s.startsWith('//', i)) {
        final end = s.indexOf('\n', i);
        final stop = end < 0 ? s.length : end;
        _blank(i, stop);
        i = stop;
        continue;
      }
      if (s.startsWith('/*', i)) {
        final stop = _blockCommentEnd(i);
        _blank(i, stop);
        i = stop;
        continue;
      }
      final c = s.codeUnitAt(i);
      if (c == 0x27 || c == 0x22) {
        final raw =
            i > 0 &&
            s.codeUnitAt(i - 1) == 0x72 &&
            (i < 2 || !_isIdent(s.codeUnitAt(i - 2)));
        i = _string(i, raw: raw);
        continue;
      }
      if (untilBrace) {
        if (c == 0x7B) depth++;
        if (c == 0x7D) {
          if (depth == 0) return i;
          depth--;
        }
      }
      i++;
    }
    return s.length;
  }

  /// End of the (nestable) block comment that starts at [i].
  int _blockCommentEnd(int i) {
    var depth = 0;
    var j = i;
    while (j < s.length) {
      if (s.startsWith('/*', j)) {
        depth++;
        j += 2;
      } else if (s.startsWith('*/', j)) {
        depth--;
        j += 2;
        if (depth == 0) return j;
      } else {
        j++;
      }
    }
    return s.length;
  }

  /// Blanks the literal text of the string whose quote is at [i] and returns
  /// the index after its closing quote.
  int _string(int i, {required bool raw}) {
    final quote = s[i];
    final triple = s.startsWith(quote * 3, i);
    final close = triple ? quote * 3 : quote;
    var j = i + close.length;
    var from = j;
    while (j < s.length) {
      if (!raw && s.codeUnitAt(j) == 0x5C) {
        j += 2;
        continue;
      }
      if (!raw && s.startsWith(r'${', j)) {
        _blank(from, j);
        j = _code(j + 2, untilBrace: true) + 1;
        from = j;
        continue;
      }
      if (s.startsWith(close, j)) {
        _blank(from, j);
        return j + close.length;
      }
      if (!triple && s.codeUnitAt(j) == 0x0A) break;
      j++;
    }
    _blank(from, j);
    return j;
  }
}
