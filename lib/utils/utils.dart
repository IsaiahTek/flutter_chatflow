import 'package:flutter/material.dart';

List<int> computeNumbersList(int hashCode){
  return hashCode.toString().split('').map((e) => num.parse(e).toInt()).toList();
}

List<int> groupNumbersIntoRGB(List<int> numbers){
  List<int> rgbList = [];
  for (var i = 0; i < 3; i++) {
    String numberList = '';
    for (var j = 0; j < 3; j++) {
      if(numbers.isNotEmpty){
        numberList += numbers.removeAt(0).toString();
      }else if(numberList.isEmpty){
        numberList += '0';
      }
    }
    rgbList.add(num.parse(numberList).toInt());
  }
  return rgbList;
}

Color createColorFromHashCode(int hashCode){
  List<int> hashCodeInts = computeNumbersList(hashCode);
  List<int> computedRGBList = groupNumbersIntoRGB(hashCodeInts);
  int r = computedRGBList[0];
  int g = computedRGBList[1];
  int b = computedRGBList[2];

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

bool isSameDay(int? previousMessageTime, int currentMessageTime){
  int? previousDay = previousMessageTime != null ? DateTime.fromMillisecondsSinceEpoch(previousMessageTime).day: null;
  int currentDay = DateTime.fromMillisecondsSinceEpoch(currentMessageTime).day;
  int deltaDay = previousDay != null? currentDay - previousDay : 1;

  return deltaDay == 0;
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
  debugPrint('\x1B[31mERROR: $message\x1B[0m');
}