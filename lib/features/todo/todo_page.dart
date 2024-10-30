import 'package:flutter/material.dart';
import 'package:todo/features/todo/todo_page_view_model.dart';
import 'package:todo/services/date_service.dart';
import 'package:todo/utilities/locator.dart';
import 'package:todo/utilities/value_listenable_builder_x.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late final homePageViewModel = TodoPageViewModel(
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
                homePageViewModel.add(
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
      first: homePageViewModel.dateNotifier,
      second: homePageViewModel.todosNotifier,
      third: homePageViewModel.showCompletedTodosNotifier,
      builder: (context, date, todos, showCompletedTodos, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Time: ${date.millisecondsSinceEpoch}"),
            actions: [
              TextButton(
                onPressed: () {
                  homePageViewModel.toggleCompletedTodos();
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
                      homePageViewModel.toggleDone(todo),
                ),
                onLongPress: () => homePageViewModel.remove(todo),
              );
            },
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: homePageViewModel.resetDate,
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
