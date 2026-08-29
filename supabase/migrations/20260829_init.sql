create extension if not exists "uuid-ossp";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  role text not null default 'client' check (role in ('client', 'vendor', 'admin')),
  phone text,
  avatar_url text,
  created_at timestamptz not null default now()
);

create table if not exists public.events (
  id uuid primary key default uuid_generate_v4(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  event_date timestamptz not null,
  venue text,
  status text not null default 'draft' check (status in ('draft', 'published', 'in_progress', 'completed', 'cancelled')),
  budget numeric(12,2) default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.event_invitations (
  id uuid primary key default uuid_generate_v4(),
  event_id uuid not null references public.events(id) on delete cascade,
  guest_name text not null,
  guest_email text,
  rsvp_status text not null default 'pending' check (rsvp_status in ('pending', 'accepted', 'declined')),
  created_at timestamptz not null default now()
);

create table if not exists public.providers (
  id uuid primary key default uuid_generate_v4(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  name text not null,
  category text not null,
  rating numeric(2,1) default 0,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.events enable row level security;
alter table public.event_invitations enable row level security;
alter table public.providers enable row level security;

create policy "Profiles are viewable by owner or admin"
on public.profiles for select
using (auth.uid() = id or auth.jwt() ->> 'role' = 'admin');

create policy "Users can update own profile"
on public.profiles for update
using (auth.uid() = id)
with check (auth.uid() = id);

create policy "Users can insert own profile"
on public.profiles for insert
with check (auth.uid() = id);

create policy "Users can manage own events"
on public.events for all
using (auth.uid() = owner_id)
with check (auth.uid() = owner_id);

create policy "Users can manage own invitations"
on public.event_invitations for all
using (
  exists (
    select 1 from public.events e
    where e.id = event_id and e.owner_id = auth.uid()
  )
)
with check (
  exists (
    select 1 from public.events e
    where e.id = event_id and e.owner_id = auth.uid()
  )
);

create policy "Users can manage own providers"
on public.providers for all
using (auth.uid() = owner_id)
with check (auth.uid() = owner_id);
