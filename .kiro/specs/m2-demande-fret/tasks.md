# Implementation Plan: M2 — Demande de Transport / Fret

## Overview

Implémentation du module M2 en Flutter/Dart avec Supabase. L'architecture suit un découpage en couches (domain / data / application / presentation) avec Riverpod pour la gestion d'état et Freezed pour les modèles immuables. Le workflow est : migration SQL → domaine Dart → repository → services → UI wizard → dashboard → navigation.

## Tasks

- [x] 1. Migration SQL Supabase et configuration du projet
  - [x] 1.1 Créer la migration SQL `supabase/migrations/YYYYMMDDHHMMSS_m2_fret.sql`
    - Créer la table `demandes_fret` avec toutes les colonnes, contraintes CHECK et valeurs par défaut (Exigence 1.1)
    - Créer la table `articles_fret` avec toutes les colonnes, contraintes CHECK et FK ON DELETE CASCADE (Exigence 1.2)
    - Créer les index de performance : `idx_demandes_fret_prestataire`, `idx_demandes_fret_statut`, `idx_articles_fret_demande` (Exigences 1.5, 1.6)
    - Activer RLS sur `demandes_fret` et créer les 4 politiques SELECT/INSERT/UPDATE/DELETE (Exigence 1.3)
    - Activer RLS sur `articles_fret` et créer la politique ALL déléguant à la demande parente (Exigence 1.4)
    - Ajouter un commentaire SQL documentant que les transitions `matchee`/`annulee`/`terminee` sont réservées au `service_role` (Exigence 1.7)
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7_

  - [x] 1.2 Ajouter les dépendances Dart au `pubspec.yaml`
    - Ajouter `flutter_riverpod: ^2.6.1`, `riverpod_annotation: ^2.6.1`, `freezed_annotation: ^2.4.4`
    - Ajouter en `dev_dependencies` : `freezed: ^2.5.7`, `build_runner: ^2.4.13`
    - _Requirements: 2.1, 2.2_

- [x] 2. Couche Domain — Enums, exceptions et modèles Freezed
  - [x] 2.1 Créer `lib/features/fret/domain/enums/fret_enums.dart`
    - Déclarer `StatutDemande` avec les valeurs `brouillon`, `publiee`, `matchee`, `annulee`, `terminee` et le getter `estNonModifiable` (true si publiee | matchee | terminee)
    - Déclarer `TypeVehicule` avec les 5 valeurs
    - Déclarer `CategorieArticle` avec les 6 valeurs
    - Déclarer `FretErrorCode` avec les 5 valeurs
    - _Requirements: 2.1, 2.2, 9.5_

  - [x] 2.2 Créer `lib/features/fret/domain/exceptions/fret_exception.dart`
    - Implémenter `FretException implements Exception` avec `code` (FretErrorCode) et `message` (String)
    - _Requirements: 2.9_

  - [x] 2.3 Créer les modèles Freezed `demande_fret.dart` et `article_fret.dart`
    - Créer `lib/features/fret/domain/models/demande_fret.dart` : classe `@freezed` `DemandeFret` avec tous les champs typés (Exigence 2.1), méthode `fromJson` et annotations `@JsonKey` pour le mapping snake_case ↔ camelCase
    - Créer `lib/features/fret/domain/models/article_fret.dart` : classe `@freezed` `ArticleFret` avec tous les champs typés (Exigence 2.2), méthode `fromJson` et annotations `@JsonKey`
    - _Requirements: 2.1, 2.2, 2.3, 2.4_

  - [x] 2.4 Créer les DTOs d'entrée dans `lib/features/fret/domain/models/fret_inputs.dart`
    - Créer `@freezed` `DemandeFretInput` avec uniquement les champs éditables
    - Créer `@freezed` `ArticleFretInput`
    - _Requirements: 2.1, 2.2_

  - [x] 2.5 Exécuter `flutter pub run build_runner build` pour générer les fichiers `.freezed.dart` et `.g.dart`
    - Vérifier l'absence d'erreurs de génération
    - _Requirements: 2.3, 2.4_

  - [x]* 2.6 Écrire le test property-based P1 — Round-trip DemandeFret
    - **Property 1 : Round-trip DemandeFret**
    - Fichier : `test/features/fret/domain/models/demande_fret_test.dart`
    - Générer des instances aléatoires de `DemandeFret`, vérifier `DemandeFret.fromJson(d.toJson()) == d` pour N ≥ 100 exemples
    - **Validates: Requirements 2.5**

  - [x]* 2.7 Écrire le test property-based P2 — Round-trip ArticleFret
    - **Property 2 : Round-trip ArticleFret**
    - Fichier : `test/features/fret/domain/models/article_fret_test.dart`
    - Générer des instances aléatoires de `ArticleFret`, vérifier `ArticleFret.fromJson(a.toJson()) == a` pour N ≥ 100 exemples
    - **Validates: Requirements 2.6**

  - [x] 2.8 Créer l'interface `lib/features/fret/domain/repositories/i_fret_repository.dart`
    - Déclarer `abstract interface class IFretRepository` avec toutes les signatures de méthodes (Exigences 2.7, 2.8)
    - _Requirements: 2.7, 2.8_

