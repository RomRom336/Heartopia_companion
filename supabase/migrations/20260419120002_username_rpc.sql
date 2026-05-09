-- ============================================================
-- Heartopia Companion — Migration 12 : Fonctions pseudo
-- ============================================================


-- ============================================================
-- 1. is_username_available(p_username text) → boolean
--
--    Vérifie si un pseudo est libre (insensible à la casse).
--    Appelée depuis le formulaire d'inscription en temps réel
--    (debounce 400 ms) avant même que l'utilisateur soit connecté.
--
--    SECURITY DEFINER : contourne le RLS pour lire profiles sans
--    être authentifié. safe car la fonction ne renvoie qu'un booléen
--    et ne divulgue aucune donnée personnelle.
--    search_path figé pour éviter les injections de schéma.
-- ============================================================
create or replace function public.is_username_available(p_username text)
returns boolean
language sql
security definer
set search_path = public
as $$
  select not exists (
    select 1
    from public.profiles
    where lower(username) = lower(p_username)
  );
$$;

comment on function public.is_username_available(text) is
  'Retourne true si p_username n''est pas encore utilisé (comparaison insensible à la casse).';

grant execute on function public.is_username_available(text) to anon, authenticated;


-- ============================================================
-- 2. Mise à jour du trigger handle_new_user
--    (redéfini ici pour corriger la priorité des métadonnées :
--     'username' passe avant 'display_name')
--    La définition d'origine est dans migration 06 ; CREATE OR REPLACE
--    l'écrase en toute sécurité.
-- ============================================================
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, username)
  values (
    new.id,
    coalesce(
      new.raw_user_meta_data ->> 'username',      -- formulaire d'inscription
      new.raw_user_meta_data ->> 'display_name',  -- providers OAuth (Google…)
      split_part(new.email, '@', 1)               -- fallback : préfixe email
    )
  );
  return new;
exception
  when unique_violation then
    insert into public.profiles (id, username)
    values (new.id, 'user_' || substr(new.id::text, 1, 8));
    return new;
end;
$$;
