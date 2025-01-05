import 'package:flutter_test/flutter_test.dart';
import 'package:demo/utils/locator.dart';
import 'package:demo/date_service.dart';

void main() {
  group('Locator Setup Tests', () {
    tearDown(() {
      locator.reset();
    });

    test('setupLocator registers DateService correctly', () {
      setupLocator();

      expect(locator.isRegistered<DateService>(), true, reason: 'DateService should be registered');
    });
  });
}