import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'todo.dart';

class TodoPageViewModel {
  TodoPageViewModel();

  final ValueNotifier<List<Todo>> todosNotifier = ValueNotifier([]);

  void add(String title) {

  }

  void remove(Todo todo) {

  }

  void toggleDone(Todo todo) {

  }
}
