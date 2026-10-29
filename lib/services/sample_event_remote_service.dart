import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/sample_event.dart';

class SampleEventRemoteService {
  SampleEventRemoteService(this._firestore);

  static const collectionName = 'sample_events';

  static const _timeout = Duration(seconds: 15);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionName);

  Future<List<SampleEvent>> getEvents() async {
    final snapshot = await _collection
        .get(const GetOptions(source: Source.server))
        .timeout(_timeout);
    return _toEvents(snapshot);
  }

  Future<List<SampleEvent>> getEventsForSample(String sampleId) async {
    final snapshot = await _collection
        .where('sampleId', isEqualTo: sampleId)
        .get(const GetOptions(source: Source.server))
        .timeout(_timeout);
    return _toEvents(snapshot);
  }

  Future<void> saveEvent(SampleEvent event) {
    return _collection.doc(event.id).set({
      'id': event.id,
      'sampleId': event.sampleId,
      'type': event.type,
      'createdAt': Timestamp.fromDate(event.createdAt),
    }).timeout(_timeout);
  }

  static List<SampleEvent> _toEvents(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    final events = <SampleEvent>[];
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final sampleId = data['sampleId'];
      final type = data['type'];
      final createdAt = data['createdAt'];
      if (sampleId is! String || type is! String || createdAt is! Timestamp) {
        continue;
      }
      events.add(SampleEvent(
        id: data['id'] as String? ?? doc.id,
        sampleId: sampleId,
        type: type,
        createdAt: createdAt.toDate(),
      ));
    }
    return events..sort(SampleEvent.compareByDate);
  }
}
