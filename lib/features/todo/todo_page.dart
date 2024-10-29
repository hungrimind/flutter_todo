import 'package:flutter/material.dart';
import 'package:todo/features/todo/todo_entity.dart';
import 'package:todo/features/todo/todo_page_view_model.dart';
import 'package:todo/features/todo/todo_repository.dart';
import 'package:todo/shared/date_service.dart';
import 'package:todo/shared/locator.dart';
import 'package:todo/shared/ui_utilities/value_listenable_builder_x.dart';

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
        actions: [
          ValueListenableBuilder2(
            first: homePageViewModel.todosNotifier,
            second: homePageViewModel.showCompletedTodosNotifier,
            builder: (context, todos, showCompletedTodos, child) {
              if (homePageViewModel.hasNonCompletedTodos) {
                return TextButton(
                  onPressed: () {
                    homePageViewModel.toggleCompletedTodos();
                  },
                  child: showCompletedTodos
                      ? const Text("Hide Done")
                      : const Text("Show Done"),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: TodoList(
        toggleDone: homePageViewModel.toggleDone,
        removeTodo: homePageViewModel.remove,
        todosNotifier: homePageViewModel.todosNotifier,
        showCompletedTodos: homePageViewModel.showCompletedTodosNotifier,
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
    required this.showCompletedTodos,
    required this.toggleDone,
    required this.removeTodo,
  });

  final ValueNotifier<List<TodoEntity>> todosNotifier;
  final ValueNotifier<bool> showCompletedTodos;
  final void Function(TodoEntity todo) toggleDone;
  final void Function(TodoEntity todo) removeTodo;

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
              showCompletedTodos: showCompletedTodos,
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
    required this.showCompletedTodos,
    required this.todo,
    required this.toggleDone,
    required this.removeTodo,
  });

  final ValueNotifier<bool> showCompletedTodos;
  final TodoEntity todo;
  final void Function(TodoEntity todo) toggleDone;
  final void Function(TodoEntity todo) removeTodo;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: showCompletedTodos,
      builder: (context, showCompletedTodos, child) {
        if (todo.completed && !showCompletedTodos) {
          return const SizedBox();
        }

        return ListTile(
          title: Text(todo.title),
          trailing: Checkbox(
            value: todo.completed,
            onChanged: (bool? value) => toggleDone(todo),
          ),
          onLongPress: () => removeTodo(todo),
        );
      },
    );
  }
}
