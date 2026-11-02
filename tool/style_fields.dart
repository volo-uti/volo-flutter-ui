// Lists the style fields that no widget reads: a field declared in
// lib/src/components/<category>/v_x/v_x_style.dart that no other file of the
// v_x folder reads from a style value. An app that sets such a field sees
// nothing change.
//
// `dart run tool/style_fields.dart` prints them as `file:line Class.field`;
// `--check` also exits 1 when there are any. A field read only by a widget in
// another folder goes in `styleFieldsReadElsewhere`
// (lib/src/tooling/style_fields.dart) with the reason.
import 'dart:io';

import 'package:volo_flutter_ui/src/tooling/style_fields.dart';

void main(List<String> args) {
  final check = args.contains('--check');
  final root = File.fromUri(Platform.script).parent.parent.path;
  final found = scanStyleFields('$root/lib/src/components', root: root);
  if (found.isEmpty) return;
  found.forEach(stdout.writeln);
  stderr.writeln(
    '${found.length} style field problem(s): read each field where the widget '
    'resolves its look (instance argument, then style, then theme override, '
    'then token), or remove it.',
  );
  if (check) exit(1);
}
