import 'package:get_it/get_it.dart';
import 'package:todo/date_service.dart';

final locator = GetIt.instance;

void setupLocators() {
  locator.registerLazySingleton<DateService>(() => DateService());
}