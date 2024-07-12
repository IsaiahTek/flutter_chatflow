import 'package:flutter/material.dart';

/// convert a number digits to list of individual digits
List<int> computeNumbersList(int hashCode) {
  return hashCode
      .toString()
      .split('')
      .map((e) => num.parse(e).toInt())
      .toList();
}

/// Convert a list of numbers to RGB group of 3 set of numbers in a list
List<int> groupNumbersIntoRGB(List<int> numbers) {
  List<int> rgbList = [];
  for (var i = 0; i < 3; i++) {
    String numberList = '';
    for (var j = 0; j < 3; j++) {
      if (numbers.isNotEmpty) {
        numberList += numbers.removeAt(0).toString();
      } else if (numberList.isEmpty) {
        numberList += '0';
      }
    }
    rgbList.add(num.parse(numberList).toInt());
  }
  return rgbList;
}

/// Used internally.
class ColorPair {
  /// main color
  final Color background;

  /// pair color
  final Color surface;

  /// Constructor
  ColorPair({required this.background, required this.surface});
}

/// Color equivalence of integer
ColorPair createColorFromHashCode(int hashCode) {
  List<int> hashCodeInts = computeNumbersList(hashCode);
  List<int> computedRGBList = groupNumbersIntoRGB(hashCodeInts);
  int r = computedRGBList[0];
  int g = computedRGBList[1];
  int b = computedRGBList[2];
  return ColorPair(
      background: Color.fromARGB(255, r, g, b),
      surface: Color.fromARGB(255, r, g, b).computeLuminance() > 0.4
          ? Colors.black
          : Colors.white);
}

/// Weekdays
List<String> weekDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

/// Months
List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

/// Get day by int
getWeekDayName(int weekday) {
  return weekDays[weekday - 1];
}

/// Get month by int
getMonthName(int month) {
  return months[month - 1];
}

/// Duration uptil now time format
Duration getDurationTillNow(DateTime pastTime) {
  return DateTime.now().difference(pastTime);
}

/// Last seen at time format
String getSentAt(int millisecondsSinceEpoch) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  String sentAt = '${date.hour}:${date.minute}';
  return sentAt;
}

/// Check if it's same day
bool isSameDay(int? previousMessageTime, int currentMessageTime) {
  int? previousDay = previousMessageTime != null
      ? DateTime.fromMillisecondsSinceEpoch(previousMessageTime).day
      : null;
  int currentDay = DateTime.fromMillisecondsSinceEpoch(currentMessageTime).day;
  int deltaDay = previousDay != null ? currentDay - previousDay : 1;

  return deltaDay == 0;
}

/// Compute Time partition of messages based on created at time stamp
String computeTimePartitionText(int millisecondsSinceEpoch) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  DateTime now = DateTime.now();
  int longAgo = now.difference(date).inDays;
  String result;
  switch (longAgo) {
    case 0:
      result = "TODAY";
      break;
    case 1:
      result = "YESTERDAY";
      break;
    default:
      if (longAgo <= 6) {
        result = getWeekDayName(date.weekday);
      } else {
        result = '${date.day}/${date.month}/${date.year}';
      }
  }
  return result;
}

/// Error message printer
void logError(String message) {
  debugPrint('\x1B[31mERROR: $message\x1B[0m');
}
