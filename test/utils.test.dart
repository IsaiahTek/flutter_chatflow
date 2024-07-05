import 'dart:ui';

import 'package:flutter_chatflow/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Utils Functions Test', () {
    test('return the hashcodes color equivalence', () {
      expect(createColorFromHashCode(25544),
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
  });
}
