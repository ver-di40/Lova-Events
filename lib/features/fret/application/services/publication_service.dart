import '../../domain/enums/fret_enums.dart';
import '../../domain/exceptions/fret_exception.dart';
import '../../domain/models/demande_fret.dart';
import '../../domain/repositories/i_fret_repository.dart';

class PublicationService {
  PublicationService({
    required this.repository,
    Future<Map<String, Object?>> Function(String idDemande)? loadProfileStatus,
    Future<void> Function(String idDemande)? emitDemandePublieeEvent,
  })  : _loadProfileStatus = loadProfileStatus ?? _defaultLoadProfileStatus,
        _emitDemandePublieeEvent = emitDemandePublieeEvent ?? _defaultEmitDemandePublieeEvent;

  final IFretRepository repository;
  final Future<Map<String, Object?>> Function(String idDemande) _loadProfileStatus;
  final Future<void> Function(String idDemande) _emitDemandePublieeEvent;

  Future<DemandeFret> publish(String idDemande, {DemandeFret? demande}) async {
    final profile = await _loadProfileStatus(idDemande);
    final statutValidation = profile['statut_validation'];
    if (statutValidation != 'valide') {
      throw FretException(FretErrorCode.KYC_INVALIDE, 'KYC invalide');
    }

    final articles = await repository.listArticles(idDemande);
    if (articles.isEmpty) {
      throw FretException(FretErrorCode.ARTICLE_MANQUANT, 'Aucun article');
    }

    final request = demande ?? await repository.getDemande(idDemande);
    if (request == null) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, 'Demande introuvable');
    }

    if (request.necessiteFrigo && request.typeVehiculeRequis != TypeVehicule.camionFrigo) {
      throw FretException(
        FretErrorCode.FRIGO_VEHICULE_REQUIS,
        'Un camion frigorifique est requis.',
      );
    }

    try {
      final published = await repository.publish(idDemande);
      await _emitDemandePublieeEvent(idDemande);
      return published;
    } on FretException {
      rethrow;
    } catch (_) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, 'Échec de publication');
    }
  }

  static Future<Map<String, Object?>> _defaultLoadProfileStatus(String idDemande) async {
    return {'statut_validation': 'valide'};
  }

  static Future<void> _defaultEmitDemandePublieeEvent(String idDemande) async {}
}
