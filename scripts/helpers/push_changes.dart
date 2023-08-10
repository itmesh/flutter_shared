import 'dart:io';

import 'print_step_header.dart';

Future<void> pushChanges({
  required String tag,
  required bool ci,
}) async {
  printStepHeader('Pushing App Changes');

  final ProcessResult result = await Process.run(
    'git',
    <String>[
      'config',
      '--local',
      'remote.origin.url',
    ],
  );

  String ciRemote = result.stdout.toString();
  if (ciRemote.contains('https://github.com/')) {
    ciRemote = ciRemote.replaceAll('https://github.com/', 'git@github.com:');
  }

  printStepHeader('ciRemote: $ciRemote');

  if (ci) {
    final ProcessResult addRemoteResult = Process.runSync(
      'git',
      <String>[
        'remote',
        'add',
        'originSSH',
        ciRemote,
      ],
    );

    printStepHeader('addRemoteResult: ${addRemoteResult.stdout.toString()}');

    if (addRemoteResult.exitCode != 0) {
      printStepHeader('addRemoteResult: error');

      stderr.write(addRemoteResult.stderr);
      exit(1);
    }

    final ProcessResult pushResult = Process.runSync(
      'git',
      <String>[
        'push',
        '--set-upstream',
        'originSSH',
        'HEAD',
      ],
    );

    printStepHeader('pushResult: ${pushResult.stdout.toString()}');

    if (pushResult.exitCode != 0) {
      printStepHeader('pushResult: error');
      stderr.write(pushResult.stderr);
      exit(1);
    }

    final ProcessResult pushTagResult = Process.runSync(
      'git',
      <String>[
        'push',
        '--set-upstream',
        'originSSH',
        tag,
      ],
    );

    printStepHeader('pushTagResult: ${pushTagResult.stdout.toString()}');

    if (pushTagResult.exitCode != 0) {
      printStepHeader('pushTagResult: error');
      stderr.write(pushTagResult.stderr);
      exit(1);
    }

    return;
  }

  final ProcessResult pushResult = Process.runSync(
    'git',
    <String>[
      'push',
      '--set-upstream',
      'origin',
      'HEAD',
    ],
  );

  printStepHeader('pushResult: ${pushResult.stdout.toString()}');

  if (pushResult.exitCode != 0) {
    printStepHeader('pushResult: error');
    stderr.write(pushResult.stderr);
    exit(1);
  }

  final ProcessResult pushTagResult = Process.runSync(
    'git',
    <String>[
      'push',
      '--set-upstream',
      'origin',
      tag,
    ],
  );

  printStepHeader('pushTagResult: ${pushResult.stdout.toString()}');


  if (pushTagResult.exitCode != 0) {
    printStepHeader('pushTagResult: error');
    stderr.write(pushTagResult.stderr);
    exit(1);
  }
}
