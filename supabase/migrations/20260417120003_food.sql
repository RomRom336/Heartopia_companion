-- ============================================================
-- Heartopia Companion — Migration 03 : Cuisine
-- food + recipe_ingredient (jonction polymorphe 3-en-1)
-- ============================================================

-- ------------------------------------------------------------
-- Plats cuisinables
-- ------------------------------------------------------------
create table public.food (
  id                      uuid primary key default gen_random_uuid(),
  name                    text not null unique,
  passion_level_required  int  not null default 1 check (passion_level_required >= 0),
  sell_price_1_star       int check (sell_price_1_star >= 0),
  sell_price_2_star       int check (sell_price_2_star >= 0),
  sell_price_3_star       int check (sell_price_3_star >= 0),
  sell_price_4_star       int check (sell_price_4_star >= 0),
  sell_price_5_star       int check (sell_price_5_star >= 0),
  created_at              timestamptz not null default now()
);

comment on table public.food is
  'Plats que le joueur peut cuisiner. Le niveau de passion cuisine requis gate l''accès à la recette.';


-- ------------------------------------------------------------
-- Table de jonction Recettes <-> Ingrédients
-- Un ingrédient de recette peut être :
--   • un ingredient   (cultivé ou acheté)
--   • un foraged_item (ramassé dans la nature)
--   • un autre food   (recette imbriquée)
-- On utilise 3 FK nullables + une contrainte CHECK qui garantit
-- qu'exactement une des 3 est renseignée (« polymorphic association »
-- à intégrité référentielle préservée, contrairement à un pattern
-- type "ref_type + ref_id").
-- ------------------------------------------------------------
create table public.recipe_ingredient (
  id             uuid primary key default gen_random_uuid(),
  food_id        uuid not null references public.food(id)          on delete cascade,
  ingredient_id  uuid references public.ingredient(id)             on delete restrict,
  foraged_id     uuid references public.foraged_item(id)           on delete restrict,
  sub_food_id    uuid references public.food(id)                   on delete restrict,
  quantity       int  not null default 1 check (quantity > 0),
  created_at     timestamptz not null default now(),
  -- Exactement une des trois références doit être renseignée
  constraint recipe_ingredient_exactly_one_ref check (
      (ingredient_id is not null)::int
    + (foraged_id    is not null)::int
    + (sub_food_id   is not null)::int = 1
  ),
  -- Une recette ne peut pas se référencer elle-même
  constraint recipe_ingredient_no_self_ref check (
      sub_food_id is null or sub_food_id <> food_id
  )
);

comment on table public.recipe_ingredient is
  'Jonction N-N entre food (recette) et une ressource consommable polymorphe (ingredient | foraged_item | autre food).';

create index recipe_ingredient_food_idx        on public.recipe_ingredient (food_id);
create index recipe_ingredient_ingredient_idx  on public.recipe_ingredient (ingredient_id) where ingredient_id is not null;
create index recipe_ingredient_foraged_idx     on public.recipe_ingredient (foraged_id)    where foraged_id    is not null;
create index recipe_ingredient_sub_food_idx    on public.recipe_ingredient (sub_food_id)   where sub_food_id   is not null;

-- Empêche un doublon exact (même food + même ressource)
create unique index recipe_ingredient_unique_triple on public.recipe_ingredient (
  food_id,
  coalesce(ingredient_id, '00000000-0000-0000-0000-000000000000'),
  coalesce(foraged_id,    '00000000-0000-0000-0000-000000000000'),
  coalesce(sub_food_id,   '00000000-0000-0000-0000-000000000000')
);
