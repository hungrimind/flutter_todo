import 'dart:async';

import 'package:todo/features/todo/todo.dart';
import 'package:todo/features/todo/todo_entity.dart';
import 'package:uuid/uuid.dart';

// Provide a uniform way for services and view models to interact with your data
class TodoRepository {
  TodoRepository({required FakeLocalDataSource fakeLocalDataSource})
      : _fakeLocalDataSource = fakeLocalDataSource;

  final FakeLocalDataSource _fakeLocalDataSource;
  final BehaviorSubject<List<Todo>> _todosController = BehaviorSubject([]);

  Stream<List<Todo>> watch() {
    return _todosController.stream;
  }

  Future<void> addTodo({required String title}) async {
    const uuid = Uuid();
    final id = uuid.v4();
    final todo = TodoEntity(id: id, title: title, completed: false);

    _fakeLocalDataSource.add();
    _todosController.add([..._todosController.value, todo.toTodo()]);
  }

  Future<void> removeTodo(Todo todo) async {
    _fakeLocalDataSource.remove();

    _todosController
        .add(_todosController.value.where((t) => t.id != todo.id).toList());
  }

  Future<void> toggleDone(Todo todo) async {
    _fakeLocalDataSource.update();

    final updatedTodos = _todosController.value.map((t) {
      if (t.id == todo.id) {
        return Todo(id: t.id, title: t.title, completed: !t.completed);
      }
      return t;
    }).toList();

    _todosController.add(updatedTodos);
  }
}

class FakeLocalDataSource {
  Future<void> add() async {}

  Future<void> remove() async {}

  Future<void> update() async {}
}

class BehaviorSubject<T> {
  // StreamController with broadcast mode
  final StreamController<T> _controller;
  T _currentValue;

  // Constructor to initialize with an initial value
  BehaviorSubject(T initialValue)
      : _currentValue = initialValue,
        _controller = StreamController<T>.broadcast();

  // Getter for the current value
  T get value => _currentValue;

  // Adds a new value and broadcasts it to all listeners
  void add(T newValue) {
    _currentValue = newValue;
    _controller.add(newValue);
  }

  // Exposes the stream to listen to changes
  Stream<T> get stream => _controller.stream;

  // Subscribes a listener and immediately emits the current value
  StreamSubscription<T> listen(void Function(T) onData) {
    final subscription = _controller.stream.listen(onData);
    // Emit the current value immediately
    onData(_currentValue);
    return subscription;
  }

  // Closes the StreamController when done
  Future<void> close() async {
    await _controller.close();
  }
}
