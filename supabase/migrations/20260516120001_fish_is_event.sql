-- ============================================================
-- Heartopia Companion — Colonne event_name sur fish, insect, bird
-- Stocke le nom de l'événement pour les animaux d'événement
-- (null si l'animal est permanent).
-- ============================================================

alter table public.fish
  add column if not exists event_name text default null;

alter table public.insect
  add column if not exists event_name text default null;

alter table public.bird
  add column if not exists event_name text default null;

comment on column public.fish.event_name   is 'Nom de l''événement si poisson d''événement, null sinon.';
comment on column public.insect.event_name is 'Nom de l''événement si insecte d''événement, null sinon.';
comment on column public.bird.event_name   is 'Nom de l''événement si oiseau d''événement, null sinon.';
