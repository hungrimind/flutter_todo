import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:todo/shared/date_service.dart';
import 'package:uuid/uuid.dart';

import 'todo.dart';

/// the viewmodel which is responsible for business logic of the page
/// this should be fully unit testable and dependencies should be constructor injected
class TodoPageViewModel {
  TodoPageViewModel({
    required DateService dateService,
  }) : _dateService = dateService;

  final DateService _dateService;

  ValueNotifier<DateTime> get serviceDate => _dateService.dateNotifier;

  final ValueNotifier<List<Todo>> todosNotifier = ValueNotifier([]);
  final ValueNotifier<bool> showCompletedTodosNotifier = ValueNotifier(false);

  bool get hasNonCompletedTodos =>
      todosNotifier.value.where((element) => element.completed).isNotEmpty;

  Future<void> add({required String title}) async {
    todosNotifier.value = [
      ...todosNotifier.value,
      Todo(id: const Uuid().v4(), title: title),
    ];
  }

  Future<void> remove(Todo todo) async {
    todosNotifier.value =
        todosNotifier.value.where((element) => element.id != todo.id).toList();
  }

  Future<void> toggleDone(Todo todo) async {
    todosNotifier.value = todosNotifier.value
        .map((element) => element.id == todo.id
            ? todo.copyWith(completed: !todo.completed)
            : element)
        .toList();
  }

  void toggleCompletedTodos() {
    showCompletedTodosNotifier.value = !showCompletedTodosNotifier.value;
  }

  void updateServiceDate() {
    _dateService.updateDate();
  }
}