- [ ] 3. Couche Data — FretRepositoryImpl
  - [x] 3.1 Créer `lib/features/fret/data/repositories/fret_repository_impl.dart`
    - Implémenter `FretRepositoryImpl implements IFretRepository`
    - Implémenter `createDraft` : INSERT dans `demandes_fret` avec `id_prestataire = auth.uid()`, retourner `DemandeFret.fromJson()`
    - Implémenter `updateDraft` : vérifier `statut.estNonModifiable` → lever `FretException(DEMANDE_NON_MODIFIABLE)`, puis UPDATE
    - Implémenter `publish` : UPDATE atomique `statut = 'publiee'` uniquement
    - Implémenter `getDemande` : SELECT par id, retourner null si absent
    - Implémenter `listDemandes` : SELECT filtré optionnellement par `statut`, trié `date_creation DESC`
    - Implémenter `deleteDraft` : DELETE si statut = brouillon (RLS protège, lever FretException sur erreur)
    - _Requirements: 2.7_

  - [x] 3.2 Implémenter les méthodes d'articles dans `FretRepositoryImpl`
    - Implémenter `addArticle` : vérifier `demande.statut.estNonModifiable` → FretException, puis INSERT
    - Implémenter `updateArticle` : vérifier `demande.statut.estNonModifiable` → FretException, puis UPDATE
    - Implémenter `deleteArticle` : vérifier statut demande parente → FretException, puis DELETE
    - Implémenter `listArticles` : SELECT tous les articles d'une demande
    - Wrapper toutes les `PostgrestException` en `FretException(SUPABASE_ERROR)` dans un try/catch global
    - _Requirements: 2.8, 2.9, 9.5_

  - [ ]* 3.3 Écrire le test property-based P6 — Immutabilité des demandes non modifiables
    - **Property 6 : Immutabilité des demandes non modifiables**
    - Fichier : `test/features/fret/presentation/wizard_fret_notifier_test.dart`
    - Mocker `IFretRepository`, vérifier que `updateDraft`, `addArticle`, `updateArticle`, `deleteArticle` lèvent `FretException(DEMANDE_NON_MODIFIABLE)` pour tout statut dans `{publiee, matchee, terminee}`
    - **Validates: Requirements 9.5**

- [x] 4. Checkpoint — Couche domain et data
  - Lancer `flutter test test/features/fret/domain/` et vérifier que tous les tests passent.
  - Vérifier que `flutter analyze` ne retourne aucune erreur sur les fichiers créés.
  - Demander à l'utilisateur si des ajustements sont nécessaires avant de passer aux services.

