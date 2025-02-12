import 'package:demo/todo/todo_page_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(TodoPageViewModel, () {
    late TodoPageViewModel viewModel;
    const todoTitle = 'Test Todo';

    setUp(() {
      viewModel = TodoPageViewModel();
    });

    test('should persist a newly added todo', () {
      viewModel.add(todoTitle);

      expect(viewModel.todosNotifier.value.length, 1);
      expect(viewModel.todosNotifier.value.first.title, todoTitle);
      expect(viewModel.todosNotifier.value.first.completed, false);
    });

    test('should be able to remove a specified todo', () {
      viewModel.add(todoTitle);

      final todo = viewModel.todosNotifier.value.first;

      viewModel.remove(todo);

      expect(viewModel.todosNotifier.value.isEmpty, true);
    });

    test('should be able to toggle the completed status of a specified Todo',
        () {
      viewModel.add(todoTitle);

      final todo = viewModel.todosNotifier.value.first;

      viewModel.toggleDone(todo);
      expect(viewModel.todosNotifier.value.first.completed, true);

      viewModel.toggleDone(todo);
      expect(viewModel.todosNotifier.value.first.completed, false);
    });
  });
}
