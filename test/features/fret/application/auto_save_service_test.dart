import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lova_events/features/fret/application/services/auto_save_service.dart';
import 'package:lova_events/features/fret/domain/enums/fret_enums.dart';
import 'package:lova_events/features/fret/domain/exceptions/fret_exception.dart';
import 'package:lova_events/features/fret/domain/models/article_fret.dart';
import 'package:lova_events/features/fret/domain/models/demande_fret.dart';
import 'package:lova_events/features/fret/domain/models/fret_inputs.dart';
import 'package:lova_events/features/fret/domain/repositories/i_fret_repository.dart';

void main() {
  group('AutoSaveService', () {
    test('sets saving and saved states for a successful step save', () async {
      final repository = _FakeFretRepository(
        updateDraftResult: Future.value(
          _buildDemande(
            'draft-1',
            StatutDemande.brouillon,
          ),
        ),
      );
      final notifications = <SaveState>[];

      final service = AutoSaveService(
        repository: repository,
        timeout: const Duration(milliseconds: 200),
        onStateChanged: notifications.add,
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

      await service.saveStep('draft-1', input);

      expect(notifications, [SaveState.saving, SaveState.saved]);
      expect(service.state, SaveState.saved);
    });

    test('switches to error state when the repository times out', () async {
      final repository = _FakeFretRepository(
        updateDraftResult: Future.delayed(
          const Duration(milliseconds: 500),
          () => _buildDemande('draft-1', StatutDemande.brouillon),
        ),
      );
      final errorMessages = <String>[];
      final stateChanges = <SaveState>[];

      final service = AutoSaveService(
        repository: repository,
        timeout: const Duration(milliseconds: 50),
        onSaveFailure: errorMessages.add,
        onStateChanged: stateChanges.add,
      );

      final input = DemandeFretInput(
        adresseDepart: 'Paris',
        adresseArrivee: 'Lyon',
        dateHeureSouhaiteeDepart: DateTime(2026, 9, 1, 8, 0),
        dateHeureRetourPrevue: null,
        typeVehiculeRequis: TypeVehicule.camionFrigo,
        fragile: false,
        necessiteFrigo: true,
        necessiteManutention: false,
        nbManutentionnairesRequis: 0,
        descriptionComplementaire: null,
      );

      await expectLater(
        service.saveStep('draft-1', input),
        throwsA(isA<TimeoutException>()),
      );

      expect(stateChanges, [SaveState.saving, SaveState.error]);
      expect(service.state, SaveState.error);
      expect(errorMessages, isNotEmpty);
    });

    test('shows a blocking alert when initial draft creation fails', () async {
      final repository = _FakeFretRepository(
        createDraftError: const FretException(
          FretErrorCode.SUPABASE_ERROR,
          'create failed',
        ),
      );
      final alerts = <String>[];

      final service = AutoSaveService(
        repository: repository,
        timeout: const Duration(milliseconds: 200),
        onBlockingAlert: alerts.add,
      );

      await expectLater(
        service.initDraft(null),
        throwsA(isA<FretException>()),
      );

      expect(alerts, ['Création du brouillon impossible. Vérifiez votre connexion et réessayez.']);
      expect(service.state, SaveState.error);
    });

    test('proposes resuming a single draft and handles multiple drafts', () async {
      final draftA = _buildDemande('draft-a', StatutDemande.brouillon);
      final draftB = _buildDemande('draft-b', StatutDemande.brouillon);
      final repository = _FakeFretRepository(
        draftListResult: [draftA],
      );

      final singleDrafts = <DemandeFret>[];
      final multiDrafts = <List<DemandeFret>>[];

      final singleService = AutoSaveService(
        repository: repository,
        timeout: const Duration(milliseconds: 200),
        onSingleDraftFound: singleDrafts.add,
      );

      await singleService.listDrafts();
      expect(singleDrafts, [draftA]);

      repository.draftListResult = [draftA, draftB];
      final multiService = AutoSaveService(
        repository: repository,
        timeout: const Duration(milliseconds: 200),
        onMultipleDraftsFound: multiDrafts.add,
      );

      await multiService.listDrafts();
      expect(multiDrafts, [isA<List<DemandeFret>>()]);
      expect(multiDrafts.first, hasLength(2));
    });
  });
}

DemandeFret _buildDemande(String id, StatutDemande statut) {
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
    statut: statut,
    dateCreation: DateTime(2026, 8, 30),
  );
}

class _FakeFretRepository implements IFretRepository {
  _FakeFretRepository({
    this.createDraftError,
    this.updateDraftResult,
    this.draftListResult = const [],
  });

  Object? createDraftError;
  Future<DemandeFret>? updateDraftResult;
  List<DemandeFret> draftListResult;

  @override
  Future<DemandeFret> createDraft() {
    if (createDraftError != null) {
      return Future.error(createDraftError!);
    }
    return Future.value(_buildDemande('created', StatutDemande.brouillon));
  }

  @override
  Future<DemandeFret> updateDraft(String id, DemandeFretInput input) {
    if (updateDraftResult is Future<DemandeFret>) {
      return updateDraftResult!;
    }
    return Future.value(_buildDemande(id, StatutDemande.brouillon));
  }

  @override
  Future<DemandeFret> publish(String id) async => _buildDemande(id, StatutDemande.publiee);

  @override
  Future<DemandeFret?> getDemande(String id) async => _buildDemande(id, StatutDemande.brouillon);

  @override
  Future<List<DemandeFret>> listDemandes({String? statut}) async => draftListResult;

  @override
  Future<void> deleteDraft(String id) async {}

  @override
  Future<ArticleFret> addArticle(String idDemande, ArticleFretInput input) async {
    return ArticleFret(
      id: 'article-1',
      idDemande: idDemande,
      designation: input.designation,
      quantite: input.quantite,
      poidsUnitaireKg: input.poidsUnitaireKg,
      volumeUnitaireM3: input.volumeUnitaireM3,
      categorie: input.categorie,
      manutentionSpeciale: input.manutentionSpeciale,
    );
  }

  @override
  Future<ArticleFret> updateArticle(
    String idDemande,
    String idArticle,
    ArticleFretInput input,
  ) async {
    return ArticleFret(
      id: idArticle,
      idDemande: idDemande,
      designation: input.designation,
      quantite: input.quantite,
      poidsUnitaireKg: input.poidsUnitaireKg,
      volumeUnitaireM3: input.volumeUnitaireM3,
      categorie: input.categorie,
      manutentionSpeciale: input.manutentionSpeciale,
    );
  }

  @override
  Future<void> deleteArticle(String idDemande, String idArticle) async {}

  @override
  Future<List<ArticleFret>> listArticles(String idDemande) async => const [];
}