- [ ] 5. Couche Application — TotauxCalculator
  - [x] 5.1 Créer `lib/features/fret/application/services/totaux_calculator.dart`
    - Implémenter `TotauxCalculator` comme service pur sans état
    - `calculerPoidsTotal(List<ArticleFret> articles)` : Σ(quantite × poidsUnitaireKg), arrondi HALF_UP 2 décimales
    - `calculerVolumeTotal(List<ArticleFret> articles)` : Σ(quantite × volumeUnitaireM3), arrondi HALF_UP 3 décimales
    - Retourner 0.0 si liste vide
    - _Requirements: 8.1, 8.2, 8.5, 8.6_

  - [ ]* 5.2 Écrire le test property-based P3 — Confluence des totaux
    - **Property 3 : Confluence des totaux**
    - Fichier : `test/features/fret/domain/services/totaux_calculator_test.dart`
    - Générer des listes aléatoires d'articles et toutes leurs permutations, vérifier l'égalité des totaux pour N ≥ 100 exemples
    - **Validates: Requirements 8.4**

  - [ ]* 5.3 Écrire le test property-based P4 — Neutralité de la liste vide
    - **Property 4 : Neutralité de la liste vide**
    - Fichier : `test/features/fret/domain/services/totaux_calculator_test.dart`
    - Vérifier que `calculerPoidsTotal([]) == 0.0` et `calculerVolumeTotal([]) == 0.0`
    - **Validates: Requirements 8.5**

  - [ ]* 5.4 Écrire le test property-based P5 — Arrondi HALF_UP correct
    - **Property 5 : Arrondi HALF_UP correct**
    - Fichier : `test/features/fret/domain/services/totaux_calculator_test.dart`
    - Pour des valeurs v ≥ 0 générées aléatoirement, vérifier `calculerPoidsTotal([article(qte=1, poids=v)]) == roundHalfUp(v, 2)` et idem pour volume
    - **Validates: Requirements 8.6**

- [x] 6. Couche Application — AutoSaveService
  - [x] 6.1 Créer `lib/features/fret/application/services/auto_save_service.dart`
    - Implémenter `AutoSaveService` avec l'enum `SaveState { saving, saved, error }`
    - Méthode `initDraft(String? existingId)` : si existingId null → `createDraft`, sinon `getDemande` ; si création échoue → lancer `AlertDialog` bloquant (Exigence 4.7)
    - Méthode `saveStep(String id, DemandeFretInput input)` : appel `updateDraft` avec timeout 2s, mettre à jour `SaveState` (Exigences 4.2, 4.6)
    - Méthode `saveArticleAdded/Updated/Deleted` : appels repository avec timeout 2s, mettre à jour `SaveState` (Exigence 4.3)
    - En cas d'échec timeout : passer à `SaveState.error`, notifier via callback/stream pour affichage snackbar non bloquant (Exigence 4.4)
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.6, 4.7_

  - [x] 6.2 Implémenter la logique de reprise de brouillon dans `AutoSaveService`
    - `listDrafts()` : appel `listDemandes(statut: StatutDemande.brouillon)`
    - Si 1 brouillon : proposer de reprendre (Exigence 4.5)
    - Si plusieurs brouillons : afficher liste de sélection (Exigence 4.5)
    - _Requirements: 4.5_

  - [x]* 6.3 Écrire les tests unitaires de `AutoSaveService`
    - Fichier : `test/features/fret/application/auto_save_service_test.dart`
    - Tester : timeout 2s → `SaveState.error`, états saving/saved/error, création initiale échoue → AlertDialog, reprise brouillon unique vs multiple
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7_

