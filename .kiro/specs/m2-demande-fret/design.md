# Document de Design Technique — M2 Demande de Transport / Fret

## Overview

Le module M2 permet au prestataire événementiel de créer, gérer et publier des demandes de transport de fret depuis l'application mobile Lova-Events (Flutter + Supabase). Il couvre l'intégralité du cycle de vie d'une demande : de la saisie initiale en brouillon jusqu'à la publication qui déclenche le module M3 (matching).

Le module s'appuie sur deux tables Supabase (`demandes_fret` et `articles_fret`), une architecture Flutter en couches (domain / data / application / presentation), et expose un Wizard 4 étapes avec auto-sauvegarde.

**Stack technique :**
- Flutter + Dart (SDK ^3.12.2)
- Supabase (supabase_flutter ^2.17.2) — base de données + RLS + Realtime
- go_router ^18.0.0 — navigation déclarative
- Riverpod — gestion d'état réactive
- Freezed — modèles Dart immuables avec sérialisation JSON

---

## Architecture

### Vue en couches

```
┌─────────────────────────────────────────────────────────────┐
│                     COUCHE UI (Widgets)                     │
│  DashboardFretScreen │ WizardFretScreen │ MissionCard       │
└────────────────────────────┬────────────────────────────────┘
                             │ (Riverpod Notifiers)
┌────────────────────────────▼────────────────────────────────┐
│                  COUCHE APPLICATION (Services)              │
│  AutoSaveService │ PublicationService │ TotauxCalculator    │
└────────────────────────────┬────────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────────┐
│                   COUCHE DONNÉES (Repository)               │
│              IFretRepository (interface + impl)             │
└────────────────────────────┬────────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────────┐
│                  INFRASTRUCTURE (Supabase)                  │
│         SupabaseClient │ demandes_fret │ articles_fret      │
└─────────────────────────────────────────────────────────────┘
```

### Intégration inter-modules

```
M1 (profiles)
    │  profiles.id = id_prestataire
    │  profiles.statut_validation (KYC check)
    ▼
M2 (demandes_fret, articles_fret)
    │  événement demande_publiee via Supabase Realtime
    ▼
M3 (Matching / Réservation) — hors scope M2
```

### Packages à ajouter au pubspec.yaml

Le projet dispose déjà de `supabase_flutter`, `go_router` et `flutter_dotenv`. M2 nécessite d'ajouter :

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
  freezed_annotation: ^2.4.4

dev_dependencies:
  freezed: ^2.5.7
  build_runner: ^2.4.13
