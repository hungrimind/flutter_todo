import 'package:flutter/foundation.dart';

class DateService {
  ValueNotifier<DateTime> dateNotifier = ValueNotifier(DateTime.now());

  void resetDate() {
    dateNotifier.value = DateTime.now();
  }
}
