import 'package:drift/drift.dart';

import '../models/sample_event.dart';
import 'app_database.dart';

class SampleEventLocalDataSource {
  SampleEventLocalDataSource(this.db);

  final AppDatabase db;

  SampleEvent _toDomain(SampleEventRow row) {
    return SampleEvent(
      id: row.id,
      sampleId: row.sampleId,
      type: row.type,
      createdAt: row.createdAt,
    );
  }

  SampleEventsCompanion _toCompanion(SampleEvent event) {
    return SampleEventsCompanion.insert(
      id: event.id,
      sampleId: event.sampleId,
      type: event.type,
      createdAt: event.createdAt,
    );
  }

  Future<List<SampleEvent>> getEventsForSample(String sampleId) async {
    final rows = await (db.select(db.sampleEvents)
          ..where((t) => t.sampleId.equals(sampleId))
          ..orderBy([
            (t) => OrderingTerm.asc(t.createdAt),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .get();
    return rows.map(_toDomain).toList();
  }

  Future<List<SampleEvent>> getAllEvents() async {
    final rows = await (db.select(db.sampleEvents)
          ..orderBy([
            (t) => OrderingTerm.asc(t.createdAt),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .get();
    return rows.map(_toDomain).toList();
  }

  Future<void> saveEvent(SampleEvent event) async {
    await db.into(db.sampleEvents).insertOnConflictUpdate(_toCompanion(event));
  }

  Future<void> saveEvents(List<SampleEvent> events) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.sampleEvents,
        events.map(_toCompanion).toList(),
      );
    });
  }
}
