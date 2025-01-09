import 'package:flutter/material.dart';
import 'package:demo/todo/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TodoPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: Colors.black),
      ),
    );
  }
}
