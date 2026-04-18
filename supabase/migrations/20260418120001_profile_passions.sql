-- ============================================================
-- Heartopia Companion — Migration 07 : Passions du joueur
-- Les 4 niveaux de compétence sont stockés dans le profil et
-- synchronisés avec les stores Zustand côté client.
-- ============================================================

alter table public.profiles
  add column if not exists cooking_passion int not null default 1
    check (cooking_passion >= 0),
  add column if not exists fishing_passion int not null default 1
    check (fishing_passion >= 0),
  add column if not exists bug_passion     int not null default 1
    check (bug_passion     >= 0),
  add column if not exists bird_passion    int not null default 1
    check (bird_passion    >= 0);

comment on column public.profiles.cooking_passion is
  'Niveau de passion Cuisine — gate les recettes visibles dans /cuisine.';
comment on column public.profiles.fishing_passion is
  'Niveau de passion Pêche — gate les poissons attrapables.';
comment on column public.profiles.bug_passion is
  'Niveau de passion Chasse aux insectes.';
comment on column public.profiles.bird_passion is
  'Niveau de passion Photo ornithologique.';