- [x] 7. Couche Application — PublicationService
  - [x] 7.1 Créer `lib/features/fret/application/services/publication_service.dart`
    - Implémenter la séquence de validation strictement ordonnée :
      1. Requête fraîche `profiles.statut_validation` → si ≠ `valide` → `FretException(KYC_INVALIDE)` (Exigence 5.1, 5.2)
      2. `listArticles(idDemande)` → si vide → `FretException(ARTICLE_MANQUANT)` (Exigence 5.3, 5.4)
      3. Si `necessiteFrigo && typeVehicule ≠ camion_frigo` → `FretException(FRIGO_VEHICULE_REQUIS)` (Exigence 5.5, 5.7)
      4. `repository.publish(idDemande)` → mise à jour atomique (Exigence 5.8)
      5. Émission événement `demande_publiee` via Supabase Realtime (Exigence 5.9)
    - Arrêt au premier échec, sans exécuter les vérifications suivantes
    - En cas d'échec Supabase sur publish : laisser statut à brouillon, retourner erreur (Exigence 5.10)
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.7, 5.8, 5.9, 5.10_

  - [x]* 7.2 Écrire le test property-based P7 — Séquentialité des validations de publication
    - **Property 7 : Séquentialité des validations de publication**
    - Fichier : `test/features/fret/application/publication_service_test.dart`
    - Avec mock `IFretRepository` et mock Supabase, vérifier les 4 cas de séquence :
      - KYC invalide → `FretException(KYC_INVALIDE)` (vérifications suivantes non exécutées)
      - KYC valide + articles vides → `FretException(ARTICLE_MANQUANT)`
      - KYC valide + articles présents + frigo violé → `FretException(FRIGO_VEHICULE_REQUIS)`
      - Toutes validations passées → `DemandeFret(statut=publiee)`
    - **Validates: Requirements 5.1, 5.3, 5.5**

- [x] 8. Providers Riverpod
  - [ ] 8.1 Créer `lib/features/fret/application/providers/fret_providers.dart`
    - Provider `fretRepositoryProvider` : instancie `FretRepositoryImpl(Supabase.instance.client)`
    - Provider `demandesListProvider` : `Future<List<DemandeFret>>` via `listDemandes()`
    - _Requirements: 6.1_

  - [x] 8.2 Créer `lib/features/fret/presentation/state/wizard_fret_notifier.dart`
    - Implémenter `WizardFretNotifier extends _$WizardFretNotifier` (Riverpod `@riverpod` class)
    - État : `currentStep`, `draftId`, `demande`, `articles`, `saveState`
    - Méthodes : `initDraft(String? existingId)`, `nextStep(DemandeFretInput input)`, `previousStep()`, `addArticle(ArticleFretInput)`, `updateArticle(String, ArticleFretInput)`, `deleteArticle(String)`, `publier()`
    - Déléguer les opérations à `AutoSaveService`, `TotauxCalculator` et `PublicationService`
    - Catch `FretException` → mise à jour état d'erreur Riverpod
    - _Requirements: 3.1, 4.1, 4.2, 4.3, 5.8, 8.3_

  - [x]* 8.3 Écrire les tests unitaires de `WizardFretNotifier`
    - Fichier : `test/features/fret/presentation/wizard_fret_notifier_test.dart`
    - Tester : transitions d'étapes, validation inline par étape, init brouillon, erreurs FretException
    - _Requirements: 3.2, 4.1_

- [x] 9. Checkpoint — Couche application
  - Lancer `flutter test test/features/fret/application/` et vérifier que tous les tests passent.
  - Vérifier que `flutter analyze` ne retourne aucune erreur.
  - Demander à l'utilisateur si des ajustements sont nécessaires avant de passer à l'UI.

- [x] 10. Navigation go_router
  - [x] 10.1 Créer `lib/features/fret/presentation/router/fret_router.dart`
    - Déclarer les routes : `/fret`, `/fret/new`, `/fret/:id/edit`, `/fret/:id` (Exigence 7.1)
    - Implémenter la garde d'authentification : redirection vers `/auth/login?redirect=<route_cible>` pour tout accès non authentifié (Exigence 7.2)
    - Implémenter la gestion erreur 404 brouillon sur `/fret/:id/edit` : `getDemande` null → `context.go('/fret')` + SnackBar "Demande introuvable" (Exigence 7.6)
    - _Requirements: 7.1, 7.2, 7.6_

  - [x] 10.2 Intégrer `fret_router` dans la bottom navigation existante
    - Positionner M2 sur l'onglet "Missions" (index 1) avec `/fret` comme route initiale (Exigence 7.5)
    - _Requirements: 7.5_

