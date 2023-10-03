import 'dart:convert';

class Todo {
  final String title;
  final String description;
  final bool isDone;

  Todo({
    required this.title,
    required this.description,
    required this.isDone,
  });

  Todo copyWith({
    String? title,
    String? description,
    bool? isDone,
  }) {
    return Todo(
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));

  @override
  String toString() =>
      'Todo(title: $title, description: $description, isDone: $isDone)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Todo &&
        other.title == title &&
        other.description == description &&
        other.isDone == isDone;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode ^ isDone.hashCode;
}
