class TodoEntity {
  TodoEntity({
    required this.id,
    required this.title,
    required this.completed,
  });

  final String id;
  final String title;
  final bool completed;

  TodoEntity copyWith({
    String? id,
    String? title,
    bool? completed,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
