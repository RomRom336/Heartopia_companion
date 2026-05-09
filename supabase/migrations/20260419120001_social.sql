-- ============================================================
-- Heartopia Companion — Migration 11 : Système social
-- friendships, friend_invites, mise à jour RLS profiles
-- et user_collection pour la comparaison de collections.
-- ============================================================


-- ============================================================
-- 1. ENUM friendship_status
-- ============================================================
do $$ begin
  create type public.friendship_status as enum ('pending', 'accepted');
exception when duplicate_object then null;
end $$;


-- ============================================================
-- 2. FRIENDSHIPS
--    user_id  = émetteur de la demande
--    friend_id = destinataire
--    Contrainte d'unicité : une seule relation entre deux joueurs,
--    quelle que soit la direction.
-- ============================================================
create table if not exists public.friendships (
  id          uuid                    primary key default gen_random_uuid(),
  user_id     uuid                    not null references auth.users(id) on delete cascade,
  friend_id   uuid                    not null references auth.users(id) on delete cascade,
  status      public.friendship_status not null default 'pending',
  created_at  timestamptz             not null default now(),

  constraint friendships_no_self  check (user_id <> friend_id),
  constraint friendships_uniq     unique (user_id, friend_id)
);

comment on table public.friendships is
  'Relation d''amitié entre deux utilisateurs. user_id = émetteur, friend_id = destinataire. '
  'Status : pending (demande en attente) → accepted (amis).';

create index if not exists friendships_user_id_idx   on public.friendships (user_id);
create index if not exists friendships_friend_id_idx on public.friendships (friend_id);
create index if not exists friendships_status_idx    on public.friendships (status);

-- RLS friendships
alter table public.friendships enable row level security;

drop policy if exists "friendships_select" on public.friendships;
create policy "friendships_select" on public.friendships
  for select using (auth.uid() = user_id or auth.uid() = friend_id);

drop policy if exists "friendships_insert" on public.friendships;
create policy "friendships_insert" on public.friendships
  for insert with check (auth.uid() = user_id);

drop policy if exists "friendships_update" on public.friendships;
create policy "friendships_update" on public.friendships
  for update
  using  (auth.uid() = user_id or auth.uid() = friend_id)
  with check (auth.uid() = user_id or auth.uid() = friend_id);

drop policy if exists "friendships_delete" on public.friendships;
create policy "friendships_delete" on public.friendships
  for delete using (auth.uid() = user_id or auth.uid() = friend_id);

grant select, insert, update, delete on public.friendships to authenticated;


-- ============================================================
-- 3. FRIEND_INVITES
--    Un token d'invitation unique par utilisateur.
--    Quiconque visite /invite/<token> peut envoyer une demande d'ami.
--    user_id UNIQUE : un seul lien actif par joueur (réutilisable).
-- ============================================================
create table if not exists public.friend_invites (
  id         uuid        primary key default gen_random_uuid(),
  user_id    uuid        not null unique references auth.users(id) on delete cascade,
  token      uuid        not null unique default gen_random_uuid(),
  created_at timestamptz not null default now()
);

comment on table public.friend_invites is
  'Token d''invitation stable par utilisateur. Partagé via /invite/<token> — '
  'quiconque visite le lien envoie automatiquement une demande d''ami.';

create index if not exists friend_invites_token_idx   on public.friend_invites (token);
create index if not exists friend_invites_user_id_idx on public.friend_invites (user_id);

-- RLS friend_invites
alter table public.friend_invites enable row level security;

-- Lecture publique (anon inclus) : la page /invite/[token] est visible sans compte
drop policy if exists "friend_invites_select" on public.friend_invites;
create policy "friend_invites_select" on public.friend_invites
  for select using (true);

drop policy if exists "friend_invites_insert" on public.friend_invites;
create policy "friend_invites_insert" on public.friend_invites
  for insert with check (auth.uid() = user_id);

drop policy if exists "friend_invites_delete" on public.friend_invites;
create policy "friend_invites_delete" on public.friend_invites
  for delete using (auth.uid() = user_id);

grant select on public.friend_invites to anon;
grant select, insert, delete on public.friend_invites to authenticated;


-- ============================================================
-- 4. PROFILES — mise à jour RLS
--    profiles_self_select bloquait la lecture des profils des amis
--    (recherche par pseudo, affichage des noms, page profil ami).
--    Les pseudos sont des données publiques → lecture ouverte à tous,
--    y compris anon (nécessaire pour la page /invite/[token]).
-- ============================================================
drop policy if exists "profiles_self_select" on public.profiles;

drop policy if exists "profiles_select_all" on public.profiles;
create policy "profiles_select_all" on public.profiles
  for select using (true);

-- Les politiques d'écriture restent self-only (inchangées depuis migration 06)


-- ============================================================
-- 5. USER_COLLECTION — mise à jour RLS
--    Le mode "Comparer les collections" lit la collection d'un ami.
--    Les étoiles ne sont pas des données sensibles.
--    Écriture (insert / update / delete) reste self-only.
-- ============================================================
drop policy if exists "user_collection_self_select" on public.user_collection;

drop policy if exists "user_collection_select_authenticated" on public.user_collection;
create policy "user_collection_select_authenticated" on public.user_collection
  for select using (auth.role() = 'authenticated');
