import 'package:flutter/material.dart';
import 'package:demo/date_service.dart';
import 'package:uuid/uuid.dart';

import 'todo.dart';

class TodoPageViewModel {
  TodoPageViewModel({required DateService dateService})
      : _dateService = dateService;

  final DateService _dateService;

  ValueNotifier<DateTime> get dateNotifier => _dateService.dateNotifier;

  final ValueNotifier<List<Todo>> todosNotifier = ValueNotifier([]);

  void add(String title) {
    todosNotifier.value = [
      ...todosNotifier.value,
      Todo(id: const Uuid().v4(), title: title, completed: false),
    ];
  }

  void remove(Todo todo) {
    todosNotifier.value =
        todosNotifier.value.where((t) => t.id != todo.id).toList();
  }

  void toggleDone(Todo todo) {
    todosNotifier.value = todosNotifier.value
        .map((t) => t.id == todo.id ? t.copyWith(completed: !t.completed) : t)
        .toList();
  }

  void resetDate() {
    // TODO: call _dateService 
  }
}
