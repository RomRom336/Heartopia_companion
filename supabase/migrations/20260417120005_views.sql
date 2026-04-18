-- ============================================================
-- Heartopia Companion — Migration 05 : Vues SQL calculées
-- Les valeurs dérivées (coûts, profits) ne sont JAMAIS stockées :
-- elles sont recalculées à la volée par ces vues.
-- ============================================================

-- ------------------------------------------------------------
-- ingredient_unit_cost_view
-- Calcule le coût unitaire d'un ingredient selon sa source.
--   Crop          : seed_cost
--   Massimo_Store : discounted_price si présent, sinon base_price
--   Doris_Store   : base_price
-- ------------------------------------------------------------
create or replace view public.ingredient_unit_cost_view as
select
  i.id   as ingredient_id,
  i.name as ingredient_name,
  i.source_type,
  case i.source_type
    when 'Crop'          then coalesce(cd.seed_cost, 0)
    when 'Massimo_Store' then coalesce(sd.discounted_price, sd.base_price, 0)
    when 'Doris_Store'   then coalesce(sd.base_price, 0)
  end as unit_cost
from public.ingredient i
left join public.crop_detail       cd on cd.ingredient_id = i.id
left join public.store_item_detail sd on sd.ingredient_id = i.id;

comment on view public.ingredient_unit_cost_view is
  'Coût d''achat/production unitaire d''un ingrédient, quelle que soit sa source.';


-- ------------------------------------------------------------
-- food_profitability_view
-- Pour chaque plat :
--   total_cost         = Σ (quantité × coût unitaire) sur tous les ingrédients
--   raw_profit         = sell_price_1_star (revenu brut de référence, sans soustraction du coût)
--   net_profit_N_star  = sell_price_N_star - total_cost
--
-- NOTE v1 : les foraged_item sont considérés coût = 0 (ramassés gratuitement).
-- Les recettes imbriquées (sub_food) contribuent 0 à v1 pour éviter la récursion ;
-- à upgrader en CTE récursive si le design le demande plus tard.
-- ------------------------------------------------------------
create or replace view public.food_profitability_view as
with recipe_cost as (
  select
    ri.food_id,
    sum(
      ri.quantity * coalesce(iuc.unit_cost, 0)
    ) as total_cost
  from public.recipe_ingredient ri
  left join public.ingredient_unit_cost_view iuc
         on iuc.ingredient_id = ri.ingredient_id
  group by ri.food_id
)
select
  f.id                       as food_id,
  f.name                     as food_name,
  f.passion_level_required,
  coalesce(rc.total_cost, 0) as total_cost,

  f.sell_price_1_star,
  f.sell_price_2_star,
  f.sell_price_3_star,
  f.sell_price_4_star,
  f.sell_price_5_star,

  -- Profit brut (référence : vente 1 étoile sans déduire le coût)
  f.sell_price_1_star        as raw_profit,

  -- Profit net par qualité
  f.sell_price_1_star - coalesce(rc.total_cost, 0) as net_profit_1_star,
  f.sell_price_2_star - coalesce(rc.total_cost, 0) as net_profit_2_star,
  f.sell_price_3_star - coalesce(rc.total_cost, 0) as net_profit_3_star,
  f.sell_price_4_star - coalesce(rc.total_cost, 0) as net_profit_4_star,
  f.sell_price_5_star - coalesce(rc.total_cost, 0) as net_profit_5_star
from public.food f
left join recipe_cost rc on rc.food_id = f.id;

comment on view public.food_profitability_view is
  'Profitabilité calculée dynamiquement de chaque plat (total_cost, raw_profit, net_profit 1-5 étoiles). Alimente l''optimiseur de cuisine.';
