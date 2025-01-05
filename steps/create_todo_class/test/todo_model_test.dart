import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo/todo/todo.dart';

void main() {
  group('Todo', () {
    test('should create a Todo instance with the given values', () {
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
        completed: false,
      );

      expect(todo.id, '1');
      expect(todo.title, 'Test Todo');
      expect(todo.completed, false);
    });

    test('copyWith should create a new instance with updated values', () {
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
        completed: false,
      );

      final updatedTodo = todo.copyWith(
        completed: true,
        title: 'Updated Todo',
      );

      // Original todo should remain unchanged
      expect(todo.id, '1');
      expect(todo.title, 'Test Todo');
      expect(todo.completed, false);

      // New todo should have updated values
      expect(updatedTodo.id, '1'); // id wasn't changed
      expect(updatedTodo.title, 'Updated Todo');
      expect(updatedTodo.completed, true);
    });

    test('copyWith should keep original values when parameters are null', () {
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
        completed: false,
      );

      final updatedTodo = todo.copyWith();

      expect(updatedTodo.id, todo.id);
      expect(updatedTodo.title, todo.title);
      expect(updatedTodo.completed, todo.completed);
    });
  });
}