class Todo {
  final String title;
  final String? description;
  final bool completed;

  Todo({
    required this.title,
    this.description,
    this.completed = false,
  });

  Todo copyWith({
    String? title,
    String? description,
    bool? completed,
  }) {
    return Todo(
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}
