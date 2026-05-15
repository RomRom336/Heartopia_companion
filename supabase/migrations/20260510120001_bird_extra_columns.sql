-- ============================================================
-- Heartopia Companion — Migration : colonnes supplémentaires bird
-- Colonnes ajoutées directement dans Supabase, documentées ici.
-- ============================================================

alter table public.bird
  add column if not exists perfect_photo_distance text,
  add column if not exists stretch_time            text;

comment on column public.bird.perfect_photo_distance is
  'Distance de photo parfaite recommandée pour cet oiseau.';
comment on column public.bird.stretch_time is
  'Durée d''étirement de l''oiseau avant envol (texte libre).';
