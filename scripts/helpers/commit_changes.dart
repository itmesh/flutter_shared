import 'dart:io';

import 'print_step_header.dart';

Future<void> commitChanges({
  String commitMsg = 'Pre-release updates',
}) async {
  printStepHeader('Committing App Changes');

  final ProcessResult result = await Process.run(
    'git',
    <String>[
      'commit',
      '-a',
      '-m',
      commitMsg,
    ],
  );

  if (result.exitCode != 0) {
    stdout.writeln(result.stderr);
    exit(1);
  }
}
