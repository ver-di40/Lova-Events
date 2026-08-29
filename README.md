# Lova Events

Monorepo Flutter + Supabase pour une application événementielle responsive (mobile/web) avec backend et migrations versionnées.

## Structure

```text
.
├── .env.example
├── .env
├── lib/
│   └── main.dart
├── supabase/
│   ├── config.toml
│   ├── .gitignore
│   ├── seed.sql
│   └── migrations/
│       └── 20260829_init.sql
├── test/
│   └── widget_test.dart
├── pubspec.yaml
├── analysis_options.yaml
├── README.md
└── web/
```

## Prérequis

- Flutter SDK 3.12+
- Supabase project
- Node.js si tu veux lancer Supabase localement

## Configuration

1. Copier `.env.example` vers `.env`
2. Remplir :
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY`

## Lancer le projet

```bash
flutter pub get
flutter run -d chrome
```

## Supabase

```bash
supabase init
supabase db push
supabase start
```

## Idée d’architecture

- Flutter app mobile/web responsive
- Supabase Auth pour authentification
- Supabase Database pour événements, prestataires et invitations
- migrations SQL versionnées dans `supabase/migrations`
- backend léger, centralisé autour de Supabase

## Prochaines étapes

- Authentification email / magic link
- Dashboard client et prestataire
- Événements, budget et RSVP
- Intégration WhatsApp / notifications
- Déploiement Vercel + Supabase
