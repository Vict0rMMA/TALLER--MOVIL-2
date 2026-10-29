import 'dart:async';

import 'package:flutter/material.dart';

import '../domain/sample_exceptions.dart';
import '../domain/sample_transitions.dart';
import '../models/sample.dart';
import '../models/sample_event.dart';
import '../models/sample_event_type.dart';
import '../repositories/sample_event_repository.dart';
import '../widgets/local_data_banner.dart';

class SampleDetailPage extends StatefulWidget {
  const SampleDetailPage({
    super.key,
    required this.sample,
    required this.repository,
  });

  final Sample sample;
  final SampleEventRepository repository;

  @override
  State<SampleDetailPage> createState() => _SampleDetailPageState();
}

class _SampleDetailPageState extends State<SampleDetailPage> {
  List<SampleEvent> _events = const [];
  bool _loading = true;
  bool _fromLocal = false;
  bool _saving = false;
  DateTime _now = DateTime.now();
  Timer? _ticker;

  SampleEventType? get _status => SampleTransitions.currentStatus(_events);
  SampleEventType? get _next => SampleTransitions.nextType(_events);

  @override
  void initState() {
    super.initState();
    _load();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_status == SampleEventType.prepared) {
        setState(() => _now = DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final result =
          await widget.repository.getEventsForSample(widget.sample.id);
      if (!mounted) return;
      setState(() {
        _events = result.events;
        _fromLocal = result.fromLocal;
        _now = DateTime.now();
      });
    } catch (e) {
      _showMessage('No se pudo cargar el historial: $e', isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _register(SampleEventType type) async {
    setState(() => _saving = true);
    try {
      await widget.repository.registerEvent(widget.sample.id, type);
      _showMessage('Evento ${type.label} registrado.');
      await _load();
    } on InvalidTransitionException catch (e) {
      _showMessage(e.message, isError: true);
    } on RemoteWriteException catch (e) {
      _showMessage(e.message, isError: true);
    } catch (e) {
      _showMessage('Error inesperado: $e', isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickOtherEvent() async {
    final selected = await showDialog<SampleEventType>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Registrar evento'),
        children: [
          for (final type in SampleEventType.values)
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(type),
              child: Text(type.label),
            ),
        ],
      ),
    );
    if (selected != null) await _register(selected);
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    final colors = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? colors.error : null,
          duration: const Duration(seconds: 5),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final next = _next;
    final remaining = SampleTransitions.remainingForAnalysis(_events, _now);
    final sample = widget.sample;

    return Scaffold(
      appBar: AppBar(title: Text(sample.id)),
      body: Column(
        children: [
          if (_fromLocal && !_loading) LocalDataBanner(onRetry: _load),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('Tipo: ${sample.type}'),
                  Text('Origen: ${sample.origin}'),
                  Text('Prioridad: ${sample.priority}'),
                  const SizedBox(height: 8),
                  Text(
                    'Estado: ${_loading ? '...' : _status?.label ?? 'Sin eventos'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Historial',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (_loading && _events.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_events.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Esta muestra no tiene eventos.'),
                    )
                  else
                    for (final event in _events)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(event.eventType?.label ?? event.type),
                        subtitle: Text(_formatDate(event.createdAt)),
                      ),
                  const SizedBox(height: 16),
                  if (remaining != null && remaining > Duration.zero)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Faltan ${SampleTransitions.formatRemaining(remaining)} '
                        'para poder iniciar el análisis.',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (next == null)
                    const Text('La muestra está archivada.')
                  else
                    ElevatedButton(
                      onPressed:
                          _saving || _loading ? null : () => _register(next),
                      child: Text(
                        _saving ? 'Guardando...' : 'Registrar ${next.label}',
                      ),
                    ),
                  TextButton(
                    onPressed: _saving || _loading ? null : _pickOtherEvent,
                    child: const Text('Registrar otro evento'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _two(int value) => value.toString().padLeft(2, '0');

String _formatDate(DateTime date) {
  final d = date.toLocal();
  return '${_two(d.day)}/${_two(d.month)}/${d.year} '
      '${_two(d.hour)}:${_two(d.minute)}';
}
