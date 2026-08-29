import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/fret_providers.dart';
import '../../application/services/auto_save_service.dart';
import '../../domain/exceptions/fret_exception.dart';
import '../../domain/models/article_fret.dart';
import '../../domain/models/demande_fret.dart';
import '../../domain/models/fret_inputs.dart';

class FretWizardState {
  const FretWizardState({
    this.currentStep = 0,
    this.draftId,
    this.demande,
    this.articles = const <ArticleFret>[],
    this.saveState = SaveState.saved,
    this.errorMessage,
  });

  static const Object _sentinel = Object();

  final int currentStep;
  final String? draftId;
  final DemandeFret? demande;
  final List<ArticleFret> articles;
  final SaveState saveState;
  final String? errorMessage;

  FretWizardState copyWith({
    int? currentStep,
    String? draftId,
    DemandeFret? demande,
    List<ArticleFret>? articles,
    SaveState? saveState,
    Object? errorMessage = _sentinel,
  }) {
    return FretWizardState(
      currentStep: currentStep ?? this.currentStep,
      draftId: draftId ?? this.draftId,
      demande: demande ?? this.demande,
      articles: articles ?? this.articles,
      saveState: saveState ?? this.saveState,
      errorMessage: errorMessage == _sentinel ? this.errorMessage : errorMessage as String?,
    );
  }
}

final wizardFretNotifierProvider = NotifierProvider<WizardFretNotifier, FretWizardState>(
  WizardFretNotifier.new,
);

class WizardFretNotifier extends Notifier<FretWizardState> {
  @override
  FretWizardState build() {
    return const FretWizardState();
  }

  Future<void> initDraft(String? existingId) async {
    final service = ref.read(autoSaveServiceProvider);

    try {
      final draft = await service.initDraft(existingId);
      state = state.copyWith(
        draftId: draft.id,
        demande: draft,
        saveState: SaveState.saved,
        errorMessage: null,
      );
    } on FretException catch (error) {
      state = state.copyWith(
        saveState: SaveState.error,
        errorMessage: error.message,
      );
      rethrow;
    } catch (error) {
      state = state.copyWith(
        saveState: SaveState.error,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  Future<void> nextStep(DemandeFretInput input) async {
    final draftId = state.draftId;
    if (draftId == null) {
      return;
    }

    final service = ref.read(autoSaveServiceProvider);

    try {
      final updated = await service.saveStep(draftId, input);
      state = state.copyWith(
        demande: updated,
        currentStep: (state.currentStep + 1).clamp(0, 3),
        saveState: SaveState.saved,
        errorMessage: null,
      );
    } on FretException catch (error) {
      state = state.copyWith(
        saveState: SaveState.error,
        errorMessage: error.message,
      );
      rethrow;
    } catch (error) {
      state = state.copyWith(
        saveState: SaveState.error,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  void previousStep() {
    state = state.copyWith(
      currentStep: (state.currentStep - 1).clamp(0, 3),
    );
  }

  void setCurrentStep(int stepIndex) {
    state = state.copyWith(
      currentStep: stepIndex.clamp(0, 3),
    );
  }

  Future<void> addArticle(ArticleFretInput input) async {
    final draftId = state.draftId;
    if (draftId == null) {
      return;
    }

    final service = ref.read(autoSaveServiceProvider);
    final totals = ref.read(totalsCalculatorProvider);

    try {
      final article = await service.saveArticleAdded(draftId, input);
      final nextArticles = [...state.articles, article];
      state = state.copyWith(
        articles: nextArticles,
        saveState: SaveState.saved,
        errorMessage: null,
      );
      final weighted = totals.calculerPoidsTotal(nextArticles);
      final volume = totals.calculerVolumeTotal(nextArticles);
      final demande = state.demande;
      if (demande != null) {
        state = state.copyWith(
          demande: demande.copyWith(
            poidsTotalEstimeKg: weighted,
            volumeTotalEstimeM3: volume,
          ),
        );
      }
    } on FretException catch (error) {
      state = state.copyWith(
        saveState: SaveState.error,
        errorMessage: error.message,
      );
      rethrow;
    } catch (error) {
      state = state.copyWith(
        saveState: SaveState.error,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  Future<void> updateArticle(String articleId, ArticleFretInput input) async {
    final draftId = state.draftId;
    if (draftId == null) {
      return;
    }

    final service = ref.read(autoSaveServiceProvider);
    final totals = ref.read(totalsCalculatorProvider);

    try {
      final article = await service.saveArticleUpdated(draftId, articleId, input);
      final nextArticles = state.articles.map((item) {
        return item.id == articleId ? article : item;
      }).toList();
      state = state.copyWith(
        articles: nextArticles,
        saveState: SaveState.saved,
        errorMessage: null,
      );
      final demande = state.demande;
      if (demande != null) {
        state = state.copyWith(
          demande: demande.copyWith(
            poidsTotalEstimeKg: totals.calculerPoidsTotal(nextArticles),
            volumeTotalEstimeM3: totals.calculerVolumeTotal(nextArticles),
          ),
        );
      }
    } on FretException catch (error) {
      state = state.copyWith(
        saveState: SaveState.error,
        errorMessage: error.message,
      );
      rethrow;
    } catch (error) {
      state = state.copyWith(
        saveState: SaveState.error,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  Future<void> deleteArticle(String articleId) async {
    final draftId = state.draftId;
    if (draftId == null) {
      return;
    }

    final service = ref.read(autoSaveServiceProvider);
    final totals = ref.read(totalsCalculatorProvider);

    try {
      await service.saveArticleDeleted(draftId, articleId);
      final nextArticles = state.articles.where((item) => item.id != articleId).toList();
      state = state.copyWith(
        articles: nextArticles,
        saveState: SaveState.saved,
        errorMessage: null,
      );
      final demande = state.demande;
      if (demande != null) {
        state = state.copyWith(
          demande: demande.copyWith(
            poidsTotalEstimeKg: totals.calculerPoidsTotal(nextArticles),
            volumeTotalEstimeM3: totals.calculerVolumeTotal(nextArticles),
          ),
        );
      }
    } on FretException catch (error) {
      state = state.copyWith(
        saveState: SaveState.error,
        errorMessage: error.message,
      );
      rethrow;
    } catch (error) {
      state = state.copyWith(
        saveState: SaveState.error,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  Future<void> publier() async {
    final draftId = state.draftId;
    final demande = state.demande;
    if (draftId == null || demande == null) {
      return;
    }

    final service = ref.read(publicationServiceProvider);

    try {
      final published = await service.publish(draftId, demande: demande);
      state = state.copyWith(
        demande: published,
        saveState: SaveState.saved,
        errorMessage: null,
      );
    } on FretException catch (error) {
      state = state.copyWith(
        saveState: SaveState.error,
        errorMessage: error.message,
      );
      rethrow;
    } catch (error) {
      state = state.copyWith(
        saveState: SaveState.error,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }
}
