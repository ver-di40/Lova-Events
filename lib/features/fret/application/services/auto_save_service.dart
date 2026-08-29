import 'dart:async';

import '../../domain/enums/fret_enums.dart';
import '../../domain/exceptions/fret_exception.dart';
import '../../domain/models/article_fret.dart';
import '../../domain/models/demande_fret.dart';
import '../../domain/models/fret_inputs.dart';
import '../../domain/repositories/i_fret_repository.dart';

enum SaveState { saving, saved, error }

class AutoSaveService {
  AutoSaveService({
    required this.repository,
    this.timeout = const Duration(seconds: 2),
    this.onStateChanged,
    this.onSaveFailure,
    this.onBlockingAlert,
    this.onSingleDraftFound,
    this.onMultipleDraftsFound,
  });

  final IFretRepository repository;
  final Duration timeout;
  final void Function(SaveState state)? onStateChanged;
  final void Function(String message)? onSaveFailure;
  final void Function(String message)? onBlockingAlert;
  final void Function(DemandeFret draft)? onSingleDraftFound;
  final void Function(List<DemandeFret> drafts)? onMultipleDraftsFound;

  SaveState _state = SaveState.saved;
  SaveState get state => _state;

  Future<DemandeFret> initDraft(String? existingId) async {
    if (existingId == null) {
      try {
        _setState(SaveState.saving);
        final draft = await _runWithTimeout(repository.createDraft());
        _setState(SaveState.saved);
        return draft;
      } on TimeoutException {
        _setState(SaveState.error);
        final message = 'Sauvegarde impossible : délai dépassé';
        onSaveFailure?.call(message);
        throw TimeoutException('Draft creation timed out');
      } on FretException catch (error) {
        _setState(SaveState.error);
        final alert = 'Création du brouillon impossible. Vérifiez votre connexion et réessayez.';
        onBlockingAlert?.call(alert);
        throw FretException(error.code, error.message);
      }
    }

    final draft = await _runWithTimeout(repository.getDemande(existingId));
    if (draft == null) {
      throw FretException(
        FretErrorCode.SUPABASE_ERROR,
        'Demande introuvable',
      );
    }
    return draft;
  }

  Future<DemandeFret> saveStep(String id, DemandeFretInput input) async {
    _setState(SaveState.saving);
    try {
      final result = await _runWithTimeout(repository.updateDraft(id, input));
      _setState(SaveState.saved);
      return result;
    } on TimeoutException {
      _setState(SaveState.error);
      final message = 'Sauvegarde du brouillon interrompue';
      onSaveFailure?.call(message);
      throw TimeoutException('Draft update timed out');
    }
  }

  Future<ArticleFret> saveArticleAdded(String idDemande, ArticleFretInput input) async {
    _setState(SaveState.saving);
    try {
      final result = await _runWithTimeout(repository.addArticle(idDemande, input));
      _setState(SaveState.saved);
      return result;
    } on TimeoutException {
      _setState(SaveState.error);
      final message = 'Ajout d’article impossible';
      onSaveFailure?.call(message);
      throw TimeoutException('Add article timed out');
    }
  }

  Future<ArticleFret> saveArticleUpdated(
    String idDemande,
    String idArticle,
    ArticleFretInput input,
  ) async {
    _setState(SaveState.saving);
    try {
      final result = await _runWithTimeout(
        repository.updateArticle(idDemande, idArticle, input),
      );
      _setState(SaveState.saved);
      return result;
    } on TimeoutException {
      _setState(SaveState.error);
      final message = 'Mise à jour d’article impossible';
      onSaveFailure?.call(message);
      throw TimeoutException('Update article timed out');
    }
  }

  Future<void> saveArticleDeleted(String idDemande, String idArticle) async {
    _setState(SaveState.saving);
    try {
      await _runWithTimeout(repository.deleteArticle(idDemande, idArticle));
      _setState(SaveState.saved);
    } on TimeoutException {
      _setState(SaveState.error);
      final message = 'Suppression d’article impossible';
      onSaveFailure?.call(message);
      throw TimeoutException('Delete article timed out');
    }
  }

  Future<List<DemandeFret>> listDrafts() async {
    final drafts = await _runWithTimeout(repository.listDemandes(statut: StatutDemande.brouillon.value));
    if (drafts.length == 1) {
      onSingleDraftFound?.call(drafts.first);
      return drafts;
    }
    if (drafts.length > 1) {
      onMultipleDraftsFound?.call(drafts);
    }
    return drafts;
  }

  Future<T> _runWithTimeout<T>(Future<T> future) {
    return future.timeout(timeout);
  }

  void _setState(SaveState next) {
    _state = next;
    onStateChanged?.call(next);
  }
}
