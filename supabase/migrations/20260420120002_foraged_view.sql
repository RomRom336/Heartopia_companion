-- ============================================================
-- Heartopia Companion — Migration 13b : ingredient_unit_cost_view
-- Étend la vue pour inclure les foraged_item utilisés en recettes.
-- Nécessite que 'Foraged' soit déjà dans l'enum (migration 13a).
-- ============================================================
create or replace view public.ingredient_unit_cost_view as
select
  i.id   as ingredient_id,
  i.name as ingredient_name,
  i.source_type,
  case i.source_type
    when 'Crop'          then coalesce(cd.seed_cost, 0)
    when 'Massimo_Store' then coalesce(sd.discounted_price, sd.base_price, 0)
    when 'Doris_Store'   then coalesce(sd.base_price, 0)
    else 0
  end as unit_cost
from public.ingredient i
left join public.crop_detail       cd on cd.ingredient_id = i.id
left join public.store_item_detail sd on sd.ingredient_id = i.id

union all

select
  fi.id             as ingredient_id,
  fi.name           as ingredient_name,
  'Foraged'         as source_type,
  0                 as unit_cost
from public.foraged_item fi
where exists (
  select 1
  from public.recipe_ingredient ri
  where ri.foraged_id = fi.id
);

comment on view public.ingredient_unit_cost_view is
  'Coût unitaire de chaque ingrédient de recette (ingredient + foraged_item utilisés en cuisine). '
  'Foraged = 0 G (ramassés gratuitement).';
