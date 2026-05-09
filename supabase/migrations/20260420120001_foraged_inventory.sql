-- ============================================================
-- Heartopia Companion — Migration 13a : Enum ingredient_source
-- Ajoute la valeur 'Foraged' (idempotent).
-- DOIT être exécutée et commitée AVANT la migration 13b.
-- ============================================================
alter type public.ingredient_source add value if not exists 'Foraged';
