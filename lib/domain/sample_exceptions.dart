class InvalidTransitionException implements Exception {
  const InvalidTransitionException(this.message, {this.remaining});

  final String message;

  final Duration? remaining;

  @override
  String toString() => message;
}

class RemoteWriteException implements Exception {
  const RemoteWriteException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}
