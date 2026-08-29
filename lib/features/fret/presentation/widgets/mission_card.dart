import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/enums/fret_enums.dart';
import '../../domain/models/demande_fret.dart';

class MissionCard extends StatelessWidget {
  const MissionCard({
    super.key,
    required this.demande,
  });

  final DemandeFret demande;

  Color _statusColor(StatutDemande statut) {
    switch (statut) {
      case StatutDemande.brouillon:
        return Colors.blue.shade700;
      case StatutDemande.publiee:
        return Colors.green.shade700;
      case StatutDemande.matchee:
        return Colors.orange.shade700;
      case StatutDemande.annulee:
        return Colors.red.shade700;
      case StatutDemande.terminee:
        return Colors.grey.shade700;
    }
  }

  String _statusLabel(StatutDemande statut) {
    switch (statut) {
      case StatutDemande.brouillon:
        return 'Brouillon';
      case StatutDemande.publiee:
        return 'Publiée';
      case StatutDemande.matchee:
        return 'Matchée';
      case StatutDemande.annulee:
        return 'Annulée';
      case StatutDemande.terminee:
        return 'Terminée';
    }
  }

  String _vehicleLabel(TypeVehicule type) {
    switch (type) {
      case TypeVehicule.fourgon:
        return 'Fourgon';
      case TypeVehicule.camionPlateau:
        return 'Camion plateau';
      case TypeVehicule.camionFrigo:
        return 'Camion frigo';
      case TypeVehicule.camionBenne:
        return 'Camion benne';
      case TypeVehicule.indifferent:
        return 'Indifférent';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(demande.statut);

    return InkWell(
      onTap: () {
        final route = demande.statut == StatutDemande.brouillon
            ? '/fret/${demande.id}/edit'
            : '/fret/${demande.id}';
        context.go(route);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${demande.adresseDepart} → ${demande.adresseArrivee}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _statusLabel(demande.statut),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${demande.dateHeureSouhaiteeDepart.day}/${demande.dateHeureSouhaiteeDepart.month}/${demande.dateHeureSouhaiteeDepart.year} • ${demande.dateHeureSouhaiteeDepart.hour.toString().padLeft(2, '0')}:${demande.dateHeureSouhaiteeDepart.minute.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.local_shipping_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(_vehicleLabel(demande.typeVehiculeRequis)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
