import 'package:flutter/material.dart';

Color createColorFromHashCode(int hashCode){
  List<int> hashCodeInts = hashCode.toString().split('').map((e) => num.parse(e).toInt()).toList();
  int takeSize = (hashCodeInts.length~/3);
  int r = num.parse(hashCodeInts.join('').substring(0, takeSize)).toInt();
  int g = num.parse(hashCodeInts.join('').substring(takeSize+1, takeSize+takeSize+1)).toInt();
  int b = num.parse(hashCodeInts.join('').substring(takeSize+takeSize+1)).toInt();
  return Color.fromARGB(255, r, g, b);
}

List<String> weekDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

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

getWeekDayName(int weekday){
  return weekDays[weekday-1];
}

getMonthName(int month){
  return months[month-1];
}

Duration getDurationTillNow(DateTime pastTime){
  return DateTime.now().difference(pastTime);
}

String getSentAt(int millisecondsSinceEpoch){
  DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  String sentAt = '${date.hour}:${date.minute}';
  return sentAt;
}

String computeTimePartitionText(int millisecondsSinceEpoch){
  DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  DateTime now = DateTime.now();
  int longAgo = now.day - date.day;
  String result;
  switch (longAgo) {
    case 0:
      result = "TODAY";
      break;
    case 1:
      result = "YESTERDAY";
      break;
    default:
      if(longAgo <= 6){
        result = getWeekDayName(date.weekday);
      }else{
        result = '${date.day}/${date.month}/${date.year}';
      }

  }
  return result;
}

  
void logError(String message) {
  debugPrint('\x1B[31mERROR: $message\x1B[0m'); // This uses ANSI escape codes to color the text red
}