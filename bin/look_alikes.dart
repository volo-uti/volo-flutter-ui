// Fails when Dart code under the given folders defines a widget named for a
// volo_flutter_ui role (`AppChip`, `SettingsRow` ...) in a file that never uses
// the library widget for that role. Run it in the product's check:
//
//   dart run volo_flutter_ui:look_alikes lib
import 'dart:io';

import 'package:volo_flutter_ui/src/tooling/look_alikes.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart run volo_flutter_ui:look_alikes <dir>...');
    exit(64);
  }
  final found = scanLookAlikeDirs(args);
  if (found.isEmpty) return;
  found.forEach(stdout.writeln);
  exit(1);
}
