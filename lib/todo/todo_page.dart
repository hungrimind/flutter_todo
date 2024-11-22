import 'package:flutter/material.dart';
import 'package:flutter_todo/date_service.dart';
import 'package:flutter_todo/utils/locator.dart';
import 'package:flutter_todo/utils/valuelistenablebuilder3.dart';

import 'todo_page_view_model.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();

  static const todoFieldKey = ValueKey('todoFieldKey');
  static const popupAddTodoKey = ValueKey('popupAddTodoKey');
  static const toggleTodoKey = ValueKey('toggleTodoKey');
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
          key: const ValueKey(TodoPage.todoFieldKey),
          controller: _todoController,
          decoration: const InputDecoration(labelText: "Enter Todo"),
        ),
        actions: [
          TextButton(
            key: TodoPage.popupAddTodoKey,
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
    return ValueListenableBuilder3(
      first: _todoPageViewModel.showCompletedTodosNotifier,
      second: _todoPageViewModel.dateNotifier,
      third: _todoPageViewModel.todosNotifier,
      builder: (context, showCompletedTodos, date, todos, child) => Scaffold(
        appBar: AppBar(
          title: Text("Time: ${date.hour}:${date.minute}:${date.second}"),
          actions: [
            TextButton(
              key: TodoPage.toggleTodoKey,
              onPressed: () {
                _todoPageViewModel.toggleShowCompletedTodos();
              },
              child: Text(showCompletedTodos ? "Hide Done" : "Show Done"),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];

            if (!showCompletedTodos && todo.completed) {
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
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                _todoPageViewModel.resetDate();
              },
              child: const Icon(Icons.refresh),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: () {
                _addTodo();
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
