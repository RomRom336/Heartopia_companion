-- ============================================================
-- Heartopia Companion — Migration 09 : Compléments schéma v2
-- Enrichissement des tables existantes pour accueillir les vraies
-- données de jeu (JSON). Aucune table n'est droppée/recrée.
-- ============================================================


-- ============================================================
-- 1. COLONNES name_en (nom anglais d'origine)
--    Nullable pour ne pas bloquer les lignes existantes.
-- ============================================================
alter table public.fish         add column if not exists name_en text;
alter table public.insect       add column if not exists name_en text;
alter table public.bird         add column if not exists name_en text;
alter table public.food         add column if not exists name_en text;
alter table public.ingredient   add column if not exists name_en text;
alter table public.foraged_item add column if not exists name_en text;


-- ============================================================
-- 2. POISSONS — condition spéciale (ex : "Attracteur Sirène")
--    Stockée en texte libre ; null = aucune condition.
-- ============================================================
alter table public.fish add column if not exists special_condition text;


-- ============================================================
-- 3. PLATS — coût total de référence + recette brute
--    total_cost  : coût de fabrication issu des données de jeu
--                  (source de vérité ; la vue s'appuie dessus).
--    recipe_text : chaîne de recette originale, conservation.
-- ============================================================
alter table public.food
  add column if not exists total_cost  int  not null default 0,
  add column if not exists recipe_text text not null default '';


-- ============================================================
-- 4. ENUM shadow_size — ajout de la valeur 'Or'
--    Les très rares poissons (niveau 11+) ont une ombre dorée
--    distincte appelée "Or" dans le jeu (vs "Dorée" classique).
-- ============================================================
do $$ begin
  alter type public.shadow_size add value if not exists 'Or';
exception when duplicate_object then null;
end $$;


-- ============================================================
-- 5. RECIPE_INGREDIENT — support des ingrédients génériques
--    Certaines recettes référencent des catégories sans FK
--    précise ("4 Fruits", "3 Poissons", "1 Boisson").
--    → On relaxe la contrainte "exactement 1" → "au plus 1"
--      et on ajoute ingredient_label + ingredient_type.
-- ============================================================

-- Colonne label : nom affiché de l'ingrédient (toujours rempli)
alter table public.recipe_ingredient
  add column if not exists ingredient_label text;

-- Colonne type : discriminant pour le front
alter table public.recipe_ingredient
  add column if not exists ingredient_type text
  check (ingredient_type in ('ingredient', 'foraged', 'food', 'generic'));

-- Remplacement de la contrainte "= 1" par "<= 1"
alter table public.recipe_ingredient
  drop constraint if exists recipe_ingredient_exactly_one_ref;

alter table public.recipe_ingredient
  add constraint recipe_ingredient_at_most_one_ref check (
      (ingredient_id is not null)::int
    + (foraged_id    is not null)::int
    + (sub_food_id   is not null)::int <= 1
  );


-- ============================================================
-- 6. food_profitability_view — réécriture v2
--    Utilise food.total_cost (valeur de jeu fiable) plutôt que
--    de recalculer depuis recipe_ingredient (v1 incomplet).
-- ============================================================
drop view if exists public.food_profitability_view;

create view public.food_profitability_view as
select
  f.id                                            as food_id,
  f.name                                          as food_name,
  f.name_en,
  f.passion_level_required,
  f.total_cost,
  f.recipe_text,

  f.sell_price_1_star,
  f.sell_price_2_star,
  f.sell_price_3_star,
  f.sell_price_4_star,
  f.sell_price_5_star,

  f.sell_price_1_star - f.total_cost              as net_profit_1_star,
  f.sell_price_2_star - f.total_cost              as net_profit_2_star,
  f.sell_price_3_star - f.total_cost              as net_profit_3_star,
  f.sell_price_4_star - f.total_cost              as net_profit_4_star,
  f.sell_price_5_star - f.total_cost              as net_profit_5_star
from public.food f;

comment on view public.food_profitability_view is
  'Profitabilité de chaque plat v2 : utilise food.total_cost (donnée de jeu) pour un calcul fiable immédiat.';


-- ============================================================
-- 7. INDEX recipe_ingredient — support de plusieurs ingrédients
--    génériques par recette (tous FKs null, labels différents).
--    L'ancien index unique_triple ne couvrait pas ingredient_label.
-- ============================================================
drop index if exists public.recipe_ingredient_unique_triple;

create unique index if not exists recipe_ingredient_unique_quad
  on public.recipe_ingredient (
    food_id,
    coalesce(ingredient_id, '00000000-0000-0000-0000-000000000000'::uuid),
    coalesce(foraged_id,    '00000000-0000-0000-0000-000000000000'::uuid),
    coalesce(sub_food_id,   '00000000-0000-0000-0000-000000000000'::uuid),
    coalesce(ingredient_label, '')
  );


-- ============================================================
-- 8. RLS — lecture publique sur toutes les tables de jeu
--    Les données de jeu sont publiques (pas de données privées).
-- ============================================================

-- fish
alter table public.fish enable row level security;
drop policy if exists "public_read_fish" on public.fish;
create policy "public_read_fish"
  on public.fish for select using (true);

-- insect
alter table public.insect enable row level security;
drop policy if exists "public_read_insect" on public.insect;
create policy "public_read_insect"
  on public.insect for select using (true);

-- bird
alter table public.bird enable row level security;
drop policy if exists "public_read_bird" on public.bird;
create policy "public_read_bird"
  on public.bird for select using (true);

-- food
alter table public.food enable row level security;
drop policy if exists "public_read_food" on public.food;
create policy "public_read_food"
  on public.food for select using (true);

-- foraged_item
alter table public.foraged_item enable row level security;
drop policy if exists "public_read_foraged_item" on public.foraged_item;
create policy "public_read_foraged_item"
  on public.foraged_item for select using (true);

-- ingredient
alter table public.ingredient enable row level security;
drop policy if exists "public_read_ingredient" on public.ingredient;
create policy "public_read_ingredient"
  on public.ingredient for select using (true);

-- crop_detail
alter table public.crop_detail enable row level security;
drop policy if exists "public_read_crop_detail" on public.crop_detail;
create policy "public_read_crop_detail"
  on public.crop_detail for select using (true);

-- store_item_detail
alter table public.store_item_detail enable row level security;
drop policy if exists "public_read_store_item_detail" on public.store_item_detail;
create policy "public_read_store_item_detail"
  on public.store_item_detail for select using (true);

-- recipe_ingredient
alter table public.recipe_ingredient enable row level security;
drop policy if exists "public_read_recipe_ingredient" on public.recipe_ingredient;
create policy "public_read_recipe_ingredient"
  on public.recipe_ingredient for select using (true);
