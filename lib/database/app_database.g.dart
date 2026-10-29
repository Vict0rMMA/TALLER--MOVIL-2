// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SampleEventsTable extends SampleEvents
    with TableInfo<$SampleEventsTable, SampleEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SampleEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sampleIdMeta =
      const VerificationMeta('sampleId');
  @override
  late final GeneratedColumn<String> sampleId = GeneratedColumn<String>(
      'sample_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, sampleId, type, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sample_events';
  @override
  VerificationContext validateIntegrity(Insertable<SampleEventRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sample_id')) {
      context.handle(_sampleIdMeta,
          sampleId.isAcceptableOrUnknown(data['sample_id']!, _sampleIdMeta));
    } else if (isInserting) {
      context.missing(_sampleIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SampleEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SampleEventRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sampleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sample_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SampleEventsTable createAlias(String alias) {
    return $SampleEventsTable(attachedDatabase, alias);
  }
}

class SampleEventRow extends DataClass implements Insertable<SampleEventRow> {
  final String id;
  final String sampleId;
  final String type;
  final DateTime createdAt;
  const SampleEventRow(
      {required this.id,
      required this.sampleId,
      required this.type,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sample_id'] = Variable<String>(sampleId);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SampleEventsCompanion toCompanion(bool nullToAbsent) {
    return SampleEventsCompanion(
      id: Value(id),
      sampleId: Value(sampleId),
      type: Value(type),
      createdAt: Value(createdAt),
    );
  }

  factory SampleEventRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SampleEventRow(
      id: serializer.fromJson<String>(json['id']),
      sampleId: serializer.fromJson<String>(json['sampleId']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sampleId': serializer.toJson<String>(sampleId),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SampleEventRow copyWith(
          {String? id, String? sampleId, String? type, DateTime? createdAt}) =>
      SampleEventRow(
        id: id ?? this.id,
        sampleId: sampleId ?? this.sampleId,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
      );
  SampleEventRow copyWithCompanion(SampleEventsCompanion data) {
    return SampleEventRow(
      id: data.id.present ? data.id.value : this.id,
      sampleId: data.sampleId.present ? data.sampleId.value : this.sampleId,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SampleEventRow(')
          ..write('id: $id, ')
          ..write('sampleId: $sampleId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sampleId, type, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SampleEventRow &&
          other.id == this.id &&
          other.sampleId == this.sampleId &&
          other.type == this.type &&
          other.createdAt == this.createdAt);
}

class SampleEventsCompanion extends UpdateCompanion<SampleEventRow> {
  final Value<String> id;
  final Value<String> sampleId;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SampleEventsCompanion({
    this.id = const Value.absent(),
    this.sampleId = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SampleEventsCompanion.insert({
    required String id,
    required String sampleId,
    required String type,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sampleId = Value(sampleId),
        type = Value(type),
        createdAt = Value(createdAt);
  static Insertable<SampleEventRow> custom({
    Expression<String>? id,
    Expression<String>? sampleId,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sampleId != null) 'sample_id': sampleId,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SampleEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? sampleId,
      Value<String>? type,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SampleEventsCompanion(
      id: id ?? this.id,
      sampleId: sampleId ?? this.sampleId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sampleId.present) {
      map['sample_id'] = Variable<String>(sampleId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SampleEventsCompanion(')
          ..write('id: $id, ')
          ..write('sampleId: $sampleId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SampleEventsTable sampleEvents = $SampleEventsTable(this);
  late final Index idxSampleEventsSampleId = Index(
      'idx_sample_events_sample_id',
      'CREATE INDEX idx_sample_events_sample_id ON sample_events (sample_id)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [sampleEvents, idxSampleEventsSampleId];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$SampleEventsTableCreateCompanionBuilder = SampleEventsCompanion
    Function({
  required String id,
  required String sampleId,
  required String type,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$SampleEventsTableUpdateCompanionBuilder = SampleEventsCompanion
    Function({
  Value<String> id,
  Value<String> sampleId,
  Value<String> type,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SampleEventsTableFilterComposer
    extends Composer<_$AppDatabase, $SampleEventsTable> {
  $$SampleEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sampleId => $composableBuilder(
      column: $table.sampleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SampleEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $SampleEventsTable> {
  $$SampleEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sampleId => $composableBuilder(
      column: $table.sampleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SampleEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SampleEventsTable> {
  $$SampleEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sampleId =>
      $composableBuilder(column: $table.sampleId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SampleEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SampleEventsTable,
    SampleEventRow,
    $$SampleEventsTableFilterComposer,
    $$SampleEventsTableOrderingComposer,
    $$SampleEventsTableAnnotationComposer,
    $$SampleEventsTableCreateCompanionBuilder,
    $$SampleEventsTableUpdateCompanionBuilder,
    (
      SampleEventRow,
      BaseReferences<_$AppDatabase, $SampleEventsTable, SampleEventRow>
    ),
    SampleEventRow,
    PrefetchHooks Function()> {
  $$SampleEventsTableTableManager(_$AppDatabase db, $SampleEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SampleEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SampleEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SampleEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sampleId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SampleEventsCompanion(
            id: id,
            sampleId: sampleId,
            type: type,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sampleId,
            required String type,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SampleEventsCompanion.insert(
            id: id,
            sampleId: sampleId,
            type: type,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SampleEventsTable, SampleEventRow>(table),
                    BaseReferences<_$AppDatabase, $SampleEventsTable,
                        SampleEventRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SampleEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SampleEventsTable,
    SampleEventRow,
    $$SampleEventsTableFilterComposer,
    $$SampleEventsTableOrderingComposer,
    $$SampleEventsTableAnnotationComposer,
    $$SampleEventsTableCreateCompanionBuilder,
    $$SampleEventsTableUpdateCompanionBuilder,
    (
      SampleEventRow,
      BaseReferences<_$AppDatabase, $SampleEventsTable, SampleEventRow>
    ),
    SampleEventRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SampleEventsTableTableManager get sampleEvents =>
      $$SampleEventsTableTableManager(_db, _db.sampleEvents);
}
