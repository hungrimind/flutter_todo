import 'package:flutter/material.dart';

class DateService {
  DateService();

  final ValueNotifier<DateTime> dateNotifier = ValueNotifier(DateTime.now());

  void resetDate() {
    dateNotifier.value = DateTime.now();
  }
}
