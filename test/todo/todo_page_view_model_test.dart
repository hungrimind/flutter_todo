import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo/date_service.dart';
import 'package:flutter_todo/todo/todo_page_view_model.dart';

void main() {
  group(TodoPageViewModel, () {
    late TodoPageViewModel viewModel;
    late DateService dateService;

    const todoTitle = 'Test Todo';

    setUp(() {
      dateService = DateService();
      viewModel = TodoPageViewModel(dateService: dateService);
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

    test('should be able to toggle the visibility of completed todos', () {
      final initialShowCompleted = viewModel.showCompletedTodosNotifier.value;

      viewModel.toggleShowCompletedTodos();
      expect(viewModel.showCompletedTodosNotifier.value, !initialShowCompleted);

      viewModel.toggleShowCompletedTodos();
      expect(viewModel.showCompletedTodosNotifier.value, initialShowCompleted);
    });
  });
}
