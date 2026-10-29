import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_track_shell/database/app_database.dart';
import 'package:sample_track_shell/database/sample_event_local_data_source.dart';
import 'package:sample_track_shell/domain/sample_exceptions.dart';
import 'package:sample_track_shell/models/sample_event.dart';
import 'package:sample_track_shell/models/sample_event_type.dart';
import 'package:sample_track_shell/repositories/sample_event_repository.dart';

import 'fake_remote_service.dart';

void main() {
  late AppDatabase db;
  late SampleEventLocalDataSource local;
  late FakeRemoteService remote;
  late SampleEventRepository repository;
  late DateTime now;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    local = SampleEventLocalDataSource(db);
    remote = FakeRemoteService();
    now = DateTime(2026, 10, 28, 10);
    repository = SampleEventRepository(
      local: local,
      remote: remote,
      clock: () => now,
    );
  });

  tearDown(() => db.close());

  test('registra en Firestore y en Drift sin reemplazar eventos', () async {
    await repository.registerEvent('M-1001', SampleEventType.received);
    now = now.add(const Duration(minutes: 1));
    await repository.registerEvent('M-1001', SampleEventType.prepared);

    expect(remote.stored, hasLength(2));
    final saved = await local.getEventsForSample('M-1001');
    expect(saved.map((e) => e.type), ['RECEIVED', 'PREPARED']);
  });

  test('solo devuelve los eventos de la muestra consultada', () async {
    await repository.registerEvent('M-1001', SampleEventType.received);
    await repository.registerEvent('M-1002', SampleEventType.received);

    final result = await repository.getEventsForSample('M-1002');
    expect(result.events.map((e) => e.sampleId), ['M-1002']);
  });

  test('la lectura remota actualiza la cache local', () async {
    await repository.registerEvent('M-1003', SampleEventType.received);
    remote.stored.add(SampleEvent(
      id: 'M-1003-remoto',
      sampleId: 'M-1003',
      type: 'PREPARED',
      createdAt: now.add(const Duration(minutes: 1)),
    ));

    final result = await repository.getEventsForSample('M-1003');
    expect(result.fromLocal, isFalse);
    expect(await local.getEventsForSample('M-1003'), hasLength(2));
  });

  test('si Firestore falla usa el ultimo historial de Drift', () async {
    await repository.registerEvent('M-1001', SampleEventType.received);
    remote.failing = true;

    final result = await repository.getEventsForSample('M-1001');
    expect(result.fromLocal, isTrue);
    expect(result.events.single.type, 'RECEIVED');
  });

  test('si la escritura remota falla no se confirma ni se guarda', () async {
    remote.failing = true;
    await expectLater(
      repository.registerEvent('M-1001', SampleEventType.received),
      throwsA(isA<RemoteWriteException>()),
    );
    expect(await local.getEventsForSample('M-1001'), isEmpty);
  });

  test('una transicion invalida no llega a persistirse', () async {
    await expectLater(
      repository.registerEvent('M-1001', SampleEventType.validated),
      throwsA(isA<InvalidTransitionException>()),
    );
    expect(remote.stored, isEmpty);
  });

  test('variante B: IN_ANALYSIS antes de 10 minutos se rechaza', () async {
    await repository.registerEvent('M-1001', SampleEventType.received);
    now = now.add(const Duration(minutes: 1));
    await repository.registerEvent('M-1001', SampleEventType.prepared);

    now = now.add(const Duration(minutes: 4));
    await expectLater(
      repository.registerEvent('M-1001', SampleEventType.inAnalysis),
      throwsA(isA<InvalidTransitionException>()),
    );

    now = now.add(const Duration(minutes: 6));
    await repository.registerEvent('M-1001', SampleEventType.inAnalysis);
    expect(remote.stored.last.type, 'IN_ANALYSIS');
  });
}
