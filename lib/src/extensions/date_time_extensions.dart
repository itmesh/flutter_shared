import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DateTimeType {
  day,
  week,
  month,
  year,
}

extension DateTimeExtensions<T extends DateTime> on T {
  DateTime withTimeOfDay(TimeOfDay timeOfDay) {
    return DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute, 0, 0);
  }

  static const List<String> weekdayNames = <String>[
    'Poniedziałek',
    'Wtorek',
    'Środa',
    'Czwartek',
    'Piątek',
    'Sobota',
    'Niedziela',
  ];

  static const List<String> shortWeekdayNames = <String>[
    'Pn',
    'Wt',
    'Śr',
    'Czw',
    'Pt',
    'Sb',
    'Nd',
  ];

  static const Map<int, String> monthNames = <int, String>{
    1: 'sty',
    2: 'lut',
    3: 'mar',
    4: 'kwi',
    5: 'maj',
    6: 'cze',
    7: 'lip',
    8: 'sie',
    9: 'wrz',
    10: 'paź',
    11: 'lis',
    12: 'gru',
  };

  static const Map<int, String> longMonthNames = <int, String>{
    1: 'styczeń',
    2: 'luty',
    3: 'marzec',
    4: 'kwiecień',
    5: 'maj',
    6: 'czerwiec',
    7: 'lipiec',
    8: 'sierpień',
    9: 'wrzesień',
    10: 'październik',
    11: 'listopad',
    12: 'grudzień',
  };

  static const Map<int, String> longMonthNamesInEnglish = <int, String>{
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };
  static const Map<int, String> shortMonthNamesInEnglish = <int, String>{
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sept',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };

  bool get isLeap {
    if (year % 400 == 0) {
      return true;
    }

    if (year % 100 == 0) {
      return false;
    }

    if (year % 4 == 0) {
      return true;
    }

    return false;
  }

  String get monthShortName {
    return monthNames[month]!;
  }

  String get formattedShort {
    return '$day $monthShortName $year';
  }

  /// January - 1, December - 12.
  int getMonthDays(int month) {
    switch (month) {
      case 1:
        return 31;

      case 2:
        return isLeap ? 29 : 28;

      case 3:
        return 31;

      case 4:
        return 30;

      case 5:
        return 31;

      case 6:
        return 30;

      case 7:
        return 31;

      case 8:
        return 31;

      case 9:
        return 30;

      case 10:
        return 31;

      case 11:
        return 30;

      case 12:
        return 31;

      default:
        // Just to be safe.
        return 31;
    }
  }

  int get monthDays {
    return getMonthDays(month);
  }

  String get readable {
    final String day = this.day.toString().padLeft(2, '0');
    final String month = this.month.toString().padLeft(2, '0');
    final String year = this.year.toString();

    return '$day.$month.$year';
  }

  String get shortReadable {
    final String day = this.day.toString().padLeft(2, '0');
    final String month = this.month.toString().padLeft(2, '0');

    return '$day.$month';
  }

  DateTime get onlyDate => DateTime(year, month, day);

  String get readableTime {
    final String hour = this.hour.toString().padLeft(2, '0');
    final String minute = this.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String toDateString(String locale) {
    return DateFormat.yMMMd(locale).format(this);
  }

  String toDateTimeString() {
    return DateFormat().add_Hm().format(this);
  }

  String get weekdayName {
    return weekdayNames[weekday - 1];
  }

  DateTime updateWithTime(TimeOfDay timeOfDay) {
    return DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute);
  }

  DateTime startOf(DateTimeType type) {
    switch (type) {
      case DateTimeType.day:
        return DateTime(year, month, day, 0, 0, 0, 0);

      case DateTimeType.week:
        return DateTime(year, month, day - weekday + 1, 0, 0, 0, 0);

      case DateTimeType.month:
        return DateTime(year, month, 1, 0, 0, 0, 0);

      case DateTimeType.year:
        return DateTime(year, 1, 1, 0, 0, 0, 0);
    }
  }

  DateTime endOf(DateTimeType type) {
    switch (type) {
      case DateTimeType.day:
        return DateTime(year, month, day, 23, 59, 59, 999);

      case DateTimeType.week:
        return DateTime(year, month, day - weekday + 8, 23, 59, 59, 999);

      case DateTimeType.month:
        return DateTime(year, month, monthDays, 23, 59, 59, 999);

      case DateTimeType.year:
        return DateTime(year, 12, getMonthDays(12), 23, 59, 59, 999);
    }
  }

  bool compareOnlyDate(DateTime dateTime) {
    if (year == dateTime.year && month == dateTime.month && day == dateTime.day) {
      return true;
    }

    return false;
  }
}
