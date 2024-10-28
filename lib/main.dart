import 'package:flutter/material.dart';
import 'package:todo/features/todo/todo_page.dart';
import 'package:todo/shared/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize our service, repositories and other app wide classes
  setupLocators();

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
