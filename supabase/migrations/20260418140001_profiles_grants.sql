-- ============================================================
-- Heartopia Companion — Migration 10 : Grants manquants profiles
-- Les politiques RLS étaient en place mais le rôle 'authenticated'
-- n'avait pas les droits INSERT/UPDATE au niveau table → les upserts
-- clients échouaient silencieusement.
-- ============================================================

grant select, insert, update on public.profiles to authenticated;
