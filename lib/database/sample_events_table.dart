import 'package:drift/drift.dart';

@DataClassName('SampleEventRow')
@TableIndex(name: 'idx_sample_events_sample_id', columns: {#sampleId})
class SampleEvents extends Table {
  TextColumn get id => text()();
  TextColumn get sampleId => text()();
  TextColumn get type => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
