import 'dart:async';

import 'package:todo/features/todo/todo_entity.dart';
import 'package:uuid/uuid.dart';

class InMemoryDataSource {
  final BehaviorSubject<List<TodoEntity>> _todosController =
      BehaviorSubject([]);

  Stream<List<TodoEntity>> get stream => _todosController.stream;

  void add({required String title}) {
    const uuid = Uuid();
    final id = uuid.v4();
    final todo = TodoEntity(id: id, title: title, completed: false);
    _todosController.add([..._todosController.value, todo]);
  }

  void remove(TodoEntity todo) {
    _todosController
        .add(_todosController.value.where((t) => t.id != todo.id).toList());
  }

  void update(TodoEntity updatedTodo) {
    final updatedTodoEntitys = _todosController.value.map((t) {
      if (t.id == updatedTodo.id) {
        return updatedTodo;
      }
      return t;
    }).toList();

    _todosController.add(updatedTodoEntitys);
  }
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