- [x] 11. Widgets communs et composants de base
  - [x] 11.1 Créer `lib/features/fret/presentation/widgets/mission_card.dart`
    - Afficher : itinéraire (A → B), date/heure départ, icône + label `TypeVehicule`, badge statut coloré (5 couleurs selon Exigence 6.2)
    - Tap → navigation `/fret/:id/edit` si brouillon, `/fret/:id` sinon (Exigences 6.4, 6.5)
    - _Requirements: 6.2, 6.4, 6.5_

  - [x] 11.2 Créer `lib/features/fret/presentation/widgets/kyc_banner_widget.dart`
    - Bannière non dismissible, texte "Votre identité n'est pas encore vérifiée", bouton CTA "Vérifier mon identité" (Exigence 6.3)
    - _Requirements: 6.3_

  - [x] 11.3 Créer `lib/features/fret/presentation/widgets/wizard_progress_indicator.dart`
    - Indicateur 4 étapes numérotées, met en valeur l'étape courante (Exigence 3.1)
    - _Requirements: 3.1_

  - [x] 11.4 Créer `lib/features/fret/presentation/widgets/wizard_save_state_header.dart`
    - Afficher 3 états : `saving` ("Sauvegarde…"), `saved` ("Brouillon sauvegardé"), `error` ("Échec de sauvegarde" + icône alerte) (Exigence 4.6)
    - _Requirements: 4.6_

  - [x] 11.5 Créer `lib/features/fret/presentation/widgets/vehicle_selection_grid.dart`
    - 5 cartes de sélection exclusive pour `TypeVehicule`
    - Avertissement RG3 inline si `necessiteFrigo && typeVehicule ≠ camion_frigo` (Exigences 3.6, 5.6)
    - _Requirements: 3.6, 5.6_

  - [x] 11.6 Créer `lib/features/fret/presentation/widgets/article_form_modal.dart`
    - Formulaire modal avec les champs : `designation` (max 200), `quantite` (> 0), `poids_unitaire_kg` (≥ 0, max 10 000), `volume_unitaire_m3` (≥ 0, max 1 000), `categorie` (dropdown), `manutention_speciale` (optionnel) (Exigence 3.9)
    - Validation inline et messages d'erreur sous chaque champ
    - _Requirements: 3.9, 3.3_

  - [x] 11.7 Créer `lib/features/fret/presentation/widgets/article_list_item.dart` et `totaux_widget.dart`
    - `article_list_item.dart` : désignation, quantité, poids ligne, volume ligne, catégorie avec `Dismissible` (swipe gauche → confirmation suppression) ; swipe désactivé si `statut.estNonModifiable` (Exigences 3.8, 9.6, 9.7)
    - `totaux_widget.dart` : affichage `poids_total_estime_kg` et `volume_total_estime_m3`, recalcul temps réel (Exigence 3.10)
    - _Requirements: 3.8, 3.10, 9.6, 9.7_

- [x] 12. Écran Dashboard
  - [x] 12.1 Créer `lib/features/fret/presentation/screens/dashboard_fret_screen.dart`
    - Intégrer `KycBannerWidget` (conditionnel si KYC non validé) (Exigence 6.3)
    - `RefreshIndicator` avec `AsyncValue<List<DemandeFret>>` géré par `demandesListProvider` (Exigences 6.1, 6.8)
    - État chargement : `CircularProgressIndicator` ; état erreur : `ErrorStateWidget` + retry ; état vide : message + CTA "Créer ma première demande" (Exigences 6.7, 6.8)
    - `ListView` de `MissionCard`, triées `date_creation DESC` (Exigence 6.1)
    - FAB "+ Publier une demande de fret" → `context.go('/fret/new')` (Exigence 6.6)
    - _Requirements: 6.1, 6.2, 6.3, 6.6, 6.7, 6.8_

