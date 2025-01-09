import 'package:flutter/material.dart';
import 'package:demo/date_service.dart';
import 'package:demo/utils/locator.dart';

import 'todo_page_view_model.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TodoPageViewModel _todoPageViewModel = TodoPageViewModel(
    dateService: locator<DateService>(),
  );

  final TextEditingController _todoController = TextEditingController();

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
              _todoPageViewModel.add(_todoController.text);
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
      body: ValueListenableBuilder(
          valueListenable: _todoPageViewModel.todosNotifier,
          builder: (context, todos, child) {
            return ListView.builder(
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
                      _todoPageViewModel.toggleDone(todo);
                    },
                  ),
                  onLongPress: () {
                    _todoPageViewModel.remove(todo);
                  },
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodo();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
