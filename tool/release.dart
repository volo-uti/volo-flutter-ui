// Release rules and notes.
//
// `dart tool/release.dart check [--commit REV]` fails (exit 1, one reason line)
// when the commit REV (default HEAD) is not a valid release: its title must be
// `chore(release): <version>` for the version in pubspec.yaml, the version must
// be greater than the previous `v*` tag, and a breaking change since that tag
// must raise the minor version while the major version is 0.
// `dart tool/release.dart notes [--commit REV]` prints the release notes built
// from the commit titles since the previous tag.
//
// Run it from inside the git repository; `make release-check` and
// `make release-notes` do that.
import 'dart:io';

import 'src/release.dart';

void main(List<String> args) {
  exitCode = runRelease(args, out: stdout, err: stderr);
}
