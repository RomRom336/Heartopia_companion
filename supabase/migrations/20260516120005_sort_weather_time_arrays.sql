-- ============================================================
-- Heartopia Companion — Tri canonique des tableaux météo et horaires
-- Ordre météo   : Soleil → Pluie → Neige → Arc-en-ciel
-- Ordre horaires: Nuit → Matin → Aprem → Soirée
-- Les tableaux vides sont traités comme "toutes les valeurs".
-- ============================================================

-- ── fish ─────────────────────────────────────────────────────
update public.fish
set weather = (
  select array_agg(w order by case w
    when 'Soleil'      then 1
    when 'Pluie'       then 2
    when 'Neige'       then 3
    when 'Arc-en-ciel' then 4
    else 5 end)
  from unnest(
    case when array_length(weather, 1) > 0
      then weather
      else array['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[]
    end
  ) as w
);

update public.fish
set "time" = (
  select array_agg(t order by case t
    when 'Nuit'   then 1
    when 'Matin'  then 2
    when 'Aprem'  then 3
    when 'Soirée' then 4
    else 5 end)
  from unnest(
    case when array_length("time", 1) > 0
      then "time"
      else array['Nuit','Matin','Aprem','Soirée']::time_period[]
    end
  ) as t
);

-- ── insect ────────────────────────────────────────────────────
update public.insect
set weather = (
  select array_agg(w order by case w
    when 'Soleil'      then 1
    when 'Pluie'       then 2
    when 'Neige'       then 3
    when 'Arc-en-ciel' then 4
    else 5 end)
  from unnest(
    case when array_length(weather, 1) > 0
      then weather
      else array['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[]
    end
  ) as w
);

update public.insect
set "time" = (
  select array_agg(t order by case t
    when 'Nuit'   then 1
    when 'Matin'  then 2
    when 'Aprem'  then 3
    when 'Soirée' then 4
    else 5 end)
  from unnest(
    case when array_length("time", 1) > 0
      then "time"
      else array['Nuit','Matin','Aprem','Soirée']::time_period[]
    end
  ) as t
);

-- ── bird ──────────────────────────────────────────────────────
update public.bird
set weather = (
  select array_agg(w order by case w
    when 'Soleil'      then 1
    when 'Pluie'       then 2
    when 'Neige'       then 3
    when 'Arc-en-ciel' then 4
    else 5 end)
  from unnest(
    case when array_length(weather, 1) > 0
      then weather
      else array['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[]
    end
  ) as w
);

update public.bird
set "time" = (
  select array_agg(t order by case t
    when 'Nuit'   then 1
    when 'Matin'  then 2
    when 'Aprem'  then 3
    when 'Soirée' then 4
    else 5 end)
  from unnest(
    case when array_length("time", 1) > 0
      then "time"
      else array['Nuit','Matin','Aprem','Soirée']::time_period[]
    end
  ) as t
);
