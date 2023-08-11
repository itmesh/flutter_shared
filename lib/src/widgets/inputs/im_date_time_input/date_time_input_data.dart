import 'package:flutter/material.dart';

class DateTimeInputData {
  const DateTimeInputData({
    this.date,
    this.time,
  });

  factory DateTimeInputData.fromDate(DateTime? dateTime) {
    if (dateTime == null) {
      return const DateTimeInputData();
    }

    return DateTimeInputData(
      date: DateTime(dateTime.year, dateTime.month, dateTime.day),
      time: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
    );
  }

  final DateTime? date;
  final TimeOfDay? time;

  DateTimeInputData copyWithDate(DateTime newDate) {
    return DateTimeInputData(date: newDate, time: time);
  }

  DateTimeInputData copyWithTime(TimeOfDay newTime) {
    return DateTimeInputData(date: date, time: newTime);
  }

  DateTime? toDateTime() {
    if (date == null) {
      return null;
    }

    if (time == null) {
      return date;
    }

    return DateTime(date!.year, date!.month, date!.day, time!.hour, time!.minute);
  }
}
