import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lova_events/features/fret/application/providers/fret_providers.dart';
import 'package:lova_events/features/fret/domain/enums/fret_enums.dart';
import 'package:lova_events/features/fret/domain/models/article_fret.dart';
import 'package:lova_events/features/fret/domain/models/demande_fret.dart';
import 'package:lova_events/features/fret/domain/models/fret_inputs.dart';
import 'package:lova_events/features/fret/domain/repositories/i_fret_repository.dart';
import 'package:lova_events/features/fret/presentation/screens/wizard_fret_screen.dart';
import 'package:lova_events/features/fret/presentation/widgets/wizard_progress_indicator.dart';

void main() {
  testWidgets('wizard screen shows header and step navigation', (tester) async {
    final container = ProviderContainer(
      overrides: [
        fretRepositoryProvider.overrideWithValue(_FakeRepository()),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: WizardFretScreen()),
      ),
    );

    await tester.pump();

    expect(find.text('Brouillon sauvegardé'), findsOneWidget);
    expect(find.byType(WizardProgressIndicator), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('Itinéraire'), findsWidgets);
    expect(find.text('Véhicule'), findsWidgets);
    expect(find.text('Inventaire'), findsWidgets);
    expect(find.text('Récapitulatif'), findsWidgets);
    expect(find.text('Suivant'), findsOneWidget);
  });
}

class _FakeRepository implements IFretRepository {
  @override
  Future<DemandeFret> createDraft() async {
    return DemandeFret(
      id: 'draft-1',
      idPrestataire: 'p1',
      adresseDepart: 'Paris',
      adresseArrivee: 'Lyon',
      dateHeureSouhaiteeDepart: DateTime(2026, 9, 1, 8, 0),
      dateHeureRetourPrevue: null,
      typeVehiculeRequis: TypeVehicule.fourgon,
      poidsTotalEstimeKg: 0,
      volumeTotalEstimeM3: 0,
      fragile: false,
      necessiteFrigo: false,
      necessiteManutention: false,
      nbManutentionnairesRequis: 0,
      descriptionComplementaire: null,
      statut: StatutDemande.brouillon,
      dateCreation: DateTime(2026, 8, 30),
    );
  }

  @override
  Future<DemandeFret> updateDraft(String id, DemandeFretInput input) async => createDraft();

  @override
  Future<DemandeFret> publish(String id) async => createDraft();

  @override
  Future<DemandeFret?> getDemande(String id) async => createDraft();

  @override
  Future<List<DemandeFret>> listDemandes({String? statut}) async => const [];

  @override
  Future<void> deleteDraft(String id) async {}

  @override
  Future<ArticleFret> addArticle(String idDemande, ArticleFretInput input) async {
    throw UnimplementedError();
  }

  @override
  Future<ArticleFret> updateArticle(String idDemande, String idArticle, ArticleFretInput input) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteArticle(String idDemande, String idArticle) async {}

  @override
  Future<List<ArticleFret>> listArticles(String idDemande) async => const [];
}
