import 'dart:io';

import 'helpers/commit_changes.dart';
import 'helpers/create_tag.dart';
import 'helpers/parse_release_arguments.dart';
import 'helpers/push_changes.dart';
import 'helpers/update_build_number.dart';
import 'helpers/update_changelog.dart';

Future<void> main(List<String> arguments) async {
  final ReleaseOptions releaseOptions = await parseReleaseArguments(arguments);

  final String version = await updateBuildNumber();
  await updateChangelog(version: version);
  await commitChanges();

  final String tag = '${releaseOptions.prefix}$version';

  await createTag(
    tag: tag,
  );

  await pushChanges(
    tag: tag,
    ci: releaseOptions.ci,
  );

  exit(0);
}
