import 'dart:io';

Future<void> main(List<String> arguments) async {
  final String currentVersion = arguments.first;
  final File changelog = File('CHANGELOG.md');
  final List<String> changelogContent = changelog.readAsLinesSync();

  if (changelogContent.first.contains(currentVersion)) {
    stderr.writeln('There are no changes for version $currentVersion');
    exit(1);
  }

  final List<String> changesRelatedToVersion = <String>[];

  for (String line in changelogContent.skip(1)) {
    if (line.contains('# $currentVersion [')) {
      break;
    }

    if (line.contains(RegExp(r'\#.*\['))) {
      continue;
    }

    if (line.contains(RegExp(r'^- \[dev-'))) {
      continue;
    }

    changesRelatedToVersion.add(line);
  }

  changesRelatedToVersion.removeWhere((String element) => element.isEmpty);
  final List<String> finalChangelog = <String>[];

  for (String line in changesRelatedToVersion) {
    line = line.replaceAll(RegExp(r'\[[a-z]+\]'), '');
    line = line.replaceAll(RegExp(r'\[[0-9]+\]'), '');
    finalChangelog.add(line);
  }

  stdout.writeln('${finalChangelog.join('\n')}\n');

  exit(0);
}
