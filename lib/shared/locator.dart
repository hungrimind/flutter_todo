import 'package:get_it/get_it.dart';
import 'package:todo/features/todo/todo_local_data_source.dart';
import 'package:todo/features/todo/todo_repository.dart';
import 'package:todo/shared/database/database.dart';
import 'package:todo/shared/date_service.dart';

final locator = GetIt.instance;

void setupLocators() {
  locator.registerLazySingleton<DateService>(() => DateService());
  locator.registerLazySingleton<AppDatabase>(() => AppDatabase());

  locator.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSource(
      database: locator<AppDatabase>(),
    ),
  );

  locator.registerLazySingleton<TodoRepository>(
    () => TodoRepository(
      todoLocalDataSource: locator<TodoLocalDataSource>(),
    ),
  );
}
