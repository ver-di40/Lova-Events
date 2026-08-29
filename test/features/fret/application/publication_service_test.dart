import 'package:flutter_test/flutter_test.dart';
import 'package:lova_events/features/fret/application/services/publication_service.dart';
import 'package:lova_events/features/fret/domain/enums/fret_enums.dart';
import 'package:lova_events/features/fret/domain/exceptions/fret_exception.dart';
import 'package:lova_events/features/fret/domain/models/article_fret.dart';
import 'package:lova_events/features/fret/domain/models/demande_fret.dart';
import 'package:lova_events/features/fret/domain/models/fret_inputs.dart';
import 'package:lova_events/features/fret/domain/repositories/i_fret_repository.dart';

void main() {
  group('PublicationService', () {
    test('stops at KYC validation failure before other checks', () async {
      final repository = _FakeFretRepository(
        statusValidation: 'invalide',
        articles: [_buildArticle('a1')],
      );

      final service = PublicationService(
        repository: repository,
        loadProfileStatus: (id) async {
          repository.calls.add('loadProfileStatus');
          return {'statut_validation': 'invalide'};
        },
        emitDemandePublieeEvent: (_) async {},
      );

      await expectLater(
        service.publish('demande-1', demande: _buildDemande('demande-1', TypeVehicule.camionFrigo, true)),
        throwsA(isA<FretException>()),
      );

      expect(repository.calls, ['loadProfileStatus']);
    });

    test('throws ARTICLE_MANQUANT when there are no articles', () async {
      final repository = _FakeFretRepository(
        statusValidation: 'valide',
        articles: const [],
      );

      final service = PublicationService(
        repository: repository,
        loadProfileStatus: (id) async {
          repository.calls.add('loadProfileStatus');
          return {'statut_validation': 'valide'};
        },
        emitDemandePublieeEvent: (_) async {},
      );

      await expectLater(
        service.publish('demande-1', demande: _buildDemande('demande-1', TypeVehicule.camionFrigo, true)),
        throwsA(
          isA<FretException>().having(
            (e) => e.code,
            'code',
            FretErrorCode.ARTICLE_MANQUANT,
          ),
        ),
      );

      expect(repository.calls, ['loadProfileStatus', 'listArticles']);
    });

    test('throws FRIGO_VEHICULE_REQUIS when cold chain is required without frigocar', () async {
      final repository = _FakeFretRepository(
        statusValidation: 'valide',
        articles: [_buildArticle('a1')],
      );

      final service = PublicationService(
        repository: repository,
        loadProfileStatus: (id) async {
          repository.calls.add('loadProfileStatus');
          return {'statut_validation': 'valide'};
        },
        emitDemandePublieeEvent: (_) async {},
      );

      await expectLater(
        service.publish('demande-1', demande: _buildDemande('demande-1', TypeVehicule.fourgon, true)),
        throwsA(
          isA<FretException>().having(
            (e) => e.code,
            'code',
            FretErrorCode.FRIGO_VEHICULE_REQUIS,
          ),
        ),
      );

      expect(repository.calls, ['loadProfileStatus', 'listArticles']);
    });

    test('publishes successfully after all validations pass', () async {
      final repository = _FakeFretRepository(
        statusValidation: 'valide',
        articles: [_buildArticle('a1')],
        publishResult: _buildDemande('demande-1', TypeVehicule.camionFrigo, true),
      );
      final emitted = <String>[];

      final service = PublicationService(
        repository: repository,
        loadProfileStatus: (id) async {
          repository.calls.add('loadProfileStatus');
          return {'statut_validation': 'valide'};
        },
        emitDemandePublieeEvent: (id) async => emitted.add(id),
      );

      final result = await service.publish('demande-1', demande: _buildDemande('demande-1', TypeVehicule.camionFrigo, true));

      expect(result.statut, StatutDemande.publiee);
      expect(repository.calls, ['loadProfileStatus', 'listArticles', 'publish']);
      expect(emitted, ['demande-1']);
    });
  });
}

DemandeFret _buildDemande(String id, TypeVehicule typeVehicule, bool necessiteFrigo) {
  return DemandeFret(
    id: id,
    idPrestataire: 'prestataire-1',
    adresseDepart: 'Paris',
    adresseArrivee: 'Lyon',
    dateHeureSouhaiteeDepart: DateTime(2026, 9, 1, 8, 0),
    dateHeureRetourPrevue: null,
    typeVehiculeRequis: typeVehicule,
    poidsTotalEstimeKg: 10,
    volumeTotalEstimeM3: 2,
    fragile: false,
    necessiteFrigo: necessiteFrigo,
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
    idDemande: 'demande-1',
    designation: 'Palette',
    quantite: 1,
    poidsUnitaireKg: 10,
    volumeUnitaireM3: 2,
    categorie: CategorieArticle.mobilier,
    manutentionSpeciale: null,
  );
}

class _FakeFretRepository implements IFretRepository {
  _FakeFretRepository({
    required this.statusValidation,
    required this.articles,
    this.publishResult,
  });

  final String statusValidation;
  final List<ArticleFret> articles;
  final DemandeFret? publishResult;
  final List<String> calls = <String>[];

  @override
  Future<DemandeFret> createDraft() async => _buildDemande('new', TypeVehicule.indifferent, false);

  @override
  Future<DemandeFret> updateDraft(String id, DemandeFretInput input) async =>
      _buildDemande(id, input.typeVehiculeRequis, input.necessiteFrigo);

  @override
  Future<DemandeFret> publish(String id) async {
    calls.add('publish');
    final base = publishResult ?? _buildDemande(id, TypeVehicule.camionFrigo, true);
    return base.copyWith(statut: StatutDemande.publiee);
  }

  @override
  Future<DemandeFret?> getDemande(String id) async => _buildDemande(id, TypeVehicule.camionFrigo, true);

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
  ) async => _buildArticle(idArticle);

  @override
  Future<void> deleteArticle(String idDemande, String idArticle) async {}

  @override
  Future<List<ArticleFret>> listArticles(String idDemande) async {
    calls.add('listArticles');
    return articles;
  }
}
