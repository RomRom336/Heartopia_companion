-- ============================================================
-- Heartopia Companion — Migration 15b : ingredient_unit_cost_view v3
-- • Catégorise les foraged items par type (Champignon, Fruit, Aquatique, Autre)
-- • Ajoute les sous-plats (SubFood) trackables en inventaire
-- • Supprime Nourriture étrange & Boisson étrange (inutiles)
-- Nécessite que 'Aquatique' soit dans l'enum (migration 15a).
-- ============================================================


-- ============================================================
-- 1. Classement des items aquatiques
-- ============================================================
update public.foraged_item
set category = 'Aquatique'
where name_en in (
  'Fish', 'Seafood', 'Crayfish', 'Blue Noble Crayfish',
  'Shrimp', 'King Crab', 'Golden King Crab'
);


-- ============================================================
-- 2. ingredient_unit_cost_view v3
--    source_type est maintenant text (plus souple que l'enum).
--    Trois sources :
--      a. ingredient (Crop / Massimo_Store / Doris_Store)
--      b. foraged_item utilisé en recette (groupé par category)
--      c. food utilisé comme sous-plat (SubFood)
-- ============================================================
drop view if exists public.ingredient_unit_cost_view;

create view public.ingredient_unit_cost_view as

-- a. Ingrédients standards
select
  i.id              as ingredient_id,
  i.name            as ingredient_name,
  i.source_type::text as source_type,
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

-- b. Objets glanés utilisés dans des recettes (catégorisés)
select
  fi.id   as ingredient_id,
  fi.name as ingredient_name,
  case fi.category
    when 'Champignon' then 'Champignon'
    when 'Fruit'      then 'Fruit'
    when 'Aquatique'  then 'Aquatique'
    else 'Autre'
  end as source_type,
  0 as unit_cost
from public.foraged_item fi
where exists (
  select 1 from public.recipe_ingredient ri
  where ri.foraged_id = fi.id
)

union all

-- c. Sous-plats utilisés comme ingrédients dans d'autres recettes
select
  f.id         as ingredient_id,
  f.name       as ingredient_name,
  'SubFood'    as source_type,
  f.total_cost as unit_cost
from public.food f
where exists (
  select 1 from public.recipe_ingredient ri
  where ri.sub_food_id = f.id
);

comment on view public.ingredient_unit_cost_view is
  'v3 : Ingrédients trackables en cuisine. source_type = Crop | Massimo_Store | Doris_Store | Champignon | Fruit | Aquatique | Autre | SubFood.';

-- Les droits sont perdus lors du DROP/CREATE — on les restaure
grant select on public.ingredient_unit_cost_view to anon, authenticated;


-- ============================================================
-- 3. Suppression de Nourriture étrange & Boisson étrange
-- ============================================================
delete from public.recipe_ingredient
where food_id in (
  md5('food_Bizarre food')::uuid,
  md5('food_Bizzare drink')::uuid
);

delete from public.food
where id in (
  md5('food_Bizarre food')::uuid,
  md5('food_Bizzare drink')::uuid
);
