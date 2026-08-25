# 💍 EventCraft AWS — Plateforme de Gestion d'Événements & Logistique

> **AWS re:Deploy Cameroon 2026** — *Mois 2 : Event & Logistics*  
> **Équipe :** Team Omega 
> **Supervision :** Mme AYOKO Dehlia  

---

## 📌 Présentation du Projet

**EventCraft AWS** est une application web Serverless conçue pour simplifier la planification financière et logistique d'événements (mariages traditionnels avec étapes comme le *Toquer-porte* ou la *Dot*, anniversaires, galas, etc.)[cite: 2, 6, 7].

Elle combine un **moteur de recommandation intelligent** sous contrainte budgétaire[cite: 5], une **collecte de fonds familiale** (Mobile Money)[cite: 3], un système de **RSVP via Webhook WhatsApp**[cite: 1, 7], et un suivi automatisé des **échéances d'acomptes**[cite: 1, 6].

---

## 🏛️ Architecture Technique (AWS Serverless)

* **Frontend :** React (Vite) / Next.js sur **AWS Amplify**
* **API & Compute :** **Amazon API Gateway** + **AWS Lambda** (Python / Node.js)
* **Base de Données :** **Amazon DynamoDB** (NoSQL On-Demand)
* **Messagerie & Alertes :** Meta WhatsApp Graph API + **Amazon EventBridge Scheduler**

---

## 🧩 Découpage des Modules

| # | Module | Description | Responsables |
| :-: | :--- | :--- | :--- |
| **1** | **Événement & Étapes** | Création de l'événement, budget global brut et sous-événements | Team Omega[cite: 7] |
| **2** | **Budget & Marge** | Marge de sécurité (5-30%) et enveloppes budgétaires plafonnées | Team Omega[cite: 2] |
| **3** | **Catalogue Prestataires** | Référentiel des prestataires et de leurs offres chiffrées | Team Omega[cite: 6] |
| **4** | **RSVP WhatsApp** | Gestion automatique des invitations/confirmations par Webhook | FOTSO Eryange Verdiane[cite: 1, 6, 7] |
| **5** | **Moteur de Sélection** | Algorithme d'IA/Optimisation des offres selon le budget disponible | Team Omega[cite: 5] |
| **6** | **Contribution Familiale** | Cagnotte collective en ligne (Mobile Money / Stripe) | Team Omega[cite: 3] |
| **7** | **Alertes Acomptes** | Calendrier des échéances et rappels automatiques aux prestataires | FOTSO Eryange Verdiane[cite: 1, 6] |

---

## 🎨 Charte Visuelle (Festif & Chaleureux)

* **Couleur Principale :** Bordeaux `#6B1530` (Light) / `#9C2A4E` (Dark)[cite: 4]
* **Couleur d'Accent :** Or festif `#D9A441` (Liseré doré de 2px sur les cartes)[cite: 4]
* **Typographies :** `Playfair Display` (Titres) et `Nunito Sans` (Corps & Formulaires)[cite: 4]