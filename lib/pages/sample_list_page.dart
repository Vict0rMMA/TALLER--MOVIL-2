import 'package:flutter/material.dart';

import '../data/sample_seed.dart';
import '../domain/sample_transitions.dart';
import '../models/sample.dart';
import '../models/sample_event.dart';
import '../models/sample_event_type.dart';
import '../repositories/sample_event_repository.dart';
import '../widgets/local_data_banner.dart';
import '../widgets/sample_card.dart';
import 'sample_detail_page.dart';

class SampleListPage extends StatefulWidget {
  const SampleListPage({super.key, required this.repository});

  final SampleEventRepository repository;

  @override
  State<SampleListPage> createState() => _SampleListPageState();
}

class _SampleListPageState extends State<SampleListPage> {
  Map<String, SampleEventType?> _statuses = {};
  bool _loading = true;
  bool _fromLocal = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final result = await widget.repository.getAllEvents();
      final bySample = <String, List<SampleEvent>>{};
      for (final event in result.events) {
        bySample.putIfAbsent(event.sampleId, () => []).add(event);
      }
      if (!mounted) return;
      setState(() {
        _statuses = {
          for (final sample in sampleSeed)
            sample.id: SampleTransitions.currentStatus(
              bySample[sample.id] ?? const [],
            ),
        };
        _fromLocal = result.fromLocal;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudieron cargar los estados: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openDetail(Sample sample) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SampleDetailPage(
          sample: sample,
          repository: widget.repository,
        ),
      ),
    );
    if (mounted) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SampleTrack'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_fromLocal && !_loading) LocalDataBanner(onRetry: _load),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _load,
                child: ListView.separated(
                  itemCount: sampleSeed.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final sample = sampleSeed[index];
                    return SampleCard(
                      sample: sample,
                      status: _statuses[sample.id],
                      loadingStatus: _loading,
                      onTap: () => _openDetail(sample),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
