-- ============================================================
-- Heartopia Companion — Migration 08 : Suivi des étoiles
-- user_collection cesse d'être un booléen implicite (row présente
-- = attrapé) pour devenir un tracker fin de la qualité obtenue.
--
-- best_star : meilleur niveau d'étoile obtenu pour cet item (1..5).
-- L'utilisateur clique directement l'étoile N dans l'UI pour
-- définir best_star = N. Re-cliquer la même étoile supprime la row
-- (item considéré comme "non attrapé") — logique gérée côté app.
--
-- Row absente     = jamais attrapé
-- Row, best_star=N = meilleure prise actuelle = N étoiles
-- ============================================================

alter table public.user_collection
  add column if not exists best_star int;

alter table public.user_collection
  drop constraint if exists user_collection_best_star_range;

alter table public.user_collection
  add constraint user_collection_best_star_range
    check (best_star is null or (best_star between 1 and 5));

comment on column public.user_collection.best_star is
  'Meilleur niveau d''étoile obtenu (1..5). La row est supprimée quand le joueur "désélectionne" sa prise.';
