import '../models/sample_event.dart';
import '../models/sample_event_type.dart';
import 'sample_exceptions.dart';

class SampleTransitions {
  SampleTransitions._();

  static const minPreparedToAnalysis = Duration(minutes: 10);

  static SampleEvent? latest(List<SampleEvent> history) {
    if (history.isEmpty) return null;
    return ([...history]..sort(SampleEvent.compareByDate)).last;
  }

  static SampleEventType? currentStatus(List<SampleEvent> history) =>
      latest(history)?.eventType;

  static SampleEventType? nextType(List<SampleEvent> history) {
    if (history.isEmpty) return SampleEventType.received;
    return currentStatus(history)?.next;
  }

  static Duration? remainingForAnalysis(
    List<SampleEvent> history,
    DateTime now,
  ) {
    final last = latest(history);
    if (last == null || last.eventType != SampleEventType.prepared) {
      return null;
    }
    final remaining = minPreparedToAnalysis - now.difference(last.createdAt);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  static void validate(
    List<SampleEvent> history,
    SampleEventType requested,
    DateTime now,
  ) {
    final expected = nextType(history);
    if (expected == null) {
      throw const InvalidTransitionException(
        'La muestra ya está archivada y no admite más eventos.',
      );
    }
    if (requested != expected) {
      throw InvalidTransitionException(
        'Transición inválida: no se pueden saltar estados. '
        'El siguiente evento permitido es ${expected.label}.',
      );
    }
    if (requested == SampleEventType.inAnalysis) {
      final remaining = remainingForAnalysis(history, now) ?? Duration.zero;
      if (remaining > Duration.zero) {
        throw InvalidTransitionException(
          'Aún no se puede iniciar el análisis: deben pasar 10 minutos '
          'desde que la muestra fue preparada. '
          'Faltan aproximadamente ${formatRemaining(remaining)}.',
          remaining: remaining,
        );
      }
    }
  }

  static String formatRemaining(Duration remaining) {
    final totalSeconds = (remaining.inMilliseconds / 1000).ceil();
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    if (minutes == 0) return '$seconds s';
    if (seconds == 0) return '$minutes min';
    return '$minutes min $seconds s';
  }
}
