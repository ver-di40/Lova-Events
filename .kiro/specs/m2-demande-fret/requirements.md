# Requirements Document

## M2 — Demande de Transport / Fret

## Introduction

Le module M2 permet au prestataire événementiel de créer, gérer et publier des demandes de transport
de fret depuis l'application mobile Lova-Events (Flutter + Supabase). Il couvre l'intégralité du
cycle de vie d'une demande : de la saisie initiale en brouillon jusqu'à la publication qui déclenche
le module M3 (matching). Le module repose sur deux entités principales — `DEMANDE_FRET` et
`ARTICLE_FRET` — et s'intègre aux tables Supabase existantes (`profiles`) via la clé pivot
`id_prestataire`.

---

## Glossary

- **Wizard_Fret** : Formulaire multi-étapes (4 étapes) pour la création d'une demande de fret.
- **Demande_Fret** : Entité principale représentant un besoin de transport logistique événementiel.
- **Article_Fret** : Entité représentant un article individuel à transporter, rattaché à une Demande_Fret.
- **Repository_Fret** : Couche d'accès aux données Dart, encapsulant toutes les requêtes Supabase pour les tables `demandes_fret` et `articles_fret`.
- **Statut_Demande** : Cycle de vie d'une Demande_Fret : `brouillon`, `publiee`, `matchee`, `annulee`, `terminee`.
- **Type_Vehicule** : Enumération des types de véhicules requis : `fourgon`, `camion_plateau`, `camion_frigo`, `camion_benne`, `indifferent`.
- **Categorie_Article** : Enumération des catégories d'articles : `mobilier`, `sonorisation_eclairage`, `decoration`, `materiel_traiteur`, `structure_tente`, `autre`.
- **KYC** : Processus de vérification d'identité du prestataire. Un prestataire est validé KYC si son champ `statut_validation` dans `profiles` vaut `valide`.
- **Prestataire** : Utilisateur authentifié avec le rôle prestataire événementiel, identifié par `profiles.id`.
- **M3** : Module Matching / Réservation consommant l'`id_demande` des Demandes_Fret publiées.
- **RLS** : Row Level Security — politique de sécurité Supabase appliquée au niveau des lignes de table.
- **Auto-sauvegarde** : Mécanisme de persistance automatique de l'état courant du Wizard_Fret en tant que brouillon à chaque changement d'étape.
- **MissionCard** : Composant UI affichant une Demande_Fret sur le dashboard avec son statut, son itinéraire et son type de véhicule.
- **DemandeFretInput** : Objet de transfert Dart utilisé pour créer ou mettre à jour une Demande_Fret. Contient tous les champs éditables (hors `id`, `id_prestataire`, `statut`, `date_creation`, `poids_total_estime_kg`, `volume_total_estime_m3`) : `adresseDepart`, `adresseArrivee`, `dateHeureSouhaiteeDepart`, `dateHeureRetourPrevue`, `typeVehiculeRequis`, `fragile`, `necessiteFrigo`, `necessiteManutention`, `nbManutentionnairesRequis`, `descriptionComplementaire`.
- **ArticleFretInput** : Objet de transfert Dart utilisé pour créer ou mettre à jour un Article_Fret. Contient : `idDemande`, `designation`, `quantite`, `poidsUnitaireKg`, `volumeUnitaireM3`, `categorie`, `manutentionSpeciale`.
- **FretException** : Exception typée Dart levée par le Repository_Fret en cas d'erreur. Contient le message d'erreur original et un code d'erreur métier parmi : `DEMANDE_NON_MODIFIABLE`, `KYC_INVALIDE`, `FRIGO_VEHICULE_REQUIS`, `ARTICLE_MANQUANT`, `SUPABASE_ERROR`.

---

## Requirements

---

### Exigence 1 — Schéma de base de données Supabase

**User Story :** En tant que développeur, je veux disposer d'une migration SQL créant les tables
`demandes_fret` et `articles_fret` avec des politiques RLS correctes, afin que les données de fret
soient isolées par prestataire et prêtes à être consommées par M3.

#### Critères d'acceptation

