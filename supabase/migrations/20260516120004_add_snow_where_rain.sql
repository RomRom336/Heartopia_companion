-- ============================================================
-- Heartopia Companion — Ajout météo Neige là où il y a Pluie
-- Pour les 3 tables : fish, insect, bird
-- ============================================================

update public.fish
set weather = array_append(weather, 'Neige'::weather_type)
where 'Pluie' = any(weather)
  and not ('Neige' = any(weather));

update public.insect
set weather = array_append(weather, 'Neige'::weather_type)
where 'Pluie' = any(weather)
  and not ('Neige' = any(weather));

update public.bird
set weather = array_append(weather, 'Neige'::weather_type)
where 'Pluie' = any(weather)
  and not ('Neige' = any(weather));
