import 'dart:io';

import 'print_step_header.dart';

Future<void> createTag({
  required String tag,
}) async {
  printStepHeader('Creating tag');

  final ProcessResult lastTagResult = Process.runSync(
    'git',
    <String>[
      'tag',
      tag,
    ],
  );

  if (lastTagResult.exitCode != 0) {
    stderr.writeln(lastTagResult.stderr);
    exit(1);
  }
}