- [x] 13. Écran Wizard — Structure principale
  - [x] 13.1 Créer `lib/features/fret/presentation/screens/wizard_fret_screen.dart`
    - `StatefulWidget` contenant `WizardSaveStateHeader`, `WizardProgressIndicator`, `PageView` (swipe désactivé, controller interne), `WizardNavigationBar`
    - `PopScope` pour intercepter le back système : afficher dialog de confirmation rappelant que le brouillon est sauvegardé (Exigence 7.4)
    - `BoutonPrecedent` UI : recul d'étape sans dialog (Exigence 7.3)
    - `BoutonContinuer` / `BoutonPublier` (étape 4)
    - Appel `WizardFretNotifier.initDraft()` au démarrage
    - _Requirements: 3.1, 4.1, 7.3, 7.4_

- [x] 14. Étapes du Wizard
  - [x] 14.1 Créer `Step1ItineraireView`
    - `TextFormField` adresse départ : trim, max 255, obligatoire (Exigence 3.4)
    - `TextFormField` adresse arrivée : trim, max 255, obligatoire (Exigence 3.4)
    - `DateTimePicker` départ : obligatoire, > now() + 1h (Exigence 3.4)
    - `SwitchListTile` "Retour prévu" + `DateTimePicker` retour conditionnel : doit être > dateDepart (Exigences 3.4, 3.5)
    - Validation inline avec messages d'erreur sous chaque champ (Exigence 3.3)
    - _Requirements: 3.2, 3.3, 3.4, 3.5_

  - [x] 14.2 Créer `Step2VehiculeBesoinsView`
    - Intégrer `VehicleSelectionGrid` (Exigence 3.6)
    - `SwitchListTile` "Froid requis" et "Manutention" (Exigences 3.6, 3.7)
    - `StepperManutentionnaires` visible uniquement si `necessiteManutention = true`, min 1 ; forcer `nb_manutentionnaires_requis = 0` si false (Exigences 3.6, 3.7)
    - Blocage étape 2→3 si `necessiteFrigo && typeVehicule ≠ camion_frigo` avec message inline RG3 (Exigence 3.14)
    - _Requirements: 3.6, 3.7, 3.14_

  - [x] 14.3 Créer `Step3InventaireView`
    - `ListView` avec `ArticleListItem` + `Dismissible` (Exigence 3.8)
    - Intégrer `TotauxWidget` (Exigence 3.10)
    - FAB "+ Ajouter un article" → `ArticleFormModal` ; désactivé si `articles.length ≥ 50` (Exigences 3.9, 3.13)
    - Bloquer ajout et afficher erreur si limite 50 articles atteinte (Exigence 3.13)
    - _Requirements: 3.8, 3.9, 3.10, 3.13_

  - [x] 14.4 Créer `Step4RecapitulatifView`
    - Synthèse complète : itinéraire, date/heure, type véhicule, besoins spécifiques, nb articles, poids total, volume total, description complémentaire (Exigence 3.11)
    - Boutons "Modifier" par section → retour à l'étape correspondante ; masqués si `statut.estNonModifiable` (Exigences 3.12, 3.15)
    - Bouton "Publier la demande" → `WizardFretNotifier.publier()` → gestion des `FretException` avec messages utilisateur (Exigences 5.1–5.10)
    - _Requirements: 3.11, 3.12, 3.15, 5.1, 5.2, 5.4, 5.7, 5.8, 5.10_

