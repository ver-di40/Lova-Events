import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lova_events/features/fret/application/providers/fret_providers.dart';
import 'package:lova_events/features/fret/application/services/auto_save_service.dart';
import 'package:lova_events/features/fret/application/services/totaux_calculator.dart';
import 'package:lova_events/features/fret/domain/enums/fret_enums.dart';
import 'package:lova_events/features/fret/domain/models/article_fret.dart';
import 'package:lova_events/features/fret/domain/models/demande_fret.dart';
import 'package:lova_events/features/fret/domain/models/fret_inputs.dart';
import 'package:lova_events/features/fret/domain/repositories/i_fret_repository.dart';
import 'package:lova_events/features/fret/presentation/state/wizard_fret_notifier.dart';

void main() {
  group('WizardFretNotifier', () {
    test('advances and rewinds steps', () async {
      final repository = _FakeFretRepository();
      final container = ProviderContainer(
        overrides: [
          fretRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(wizardFretNotifierProvider.notifier);
      notifier.state = const FretWizardState(
        draftId: 'draft-1',
        demande: null,
        currentStep: 0,
      );

      final input = DemandeFretInput(
        adresseDepart: 'Paris',
        adresseArrivee: 'Lyon',
        dateHeureSouhaiteeDepart: DateTime(2026, 9, 1, 8, 0),
        dateHeureRetourPrevue: null,
        typeVehiculeRequis: TypeVehicule.fourgon,
        fragile: false,
        necessiteFrigo: false,
        necessiteManutention: false,
        nbManutentionnairesRequis: 0,
        descriptionComplementaire: null,
      );

      await notifier.nextStep(input);
      expect(notifier.state.currentStep, 1);

      notifier.previousStep();
      expect(notifier.state.currentStep, 0);
    });

    test('initializes a draft when no existing id is provided', () async {
      final repository = _FakeFretRepository();
      final container = ProviderContainer(
        overrides: [
          fretRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(wizardFretNotifierProvider.notifier);
      final draft = _buildDemande('created');

      notifier.state = FretWizardState(
        draftId: draft.id,
        demande: draft,
        saveState: SaveState.saved,
      );

      expect(notifier.state.draftId, 'created');
      expect(notifier.state.demande, isNotNull);
    });

    test('captures FretException in state', () async {
      final repository = _FakeFretRepository();
      final container = ProviderContainer(
        overrides: [
          fretRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(wizardFretNotifierProvider.notifier);
      notifier.state = notifier.state.copyWith(
        saveState: SaveState.error,
        errorMessage: 'KYC invalide',
      );

      expect(notifier.state.saveState, SaveState.error);
      expect(notifier.state.errorMessage, 'KYC invalide');
    });

    test('clears error state when a successful save resets the wizard state', () async {
      final notifier = FretWizardState(
        saveState: SaveState.error,
        errorMessage: 'KYC invalide',
      );

      final updated = notifier.copyWith(
        saveState: SaveState.saved,
        errorMessage: null,
      );

      expect(updated.saveState, SaveState.saved);
      expect(updated.errorMessage, isNull);
    });

    test('sets save error state when a non-Fret exception occurs while saving the step', () async {
      final repository = _FailingOnUpdateRepository();
      final container = ProviderContainer(
        overrides: [
          fretRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(wizardFretNotifierProvider.notifier);
      notifier.state = const FretWizardState(
        draftId: 'draft-1',
        currentStep: 0,
      );

      final input = DemandeFretInput(
        adresseDepart: 'Paris',
        adresseArrivee: 'Lyon',
        dateHeureSouhaiteeDepart: DateTime(2026, 9, 1, 8, 0),
        dateHeureRetourPrevue: null,
        typeVehiculeRequis: TypeVehicule.fourgon,
        fragile: false,
        necessiteFrigo: false,
        necessiteManutention: false,
        nbManutentionnairesRequis: 0,
        descriptionComplementaire: null,
      );

      await expectLater(
        notifier.nextStep(input),
        throwsA(isA<TimeoutException>()),
      );

      expect(notifier.state.saveState, SaveState.error);
      expect(notifier.state.errorMessage, isNotNull);
    });

    test('exposes the integrated Fret application providers', () async {
      final repository = _FakeFretRepository();
      final container = ProviderContainer(
        overrides: [
          fretRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final service = container.read(autoSaveServiceProvider);
      final publicationService = container.read(publicationServiceProvider);
      final totalsCalculator = container.read(totalsCalculatorProvider);

      expect(service.repository, same(repository));
      expect(publicationService.repository, same(repository));
      expect(totalsCalculator, isA<TotauxCalculator>());
    });
  });
}

DemandeFret _buildDemande(String id) {
  return DemandeFret(
    id: id,
    idPrestataire: 'prestataire-1',
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
    dateCreation: DateTime(2026, 8, 25),
  );
}

ArticleFret _buildArticle(String id) {
  return ArticleFret(
    id: id,
    idDemande: 'draft-1',
    designation: 'Palette',
    quantite: 1,
    poidsUnitaireKg: 12,
    volumeUnitaireM3: 0.5,
    categorie: CategorieArticle.mobilier,
    manutentionSpeciale: null,
  );
}

class _FailingOnUpdateRepository implements IFretRepository {
  @override
  Future<DemandeFret> createDraft() async => _buildDemande('created');

  @override
  Future<DemandeFret> updateDraft(String id, DemandeFretInput input) async {
    throw TimeoutException('Draft update timed out');
  }

  @override
  Future<DemandeFret> publish(String id) async => _buildDemande(id).copyWith(statut: StatutDemande.publiee);

  @override
  Future<DemandeFret?> getDemande(String id) async => _buildDemande(id);

  @override
  Future<List<DemandeFret>> listDemandes({String? statut}) async => const [];

  @override
  Future<void> deleteDraft(String id) async {}

  @override
  Future<ArticleFret> addArticle(String idDemande, ArticleFretInput input) async => _buildArticle('new');

  @override
  Future<ArticleFret> updateArticle(
    String idDemande,
    String idArticle,
    ArticleFretInput input,
  ) async =>
      _buildArticle(idArticle);

  @override
  Future<void> deleteArticle(String idDemande, String idArticle) async {}

  @override
  Future<List<ArticleFret>> listArticles(String idDemande) async => const [];
}

class _FakeFretRepository implements IFretRepository {
  @override
  Future<DemandeFret> createDraft() async => _buildDemande('created');

  @override
  Future<DemandeFret> updateDraft(String id, DemandeFretInput input) async =>
      _buildDemande(id).copyWith(
        adresseDepart: input.adresseDepart,
        adresseArrivee: input.adresseArrivee,
      );

  @override
  Future<DemandeFret> publish(String id) async => _buildDemande(id).copyWith(statut: StatutDemande.publiee);

  @override
  Future<DemandeFret?> getDemande(String id) async => _buildDemande(id);

  @override
  Future<List<DemandeFret>> listDemandes({String? statut}) async => const [];

  @override
  Future<void> deleteDraft(String id) async {}

  @override
  Future<ArticleFret> addArticle(String idDemande, ArticleFretInput input) async =>
      _buildArticle('new');

  @override
  Future<ArticleFret> updateArticle(
    String idDemande,
    String idArticle,
    ArticleFretInput input,
  ) async =>
      _buildArticle(idArticle);

  @override
  Future<void> deleteArticle(String idDemande, String idArticle) async {}

  @override
  Future<List<ArticleFret>> listArticles(String idDemande) async => const [];
}
