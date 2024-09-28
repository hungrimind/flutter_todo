import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:todo/features/todo/todo.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

const _uuid = Uuid();

extension TodoItemX on TodoEntity {
  Todo toTodo() {
    return Todo(
      id: id,
      title: title,
      completed: completed,
    );
  }
}

class TodoEntities extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get title => text()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [
  TodoEntities,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'database');
  }
}
