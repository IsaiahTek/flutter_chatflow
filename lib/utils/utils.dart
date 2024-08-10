import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/utils/types.dart';

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
  final Color main;

  /// pair color
  final Color surface;

  /// Constructor
  ColorPair({required this.main, required this.surface});
}

/// Color equivalence of integer
ColorPair createColorFromHashCode(int hashCode) {
  List<int> hashCodeInts = computeNumbersList(hashCode);
  List<int> computedRGBList = groupNumbersIntoRGB(hashCodeInts);
  int r = computedRGBList[0];
  int g = computedRGBList[1];
  int b = computedRGBList[2];
  return ColorPair(
      main: Color.fromARGB(255, r, g, b),
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

///
List<ConsecutiveOccurrence> getConsecutives(
    {required List<Message> items, required Message check, int? amount}) {
  int found = 0;
  List<ConsecutiveOccurrence> results = [];
  for (var index = 0; index < items.length; index++) {
    if (index > 0) {
      if (items[index].type == check.type &&
          items[index - 1].type == check.type &&
          items[index].author.userID == items[index - 1].author.userID &&
          isSameDay(items[index - 1].createdAt, items[index].createdAt) &&
          results.isNotEmpty) {
        found += 1;
        results[results.length - 1].updateEndIndex(index);
      } else if (found >= 0 && items[index].type == check.type) {
        found = 1;
        results.add(ConsecutiveOccurrence(startIndex: index));
      }
    }
  }
  results = results.where((result) {
    return (result.endIndex ?? -1) - result.startIndex + 1 >= (amount ?? 4);
  }).toList();
  return results;
}

/// For internal use only
bool indexIsInConsecutives(List<ConsecutiveOccurrence> items, int index) {
  return items.any((element) {
    if ((element.endIndex != null && element.endIndex! >= index) &&
        (element.startIndex <= index)) {
      return true;
    } else {
      return false;
    }
  });
}

/// Internal use only
bool indexIsInConsecutivesAndIsFirstTake(
    List<ConsecutiveOccurrence> items, int index) {
  return items.any((element) {
    if ((element.endIndex != null && element.endIndex! >= index) &&
        (element.startIndex == index)) {
      return true;
    } else {
      return false;
    }
  });
}

/// Internal use only
List<ImageMessage> getGroupedImageMessages(List<Message> messages,
    List<ConsecutiveOccurrence> consecutiveOccurrences, int startIndex) {
  ConsecutiveOccurrence occurrence = consecutiveOccurrences
      .firstWhere((element) => element.startIndex == startIndex);

  List<ImageMessage> groupedImageMessages = [];

  for (var i = 0; i <= occurrence.endIndex! - occurrence.startIndex; i++) {
    groupedImageMessages
        .add(messages[i + occurrence.startIndex] as ImageMessage);
  }
  return groupedImageMessages;
}

///
abstract class TestMessage extends Message {
  ///
  TestMessage()
      : super(
            author: const ChatUser(userID: "userID"),
            createdAt: 0,
            type: MessageType.custom);
}

///
class TestImageMessage extends TestMessage {
  ///
  TestImageMessage() {
    super.type = MessageType.image;
  }
}

///
class TestTextMessage extends TestMessage {
  ///
  TestTextMessage() {
    super.type = MessageType.text;
  }
}

///
class TestVideoMessage extends TestMessage {
  ///
  TestVideoMessage() {
    super.type = MessageType.video;
  }
}

///
class TestDocMessage extends TestMessage {
  ///
  TestDocMessage() {
    super.type = MessageType.doc;
  }
}

/// Internal use only
class ConsecutiveOccurrence {
  /// Internal use only
  final int startIndex;

  /// Internal use only
  int? endIndex;

  /// Internal use only
  ///
  updateEndIndex(int newIndex) {
    endIndex = newIndex;
  }

  /// Number of items found
  get total => (endIndex ?? -1) - startIndex + 1;

  @override
  toString() {
    return 'ConsecutiveOccurrence of ($total) items: FROM:$startIndex TO:$endIndex';
  }

  ///
  ConsecutiveOccurrence({required this.startIndex, this.endIndex});
}

// /// Util function to detect urls in a text. Feel free to use if you need it!
// List<String> detectUrls(String text) {
//   String urlPattern =
//       r'(?:(?:https?|ftp):\/\/)?(?:[\w-]+\.)+[a-z]{2,}(?:\/\S*)?';
//   final regex = RegExp(urlPattern, caseSensitive: false);
//   final matches = regex.allMatches(text);

//   return matches.map((match) => match.group(0)!).toList();
// }


/// Use this function if you need to dynamically get the url of file-based message.
String? getFileUrlFromMessage(Message message){
  String? url;
  switch (message.type) {
    case MessageType.image:
      url = (message as ImageMessage).uri;
      break;
    case MessageType.video:
      url = (message as VideoMessage).uri;
      break;
    case MessageType.audio:
      url = (message as AudioMessage).uri;
      break;
    case MessageType.pdf:
      url = (message as PdfMessage).uri;
      break;
    case MessageType.doc:
      url = (message as DocMessage).uri;
      break;
    case MessageType.file:
      url = (message as FileMessage).uri;
      break;
    default:
      break;
  }

  return url;
}


/// Use this util to update the uri of a file based message when needed
Message updateMessageUri(Message message, String uri){
  return _updatedUri(message, uri);
}


Message _updatedUri(Message message, String uri){
  switch (message.type) {
    case MessageType.image:
      (message as ImageMessage).uri = uri;
      break;
    case MessageType.video:
      (message as VideoMessage).uri = uri;
      break;
    case MessageType.audio:
      (message as AudioMessage).uri = uri;
      break;
    case MessageType.pdf:
      (message as PdfMessage).uri = uri;
      break;
    case MessageType.doc:
      (message as DocMessage).uri = uri;
      break;
    case MessageType.file:
      (message as FileMessage).uri = uri;
      break;
    default:
      break;
  }
  return message;
}
