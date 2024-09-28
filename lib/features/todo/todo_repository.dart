import 'package:flutter/foundation.dart';
import 'package:todo/features/todo/todo.dart';
import 'package:todo/features/todo/todo_entity.dart';
import 'package:uuid/uuid.dart';

// provide a uniform way for services and view models to interact with your data
class TodoRepository {
  TodoRepository({required FakeLocalDataSource fakeLocalDataSource})
      : _fakeLocalDataSource = fakeLocalDataSource;

  final FakeLocalDataSource _fakeLocalDataSource;
  final ValueNotifier<List<TodoEntity>> _todosNotifier = ValueNotifier([]);
  List<TodoEntity> get todos => _todosNotifier.value;

  void addListener(void Function() listener) =>
      _todosNotifier.addListener(listener);
  void removeListener(void Function() listener) =>
      _todosNotifier.removeListener(listener);

  Future<void> addTodo({required String title}) async {
    const uuid = Uuid();
    final id = uuid.v4();
    final todo = TodoEntity(id: id, title: title, completed: false);

    _fakeLocalDataSource.add();
    _todosNotifier.value = [..._todosNotifier.value, todo];
  }

  Future<void> removeTodo(Todo todo) async {
    _fakeLocalDataSource.remove();

    _todosNotifier.value =
        _todosNotifier.value.where((t) => t.id != todo.id).toList();
  }

  Future<void> toggleDone(Todo todo) async {
    _fakeLocalDataSource.update();

    final updatedTodos = _todosNotifier.value.map((t) {
      if (t.id == todo.id) {
        return TodoEntity(id: t.id, title: t.title, completed: !t.completed);
      }
      return t;
    }).toList();
    _todosNotifier.value = updatedTodos;
  }
}

class FakeLocalDataSource {
  Future<void> add() async {}

  Future<void> remove() async {}

  Future<void> update() async {}
}
