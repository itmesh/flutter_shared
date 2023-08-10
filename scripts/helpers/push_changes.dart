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
  print('ciRemote: $ciRemote');
  if (ciRemote.contains('https://github.com/')) {
    ciRemote = ciRemote.replaceFirst('https://github.com/', 'git@github.com:').trim();
  } else if (ciRemote.contains('https://itmesh@github.com/')) {
    ciRemote = ciRemote.replaceFirst('https://itmesh@github.com/', 'git@github.com:').trim();
  }

  print('ciRemote: $ciRemote');

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

    print('addRemoteResult: ${addRemoteResult.stdout.toString()}');

    if (addRemoteResult.exitCode != 0) {
      print('addRemoteResult: error');

      stderr.write(addRemoteResult.stderr);
      exit(1);
    }

    final ProcessResult pushResult = Process.runSync(
      'git',
      <String>[
        'push',
        '--set-upstream',
        'originSSH',
      ],
    );

    print('pushResult: ${pushResult.stdout.toString()}');

    if (pushResult.exitCode != 0) {
      print('pushResult: error');
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

    print('pushTagResult: ${pushTagResult.stdout.toString()}');

    if (pushTagResult.exitCode != 0) {
      print('pushTagResult: error');
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
