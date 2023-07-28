import 'dart:io';

void printStepHeader(String header) {
  const int spaceLength = 8;
  final int textLength = header.length;
  final int lineLength = textLength + 2 * spaceLength;

  stdout.writeln('''
# ${'=' * lineLength} #
# ${' ' * spaceLength}$header${' ' * spaceLength} #
# ${'=' * lineLength} #
  ''');
}
