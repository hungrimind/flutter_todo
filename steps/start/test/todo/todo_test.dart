import 'package:demo/todo/todo.dart';
import 'package:flutter_test/flutter_test.dart';

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
  });
}
