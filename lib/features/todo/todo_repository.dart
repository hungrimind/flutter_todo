import 'package:todo/features/todo/todo.dart';
import 'package:todo/features/todo/todo_local_data_source.dart';
import 'package:todo/shared/database/database.dart';

// provide a uniform way for services and view models to interact with your data
class TodoRepository {
  TodoRepository({required TodoLocalDataSource todoLocalDataSource})
      : _todoLocalDataSource = todoLocalDataSource;

  final TodoLocalDataSource _todoLocalDataSource;

  Stream<List<Todo>> listenAll() {
    return _todoLocalDataSource.listenAll().map((todos) {
      return todos.map((todo) {
        return todo.toTodo();
      }).toList();
    });
  }

  Future<void> addTodo({required String title}) async {
    await _todoLocalDataSource.add(title);
  }

  Future<void> removeTodo(Todo todo) async {
    await _todoLocalDataSource.remove(todo.toEntity());
  }

  Future<void> toggleDone(Todo todo) async {
    final toggledTodo = todo.copyWith(completed: !todo.completed);
    await _todoLocalDataSource.update(toggledTodo.toEntity());
  }
}