- [x] 15. Écran stub détail demande publiée
  - [x] 15.1 Créer `lib/features/fret/presentation/screens/fret_detail_screen.dart`
    - Stub minimaliste pour la route `/fret/:id` (point d'entrée M3), afficher l'`id` de la demande en attendant M3
    - _Requirements: 6.5, 7.1_

- [x] 16. Intégration finale et recalcul atomique des totaux
  - [x] 16.1 Intégrer `TotauxCalculator` dans `FretRepositoryImpl` pour le recalcul atomique
    - Après chaque `addArticle`, `updateArticle`, `deleteArticle` : appeler `TotauxCalculator`, puis UPDATE `demandes_fret.poids_total_estime_kg` et `volume_total_estime_m3` dans la même transaction Supabase (Exigence 8.3)
    - Utiliser une fonction RPC Supabase ou une transaction `supabase.rpc()` pour garantir l'atomicité
    - _Requirements: 8.1, 8.2, 8.3, 8.6_

  - [x] 16.2 Câbler tous les composants dans `WizardFretNotifier`
    - Connecter `AutoSaveService`, `PublicationService`, `TotauxCalculator` et `FretRepositoryImpl` via les providers Riverpod
    - Vérifier que `nextStep()` déclenche l'auto-sauvegarde et met à jour `SaveState` dans le header
    - Vérifier que `addArticle/updateArticle/deleteArticle()` déclenchent le recalcul temps réel du `TotauxWidget`
    - _Requirements: 4.2, 4.3, 8.3_

- [x] 17. Checkpoint final — Intégration complète
  - Lancer `flutter test` pour exécuter la totalité de la suite de tests.
  - Lancer `flutter analyze` pour vérifier l'absence d'erreurs statiques.
  - Vérifier que `build_runner` ne produit pas de fichiers en conflit.
  - Demander à l'utilisateur si des ajustements sont nécessaires avant de considérer M2 terminé.

## Notes

- Les tâches marquées `*` sont optionnelles et peuvent être sautées pour un MVP plus rapide
- Chaque tâche référence les exigences spécifiques pour la traçabilité
- Les checkpoints garantissent une validation incrémentale à chaque couche
- Les tests property-based (P1–P7) valident les propriétés universelles définies dans le design
- Les tests unitaires valident les cas spécifiques et les conditions limites
- Lancer `flutter pub run build_runner build --delete-conflicting-outputs` si des conflits de génération apparaissent
- La migration SQL doit être appliquée via `supabase db push` ou `supabase migration up` avant les tests d'intégration
- Les tests d'intégration nécessitent un environnement Supabase local (`supabase start`)

## Task Dependency Graph

```json
{
  "waves": [
    { "id": 0, "tasks": ["1.1", "1.2"] },
    { "id": 1, "tasks": ["2.1", "2.2"] },
    { "id": 2, "tasks": ["2.3", "2.4"] },
    { "id": 3, "tasks": ["2.5"] },
    { "id": 4, "tasks": ["2.6", "2.7", "2.8"] },
    { "id": 5, "tasks": ["3.1"] },
    { "id": 6, "tasks": ["3.2"] },
    { "id": 7, "tasks": ["3.3", "5.1"] },
    { "id": 8, "tasks": ["5.2", "5.3", "5.4", "8.1"] },
    { "id": 9, "tasks": ["6.1", "7.1"] },
    { "id": 10, "tasks": ["6.2", "6.3", "7.2", "8.2"] },
    { "id": 11, "tasks": ["6.3", "8.3", "10.1"] },
    { "id": 12, "tasks": ["10.2", "11.1", "11.2", "11.3", "11.4", "11.5", "11.6", "11.7"] },
    { "id": 13, "tasks": ["12.1", "13.1"] },
    { "id": 14, "tasks": ["14.1", "14.2", "15.1"] },
    { "id": 15, "tasks": ["14.3"] },
    { "id": 16, "tasks": ["14.4"] },
    { "id": 17, "tasks": ["16.1"] },
    { "id": 18, "tasks": ["16.2"] }
  ]
}
```
