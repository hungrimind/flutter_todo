import 'package:flutter/foundation.dart';

class DateService {
  ValueNotifier<DateTime> dateNotifier = ValueNotifier(DateTime.now());

  void updateDate() {
    dateNotifier.value = DateTime.now();
  }
}
