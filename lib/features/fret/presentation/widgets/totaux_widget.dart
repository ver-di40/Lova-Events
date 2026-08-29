import 'package:flutter/material.dart';

class TotauxWidget extends StatelessWidget {
  const TotauxWidget({
    super.key,
    required this.poidsTotalKg,
    required this.volumeTotalM3,
  });

  final double poidsTotalKg;
  final double volumeTotalM3;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _TotalTile(
                label: 'Poids total',
                value: '${poidsTotalKg.toStringAsFixed(2)} kg',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TotalTile(
                label: 'Volume total',
                value: '${volumeTotalM3.toStringAsFixed(3)} m³',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalTile extends StatelessWidget {
  const _TotalTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
