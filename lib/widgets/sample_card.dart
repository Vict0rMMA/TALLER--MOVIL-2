import 'package:flutter/material.dart';

import '../models/sample.dart';
import '../models/sample_event_type.dart';

class SampleCard extends StatelessWidget {
  const SampleCard({
    super.key,
    required this.sample,
    required this.status,
    required this.onTap,
    this.loadingStatus = false,
  });

  final Sample sample;
  final SampleEventType? status;
  final bool loadingStatus;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(sample.id),
      subtitle: Text(
        '${sample.type} - ${sample.origin}\nPrioridad: ${sample.priority}',
      ),
      isThreeLine: true,
      trailing: Text(loadingStatus ? '...' : status?.label ?? 'Sin eventos'),
    );
  }
}
