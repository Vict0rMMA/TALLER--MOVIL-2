import 'sample_event_type.dart';

class SampleEvent {
  const SampleEvent({
    required this.id,
    required this.sampleId,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String sampleId;
  final String type;
  final DateTime createdAt;

  SampleEventType? get eventType => SampleEventType.fromCode(type);

  static int compareByDate(SampleEvent a, SampleEvent b) {
    final byDate = a.createdAt.compareTo(b.createdAt);
    return byDate != 0 ? byDate : a.id.compareTo(b.id);
  }
}