```

### Navigation go_router

Routes M2 déclarées dans `lib/features/fret/presentation/router/fret_router.dart` :

| Route | Écran |
|-------|-------|
| `/fret` | Dashboard — liste des demandes |
| `/fret/new` | Wizard création (étape 1) |
| `/fret/:id/edit` | Wizard reprise brouillon (étape mémorisée) |
| `/fret/:id` | Détail demande publiée (point d'entrée M3) |

Les 4 étapes du Wizard sont gérées via l'état interne du widget (PageView) sans sous-routes. L'URL reste stable (`/fret/new` ou `/fret/:id/edit`) pendant la saisie.

**Garde d'authentification :** tout accès non authentifié aux routes `/fret/*` redirige vers `/auth/login?redirect=<route_cible>`.

**Erreur 404 brouillon :** si `getDemande(id)` retourne `null` sur `/fret/:id/edit`, rediriger vers `/fret` avec un SnackBar "Demande introuvable".

La bottom navigation positionne M2 sur l'onglet "Missions" (index 1), `/fret` étant la route initiale de cet onglet.

### Schéma de base de données

Migration SQL : `supabase/migrations/YYYYMMDDHHMMSS_m2_fret.sql`

```sql
CREATE TABLE IF NOT EXISTS public.demandes_fret (
  id                          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  id_prestataire              uuid        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  adresse_depart              text        NOT NULL,
  adresse_arrivee             text        NOT NULL,
  date_heure_souhaitee_depart timestamptz NOT NULL,
  date_heure_retour_prevue    timestamptz,
  type_vehicule_requis        text        NOT NULL
    CHECK (type_vehicule_requis IN ('fourgon','camion_plateau','camion_frigo','camion_benne','indifferent')),
  poids_total_estime_kg       numeric(10,2) NOT NULL DEFAULT 0,
  volume_total_estime_m3      numeric(10,3) NOT NULL DEFAULT 0,
  fragile                     boolean     NOT NULL DEFAULT false,
  necessite_frigo             boolean     NOT NULL DEFAULT false,
  necessite_manutention       boolean     NOT NULL DEFAULT false,
  nb_manutentionnaires_requis integer     NOT NULL DEFAULT 0
    CHECK (nb_manutentionnaires_requis >= 0 AND nb_manutentionnaires_requis <= 99),
  description_complementaire  text,
  statut                      text        NOT NULL DEFAULT 'brouillon'
    CHECK (statut IN ('brouillon','publiee','matchee','annulee','terminee')),
  date_creation               timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.articles_fret (
  id                  uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  id_demande          uuid        NOT NULL REFERENCES public.demandes_fret(id) ON DELETE CASCADE,
  designation         text        NOT NULL,
  quantite            integer     NOT NULL CHECK (quantite > 0),
  poids_unitaire_kg   numeric(10,2) NOT NULL CHECK (poids_unitaire_kg >= 0),
  volume_unitaire_m3  numeric(10,3) NOT NULL CHECK (volume_unitaire_m3 >= 0),
  categorie           text        NOT NULL
    CHECK (categorie IN ('mobilier','sonorisation_eclairage','decoration',
                         'materiel_traiteur','structure_tente','autre')),
  manutention_speciale text
);

-- Index de performance
CREATE INDEX IF NOT EXISTS idx_demandes_fret_prestataire ON public.demandes_fret(id_prestataire);
CREATE INDEX IF NOT EXISTS idx_demandes_fret_statut       ON public.demandes_fret(statut);
CREATE INDEX IF NOT EXISTS idx_articles_fret_demande      ON public.articles_fret(id_demande);

-- RLS demandes_fret
ALTER TABLE public.demandes_fret ENABLE ROW LEVEL SECURITY;
CREATE POLICY "demandes_fret_select" ON public.demandes_fret FOR SELECT
  USING (auth.uid() = id_prestataire);
CREATE POLICY "demandes_fret_insert" ON public.demandes_fret FOR INSERT
  WITH CHECK (auth.uid() = id_prestataire);
CREATE POLICY "demandes_fret_update" ON public.demandes_fret FOR UPDATE
  USING (auth.uid() = id_prestataire AND statut IN ('brouillon','publiee'))
  WITH CHECK (auth.uid() = id_prestataire);
CREATE POLICY "demandes_fret_delete" ON public.demandes_fret FOR DELETE
  USING (auth.uid() = id_prestataire AND statut = 'brouillon');

-- RLS articles_fret (délégation à la demande parente)
ALTER TABLE public.articles_fret ENABLE ROW LEVEL SECURITY;
CREATE POLICY "articles_fret_all" ON public.articles_fret FOR ALL
  USING (EXISTS (
    SELECT 1 FROM public.demandes_fret d
    WHERE d.id = id_demande AND d.id_prestataire = auth.uid()
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM public.demandes_fret d
    WHERE d.id = id_demande AND d.id_prestataire = auth.uid()
  ));
```

> Les transitions `matchee`, `annulee` et `terminee` sont réservées aux services backend utilisant le rôle `service_role` Supabase (M3 ou service dédié), contournant la RLS. Le prestataire ne peut pas passer une demande à ces statuts via le client.

---

## Components and Interfaces

### Arbre de widgets du Wizard

```
WizardFretScreen (StatefulWidget)
├── WizardSaveStateHeader     ← indicateur saving / sauvegardé / erreur
├── WizardProgressIndicator   ← 4 étapes numérotées
├── PageView (controller interne, swipe désactivé)
│   ├── Step1ItineraireView
│   ├── Step2VehiculeBesoinsView
│   ├── Step3InventaireView
│   └── Step4RecapitulatifView
├── WizardNavigationBar
│   ├── BoutonPrecedent  (recul d'étape uniquement, sans dialog)
│   └── BoutonContinuer / BoutonPublier (étape 4)
└── PopScope             ← dialog confirmation back système
```

### Détail des étapes du Wizard

**Étape 1 — Itinéraire**
- `TextFormField` adresse départ : obligatoire, trim, max 255 chars
- `TextFormField` adresse arrivée : obligatoire, trim, max 255 chars
- `DateTimePicker` départ : obligatoire, doit être `> now() + 1h`
- `SwitchListTile` "Retour prévu" : active le champ date de retour
- `DateTimePicker` retour (conditionnel) : doit être `> dateDepart`

**Étape 2 — Véhicule & besoins**
- `VehicleSelectionGrid` : 5 cartes exclusives (fourgon, camion_plateau, camion_frigo, camion_benne, indifferent)
- `SwitchListTile` "Froid requis" : si true + véhicule ≠ camion_frigo → avertissement RG3 inline
- `SwitchListTile` "Manutention" : si true → affiche `StepperManutentionnaires` (min 1, max 99)
- Blocage étape 2→3 si `necessiteFrigo && typeVehicule ≠ camion_frigo`

**Étape 3 — Inventaire**
- `ListView` articles avec `Dismissible` (swipe gauche → suppression avec confirmation)
- Swipe désactivé si `demande.statut.estNonModifiable`
- `TotauxWidget` (poids_total + volume_total, recalcul temps réel)
- FAB "+ Ajouter un article" → `ArticleFormModal` (désactivé si articles.length ≥ 50)

**Étape 4 — Récapitulatif**
- Synthèse par sections : itinéraire, véhicule, inventaire, description
- Bouton "Modifier" par section → retour à l'étape correspondante (masqué si statut non brouillon)
- Bouton "Publier la demande" → déclenche `PublicationService`

### Dashboard

```
DashboardFretScreen
├── KycBannerWidget      ← non dismissible, visible si KYC non validé
├── RefreshIndicator (pull-to-refresh)
│   └── AsyncValue<List<DemandeFret>>
│       ├── loading → CircularProgressIndicator
│       ├── error   → ErrorStateWidget + retry
│       └── data
│           ├── vide  → EmptyStateWidget + CTA "Créer ma première demande"
│           └── liste → ListView des MissionCard (triées date_creation DESC)
└── FAB "+ Publier une demande de fret" → context.go('/fret/new')
```

`MissionCard` affiche : itinéraire (A → B), date/heure départ, icône + label type véhicule, badge statut coloré. Tap → navigation selon statut (`/fret/:id/edit` pour brouillon, `/fret/:id` pour les autres).

Couleurs des badges de statut :

| Statut    | Couleur          |
|-----------|------------------|
| brouillon | gris             |
| publiee   | cyan électrique  |
| matchee   | vert             |
| annulee   | rouge            |
| terminee  | gris foncé       |

### Services

**AutoSaveService**
- Crée le brouillon initial dès l'ouverture du Wizard (avant toute saisie)
- Persiste les données à chaque changement d'étape (SLA 2s, timeout Supabase)
- Gère l'état `SaveState { saving, saved, error }` exposé au header du Wizard
- Si la création initiale échoue : bloque l'ouverture avec une `AlertDialog` d'erreur
- Si une sauvegarde ultérieure échoue : affiche un SnackBar non bloquant

**PublicationService** — séquence de validation strictement ordonnée :
1. Requête fraîche `profiles.statut_validation` → si ≠ `valide` : `FretException(KYC_INVALIDE)`
2. `listArticles(idDemande)` → si vide : `FretException(ARTICLE_MANQUANT)` + redirection étape 3
3. Si `necessiteFrigo && typeVehicule ≠ camion_frigo` : `FretException(FRIGO_VEHICULE_REQUIS)`
4. `repository.publish(idDemande)` — mise à jour atomique `statut = 'publiee'`
5. Émission événement `demande_publiee` via Supabase Realtime (canal consommé par M3)

**TotauxCalculator** — service pur sans état :
- `calculerPoidsTotal(articles)` = Σ(quantite × poidsUnitaireKg), arrondi HALF_UP 2 décimales
- `calculerVolumeTotal(articles)` = Σ(quantite × volumeUnitaireM3), arrondi HALF_UP 3 décimales
- Résultats identiques quel que soit l'ordre des articles (confluence)
- Liste vide → retourne 0.0 pour les deux totaux

### Providers Riverpod

```dart
// Repository
@riverpod
IFretRepository fretRepository(ref) => FretRepositoryImpl(Supabase.instance.client);

// Dashboard
@riverpod
Future<List<DemandeFret>> demandesList(ref) =>
    ref.watch(fretRepositoryProvider).listDemandes();

// Wizard state
@riverpod
class WizardFretNotifier extends _$WizardFretNotifier {
  // currentStep, draftId, demande, articles, saveState
  Future<void> initDraft(String? existingId);
  Future<void> nextStep(DemandeFretInput input);
  void previousStep();
  Future<void> addArticle(ArticleFretInput input);
  Future<void> updateArticle(String id, ArticleFretInput input);
  Future<void> deleteArticle(String id);
  Future<DemandeFret> publier();
}
```

---

## Data Models

### Enumerations

```dart
// lib/features/fret/domain/enums/fret_enums.dart

enum StatutDemande { brouillon, publiee, matchee, annulee, terminee }
// StatutDemande.estNonModifiable → true si publiee | matchee | terminee

enum TypeVehicule { fourgon, camion_plateau, camion_frigo, camion_benne, indifferent }

enum CategorieArticle {
  mobilier, sonorisation_eclairage, decoration,
  materiel_traiteur, structure_tente, autre
}

enum FretErrorCode {
  DEMANDE_NON_MODIFIABLE, KYC_INVALIDE,
  FRIGO_VEHICULE_REQUIS, ARTICLE_MANQUANT, SUPABASE_ERROR
}
```

### DemandeFret (modèle immuable Freezed)

```dart
@freezed
class DemandeFret with _$DemandeFret {
  const factory DemandeFret({
    required String id,
    required String idPrestataire,
    required String adresseDepart,
    required String adresseArrivee,
    required DateTime dateHeureSouhaiteeDepart,
    DateTime? dateHeureRetourPrevue,
    required TypeVehicule typeVehiculeRequis,
    @Default(0.0) double poidsTotalEstimeKg,
    @Default(0.0) double volumeTotalEstimeM3,
    @Default(false) bool fragile,
    @Default(false) bool necessiteFrigo,
    @Default(false) bool necessiteManutention,
    @Default(0) int nbManutentionnairesRequis,
    String? descriptionComplementaire,
    @Default(StatutDemande.brouillon) StatutDemande statut,
    required DateTime dateCreation,
  }) = _DemandeFret;

  factory DemandeFret.fromJson(Map<String, dynamic> json) => _$DemandeFretFromJson(json);
}
```

### ArticleFret (modèle immuable Freezed)

```dart
@freezed
class ArticleFret with _$ArticleFret {
  const factory ArticleFret({
    required String id,
    required String idDemande,
    required String designation,
    required int quantite,
    required double poidsUnitaireKg,
    required double volumeUnitaireM3,
    required CategorieArticle categorie,
    String? manutentionSpeciale,
  }) = _ArticleFret;

  factory ArticleFret.fromJson(Map<String, dynamic> json) => _$ArticleFretFromJson(json);
}
```

### DTOs d'entrée

```dart
@freezed
class DemandeFretInput with _$DemandeFretInput {
  // Champs éditables uniquement (hors id, id_prestataire, statut, date_creation, totaux)
  const factory DemandeFretInput({
    required String adresseDepart,
    required String adresseArrivee,
    required DateTime dateHeureSouhaiteeDepart,
    DateTime? dateHeureRetourPrevue,
    required TypeVehicule typeVehiculeRequis,
    @Default(false) bool fragile,
    @Default(false) bool necessiteFrigo,
    @Default(false) bool necessiteManutention,
    @Default(0) int nbManutentionnairesRequis,
    String? descriptionComplementaire,
  }) = _DemandeFretInput;
}

@freezed
class ArticleFretInput with _$ArticleFretInput {
  const factory ArticleFretInput({
    required String idDemande,
    required String designation,
    required int quantite,
    required double poidsUnitaireKg,
    required double volumeUnitaireM3,
    required CategorieArticle categorie,
    String? manutentionSpeciale,
  }) = _ArticleFretInput;
}
```

### Interface IFretRepository

```dart
abstract interface class IFretRepository {
  Future<DemandeFret> createDraft(DemandeFretInput input);
  Future<DemandeFret> updateDraft(String id, DemandeFretInput input);
  Future<DemandeFret> publish(String id);
  Future<DemandeFret?> getDemande(String id);
  Future<List<DemandeFret>> listDemandes({StatutDemande? statut});
  Future<void> deleteDraft(String id);

  Future<ArticleFret> addArticle(ArticleFretInput input);
  Future<ArticleFret> updateArticle(String id, ArticleFretInput input);
  Future<void> deleteArticle(String id);
  Future<List<ArticleFret>> listArticles(String idDemande);
}
```

### Mapping JSON ↔ Supabase (snake_case ↔ camelCase)

| Colonne Supabase | Champ Dart |
|-----------------|------------|
| `id_prestataire` | `idPrestataire` |
| `adresse_depart` | `adresseDepart` |
| `adresse_arrivee` | `adresseArrivee` |
| `date_heure_souhaitee_depart` | `dateHeureSouhaiteeDepart` |
| `date_heure_retour_prevue` | `dateHeureRetourPrevue` |
| `type_vehicule_requis` | `typeVehiculeRequis` |
| `poids_total_estime_kg` | `poidsTotalEstimeKg` |
| `volume_total_estime_m3` | `volumeTotalEstimeM3` |
| `necessite_frigo` | `necessiteFrigo` |
| `necessite_manutention` | `necessiteManutention` |
| `nb_manutentionnaires_requis` | `nbManutentionnairesRequis` |
| `description_complementaire` | `descriptionComplementaire` |
| `date_creation` | `dateCreation` |
| `id_demande` | `idDemande` |
| `poids_unitaire_kg` | `poidsUnitaireKg` |
| `volume_unitaire_m3` | `volumeUnitaireM3` |
| `manutention_speciale` | `manutentionSpeciale` |

La sérialisation Freezed gère ce mapping via les annotations `@JsonKey(name: 'snake_case_field')` ou via une configuration `build.yaml`.

---

## Correctness Properties

Ces propriétés sont formalisées et vérifiables par Property-Based Testing (PBT) avec le package `test` et des générateurs aléatoires.

### Property 1: Round-trip DemandeFret

Pour tout objet `DemandeFret d`, la sérialisation suivie de la désérialisation produit un objet structurellement équivalent :
```
DemandeFret.fromJson(d.toJson()) == d
```

**Validates: Requirements 2.5**

### Property 2: Round-trip ArticleFret

Pour tout objet `ArticleFret a`, la sérialisation suivie de la désérialisation produit un objet structurellement équivalent :
```
ArticleFret.fromJson(a.toJson()) == a
```

**Validates: Requirements 2.6**

### Property 3: Confluence des totaux

Pour toute liste d'articles et toute permutation `p` de cette liste, les totaux calculés sont identiques :
```
calculerPoidsTotal(articles) == calculerPoidsTotal(p(articles))
calculerVolumeTotal(articles) == calculerVolumeTotal(p(articles))
```

**Validates: Requirements 8.4**

### Property 4: Neutralité de la liste vide

Lorsqu'aucun article n'est associé à une demande, les deux totaux valent zéro :
```
calculerPoidsTotal([]) == 0.0
calculerVolumeTotal([]) == 0.0
```

**Validates: Requirements 8.5**

### Property 5: Arrondi HALF_UP correct

Pour toute valeur `v ≥ 0`, le calcul d'un article unitaire produit la valeur arrondie selon la règle HALF_UP :
```
calculerPoidsTotal([article(qte=1, poids=v)]) == roundHalfUp(v, 2)
calculerVolumeTotal([article(qte=1, vol=v)])  == roundHalfUp(v, 3)
```

**Validates: Requirements 8.6**

### Property 6: Immutabilité des demandes non modifiables

Lorsque `demande.statut ∈ {publiee, matchee, terminee}`, toute tentative de mutation lève `FretException(DEMANDE_NON_MODIFIABLE)` :
```
updateDraft(id, input)                    → FretException(DEMANDE_NON_MODIFIABLE)
addArticle(ArticleFretInput(idDemande=id)) → FretException(DEMANDE_NON_MODIFIABLE)
updateArticle(id, input)                  → FretException(DEMANDE_NON_MODIFIABLE)
deleteArticle(id)                         → FretException(DEMANDE_NON_MODIFIABLE)
```

**Validates: Requirements 9.5**

### Property 7: Séquentialité des validations de publication

Les validations de publication s'arrêtent au premier échec et produisent le code d'erreur correspondant :
```
Si KYC invalide                              → FretException(KYC_INVALIDE)
Si KYC valide ET articles vides              → FretException(ARTICLE_MANQUANT)
Si KYC valide ET articles présents ET frigo violé → FretException(FRIGO_VEHICULE_REQUIS)
Si toutes validations passées                → DemandeFret(statut=publiee)
```

**Validates: Requirements 5.1, 5.3, 5.5**

---

## Error Handling

### FretException

Toute erreur métier ou Supabase est encapsulée dans `FretException` :

```dart
class FretException implements Exception {
  const FretException({required this.code, required this.message});
  final FretErrorCode code;
  final String message;
}
```

### Stratégie par couche

| Couche | Comportement |
|--------|-------------|
| `FretRepositoryImpl` | Capture toute `PostgrestException` / `AuthException` → `FretException(SUPABASE_ERROR, message_original)` |
| `FretRepositoryImpl` | Vérifie `statut.estNonModifiable` avant mutation → `FretException(DEMANDE_NON_MODIFIABLE)` |
| `PublicationService` | Vérifications séquentielles KYC/articles/frigo → codes spécifiques |
| `AutoSaveService` | Timeout 2s → `SaveState.error` + SnackBar non bloquant (sauf création initiale) |
| `AutoSaveService` | Échec création initiale → `AlertDialog` bloquant avec retry |
| `WizardFretNotifier` | Catch `FretException` → mise à jour état d'erreur Riverpod → affichage UI |
| `Router_M2` | `getDemande` null/erreur sur `/fret/:id/edit` → `context.go('/fret')` + SnackBar |

### Messages utilisateur (couche présentation)

| Code erreur | Message affiché |
|------------|-----------------|
| `KYC_INVALIDE` | "Votre identité n'est pas encore vérifiée. Complétez votre vérification KYC pour publier." |
| `ARTICLE_MANQUANT` | "Vous devez ajouter au moins un article avant de publier." → redirection étape 3 |
| `FRIGO_VEHICULE_REQUIS` | "Un véhicule de type camion frigo est obligatoire lorsque le froid est requis." |
| `DEMANDE_NON_MODIFIABLE` | "Cette demande ne peut plus être modifiée." |
| `SUPABASE_ERROR` | "Une erreur technique est survenue. Veuillez réessayer." |

---

## Testing Strategy

### Tests unitaires

| Composant | Scénarios |
|-----------|-----------|
| `TotauxCalculator` | P3, P4, P5 + cas limites (0 kg, 0 article, max 10 000 kg, max 1 000 m³) |
| `DemandeFret` fromJson/toJson | P1 avec fixtures JSON Supabase réels |
| `ArticleFret` fromJson/toJson | P2 avec fixtures |
| `PublicationService` | P7 — 4 cas de séquence, avec mock `IFretRepository` et mock Supabase |
| `AutoSaveService` | Timeout 2s, états saving/saved/error, création initiale, reprise brouillon |
| `WizardFretNotifier` | Transitions d'étapes, validation inline par étape, init brouillon |

### Tests Property-Based

Les propriétés P1 à P7 sont implémentées avec des générateurs aléatoires :
- Générateurs pour `DemandeFret`, `ArticleFret`, `DemandeFretInput`, `ArticleFretInput`
- Vérification avec N ≥ 100 exemples générés aléatoirement
- Cas dégénérés : listes vides, valeurs maximales, chaînes vides, dates limites

### Tests d'intégration

Avec Supabase local (`supabase start`) :
- Flow complet wizard : création brouillon → saisie 4 étapes → publication → vérification statut
- RLS isolation : prestataire A ne peut pas lire/modifier les demandes du prestataire B
- Cohérence totaux : après N mutations d'articles, `demandes_fret.poids_total_estime_kg` == somme calculée localement
- Cascade delete : suppression `demandes_fret` → suppression automatique `articles_fret`

### Structure des fichiers de test

```
test/
└── features/
    └── fret/
        ├── domain/
        │   ├── models/
        │   │   ├── demande_fret_test.dart        ← P1 round-trip
        │   │   └── article_fret_test.dart         ← P2 round-trip
        │   └── services/
        │       └── totaux_calculator_test.dart    ← P3 P4 P5
        ├── application/
        │   ├── publication_service_test.dart      ← P7
        │   └── auto_save_service_test.dart
        ├── presentation/
        │   └── wizard_fret_notifier_test.dart     ← P6 transitions
        └── integration/
            └── fret_repository_integration_test.dart
```

### Structure des fichiers sources

```
lib/features/fret/
├── domain/
│   ├── enums/fret_enums.dart
│   ├── exceptions/fret_exception.dart
│   ├── models/
│   │   ├── demande_fret.dart + .freezed.dart + .g.dart
│   │   ├── article_fret.dart + .freezed.dart + .g.dart
│   │   └── fret_inputs.dart + .freezed.dart
│   └── repositories/i_fret_repository.dart
├── data/
│   └── repositories/fret_repository_impl.dart
├── application/
│   ├── providers/fret_providers.dart
│   └── services/
│       ├── auto_save_service.dart
│       ├── publication_service.dart
│       └── totaux_calculator.dart
└── presentation/
    ├── router/fret_router.dart
    ├── screens/
    │   ├── dashboard_fret_screen.dart
    │   ├── wizard_fret_screen.dart
    │   └── fret_detail_screen.dart   ← stub point d'entrée M3
    ├── state/wizard_fret_notifier.dart
    └── widgets/
        ├── mission_card.dart
        ├── kyc_banner_widget.dart
        ├── wizard_progress_indicator.dart
        ├── wizard_save_state_header.dart
        ├── vehicle_selection_grid.dart
        ├── article_list_item.dart
        ├── article_form_modal.dart
        └── totaux_widget.dart
```
