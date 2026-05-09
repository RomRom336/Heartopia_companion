-- ============================================================
-- Heartopia Companion — Migration 15a : Enum foraged_category
-- Ajoute la valeur 'Aquatique' pour les poissons & crustacés.
-- DOIT être exécutée avant la migration 15b.
-- ============================================================
alter type public.foraged_category add value if not exists 'Aquatique';
