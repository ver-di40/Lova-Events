import 'package:flutter/material.dart';

import '../../domain/enums/fret_enums.dart';

class VehicleSelectionGrid extends StatelessWidget {
  const VehicleSelectionGrid({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.necessiteFrigo,
  });

  final TypeVehicule selected;
  final ValueChanged<TypeVehicule> onSelected;
  final bool necessiteFrigo;

  @override
  Widget build(BuildContext context) {
    final vehicles = TypeVehicule.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vehicles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];
            final isSelected = vehicle == selected;

            return ChoiceChip(
              label: Text(_label(vehicle)),
              selected: isSelected,
              onSelected: (_) => onSelected(vehicle),
              showCheckmark: false,
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
            );
          },
        ),
        if (necessiteFrigo && selected != TypeVehicule.camionFrigo) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Le froid requis impose un camion frigorifique.'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _label(TypeVehicule vehicle) {
    switch (vehicle) {
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
}
