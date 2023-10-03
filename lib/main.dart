import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> todos = [];
  List<Todo> completedTodos = [];
  bool showCompletedTodos = false;

  @override
  initState() {
    super.initState();
    _retrieveTodos();
  }

  @override
  dispose() {
    _saveLocally();
    super.dispose();
  }

  void _addTodo(String title, String description) {
    setState(() {
      todos.add(Todo(
        title: title,
        description: description,
        isDone: false,
      ));
    });
    _saveLocally();
  }

  void _finishTodo(int index, Todo todo) {
    setState(() {
      todos.removeAt(index);
      completedTodos.add(todo);
    });
    _saveLocally();
  }

  void _unfinishTodo(int index, Todo todo) {
    setState(() {
      completedTodos.removeAt(index);
      todos.add(todo);
    });
    _saveLocally();
  }

  void _saveLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todosJson = jsonEncode(todos.map((todo) => todo.toJson()).toList());
    String completedTodosJson =
        jsonEncode(completedTodos.map((todo) => todo.toJson()).toList());
    await prefs.setString('todos', todosJson);
    await prefs.setString('completedTodos', completedTodosJson);
  }

  void _retrieveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todosJson = prefs.getString('todos') ?? '[]';
    String completedTodosJson = prefs.getString('completedTodos') ?? '[]';
    setState(() {
      todos = (jsonDecode(todosJson) as List)
          .map((todo) => Todo.fromJson(todo))
          .toList();
      completedTodos = (jsonDecode(completedTodosJson) as List)
          .map((todo) => Todo.fromJson(todo))
          .toList();
    });
  }

  _deleteTodo(int index, Todo todo, bool isCompletedTodo) {
    setState(() {
      if (isCompletedTodo) {
        completedTodos.removeAt(index);
      } else {
        todos.removeAt(index);
      }
    });
    _saveLocally();
  }

  _showTodoDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _addTodo(titleController.text, descriptionController.text);
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              title: Text("Todo"),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == todos.length) {
                    if (completedTodos.isEmpty) return Container();
                    if (showCompletedTodos) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: const Text("Hide Completed Todos"),
                            onPressed: () => setState(() {
                              showCompletedTodos = false;
                            }),
                          ),
                        ],
                      );
                    } else {
                      return TextButton(
                        child: const Text("Completed Todos"),
                        onPressed: () => setState(() {
                          showCompletedTodos = true;
                        }),
                      );
                    }
                  }
                  return ListTile(
                    title: Text(todos[index].title),
                    subtitle: Text(todos[index].description),
                    trailing: Checkbox(
                      value: todos[index].isDone,
                      onChanged: (value) {
                        _finishTodo(
                          index,
                          todos[index].copyWith(
                            isDone: value,
                          ),
                        );
                      },
                    ),
                    onLongPress: () {
                      _deleteTodo(
                        index,
                        todos[index],
                        false,
                      );
                    },
                  );
                },
                childCount: todos.length + 1,
              ),
            ),
            if (showCompletedTodos)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ListTile(
                      title: Text(completedTodos[index].title),
                      subtitle: Text(completedTodos[index].description),
                      trailing: Checkbox(
                        value: completedTodos[index].isDone,
                        onChanged: (value) {
                          _unfinishTodo(
                            index,
                            completedTodos[index].copyWith(
                              isDone: value,
                            ),
                          );
                        },
                      ),
                      onLongPress: () {
                        _deleteTodo(
                          index,
                          completedTodos[index],
                          true,
                        );
                      },
                    );
                  },
                  childCount: completedTodos.length,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTodoDialog,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
