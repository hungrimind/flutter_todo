import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo/date_service.dart';
import 'package:flutter_todo/todo/todo_page_view_model.dart';

class FakeDateService extends Fake implements DateService {
  @override
  ValueNotifier<DateTime> dateNotifier = ValueNotifier(DateTime(2024, 12, 1));

  @override
  void resetDate() {
    dateNotifier.value = DateTime(2022, 3, 17);
  }
}

void main() {
  group(TodoPageViewModel, () {
    late TodoPageViewModel viewModel;
    late DateService dateService;
    const todoTitle = 'Test Todo';

    setUp(() {
      dateService = FakeDateService();
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

    test('should update the date when the date service updates', () {
      expect(viewModel.dateNotifier.value, DateTime(2024, 12, 1));

      dateService.resetDate();

      expect(viewModel.dateNotifier.value, DateTime(2022, 3, 17));
    });
  });
}
