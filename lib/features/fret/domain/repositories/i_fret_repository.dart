import '../models/article_fret.dart';
import '../models/demande_fret.dart';
import '../models/fret_inputs.dart';

abstract interface class IFretRepository {
  Future<DemandeFret> createDraft();
  Future<DemandeFret> updateDraft(String id, DemandeFretInput input);
  Future<DemandeFret> publish(String id);
  Future<DemandeFret?> getDemande(String id);
  Future<List<DemandeFret>> listDemandes({String? statut});
  Future<void> deleteDraft(String id);

  Future<ArticleFret> addArticle(String idDemande, ArticleFretInput input);
  Future<ArticleFret> updateArticle(String idDemande, String idArticle, ArticleFretInput input);
  Future<void> deleteArticle(String idDemande, String idArticle);
  Future<List<ArticleFret>> listArticles(String idDemande);
}
