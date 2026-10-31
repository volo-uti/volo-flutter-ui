// Fails when Dart code under the given folders builds a raw Material widget
// that volo_flutter_ui replaces. Run it in the product's check:
//
//   dart run volo_flutter_ui:raw_widgets lib
import 'dart:io';

import 'package:volo_flutter_ui/src/tooling/raw_widgets.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart run volo_flutter_ui:raw_widgets <dir>...');
    exit(64);
  }
  final found = scanRawWidgetDirs(args);
  if (found.isEmpty) return;
  found.forEach(stdout.writeln);
  exit(1);
}
