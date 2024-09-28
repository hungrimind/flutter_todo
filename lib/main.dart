import 'package:flutter/material.dart';
import 'package:todo/features/todo/todo_page.dart';
import 'package:todo/features/todo/todo_repository.dart';
import 'package:todo/shared/date_service.dart';
import 'package:todo/todo.dart';

// app wide dependencies, consider using GetIt to override
// dependencies in tests.
late final DateService dateService;
late final TodoRepository todoRepository;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  dateService = DateService();
  todoRepository = TodoRepository();

  runApp(
    MaterialApp(
      home: const TodoPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
        ),
      ),
    ),
  );
}

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.todosNotifier,
    required this.showCompletedTodos,
    required this.toggleDone,
    required this.removeTodo,
  });

  final ValueNotifier<List<Todo>> todosNotifier;
  final ValueNotifier<bool> showCompletedTodos;
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
  final Todo todo;
  final void Function(Todo todo) toggleDone;
  final void Function(Todo todo) removeTodo;

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
          subtitle: todo.description != null ? Text(todo.description!) : null,
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
