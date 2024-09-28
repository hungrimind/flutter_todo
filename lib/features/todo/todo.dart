import 'package:todo/shared/database/database.dart';

class Todo {
  final String id;
  final String title;
  final bool completed;

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
  });

  TodoEntity toEntity() {
    return TodoEntity(
      id: id,
      title: title,
      completed: completed,
    );
  }

  Todo copyWith({
    String? title,
    bool? completed,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
