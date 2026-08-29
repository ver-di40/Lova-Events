-- Données de démonstration pour le projet Lova Events

INSERT INTO public.profiles (id, full_name, role, phone)
VALUES
  ('00000000-0000-0000-0000-000000000001', 'Demo Client', 'client', '+237690000001'),
  ('00000000-0000-0000-0000-000000000002', 'Demo Vendor', 'vendor', '+237690000002')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (id, owner_id, title, event_date, venue, status, budget)
VALUES
  ('11111111-1111-1111-1111-111111111111', '00000000-0000-0000-0000-000000000001', 'Mariage de Jade', '2026-12-15 18:00:00+00', 'Yaoundé', 'published', 1500000)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.providers (id, owner_id, name, category, rating)
VALUES
  ('22222222-2222-2222-2222-222222222222', '00000000-0000-0000-0000-000000000002', 'Luxe Events', 'Décoration', 4.8)
ON CONFLICT (id) DO NOTHING;
