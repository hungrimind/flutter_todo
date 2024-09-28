import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:todo/features/todo/todo_repository.dart';
import 'package:todo/shared/date_service.dart';
import 'package:todo/todo.dart';

/// the viewmodel which is responsible for business logic of the page
/// this should be fully unit testable and dependencies should be constructor injected
class TodoPageViewModel {
  TodoPageViewModel(
      {required DateService dateService,
      required TodoRepository todoRepository})
      : _dateService = dateService,
        _todoRepository = todoRepository;

  final DateService _dateService;
  final TodoRepository _todoRepository;

  ValueNotifier<DateTime> get serviceDate => _dateService.dateNotifier;

  final ValueNotifier<List<Todo>> todos = ValueNotifier([]);
  final ValueNotifier<bool> showCompletedTodos = ValueNotifier(false);

  bool get hasNonCompletedTodos =>
      todos.value.where((element) => element.completed).isNotEmpty;

  Future<void> init() async {
    _todoRepository.todos.addListener(onTodosUpdate);
  }

  void onTodosUpdate() {
    todos.value = _todoRepository.todos.value;
  }

  Future<void> add(Todo todo) async {
    _todoRepository.addTodo(todo);
  }

  Future<void> remove(Todo todo) async {
    _todoRepository.removeTodo(todo);
  }

  Future<void> toggleDone(Todo todo) async {
    _todoRepository.toggleDone(todo);
  }

  void toggleCompletedTodos() {
    showCompletedTodos.value = !showCompletedTodos.value;
  }

  void updateServiceDate() {
    _dateService.updateDate();
  }

  void dispose() {
    _todoRepository.todos.removeListener(onTodosUpdate);
  }
}
