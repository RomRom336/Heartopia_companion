-- ============================================================
-- Heartopia Companion — Migration 14 : Ingrédients génériques → foraged
-- Convertit les lignes recipe_ingredient "generiques" (null/null/null)
-- qui référencent des items précis (poissons, crustacés…) en vraies
-- lignes avec foraged_id, pour permettre le suivi dans l'inventaire cuisine.
--
-- Items génériques CONSERVÉS (vrais wildcards, non convertibles) :
--   "Toute type de légumes", "Toute type de fruits", "Fruits",
--   "Tout type de champignons", "Champignons", "fruit",
--   "Sucre de n'importe quelle couleur", "Légumes",
--   "Café", "Rater n'importe quel plat", "Rater n'importe quelle boisson"
-- ============================================================


-- ============================================================
-- 1. Nouveaux foraged_item : poissons, crustacés, fruits de mer
-- ============================================================
insert into public.foraged_item (id, name_en, name, category, sell_price)
values
  (md5('foraged_Fish')::uuid,          'Fish',                 'Poisson',              'Autre',  0),
  (md5('foraged_Seafood')::uuid,        'Seafood',              'Fruits de mer',        'Autre',  0),
  (md5('foraged_Crayfish')::uuid,       'Crayfish',             'Écrevisse',            'Autre',  0),
  (md5('foraged_BlueCrayfish')::uuid,   'Blue Noble Crayfish',  'Écrevisse noble bleue','Autre',  0),
  (md5('foraged_Shrimp')::uuid,         'Shrimp',               'Crevette',             'Autre',  0),
  (md5('foraged_KingCrab')::uuid,       'King Crab',            'Crabe royal',          'Autre',  0),
  (md5('foraged_GoldenKingCrab')::uuid, 'Golden King Crab',     'Crabe royal doré',     'Autre',  0)
on conflict (id) do nothing;


-- ============================================================
-- 2. Mise à jour des lignes recipe_ingredient génériques
--    Cible : food_id + ingredient_label + toutes FKs nulles
-- ============================================================

-- Fish N Chips — 2 Poissons
update public.recipe_ingredient
set foraged_id = md5('foraged_Fish')::uuid, ingredient_type = 'foraged'
where food_id = md5('food_Fish N Chips')::uuid
  and ingredient_label = 'Poissons'
  and ingredient_id is null and foraged_id is null and sub_food_id is null;

-- Deluxe Seafood Platter — 2 Écrevisses
update public.recipe_ingredient
set foraged_id = md5('foraged_Crayfish')::uuid, ingredient_type = 'foraged'
where food_id = md5('food_Deluxe Seafood Platter')::uuid
  and ingredient_label = 'Ecrevisses'
  and ingredient_id is null and foraged_id is null and sub_food_id is null;

-- Deluxe Seafood Platter — 2 Poissons
update public.recipe_ingredient
set foraged_id = md5('foraged_Fish')::uuid, ingredient_type = 'foraged'
where food_id = md5('food_Deluxe Seafood Platter')::uuid
  and ingredient_label = 'Poissons'
  and ingredient_id is null and foraged_id is null and sub_food_id is null;

-- Seafood Risotto — 2 Fruits de mer
update public.recipe_ingredient
set foraged_id = md5('foraged_Seafood')::uuid, ingredient_type = 'foraged'
where food_id = md5('food_Seafood Risotto')::uuid
  and ingredient_label = 'Fruits de mer'
  and ingredient_id is null and foraged_id is null and sub_food_id is null;

-- Smoked Fish Bagel — 1 Poisson
update public.recipe_ingredient
set foraged_id = md5('foraged_Fish')::uuid, ingredient_type = 'foraged'
where food_id = md5('food_Smoked Fish Bagel')::uuid
  and ingredient_label = 'Poissons'
  and ingredient_id is null and foraged_id is null and sub_food_id is null;

-- Seafood Pizza — 1 Poisson
update public.recipe_ingredient
set foraged_id = md5('foraged_Fish')::uuid, ingredient_type = 'foraged'
where food_id = md5('food_Seafood Pizza')::uuid
  and ingredient_label = 'Poisson'
  and ingredient_id is null and foraged_id is null and sub_food_id is null;

-- Steamed King Crab — 3 Crabes royaux
update public.recipe_ingredient
set foraged_id = md5('foraged_KingCrab')::uuid, ingredient_type = 'foraged'
where food_id = md5('food_Steamed King Crab')::uuid
  and ingredient_label = 'Crabe'
  and ingredient_id is null and foraged_id is null and sub_food_id is null;

-- Steamed Golden King Crab — 3 Crabes royaux dorés
update public.recipe_ingredient
set foraged_id = md5('foraged_GoldenKingCrab')::uuid, ingredient_type = 'foraged'
where food_id = md5('food_Steamed Golden King Crab')::uuid
  and ingredient_label = 'Crabe royal doré'
  and ingredient_id is null and foraged_id is null and sub_food_id is null;

-- Cheese Shrimp Stuffed Crab — 2 Crabes royaux
update public.recipe_ingredient
set foraged_id = md5('foraged_KingCrab')::uuid, ingredient_type = 'foraged'
where food_id = md5('food_Cheese Shrimp Stuffed Crab')::uuid
  and ingredient_label = 'Crabes royaux'
  and ingredient_id is null and foraged_id is null and sub_food_id is null;

-- Cheese Shrimp Stuffed Crab — 2 Crevettes
update public.recipe_ingredient
set foraged_id = md5('foraged_Shrimp')::uuid, ingredient_type = 'foraged'
where food_id = md5('food_Cheese Shrimp Stuffed Crab')::uuid
  and ingredient_label = 'Crevettes'
  and ingredient_id is null and foraged_id is null and sub_food_id is null;

-- Shrimp Avocado Cup — 2 Crevettes
update public.recipe_ingredient
set foraged_id = md5('foraged_Shrimp')::uuid, ingredient_type = 'foraged'
where food_id = md5('food_Shrimp Avocado Cup')::uuid
  and ingredient_label = 'Crevettes'
  and ingredient_id is null and foraged_id is null and sub_food_id is null;

-- Crayfish Sashimi — 3 Écrevisses
update public.recipe_ingredient
set foraged_id = md5('foraged_Crayfish')::uuid, ingredient_type = 'foraged'
where food_id = md5('food_Crayfish Sashimi')::uuid
  and ingredient_label = 'Ecrevisse'
  and ingredient_id is null and foraged_id is null and sub_food_id is null;

-- Blue European Crayfish Sashimi — 3 Écrevisses nobles bleues
update public.recipe_ingredient
set foraged_id = md5('foraged_BlueCrayfish')::uuid, ingredient_type = 'foraged'
where food_id = md5('food_Blue European Crayfish Sashimi')::uuid
  and ingredient_label = 'Ecrevisse noble bleu'
  and ingredient_id is null and foraged_id is null and sub_food_id is null;
