import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todo {
  final String title;
  final String? description;
  final bool isDone;

  Todo({
    required this.title,
    this.description,
    this.isDone = false,
  });

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
      description: map['description'],
      isDone: map['isDone'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));

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
}

class TodoListNotifier extends ValueNotifier<List<Todo>> {
  TodoListNotifier(super.state) {
    _initializeTodos();
  }

  late SharedPreferences prefs;

  void _initializeTodos() async {
    prefs = await SharedPreferences.getInstance();
    final String? storedTodoList = prefs.getString('todoList');
    if (storedTodoList != null) {
      value = (jsonDecode(storedTodoList) as List)
          .map((todo) => Todo.fromJson(todo))
          .toList();
    }
  }

  void add(Todo todo) async {
    value = [...value, todo];
    await prefs.setString('todoList', jsonEncode(value));
  }

  void remove(Todo todo) async {
    value = value.where((element) => element != todo).toList();
    await prefs.setString('todoList', jsonEncode(value));
  }

  void toggleDone(Todo todo) async {
    value = value.map((oldTodo) {
      if (oldTodo == todo) {
        return oldTodo.copyWith(isDone: !oldTodo.isDone);
      }
      return oldTodo;
    }).toList();

    await prefs.setString('todoList', jsonEncode(value));
  }
}
