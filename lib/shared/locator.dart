import 'package:get_it/get_it.dart';
import 'package:todo/database.dart';
import 'package:todo/features/todo/todo_repository.dart';
import 'package:todo/shared/date_service.dart';

final locator = GetIt.instance;

void setupLocators() {
  locator.registerLazySingleton<DateService>(() => DateService());

  locator.registerLazySingleton<TodoRepository>(
    () => TodoRepository(
      inMemoryDataSource: InMemoryDataSource(),
    ),
  );
}
