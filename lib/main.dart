import 'package:flutter/material.dart';
import 'package:todo/provider.dart';
import 'package:todo/todo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    Provider(
      notifier: TodoListNotifier(),
      child: MaterialApp(
        home: const MyHomePage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Colors.black,
          ),
        ),
      ),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showDone = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<TodoListNotifier>(context).add(
                  Todo(
                    title: _titleController.text,
                    description: _descriptionController.text,
                  ),
                );

                _titleController.clear();
                _descriptionController.clear();
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
    final todoListNotifier = Provider.of<TodoListNotifier>(context);
    final todoList = todoListNotifier.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo"),
        actions: [
          if (todoList.where((element) => element.isDone).isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  showDone = !showDone;
                });
              },
              child:
                  showDone ? const Text("Hide Done") : const Text("Show Done"),
            )
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            if (todoList[index].isDone && !showDone) {
              return Container();
            }
            return ListTile(
              title: Text(todoList[index].title),
              subtitle: todoList[index].description != null
                  ? Text(todoList[index].description!)
                  : null,
              trailing: Checkbox(
                value: todoList[index].isDone,
                onChanged: (bool? value) =>
                    todoListNotifier.toggleDone(todoList[index]),
              ),
              onLongPress: () => todoListNotifier.remove(todoList[index]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
