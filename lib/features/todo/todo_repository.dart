import 'package:flutter/foundation.dart';
import 'package:todo/todo.dart';

class TodoRepository {
  TodoRepository();

  // this should live in a server or local storage and we should provide a listenable approach to this item
  // ValueNotifier here is just an example but most storage solutions and packages provide a reactive way to get data.
  final ValueNotifier<List<Todo>> todos = ValueNotifier([]);

  void addTodo(Todo todo) {
    todos.value = [...todos.value, todo];
  }

  void removeTodo(Todo todo) {
    todos.value = todos.value.where((element) => element != todo).toList();
  }

  void toggleDone(Todo todo) {
    todos.value = todos.value.map((oldTodo) {
      if (oldTodo == todo) {
        return oldTodo.copyWith(completed: !oldTodo.completed);
      }
      return oldTodo;
    }).toList();
  }
}
