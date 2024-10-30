import 'package:flutter/material.dart';
import 'package:todo/date_service.dart';
import 'package:todo/todo/todo_page_view_model.dart';
import 'package:todo/utils/locator.dart';
import 'package:todo/utils/value_listenable_builder_x.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late final todoPageViewModel = TodoPageViewModel(
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
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: _todoController,
            decoration: const InputDecoration(
              labelText: "Enter Todo",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                todoPageViewModel.add(
                  title: _todoController.text,
                );

                _todoController.clear();
                Navigator.pop(context);
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
    return ValueListenableBuilder3(
      first: todoPageViewModel.dateNotifier,
      second: todoPageViewModel.todosNotifier,
      third: todoPageViewModel.showCompletedTodosNotifier,
      builder: (context, date, todos, showCompletedTodos, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Time: ${date.millisecondsSinceEpoch}"),
            actions: [
              TextButton(
                onPressed: () {
                  todoPageViewModel.toggleCompletedTodos();
                },
                child: showCompletedTodos
                    ? const Text("Hide Done")
                    : const Text("Show Done"),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              if (todo.completed && !showCompletedTodos) {
                return const SizedBox();
              }

              return ListTile(
                title: Text(todo.title),
                trailing: Checkbox(
                  value: todo.completed,
                  onChanged: (bool? value) =>
                      todoPageViewModel.toggleDone(todo),
                ),
                onLongPress: () => todoPageViewModel.remove(todo),
              );
            },
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: todoPageViewModel.resetDate,
                child: const Icon(Icons.date_range),
              ),
              const SizedBox(width: 12),
              FloatingActionButton(
                onPressed: _addTodo,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        );
      },
    );
  }
}
