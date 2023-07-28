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

  final String ciRemote = result.stdout.toString();

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

    if (addRemoteResult.exitCode != 0) {
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

    if (pushResult.exitCode != 0) {
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

    if (pushTagResult.exitCode != 0) {
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

  if (pushResult.exitCode != 0) {
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

  if (pushTagResult.exitCode != 0) {
    stderr.write(pushTagResult.stderr);
    exit(1);
  }
}
