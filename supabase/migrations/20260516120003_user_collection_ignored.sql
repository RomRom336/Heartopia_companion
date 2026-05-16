-- ============================================================
-- Heartopia Companion — Colonne ignored sur user_collection
-- Permet de marquer un animal d'événement comme "ignoré" :
-- l'utilisateur ne l'a pas mais l'événement est terminé,
-- il ne veut plus le voir dans sa liste à attraper.
-- ============================================================

alter table public.user_collection
  add column if not exists ignored boolean not null default false;

comment on column public.user_collection.ignored is
  'True si l''utilisateur a marqué cet animal comme ignoré (event terminé, non attrapable).';
