# FretEvent — Plateforme de Mise en Relation Logistique Événementielle
## Rapport d'Architecture Fonctionnelle & Modélisation Conceptuelle des Données (Méthode Merise)

**Version** : 1.0
**Rédigé par** : Architecture Logicielle & Conception des Systèmes d'Information
**Objet** : Découpage modulaire et MCD de référence pour une plateforme B2B/B2C connectant les prestataires événementiels (traiteurs, décorateurs, loueurs de matériel, techniciens son/lumière) à des transporteurs (chauffeurs indépendants ou flottes) disposant de véhicules adaptés au fret événementiel.

---

## PARTIE 1 — DÉCOUPAGE EN MODULES FONCTIONNELS

L'application est découpée en **8 modules autonomes**, faiblement couplés, communiquant via des identifiants pivots (clés étrangères inter-modules) plutôt que par duplication de logique métier. Chaque module peut être développé, testé et déployé indépendamment (logique de microservices ou de modules monolithiques bien isolés selon la phase du projet).

### Vue d'ensemble des modules

| # | Module | Rôle principal |
|---|--------|-----------------|
| M1 | Authentification & Gestion des Profils | Identité, comptabilisation des rôles, KYC |
| M2 | Demande de Transport / Fret | Expression du besoin logistique |
| M3 | Matching / Réservation | Mise en relation offre/demande, missions |
| M4 | Géolocalisation & Tracking | Suivi temps réel des véhicules et missions |
| M5 | Tarification & Paiement | Calcul du prix, encaissement, reversement |
| M6 | Évaluation / Avis | Réputation et confiance bilatérale |
| M7 | Notifications & Communication | Alertes temps réel, messagerie |
| M8 | Gestion de Flotte & Documents | Véhicules, chauffeurs, conformité réglementaire |

