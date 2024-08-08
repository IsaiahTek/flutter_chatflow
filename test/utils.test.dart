import 'dart:ui';
import 'package:flutter_chatflow/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Utils Functions Test', () {
    test('return the hashcodes color equivalence', () {
      expect(createColorFromHashCode(25544).main,
          const Color.fromARGB(255, 255, 44, 0));
    });
    test('return Time Partition', () {
      expect(computeTimePartitionText(DateTime.now().millisecondsSinceEpoch),
          'TODAY');
    });
    test('return Sameness of day', () {
      expect(
          isSameDay(DateTime.now().millisecondsSinceEpoch,
              DateTime.now().millisecondsSinceEpoch),
          true);
    });
    // DateTime twoWeeksAgo = DateTime(2024, 6, 22);
    // test('return Time Partition For more than 6 days ago', () {
    //   expect(computeTimePartitionText(twoWeeksAgo.millisecondsSinceEpoch),
    //       '22/6/2024');
    // });
    // DateTime fiveWeeksAgo = DateTime(2024, 7, 1);
    // test('return Time Partition For more than 6 days ago', () {
    //   expect(computeTimePartitionText(fiveWeeksAgo.millisecondsSinceEpoch),
    //       'Monday');
    // });

    List<TestMessage> numbers = [
      TestImageMessage(),
      TestTextMessage(),
      TestTextMessage(),
      TestTextMessage(),
      TestTextMessage(),
      TestTextMessage(),
      TestVideoMessage(),
      TestTextMessage(),
      TestTextMessage(),
      TestTextMessage(),
      TestTextMessage(),
      TestDocMessage()
    ];
    test('Consecutive value in list', () {
      expect(
          getConsecutives(items: numbers, check: TestTextMessage()).toString(),
          [
            ConsecutiveOccurrence(startIndex: 1, endIndex: 5),
            ConsecutiveOccurrence(startIndex: 7, endIndex: 10)
          ].toString());
    });
    test('Index Is In Consecutives', () {
      expect(
          indexIsInConsecutives(
              getConsecutives(items: numbers, check: TestTextMessage()), 0),
          false);
    });
    test('URL Detector', () {
      expect(
          detectUrls(
              'I know who I am at http:google.com, http://google.com, https://google.com and google.com before telling you I am a link'),
          [
            'google.com',
            'http://google.com',
            'https://google.com',
            'google.com'
          ]);
    });
  });
}
