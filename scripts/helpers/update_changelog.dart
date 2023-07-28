import 'dart:convert';
import 'dart:io';

import 'print_step_header.dart';

extension DateTimeExtension on DateTime {
  String toSimpleString() {
    final String year = this.year.toString();
    final String month = this.month.toString().padLeft(2, '0');
    final String day = this.day.toString().padLeft(2, '0');
    final String hour = this.hour.toString().padLeft(2, '0');
    final String minute = this.minute.toString().padLeft(2, '0');

    return '$day.$month.$year $hour:$minute';
  }
}

const List<String> _wantedChangelogTags = <String>[
  '[feature]',
  '[regression]',
  '[fix]',
  '[hotfix]',
  '[improvement]',
  '[dev-feature]',
  '[dev-fix]',
  '[dev-improvement]',
];

Future<void> updateChangelog({
  required String version,
}) async {
  printStepHeader('Updating CHANGELOG');

  final ProcessResult lastChangelogCommitResult = Process.runSync(
    'git',
    <String>[
      'rev-list',
      'HEAD',
      '-1',
      'CHANGELOG.md',
    ],
  );

  if (lastChangelogCommitResult.exitCode != 0) {
    stderr.writeln(lastChangelogCommitResult.stderr);
    exit(1);
  }

  final String lastChangelogCommit = (lastChangelogCommitResult.stdout as String).trim();

  final ProcessResult wantedCommitsResult = Process.runSync(
    'git',
    <String>[
      'rev-list',
      '$lastChangelogCommit...',
    ],
  );

  if (wantedCommitsResult.exitCode != 0) {
    stderr.writeln(wantedCommitsResult.stderr);
    exit(1);
  }

  List<String> wantedCommits = (wantedCommitsResult.stdout as String).split('\n');
  wantedCommits = wantedCommits.where((String text) => text.isNotEmpty).toList();
  wantedCommits = wantedCommits.map((String text) => text.trim()).toList();

  final List<String> changes = <String>[];
  for (String commit in wantedCommits) {
    final ProcessResult commitResult = Process.runSync(
      'git',
      <String>[
        'log',
        '--format=%B',
        '-n',
        '1',
        commit,
      ],
      stdoutEncoding: const Utf8Codec(),
    );

    if (commitResult.exitCode != 0) {
      stderr.writeln(commitResult.stderr);
      exit(1);
    }

    final String formattedCommit = (commitResult.stdout as String).replaceAll('\r\n', '\n');

    List<String> commitLines = formattedCommit.split('\n');
    commitLines = commitLines.map((String text) => text.trim()).toList();

    final List<String> commitChanges = <String>[];
    for (String commitLine in commitLines) {
      for (String wantedTag in _wantedChangelogTags) {
        if (commitLine.contains(wantedTag)) {
          commitChanges.add(commitLine);
          break;
        }
      }
    }

    changes.addAll(commitChanges);
  }

  changes.sort();

  if (changes.isEmpty) {
    changes.add('[dev-improvement] Developer changes.');
  }

  for (int i = 0; i < changes.length; i++) {
    if (!changes[i].startsWith('- ')) {
      changes[i] = '- ${changes[i]}';
    }
  }

  final File changelog = File('CHANGELOG.md');
  final List<String> changelogContent = changelog.readAsLinesSync();

  changelogContent.insert(0, '# $version [${DateTime.now().toSimpleString()}]\n');

  changelogContent.insertAll(1, changes);

  changelog.writeAsStringSync('${changelogContent.join('\n')}\n');
}
