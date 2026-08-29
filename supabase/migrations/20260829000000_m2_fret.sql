create extension if not exists "uuid-ossp";
create extension if not exists pgcrypto;

create table if not exists public.demandes_fret (
  id uuid primary key default gen_random_uuid(),
  id_prestataire uuid not null references public.profiles(id) on delete cascade,
  adresse_depart text not null,
  adresse_arrivee text not null,
  date_heure_souhaitee_depart timestamptz not null,
  date_heure_retour_prevue timestamptz,
  type_vehicule_requis text not null
    check (type_vehicule_requis in ('fourgon', 'camion_plateau', 'camion_frigo', 'camion_benne', 'indifferent')),
  poids_total_estime_kg numeric(10,2) not null default 0 check (poids_total_estime_kg >= 0),
  volume_total_estime_m3 numeric(10,3) not null default 0 check (volume_total_estime_m3 >= 0),
  fragile boolean not null default false,
  necessite_frigo boolean not null default false,
  necessite_manutention boolean not null default false,
  nb_manutentionnaires_requis integer not null default 0
    check (nb_manutentionnaires_requis >= 0 and nb_manutentionnaires_requis <= 99),
  description_complementaire text,
  statut text not null default 'brouillon'
    check (statut in ('brouillon', 'publiee', 'matchee', 'annulee', 'terminee')),
  date_creation timestamptz not null default now()
);

create table if not exists public.articles_fret (
  id uuid primary key default gen_random_uuid(),
  id_demande uuid not null references public.demandes_fret(id) on delete cascade,
  designation text not null
    check (char_length(trim(designation)) > 0 and char_length(designation) <= 200),
  quantite integer not null check (quantite > 0),
  poids_unitaire_kg numeric(10,2) not null check (poids_unitaire_kg >= 0 and poids_unitaire_kg <= 10000),
  volume_unitaire_m3 numeric(10,3) not null check (volume_unitaire_m3 >= 0 and volume_unitaire_m3 <= 1000),
  categorie text not null
    check (categorie in ('mobilier', 'sonorisation_eclairage', 'decoration', 'materiel_traiteur', 'structure_tente', 'autre')),
  manutention_speciale text
);

create index if not exists idx_demandes_fret_prestataire on public.demandes_fret (id_prestataire);
create index if not exists idx_demandes_fret_statut on public.demandes_fret (statut);
create index if not exists idx_articles_fret_demande on public.articles_fret (id_demande);

alter table public.demandes_fret enable row level security;
create policy "demandes_fret_select"
on public.demandes_fret for select
using (auth.uid() = id_prestataire);

create policy "demandes_fret_insert"
on public.demandes_fret for insert
with check (auth.uid() = id_prestataire);

create policy "demandes_fret_update"
on public.demandes_fret for update
using (auth.uid() = id_prestataire and statut in ('brouillon', 'publiee'))
with check (auth.uid() = id_prestataire and statut in ('brouillon', 'publiee'));

create policy "demandes_fret_delete"
on public.demandes_fret for delete
using (auth.uid() = id_prestataire and statut = 'brouillon');

alter table public.articles_fret enable row level security;
create policy "articles_fret_all"
on public.articles_fret for all
using (
  exists (
    select 1
    from public.demandes_fret d
    where d.id = articles_fret.id_demande and d.id_prestataire = auth.uid()
  )
)
with check (
  exists (
    select 1
    from public.demandes_fret d
    where d.id = articles_fret.id_demande and d.id_prestataire = auth.uid()
  )
);

create or replace function public.refresh_fret_totals_for_demande(p_demande_id uuid)
returns void
language sql
security definer
set search_path = public
as $$
  with totals as (
    select
      coalesce(sum(quantite * poids_unitaire_kg), 0)::numeric(10,2) as poids_total_estime_kg,
      coalesce(sum(quantite * volume_unitaire_m3), 0)::numeric(10,3) as volume_total_estime_m3
    from public.articles_fret
    where id_demande = p_demande_id
  )
  update public.demandes_fret d
  set
    poids_total_estime_kg = t.poids_total_estime_kg,
    volume_total_estime_m3 = t.volume_total_estime_m3
  from totals t
  where d.id = p_demande_id;
$$;

granted execute on function public.refresh_fret_totals_for_demande(uuid) to authenticated;

comment on table public.demandes_fret is
  'Les transitions de statut vers matchee, annulee et terminee sont réservées aux services backend utilisant le rôle service_role Supabase (M3 ou service dédié), contournant la RLS. Le prestataire ne peut pas passer directement une demande à ces statuts via le client.';
