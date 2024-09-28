class Todo {
  final String title;
  final bool completed;

  Todo({
    required this.title,
    this.completed = false,
  });

  Todo copyWith({
    String? title,
    String? description,
    bool? completed,
  }) {
    return Todo(
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
