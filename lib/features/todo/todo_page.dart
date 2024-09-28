import 'package:flutter/material.dart';
import 'package:todo/features/todo/todo_page_view_model.dart';
import 'package:todo/features/todo/todo_repository.dart';
import 'package:todo/shared/date_service.dart';
import 'package:todo/shared/locator.dart';

import 'todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late final homePageViewModel = TodoPageViewModel(
    dateService: locator<DateService>(),
    todoRepository: locator<TodoRepository>(),
  );

  final TextEditingController _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    homePageViewModel.init();
  }

  @override
  void dispose() {
    _todoController.dispose();
    homePageViewModel.dispose();
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
      ),
      body: TodoList(
        toggleDone: homePageViewModel.toggleDone,
        removeTodo: homePageViewModel.remove,
        todosNotifier: homePageViewModel.todosNotifier,
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

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.todosNotifier,
    required this.toggleDone,
    required this.removeTodo,
  });

  final ValueNotifier<List<Todo>> todosNotifier;
  final void Function(Todo todo) toggleDone;
  final void Function(Todo todo) removeTodo;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: todosNotifier,
      builder: (context, todos, child) {
        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return TodoItem(
              todo: todo,
              toggleDone: toggleDone,
              removeTodo: removeTodo,
            );
          },
        );
      },
    );
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.todo,
    required this.toggleDone,
    required this.removeTodo,
  });

  final Todo todo;
  final void Function(Todo todo) toggleDone;
  final void Function(Todo todo) removeTodo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.title),
      trailing: Checkbox(
        value: todo.completed,
        onChanged: (bool? value) => toggleDone(todo),
      ),
      onLongPress: () => removeTodo(todo),
    );
  }
}
