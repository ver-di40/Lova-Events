import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lova_events/features/fret/application/providers/fret_providers.dart';
import 'package:lova_events/features/fret/domain/enums/fret_enums.dart';
import 'package:lova_events/features/fret/domain/models/demande_fret.dart';
import 'package:lova_events/features/fret/presentation/screens/dashboard_fret_screen.dart';

void main() {
  testWidgets('dashboard shows KYC banner and empty state CTA', (tester) async {
    final container = ProviderContainer(
      overrides: [
        demandesListProvider.overrideWith((ref) async => const <DemandeFret>[]),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: DashboardFretScreen()),
      ),
    );

    await tester.pump();

    expect(find.text("Votre identité n'est pas encore vérifiée"), findsOneWidget);
    expect(find.text('Créer ma première demande'), findsOneWidget);
  });

  testWidgets('dashboard renders a list of missions when data is present', (tester) async {
    final container = ProviderContainer(
      overrides: [
        demandesListProvider.overrideWith((ref) async => [
          DemandeFret(
            id: 'd1',
            idPrestataire: 'p1',
            adresseDepart: 'Paris',
            adresseArrivee: 'Lyon',
            dateHeureSouhaiteeDepart: DateTime(2026, 9, 1, 8, 0),
            dateHeureRetourPrevue: null,
            typeVehiculeRequis: TypeVehicule.fourgon,
            poidsTotalEstimeKg: 120,
            volumeTotalEstimeM3: 4,
            fragile: false,
            necessiteFrigo: false,
            necessiteManutention: false,
            nbManutentionnairesRequis: 0,
            descriptionComplementaire: null,
            statut: StatutDemande.brouillon,
            dateCreation: DateTime(2026, 8, 30),
          ),
        ]),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: DashboardFretScreen()),
      ),
    );

    await tester.pump();

    expect(find.text('Paris → Lyon'), findsOneWidget);
    expect(find.text('Brouillon'), findsOneWidget);
  });
}
