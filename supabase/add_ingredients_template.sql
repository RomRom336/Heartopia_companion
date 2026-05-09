-- ============================================================
-- Script template : ajouter des ingrédients manquants
-- ============================================================
-- Copier-coller ce script, remplacer les valeurs entre <...>
-- et l'exécuter dans l'éditeur SQL Supabase.
--
-- Trois types d'ingrédients existent dans le schéma :
--   1. ingredient  → cultivé (Crop) ou acheté en boutique
--      (Massimo_Store / Doris_Store)
--   2. foraged_item → ramassé dans la nature (coût = 0)
--
-- ============================================================


-- ============================================================
-- A. Ajouter un ingrédient « boutique » ou « culture »
--    (source_type : Crop | Massimo_Store | Doris_Store)
-- ============================================================

-- 1. Ligne dans ingredient
insert into public.ingredient (id, name_en, name, source_type)
values (
  md5('<clé_unique_en_ascii>')::uuid,   -- ex: md5('ingr_Sugar')::uuid
  '<NomEN>',                            -- ex: 'Sugar'
  '<Nom FR>',                           -- ex: 'Sucre'
  'Massimo_Store'                       -- ou 'Doris_Store' ou 'Crop'
)
on conflict (id) do nothing;

-- 2a. Si source_type = 'Massimo_Store' ou 'Doris_Store'
insert into public.store_item_detail (ingredient_id, store_name, base_price, discounted_price)
values (
  md5('<clé_unique_en_ascii>')::uuid,
  'Massimo',      -- ou 'Doris'
  <prix_de_base>, -- ex: 100
  <prix_remisé>   -- ex: 60 (null pour Doris)
)
on conflict (ingredient_id) do nothing;

-- 2b. Si source_type = 'Crop'
insert into public.crop_detail
  (ingredient_id, passion_level, growth_time, seed_cost,
   sell_price_1_star, sell_price_2_star, sell_price_3_star,
   sell_price_4_star, sell_price_5_star)
values (
  md5('<clé_unique_en_ascii>')::uuid,
  <niveau_passion>,   -- ex: 1
  '<durée>',          -- ex: '2 hours' (interval PostgreSQL)
  <coût_graine>,      -- ex: 50
  <vente_1_étoile>,   -- ex: 150
  <vente_2_étoiles>,  -- ex: 200
  <vente_3_étoiles>,  -- ex: 250
  <vente_4_étoiles>,  -- ex: 300
  <vente_5_étoiles>   -- ex: 450
)
on conflict (ingredient_id) do nothing;


-- ============================================================
-- B. Ajouter un objet glanés (foraged_item, coût = 0)
--    Catégories disponibles : Champignon | Fruit | Bois | Minéral | Autre
-- ============================================================

insert into public.foraged_item (id, name_en, name, category, sell_price)
values (
  md5('foraged_<NomEN>')::uuid,   -- ex: md5('foraged_Clover')::uuid
  '<NomEN>',                      -- ex: 'Clover'
  '<Nom FR>',                     -- ex: 'Trèfle'
  'Autre',                        -- catégorie (Champignon | Fruit | Bois | Minéral | Autre)
  <prix_vente>                    -- ex: 10  (0 si pas vendable)
)
on conflict (id) do nothing;


-- ============================================================
-- C. Utiliser l'ingrédient dans une recette existante
--    (ajouter une ligne dans recipe_ingredient)
--
--    Exactement UNE des trois colonnes (ingredient_id / foraged_id /
--    sub_food_id) doit être renseignée — les deux autres = null.
-- ============================================================

insert into public.recipe_ingredient
  (food_id, ingredient_id, foraged_id, sub_food_id, quantity)
values (
  -- food_id : retrouver l'UUID du plat
  (select id from public.food where name = '<Nom du plat>'),

  -- Choisir UNE seule option parmi les 3 ci-dessous :
  md5('ingr_<NomEN>')::uuid,    -- → ingredient (cultivé / boutique)
  -- md5('foraged_<NomEN>')::uuid, -- → foraged_item
  -- (select id from public.food where name = '<Sous-plat>'), -- → sub_food

  null,   -- foraged_id  (null si ingredient_id renseigné)
  null,   -- sub_food_id (null si ingredient_id renseigné)
  <quantité>  -- ex: 2
)
on conflict do nothing;
