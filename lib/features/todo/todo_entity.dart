import 'package:todo/features/todo/todo.dart';

class TodoEntity {
  TodoEntity({
    required this.id,
    required this.title,
    required this.completed,
  });

  final String id;
  final String title;
  final bool completed;

  Todo toTodo() {
    return Todo(
      id: id,
      title: title,
      completed: completed,
    );
  }
}
