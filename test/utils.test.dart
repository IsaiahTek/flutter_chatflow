import 'dart:ui';

import 'package:flutter_chatflow/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Utils Functions Test', () {
    test('return the hashcodes color equivalence', () {
      expect(createColorFromHashCode(25544).background,
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
    DateTime twoWeeksAgo = DateTime(2024, 6, 22);
    test('return Time Partition For more than 6 days ago', () {
      expect(computeTimePartitionText(twoWeeksAgo.millisecondsSinceEpoch),
          '22/6/2024');
    });
    DateTime fiveWeeksAgo = DateTime(2024, 7, 1);
    test('return Time Partition For more than 6 days ago', () {
      expect(computeTimePartitionText(fiveWeeksAgo.millisecondsSinceEpoch),
          'Monday');
    });
  });
}
