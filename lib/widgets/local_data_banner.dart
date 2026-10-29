import 'package:flutter/material.dart';

class LocalDataBanner extends StatelessWidget {
  const LocalDataBanner({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.orange.shade100,
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          const Expanded(
            child: Text('Sin conexión, mostrando datos guardados'),
          ),
          TextButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
