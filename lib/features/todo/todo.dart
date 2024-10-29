class Todo {
  final String id;
  final String title;
  final bool completed;

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
  });

  Todo copyWith({
    String? title,
    bool? completed,
  }) {
    return Todo(
        id: id,
        title: title ?? this.title,
        completed: completed ?? this.completed);
  }
}
