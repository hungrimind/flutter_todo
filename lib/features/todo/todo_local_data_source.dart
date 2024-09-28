import 'package:todo/shared/database/database.dart';

// The implementation for handling the specific approach of the datasource
class TodoLocalDataSource {
  TodoLocalDataSource({required AppDatabase database}) : _database = database;
  final AppDatabase _database;

  Stream<List<TodoEntity>> listenAll() {
    final query = _database.select(_database.todoEntities);

    return query.watch();
  }

  Future<void> add(String text) async {
    final insert = TodoEntitiesCompanion.insert(
      title: text,
    );
    await _database.into(_database.todoEntities).insert(insert);
  }

  Future<void> remove(TodoEntity todo) async {
    final query = _database.delete(_database.todoEntities)
      ..where((tbl) => tbl.id.equals(todo.id));
    await query.go();
  }

  Future<void> update(TodoEntity todo) async {
    final query = _database.update(_database.todoEntities)
      ..where((tbl) => tbl.id.equals(todo.id));

    await query.write(todo);
  }
}
