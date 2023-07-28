Future<ReleaseOptions> parseReleaseArguments(List<String> arguments) async {
  bool ci = false;
  final List<String> prefixes = arguments.toList();

  if (arguments.contains('--ci')) {
    ci = true;
    prefixes.remove('--ci');
  }

  String prefix = '';
  if (prefixes.isNotEmpty) {
    prefix = '${prefixes.first}_';
  }

  return ReleaseOptions(
    prefix: prefix,
    ci: ci,
  );
}

class ReleaseOptions {
  const ReleaseOptions({
    required this.ci,
    required this.prefix,
  });

  final String prefix;
  final bool ci;
}
