import 'package:flutter/material.dart';
import 'package:todo/features/todo/todo_page_view_model.dart';
import 'package:todo/shared/date_service.dart';
import 'package:todo/shared/locator.dart';

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
  void initState() {
    super.initState();
  }

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
          title: const Text("Add Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _todoController,
                decoration: const InputDecoration(
                  labelText: "Enter Todo",
                ),
              ),
            ],
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
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: homePageViewModel.serviceDate,
          builder: (context, date, child) {
            return Text("Todo $date");
          },
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: homePageViewModel.todosNotifier,
            builder: (context, todos, child) {
              if (homePageViewModel.hasNonCompletedTodos) {
                return TextButton(
                  onPressed: () {
                    homePageViewModel.toggleCompletedTodos();
                  },
                  child: ValueListenableBuilder(
                    valueListenable:
                        homePageViewModel.showCompletedTodosNotifier,
                    builder: (context, showCompletedTodos, child) {
                      return showCompletedTodos
                          ? const Text("Hide Done")
                          : const Text("Show Done");
                    },
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: homePageViewModel.todosNotifier,
        builder: (context, todos, child) {
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ValueListenableBuilder(
                valueListenable: homePageViewModel.showCompletedTodosNotifier,
                builder: (context, showCompletedTodos, child) {
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
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: homePageViewModel.updateServiceDate,
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
  }
}
