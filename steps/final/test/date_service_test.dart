import 'package:flutter_test/flutter_test.dart';
import 'package:demo/date_service.dart';

void main() {
  group(DateService, () {
    late DateService dateService;

    setUp(() {
      dateService = DateService();
    });

    test('should initialize with the current date', () {
      final now = DateTime.now();
      final date = dateService.dateNotifier.value;

      // Compare up to seconds precision
      expect(
        date.difference(now).inSeconds.abs() <= 1,
        isTrue,
      );
    });

    test('should be able to reset the date', () {
      final oldDate = dateService.dateNotifier.value;

      dateService.resetDate();
      final newDate = dateService.dateNotifier.value;

      expect(newDate.isAfter(oldDate), isTrue);
    });
  });
}