### 1.1 Module M1 — Authentification & Gestion des Profils
Ce module gère la création de compte, l'authentification (email/mot de passe, OTP, OAuth) et la distinction entre les deux profils métier : **Prestataire Événementiel** (expéditeur) et **Transporteur** (chauffeur indépendant ou entreprise de transport). En entrée : informations d'inscription, pièces justificatives (SIRET, pièce d'identité, permis). En sortie : un compte validé avec un rôle et un statut de vérification (KYC), consommé par tous les autres modules pour l'autorisation d'accès.

### 1.2 Module M2 — Demande de Transport / Fret
Ce module permet au prestataire événementiel de publier une demande de transport détaillant l'itinéraire, la date, le type de véhicule requis et les caractéristiques du matériel (poids, volume, fragilité, besoin de froid, besoin de manutention). En entrée : formulaire structuré de la demande + liste des articles à transporter. En sortie : une annonce de fret "publiée" et visible par le module de Matching, avec un statut de cycle de vie (en attente, matchée, annulée, terminée).

### 1.3 Module M3 — Matching / Réservation
Ce module est le cœur algorithmique de la plateforme : il rapproche les demandes de fret publiées avec les véhicules disponibles compatibles (type de véhicule, capacité, zone géographique, disponibilité horaire), soit par attribution automatique, soit par système d'offres (bidding) des transporteurs. En entrée : demande de fret (M2) + disponibilités des véhicules (M8). En sortie : une **Mission** confirmée liant un prestataire, un transporteur, un véhicule et un chauffeur, transmise aux modules Tracking (M4) et Paiement (M5).

### 1.4 Module M4 — Géolocalisation & Tracking
Ce module assure le suivi en temps réel de la position du véhicule pendant l'exécution de la mission (aller vers l'entrepôt, trajet vers le lieu de l'événement, retour) et matérialise les jalons (étapes) de la mission. En entrée : flux GPS du chauffeur (application mobile) et identifiant de mission (M3). En sortie : position live consultable par le prestataire, historique de trajet, horodatage des étapes clés utilisé pour le calcul de conformité SLA.

### 1.5 Module M5 — Tarification & Paiement
Ce module calcule le prix de la course (distance, type de véhicule, manutention, urgence), gère l'encaissement du prestataire, le séquestre (escrow), la commission plateforme et le reversement au transporteur. En entrée : caractéristiques de la mission validée (M3) + grille tarifaire. En sortie : un paiement tracé, une facture, et un solde crédité au portefeuille du transporteur.

### 1.6 Module M6 — Évaluation / Avis
Ce module permet une notation bilatérale à l'issue de chaque mission terminée : le prestataire note le transporteur (ponctualité, soin du matériel, professionnalisme) et le transporteur note le prestataire (exactitude des informations, respect des délais de chargement). En entrée : identifiant de mission clôturée (M3/M4) + saisie de note et commentaire. En sortie : une note moyenne consolidée par utilisateur, exploitée par le Matching (M3) pour prioriser les meilleurs profils.

### 1.7 Module M7 — Notifications & Communication
Ce module centralise l'envoi d'alertes (nouvelle offre, mission acceptée, véhicule en approche, paiement reçu) via email, SMS ou push, ainsi qu'une messagerie interne prestataire-transporteur. En entrée : événements métier déclenchés par tous les autres modules (changement de statut). En sortie : notifications livrées et journal de conversation consultable.

### 1.8 Module M8 — Gestion de Flotte & Documents
Ce module gère, côté transporteur, la déclaration des véhicules (type, capacité, équipements), des chauffeurs salariés (pour les entreprises de transport) et des documents réglementaires obligatoires (assurance marchandises, carte grise, K-bis, licence de transport). En entrée : déclaration de véhicule/chauffeur + upload de documents. En sortie : un catalogue de véhicules "disponibles et conformes", consommé directement par le Matching (M3).

### Schéma global des flux inter-modules

```
 ┌───────────────┐        ┌────────────────────┐        ┌──────────────────┐
 │   M1 - AUTH   │──────▶│  M2 - DEMANDE FRET   │──────▶│  M3 - MATCHING /  │
 │  & PROFILS    │  id   │  (Prestataire)       │ id    │  RÉSERVATION      │
 └───────────────┘  utl  └────────────────────┘ dmd    └─────────┬─────────┘
        │                                                        │ id_mission
        │ id_utilisateur                                         │
        ▼                                                        ▼
 ┌───────────────┐        ┌────────────────────┐        ┌──────────────────┐
 │  M8 - FLOTTE  │──────▶│   (véhicule dispo)   │──────▶│  M4 - TRACKING &  │
 │  & DOCUMENTS  │  id   │                      │       │  GÉOLOCALISATION  │
 └───────────────┘  veh  └────────────────────┘        └─────────┬─────────┘
                                                                   │
        ┌──────────────────────────────────────────────────────┐│
        ▼                                                        ▼
 ┌───────────────┐        ┌────────────────────┐        ┌──────────────────┐
 │ M5 - TARIF &  │◀──────│    id_mission        │──────▶│  M6 - ÉVALUATION  │
 │  PAIEMENT     │       │   (mission clôturée) │       │  / AVIS            │
 └───────────────┘        └────────────────────┘        └──────────────────┘
        │                                                        │
        └──────────────────────┬─────────────────────────────────┘
                                 ▼
                         ┌──────────────────┐
                         │  M7 - NOTIFICA-   │
                         │  TIONS & COMM.    │
                         └──────────────────┘
```

---

## PARTIE 2 — MODÉLISATION CONCEPTUELLE DES DONNÉES (MCD MERISE)

### 2.0 Dictionnaire des entités pivots (partagées entre modules)

Deux entités structurent tout le système et servent de "ponts" entre les modules : **UTILISATEUR** (identité unique, M1) et **MISSION** (transaction logistique unique, M3). Toutes les cardinalités ci-dessous respectent la notation Merise `(min, max)` côté association.

---

### 2.1 MCD du Module M1 — Authentification & Gestion des Profils

**Entités et attributs**

- **UTILISATEUR**
  - PK `id_utilisateur`
  - nom_ou_raison_sociale
  - email (unique)
  - telephone
  - mot_de_passe_hash
  - type_compte {PRESTATAIRE, TRANSPORTEUR, ADMIN}
  - date_creation
  - statut_validation {en_attente, valide, suspendu}

- **PRESTATAIRE_EVENEMENTIEL**
  - PK `id_prestataire`
  - FK `id_utilisateur`
  - nom_entreprise
  - secteur_activite {traiteur, decorateur, loueur_materiel, son_lumiere, autre}
  - siret
  - adresse_entrepot_principal

- **TRANSPORTEUR**
  - PK `id_transporteur`
  - FK `id_utilisateur`
  - type_transporteur {particulier, entreprise}
  - numero_licence_transport
  - siret (nullable si particulier)
  - note_moyenne (calculée, dénormalisée depuis M6)
  - rayon_action_km

**Associations et cardinalités**

- `UTILISATEUR` — **SE_DECLINE_EN** — `PRESTATAIRE_EVENEMENTIEL` : (1,1) côté PRESTATAIRE, (0,1) côté UTILISATEUR — *(un utilisateur peut avoir 0 ou 1 profil prestataire ; un profil prestataire correspond à exactement 1 utilisateur)*
- `UTILISATEUR` — **SE_DECLINE_EN** — `TRANSPORTEUR` : (1,1) / (0,1) — *(idem, exclusif ou cumulable selon règle de gestion)*

**Schéma ASCII**

```
┌───────────────────────────┐
│        UTILISATEUR        │
├───────────────────────────┤
│ PK id_utilisateur         │
│    nom_ou_raison_sociale  │
│    email                  │
│    telephone              │
│    mot_de_passe_hash      │
│    type_compte            │
│    date_creation          │
│    statut_validation      │
└─────────────┬──────────────┘
              │(0,1)
        ┌─────┴──────┐
        │ SE_DECLINE │
        │    _EN     │
        └─────┬──────┘
              │(1,1)
   ┌──────────┴───────────┐              ┌──────────────────────┐
   │ PRESTATAIRE_          │              │                       │
   │ EVENEMENTIEL           │              │                       │
   ├────────────────────────┤              │                       │
   │ PK id_prestataire      │              │                       │
   │ FK id_utilisateur      │              │                       │
   │    nom_entreprise      │              │                       │
   │    secteur_activite    │              │                       │
   │    siret               │              │                       │
   │    adresse_entrepot    │              │                       │
   └───────────┬────────────┘              └───────────────────────┘
               │ pont vers M2 (id_prestataire)
               ▼
        [Module M2 - DEMANDE_FRET]

┌───────────────────────────┐
│        UTILISATEUR        │◀── (même entité, second lien)
└─────────────┬──────────────┘
              │(0,1)
        ┌─────┴──────┐
        │ SE_DECLINE │
        │    _EN     │
        └─────┬──────┘
              │(1,1)
   ┌──────────┴───────────┐
   │      TRANSPORTEUR      │
   ├─────────────────────────┤
   │ PK id_transporteur      │
   │ FK id_utilisateur       │
   │    type_transporteur    │
   │    numero_licence       │
   │    siret                │
   │    note_moyenne         │
   │    rayon_action_km      │
   └───────────┬─────────────┘
               │ pont vers M8 (id_transporteur)
               ▼
        [Module M8 - VEHICULE / CHAUFFEUR]
```

---

### 2.2 MCD du Module M2 — Demande de Transport / Fret

**Entités et attributs**

- **DEMANDE_FRET**
  - PK `id_demande`
  - FK `id_prestataire` *(pont vers M1)*
  - adresse_depart
  - adresse_arrivee
  - date_heure_souhaitee_depart
  - date_heure_retour_prevue (nullable, si aller-retour requis)
  - type_vehicule_requis {fourgon, camion_plateau, camion_frigo, camion_benne, indifferent}
  - poids_total_estime_kg
  - volume_total_estime_m3
  - fragile (booléen)
  - necessite_frigo (booléen)
  - necessite_manutention (booléen)
  - nb_manutentionnaires_requis
  - description_complementaire
  - statut {brouillon, publiee, matchee, annulee, terminee}
  - date_creation

- **ARTICLE_FRET**
  - PK `id_article`
  - FK `id_demande`
  - designation
  - quantite
  - poids_unitaire_kg
  - volume_unitaire_m3
  - categorie {mobilier, sonorisation_eclairage, decoration, materiel_traiteur, structure_tente, autre}
  - manutention_speciale (texte libre : "à plat", "vertical uniquement", etc.)

**Associations et cardinalités**

- `PRESTATAIRE_EVENEMENTIEL` — **PUBLIE** — `DEMANDE_FRET` : (1,1) côté DEMANDE_FRET, (0,N) côté PRESTATAIRE — *(un prestataire publie 0 à N demandes ; chaque demande appartient à exactement 1 prestataire)*
- `DEMANDE_FRET` — **CONTIENT** — `ARTICLE_FRET` : (1,1) côté ARTICLE_FRET, (1,N) côté DEMANDE_FRET — *(une demande contient au moins 1 article ; un article appartient à une seule demande)*

**Schéma ASCII**

```
        [Module M1 - PRESTATAIRE_EVENEMENTIEL]
                        │
                        │ (0,N)
                  ┌─────┴─────┐
                  │  PUBLIE   │
                  └─────┬─────┘
                        │ (1,1)
        ┌───────────────┴────────────────┐
        │           DEMANDE_FRET          │
        ├──────────────────────────────────┤
        │ PK id_demande                    │
        │ FK id_prestataire                │
        │    adresse_depart                │
        │    adresse_arrivee               │
        │    date_heure_souhaitee_depart   │
        │    date_heure_retour_prevue      │
        │    type_vehicule_requis          │
        │    poids_total_estime_kg         │
        │    volume_total_estime_m3        │
        │    fragile                       │
        │    necessite_frigo               │
        │    necessite_manutention         │
        │    nb_manutentionnaires_requis   │
        │    statut                        │
        └───────────────┬────────────────────┘
                (1,N)    │
              ┌──────────┴─────────┐
              │      CONTIENT       │
              └──────────┬──────────┘
                (1,1)    │
        ┌────────────────┴────────────────┐
        │           ARTICLE_FRET           │
        ├───────────────────────────────────┤
        │ PK id_article                     │
        │ FK id_demande                     │
        │    designation                    │
        │    quantite                       │
        │    poids_unitaire_kg              │
        │    volume_unitaire_m3             │
        │    categorie                      │
        │    manutention_speciale           │
        └────────────────────────────────────┘

  pont sortant : id_demande ──▶ [Module M3 - MISSION]
```

---

### 2.3 MCD du Module M3 — Matching / Réservation

**Entités et attributs**

- **MISSION**
  - PK `id_mission`
  - FK `id_demande` *(pont vers M2)*
  - FK `id_vehicule` *(pont vers M8)*
  - FK `id_chauffeur` (nullable si transporteur particulier) *(pont vers M8)*
  - mode_attribution {automatique, offre_validee}
  - date_acceptation
  - prix_convenu
  - statut {proposee, confirmee, en_cours, livree, cloturee, annulee, litige}

- **OFFRE**
  - PK `id_offre`
  - FK `id_demande` *(pont vers M2)*
  - FK `id_transporteur` *(pont vers M1)*
  - prix_propose
  - delai_prise_en_charge_estime
  - date_offre
  - statut {envoyee, acceptee, refusee, expiree}

**Associations et cardinalités**

- `DEMANDE_FRET` — **RECOIT** — `OFFRE` : (0,N) côté OFFRE, (1,1) côté DEMANDE_FRET — *(une demande reçoit 0 à N offres de transporteurs)*
- `TRANSPORTEUR` — **SOUMET** — `OFFRE` : (0,N) côté OFFRE, (1,1) côté TRANSPORTEUR
- `OFFRE` — **SE_TRANSFORME_EN** — `MISSION` : (0,1) côté OFFRE, (1,1) côté MISSION *(une offre acceptée génère exactement une mission ; une mission peut provenir d'une offre ou d'une attribution automatique directe depuis la demande)*
- `DEMANDE_FRET` — **DONNE_LIEU_A** — `MISSION` : (1,1) côté MISSION, (0,1) côté DEMANDE_FRET *(une demande donne lieu à au plus une mission active)*
- `VEHICULE` — **EST_AFFECTE_A** — `MISSION` : (0,N) côté VEHICULE, (1,1) côté MISSION
- `CHAUFFEUR` — **CONDUIT** — `MISSION` : (0,N) côté CHAUFFEUR, (0,1) côté MISSION

**Schéma ASCII**

```
[M2 - DEMANDE_FRET]                    [M1 - TRANSPORTEUR]
        │ (1,1)                                │ (1,1)
   ┌────┴────┐                             ┌────┴────┐
   │ RECOIT  │                             │ SOUMET  │
   └────┬────┘                             └────┬────┘
        │ (0,N)                                 │ (0,N)
        └───────────────┐         ┌──────────────┘
                         ▼         ▼
                 ┌───────────────────────┐
                 │          OFFRE          │
                 ├───────────────────────────┤
                 │ PK id_offre               │
                 │ FK id_demande             │
                 │ FK id_transporteur        │
                 │    prix_propose           │
                 │    delai_prise_en_charge  │
                 │    date_offre             │
                 │    statut                 │
                 └────────────┬───────────────┘
                       (0,1)  │
                  ┌───────────┴────────────┐
                  │   SE_TRANSFORME_EN      │
                  └───────────┬─────────────┘
                       (1,1)  │
  [M2-DEMANDE_FRET]           ▼
        │(0,1)      ┌─────────────────────────────┐
   ┌────┴────┐      │            MISSION            │
   │DONNE_LIEU│─────▶├─────────────────────────────────┤
   │   _A     │(1,1) │ PK id_mission                   │
   └──────────┘      │ FK id_demande                   │
                      │ FK id_vehicule                  │
                      │ FK id_chauffeur (nullable)       │
                      │    mode_attribution             │
                      │    date_acceptation             │
                      │    prix_convenu                 │
                      │    statut                       │
                      └──────┬──────────────┬─────────────┘
                       (0,N) │              │ (0,N)
                  ┌──────────┴────┐   ┌──────┴───────────┐
                  │ EST_AFFECTE_A  │   │     CONDUIT       │
                  └──────────┬─────┘   └──────┬────────────┘
                       (1,1) │              (0,1) │
                              ▼                    ▼
                  [M8 - VEHICULE]        [M8 - CHAUFFEUR]

  pont sortant : id_mission ──▶ [M4-TRACKING] / [M5-PAIEMENT] / [M6-AVIS]
```

---

### 2.4 MCD du Module M4 — Géolocalisation & Tracking

**Entités et attributs**

- **ETAPE_MISSION**
  - PK `id_etape`
  - FK `id_mission` *(pont vers M3)*
  - type_etape {depart_entrepot, arrivee_lieu_evenement, debut_dechargement, fin_dechargement, depart_retour, arrivee_entrepot}
  - horodatage_prevu
  - horodatage_reel (nullable tant que non atteinte)
  - statut {a_venir, en_cours, validee, en_retard}

- **POSITION_GPS**
  - PK `id_position`
  - FK `id_mission` *(pont vers M3)*
  - FK `id_vehicule` *(pont vers M8)*
  - latitude
  - longitude
  - vitesse_kmh
  - horodatage_capture

**Associations et cardinalités**

- `MISSION` — **SE_DECOUPE_EN** — `ETAPE_MISSION` : (1,1) côté ETAPE_MISSION, (1,N) côté MISSION *(une mission comporte au moins 2 étapes : départ et arrivée)*
- `MISSION` — **GENERE** — `POSITION_GPS` : (1,1) côté POSITION_GPS, (0,N) côté MISSION
- `VEHICULE` — **EMET** — `POSITION_GPS` : (1,1) côté POSITION_GPS, (0,N) côté VEHICULE

**Schéma ASCII**

```
                   [M3 - MISSION]
                  (1,N)│    │(0,N)
             ┌──────────┘    └───────────┐
      ┌──────┴───────┐            ┌──────┴──────┐
      │ SE_DECOUPE_EN │            │   GENERE     │
      └──────┬────────┘            └──────┬───────┘
        (1,1)│                       (1,1)│
             ▼                             ▼
┌───────────────────────────┐   ┌──────────────────────────┐
│       ETAPE_MISSION         │   │       POSITION_GPS         │
├────────────────────────────┤   ├───────────────────────────┤
│ PK id_etape                 │   │ PK id_position             │
│ FK id_mission                │   │ FK id_mission               │
│    type_etape                │   │ FK id_vehicule              │
│    horodatage_prevu          │   │    latitude                 │
│    horodatage_reel           │   │    longitude                │
│    statut                    │   │    vitesse_kmh               │
└──────────────────────────────┘   │    horodatage_capture        │
                                    └──────────────┬────────────────┘
                                             (0,N)  │
                                        ┌───────────┴────────┐
                                        │        EMET          │
                                        └───────────┬───────────┘
                                             (1,1)   │
                                                      ▼
                                            [M8 - VEHICULE]
```

---

### 2.5 MCD du Module M5 — Tarification & Paiement

**Entités et attributs**

- **GRILLE_TARIFAIRE**
  - PK `id_tarif`
  - type_vehicule {fourgon, camion_plateau, camion_frigo, camion_benne}
  - prix_base_forfaitaire
  - prix_par_km
  - prix_par_manutentionnaire
  - supplement_frigo
  - supplement_urgence
  - zone_geographique
  - date_effet

- **PAIEMENT**
  - PK `id_paiement`
  - FK `id_mission` *(pont vers M3)*
  - montant_total_ttc
  - commission_plateforme
  - montant_reverse_transporteur
  - moyen_paiement {carte_bancaire, mobile_money, virement}
  - statut_paiement {en_attente, sequestre, valide, rembourse, litige}
  - date_paiement

- **FACTURE**
  - PK `id_facture`
  - FK `id_paiement`
  - numero_facture (unique)
  - date_emission
  - url_pdf

**Associations et cardinalités**

- `MISSION` — **APPLIQUE** — `GRILLE_TARIFAIRE` : (0,N) côté MISSION, (1,1) côté GRILLE_TARIFAIRE *(chaque mission applique une seule grille tarifaire en vigueur à la date de la mission)*
- `MISSION` — **DECLENCHE** — `PAIEMENT` : (1,1) côté PAIEMENT, (1,1) côté MISSION *(une mission génère exactement un paiement)*
- `PAIEMENT` — **DONNE_LIEU_A** — `FACTURE` : (1,1) côté FACTURE, (1,1) côté PAIEMENT

**Schéma ASCII**

```
┌────────────────────────┐
│    GRILLE_TARIFAIRE      │
├──────────────────────────┤
│ PK id_tarif               │
│    type_vehicule          │
│    prix_base_forfaitaire  │
│    prix_par_km            │
│    prix_par_manutentionn. │
│    supplement_frigo       │
│    supplement_urgence     │
│    zone_geographique      │
│    date_effet             │
└─────────────┬──────────────┘
        (1,1) │
        ┌─────┴─────┐
        │  APPLIQUE  │
        └─────┬──────┘
        (0,N) │
              ▼
       [M3 - MISSION]
              │ (1,1)
        ┌─────┴──────┐
        │ DECLENCHE  │
        └─────┬──────┘
        (1,1) │
┌─────────────┴───────────────┐
│           PAIEMENT             │
├────────────────────────────────┤
│ PK id_paiement                  │
│ FK id_mission                   │
│    montant_total_ttc            │
│    commission_plateforme        │
│    montant_reverse_transporteur │
│    moyen_paiement               │
│    statut_paiement              │
│    date_paiement                │
└─────────────┬──────────────────┘
        (1,1) │
        ┌─────┴───────┐
        │ DONNE_LIEU_A│
        └─────┬────────┘
        (1,1) │
┌─────────────┴────────────┐
│          FACTURE           │
├─────────────────────────────┤
│ PK id_facture                │
│ FK id_paiement                │
│    numero_facture             │
│    date_emission              │
│    url_pdf                    │
└────────────────────────────────┘
```

---

### 2.6 MCD du Module M6 — Évaluation / Avis

**Entités et attributs**

- **AVIS**
  - PK `id_avis`
  - FK `id_mission` *(pont vers M3)*
  - FK `id_auteur` *(pont vers M1 — UTILISATEUR)*
  - FK `id_cible` *(pont vers M1 — UTILISATEUR)*
  - note_globale (1 à 5)
  - note_ponctualite (1 à 5, nullable si non applicable)
  - note_soin_materiel (1 à 5, nullable)
  - commentaire
  - type_avis {prestataire_vers_transporteur, transporteur_vers_prestataire}
  - date_avis

**Associations et cardinalités**

- `MISSION` — **FAIT_OBJET_DE** — `AVIS` : (0,2) côté AVIS, (1,1) côté MISSION *(une mission clôturée peut recevoir au maximum 2 avis : un dans chaque sens)*
- `UTILISATEUR` — **REDIGE** — `AVIS` (rôle auteur) : (0,N) côté AVIS, (1,1) côté UTILISATEUR
- `UTILISATEUR` — **RECOIT** — `AVIS` (rôle cible) : (0,N) côté AVIS, (1,1) côté UTILISATEUR

**Schéma ASCII**

```
              [M3 - MISSION]
                    │ (1,1)
             ┌──────┴───────┐
             │ FAIT_OBJET_DE │
             └──────┬────────┘
                (0,2)│
      ┌───────────────┴────────────────┐
      │               AVIS               │
      ├─────────────────────────────────┤
      │ PK id_avis                       │
      │ FK id_mission                    │
      │ FK id_auteur ────────┐            │
      │ FK id_cible ─────────┼──┐         │
      │    note_globale       │  │        │
      │    note_ponctualite   │  │        │
      │    note_soin_materiel │  │        │
      │    commentaire        │  │        │
      │    type_avis          │  │        │
      │    date_avis          │  │        │
      └────────────────────────┘  │        │
              (0,N)│REDIGE         │(0,N)RECOIT
                   ▼               ▼
            [M1 - UTILISATEUR] (même entité, deux rôles distincts)
```

---

### 2.7 MCD du Module M7 — Notifications & Communication

**Entités et attributs**

- **NOTIFICATION**
  - PK `id_notification`
  - FK `id_utilisateur` *(pont vers M1)*
  - id_evenement_source (référence polymorphe : id_mission, id_offre, id_paiement…)
  - type_notification {nouvelle_offre, mission_confirmee, vehicule_en_approche, paiement_recu, document_expire}
  - contenu
  - canal {email, sms, push}
  - statut_lecture {non_lu, lu}
  - date_envoi

- **MESSAGE**
  - PK `id_message`
  - FK `id_mission` *(pont vers M3)*
  - FK `id_emetteur` *(pont vers M1)*
  - FK `id_destinataire` *(pont vers M1)*
  - contenu_texte
  - date_envoi
  - statut_lecture {non_lu, lu}

**Associations et cardinalités**

- `UTILISATEUR` — **RECOIT_NOTIFICATION** — `NOTIFICATION` : (0,N) côté NOTIFICATION, (1,1) côté UTILISATEUR
- `MISSION` — **SUPPORTE** — `MESSAGE` : (0,N) côté MESSAGE, (1,1) côté MISSION
- `UTILISATEUR` — **ENVOIE / RECOIT** — `MESSAGE` : (0,N) côté MESSAGE (pour chaque rôle), (1,1) côté UTILISATEUR

**Schéma ASCII**

```
[M1 - UTILISATEUR]                     [M3 - MISSION]
        │ (1,1)                                │ (1,1)
  ┌─────┴──────────┐                     ┌──────┴──────┐
  │RECOIT_          │                     │  SUPPORTE   │
  │NOTIFICATION      │                     └──────┬──────┘
  └─────┬────────────┘                       (0,N) │
   (0,N)│                                            ▼
        ▼                                  ┌──────────────────────┐
┌─────────────────────────┐                │        MESSAGE          │
│      NOTIFICATION          │                ├─────────────────────────┤
├────────────────────────────┤                │ PK id_message             │
│ PK id_notification          │                │ FK id_mission             │
│ FK id_utilisateur           │                │ FK id_emetteur ──────┐    │
│    id_evenement_source      │                │ FK id_destinataire ──┼──┐ │
│    type_notification        │                │    contenu_texte      │  │ │
│    contenu                  │                │    date_envoi          │  │ │
│    canal                    │                │    statut_lecture      │  │ │
│    statut_lecture           │                └──────────────────────────┘  │ │
│    date_envoi               │                        (0,N)│ENVOIE          │(0,N)RECOIT
└────────────────────────────┘                              ▼                ▼
                                                     [M1 - UTILISATEUR] (deux rôles)
```

---

### 2.8 MCD du Module M8 — Gestion de Flotte & Documents

**Entités et attributs**

- **VEHICULE**
  - PK `id_vehicule`
  - FK `id_transporteur` *(pont vers M1)*
  - immatriculation (unique)
  - type_vehicule {fourgon, camion_plateau, camion_frigo, camion_benne}
  - capacite_volume_m3
  - capacite_poids_kg
  - hayon_elevateur (booléen)
  - equipement_arrimage (booléen)
  - annee_mise_en_circulation
  - photo_url
  - statut_disponibilite {disponible, en_mission, en_maintenance, hors_service}

- **CHAUFFEUR**
  - PK `id_chauffeur`
  - FK `id_transporteur` *(pont vers M1, nullable si le transporteur est lui-même le chauffeur unique)*
  - nom
  - prenom
  - numero_permis
  - categorie_permis {B, C, C1, CE}
  - telephone
  - statut {actif, indisponible}

- **DOCUMENT_JUSTIFICATIF**
  - PK `id_document`
  - FK `id_transporteur` (nullable) *(pont vers M1)*
  - FK `id_vehicule` (nullable) *(pont vers VEHICULE — un document peut concerner le véhicule ou le transporteur)*
  - type_document {assurance_marchandises, carte_grise, kbis, licence_transport, permis_conduire, controle_technique}
  - url_fichier
  - date_expiration
  - statut_verification {en_attente, valide, refuse, expire}

**Associations et cardinalités**

- `TRANSPORTEUR` — **POSSEDE** — `VEHICULE` : (0,N) côté VEHICULE, (1,1) côté TRANSPORTEUR
- `TRANSPORTEUR` — **EMPLOIE** — `CHAUFFEUR` : (0,N) côté CHAUFFEUR, (1,1) côté TRANSPORTEUR
- `VEHICULE` — **EST_JUSTIFIE_PAR** — `DOCUMENT_JUSTIFICATIF` : (0,N) côté DOCUMENT, (0,1) côté VEHICULE
- `TRANSPORTEUR` — **EST_JUSTIFIE_PAR** — `DOCUMENT_JUSTIFICATIF` : (0,N) côté DOCUMENT, (0,1) côté TRANSPORTEUR
- `CHAUFFEUR` — **CONDUIT_HABITUELLEMENT** — `VEHICULE` : (0,N) côté CHAUFFEUR, (0,N) côté VEHICULE *(association plusieurs-à-plusieurs, un chauffeur pouvant conduire plusieurs véhicules de la flotte selon les missions)*

**Schéma ASCII**

```
                       [M1 - TRANSPORTEUR]
                     (1,1)│         │(1,1)
            ┌──────────────┘         └───────────────┐
      ┌─────┴─────┐                            ┌──────┴──────┐
      │  POSSEDE  │                            │   EMPLOIE   │
      └─────┬─────┘                            └──────┬───────┘
      (0,N) │                                    (0,N) │
            ▼                                            ▼
┌─────────────────────────────┐              ┌────────────────────────────┐
│           VEHICULE             │              │          CHAUFFEUR           │
├────────────────────────────────┤              ├──────────────────────────────┤
│ PK id_vehicule                  │              │ PK id_chauffeur                │
│ FK id_transporteur              │◀────────────▶│ FK id_transporteur             │
│    immatriculation              │  (0,N)-(0,N) │    nom / prenom                │
│    type_vehicule                │  CONDUIT_    │    numero_permis               │
│    capacite_volume_m3           │  HABITUELLE  │    categorie_permis            │
│    capacite_poids_kg            │  MENT        │    telephone                   │
│    hayon_elevateur              │              │    statut                      │
│    equipement_arrimage          │              └────────────────────────────────┘
│    annee_mise_en_circulation    │
│    statut_disponibilite         │
└───────────────┬──────────────────┘
          (0,1) │
     ┌───────────┴────────────┐
     │  EST_JUSTIFIE_PAR        │
     └───────────┬──────────────┘
          (0,N)  │
                  ▼
┌─────────────────────────────────┐
│       DOCUMENT_JUSTIFICATIF        │
├────────────────────────────────────┤
│ PK id_document                      │
│ FK id_transporteur (nullable)       │
│ FK id_vehicule (nullable)           │
│    type_document                    │
│    url_fichier                      │
│    date_expiration                  │
│    statut_verification              │
└────────────────────────────────────────┘

  pont sortant : id_vehicule / id_chauffeur ──▶ [M3 - MISSION]
```

---

## PARTIE 3 — SYNTHÈSE DES PONTS INTER-MODULES (CLÉS PIVOTS)

| Clé pivot | Module émetteur | Modules consommateurs |
|---|---|---|
| `id_utilisateur` | M1 | M2, M3 (via id_prestataire/id_transporteur), M6, M7 |
| `id_prestataire` | M1 | M2 (PUBLIE), M6 |
| `id_transporteur` | M1 | M3 (OFFRE), M8 |
| `id_demande` | M2 | M3 (RECOIT, DONNE_LIEU_A) |
| `id_vehicule` | M8 | M3 (EST_AFFECTE_A), M4 (EMET) |
| `id_chauffeur` | M8 | M3 (CONDUIT) |
| `id_mission` | M3 | M4, M5, M6, M7 |

Ce tableau constitue la **matrice de couplage** du système : elle garantit que chaque module reste autonome (base de données ou schéma logique propre) tout en assurant la cohérence transactionnelle globale via des identifiants partagés — une architecture directement transposable en microservices avec un identifiant de corrélation (`id_mission`) comme fil rouge de bout en bout du parcours utilisateur.

---

## PARTIE 4 — RÈGLES DE GESTION CLÉS (RG)

1. **RG1** : Une demande de fret ne peut être publiée que si `statut_validation` du prestataire = `valide` (KYC M1 requis).
2. **RG2** : Un véhicule ne peut être affecté à une mission (M3) que si son `statut_disponibilite` = `disponible` ET que tous ses documents obligatoires (M8) ont un `statut_verification` = `valide` et une `date_expiration` future.
3. **RG3** : Le `type_vehicule_requis` de la DEMANDE_FRET doit être compatible avec le `type_vehicule` du VEHICULE affecté (contrainte de matching, ex. : `necessite_frigo = vrai` ⇒ véhicule de type `camion_frigo` obligatoire).
4. **RG4** : Le paiement (M5) passe à `sequestre` dès la confirmation de la mission et n'est libéré vers le transporteur (`valide`) qu'après validation de l'étape `arrivee_lieu_evenement` (M4) ou `arrivee_entrepot` en cas de retour.
5. **RG5** : Un AVIS ne peut être créé que si `MISSION.statut` = `cloturee`, et un seul avis par (mission, type_avis).

---

*Fin du rapport. Document prêt à être décliné en schémas physiques de données (SGBD relationnel : PostgreSQL recommandé pour la gestion native des types énumérés et des contraintes géospatiales via PostGIS pour le module M4).*
