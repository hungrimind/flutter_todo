import 'dart:async';

import 'package:todo/fake_data_source.dart';
import 'package:todo/features/todo/todo.dart';
import 'package:todo/features/todo/todo_entity.dart';
import 'package:uuid/uuid.dart';

// Provide a uniform way for services and view models to interact with your data
class TodoRepository {
  TodoRepository({required FakeDataSource fakeDataSource})
      : _fakeDataSource = fakeDataSource;

  final FakeDataSource _fakeDataSource;
  final BehaviorSubject<List<Todo>> _todosController = BehaviorSubject([]);

  Stream<List<Todo>> watch() {
    return _todosController.stream;
  }

  Future<void> addTodo({required String title}) async {
    const uuid = Uuid();
    final id = uuid.v4();
    final todo = TodoEntity(id: id, title: title, completed: false);

    _fakeDataSource.add();
    _todosController.add([..._todosController.value, todo.toTodo()]);
  }

  Future<void> removeTodo(Todo todo) async {
    _fakeDataSource.remove();

    _todosController
        .add(_todosController.value.where((t) => t.id != todo.id).toList());
  }

  Future<void> toggleDone(Todo todo) async {
    _fakeDataSource.update();

    final updatedTodos = _todosController.value.map((t) {
      if (t.id == todo.id) {
        return Todo(id: t.id, title: t.title, completed: !t.completed);
      }
      return t;
    }).toList();

    _todosController.add(updatedTodos);
  }
}
