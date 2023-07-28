import 'dart:io';

import 'print_step_header.dart';

Future<String> updateBuildNumber() async {
  printStepHeader('Updating Build Number');

  final File pubspecFile = File('pubspec.yaml');
  final List<String> pubspecContent = await pubspecFile.readAsLines();
  final String wantedLine = pubspecContent.firstWhere((String line) => line.startsWith('version'));
  final int wantedLineI = pubspecContent.indexOf(wantedLine);

  final String currentVersion = wantedLine.replaceAll('version:', '').trim();
  final String versionPart = currentVersion.split('+').first;

  final int buildNumber = int.parse(currentVersion.split('+').last);

  final String newVersion = '$versionPart+${buildNumber + 1}';

  pubspecContent.removeAt(wantedLineI);
  pubspecContent.insert(wantedLineI, 'version: $newVersion');
  pubspecFile.writeAsStringSync('${pubspecContent.join('\n')}\n');

  return newVersion;
}
