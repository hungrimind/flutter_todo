import 'package:flutter/material.dart';
import 'package:demo/todo/todo.dart';
import 'package:uuid/uuid.dart';

import 'todo_page_view_model.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _todoController = TextEditingController();

  final todos = <Todo>[];

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  void _addTodo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _todoController,
          decoration: const InputDecoration(labelText: "Enter Todo"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                todos.add(Todo(
                    id: const Uuid().v4(),
                    title: _todoController.text,
                    completed: false));
              });
              _todoController.clear();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Display time here later"),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];

          if (todo.completed) {
            return const SizedBox();
          }

          return ListTile(
            title: Text(todo.title),
            trailing: Checkbox(
              value: todo.completed,
              onChanged: (value) {
                final newTodo = todo.copyWith(completed: value ?? false);
                setState(() {
                  todos[index] = newTodo;
                });
              },
            ),
            onLongPress: () {
              setState(() {
                todos.removeAt(index);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodo();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
