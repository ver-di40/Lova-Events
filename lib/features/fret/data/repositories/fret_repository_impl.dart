import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/enums/fret_enums.dart';
import '../../domain/exceptions/fret_exception.dart';
import '../../domain/models/article_fret.dart';
import '../../domain/models/demande_fret.dart';
import '../../domain/models/fret_inputs.dart';
import '../../domain/repositories/i_fret_repository.dart';

class FretRepositoryImpl implements IFretRepository {
  FretRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<DemandeFret> createDraft() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw const FretException(
          FretErrorCode.SUPABASE_ERROR,
          'Utilisateur non authentifié.',
        );
      }

      final now = DateTime.now();
      final payload = {
        'id_prestataire': userId,
        'adresse_depart': '',
        'adresse_arrivee': '',
        'date_heure_souhaitee_depart': now.add(const Duration(days: 1)).toIso8601String(),
        'date_heure_retour_prevue': null,
        'type_vehicule_requis': TypeVehicule.indifferent.value,
        'poids_total_estime_kg': 0.0,
        'volume_total_estime_m3': 0.0,
        'fragile': false,
        'necessite_frigo': false,
        'necessite_manutention': false,
        'nb_manutentionnaires_requis': 0,
        'description_complementaire': null,
        'statut': StatutDemande.brouillon.value,
        'date_creation': now.toIso8601String(),
      };

      final row = await _client.from('demandes_fret').insert(payload).select().single();
      return DemandeFret.fromJson(_asJsonMap(row));
    } on FretException {
      rethrow;
    } on PostgrestException catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.message);
    } catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.toString());
    }
  }

  @override
  Future<DemandeFret> updateDraft(String id, DemandeFretInput input) async {
    try {
      final demande = await getDemande(id);
      if (demande == null) {
        throw const FretException(
          FretErrorCode.SUPABASE_ERROR,
          'Demande introuvable.',
        );
      }

      if (demande.statut.estNonModifiable) {
        throw FretException(
          FretErrorCode.DEMANDE_NON_MODIFIABLE,
          'La demande est non modifiable.',
        );
      }

      final row = await _client
          .from('demandes_fret')
          .update(input.toJson())
          .eq('id', id)
          .select()
          .single();

      return DemandeFret.fromJson(_asJsonMap(row));
    } on FretException {
      rethrow;
    } on PostgrestException catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.message);
    } catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.toString());
    }
  }

  @override
  Future<DemandeFret> publish(String id) async {
    try {
      final row = await _client
          .from('demandes_fret')
          .update({'statut': StatutDemande.publiee.value})
          .eq('id', id)
          .select()
          .single();

      return DemandeFret.fromJson(_asJsonMap(row));
    } on FretException {
      rethrow;
    } on PostgrestException catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.message);
    } catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.toString());
    }
  }

  @override
  Future<DemandeFret?> getDemande(String id) async {
    try {
      final row = await _client
          .from('demandes_fret')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (row == null) {
        return null;
      }

      return DemandeFret.fromJson(_asJsonMap(row));
    } on PostgrestException catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.message);
    } catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.toString());
    }
  }

  @override
  Future<List<DemandeFret>> listDemandes({String? statut}) async {
    try {
      var query = _client.from('demandes_fret').select();
      if (statut != null) {
        query = query.eq('statut', statut);
      }
      final rows = await query.order('date_creation', ascending: false);

      final items = rows
          .map((row) => DemandeFret.fromJson(_asJsonMap(row)))
          .toList();
      return items;
    } on PostgrestException catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.message);
    } catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.toString());
    }
  }

  @override
  Future<void> deleteDraft(String id) async {
    try {
      final demande = await getDemande(id);
      if (demande == null) {
        throw const FretException(
          FretErrorCode.SUPABASE_ERROR,
          'Demande introuvable.',
        );
      }

      if (demande.statut != StatutDemande.brouillon) {
        throw FretException(
          FretErrorCode.DEMANDE_NON_MODIFIABLE,
          'Seuls les brouillons peuvent être supprimés.',
        );
      }

      await _client.from('demandes_fret').delete().eq('id', id);
    } on FretException {
      rethrow;
    } on PostgrestException catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.message);
    } catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.toString());
    }
  }

  @override
  Future<ArticleFret> addArticle(String idDemande, ArticleFretInput input) async {
    try {
      final demande = await getDemande(idDemande);
      if (demande == null) {
        throw const FretException(
          FretErrorCode.SUPABASE_ERROR,
          'Demande introuvable.',
        );
      }

      if (demande.statut.estNonModifiable) {
        throw FretException(
          FretErrorCode.DEMANDE_NON_MODIFIABLE,
          'La demande est non modifiable.',
        );
      }

      final payload = <String, Object?>{...input.toJson(), 'id_demande': idDemande};
      final row = await _client.from('articles_fret').insert(payload).select().single();
      await _refreshTotalsForDemande(idDemande);
      return ArticleFret.fromJson(_asJsonMap(row));
    } on FretException {
      rethrow;
    } on PostgrestException catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.message);
    } catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.toString());
    }
  }

  @override
  Future<ArticleFret> updateArticle(
    String idDemande,
    String idArticle,
    ArticleFretInput input,
  ) async {
    try {
      final demande = await getDemande(idDemande);
      if (demande == null) {
        throw const FretException(
          FretErrorCode.SUPABASE_ERROR,
          'Demande introuvable.',
        );
      }

      if (demande.statut.estNonModifiable) {
        throw FretException(
          FretErrorCode.DEMANDE_NON_MODIFIABLE,
          'La demande est non modifiable.',
        );
      }

      final row = await _client
          .from('articles_fret')
          .update(input.toJson())
          .eq('id', idArticle)
          .eq('id_demande', idDemande)
          .select()
          .single();

      await _refreshTotalsForDemande(idDemande);
      return ArticleFret.fromJson(_asJsonMap(row));
    } on FretException {
      rethrow;
    } on PostgrestException catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.message);
    } catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.toString());
    }
  }

  @override
  Future<void> deleteArticle(String idDemande, String idArticle) async {
    try {
      final demande = await getDemande(idDemande);
      if (demande == null) {
        throw const FretException(
          FretErrorCode.SUPABASE_ERROR,
          'Demande introuvable.',
        );
      }

      if (demande.statut.estNonModifiable) {
        throw FretException(
          FretErrorCode.DEMANDE_NON_MODIFIABLE,
          'La demande est non modifiable.',
        );
      }

      await _client
          .from('articles_fret')
          .delete()
          .eq('id', idArticle)
          .eq('id_demande', idDemande);

      await _refreshTotalsForDemande(idDemande);
    } on FretException {
      rethrow;
    } on PostgrestException catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.message);
    } catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.toString());
    }
  }

  @override
  Future<List<ArticleFret>> listArticles(String idDemande) async {
    try {
      final rows = await _client
          .from('articles_fret')
          .select()
          .eq('id_demande', idDemande)
          .order('id');

      return rows.map((row) => ArticleFret.fromJson(_asJsonMap(row))).toList();
    } on PostgrestException catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.message);
    } catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.toString());
    }
  }

  Future<void> _refreshTotalsForDemande(String idDemande) async {
    try {
      await _client.rpc(
        'refresh_fret_totals_for_demande',
        params: {'p_demande_id': idDemande},
      );
    } on PostgrestException catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.message);
    } catch (error) {
      throw FretException(FretErrorCode.SUPABASE_ERROR, error.toString());
    }
  }

  Map<String, Object?> _asJsonMap(Map<String, dynamic> data) {
    return Map<String, Object?>.from(data);
  }
}
