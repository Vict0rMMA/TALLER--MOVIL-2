import 'package:flutter_test/flutter_test.dart';
import 'package:sample_track_shell/domain/sample_exceptions.dart';
import 'package:sample_track_shell/domain/sample_transitions.dart';
import 'package:sample_track_shell/models/sample_event.dart';
import 'package:sample_track_shell/models/sample_event_type.dart';

SampleEvent _event(SampleEventType type, DateTime at) => SampleEvent(
      id: 'M-1001-${type.code}',
      sampleId: 'M-1001',
      type: type.code,
      createdAt: at,
    );

void main() {
  final t0 = DateTime(2026, 10, 28, 10);

  test('sin eventos: estado null y siguiente RECEIVED', () {
    expect(SampleTransitions.currentStatus(const []), isNull);
    expect(SampleTransitions.nextType(const []), SampleEventType.received);
  });

  test('el estado actual es el evento mas reciente', () {
    final history = [
      _event(SampleEventType.prepared, t0.add(const Duration(minutes: 5))),
      _event(SampleEventType.received, t0),
    ];
    expect(SampleTransitions.currentStatus(history), SampleEventType.prepared);
  });

  test('no se permite saltar estados', () {
    final history = [_event(SampleEventType.received, t0)];
    expect(
      () => SampleTransitions.validate(
        history,
        SampleEventType.inAnalysis,
        t0.add(const Duration(hours: 1)),
      ),
      throwsA(isA<InvalidTransitionException>()),
    );
  });

  test('una muestra archivada no admite mas eventos', () {
    final history = [
      for (final (i, type) in SampleEventType.values.indexed)
        _event(type, t0.add(Duration(minutes: 20 * i))),
    ];
    expect(SampleTransitions.nextType(history), isNull);
    expect(
      () => SampleTransitions.validate(
        history,
        SampleEventType.received,
        t0.add(const Duration(hours: 5)),
      ),
      throwsA(isA<InvalidTransitionException>()),
    );
  });

  group('variante B: 10 minutos entre PREPARED e IN_ANALYSIS', () {
    final preparedAt = t0.add(const Duration(minutes: 1));
    final history = [
      _event(SampleEventType.received, t0),
      _event(SampleEventType.prepared, preparedAt),
    ];

    test('antes de 10 minutos se rechaza e indica cuanto falta', () {
      final now = preparedAt.add(const Duration(minutes: 3));
      try {
        SampleTransitions.validate(history, SampleEventType.inAnalysis, now);
        fail('Debio rechazarse');
      } on InvalidTransitionException catch (e) {
        expect(e.remaining, const Duration(minutes: 7));
        expect(e.message, contains('7 min'));
      }
    });

    test('a los 10 minutos exactos se permite', () {
      final now = preparedAt.add(const Duration(minutes: 10));
      expect(
        SampleTransitions.remainingForAnalysis(history, now),
        Duration.zero,
      );
      SampleTransitions.validate(history, SampleEventType.inAnalysis, now);
    });

    test('la restriccion no aplica a otras transiciones', () {
      final received = [_event(SampleEventType.received, t0)];
      SampleTransitions.validate(
        received,
        SampleEventType.prepared,
        t0.add(const Duration(seconds: 1)),
      );
      expect(SampleTransitions.remainingForAnalysis(received, t0), isNull);
    });
  });

  test('formatRemaining redondea hacia arriba', () {
    expect(
      SampleTransitions.formatRemaining(
          const Duration(seconds: 89, milliseconds: 1)),
      '1 min 30 s',
    );
    expect(
        SampleTransitions.formatRemaining(const Duration(seconds: 45)), '45 s');
    expect(SampleTransitions.formatRemaining(const Duration(minutes: 10)),
        '10 min');
  });
}
