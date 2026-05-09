-- ============================================================
-- Heartopia Companion — Migration 06 : Profils & Collection utilisateur
-- Introduit profiles + user_collection + RLS stricte par utilisateur.
-- ============================================================

-- ENUM : type d'item collecté (aligné sur les tables fish / insect / bird)
create type public.collection_item_type as enum (
  'Poisson',
  'Insecte',
  'Oiseau'
);


-- ============================================================
-- 1. PROFILES
--    Une ligne par utilisateur, créée automatiquement à l'inscription.
--    id = PK = FK vers auth.users (relation 1-1 stricte).
-- ============================================================
create table public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  username    text unique,
  avatar_url  text,
  created_at  timestamptz not null default now()
);

comment on table public.profiles is
  'Profil minimal de chaque utilisateur. Créé automatiquement via le trigger on_auth_user_created.';


-- ------------------------------------------------------------
-- Trigger : auto-création du profil à l'inscription
-- ------------------------------------------------------------
-- SECURITY DEFINER : la fonction s'exécute avec les droits du propriétaire
-- (nécessaire car un utilisateur anonyme ne pourrait pas insérer dans profiles).
-- search_path figé pour éviter toute injection via un schéma tiers.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, username)
  values (
    new.id,
    coalesce(
      new.raw_user_meta_data ->> 'username',      -- formulaire d'inscription
      new.raw_user_meta_data ->> 'display_name',  -- providers OAuth (Google…)
      split_part(new.email, '@', 1)               -- fallback : préfixe email
    )
  );
  return new;
exception
  -- Collision de pseudo rare (race condition) → fallback UUID
  when unique_violation then
    insert into public.profiles (id, username)
    values (new.id, 'user_' || substr(new.id::text, 1, 8));
    return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();


-- ============================================================
-- 2. USER_COLLECTION
--    Checklist polymorphe : (user × type × item_id).
--    NOTE : pas de FK sur item_id vers fish/insect/bird (association
--    polymorphe). L'intégrité référentielle est garantie côté application
--    en croisant item_type avec la bonne table.
-- ============================================================
create table public.user_collection (
  user_id     uuid not null references auth.users(id) on delete cascade,
  item_type   collection_item_type not null,
  item_id     uuid not null,
  caught_at   timestamptz not null default now(),
  primary key (user_id, item_type, item_id)
);

comment on table public.user_collection is
  'Progression du joueur. Un triplet (user × type × item_id) = 1 capture. item_id référence fish/insect/bird selon item_type (intégrité applicative).';

create index user_collection_user_type_idx
  on public.user_collection (user_id, item_type);


-- ============================================================
-- 3. ROW LEVEL SECURITY — strict, self-only
-- ============================================================

-- PROFILES : chacun ne peut voir / créer / modifier / supprimer QUE son propre profil
alter table public.profiles enable row level security;

create policy "profiles_self_select" on public.profiles
  for select using (auth.uid() = id);

create policy "profiles_self_insert" on public.profiles
  for insert with check (auth.uid() = id);

create policy "profiles_self_update" on public.profiles
  for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

create policy "profiles_self_delete" on public.profiles
  for delete using (auth.uid() = id);


-- USER_COLLECTION : strictement privé
alter table public.user_collection enable row level security;

create policy "user_collection_self_select" on public.user_collection
  for select using (auth.uid() = user_id);

create policy "user_collection_self_insert" on public.user_collection
  for insert with check (auth.uid() = user_id);

create policy "user_collection_self_update" on public.user_collection
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "user_collection_self_delete" on public.user_collection
  for delete using (auth.uid() = user_id);
