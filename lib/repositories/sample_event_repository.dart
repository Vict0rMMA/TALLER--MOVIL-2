import 'package:flutter/foundation.dart';

import '../database/sample_event_local_data_source.dart';
import '../domain/sample_exceptions.dart';
import '../domain/sample_transitions.dart';
import '../models/sample_event.dart';
import '../models/sample_event_type.dart';
import '../services/sample_event_remote_service.dart';

class EventsResult {
  const EventsResult({required this.events, required this.fromLocal});

  final List<SampleEvent> events;

  final bool fromLocal;
}

class SampleEventRepository {
  SampleEventRepository({
    required this.local,
    required this.remote,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final SampleEventLocalDataSource local;
  final SampleEventRemoteService remote;
  final DateTime Function() _clock;

  Future<EventsResult> getEventsForSample(String sampleId) {
    return _remoteFirst(
      () => remote.getEventsForSample(sampleId),
      () => local.getEventsForSample(sampleId),
    );
  }

  Future<EventsResult> getAllEvents() {
    return _remoteFirst(remote.getEvents, local.getAllEvents);
  }

  Future<SampleEvent> registerEvent(
    String sampleId,
    SampleEventType type,
  ) async {
    final history = await getEventsForSample(sampleId);
    final now = _clock();
    SampleTransitions.validate(history.events, type, now);

    final event = SampleEvent(
      id: '$sampleId-${now.microsecondsSinceEpoch}',
      sampleId: sampleId,
      type: type.code,
      createdAt: now,
    );

    try {
      await remote.saveEvent(event);
    } catch (e) {
      debugPrint('Error guardando evento en Firestore: $e');
      throw RemoteWriteException(
        'No se pudo guardar el evento en Firestore. '
        'El evento no fue registrado; verifique la conexión e intente de nuevo.',
        e,
      );
    }

    await local.saveEvent(event);
    return event;
  }

  Future<EventsResult> _remoteFirst(
    Future<List<SampleEvent>> Function() readRemote,
    Future<List<SampleEvent>> Function() readLocal,
  ) async {
    final List<SampleEvent> remoteEvents;
    try {
      remoteEvents = await readRemote();
    } catch (e) {
      debugPrint('Firestore no disponible, usando cache local: $e');
      return EventsResult(events: await readLocal(), fromLocal: true);
    }

    await local.saveEvents(remoteEvents);
    return EventsResult(events: remoteEvents, fromLocal: false);
  }
}