1. THE **Schema_Manager** SHALL créer la table `demandes_fret` avec les colonnes : `id` (uuid, PK, default `gen_random_uuid()`), `id_prestataire` (uuid, FK → `profiles.id`, NOT NULL), `adresse_depart` (text, NOT NULL), `adresse_arrivee` (text, NOT NULL), `date_heure_souhaitee_depart` (timestamptz, NOT NULL), `date_heure_retour_prevue` (timestamptz, nullable), `type_vehicule_requis` (text, NOT NULL, CHECK dans l'énumération Type_Vehicule), `poids_total_estime_kg` (numeric(10,2), default 0), `volume_total_estime_m3` (numeric(10,3), default 0), `fragile` (boolean, NOT NULL, default false), `necessite_frigo` (boolean, NOT NULL, default false), `necessite_manutention` (boolean, NOT NULL, default false), `nb_manutentionnaires_requis` (integer, NOT NULL, default 0, CHECK (`nb_manutentionnaires_requis` >= 0 AND `nb_manutentionnaires_requis` <= 99)), `description_complementaire` (text, nullable), `statut` (text, NOT NULL, default `brouillon`, CHECK dans Statut_Demande), `date_creation` (timestamptz, NOT NULL, default `now()`).

2. THE **Schema_Manager** SHALL créer la table `articles_fret` avec les colonnes : `id` (uuid, PK, default `gen_random_uuid()`), `id_demande` (uuid, FK → `demandes_fret.id` ON DELETE CASCADE, NOT NULL), `designation` (text, NOT NULL), `quantite` (integer, NOT NULL, CHECK > 0), `poids_unitaire_kg` (numeric(10,2), NOT NULL, CHECK >= 0), `volume_unitaire_m3` (numeric(10,3), NOT NULL, CHECK >= 0), `categorie` (text, NOT NULL, CHECK dans Categorie_Article), `manutention_speciale` (text, nullable).

3. WHEN la table `demandes_fret` est créée, THE **Schema_Manager** SHALL activer RLS et créer les politiques suivantes : SELECT autorisé si `auth.uid() = id_prestataire` ; INSERT autorisé si `auth.uid() = id_prestataire` ; UPDATE autorisé si `auth.uid() = id_prestataire` et `statut IN ('brouillon', 'publiee')` — cette politique protège uniquement la transition de statut pour les demandes publiées, la protection des champs individuels d'une demande publiée étant assurée par la couche applicative (Repository_Fret) ; DELETE autorisé si `auth.uid() = id_prestataire` et `statut = 'brouillon'`.

4. WHEN la table `articles_fret` est créée, THE **Schema_Manager** SHALL activer RLS et créer des politiques déléguant la propriété à la Demande_Fret parente : toutes les opérations (SELECT, INSERT, UPDATE, DELETE) sont autorisées si `EXISTS (SELECT 1 FROM demandes_fret d WHERE d.id = id_demande AND d.id_prestataire = auth.uid())`.

5. THE **Schema_Manager** SHALL créer un index sur `demandes_fret(id_prestataire)` et un index sur `demandes_fret(statut)` pour optimiser les requêtes du dashboard.

6. THE **Schema_Manager** SHALL créer un index sur `articles_fret(id_demande)` pour optimiser la récupération des articles par demande.

7. THE **Schema_Manager** SHALL documenter que les transitions de statut vers `matchee`, `annulee` et `terminee` sont effectuées exclusivement par des services serveur (M3 ou service backend dédié) utilisant le rôle `service_role` Supabase, contournant la RLS. Le prestataire (auth.uid) ne peut pas directement passer une demande à ces statuts via la RLS client.

---

### Exigence 2 — Modèles Dart et Repository

**User Story :** En tant que développeur Flutter, je veux des modèles Dart immuables et un
Repository_Fret utilisant le client Supabase, afin de manipuler les données de fret de manière
type-safe et testable.

#### Critères d'acceptation

1. THE **Dart_Model_DemandeFret** SHALL exposer tous les champs de la table `demandes_fret` avec des types Dart appropriés : `id` (String), `idPrestataire` (String), `adresseDepart` (String), `adresseArrivee` (String), `dateHeureSouhaiteeDepart` (DateTime), `dateHeureRetourPrevue` (DateTime?), `typeVehiculeRequis` (TypeVehicule enum), `poidsTotalEstimeKg` (double), `volumeTotalEstimeM3` (double), `fragile` (bool), `necessiteFrigo` (bool), `necessiteManutention` (bool), `nbManutentionnairesRequis` (int), `descriptionComplementaire` (String?), `statut` (StatutDemande enum), `dateCreation` (DateTime).

2. THE **Dart_Model_ArticleFret** SHALL exposer tous les champs de la table `articles_fret` : `id` (String), `idDemande` (String), `designation` (String), `quantite` (int), `poidsUnitaireKg` (double), `volumeUnitaireM3` (double), `categorie` (CategorieArticle enum), `manutentionSpeciale` (String?).

3. THE **Dart_Model_DemandeFret** SHALL exposer les méthodes `fromJson(Map<String, dynamic>)`, `toJson()` et `copyWith(...)` permettant la sérialisation/désérialisation depuis/vers la réponse Supabase.

4. THE **Dart_Model_ArticleFret** SHALL exposer les méthodes `fromJson(Map<String, dynamic>)`, `toJson()` et `copyWith(...)`.

5. THE **Dart_Model_DemandeFret** SHALL garantir que `DemandeFret.fromJson(d.toJson())` produit un objet structurellement équivalent à `d` (propriété de round-trip).

6. THE **Dart_Model_ArticleFret** SHALL garantir que `ArticleFret.fromJson(a.toJson())` produit un objet structurellement équivalent à `a` (propriété de round-trip).

7. THE **Repository_Fret** SHALL exposer les méthodes suivantes, dont les paramètres d'entrée utilisent les types définis dans le Glossaire : `createDraft(DemandeFretInput)` → `Future<DemandeFret>` ; `updateDraft(String id, DemandeFretInput)` → `Future<DemandeFret>` ; `publish(String id)` → `Future<DemandeFret>` (effectue uniquement la mise à jour atomique `statut = 'publiee'` en base de données — les validations métier KYC, article minimum et contrainte frigo sont de la responsabilité du Publication_Service, Exigence 5) ; `getDemande(String id)` → `Future<DemandeFret?>` ; `listDemandes({StatutDemande? statut})` → `Future<List<DemandeFret>>` ; `deleteDraft(String id)` → `Future<void>`.

8. THE **Repository_Fret** SHALL exposer les méthodes suivantes pour les articles, dont les paramètres d'entrée utilisent les types définis dans le Glossaire : `addArticle(ArticleFretInput)` → `Future<ArticleFret>` ; `updateArticle(String id, ArticleFretInput)` → `Future<ArticleFret>` ; `deleteArticle(String id)` → `Future<void>` ; `listArticles(String idDemande)` → `Future<List<ArticleFret>>`.

9. IF une opération Supabase retourne une erreur, THEN THE **Repository_Fret** SHALL lever une FretException (telle que définie dans le Glossaire) avec le message d'erreur original et l'un des codes d'erreur métier suivants selon le contexte : `DEMANDE_NON_MODIFIABLE`, `KYC_INVALIDE`, `FRIGO_VEHICULE_REQUIS`, `ARTICLE_MANQUANT`, `SUPABASE_ERROR`.

---

### Exigence 3 — Wizard de création en 4 étapes (UI et validation)

**User Story :** En tant que prestataire, je veux saisir ma demande de transport via un formulaire
guidé en 4 étapes, afin de fournir toutes les informations nécessaires de manière progressive et
sans risque de perte de données.

#### Critères d'acceptation

1. THE **Wizard_Fret** SHALL afficher un indicateur de progression (step indicator) montrant l'étape courante parmi les 4 étapes : Itinéraire, Véhicule & besoins, Inventaire, Récapitulatif & publication.

2. WHEN l'utilisateur navigue vers l'étape suivante, THE **Wizard_Fret** SHALL valider les champs obligatoires de l'étape courante avant de permettre la progression.

3. IF un champ obligatoire est vide ou invalide lors de la tentative de progression, THEN THE **Wizard_Fret** SHALL afficher un message d'erreur inline sous le champ concerné sans quitter l'étape.

4. THE **Wizard_Fret** — Étape 1 (Itinéraire) — SHALL collecter : `adresse_depart` (champ texte libre, obligatoire, non vide après trim, longueur maximale 255 caractères), `adresse_arrivee` (champ texte libre, obligatoire, non vide après trim, longueur maximale 255 caractères), `date_heure_souhaitee_depart` (date + heure, obligatoire, doit être strictement supérieure à `now()` au moment de la validation de l'étape avec un minimum de 1 heure dans le futur), `date_heure_retour_prevue` (date + heure, optionnelle, activée par un toggle Retour prévu Oui/Non).

5. IF `date_heure_retour_prevue` est renseignée, THEN THE **Wizard_Fret** SHALL vérifier que `date_heure_retour_prevue` est postérieure à `date_heure_souhaitee_depart` et afficher une erreur inline dans le cas contraire.

6. THE **Wizard_Fret** — Étape 2 (Véhicule & besoins) — SHALL collecter : `type_vehicule_requis` via des cartes de sélection exclusives, le toggle `necessite_frigo`, le toggle `necessite_manutention`, le stepper `nb_manutentionnaires_requis` (visible uniquement si `necessite_manutention = true`, valeur minimum 1).

7. WHILE `necessite_manutention = false`, THE **Wizard_Fret** SHALL forcer `nb_manutentionnaires_requis` à 0 et masquer le stepper.

8. THE **Wizard_Fret** — Étape 3 (Inventaire) — SHALL afficher la liste des Article_Fret associés à la Demande_Fret courante, avec pour chaque article : désignation, quantité, poids total de la ligne (quantité × poids_unitaire_kg), volume total de la ligne (quantité × volume_unitaire_m3), catégorie.

9. WHEN l'utilisateur tape sur « Ajouter un article », THE **Wizard_Fret** SHALL ouvrir une modale permettant de saisir : `designation` (obligatoire, longueur maximale 200 caractères), `quantite` (obligatoire, > 0), `poids_unitaire_kg` (obligatoire, ≥ 0, borne supérieure 10 000 kg), `volume_unitaire_m3` (obligatoire, ≥ 0, borne supérieure 1 000 m³), `categorie` (obligatoire, liste déroulante Categorie_Article), `manutention_speciale` (optionnel, texte libre).

10. WHEN un article est ajouté ou supprimé, THE **Wizard_Fret** SHALL recalculer et afficher les totaux `poids_total_estime_kg` et `volume_total_estime_m3` en temps réel comme la somme de (quantité × poids_unitaire_kg) et (quantité × volume_unitaire_m3) pour tous les articles de la demande.

11. WHILE l'utilisateur est à l'étape 4, THE **Wizard_Fret** SHALL afficher une synthèse complète de toutes les données saisies : itinéraire, date/heure, type de véhicule, besoins spécifiques, nombre d'articles, poids total, volume total, et description complémentaire si renseignée.

12. WHILE l'utilisateur est à l'étape 4 et que le statut de la Demande_Fret est `brouillon`, THE **Wizard_Fret** SHALL proposer un bouton « Modifier » par section permettant de revenir à l'étape correspondante avec les données pré-remplies.

13. IF la prestataire tente d'ajouter un article au-delà de la limite de 50 Article_Fret par Demande_Fret, THEN THE **Wizard_Fret** SHALL bloquer l'ajout et afficher un message d'erreur indiquant que le nombre maximum d'articles est atteint.

14. IF `necessite_frigo = true` et `type_vehicule_requis ≠ 'camion_frigo'` lors du passage de l'étape 2 à l'étape 3, THEN THE **Wizard_Fret** SHALL bloquer la progression et afficher un message d'erreur inline sur la sélection de véhicule indiquant la contrainte RG3.

15. WHILE une Demande_Fret a le statut `publiee`, `matchee` ou `terminee`, THE **Wizard_Fret** SHALL masquer les boutons « Modifier » de l'étape 4 (Récapitulatif).

---

### Exigence 4 — Sauvegarde automatique en brouillon

**User Story :** En tant que prestataire, je veux que ma demande soit sauvegardée automatiquement
à chaque étape, afin de ne jamais perdre ma saisie en cas de fermeture accidentelle de l'application.

#### Critères d'acceptation

1. WHEN le Wizard_Fret est ouvert pour une nouvelle demande, THE **Auto_Save_Service** SHALL créer immédiatement une entrée en base avec `statut = 'brouillon'` avant que l'utilisateur ne saisisse quoi que ce soit.

2. WHEN l'utilisateur valide une étape et passe à l'étape suivante, THE **Auto_Save_Service** SHALL persister les données de l'étape complétée en base (update sur la Demande_Fret brouillon existante) dans un délai maximal de 2 secondes (SLA maximale) ; au-delà de ce délai sans réponse de Supabase, la sauvegarde est considérée en échec et le comportement décrit au critère 4 s'applique.

3. WHEN l'utilisateur ajoute, modifie ou supprime un Article_Fret, THE **Auto_Save_Service** SHALL synchroniser la modification en base dans un délai maximal de 2 secondes (SLA maximale) ; au-delà de ce délai sans réponse de Supabase, la sauvegarde est considérée en échec et le comportement décrit au critère 4 s'applique.

4. IF la sauvegarde automatique échoue, THEN THE **Auto_Save_Service** SHALL afficher un indicateur visuel non bloquant (snackbar ou icône) signalant l'échec de sauvegarde, sans bloquer la navigation dans le Wizard_Fret.

5. WHEN le prestataire rouvre le Wizard_Fret après fermeture et qu'un seul brouillon existe, THE **Auto_Save_Service** SHALL proposer de reprendre ce brouillon à partir de l'étape où la saisie s'est interrompue. IF plusieurs brouillons existent, THEN THE **Auto_Save_Service** SHALL présenter une liste de sélection permettant au prestataire de choisir le brouillon à reprendre ou d'en créer un nouveau.

6. THE **Auto_Save_Service** SHALL maintenir un indicateur d'état de sauvegarde visible dans l'en-tête du Wizard_Fret selon les 3 états suivants : `saving` (texte : "Sauvegarde…"), `saved` (texte : "Brouillon sauvegardé"), `error` (texte : "Échec de sauvegarde" avec icône d'alerte).

7. IF la création initiale du brouillon (critère 1) échoue côté Supabase, THEN THE **Auto_Save_Service** SHALL bloquer l'ouverture du Wizard_Fret et afficher un message d'erreur bloquant invitant le prestataire à réessayer.

---

### Exigence 5 — Flux de publication avec vérification KYC (RG1) et contrainte frigo (RG3)

**User Story :** En tant que prestataire, je veux publier ma demande de transport en un clic depuis
le récapitulatif, afin qu'elle soit visible par les transporteurs compatibles via M3.

#### Critères d'acceptation

1. WHEN le prestataire appuie sur « Publier la demande » à l'étape 4, THE **Publication_Service** SHALL vérifier en premier que le champ `statut_validation` du prestataire dans la table `profiles` est égal à `valide` (RG1), via une requête fraîche non cachée vers Supabase reflétant le statut le plus récent.

2. IF `profiles.statut_validation ≠ 'valide'` au moment de la publication, THEN THE **Publication_Service** SHALL bloquer la publication et afficher un message explicatif invitant le prestataire à compléter sa vérification KYC, sans modifier le statut de la Demande_Fret.

3. WHEN la vérification KYC est passée, THE **Publication_Service** SHALL vérifier en second que la Demande_Fret contient au minimum 1 Article_Fret.

4. IF la Demande_Fret ne contient aucun Article_Fret au moment de la publication, THEN THE **Publication_Service** SHALL bloquer la publication et rediriger le prestataire vers l'étape 3 (Inventaire) avec un message d'erreur.

5. WHEN la vérification du nombre d'articles est passée, THE **Publication_Service** SHALL vérifier en troisième que la contrainte frigo est respectée : si `necessite_frigo = true` alors `type_vehicule_requis` doit être `camion_frigo` (RG3). En cas d'échec à l'une de ces vérifications séquentielles, les vérifications suivantes ne sont pas effectuées.

6. WHILE `necessite_frigo = true`, THE **Wizard_Fret** SHALL afficher un avertissement inline sur l'écran de l'étape 2 indiquant que le type de véhicule `camion_frigo` est obligatoire (RG3).

7. IF `necessite_frigo = true` et `type_vehicule_requis ≠ 'camion_frigo'` au moment de la publication, THEN THE **Publication_Service** SHALL bloquer la publication et afficher un message d'erreur indiquant la contrainte RG3.

8. WHEN toutes les validations sont passées, THE **Publication_Service** SHALL mettre à jour le champ `statut` de la Demande_Fret de `brouillon` à `publiee` en base de données via une transaction atomique.

9. WHEN la Demande_Fret passe au statut `publiee`, THE **Publication_Service** SHALL émettre un événement `demande_publiee` (via le bus d'événements applicatif ou une notification Supabase Realtime) contenant l'`id_demande`, consommable par le module M3.

10. IF la mise à jour du statut échoue côté Supabase, THEN THE **Publication_Service** SHALL laisser le statut à `brouillon`, afficher un message d'erreur technique et permettre au prestataire de réessayer.

---

### Exigence 6 — Dashboard et liste des demandes

**User Story :** En tant que prestataire, je veux voir mes demandes de fret actives sur le dashboard,
afin de suivre leur état et accéder rapidement aux actions disponibles.

#### Critères d'acceptation

1. THE **Dashboard_Fret** SHALL afficher toutes les Demandes_Fret de l'utilisateur authentifié, tous statuts confondus (`brouillon`, `publiee`, `matchee`, `annulee`, `terminee`), triées par `date_creation` décroissante.

2. WHEN le dashboard est chargé, THE **Dashboard_Fret** SHALL afficher pour chaque Demande_Fret une MissionCard contenant : l'itinéraire (adresse_depart → adresse_arrivee), la date et l'heure de départ souhaitée, le type de véhicule requis avec une icône, le badge de statut coloré pour tous les statuts (brouillon = gris, publiee = cyan, matchee = vert, annulee = rouge, terminee = gris foncé).

3. WHEN un prestataire non validé KYC accède au dashboard, THE **Dashboard_Fret** SHALL afficher une bannière fixe non dismissible en haut de la liste, avec le texte "Votre identité n'est pas encore vérifiée" et un bouton CTA "Vérifier mon identité" redirigeant vers le parcours KYC, sans bloquer l'accès aux brouillons existants.

4. WHEN le prestataire appuie sur une MissionCard dont le statut est `brouillon`, THE **Dashboard_Fret** SHALL naviguer vers le Wizard_Fret à l'étape où la saisie avait été interrompue.

5. WHEN le prestataire appuie sur une MissionCard dont le statut est `publiee`, THE **Dashboard_Fret** SHALL naviguer vers la route `/fret/:id` (point d'entrée du module M3) ; M2 est uniquement responsable de cette navigation, le contenu de l'écran `/fret/:id` étant défini dans M3.

6. THE **Dashboard_Fret** SHALL proposer un bouton d'action principal « + Publier une demande de fret » permettant de démarrer un nouveau Wizard_Fret.

7. IF la liste des demandes est vide, THEN THE **Dashboard_Fret** SHALL afficher un état vide avec un message contextuel et le CTA « Créer ma première demande ».

8. WHEN le prestataire effectue un pull-to-refresh sur le dashboard, THE **Dashboard_Fret** SHALL recharger la liste depuis Supabase, afficher un indicateur de chargement natif Flutter (`RefreshIndicator`) pendant le rechargement, et mettre à jour les MissionCards à la fin du rechargement.

---

### Exigence 7 — Navigation avec go_router

**User Story :** En tant que développeur Flutter, je veux une navigation déclarative cohérente
avec go_router pour tous les écrans du module M2, afin que les routes soient deep-linkables et
que la navigation soit prévisible.

#### Critères d'acceptation

1. THE **Router_M2** SHALL déclarer les routes suivantes : `/fret` (liste/dashboard des demandes — route initialement chargée lors du tap sur l'onglet « Missions » dans la bottom navigation), `/fret/new` (création d'un nouveau brouillon, étape 1), `/fret/:id/edit` (reprise d'un brouillon existant, étape mémorisée), `/fret/:id` (détail d'une demande publiée).

2. WHEN un utilisateur non authentifié tente d'accéder à une route du module M2, THE **Router_M2** SHALL rediriger vers l'écran de connexion avec conservation de la route cible (`redirect` parameter).

3. THE **Router_M2** SHALL implémenter la navigation entre les 4 étapes du Wizard_Fret via l'état interne du widget (sans création de routes séparées par étape) afin de maintenir l'URL `/fret/new` ou `/fret/:id/edit` stable pendant la saisie. Le Wizard_Fret SHALL exposer un bouton « Précédent » visible dans l'UI pour reculer d'une étape sans dialog de confirmation.

4. WHEN l'utilisateur appuie sur le bouton Back système (Android/iOS) depuis le Wizard_Fret, THE **Router_M2** SHALL afficher une boîte de dialogue de confirmation avant de quitter, rappelant que le brouillon est sauvegardé. Le bouton « Précédent » de l'UI déclenche uniquement le recul d'une étape, sans dialog.

5. THE **Router_M2** SHALL s'intégrer dans la bottom navigation à 4 onglets (Accueil, Missions, Messages, Profil) en positionnant le module M2 sur l'onglet « Missions », `/fret` étant la route initialement chargée lors du tap sur cet onglet.

6. IF `getDemande(id)` retourne `null` ou une erreur lors de l'accès à `/fret/:id/edit`, THEN THE **Router_M2** SHALL rediriger vers `/fret` et afficher un message d'erreur non bloquant (snackbar) indiquant que la demande est introuvable.

---

### Exigence 8 — Calculs automatiques et cohérence des totaux

**User Story :** En tant que prestataire, je veux que le poids total et le volume total de ma
demande soient calculés automatiquement à partir des articles saisis, afin de n'avoir à saisir
que les données unitaires de chaque article.

#### Critères d'acceptation

1. THE **Totaux_Calculator** SHALL calculer `poids_total_estime_kg` comme la somme de (`quantite` × `poids_unitaire_kg`) pour tous les Article_Fret de la Demande_Fret.

2. THE **Totaux_Calculator** SHALL calculer `volume_total_estime_m3` comme la somme de (`quantite` × `volume_unitaire_m3`) pour tous les Article_Fret de la Demande_Fret.

3. WHEN un Article_Fret est ajouté, modifié ou supprimé, THE **Totaux_Calculator** SHALL recalculer et persister les totaux dans la Demande_Fret dans la même transaction atomique Supabase que la modification de l'Article_Fret, de façon synchrone avant le retour de la réponse.

4. THE **Totaux_Calculator** SHALL produire des résultats identiques quel que soit l'ordre de traitement des articles (propriété de confluence).

5. IF la liste d'articles est vide, THEN THE **Totaux_Calculator** SHALL retourner `poids_total_estime_kg = 0` et `volume_total_estime_m3 = 0`.

6. THE **Totaux_Calculator** SHALL arrondir `poids_total_estime_kg` à 2 décimales et `volume_total_estime_m3` à 3 décimales selon la règle HALF_UP (arrondi à la demi-unité supérieure) avant persistance en base.

---

### Exigence 9 — Gestion des articles (CRUD)

**User Story :** En tant que prestataire, je veux ajouter, modifier et supprimer des articles dans
ma demande de transport, afin de décrire précisément le matériel à transporter.

#### Critères d'acceptation

1. WHEN le prestataire soumet le formulaire d'ajout d'article avec des données valides, THE **Repository_Fret** SHALL persister l'Article_Fret en base et retourner l'objet créé avec son `id` généré par la base.

2. WHEN le prestataire modifie un article existant et confirme, THE **Repository_Fret** SHALL mettre à jour l'Article_Fret en base avec les nouvelles valeurs et retourner l'objet Article_Fret mis à jour.

3. WHEN le prestataire supprime un article, THE **Wizard_Fret** SHALL afficher un dialog de confirmation mentionnant la `designation` de l'article concerné avant suppression définitive.

4. WHEN la suppression est confirmée, THE **Repository_Fret** SHALL supprimer l'Article_Fret de la table `articles_fret` et déclencher le recalcul des totaux.

5. IF une Demande_Fret est au statut `publiee`, `matchee` ou `terminee`, THEN THE **Repository_Fret** SHALL rejeter toute tentative de modification ou suppression d'un Article_Fret et lever une FretException avec le code `DEMANDE_NON_MODIFIABLE`.

6. THE **Wizard_Fret** SHALL permettre le swipe gauche sur un article de la liste pour déclencher l'action de suppression avec confirmation, sauf pour les articles d'une Demande_Fret dont le statut est `publiee`, `matchee` ou `terminee` pour lesquels le swipe gauche est désactivé.

7. WHILE une Demande_Fret a le statut `publiee`, `matchee` ou `terminee`, THE **Wizard_Fret** SHALL masquer les contrôles de modification et de suppression des Article_Fret (bouton d'édition dans la modale, swipe gauche) afin de prévenir les tentatives d'actions non autorisées.

---
