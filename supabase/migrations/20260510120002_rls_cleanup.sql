-- ============================================================
-- Heartopia Companion — Nettoyage des politiques RLS dupliquées
-- profiles et user_collection avaient des polices redondantes
-- créées par différentes migrations. On garde les versions
-- nommées de façon cohérente et on supprime les doublons.
-- ============================================================


-- ── profiles : suppression des doublons anciens ──────────────
-- On garde : profiles_self_select / profiles_self_insert /
--            profiles_self_update / profiles_self_delete /
--            "Authenticated users can search profiles"
-- On supprime : users_read_own_profile, users_update_own_profile
--   (identiques à profiles_self_select / profiles_self_update)

drop policy if exists "users_read_own_profile"    on public.profiles;
drop policy if exists "users_update_own_profile"  on public.profiles;


-- ── user_collection : suppression des doublons anciens ───────
-- On garde : "Users manage own collection" (ALL authenticated) +
--            "Friends can read collection" (SELECT authenticated)
-- On supprime : les polices public redondantes créées par les
--   anciennes migrations (user_collection_self_*, users_*_own_collection)

drop policy if exists "user_collection_self_select" on public.user_collection;
drop policy if exists "user_collection_self_insert" on public.user_collection;
drop policy if exists "user_collection_self_update" on public.user_collection;
drop policy if exists "user_collection_self_delete" on public.user_collection;
drop policy if exists "users_read_own_collection"   on public.user_collection;
drop policy if exists "users_insert_own_collection" on public.user_collection;
drop policy if exists "users_update_own_collection" on public.user_collection;
drop policy if exists "users_delete_own_collection" on public.user_collection;
