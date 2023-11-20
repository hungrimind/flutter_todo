import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/todo.dart';

void main() {
  runApp(MaterialApp(
    home: const MyHomePage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: const ColorScheme.light(
        primary: Colors.black,
      ),
    ),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences prefs;
  List<Todo> _todoList = [];
  bool showDone = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _retrieveTodos();
  }

  _retrieveTodos() async {
    prefs = await SharedPreferences.getInstance();
    final String? storedTodoList = prefs.getString('todoList');
    if (storedTodoList != null) {
      setState(() {
        _todoList = (jsonDecode(storedTodoList) as List)
            .map((todo) => Todo.fromJson(todo))
            .toList();
      });
    }
  }

  _saveTodos() async {
    await prefs.setString('todoList', jsonEncode(_todoList));
  }

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
                setState(() {
                  _todoList.add(Todo(
                    title: _titleController.text,
                    description: _descriptionController.text,
                  ));
                });

                _titleController.clear();
                _descriptionController.clear();
                _saveTodos();
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _deleteTodo(int index) {
    setState(() {
      _todoList.removeAt(index);
    });
    _saveTodos();
  }

  void _updateTodo(int index, bool? value) {
    setState(() {
      _todoList[index] = Todo(
        title: _todoList[index].title,
        description: _todoList[index].description,
        isDone: value!,
      );
    });
    _saveTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo"),
        actions: [
          if (_todoList.where((element) => element.isDone).isNotEmpty)
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
          itemCount: _todoList.length,
          itemBuilder: (context, index) {
            if (_todoList[index].isDone && !showDone) return Container();
            return ListTile(
              title: Text(_todoList[index].title),
              subtitle: _todoList[index].description != null
                  ? Text(_todoList[index].description!)
                  : null,
              trailing: Checkbox(
                value: _todoList[index].isDone,
                onChanged: (bool? value) {
                  _updateTodo(index, value);
                },
              ),
              onLongPress: () => _deleteTodo(index),
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
