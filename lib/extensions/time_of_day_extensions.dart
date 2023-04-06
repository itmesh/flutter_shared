import 'package:flutter/material.dart';

extension TimeOfDayExtensions on TimeOfDay {
  String get readable {
    final String hour = this.hour.toString().padLeft(2, '0');
    final String minute = this.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  TimeOfDay add(Duration duration) {
    final DateTime dateTime = DateTime(2000, 12, 1, hour, minute);

    final DateTime diff = dateTime.add(duration);

    return TimeOfDay(
      hour: diff.hour,
      minute: diff.minute,
    );

    // final int startMinuteOfDay = (hour * 60) + minute;
    // final int endMinuteOfDay = startMinuteOfDay + duration.inMinutes;

    // return TimeOfDay(
    //   hour: endMinuteOfDay ~/ 60,
    //   minute: endMinuteOfDay % 60,
    // );
  }

  TimeOfDay subtract(Duration duration) {
    final DateTime dateTime = DateTime(2000, 12, 1, hour, minute);

    final DateTime diff = dateTime.subtract(duration);

    return TimeOfDay(
      hour: diff.hour,
      minute: diff.minute,
    );
  }

  bool isBefore(TimeOfDay time) {
    if (hour < time.hour) {
      return true;
    }

    if (hour == time.hour && minute < time.minute) {
      return true;
    }

    return false;
  }

  bool isAfter(TimeOfDay time) {
    if (hour > time.hour) {
      return true;
    }

    if (hour == time.hour && minute > time.minute) {
      return true;
    }

    return false;
  }
}
