// Fails when Dart code under the given folders defines a widget named for a
// volo_flutter_ui role (`AppChip`, `SettingsRow` ...) in a file that never uses
// the library widget for that role. Run it in the product's check:
//
//   dart run volo_flutter_ui:look_alikes lib
//
// A widget the library cannot replace passes with a reason in a
// `// look-alike: <why>` line right above its class; every run lists those
// under "Accepted look-alikes" so they stay in sight.
import 'dart:io';

import 'package:volo_flutter_ui/src/tooling/look_alikes.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart run volo_flutter_ui:look_alikes <dir>...');
    exit(64);
  }
  final report = scanLookAlikeDirs(args);
  if (report.accepted.isNotEmpty) {
    stdout.writeln('Accepted look-alikes (${report.accepted.length}):');
    for (final a in report.accepted) {
      stdout.writeln('  $a');
    }
  }
  if (report.failures.isEmpty) return;
  report.failures.forEach(stdout.writeln);
  exit(1);
}
