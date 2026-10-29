enum SampleEventType {
  received('RECEIVED', 'Recibida'),
  prepared('PREPARED', 'Preparada'),
  inAnalysis('IN_ANALYSIS', 'En análisis'),
  validated('VALIDATED', 'Validada'),
  archived('ARCHIVED', 'Archivada');

  const SampleEventType(this.code, this.label);

  final String code;

  final String label;

  SampleEventType? get next =>
      index + 1 < values.length ? values[index + 1] : null;

  static SampleEventType? fromCode(String code) {
    for (final type in values) {
      if (type.code == code) return type;
    }
    return null;
  }
}
