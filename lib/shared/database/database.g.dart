// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TodoEntitiesTable extends TodoEntities
    with TableInfo<$TodoEntitiesTable, TodoEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoEntitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, title, completed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_entities';
  @override
  VerificationContext validateIntegrity(Insertable<TodoEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  TodoEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
    );
  }

  @override
  $TodoEntitiesTable createAlias(String alias) {
    return $TodoEntitiesTable(attachedDatabase, alias);
  }
}

class TodoEntity extends DataClass implements Insertable<TodoEntity> {
  final String id;
  final String title;
  final bool completed;
  const TodoEntity(
      {required this.id, required this.title, required this.completed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  TodoEntitiesCompanion toCompanion(bool nullToAbsent) {
    return TodoEntitiesCompanion(
      id: Value(id),
      title: Value(title),
      completed: Value(completed),
    );
  }

  factory TodoEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoEntity(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  TodoEntity copyWith({String? id, String? title, bool? completed}) =>
      TodoEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        completed: completed ?? this.completed,
      );
  TodoEntity copyWithCompanion(TodoEntitiesCompanion data) {
    return TodoEntity(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoEntity(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, completed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoEntity &&
          other.id == this.id &&
          other.title == this.title &&
          other.completed == this.completed);
}

class TodoEntitiesCompanion extends UpdateCompanion<TodoEntity> {
  final Value<String> id;
  final Value<String> title;
  final Value<bool> completed;
  final Value<int> rowid;
  const TodoEntitiesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.completed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodoEntitiesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.completed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : title = Value(title);
  static Insertable<TodoEntity> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<bool>? completed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (completed != null) 'completed': completed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodoEntitiesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<bool>? completed,
      Value<int>? rowid}) {
    return TodoEntitiesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoEntitiesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('completed: $completed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TodoEntitiesTable todoEntities = $TodoEntitiesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [todoEntities];
}

typedef $$TodoEntitiesTableCreateCompanionBuilder = TodoEntitiesCompanion
    Function({
  Value<String> id,
  required String title,
  Value<bool> completed,
  Value<int> rowid,
});
typedef $$TodoEntitiesTableUpdateCompanionBuilder = TodoEntitiesCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<bool> completed,
  Value<int> rowid,
});

class $$TodoEntitiesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TodoEntitiesTable> {
  $$TodoEntitiesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get completed => $state.composableBuilder(
      column: $state.table.completed,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$TodoEntitiesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TodoEntitiesTable> {
  $$TodoEntitiesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get completed => $state.composableBuilder(
      column: $state.table.completed,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$TodoEntitiesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TodoEntitiesTable,
    TodoEntity,
    $$TodoEntitiesTableFilterComposer,
    $$TodoEntitiesTableOrderingComposer,
    $$TodoEntitiesTableCreateCompanionBuilder,
    $$TodoEntitiesTableUpdateCompanionBuilder,
    (TodoEntity, BaseReferences<_$AppDatabase, $TodoEntitiesTable, TodoEntity>),
    TodoEntity,
    PrefetchHooks Function()> {
  $$TodoEntitiesTableTableManager(_$AppDatabase db, $TodoEntitiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TodoEntitiesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TodoEntitiesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TodoEntitiesCompanion(
            id: id,
            title: title,
            completed: completed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String title,
            Value<bool> completed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TodoEntitiesCompanion.insert(
            id: id,
            title: title,
            completed: completed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TodoEntitiesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TodoEntitiesTable,
    TodoEntity,
    $$TodoEntitiesTableFilterComposer,
    $$TodoEntitiesTableOrderingComposer,
    $$TodoEntitiesTableCreateCompanionBuilder,
    $$TodoEntitiesTableUpdateCompanionBuilder,
    (TodoEntity, BaseReferences<_$AppDatabase, $TodoEntitiesTable, TodoEntity>),
    TodoEntity,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TodoEntitiesTableTableManager get todoEntities =>
      $$TodoEntitiesTableTableManager(_db, _db.todoEntities);
}
