import 'dart:async';

import 'package:todo/database.dart';
import 'package:todo/features/todo/todo_entity.dart';

/// Provide a uniform way for services and view models to interact with your data
class TodoRepository {
  TodoRepository({required InMemoryDataSource inMemoryDataSource})
      : _inMemoryDataSource = inMemoryDataSource;

  /// This is an example but could be for example Firestore
  final InMemoryDataSource _inMemoryDataSource;

  Stream<List<TodoEntity>> watch() {
    return _inMemoryDataSource.stream;
  }

  Future<void> addTodo({required String title}) async {
    _inMemoryDataSource.add(title: title);
  }

  Future<void> removeTodo(TodoEntity todo) async {
    _inMemoryDataSource.remove(todo);
  }

  Future<void> toggleDone(TodoEntity todo) async {
    final updatedTodo = todo.copyWith(completed: !todo.completed);

    _inMemoryDataSource.update(updatedTodo);
  }
}
