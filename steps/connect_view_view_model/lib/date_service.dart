import 'package:flutter/material.dart';

class DateService {
  DateService();

  final ValueNotifier<DateTime> dateNotifier = ValueNotifier(DateTime(2024, 12, 1));

  void resetDate() {
  }
}