import 'dart:math';

import 'package:flutter/material.dart';

extension StringExtensions<T extends String> on T {
  static final List<String> polishLetters = <String>[
    'a',
    'ą',
    'b',
    'c',
    'ć',
    'd',
    'e',
    'ę',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'ł',
    'm',
    'n',
    'ń',
    'o',
    'ó',
    'p',
    'q',
    'r',
    's',
    'ś',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
    'ż',
    'ź',
  ];

  int compareToPolishString(String secondString) {
    final String a = toLowerCase();
    final String b = secondString.toLowerCase();

    for (int i = 0; i < min(a.length, b.length); i++) {
      final int aValue = polishLetters.indexOf(a[i]);
      final int bValue = polishLetters.indexOf(b[i]);

      final int result = (aValue - bValue).sign;
      if (result != 0) {
        return result;
      }
    }

    return (a.length - b.length).sign;
  }

  Size textSize(TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: this, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  String toCamelCase() {
    final List<String> words = trim().split(RegExp(r'\s+'));
    return words.first.toLowerCase() +
        words.skip(1).map(
          (String singleWord) {
            final String firstLetter = singleWord[0];
            final String restOfWord = singleWord.substring(1);
            return firstLetter.toUpperCase() + restOfWord.toLowerCase();
          },
        ).join('');
  }
}
