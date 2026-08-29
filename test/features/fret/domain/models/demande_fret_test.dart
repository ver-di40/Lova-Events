import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:lova_events/features/fret/domain/enums/fret_enums.dart';
import 'package:lova_events/features/fret/domain/models/demande_fret.dart';

void main() {
  test('round-trip DemandeFret JSON for randomized values', () {
    const sampleCount = 100;
    final random = Random(20260829);

    for (var i = 0; i < sampleCount; i++) {
      final dateDepart = DateTime(
        2026,
        1,
        1,
        8,
        0,
      ).add(
        Duration(
          days: random.nextInt(180),
          hours: random.nextInt(24),
          minutes: random.nextInt(60),
        ),
      );

      final dateRetour = random.nextBool()
          ? dateDepart.add(
              Duration(
                days: random.nextInt(7) + 1,
                hours: random.nextInt(12),
              ),
            )
          : null;

      final demande = DemandeFret(
        id: 'demande-$i',
        idPrestataire: 'prestataire-$i',
        adresseDepart: 'Adresse départ $i ${random.nextInt(9999)}',
        adresseArrivee: 'Adresse arrivée $i ${random.nextInt(9999)}',
        dateHeureSouhaiteeDepart: dateDepart,
        dateHeureRetourPrevue: dateRetour,
        typeVehiculeRequis: TypeVehicule.values[random.nextInt(TypeVehicule.values.length)],
        poidsTotalEstimeKg: _randomDouble(random, 0, 5000),
        volumeTotalEstimeM3: _randomDouble(random, 0, 150),
        fragile: random.nextBool(),
        necessiteFrigo: random.nextBool(),
        necessiteManutention: random.nextBool(),
        nbManutentionnairesRequis: random.nextInt(6),
        descriptionComplementaire: random.nextBool()
            ? 'Description $i ${random.nextInt(1000)}'
            : null,
        statut: StatutDemande.values[random.nextInt(StatutDemande.values.length)],
        dateCreation: dateDepart.add(const Duration(days: -1)),
      );

      final json = demande.toJson();
      final roundTrip = DemandeFret.fromJson(json);

      expect(roundTrip, equals(demande));
    }
  });
}

double _randomDouble(Random random, double min, double max) {
  return min + random.nextDouble() * (max - min);
}
