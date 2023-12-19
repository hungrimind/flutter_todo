import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/todo.dart';

class TodoStateHolder extends StatefulWidget {
  const TodoStateHolder({required this.child, Key? key}) : super(key: key);

  final Widget child;

  static TodoStateHolderState of(BuildContext context) {
    return context.findAncestorStateOfType<TodoStateHolderState>()!;
  }

  @override
  TodoStateHolderState createState() => TodoStateHolderState();
}

class TodoStateHolderState extends State<TodoStateHolder> {
  late SharedPreferences prefs;
  TodoState _todoState = TodoState(todoList: []);

  @override
  void initState() {
    super.initState();
    _retrieveTodos();
  }

  @override
  Widget build(BuildContext context) {
    return TodoProvider(
      _todoState,
      child: widget.child,
    );
  }

  _retrieveTodos() async {
    prefs = await SharedPreferences.getInstance();
    final String? storedTodoList = prefs.getString('todoList');
    if (storedTodoList != null) {
      setState(() {
        _todoState = TodoState(
            todoList: (jsonDecode(storedTodoList) as List)
                .map((todo) => Todo.fromJson(todo))
                .toList());
      });
    }
  }

  _saveTodos() async {
    await prefs.setString('todoList', jsonEncode(_todoState.todoList));
  }

  void add(Todo todo) {
    setState(() {
      _todoState = _todoState.copyWith(
        todoList: [..._todoState.todoList, todo],
      );
    });
    _saveTodos();
  }

  void update(int index, Todo todo) {
    setState(() {
      _todoState = _todoState.copyWith(
        todoList: List.from(_todoState.todoList)..[index] = todo,
      );
    });
    _saveTodos();
  }

  void delete(int index) {
    setState(() {
      _todoState = _todoState.copyWith(
        todoList: [..._todoState.todoList]..removeAt(index),
      );
    });
    _saveTodos();
  }
}

class TodoState {
  TodoState({
    required this.todoList,
  });

  final List<Todo> todoList;

  TodoState copyWith({
    List<Todo>? todoList,
  }) {
    return TodoState(
      todoList: todoList ?? this.todoList,
    );
  }
}

class TodoProvider extends InheritedWidget {
  const TodoProvider(this.data, {Key? key, required Widget child})
      : super(key: key, child: child);

  final TodoState data;

  static TodoState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TodoProvider>()!.data;
  }

  @override
  bool updateShouldNotify(TodoProvider oldWidget) {
    return data != oldWidget.data;
  }
}
