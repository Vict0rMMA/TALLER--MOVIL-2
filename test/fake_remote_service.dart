import 'package:sample_track_shell/models/sample_event.dart';
import 'package:sample_track_shell/services/sample_event_remote_service.dart';

class FakeRemoteService implements SampleEventRemoteService {
  final List<SampleEvent> stored = [];
  bool failing = false;

  void _check() {
    if (failing) throw Exception('Firestore no disponible');
  }

  @override
  Future<List<SampleEvent>> getEvents() async {
    _check();
    return [...stored]..sort(SampleEvent.compareByDate);
  }

  @override
  Future<List<SampleEvent>> getEventsForSample(String sampleId) async {
    _check();
    return stored.where((e) => e.sampleId == sampleId).toList()
      ..sort(SampleEvent.compareByDate);
  }

  @override
  Future<void> saveEvent(SampleEvent event) async {
    _check();
    stored.add(event);
  }
}
