-- ============================================================
-- Heartopia Companion — Seed complet (données réelles du jeu)
-- UUIDs réels : extraits de la base Supabase (fichiers JSON exportés)
-- Généré en plusieurs passes, concaténé ici.
-- ============================================================


-- ============================================================
-- 0. NETTOYAGE — ordre inverse des FK
-- ============================================================
truncate public.recipe_ingredient cascade;
truncate public.food              cascade;
truncate public.bird              cascade;
truncate public.insect            cascade;
truncate public.fish              cascade;
truncate public.store_item_detail cascade;
truncate public.crop_detail       cascade;
truncate public.ingredient        cascade;
truncate public.foraged_item      cascade;
truncate public.user_collection   cascade;

-- ============================================================
-- 1. OBJETS GLANÉS (foraged_item)
--    Catégories enum : Champignon | Fruit | Bois | Minéral | Autre
-- ============================================================
insert into public.foraged_item
  (id, name_en, name, category, sell_price)
values
  -- Champignons
  ('22866875-197b-a673-c883-518e9b3505b3'::uuid,        'Button',             'Champignon de Paris', 'Champignon', 16),
  ('fcce5856-372a-1dc9-523b-1982fa89b5d6'::uuid,        'Oyster',             'Pleurote',            'Champignon', 16),
  ('99426b97-b9a4-1906-49ad-c05bf5ba6666'::uuid,      'Shiitake',           'Shiitake',            'Champignon', 16),
  ('4751165d-6c46-547e-40bc-893a44879b75'::uuid,      'PennyBun',           'Cèpe',                'Champignon', 16),
  ('3ec27fdb-01ce-114c-d79d-30fc14b35299'::uuid,  'BlackTruffle',       'Truffe noire',        'Champignon', 99),
  ('a76be0b6-2583-310e-dbb2-cd2518c429a7'::uuid,     'Matsutake',          'Matsutake',           'Champignon',  0),
  -- Fruits sauvages
  ('bc143107-9629-527f-024e-6289f93df877'::uuid,     'Blueberry',          'Myrtille',            'Fruit',      16),
  ('334c3241-e766-9a41-4e0d-fac650361d5f'::uuid,     'Raspberry',          'Framboise',           'Fruit',      26),
  ('98fddbd3-42d1-3a3d-295b-71b847546bf0'::uuid,      'Mandarin',           'Mandarine',           'Fruit',      28),
  ('ef3ccc1b-bba1-660c-d57b-9e65d6f99bb7'::uuid,         'Apple',              'Pomme',               'Fruit',      28),
  -- Bois
  ('e29b9e5c-a62a-010b-f37c-52f74489e8cb'::uuid,        'Bamboo',             'Bambou',              'Bois',        7),
  ('3d2f286c-95be-f71b-8c06-5f9c83fb9468'::uuid,        'Branch',             'Branche',             'Bois',        5),
  ('48604b09-ff2b-ba58-a261-358f13d5293d'::uuid,        'Timber',             'Bois',                'Bois',        6),
  ('64e78af2-2f00-d99d-8a32-b72266b0a719'::uuid, 'Quality Timber',     'Bois de qualité',     'Bois',       12),
  ('3ce62745-6322-606c-abed-d54880e4073c'::uuid,    'Rare Timber',        'Bois rare',           'Bois',       50),
  ('919bb5ed-eb81-94e1-2649-daa6aa984069'::uuid,    'Roaming Oak Timber', 'Chêne errant',        'Bois',      150),
  -- Minéraux
  ('3251de32-a5e1-2a54-0490-e1facf9c94ee'::uuid,         'Stone',              'Pierre',              'Minéral',     8),
  ('5e1a88b2-6821-271d-e9b4-8ef1efd66e66'::uuid,           'Ore',                'Minerai',             'Minéral',    14),
  ('67cf0bd9-eadb-b4e6-48a4-9ee827de3c30'::uuid,      'Flawless Fluorite',  'Fluorite pure',       'Minéral',   150),
  ('4cc543c2-0b86-4758-2589-ff55623362f7'::uuid,      'Starfall Shard',     'Éclat d''étoile',     'Minéral',   150),
  -- Divers
  ('f5d992d0-98b3-1b74-d684-579b52fb42f7'::uuid,        'Party Popper',       'Cotillon',            'Autre',      25),
  ('20695ff3-27a3-2327-cdcf-5d3529c64ae9'::uuid,           'Dye',                'Teinture',            'Autre',      50),
  ('c122649c-da27-8be7-3af8-648ac20a1afe'::uuid,      'Colorful Sparkler',  'Cierge magique',      'Autre',     150),
  ('2c8bb4a0-6802-0179-13e4-0d98fbc06f14'::uuid,          'Kite',               'Cerf-volant',         'Autre',     600),
  ('694567ba-a323-aaa1-700e-cc15b015e920'::uuid,       'Balloon',            'Ballon',              'Autre',     600),
  -- Fleurs et plantes (ingrédients de recettes)
  ('7632925c-c35b-415a-19ad-9ae0ffc9266b'::uuid,    'White Daisy',        'Pâquerette blanche',  'Autre',       0),
  ('2115501d-cf57-eabb-c617-96b82467b689'::uuid,       'Red Rose',           'Rose rouge',          'Autre',       0),
  ('e9ed6248-34e4-6f4b-6742-1fd00d11c55f'::uuid,          'Weed',               'Mauvaise herbe',      'Autre',       0),
  -- Poissons et crustacés (trackables en cuisine)
  ('82ded839-5412-5bbc-bac1-2e35c9cb967d'::uuid,          'Fish',               'Poisson',             'Aquatique',   0),
  ('54fb981e-b374-a296-5d08-966b66adfed1'::uuid,       'Seafood',            'Fruits de mer',       'Aquatique',   0),
  ('37aa27f9-aab1-aeae-76b7-6cae02808edf'::uuid,      'Crayfish',           'Écrevisse',           'Aquatique',   0),
  ('d7fe53d7-b467-1a2e-e211-9339830d7794'::uuid,  'Blue Noble Crayfish','Écrevisse noble bleue','Aquatique',  0),
  ('cb6a3735-49dc-b263-fa82-52b7ec3089e2'::uuid,        'Shrimp',             'Crevette',            'Aquatique',   0),
  ('0e76afbc-07be-ee27-15b0-f7a2bed356f0'::uuid,      'King Crab',          'Crabe royal',         'Aquatique',   0),
  ('475f3485-bd9d-7378-9438-01bfc65f5a32'::uuid,'Golden King Crab',   'Crabe royal doré',    'Aquatique',   0);


-- ============================================================
-- 2. INGRÉDIENTS — table mère
--    source_type enum : Crop | Massimo_Store | Doris_Store
-- ============================================================
insert into public.ingredient
  (id, name_en, name, source_type)
values
  -- Massimo
  ('35b3a4a7-8387-fd94-e1df-adc4c485c79b'::uuid,          'Meat',          'Viande',           'Massimo_Store'),
  ('689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,           'Egg',           'Œuf',              'Massimo_Store'),
  ('c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,          'Milk',          'Lait',             'Massimo_Store'),
  ('df481a54-44e6-1c26-dc86-708722a0484a'::uuid,        'Cheese',        'Fromage',          'Massimo_Store'),
  ('c75408b4-c8a1-edc1-0f37-0c592ee78206'::uuid,        'Butter',        'Beurre',           'Massimo_Store'),
  ('9d7f780b-ad0e-53c5-c0be-005ae8d4bebb'::uuid,   'CoffeeBeans',   'Grains de café',   'Massimo_Store'),
  ('b43f91a0-779d-eed1-d6e9-d905b9565cc5'::uuid,     'TeaLeaves',     'Feuilles de thé',  'Massimo_Store'),
  ('51dddf86-df2c-50e5-c6de-81fb8b0c323f'::uuid,  'MatchaPowder',  'Poudre de matcha', 'Massimo_Store'),
  ('3122564f-f3dc-0cae-7071-8e74772b100d'::uuid,     'RiceFlour',     'Farine de riz',    'Massimo_Store'),
  ('12900f86-52b3-1a3e-20b5-d9b7c123ccc6'::uuid,       'RedBean',       'Haricot rouge',    'Massimo_Store'),
  ('30277655-f605-7f55-d387-f8fe67718fa3'::uuid,    'CookingOil',    'Huile de cuisson', 'Massimo_Store'),
  ('925fd249-ab3a-6bcd-9e54-8758888f26d3'::uuid, 'PasturizedEgg', 'Œuf pasteurisé',   'Massimo_Store'),
  -- Doris
  ('37a2fae1-ff08-c2ed-df8b-625d983b14eb'::uuid,     'BlueSugar',     'Sucre Bleu',       'Doris_Store'),
  ('a9fef895-3fd4-c51d-32cb-f3a3e26eb179'::uuid,   'IndigoSugar',   'Sucre Indigo',     'Doris_Store'),
  ('9052f3b6-1f16-ec11-c896-93de32927ceb'::uuid,   'VioletSugar',   'Sucre Violet',     'Doris_Store'),
  ('07250ad8-8705-1a84-696f-af3d9617d3cb'::uuid,      'RedSugar',      'Sucre Rouge',      'Doris_Store'),
  ('51c7c10b-f763-a181-63a9-aa9a86f2183e'::uuid,   'OrangeSugar',   'Sucre Orange',     'Doris_Store'),
  ('84b704d8-d8d8-0140-ca6f-cda841752474'::uuid,   'YellowSugar',   'Sucre Jaune',      'Doris_Store'),
  ('71c72198-2e71-d530-d3ed-28043c1858e0'::uuid,    'GreenSugar',    'Sucre Vert',       'Doris_Store'),
  -- Cultures
  ('7c9bb91e-1346-6b2c-d603-4e4b03d2b678'::uuid,        'Tomato',        'Tomate',           'Crop'),
  ('b7495864-41bd-56bf-e21d-26ce9b72cdf6'::uuid,        'Potato',        'Pomme de terre',   'Crop'),
  ('7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,         'Wheat',         'Blé',              'Crop'),
  ('7d40466d-5da2-7f16-3b9a-b0868830e823'::uuid,       'Lettuce',       'Laitue',           'Crop'),
  ('5444aea0-3f60-8f75-43d1-851d7f5d86b6'::uuid,     'Pineapple',     'Ananas',           'Crop'),
  ('cd5317e5-9b0d-5f55-fd11-fdc7bf0a8d94'::uuid,        'Carrot',        'Carotte',          'Crop'),
  ('0a540b1d-e375-cccb-8bc4-5886f59e25a5'::uuid,    'Strawberry',    'Fraise',           'Crop'),
  ('2f2ecdda-27a6-09c5-1314-1ad1c85454ca'::uuid,          'Corn',          'Maïs',             'Crop'),
  ('af7032bb-ff42-6d90-f36e-c72ad3ccf721'::uuid,        'Grapes',        'Raisin',           'Crop'),
  ('53fb4855-be19-83c4-1d7c-10d9a144481a'::uuid,      'Eggplant',      'Aubergine',        'Crop'),
  ('2862808b-dfab-0cbe-c242-a4e1f14cac41'::uuid,       'TeaTree',       'Arbre à thé',      'Crop'),
  ('1653da8c-992e-e3c1-ed00-5d617ee114cc'::uuid,         'Cocoa',         'Cacao',            'Crop'),
  ('db3a78b6-b77c-0dee-618e-bdceaf049881'::uuid,       'Avocado',       'Avocat',           'Crop');


-- ============================================================
-- 3. CULTURES (crop_detail)
--    passion_level = niveau requis dans le jeu
--    growth_time   = interval PostgreSQL
-- ============================================================
insert into public.crop_detail
  (ingredient_id, passion_level, growth_time, seed_cost,
   sell_price_1_star, sell_price_2_star, sell_price_3_star,
   sell_price_4_star, sell_price_5_star)
values
  ('7c9bb91e-1346-6b2c-d603-4e4b03d2b678'::uuid,     1,  '15 minutes',  10,   30,   40,   50,   60,   70),
  ('b7495864-41bd-56bf-e21d-26ce9b72cdf6'::uuid,     1,  '1 hour',      30,   90,  120,  150,  180,  210),
  ('7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,      2,  '4 hours',     95,  285,  381,  475,  570,  855),
  ('7d40466d-5da2-7f16-3b9a-b0868830e823'::uuid,    3,  '8 hours',    145,  435,  582,  726,  870, 1305),
  ('5444aea0-3f60-8f75-43d1-851d7f5d86b6'::uuid,  4,  '30 minutes',  15,   52,   69,   86,  104,  118),
  ('cd5317e5-9b0d-5f55-fd11-fdc7bf0a8d94'::uuid,     5,  '2 hours',     50,  155,  207,  258,  310,  350),
  ('0a540b1d-e375-cccb-8bc4-5886f59e25a5'::uuid, 6,  '6 hours',    125,  375,  502,  626,  750, 1125),
  ('2f2ecdda-27a6-09c5-1314-1ad1c85454ca'::uuid,       6,  '12 hours',   170,  515,  690,  860, 1030, 1545),
  ('af7032bb-ff42-6d90-f36e-c72ad3ccf721'::uuid,     7,  '10 hours',   160,  480,  643,  801,  960, 1440),
  ('53fb4855-be19-83c4-1d7c-10d9a144481a'::uuid,   8,  '7 hours',    135,  406,  544,  678,  812, 1218),
  ('2862808b-dfab-0cbe-c242-a4e1f14cac41'::uuid,    11, '45 minutes',  25,   75,  100,  125,  150,  225),
  ('1653da8c-992e-e3c1-ed00-5d617ee114cc'::uuid,      12, '5 hours',    110,  330,  442,  551,  660,  990),
  ('db3a78b6-b77c-0dee-618e-bdceaf049881'::uuid,    13, '13 hours',   180,  540,  735,  916, 1098, 1647);


-- ============================================================
-- 4. ARTICLES DE BOUTIQUE (store_item_detail)
--    discounted_price : uniquement Massimo (null pour Doris)
-- ============================================================
insert into public.store_item_detail
  (ingredient_id, store_name, base_price, discounted_price)
values
  ('35b3a4a7-8387-fd94-e1df-adc4c485c79b'::uuid,          'Massimo', 200, 120),
  ('689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,           'Massimo', 100,  60),
  ('c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,          'Massimo',  50,  30),
  ('df481a54-44e6-1c26-dc86-708722a0484a'::uuid,        'Massimo', 100,  60),
  ('c75408b4-c8a1-edc1-0f37-0c592ee78206'::uuid,        'Massimo', 150,  90),
  ('9d7f780b-ad0e-53c5-c0be-005ae8d4bebb'::uuid,   'Massimo',  50,  30),
  ('b43f91a0-779d-eed1-d6e9-d905b9565cc5'::uuid,     'Massimo', 250, 150),
  ('51dddf86-df2c-50e5-c6de-81fb8b0c323f'::uuid,  'Massimo', 250, 150),
  ('3122564f-f3dc-0cae-7071-8e74772b100d'::uuid,     'Massimo',  50,  30),
  ('12900f86-52b3-1a3e-20b5-d9b7c123ccc6'::uuid,       'Massimo',  50,  30),
  ('30277655-f605-7f55-d387-f8fe67718fa3'::uuid,    'Massimo', 100,  60),
  ('925fd249-ab3a-6bcd-9e54-8758888f26d3'::uuid, 'Massimo', 100,  60),
  ('37a2fae1-ff08-c2ed-df8b-625d983b14eb'::uuid,     'Doris',   150, null),
  ('a9fef895-3fd4-c51d-32cb-f3a3e26eb179'::uuid,   'Doris',   150, null),
  ('9052f3b6-1f16-ec11-c896-93de32927ceb'::uuid,   'Doris',   150, null),
  ('07250ad8-8705-1a84-696f-af3d9617d3cb'::uuid,      'Doris',   150, null),
  ('51c7c10b-f763-a181-63a9-aa9a86f2183e'::uuid,   'Doris',   200, null),
  ('84b704d8-d8d8-0140-ca6f-cda841752474'::uuid,   'Doris',   150, null),
  ('71c72198-2e71-d530-d3ed-28043c1858e0'::uuid,    'Doris',   200, null);


-- ============================================================
-- 5. POISSONS (fish)
--
-- Créneaux du jeu : Nuit 1h–7h · Matin 7h–13h · Aprem 13h–19h · Soirée 19h–1h
--
-- Mapping time_period[] depuis les chaînes JSON du jeu :
--   "Toute la journée"  → [Nuit,Matin,Aprem,Soirée]    (1h–1h : tout)
--   "Attracteur Sirène" → []  + special_condition        (aucun créneau natif)
--   "07:00 - 19:00"     → [Matin,Aprem]                 (7h–13h + 13h–19h)
--   "19:00 - 07:00"     → [Soirée,Nuit]                 (19h–1h + 1h–7h)
--   "13:00 - 01:00"     → [Aprem,Soirée]                (13h–19h + 19h–1h)
--   "01:00 - 13:00"     → [Nuit,Matin]                  (1h–7h + 7h–13h)
--   "12:00 - 06:00"     → [Matin,Aprem,Soirée,Nuit]     (12h → 06h : tout sauf début Matin)
--   "18:00 - 12:00"     → [Aprem,Soirée,Nuit,Matin]     (18h → 12h : tout sauf début Aprem)
--   "13:00 - 07:00"     → [Aprem,Soirée,Nuit]           (13h–19h + 19h–1h + 1h–7h)
--   "19:00 - 01:00"     → [Soirée]                      (19h–1h exactement)
--   "12:00 - 00:00"     → [Matin,Aprem,Soirée]          (12h–13h + 13h–19h + 19h–1h)
--   "07:00 - 01:00"     → [Matin,Aprem,Soirée]          (7h–13h + 13h–19h + 19h–1h)
--   "06:00 - 18:00"     → [Nuit,Matin,Aprem]            (6h–7h + 7h–13h + 13h–18h)
--   "18:00 - 06:00"     → [Aprem,Soirée,Nuit]           (13h–19h + 19h–1h + 1h–7h)
--   "19:00 - 13:00"     → [Soirée,Nuit,Matin]           (19h–1h + 1h–7h + 7h–13h)
--   "01:00 - 19:00"     → [Nuit,Matin,Aprem]            (1h–7h + 7h–13h + 13h–19h)
--   "19:00 - 02:00"     → [Soirée,Nuit]                 (19h–1h + 1h–2h)
--   "06:00 - 12:00"     → [Nuit,Matin]                  (6h–7h + 7h–12h)
--   "06:00 - 00:00"     → [Nuit,Matin,Aprem,Soirée]     (6h–7h + 7h–13h + 13h–19h + 19h–0h)
--   "00:00 - 12:00"     → [Soirée,Nuit,Matin]           (0h–1h + 1h–7h + 7h–12h)
--
-- Mapping shadow_size[] :
--   Petite→Petit  Moyenne→Moyen  Grande→Grand
--   Dorée→Doré    Or→Or          Bleue→Bleu
-- ============================================================
insert into public.fish
  (id, name_en, name, passion_level,
   weather, "time", location_type, exact_location, shadow_size,
   sell_price_1_star, sell_price_2_star, sell_price_3_star,
   sell_price_4_star, sell_price_5_star, special_condition)
values

-- ── MER : Sea Fishing ───────────────────────────────────────
  ('81983b07-72df-e7e6-ae7f-39d49266298a'::uuid,
   'Striped Red Mullet','Rouget barbet',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Sea Fishing',ARRAY['Doré']::shadow_size[],
   320,480,640,1280,2560,null),

  ('c7302a12-1ceb-0a62-6db7-a1d27b07489a'::uuid,
   'Common Octopus','Pieuvre',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Sea Fishing',ARRAY['Moyen','Doré']::shadow_size[],
   320,480,640,1280,2560,null),

  ('7f50faa5-4fde-ab1c-7c78-f7741536b117'::uuid,
   'Anglerfish','Baudroie',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Sea Fishing',ARRAY['Doré']::shadow_size[],
   320,480,640,1280,2560,null),

  ('2a1abc37-4370-9d98-f8b1-d144027f7903'::uuid,
   'Turbot','Turbot',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Sea Fishing',ARRAY['Moyen']::shadow_size[],
   320,480,640,1280,2560,null),

  ('52534496-2bb1-312e-403a-0c5f8c85e121'::uuid,
   'European Flying Squid','Calmar volant',5,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Sea Fishing',ARRAY['Doré']::shadow_size[],
   320,480,640,1280,2560,null),

  ('62156fd5-19dd-1397-2478-33d3b96b81f6'::uuid,
   'Nursehound','Roussette',6,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Sea Fishing',ARRAY['Grand','Doré']::shadow_size[],
   535,802,1070,2140,4280,null),

  ('b95debbe-6b26-9030-3ebf-599f69714036'::uuid,
   'Giant Oarfish','Régalec',7,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Mer','Sea Fishing',ARRAY['Doré']::shadow_size[],
   535,802,1070,2140,4280,null),

  ('c0f03688-4812-9734-73b1-f949642b62b3'::uuid,
   'Golden King Crab','Crabe royal doré',8,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Sea Fishing',ARRAY['Doré']::shadow_size[],
   850,1275,1700,3400,6800,null),

  ('0bd8851a-d3f6-13c6-1da4-ef5bf390097b'::uuid,
   'Moonfish','Lampris-lune',9,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Mer','Sea Fishing',ARRAY['Doré']::shadow_size[],
   850,1275,1700,3400,6800,null),

  ('4ffb73c1-c6db-72c5-9244-3baea1e7e094'::uuid,
   'Shortfin Mako Shark','Requin Mako',10,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Mer','Sea Fishing',ARRAY['Doré']::shadow_size[],
   850,1275,1700,3400,6800,null),

  ('a2669f9d-145f-bafe-8fa2-49e56fa4bc3a'::uuid,
   'Whale Shark','Requin-baleine',11,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit','Matin']::time_period[],
   'Mer','Sea Fishing',ARRAY['Or']::shadow_size[],
   0,0,0,0,0,null),

  ('7a68efa8-2e3b-7400-35ea-86a2d51fd36e'::uuid,
   'Moon Jellyfish','Méduse commune',12,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée','Nuit']::time_period[],
   'Mer','Sea Fishing',ARRAY['Or']::shadow_size[],
   0,0,0,0,0,null),

-- ── MER : Ocean ─────────────────────────────────────────────
  ('55079037-2b63-481d-732e-b98b84cb6716'::uuid,
   'Sardine','Sardine',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Ocean',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  ('f9c32e51-b09b-90bc-a42a-4219939700c7'::uuid,
   'Sea Bass','Perche de mer',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Ocean',ARRAY['Moyen']::shadow_size[],
   75,112,150,300,600,null),

  ('d7938396-09cf-e11d-2639-909b9cb91fbd'::uuid,
   'Skipjack Tuna','Bonite',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Ocean',ARRAY['Grand']::shadow_size[],
   210,315,420,840,1680,null),

  ('1b01ba99-91db-4b50-9028-0078ff631b0b'::uuid,
   'Rabbit Fish','Chimère argentée',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY[]::time_period[],
   'Mer','Ocean',ARRAY['Moyen','Bleu']::shadow_size[],
   320,480,640,1280,2560,'Attracteur Sirène'),

-- ── MER : Zephyr Sea ────────────────────────────────────────
  ('7d54675a-5301-a57d-8d73-6cb3e717ffc8'::uuid,
   'Beltfish','Poisson sabre',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Grand']::shadow_size[],
   105,157,210,420,840,null),

  ('472368f5-30f3-e30c-53a4-0ff2a078f9dd'::uuid,
   'Atlantic Pygmy Octopus','Pieuvre naine atlantique',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

  ('3b19eba4-025d-1b68-d128-df2dd97ea81f'::uuid,
   'False Scad','Comète coussut',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Moyen']::shadow_size[],
   155,232,310,620,1240,null),

  ('dc82508f-ecbf-a392-1c7a-7d2874546ee3'::uuid,
   'European Lobster','Homard européen',5,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  ('25299651-a495-184f-8959-bec4939a2fe9'::uuid,
   'Blackspot Seabream','Pagellus bogaraveo',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  ('40f71f7a-3c2e-bfa0-6a08-5c84fe90d6bd'::uuid,
   'Bluefin Tuna','Thon rouge',9,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Grand']::shadow_size[],
   850,1275,1700,3400,6800,null),

  ('5ee8e56d-4835-6f0a-e05e-5fb8f76e4406'::uuid,
   'Damselfly Fish','Poisson agrion',11,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Moyen']::shadow_size[],
   0,0,0,0,0,null),

  ('e6eeb096-ba48-8fdf-886b-9a679ff7badb'::uuid,
   'Half-Blue Golden Damselfish','Demoiselle dorée à queue bleue',14,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Petit']::shadow_size[],
   0,0,0,0,0,null),

-- ── MER : East Sea ──────────────────────────────────────────
  ('01a879f5-45d3-2c97-3a02-e71b905254a9'::uuid,
   'Common Prawn','Crevette de mer',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','East Sea',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  ('6f7ef2ee-e55c-ade2-5ec9-a7dbd3ca6a39'::uuid,
   'Hermit Crab','Bernard-l''ermite',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','East Sea',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  ('dbf46261-aef8-aa3f-112c-1236f07ccdb1'::uuid,
   'Goby','Gobie',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Mer','East Sea',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

  ('653690af-2e6e-b79d-cb6f-6c2422ae9ef5'::uuid,
   'Tub Gurnard','Grondin perlon',6,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','East Sea',ARRAY['Moyen']::shadow_size[],
   380,570,760,1520,3040,null),

  ('7b9389d3-8744-f1da-8cc9-291ff28fb426'::uuid,
   'Haddock','Églefin',8,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Mer','East Sea',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  ('75f13cde-5428-79d0-a569-dd1eb111c4fe'::uuid,
   'Ocean Sunfish','Poisson-lune',9,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin']::time_period[],
   'Mer','East Sea',ARRAY['Grand']::shadow_size[],
   850,1275,1700,3400,6800,null),

  ('a80b530b-cfe2-2d96-e3a3-1fc674d59ac1'::uuid,
   'Western Australian Fantasy Arowana','Arowana fantastique d''Australie',14,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin']::time_period[],
   'Mer','East Sea',ARRAY['Moyen']::shadow_size[],
   0,0,0,0,0,null),

-- ── MER : Whale Sea ─────────────────────────────────────────
  ('2297edf1-3bce-8e47-55c5-063f4607d9ba'::uuid,
   'Scad','Saurel',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Whale Sea',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  ('ba7add6b-30dd-611a-9afb-5b8aba19197e'::uuid,
   'Seahorse','Hippocampe',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Mer','Whale Sea',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  ('864f7b65-b5c3-9bcb-efa9-985e9a728dbb'::uuid,
   'Atlantic Salmon','Saumon atlantique',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Mer','Whale Sea',ARRAY['Moyen']::shadow_size[],
   155,232,310,620,1240,null),

  ('8560dfdf-5978-e53f-60cc-2201861d6bcc'::uuid,
   'Atlantic Mackerel','Maquereau commun',5,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Mer','Whale Sea',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

  ('cbbd1579-bfe9-528b-0f23-e434d3192788'::uuid,
   'King Crab','Crabe royal',8,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Mer','Whale Sea',ARRAY['Grand']::shadow_size[],
   535,802,1070,2140,4280,null),

  ('b323f86f-b8ac-4e3c-109e-8b6abc5572ca'::uuid,
   'Swordfish','Espadon',10,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Mer','Whale Sea',ARRAY['Grand']::shadow_size[],
   850,1275,1700,3400,6800,null),

  ('e3a3e7fa-3280-0374-7e57-7bd8f2f3fc0c'::uuid,
   'Green Sea Turtle','Tortue',12,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Mer','Whale Sea',ARRAY['Grand']::shadow_size[],
   0,0,0,0,0,null),

  ('a58fbe3d-7681-1577-eefc-1006932d7ffa'::uuid,
   'Lionfish','Poisson-lion',13,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit','Matin']::time_period[],
   'Mer','Whale Sea',ARRAY['Moyen']::shadow_size[],
   0,0,0,0,0,null),

-- ── MER : Old Sea ───────────────────────────────────────────
  ('0798295f-3db2-1eef-ab53-efdeff4108c9'::uuid,
   'Sea Stickleback','Epinoche de mer',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Old Sea',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  ('53a0004c-f2b2-e645-3a7d-0ac247fa1045'::uuid,
   'Clownfish','Poisson-clown',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Old Sea',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  ('72c6fb58-c4c9-bb41-be71-673138916d75'::uuid,
   'European Plaice','Plie commune',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Mer','Old Sea',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  ('dee44c62-0533-0b17-01aa-a716a2a0d7e8'::uuid,
   'Pufferfish','Tétraodon',6,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Mer','Old Sea',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  ('9a48b0ee-a92f-2f95-0157-2705ae3fb6a3'::uuid,
   'European Eel','Anguille européenne',7,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Soirée']::time_period[],
   'Mer','Old Sea',ARRAY['Moyen']::shadow_size[],
   380,570,760,1520,3040,null),

  ('35268a63-034d-2223-1d6a-047002827107'::uuid,
   'Smooth Hammerhead','Requin marteau',10,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Mer','Old Sea',ARRAY['Grand']::shadow_size[],
   850,1275,1700,3400,6800,null),

  ('f2db327f-1ac5-9927-d229-0c4d8b1d7023'::uuid,
   'Koi','Carpe Koï',12,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Mer','Old Sea',ARRAY['Grand']::shadow_size[],
   0,0,0,0,0,null),

  ('a61af480-a357-6203-f30e-f7fe0b53ff7d'::uuid,
   'Blue Tang','Coryphène',13,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée','Nuit']::time_period[],
   'Mer','Old Sea',ARRAY['Moyen']::shadow_size[],
   0,0,0,0,0,null),

-- ── LAC : Lake ──────────────────────────────────────────────
  ('936bc3c4-171b-9f16-e737-5df4a4b245eb'::uuid,
   'Common Bleak','Ablette',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Lake',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  ('f5f497db-ff5f-75d7-1550-42c3e680a11f'::uuid,
   'Common Chub','Carpe argentée',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Lake',ARRAY['Moyen']::shadow_size[],
   75,112,150,300,600,null),

  ('fcb4c122-3c1e-3899-80d7-d4f7447ef813'::uuid,
   'Edible Frog','Grenouille européenne',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY[]::time_period[],
   'Lac','Lake',ARRAY['Bleu']::shadow_size[],
   320,480,640,1280,2560,'Attracteur Sirène'),

-- ── LAC : Forest Lake ───────────────────────────────────────
  ('1b870373-ac72-84b1-bc37-3c5501442341'::uuid,
   'Tench','Tanche dorée',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Forest Lake',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  ('fd21507e-72ee-5994-5156-d0b0ea3c7e3a'::uuid,
   'Largemouth Bass','Grand black-bass',4,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Forest Lake',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  ('10142426-2024-e468-a92f-0c1472fc6a75'::uuid,
   'Mud Sunfish','Acantharchus pomotis',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Lac','Forest Lake',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  ('9ec4d092-2285-e903-5f18-6236e434eb43'::uuid,
   'European Crayfish','Ecrevisse noble',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit','Matin']::time_period[],
   'Lac','Forest Lake',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  ('179df377-bda0-abaa-309a-8d32ad21ef29'::uuid,
   'Large Pearl Mussel','Grande huître perlière',6,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Forest Lake',ARRAY['Moyen']::shadow_size[],
   380,570,760,1520,3040,null),

  ('80aff23c-c03e-07a5-7ef2-22e26513aa31'::uuid,
   'Blue European Crayfish','Écrevisse noble bleu',8,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Lac','Forest Lake',ARRAY['Petit']::shadow_size[],
   250,375,500,1000,2000,null),

  ('12e1d576-ceec-a339-2ff8-776758e84191'::uuid,
   'Arctic Char','Omble Chevalier',10,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Lac','Forest Lake',ARRAY['Moyen']::shadow_size[],
   610,915,1220,2440,4880,null),

  ('14049348-8913-f8ef-c4e2-d6b042205b41'::uuid,
   'Betta Fish','Combattant (Betta)',12,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Lac','Forest Lake',ARRAY['Petit']::shadow_size[],
   0,0,0,0,0,null),

-- ── LAC : Meadow Lake ───────────────────────────────────────
  ('af5f07d4-d31e-3aba-0847-5e29ee22b762'::uuid,
   'European Smelt','Eperlan',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Meadow Lake',ARRAY['Moyen']::shadow_size[],
   100,150,200,400,800,null),

  ('e9a6ed5a-b871-11bf-8586-e319fd661791'::uuid,
   'Trout','Truite',5,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Lac','Meadow Lake',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  ('7645edf1-eb77-1672-03b6-fc5d1ecfa8a1'::uuid,
   'Butterfly Koi','Koï papillon',4,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Meadow Lake',ARRAY['Grand']::shadow_size[],
   320,480,640,1280,2560,null),

  ('f684562a-d17b-3904-fc8c-ff1bf5c17c19'::uuid,
   'Goldfish','Poisson rouge',8,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Lac','Meadow Lake',ARRAY['Petit']::shadow_size[],
   250,375,500,1000,2000,null),

  ('e7cef337-cf4a-7ea3-c847-cfd6bcce3bdb'::uuid,
   'Wels Catfish','Silure Glane',10,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Lac','Meadow Lake',ARRAY['Moyen']::shadow_size[],
   610,915,1220,2440,4880,null),

  ('1f9874d1-c2b9-bbab-ff5a-31e7492491d4'::uuid,
   'Golden Arowana','Arowana doré',11,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Lac','Meadow Lake',ARRAY['Petit']::shadow_size[],
   0,0,0,0,0,null),

-- ── LAC : Suburban Lake ─────────────────────────────────────
  ('cd6bb906-9956-941c-2e0b-83da8040ae5f'::uuid,
   'Crucian Carp','Carpe noire',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Suburban Lake',ARRAY['Moyen']::shadow_size[],
   75,112,150,300,600,null),

  ('65c731ba-635d-df69-ecdf-61f268779ab2'::uuid,
   'Schneider','Barbeau',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Suburban Lake',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  ('f92a5f04-1524-abc5-5319-76db10952daf'::uuid,
   'Stone Loach','Loche des rochers',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Suburban Lake',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  ('48ee8518-c240-c558-a4e1-5b3dfb1234db'::uuid,
   'Mussel','Moule',3,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Suburban Lake',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  ('c55dcb70-3baa-35d4-fcde-45941c6f10ad'::uuid,
   'River Crab','Crabe de ruisseau',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Suburban Lake',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  ('7d6cbf3f-8f5e-6239-0c82-400a591795d7'::uuid,
   'Common Rudd','Rotengle',5,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Suburban Lake',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

  ('f5658803-701e-96d9-ca98-993e3db68698'::uuid,
   'Grayling','Omble commun',6,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Suburban Lake',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  ('dc916335-d5f0-b842-c5bb-b71de3185cc9'::uuid,
   'Mediterranean Killifish','Aphanius de Corse',7,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem']::time_period[],
   'Lac','Suburban Lake',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

  ('d4895c96-f84a-7dcd-f5de-1bf6b8e28124'::uuid,
   'European Mudminnow','Le Poisson-chien',8,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin']::time_period[],
   'Lac','Suburban Lake',ARRAY['Petit']::shadow_size[],
   250,375,500,1000,2000,null),

  ('2988ba63-0815-3a15-6e4b-fc2d4ecca63d'::uuid,
   'Northern Pike','Brochet tacheté',9,
   ARRAY['Pluie','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Lac','Suburban Lake',ARRAY['Moyen']::shadow_size[],
   610,915,1220,2440,4880,null),

  ('e78d03ba-d62f-6e50-fe6e-ee8b804d72a0'::uuid,
   'Angel Fish','Poisson-ange',12,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Lac','Suburban Lake',ARRAY['Moyen']::shadow_size[],
   0,0,0,0,0,null),

-- ── LAC : Onsen Mountain Lake ────────────────────────────────
  ('b14acc41-53bb-cfae-5a45-691709d9037c'::uuid,
   'Common Whitefish','Féra',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Onsen Mountain Lake',ARRAY['Moyen']::shadow_size[],
   105,157,210,420,840,null),

  ('2531e9eb-2d00-c5e6-daa0-ae3989f21dce'::uuid,
   'Ruffe','Grémille',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Lac','Onsen Mountain Lake',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  ('e1a7463d-7f3e-7afe-e8cc-c87f38002c58'::uuid,
   'Tadpole','Têtard',3,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Onsen Mountain Lake',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  ('92ccda3f-7d0a-c130-0e23-2a343cd9982b'::uuid,
   'Mottled Sculpin','Chabot',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Lac','Onsen Mountain Lake',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

  ('e21d4063-72bd-baf7-48d9-394a46a42dd3'::uuid,
   'Pumpkinseed','Crapet-soleil',9,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Lac','Onsen Mountain Lake',ARRAY['Petit']::shadow_size[],
   250,375,500,1000,2000,null),

  ('a6faa48e-4d05-70e3-e63f-cce8a09cf8fc'::uuid,
   'Bluegill','Crapet arlequin',10,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Lac','Onsen Mountain Lake',ARRAY['Petit']::shadow_size[],
   395,592,790,1580,3160,null),

  ('e9083103-5104-37b1-052b-52f61b515ad5'::uuid,
   'Lionhead Goldfish','Tête de lion (Poisson rouge)',11,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Onsen Mountain Lake',ARRAY['Petit']::shadow_size[],
   0,0,0,0,0,null),

-- ── RIVIÈRE : River ──────────────────────────────────────────
  ('b7a00353-7146-1fcb-3b60-53101645b40e'::uuid,
   'European Perch','Perche de rivière',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','River',ARRAY['Moyen']::shadow_size[],
   75,112,150,300,600,null),

  ('9c477e99-afe9-e151-623a-b6076a52cd5f'::uuid,
   'Oriental Shrimp','Crevette verte',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','River',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  ('1c6256ce-6272-b2c4-128a-e0b88a8780e0'::uuid,
   'Tilapia','Tilapia',4,
   ARRAY['Soleil','Pluie','Arc-en-ciel']::weather_type[],
   ARRAY[]::time_period[],
   'Rivière','River',ARRAY['Moyen','Bleu']::shadow_size[],
   320,480,640,1280,2560,'Attracteur Sirène'),

-- ── RIVIÈRE : Shallow River ──────────────────────────────────
  ('88045e0b-f207-8f9e-0ecc-3b16a6c51c4e'::uuid,
   'Barbel','Barbillon',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Shallow River',ARRAY['Moyen']::shadow_size[],
   75,112,150,300,600,null),

  ('53b99388-965b-6fa0-e38a-d7abe1735970'::uuid,
   'Three-Spined Stickleback','Epinoche',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Shallow River',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

-- ── RIVIÈRE : Tranquil River ─────────────────────────────────
  ('8d04727f-560f-5fd0-beae-701e289012ba'::uuid,
   'Minnow','Vairon',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Tranquil River',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  ('35709107-e555-edab-e10e-989aa7334ec2'::uuid,
   'Burbot','Lotte',4,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Rivière','Tranquil River',ARRAY['Grand']::shadow_size[],
   230,345,460,920,1840,null),

  ('b5ec2bc8-ec82-7fc9-2732-3114e5bf605a'::uuid,
   'Chum Salmon','Saumon kéta',6,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Tranquil River',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

-- ── RIVIÈRE : Giantwood River ────────────────────────────────
  ('26914d95-3862-421f-a753-e64974842155'::uuid,
   'Spined Loach','Loche des fleurs',1,
   ARRAY['Soleil','Pluie','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Giantwood River',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  ('b2975e5a-56b3-12c3-0a7d-5a0e2c774f88'::uuid,
   'Zander','Sandre blanc',3,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Giantwood River',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  ('5343836c-0296-3cc1-fac5-62ec82a14788'::uuid,
   'Red-Bellied Piranha','Piranha à ventre rouge',4,
   ARRAY['Soleil','Pluie','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Giantwood River',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  ('c6348b56-9706-3bc7-958a-85d8790f66b5'::uuid,
   'Huchen','Huchon',9,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Rivière','Giantwood River',ARRAY['Moyen']::shadow_size[],
   380,570,760,1520,3040,null),

-- ── RIVIÈRE : Rosy River ─────────────────────────────────────
  ('73ba0b2d-7671-d5e6-7467-7101bddbc72e'::uuid,
   'Streber','Zingel streber',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Rosy River',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  ('b64dfd73-d2c0-bdc6-b517-7abdcccd58fc'::uuid,
   'Common Carp','Carpe commune',4,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Rivière','Rosy River',ARRAY['Moyen']::shadow_size[],
   50,75,100,200,400,null),

  ('5cf62d70-0bb5-5730-1ef9-d255afe476fa'::uuid,
   'Freshwater Blenny','Blennie fluviatile',5,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Rosy River',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null);


-- ============================================================
-- INSECTES (76)
-- Colonnes : id, name_en, name, passion_level, weather, "time",
--            exact_location, sell_price_1..5_star
-- ============================================================

insert into public.insect (
  id, name_en, name, passion_level, weather, "time",
  exact_location,
  sell_price_1_star, sell_price_2_star, sell_price_3_star,
  sell_price_4_star, sell_price_5_star
) values

-- ── Zone de Départ et Centre-Ville ─────────────────────────
  ('97d92ddf-a70b-0017-c043-81c2e6520da9'::uuid,
   'Large Red Damselfly','Grand agrion',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Bord de l''eau',35,52,70,140,280),

  ('682e8699-fefc-b0bf-a589-cd71a8b14bfe'::uuid,
   'Orange-Tip','Piéride du cresson',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Zone Centrale',30,45,60,120,240),

  ('d26583f1-133b-ddd8-227c-6f5477b9b472'::uuid,
   'Common Blue Butterfly','Azuré de Porcelaine',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Zone Centrale',105,157,210,300,600),

  (md5('insect_Sulkowsky''s Morpho')::uuid,
   'Sulkowsky''s Morpho','Papillon de nuit luminescent',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Attracteur d''insectes gonflable',90,135,180,360,720),

  ('4c56838b-ceaf-b89a-4e5a-f53866112f4a'::uuid,
   'Common Whitetail','Libellule à queue blanche',4,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rive de la rivière',75,112,150,300,600),

-- ── Événement Appât ─────────────────────────────────────────
  ('a5970907-140d-b420-4110-aa60aa2cbb91'::uuid,
   'Apollo','Parnassien',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Appât',30,45,60,120,240),

  ('7a2b752e-e15e-c0a4-71c8-0e2b920710a5'::uuid,
   'Postman Butterfly','Papillon à anneaux rouges',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Appât',30,45,60,120,240),

  ('767103a7-3f01-6221-33a5-815a029d30d0'::uuid,
   'Pink Katydid','Sauterelle rose',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Appât',90,135,180,360,720),

  ('1085e6a8-4497-0549-4837-a378bbd19738'::uuid,
   'White Witch','Papillon sorcière blanche',6,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Appât',90,135,180,360,720),

  ('b725a305-7d33-a209-6624-35c796d3fff5'::uuid,
   'Chestnut Tiger','Grand paon de nuit',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Appât',150,225,300,600,1200),

  ('d7eb4a9d-9b22-5b80-bdac-0d5e66b0603a'::uuid,
   'Rainbow Stag Beetle','Pioche arc-en-ciel',10,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Ruines de l''Événement',440,660,880,1760,3520),

-- ── Terrains Privés et Rochers ──────────────────────────────
  ('7102cc39-3416-8f63-d173-4b674e2376ee'::uuid,
   'European Firebug','Pyrrhocoris apterus',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rochers du terrain',35,52,70,140,280),

  ('fc8ae2bd-8e9a-faf5-336b-57b0e361b315'::uuid,
   'Amethyst Flower Beetle','Cétoine étoilée bleue',2,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rochers du terrain',165,247,330,660,1320),

  (md5('insect_Rajah Brooke''s Birdwing')::uuid,
   'Rajah Brooke''s Birdwing','Papillon à col rouge',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit','Matin']::time_period[],
   'Terrains privés',90,135,180,360,720),

-- ── Banlieue ────────────────────────────────────────────────
  ('931dda9c-cd8a-a635-6676-328f5b85fca6'::uuid,
   'Common Brimstone','Citron aspasia',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Banlieue',30,45,60,120,240),

  ('3979723e-938e-9214-2723-b4befffecd17'::uuid,
   'Four-Spotted Skimmer','Libellule tachetée',2,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rive de la banlieue',75,112,150,300,600),

  ('536d397b-79b0-ddd0-3d20-ed8efccdf9cf'::uuid,
   'Seven-Spotted Ladybug','Coccinelle à sept points',2,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Banlieue',110,165,220,440,880),

  ('6a221da3-c3db-a08d-666b-1f5b85d731e6'::uuid,
   'Mini Moon Moth','Actias neidhoederi',3,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit','Matin']::time_period[],
   'Banlieue',105,158,210,420,840),

  ('132e2685-6b25-0fc8-a50b-93844002b70a'::uuid,
   'Large Banded Grasshopper','Criquet à ailes réticulées',4,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Banlieue',140,210,280,460,1120),

  ('53b513f9-9f32-ab6d-8876-1b8f033f22cd'::uuid,
   'Green Birdwing','Ornithoptère vert',6,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Banlieue',150,225,300,600,1200),

  ('402507c1-2c59-1461-9cf4-e6839ee4429b'::uuid,
   'Comet Moth','Comète papillon de nuit',8,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Banlieue',240,360,480,960,1920),

  (md5('insect_Queen Alexandra''s Birdwing')::uuid,
   'Queen Alexandra''s Birdwing','Ornithoptère de la Reine Alexandra',11,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Rive de la banlieue',0,0,0,0,0),

  ('a5ddcc84-bc1b-25c2-b2be-fc7a11ccd2d3'::uuid,
   'Gorgeous Damselfly','Demoiselle magnifique',13,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Rive de la banlieue',0,0,0,0,0),

-- ── Village de Pêcheurs ─────────────────────────────────────
  ('97bf48b7-3a78-c25c-8137-7991b9227ec8'::uuid,
   'Cabbage White','Papillon blanc',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Village',30,45,60,120,240),

  ('bb0ccbf2-2446-f20e-9f44-72a82c1f9858'::uuid,
   'Siberian Grasshopper','Criquet aux pattes massives',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Village',90,135,180,360,720),

  ('2359e63b-3939-5385-a72e-ea97800bd7a5'::uuid,
   'Ant','Fourmi',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Place du Village',220,330,440,880,1760),

  ('c9bb26d0-1e45-2c6d-b6ab-24008951c215'::uuid,
   'Beautiful Leopard','Mélitée léopard',4,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit','Matin']::time_period[],
   'Quai du Village',90,135,180,360,720),

  ('79cd95f2-eae1-3ab2-f183-afe9e5572506'::uuid,
   'Blue Shieldbug','Punaise bleue',6,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Phare du Village',110,165,220,440,880),

  ('b769bbb4-8ad0-0fe8-493f-42478d6c52a2'::uuid,
   'Horned Beetle','Scarabée unicorne',8,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Jetée Est',275,412,550,1100,2200),

  ('6b2d8468-87d3-71e2-38eb-d8653a98e711'::uuid,
   'Cerulean Carpenter','Abeille charpentière bleue',9,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Place du Village',440,660,880,1760,3520),

-- ── Mont Onsen ───────────────────────────────────────────────
  ('63683d41-fdac-4a61-b734-70b9e45878c7'::uuid,
   'Gold Grasshoppers','Sauterelle de l’oasis',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mont Onsen',45,67,90,180,360),

  ('d2ec6c75-dece-cb95-f5ab-1b582ff5e2c6'::uuid,
   'Green Tiger Beetle','Cicindèle verte',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mont Onsen',110,165,220,440,880),

  ('b6a016d0-b822-b20f-af66-c9824be16c33'::uuid,
   'Fire-Colored Beetle','Pyrochroa',3,
   ARRAY['Soleil','Pluie','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mont Onsen',110,165,220,440,880),

  ('93e965cb-7cfa-acb8-cff1-01fb55bab451'::uuid,
   'Four-Spotted Ladybug','Coccinelle à quatre étoiles',4,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac du Cratère',165,247,330,660,1320),

  ('afd9a020-3f4a-5581-3844-a7567d07975e'::uuid,
   'Hercules Beetle','Scarabée Hercule',10,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Lac du Cratère',440,660,880,1760,3520),

  ('92976c13-7e68-8d3e-a6fd-5a6c2556e119'::uuid,
   'Mediterranean Mantis','Mante arc-en-ciel',5,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Falaise rocheuse',195,292,390,780,1560),

  ('c21bc1d5-56c7-b428-a11e-fee15c79874b'::uuid,
   'Giant Asian Mantis','Mante Papoue',5,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Ruines d''Onsen',390,585,780,1560,3120),

  ('d120b3e2-59d0-dae9-ca47-f7bd8e3d5124'::uuid,
   'Mourning Cloak','Charaxes jasius',5,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Mont Onsen',90,135,180,360,720),

  ('8683a473-7a6e-d4b5-cb40-386be7bf6c3f'::uuid,
   'Silver Jewel Scarab','Scarabée argenté aux gemmes',6,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Falaise rocheuse',165,247,330,660,1320),

  ('99754c24-9188-bfec-eb97-b075170cbd82'::uuid,
   'Crimson Marsh Glider','Libellule rose',7,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem']::time_period[],
   'Bord du lac',185,277,370,740,1480),

  ('2caa1457-6b8d-3228-8b52-8006cf957023'::uuid,
   'Minotaur Beetle','Scarabée sacré',8,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Ruines d''Onsen',275,412,550,1100,2200),

  ('ff4d641c-b46f-0b7b-7fc4-b283eaaae40c'::uuid,
   'Conehead Mantis','Mante à tête conique',9,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Ruines d''Onsen',515,772,1030,2060,4120),

  ('bbc8c9d4-ef41-5c18-5627-8c242aa5cd68'::uuid,
   'Orchid Mantis','Mante orchidée',11,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Ruines d''Onsen',0,0,0,0,0),

  ('ac5d9921-3286-6842-5fc7-8fa443136c23'::uuid,
   'Milkweed Grasshopper','Criquet de l''asclépiade',12,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Lac d''Onsen',0,0,0,0,0),

  ('5271f739-4f99-75bd-4745-aed040bff6a7'::uuid,
   'Dream Glow Butterfly','Papillon éclat de rêve',13,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Cratère du lac d''Onsen',0,0,0,0,0),

-- ── Forêt de Pins du Chêne Spirituel ────────────────────────
  ('186ce73b-5524-69b3-ade2-d544d3ac586a'::uuid,
   'Cicada','Cigalle',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Forêt de pins',220,330,440,880,1760),

  ('2f556814-9a5c-7102-8872-3a010c526255'::uuid,
   'Blue Morpho','Morpho bleu',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin']::time_period[],
   'Forêt de pins',150,225,300,600,1200),

  ('2966b093-08e1-8f9a-3ace-0d9efeb3561c'::uuid,
   'Spanish Moon Moth','Isabelle',9,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Forêt de pins',150,225,300,600,1200),

  ('269739f3-02c3-6649-69aa-ca422cd5eb71'::uuid,
   'Golden Stag Beetle','Lucane doré spectral',9,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Forêt de pins',440,660,880,1760,3520),

  ('8add407a-c078-5e40-a0dc-b66353f7beec'::uuid,
   'Southeast Asian Giant Rhinoceros Beetle','Scarabée rhinocéros géant d''Asie',11,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée','Nuit']::time_period[],
   'Forêt de pins',0,0,0,0,0),

-- ── Champ de Fleurs ──────────────────────────────────────────
  ('7a7bdff3-802e-36f2-9a2e-694d2a8c5021'::uuid,
   'Asparagus Beetle','Criocère de l''asperge',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs',55,82,110,220,440),

  ('f8b2354c-cfc0-326f-1460-ced36dbbd33c'::uuid,
   'Bumblebee','Bourdon',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs',110,165,220,440,880),

  ('65696e5f-3ffc-9ebd-9f80-4e6ea2794561'::uuid,
   'Katydid','Grillon',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs',180,270,360,720,1440),

  ('2eca3e7d-a41b-9528-0ec7-b5f4a99f8a01'::uuid,
   'Purple Emperor','Vanesse violette',3,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem']::time_period[],
   'Montagne des Baleines',90,135,180,360,720),

  ('a40f08ff-ef44-6552-6e34-29edc8ed27ab'::uuid,
   'Splay-Footed Carpenter','Abeille charpentière violette',5,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Montagne des Baleines',165,247,330,660,1320),

  ('c8834a18-8bc1-148c-06d5-0906e1c6a8fa'::uuid,
   'Peacock Butterfly','Paon de jour',5,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs du Moulin',90,135,180,360,720),

  ('8f8e87d0-406c-e450-6f4d-36a8efc1d6ea'::uuid,
   'Elegant Flower Beetle','Cétoine étoilée',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Montagne des Baleines',275,412,550,1100,2200),

  ('c891222a-342a-443b-92fd-1154aeb20f92'::uuid,
   'Picasso Bug','Punaise Picasso',8,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Plage d''Améthyste',185,277,370,740,1480),

  ('cbbbfcbc-9872-d76a-ff7a-02bb08cfbd8f'::uuid,
   'Mother of Pearl','Hypolimnas vert',9,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs du Moulin',240,360,480,960,1920),

  ('faf51190-eaf3-ed0b-1168-d1eca7f2fdaf'::uuid,
   'Morpho Helena','Papillon bleu céleste',10,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Plage d''Améthyste',240,360,480,960,1920),

  ('f0ea85b5-60a4-3598-4bdf-6c67856ee0a2'::uuid,
   'Rose Swallowtail Butterfly','Voilier rose',12,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs du Moulin',0,0,0,0,0),

  ('bb32a631-4b08-b256-f7b9-6b1390da9a43'::uuid,
   'Flame Dragonfly','Libellule de feu',12,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Montagne des Baleines',0,0,0,0,0),

  ('10741526-2ca6-652f-dc2e-d4739857f564'::uuid,
   'Glasswing Butterfly','Papillon aux ailes de verre',14,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Montagne des Baleines',0,0,0,0,0),

-- ── Forêt ────────────────────────────────────────────────────
  ('35ca5d51-c17f-d3c7-3be0-7a68867d8d2f'::uuid,
   'Old World Swallowtail','Papillon doré',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Forêt',30,45,60,120,240),

  ('a19690fe-bc0c-c689-1262-3633c54bd088'::uuid,
   'Wasp Beetle','Capricorne tigré',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Forêt',110,165,220,440,880),

  ('f0b20443-0314-6c24-8d4d-a57af69d0ed6'::uuid,
   'Waroona Cuckoo Bee','Abeille à queue blanche',3,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Tour des cerfs',165,247,330,660,1320),

  ('668a55cc-3108-d213-07e7-7c36ccf5cfe3'::uuid,
   'Alpine Longhorn Beetle','Capricorne des montagnes',5,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Île de la forêt',165,247,330,660,1320),

  ('a8c789a0-72f9-442d-0cec-3ca015afb4e0'::uuid,
   'Asian Lady Beetle','Coccinelle asiatique',5,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Tour des cerfs',165,247,330,660,1320),

  ('c5f51fa4-e603-83bf-c8a9-3e4fb61182fe'::uuid,
   'Beautiful Demoiselle','Agrion de Virginie',6,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rive du lac de la forêt',110,165,220,440,880),

  ('fb120798-d967-9986-9672-6fce10b4f411'::uuid,
   'Golden Jewel Scarab','Scarabée doré aux gemmes',7,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Puzzle de saut',275,412,550,1100,2200),

  ('182685cb-13ec-8f03-541c-5f956f0aac49'::uuid,
   'Stag Beetle','Lucanus',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin']::time_period[],
   'Puzzle de saut',275,412,550,1100,2200),

  ('35f63f3a-602c-8fbc-be2a-58f7b7877128'::uuid,
   'Bagworm Moth','Chenille porte-case',10,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Tour des cerfs',440,660,880,1760,3520),

  ('2cfdb71e-3643-2cef-0b83-6a18c6af0846'::uuid,
   'Sunset Morpho','Papillon de soleil',10,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Tour des cerfs',240,360,480,960,1920),

  ('6eba3057-d963-9bed-4feb-9bb46eee1b41'::uuid,
   'Goliathus Atlas Beetle','Scarabée Goliath',12,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Tour des cerfs',0,0,0,0,0),

  ('9de11ee4-eea5-1a83-e9a3-9feafb4a43c5'::uuid,
   'Green Snail','Escargot vert',14,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Île de la forêt',0,0,0,0,0),

-- ── Zones Spécifiques / Montagnes ────────────────────────────
  ('53344d53-8dc7-7b41-511d-82c2b144ef0b'::uuid,
   'Little Thirteen-Star Ladybug','Petite coccinelle à treize points',11,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Montagne des Baleines',0,0,0,0,0)

on conflict (name) do update set
  name_en            = excluded.name_en,
  passion_level      = excluded.passion_level,
  weather            = excluded.weather,
  "time"             = excluded."time",
  exact_location     = excluded.exact_location,
  sell_price_1_star  = excluded.sell_price_1_star,
  sell_price_2_star  = excluded.sell_price_2_star,
  sell_price_3_star  = excluded.sell_price_3_star,
  sell_price_4_star  = excluded.sell_price_4_star,
  sell_price_5_star  = excluded.sell_price_5_star;


-- ============================================================
-- OISEAUX (70)
-- Colonnes : id, name_en, name, passion_level, weather, "time",
--            exact_location, sell_price_1..5_star
-- ============================================================

insert into public.bird (
  id, name_en, name, passion_level, weather, "time",
  exact_location,
  sell_price_1_star, sell_price_2_star, sell_price_3_star,
  sell_price_4_star, sell_price_5_star
) values

-- ── Zones Générales et Aquatiques ───────────────────────────
  ('5acf61a3-323d-1de6-c3ea-9d9a9dab7a00'::uuid,
   'Greater Flamingo','Grand flamant',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Bord de l''eau',15,60,120,240,480),

  ('42a32f02-fc19-adaf-b69f-2bbecdff0c2c'::uuid,
   'Mallard','Canard colvert',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac',12,50,100,200,400),

  ('85e46d07-d31d-0556-b76a-dababd4a1fd6'::uuid,
   'Eurasian Wigeon','Canard siffleur',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière',17,70,140,280,560),

  ('a283a3ec-a989-5d34-dea5-864659b5b9ce'::uuid,
   'King Eider','Eider royal',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière',17,70,140,280,560),

  ('8aef596f-b586-f155-ab6a-3af637a84d8d'::uuid,
   'Seagull','Mouette',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Bord de mer',17,70,140,280,560),

  ('b0fa2ea4-7786-f457-dd79-e753313627b7'::uuid,
   'European Shag','Cormoran vert européen',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Océan',17,70,140,280,560),

-- ── Événement Nid des Cent ──────────────────────────────────
  ('478842ca-e37f-ad6c-f1c8-6585ffb914d9'::uuid,
   'Blue Peafowl','Paon bleu',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',10,40,80,160,320),

  ('3a300dd3-2356-4dcb-cd74-9a6e768a8d1f'::uuid,
   'Blue-and-Yellow Macaw','Ara bleu et jaune',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',7,30,60,120,240),

  ('38cf56fc-37b3-654d-69a8-264c0901adb3'::uuid,
   'Red-and-Green Macaw','Ara rouge et vert',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',10,40,80,160,320),

  ('0a51c7c9-89ce-e626-edc9-efb96b8ae8e7'::uuid,
   'Great Green Macaw','Grand ara vert',5,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',15,60,120,240,480),

  (md5('bird_Lear''s Macaw')::uuid,
   'Lear''s Macaw','Ara indigo',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',22,90,180,360,720),

  ('0e5832e8-9458-7216-e021-b28377c611de'::uuid,
   'Green Peafowl','Paon vert',9,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',37,150,300,600,1200),

  ('95e57956-12e8-da65-f9ae-6efef8d6c96f'::uuid,
   'White Peacock','Paon blanc',11,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',0,0,0,0,0),

  ('5c8eb5b7-4f3b-5810-1a41-0f99250bf5df'::uuid,
   'Black Peacock','Paon noir',13,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',0,0,0,0,0),

-- ── Banlieue et Terrains Privés ─────────────────────────────
  ('d57fbb09-48ef-d06c-45f5-08325f43facf'::uuid,
   'Eurasian Collared Dove','Tourterelle grise',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Terrains privés',10,40,80,160,320),

  ('ecabc2f7-3971-31e0-ca82-6603add79e45'::uuid,
   'Eurasian Golden Oriole','Golden Oriole',3,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Terrains privés',15,60,120,240,480),

  ('63742b35-1a22-d674-bcb8-d665bfcd20a9'::uuid,
   'Eurasian Bullfinch','Bouvreuil à ventre rouge',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Banlieue',7,30,60,120,240),

  ('8d4702e4-239a-fc00-a67f-a42e33e028a0'::uuid,
   'Woodchat Shrike','Pie-grèche à tête rousse',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Banlieue',10,40,80,160,320),

  ('613b8f7d-ef4f-d35b-4a88-4538d0eaad21'::uuid,
   'Ruddy Shelduck','Tadorne casarca',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac de banlieue',17,70,140,280,560),

  ('9c3e6aee-d35b-f025-55bf-dd07a63cf4e8'::uuid,
   'Jambu Fruit Dove','Colombe jambu',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Banlieue',27,110,220,440,880),

  ('3a7132c6-25cd-296f-922e-0012c33c28a6'::uuid,
   'Eastern Bluebird','Merle bleu de l''Est',8,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Banlieue',30,120,240,480,960),

  ('1a85598a-f0aa-bd8a-d4e9-efc9facadff8'::uuid,
   'Paradise Tanager','Calliste septicolore',9,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Banlieue',30,120,240,480,960),

  ('7f94f595-741a-d8dd-f61e-eefa82d6befd'::uuid,
   'Nicobar Pigeon','Pigeon à camail',11,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée','Nuit']::time_period[],
   'Banlieue',0,0,0,0,0),

  ('eb7f0375-d426-a6f6-6efd-5ddba44980f4'::uuid,
   'Mute Swan','Cygne tuberculé',13,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rive de la banlieue',0,0,0,0,0),

  ('1350d775-8d1c-879e-a4d8-1e77e4e12c30'::uuid,
   'Black Swan','Cygne noir',13,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Rive de la banlieue',0,0,0,0,0),

-- ── Zone Centrale ────────────────────────────────────────────
  ('d3fbde4f-2e1c-4a65-c589-fc7660976562'::uuid,
   'Stock Dove','Pigeon colombin',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Zone centrale',10,40,80,160,320),

  ('8e522061-749b-14a3-c7f6-b242899363d5'::uuid,
   'Eurasian Robin','Rouge-gorge',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Zone centrale',7,30,60,120,240),

  ('3df62073-3947-5a04-fa44-eda26a0fca21'::uuid,
   'Long-Tailed Tit','Aegithalos caudatus',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Tête de Blanc',2,8,16,32,64),

-- ── Village de Pêcheurs ─────────────────────────────────────
  ('9634f919-04de-8fac-f9f7-3663f85563f1'::uuid,
   'Pied Imperial Pigeon','Tourterelle tigrine',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Village de pêcheurs',10,40,80,160,320),

  ('90a1e7f4-d19c-7ccc-9eed-bdb9e763a513'::uuid,
   'Eurasian Nuthatch','Sittelle',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Village de pêcheurs',10,40,80,160,320),

  (md5('bird_Przevalski''s Parrotbill')::uuid,
   'Przevalski''s Parrotbill','Cardinal à couronne grise',4,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Place du village',15,60,120,240,480),

  ('7d26bdf5-ae43-2a27-00e5-fde2207b4faa'::uuid,
   'Yellow Bellied Flycatcher','Moucherolle à ventre jaune',5,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Quai du village',15,60,120,240,480),

  ('c50a3899-846f-7e88-6292-893eb78a90a2'::uuid,
   'Cinnamon Ground Dove','Tourterelle à tête grise',6,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Jetée Est du village',27,110,220,440,880),

  ('518e69e1-2939-a536-49da-153a64f9d487'::uuid,
   'Double-Barred Finch','Diamant mandarin',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Phare du village',10,40,80,160,320),

  ('8fce63e1-4bd3-9973-f01a-6dd1ad5fac4a'::uuid,
   'Azores Bullfinch','Bouvreuil',10,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Phare du village',30,120,240,480,960),

-- ── Champ de Fleurs ──────────────────────────────────────────
  ('b9adf700-1723-297b-b95e-7921c25b57fc'::uuid,
   'Pink-Necked Green Pigeon','Colombar à cou rose',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs',15,60,120,240,480),

  ('4f90dfef-eebc-257b-bd47-e537dc886053'::uuid,
   'Eurasian Chaffinch','Fringilla coelebs',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs',7,30,60,120,240),

  ('c92a1024-e916-dbb1-f58f-7c4f7ede9e47'::uuid,
   'White Wagtail','Bergeronette grise',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Plage d''Améthyste',15,60,120,240,480),

  ('48c89612-2b94-d7c8-eb06-ff69a0689c2b'::uuid,
   'American Flamingo','Flamant rose américain',9,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Plage d''Améthyste',55,220,440,880,1760),

  (md5('bird_Wallace''s Fruit Dove')::uuid,
   'Wallace''s Fruit Dove','Pigeon aux fruit d''or',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Moulin du champ de fleurs',17,70,140,280,560),

  ('9f21d870-71b1-cc0b-ead0-44cd77af238b'::uuid,
   'Azure Tit','Mésange bleue',7,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Moulin du champ de fleurs',22,90,180,360,720),

  ('edc46e56-d9ac-7540-12f1-1ee1f0d7c1e4'::uuid,
   'Pink Pigeon','Pigeon rose',8,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Montagne des Baleines',27,110,220,440,880),

  ('eb0399ca-41c7-783a-a839-e18bd4ba107f'::uuid,
   'Purple Finch','Roselin pourpré',11,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Moulin du champ de fleurs',0,0,0,0,0),

-- ── Mont Onsen et Mer Ancienne ───────────────────────────────
  ('ef84ae6b-7b9d-3842-750e-19799baf89d6'::uuid,
   'Brown Noddy','Sterne blanche',5,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Bord de mer ancienne',22,90,180,360,720),

  ('c8a522a4-e71e-3d35-e9aa-7ed0c4e90d7e'::uuid,
   'Great Tit','Grand pic',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mont Onsen',7,30,60,120,240),

  ('7950ff1b-43ee-940f-73d4-cd6659bd243e'::uuid,
   'Bearded Reedling','Panure à moustaches',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mont Onsen',10,40,80,160,320),

  ('5be47fb1-d5ed-c109-ad20-c0f6860efefa'::uuid,
   'African Olive Pigeon','Pigeon à yeux jaunes',5,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mont Onsen',27,110,220,440,880),

  ('44d8cd67-7a87-b28c-fb4a-e9c67ad258b6'::uuid,
   'Peregrine Falcon','Faucon pèlerin',8,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Mont Onsen',65,260,520,1040,2080),

  ('cef219c7-0b3a-4750-5399-11c1ca7c5435'::uuid,
   'Hawfinch','Gros-bec',6,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac du cratère Onsen',15,60,120,240,480),

  ('4bdb500c-5ae7-f2c9-f968-de0641c8fe7d'::uuid,
   'Long Eared Owl','Hibou moyen-duc',6,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Falaise d''Onsen',47,190,380,760,1520),

  ('8e48b565-d946-1c7d-1537-a74bb27dbcbe'::uuid,
   'European Bee-Eater','Guêpier d''Europe',5,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rive du lac Onsen',22,90,180,360,720),

  ('dfbef083-a063-7056-c24a-283b620420c5'::uuid,
   'White-Headed Duck','Canard à tête blanche',9,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Rive du lac Onsen',45,180,360,720,1440),

  ('0815d352-d5d8-ce2b-9e1f-8c0b2deabcdc'::uuid,
   'Lady Amherst Pheasant','Faisan à ventre blanc',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Ruines d''Onsen',17,70,140,280,560),

  ('bd2d3023-6b65-e278-018c-caacea907516'::uuid,
   'Amur Falcon','Faucon à pattes rouges',10,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Ruines d''Onsen',65,260,520,1040,2080),

  ('b4a96bdd-39a7-d19c-5e10-a8efc544651f'::uuid,
   'Spot-billed Duck','Canard à bec tacheté',11,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Lac du mont Onsen',0,0,0,0,0),

  ('5020e505-1f16-e97c-e7f3-56d41f365866'::uuid,
   'Red-billed Leiothrix','Léiotrix à bec rouge',12,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Cratère du lac Onsen',0,0,0,0,0),

  ('69f62494-096e-2a5c-d1ae-210f34d05a1c'::uuid,
   'Rock Pigeon','Pigeon biset',11,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin']::time_period[],
   'Côte de la mer ancienne',0,0,0,0,0),

-- ── Forêt ────────────────────────────────────────────────────
  ('c8c05db5-f59d-835a-59fb-e398cb4e6895'::uuid,
   'Eurasian Wren','Troglodyte',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Forêt',7,30,60,120,240),

  ('914025b2-5d85-08be-6221-857f1b2c181c'::uuid,
   'Wonga Pigeon','Pigeon de Wonga',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Forêt',15,60,120,240,480),

  ('3964f88e-7d25-d6f9-8c16-19c869867dc7'::uuid,
   'Silver-Throated Tit','Mésange à menton argent',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Puzzle de saut forêt',10,40,80,160,320),

  ('6dd509d8-20f9-15c3-c644-a4aa9aaf331a'::uuid,
   'Verditer Flycatcher','Gobemouche vert-de-gris',10,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Puzzle de saut forêt',30,120,240,480,960),

  ('a6da7898-00e5-5ea8-b317-898d823dfd1d'::uuid,
   'Pine Grosbeak','Pinson',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Île de la forêt',15,60,120,240,480),

  ('c18b42b8-961f-03cc-83d5-24f65b5c2793'::uuid,
   'Smew','Harle Piette',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac de la forêt',22,90,180,360,720),

  ('71f9e3f0-cc1d-40d9-ceac-c497442ccc34'::uuid,
   'Lesser Flamingo','Petit flamant',5,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rive du lac forêt',27,110,220,440,880),

  ('12f6bc91-2013-f644-51b3-6517b760ee7b'::uuid,
   'Regent Bowerbird','Jardinier à tête jaune',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Forêt de pins du chêne spirituel',15,60,120,240,480),

  ('94bec550-02cf-1af7-7395-f61874e799bf'::uuid,
   'Redpoll','Linotte à dos blanc',8,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Forêt de pins du chêne spirituel',22,90,180,360,720),

  ('edd90479-aee1-8858-19b7-1c4777f868de'::uuid,
   'Common Kestrel','Faucon rouge',7,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Tour des cerfs',47,190,380,760,1520),

  ('5c6e1970-21d5-08f5-9931-8a9916d470e5'::uuid,
   'Eagle-Owl','Grand-duc d''Europe',10,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Tour des cerfs',65,260,520,1040,2080),

  ('391283d2-e886-17b3-f8c2-e64b879577ce'::uuid,
   'Snowy Owl','Harfang des neiges',12,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Cime des arbres forêt spirituelle',0,0,0,0,0),

  ('f3716f74-b9f1-4d6d-a5c3-ff65ee1fbaaa'::uuid,
   'Spectacled Owl','Chouette à lunettes',14,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Plateforme d''observation forêt',0,0,0,0,0)

on conflict (name) do update set
  name_en            = excluded.name_en,
  passion_level      = excluded.passion_level,
  weather            = excluded.weather,
  "time"             = excluded."time",
  exact_location     = excluded.exact_location,
  sell_price_1_star  = excluded.sell_price_1_star,
  sell_price_2_star  = excluded.sell_price_2_star,
  sell_price_3_star  = excluded.sell_price_3_star,
  sell_price_4_star  = excluded.sell_price_4_star,
  sell_price_5_star  = excluded.sell_price_5_star;


-- ============================================================
-- PLATS (food) — 84 entrées
-- Colonnes : id, name_en, name, passion_level_required,
--   sell_price_1..5_star, total_cost, recipe_text
-- ============================================================

insert into public.food (
  id, name_en, name, passion_level_required,
  sell_price_1_star, sell_price_2_star, sell_price_3_star,
  sell_price_4_star, sell_price_5_star,
  total_cost, recipe_text
) values
  ('42be1f9a-aef1-f678-f561-0b7d97120fcc'::uuid,        'House Salad',       'Salade de campagne',    1,     90, 135, 180, 360, 720,    20,'2 Tout type de légumes'),
  ('430e9329-d8c3-7a7d-7977-05d595874239'::uuid,          'Mixed Jam',         'Confiture assortie',  1,    160, 240, 320, 640,1280,     0,'4 Tout type de fruits'),
  ('50ec2c6e-6485-8ce6-8cbb-cd94e60cfdb3'::uuid,      'Blueberry Jam',     'Confiture de myrtille',1,170, 255, 340, 680,1360,   0,'4 Myrtilles'),
  ('c50a14b3-ca98-a761-31f4-eaf4a4143b66'::uuid,       'Tomato Sauce',      'Sauce tomate',     1,    180, 270, 360, 720,1440,    40,'4 Tomates'),
  ('6917c831-f05c-bd17-b8b2-9f09450e5b72'::uuid,      'Raspberry Jam',     'Confiture de framboise',1,250,475, 500,1000,2000,    0,'4 Framboises'),
  ('9ee3abd4-308a-70fc-d201-dc09d8d75ebd'::uuid,          'Apple Jam',         'Confiture de pomme',1,  270, 405, 540,1080,2160,    0,'4 Pommes'),
  ('2856117d-63a1-dac9-7496-2e28bd1c397c'::uuid,       'Mandarin Jam',      'Confiture d''orange',1,270,405, 540,1080,2160,   0,'4 Oranges'),
  ('7823f3c9-daa3-ed92-8338-8e3608caa63a'::uuid,      'Pineapple Jam',     'Confiture d''ananas',4,  280, 420, 560,1120,2240,    60,'4 Ananas'),
  ('989273f7-cfa8-9b12-bdff-5945c2561da8'::uuid,     'Strawberry Jam',    'Confiture de fraise',6, 1580,2370,3160,6320,12640, 500,'4 Fraises'),
  ('516382d9-f441-7309-f33a-dbbee04c040e'::uuid,          'Grape Jam',         'Confiture de raisin',7,  2020,3030,4040,8080,16160, 640,'4 Raisins'),
  ('38f55013-0455-bf57-552e-c7c124d6bc3e'::uuid,    'Chocolate Sauce',   'Pâte à tartiner au chocolat',  12,    1400,2100,2800,5600,11200, 440,'4 Cacao'),
  ('520bdf04-fddf-a565-8821-68fb7ce469be'::uuid,   'Grilled Mushroom',  'Champignons rôtis',1,    180, 270, 360, 720,1440,    0,'4 Tout type de champignons'),
  ('8cb5e951-7463-f733-cf18-c7fcfdd68c0c'::uuid,'Grilled Button Mushroom','Mousserons rôtis',1,180,270,360,720,1440,0,'2 Mousserons'),
  ('cccba190-437d-f44b-73c6-dd6ca6b91e22'::uuid,'Grilled Oyster Mushroom','Pleurotes rôtis',1,180,270,360,720,1440,0,'4 Pleurotes'),
  ('54d7ae5c-1632-aef7-1cad-0cc6204a0d27'::uuid,  'Grilled Penny Bun', 'Cèpes de bordeaux rôtis',      1,    180, 270, 360, 720,1440,    0,'2 Cèpes de bordeaux'),
  ('dcb4fdef-be04-bf27-03e3-8b148c7d5193'::uuid,'Grilled Shiitake Mushroom','Lentins du chêne rôtis',1,180,270,360,720,1440,0,'4 Lentins du chêne'),
  ('0ec52406-b888-3787-1186-cdf641c5435d'::uuid,       'Mushroom Pie',      'Tarte de champignons',1, 500, 750,1000,2000,4000,  195,'2 Champignons, 1 Blé, 1 Oeuf'),
  ('b185c99f-acad-cdb0-4430-06ebd1ee5c40'::uuid,'Button Mushroom Pie','Tarte de mousserons',1,500,750,1000,2000,4000,195,'2 Mousserons, 1 Blé, 1 Oeuf'),
  ('b7709d82-c8cb-d898-76cd-cd29e2e13cc1'::uuid,'Oyster Mushroom Pie','Tarte de pleurotes',1,  500, 750,1000,2000,4000,  195,'2 Pleurotes, 1 Blé, 1 Oeuf'),
  ('745417c9-8896-40e4-9d76-c8507e90a875'::uuid,      'Penny Bun Pie',     'Tarte de cèpes de bordeaux',  1,    500, 750,1000,2000,4000,  195,'2 Cèpes de bordeaux, 1 Blé, 1 Oeuf'),
  ('8da5578e-9c4b-dabf-1ac7-ef542f7b735e'::uuid,       'Shiitake Pie',      'Tarte de lentins du chêne',1,  500, 750,1000,2000,4000,  195,'2 Lentins du chêne, 1 Blé, 1 Oeuf'),
  ('56652c6d-7e01-9e55-dfbd-141ed439d706'::uuid,          'Apple Pie',         'Tarte aux pommes', 5,    730,1095,1460,2920,5840,  345,'1 Pomme, 1 Blé, 1 Oeuf, 1 Beurre'),
  ('432d19c8-43b9-11a8-7ebc-7352a7ecb9e2'::uuid,  'Black Truffle Pie', 'Tarte de truffes noires',1,830,1245,1660,3320,6640,195,'2 Truffes noires, 1 Blé, 1 Oeuf'),
  ('22c35139-8f9e-762b-2cb2-0435d5b913b1'::uuid, 'Original Roll Cake','Rouleau de nuages flottants à la saveur originale',1, 550, 825,1100,2280,4400, 450,'1 Oeuf, 1 Lait, 2 Sucre de n''importe quelle couleur'),
  ('84cb9c2a-f387-a9df-32cd-9e911fb0c65e'::uuid,     'Blue Roll Cake',    'Rouleau jaune de nuages flottants bleu',1,    570, 855,1140,2280,4560,  450,'1 Oeuf, 1 Lait, 2 Sucre bleu'),
  ('ed9f43c8-4894-0f84-3f86-3b08e67d127d'::uuid,   'Indigo Roll Cake',  'Rouleau de nuages flottants cyan',1,  570, 855,1140,2280,4560,  450,'1 Oeuf, 1 Lait, 2 Sucre cyan'),
  ('9f29e7df-96b0-4fec-cee1-954269146e3d'::uuid,   'Violet Roll Cake',  'Rouleau de nuages flottants violet',1,  570, 855,1140,2280,4560,  450,'1 Oeuf, 1 Lait, 2 Sucre violet'),
  ('30cb22e9-63cb-290c-21f5-476c282b8bd5'::uuid,      'Red Roll Cake',     'Rouleau de nuages flottants rouge',1,   670,1005,1340,2680,5360,  450,'1 Oeuf, 1 Lait, 2 Sucre rouge'),
  ('b544bc52-0664-f5d5-b8ab-36fc30f26779'::uuid,   'Yellow Roll Cake',  'Rouleau de nuages flottants jaune',1,   670,1005,1340,2680,5360,  450,'1 Oeuf, 1 Lait, 2 Sucre jaune'),
  ('e65be5eb-d155-54d2-43a8-a5a912766393'::uuid,   'Orange Roll Cake',  'Rouleau de nuages flottants orange',1,  670,1005,1340,2680,5360,  550,'1 Oeuf, 1 Lait, 2 Sucre orange'),
  ('bc72524a-700f-4af9-d035-8f52f94f3809'::uuid,    'Green Roll Cake',   'Rouleau de nuages flottants vert',1,    670,1005,1340,2680,5360,  550,'1 Oeuf, 1 Lait, 2 Sucre vert'),
  ('c33d9e5a-4e7e-1b82-52d6-8aee192001a2'::uuid,             'Coffee',            'Café',             2,    290, 435, 580,1160,2320,  200,'4 Grains de café'),
  ('b3cb1041-c896-5957-b634-47290f85992e'::uuid,       'Coffee Latte',      'Café latte',       2,    300, 450, 600,1200,2400,  200,'2 Grains de café, 2 Lait'),
  ('45d955b7-c83b-4c16-9b07-2bcfc10b2896'::uuid,   'Mellow Black Tea',  'Thé noir doux',   11,    840,1260,1680,3360,6720,  500,'2 Feuilles de thé'),
  ('36737e85-b2c6-a891-7c70-8476f9880a19'::uuid,  'Fragrant Milk Tea', 'Thé au lait parfumé',11, 840,1260,1680,3360,6720,  600,'2 Feuilles de thé, 2 Lait'),
  ('468f492c-31d0-2998-6fe1-bfef144e82fb'::uuid,     'Cocoa Milk Tea',    'Thé au lait au cacao',11,1120,1680,2240,4480,8960, 660,'2 Feuilles de thé, 1 Lait, 1 Cacao'),
  ('b7c9d92b-23b4-8bd9-c454-e087d3430d51'::uuid,'Refreshing Green Tea','Thé vert rafraîchissant',12,500,750,1000,2000,4000,50,'2 Arbres à thé'),
  ('23d15208-f219-2e72-21d3-5ea20b1ea654'::uuid,           'Milk Tea',          'Thé au lait',     12,    500, 750,1000,2000,4000,  150,'2 Arbres à thé, 2 Lait'),
  ('bc7d179b-4d27-6a5c-95fd-3ee27c46c2b3'::uuid,    'Matcha Milk Tea',   'Thé au lait au matcha',12,700,1050,1400,2800,5600, 350,'2 Arbres à thé, 1 Lait, 1 Poudre de matcha'),
  ('589a5f19-efef-88a4-5675-f9f713a1fec6'::uuid,          'Daisy Tea',         'Thé à la pâquerette',12, 600, 900,1200,2400,4800,  110,'2 Arbres à thé, 2 Pâquerettes blanches'),
  ('fd64ba36-78a5-214e-d87f-91690ed51f48'::uuid,           'Rose Tea',          'Thé à la rose',   12,   1930,2895,3860,7720,15440, 650,'2 Arbres à thé, 2 Roses rouges'),
  ('04cabfd5-2dd1-9a77-44ec-3204aecbabbb'::uuid,        'Cheese Cake',       'Gâteau au fromage',       1,    480, 720, 960,1920,3840,  245,'1 Fromage, 1 Lait, 1 Blé'),
  ('e118292f-1207-299f-437c-5f617b805ba5'::uuid,           'Tiramisu',          'Tiramisu',         6,    530, 795,1060,2120,4240,  350,'1 Œuf, 1 Grain de café, 1 Lait, 1 Fromage'),
  ('b378afb8-4dec-0826-4916-ee908fbcd5d3'::uuid, 'Rustic Ratatouille','Ragoût rustique',3,  640, 960,1280,2560,5120, 185,'1 Tomates, 1 Pommes de terre, 1 Laitue'),
  ('00e4c60c-4b11-5550-2544-607d4f7243ef'::uuid,   'Meat Sauce Pasta',  'Spagehetti polonaise',4,670,1005,1340,2680,5360, 405,'1 Viande, 1 Blé, 1 Tomate, 1 Fromage'),
  ('26aa298d-8314-dd54-8d50-1b4ada2166d8'::uuid,        'Carrot Cake',       'Gâteau à la carotte',5,  840,1260,1680,3360,6720,  295,'2 Carottes, 1 Blé, 1 Oeuf'),
  ('5e18ac29-c7e6-ef5b-0a10-e30dc8f3d9a3'::uuid,'Black Truffle Cream Pasta','Pâtes à la crème de truffes noires',3,900,1350,1980,3600,7200,240,'1 Truffes noires, 2 Blé, 1 Lait'),
  ('348c0ce1-1a35-1b8f-30e7-9d05799cb484'::uuid,          'Corn Soup',         'Soupe épaisse au maïs',    5,   1340,2010,2680,5360,10720, 540,'2 Maïs, 1 Blé, 1 Lait'),
  ('fec92f85-68ed-05fa-10db-c543677f09a8'::uuid,        'Meat Burger',       'Burger à la viande fraiche',8,  1350,2025,2700,5400,10800, 480,'1 Blé, 1 Laitue, 1 Viande, 1 Sauce tomate'),
  ('d38d17dc-4b8a-6afe-85a5-9761a80db3a1'::uuid,'Baked Eggplant With Meat','Aubergine gratinée à la bolognaise',9,1230,1845,2460,4920,9840,475,'1 Aubergine, 1 Huile, 1 Viande, 1 Sauce tomate'),
  ('feee62c9-df03-6762-52ed-92acb3895714'::uuid,       'Fish N Chips',      'Poisson et frites',     1,    310, 465, 620,1240,2480,   60,'2 Poissons, 2 Pommes de terre'),
  ('eeaf410f-26c5-4d7a-6de0-3c7d536e970a'::uuid,'Deluxe Seafood Platter','Assortiment de fruits de mer de luxe',6,410,615,820,1640,3280,0,'2 Ecrevisses, 2 Poissons'),
  ('ec05566e-059c-08b4-686b-2c42c7ed4b02'::uuid,    'Seafood Risotto',   'Risotto aux fruits de mer',3,490,735,980,1960,3920,105,'2 Fruits de mer, 1 Blé, 1 Tomate'),
  ('c1f1d79f-1303-3cb0-7f37-3174411a4e15'::uuid,  'Smoked Fish Bagel', 'Bagel au poisson fumé',2, 520, 780,1040,2080,4160, 205,'1 Poissons, 1 Fromage, 1 Légumes, 1 Blé'),
  ('945cb414-be27-0adb-4f04-c6d4cb1c559d'::uuid,      'Seafood Pizza',     'Pizza aux fruits de mer',4,780,1170,1560,3120,6240, 235,'1 Fromage, 1 Sauce tomate, 1 Blé, 1 Poisson'),
  ('77630d35-58e2-5ed5-0573-02409ea52c86'::uuid,  'Steamed King Crab', 'Crabe royale cuit à la vapeur',10,1990,2985,3980,7960,15920,150,'3 Crabe, 1 Beurre'),
  ('664c2435-f16a-e9db-b5ba-dd788bd6bd06'::uuid,'Steamed Golden King Crab','Crabe royale doré cuit à la vapeur',10,2980,4470,5960,11920,23840,150,'3 Crabe royal doré, 1 Beurre'),
  ('c9a0f031-052d-0ff0-7a84-3843a9c50e24'::uuid,'Cheese Shrimp Stuffed Crab','Crabe farci fromage crevette',13,1440,2160,2880,5760,11520,0,'2 Crabes royaux, 2 Crevettes'),
  ('f4f0f325-1b53-7673-725f-b700c30640a4'::uuid, 'Shrimp Avocado Cup','Coupe crevette avocat',13,1560,2340,3120,6240,12480,360,'2 Crevettes, 2 Avocats'),
  ('4e40f26b-fcad-da0b-1a8c-ad648e1763bb'::uuid,      'Afternoon Tea',     'Goûter anglais',7,  710,1065,1420,2840,5680, 350,'1 Tiramisu, 1 fruit'),
  ('02cc1cc8-0643-e111-061e-13083d5dd6ae'::uuid,         'Picnic Set',        'Repas de pique-nique',7, 2260,3390,4520,9040,18080,840,'1 Pizza aux fruits de mer, 1 Tarte aux pommes, 1 Poisson et frites, 1 Café'),
  ('d134a79c-6bab-8243-6178-d1ceed1551db'::uuid, 'Candlelight Dinner','Dîner aux chandelles',9,  1760,2640,3520,7040,14080,680,'1 Salade de campagne, 1 Bagel au poisson fumé, 1 Risotto aux fruits de mer, 1 Tiramisu'),
  ('15047aff-5e74-3f07-8c20-1e4c1c9a2ab8'::uuid,   'Crayfish Sashimi',  'Plateau d''écrevisse',8,   850,1275,1700,3400,6800,145,'3 Ecrevisse, 1 Salade'),
  ('84a2ec81-59d6-255d-fbbb-ce36f71fa379'::uuid,'Blue European Crayfish Sashimi','Plateau d''écrevisse noble bleu',8,1310,1965,2620,5240,10480,145,'3 Ecrevisse noble bleu, 1 Salade'),
  ('61e206e8-749e-ea36-af34-2ccf745ef36b'::uuid,'Exquisite Afternoon Tea','Thé de l''après-midi exquis',12,2970,4455,5940,11880,23760,1490,'2 Cheesecakes, 2 Thés noirs doux'),
  ('cb0e53c5-74cb-4471-2e4c-d8f8444feda4'::uuid,          'Milkshake',         'Milkshake',       11,    400, 600, 800,1600,3200,  100,'2 Fruits, 2 Lait'),
  ('cf7c970f-2bc8-c63f-0fb1-cb693bb42777'::uuid,'Strawberry Milkshake','Milkshake à la fraise',11,1090,1635,2180,4360,8720,350,'2 Fraises, 2 Lait'),
  ('bcd3238b-7471-65f2-66a2-f993cb8f2323'::uuid,'Pineapple Milkshake','Milkshake à l''ananas',11,440,660,880,1760,3520,  130,'2 Ananas, 2 Lait'),
  ('05792e20-bda9-4724-bb85-efaa10220a3f'::uuid, 'Mandarin Milkshake','Milkshake à l''orange',11,450,675,900,1800,3600,100,'2 Oranges, 2 Lait'),
  ('8fd4e061-8ceb-2350-863a-ae159a210be7'::uuid,'Raspberry Milkshake','Milkshake à la framboise',11,440,660,880,1760,3520,100,'2 Framboises, 2 Lait'),
  ('65dfeb94-a60e-c97d-dd60-bf06b1bd24e4'::uuid,'Blueberry Milkshake','Milkshake à la myrtille',11,400,600,800,1600,3200,100,'2 Myrtilles, 2 Lait'),
  ('21ddd72b-1d78-5d67-fe78-97638f23f748'::uuid,    'Apple Milkshake',   'Milkshake à la pomme',11,  450, 675, 900,1800,3600, 100,'2 Pommes, 2 Lait'),
  ('c1c979f1-3063-d8ca-8935-3f3d2bf65a27'::uuid,'Chocolate Milkshake','Milkshake au chocolat',11,1000,1500,2000,4000,8000,320,'2 Cacao, 2 Lait'),
  ('226c4306-00b7-5168-2150-caa9461fa4d5'::uuid,    'Grape Milkshake',   'Milkshake au raisin',11,  1300,1950,2600,5200,10400,420,'2 Raisins, 2 Lait'),
  ('382c0987-f098-3ecf-695a-4a3b7fecb0eb'::uuid,   'Matcha Milkshake',  'Milkshake au matcha',11,   840,1260,1680,3360,6720, 600,'2 Poudre de matcha, 2 Lait'),
  ('271eb8a4-2825-ed29-f8a3-48d89d1ea6e3'::uuid,          'Onsen Egg',         'Œuf thermal',        1,    130, 195, 260, 520,1040,  100,'1 œuf (Utiliser les paniers dans l''eau pour cuir l''œuf)'),
  ('f402ce53-2718-c23b-f3b7-294c35681b3b'::uuid,         'Grass Cake',        'Gâteau à l''herbe',1,    690,1035,1380,2760,5520,  395,'1 Blé, 1 Lait, 1 Poudre de matcha, 1 Mauvaise herbe'),
  ('95123191-7cfb-3227-e9f7-709f4fdf7a6f'::uuid,         'Egg_Easter',        'Œuf de Pâques',    1,    190, 285, 380, 760,1520,  150,'1 Œuf, 1 Lait'),
  ('81fdd26d-8d6a-e719-701c-80efcdbe48a5'::uuid,         'Orange Egg',        'Œuf Orange',       1,    190, 285, 380, 760,1520,  100,'1 Œuf, 1 Pomme'),
  ('82b6c923-f17e-45be-de1d-ad69123412cf'::uuid,          'Green Egg',         'Œuf Vert',         1,    570, 855,1140,2280,4560,  245,'1 Œuf, 1 Laitue'),
  ('2f28a893-5ec8-3d05-c77b-64722eebea98'::uuid,         'Purple Egg',        'Œuf Violet',       1,    620, 930,1240,2480,4960,  260,'1 Œuf, 1 Raisin'),
  ('a3f61950-bee9-733e-d324-63900fb0a53e'::uuid, 'Colorful Egg Feast','Festin d''œufs colorés',1,1650,2475,3300,6600,13200,755,'1 Œuf Pâques, 1 Œuf Violet, 1 Œuf Orange, 1 Œuf Vert')

on conflict (name) do update set
  name_en                 = excluded.name_en,
  passion_level_required  = excluded.passion_level_required,
  sell_price_1_star       = excluded.sell_price_1_star,
  sell_price_2_star       = excluded.sell_price_2_star,
  sell_price_3_star       = excluded.sell_price_3_star,
  sell_price_4_star       = excluded.sell_price_4_star,
  sell_price_5_star       = excluded.sell_price_5_star,
  total_cost              = excluded.total_cost,
  recipe_text             = excluded.recipe_text;

-- ============================================================
-- RECIPE_INGREDIENT
-- Colonnes : food_id, ingredient_id, foraged_id, sub_food_id,
--            quantity, ingredient_label, ingredient_type
-- ============================================================

insert into public.recipe_ingredient
  (food_id, ingredient_id, foraged_id, sub_food_id,
   quantity, ingredient_label, ingredient_type)
values

-- ── House Salad ──────────────────────────────────────────────
  ('42be1f9a-aef1-f678-f561-0b7d97120fcc'::uuid,   null,null,null, 2,'Toute type de légumes','generic'),

-- ── Mixed Jam ────────────────────────────────────────────────
  ('430e9329-d8c3-7a7d-7977-05d595874239'::uuid,     null,null,null, 4,'Toute type de fruits','generic'),

-- ── Blueberry Jam ────────────────────────────────────────────
  ('50ec2c6e-6485-8ce6-8cbb-cd94e60cfdb3'::uuid, null,'bc143107-9629-527f-024e-6289f93df877'::uuid,null, 4,'Myrtilles','foraged'),

-- ── Tomato Sauce ─────────────────────────────────────────────
  ('c50a14b3-ca98-a761-31f4-eaf4a4143b66'::uuid,  '7c9bb91e-1346-6b2c-d603-4e4b03d2b678'::uuid,null,null, 4,'Tomates','ingredient'),

-- ── Raspberry Jam ────────────────────────────────────────────
  ('6917c831-f05c-bd17-b8b2-9f09450e5b72'::uuid, null,'334c3241-e766-9a41-4e0d-fac650361d5f'::uuid,null, 4,'Framboises','foraged'),

-- ── Apple Jam ────────────────────────────────────────────────
  ('9ee3abd4-308a-70fc-d201-dc09d8d75ebd'::uuid,     null,'ef3ccc1b-bba1-660c-d57b-9e65d6f99bb7'::uuid,null, 4,'Pommes','foraged'),

-- ── Mandarin Jam ─────────────────────────────────────────────
  ('2856117d-63a1-dac9-7496-2e28bd1c397c'::uuid,  null,'98fddbd3-42d1-3a3d-295b-71b847546bf0'::uuid,null, 4,'Oranges','foraged'),

-- ── Pineapple Jam ────────────────────────────────────────────
  ('7823f3c9-daa3-ed92-8338-8e3608caa63a'::uuid, '5444aea0-3f60-8f75-43d1-851d7f5d86b6'::uuid,null,null, 4,'Ananas','ingredient'),

-- ── Strawberry Jam ───────────────────────────────────────────
  ('989273f7-cfa8-9b12-bdff-5945c2561da8'::uuid,'0a540b1d-e375-cccb-8bc4-5886f59e25a5'::uuid,null,null, 4,'Fraises','ingredient'),

-- ── Grape Jam ────────────────────────────────────────────────
  ('516382d9-f441-7309-f33a-dbbee04c040e'::uuid,     'af7032bb-ff42-6d90-f36e-c72ad3ccf721'::uuid,null,null, 4,'Raisins','ingredient'),

-- ── Chocolate Sauce ──────────────────────────────────────────
  ('38f55013-0455-bf57-552e-c7c124d6bc3e'::uuid,'1653da8c-992e-e3c1-ed00-5d617ee114cc'::uuid,null,null, 4,'Cacao','ingredient'),

-- ── Grilled Mushroom ─────────────────────────────────────────
  ('520bdf04-fddf-a565-8821-68fb7ce469be'::uuid,null,null,null, 4,'Tout type de champignons','generic'),

-- ── Grilled Button Mushroom ──────────────────────────────────
  ('8cb5e951-7463-f733-cf18-c7fcfdd68c0c'::uuid,null,'22866875-197b-a673-c883-518e9b3505b3'::uuid,null, 2,'Mousserons','foraged'),

-- ── Grilled Oyster Mushroom ──────────────────────────────────
  ('cccba190-437d-f44b-73c6-dd6ca6b91e22'::uuid,null,'fcce5856-372a-1dc9-523b-1982fa89b5d6'::uuid,null, 4,'Pleurotes','foraged'),

-- ── Grilled Penny Bun ────────────────────────────────────────
  ('54d7ae5c-1632-aef7-1cad-0cc6204a0d27'::uuid,null,'4751165d-6c46-547e-40bc-893a44879b75'::uuid,null, 2,'Cèpes de bordeaux','foraged'),

-- ── Grilled Shiitake Mushroom ────────────────────────────────
  ('dcb4fdef-be04-bf27-03e3-8b148c7d5193'::uuid,null,'99426b97-b9a4-1906-49ad-c05bf5ba6666'::uuid,null, 4,'Lentins du chêne','foraged'),

-- ── Mushroom Pie ─────────────────────────────────────────────
  ('0ec52406-b888-3787-1186-cdf641c5435d'::uuid,  null,null,null, 2,'Champignons','generic'),
  ('0ec52406-b888-3787-1186-cdf641c5435d'::uuid,  '7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 1,'Blé','ingredient'),
  ('0ec52406-b888-3787-1186-cdf641c5435d'::uuid,  '689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),

-- ── Button Mushroom Pie ──────────────────────────────────────
  ('b185c99f-acad-cdb0-4430-06ebd1ee5c40'::uuid,null,'22866875-197b-a673-c883-518e9b3505b3'::uuid,null, 2,'Mousserons','foraged'),
  ('b185c99f-acad-cdb0-4430-06ebd1ee5c40'::uuid,'7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 1,'Blé','ingredient'),
  ('b185c99f-acad-cdb0-4430-06ebd1ee5c40'::uuid,'689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),

-- ── Oyster Mushroom Pie ──────────────────────────────────────
  ('b7709d82-c8cb-d898-76cd-cd29e2e13cc1'::uuid,null,'fcce5856-372a-1dc9-523b-1982fa89b5d6'::uuid,null, 2,'Pleurotes','foraged'),
  ('b7709d82-c8cb-d898-76cd-cd29e2e13cc1'::uuid,'7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 1,'Blé','ingredient'),
  ('b7709d82-c8cb-d898-76cd-cd29e2e13cc1'::uuid,'689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),

-- ── Penny Bun Pie ────────────────────────────────────────────
  ('745417c9-8896-40e4-9d76-c8507e90a875'::uuid, null,'4751165d-6c46-547e-40bc-893a44879b75'::uuid,null, 2,'Cèpes de bordeaux','foraged'),
  ('745417c9-8896-40e4-9d76-c8507e90a875'::uuid, '7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 1,'Blé','ingredient'),
  ('745417c9-8896-40e4-9d76-c8507e90a875'::uuid, '689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),

-- ── Shiitake Pie ─────────────────────────────────────────────
  ('8da5578e-9c4b-dabf-1ac7-ef542f7b735e'::uuid,  null,'99426b97-b9a4-1906-49ad-c05bf5ba6666'::uuid,null, 2,'Lentins du chêne','foraged'),
  ('8da5578e-9c4b-dabf-1ac7-ef542f7b735e'::uuid,  '7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 1,'Blé','ingredient'),
  ('8da5578e-9c4b-dabf-1ac7-ef542f7b735e'::uuid,  '689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),

-- ── Apple Pie ────────────────────────────────────────────────
  ('56652c6d-7e01-9e55-dfbd-141ed439d706'::uuid,     null,'ef3ccc1b-bba1-660c-d57b-9e65d6f99bb7'::uuid,null, 1,'Pomme','foraged'),
  ('56652c6d-7e01-9e55-dfbd-141ed439d706'::uuid,     '7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 1,'Blé','ingredient'),
  ('56652c6d-7e01-9e55-dfbd-141ed439d706'::uuid,     '689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),
  ('56652c6d-7e01-9e55-dfbd-141ed439d706'::uuid,     'c75408b4-c8a1-edc1-0f37-0c592ee78206'::uuid,null,null, 1,'Beurre','ingredient'),

-- ── Black Truffle Pie ────────────────────────────────────────
  ('432d19c8-43b9-11a8-7ebc-7352a7ecb9e2'::uuid,null,'3ec27fdb-01ce-114c-d79d-30fc14b35299'::uuid,null, 2,'Truffes noires','foraged'),
  ('432d19c8-43b9-11a8-7ebc-7352a7ecb9e2'::uuid,'7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 1,'Blé','ingredient'),
  ('432d19c8-43b9-11a8-7ebc-7352a7ecb9e2'::uuid,'689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),

-- ── Original Roll Cake ───────────────────────────────────────
  ('22c35139-8f9e-762b-2cb2-0435d5b913b1'::uuid,'689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),
  ('22c35139-8f9e-762b-2cb2-0435d5b913b1'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),
  ('22c35139-8f9e-762b-2cb2-0435d5b913b1'::uuid,null,null,null, 2,'Sucre de n''importe quelle couleur','generic'),

-- ── Blue Roll Cake ───────────────────────────────────────────
  ('84cb9c2a-f387-a9df-32cd-9e911fb0c65e'::uuid,'689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),
  ('84cb9c2a-f387-a9df-32cd-9e911fb0c65e'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),
  ('84cb9c2a-f387-a9df-32cd-9e911fb0c65e'::uuid,'37a2fae1-ff08-c2ed-df8b-625d983b14eb'::uuid,null,null, 2,'Sucre bleu','ingredient'),

-- ── Indigo Roll Cake ─────────────────────────────────────────
  ('ed9f43c8-4894-0f84-3f86-3b08e67d127d'::uuid,'689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),
  ('ed9f43c8-4894-0f84-3f86-3b08e67d127d'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),
  ('ed9f43c8-4894-0f84-3f86-3b08e67d127d'::uuid,'a9fef895-3fd4-c51d-32cb-f3a3e26eb179'::uuid,null,null, 2,'Sucre cyan','ingredient'),

-- ── Violet Roll Cake ─────────────────────────────────────────
  ('9f29e7df-96b0-4fec-cee1-954269146e3d'::uuid,'689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),
  ('9f29e7df-96b0-4fec-cee1-954269146e3d'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),
  ('9f29e7df-96b0-4fec-cee1-954269146e3d'::uuid,'9052f3b6-1f16-ec11-c896-93de32927ceb'::uuid,null,null, 2,'Sucre violet','ingredient'),

-- ── Red Roll Cake ────────────────────────────────────────────
  ('30cb22e9-63cb-290c-21f5-476c282b8bd5'::uuid, '689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),
  ('30cb22e9-63cb-290c-21f5-476c282b8bd5'::uuid, 'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),
  ('30cb22e9-63cb-290c-21f5-476c282b8bd5'::uuid, '07250ad8-8705-1a84-696f-af3d9617d3cb'::uuid,null,null, 2,'Sucre rouge','ingredient'),

-- ── Yellow Roll Cake ─────────────────────────────────────────
  ('b544bc52-0664-f5d5-b8ab-36fc30f26779'::uuid,'689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),
  ('b544bc52-0664-f5d5-b8ab-36fc30f26779'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),
  ('b544bc52-0664-f5d5-b8ab-36fc30f26779'::uuid,'84b704d8-d8d8-0140-ca6f-cda841752474'::uuid,null,null, 2,'Sucre jaune','ingredient'),

-- ── Orange Roll Cake ─────────────────────────────────────────
  ('e65be5eb-d155-54d2-43a8-a5a912766393'::uuid,'689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),
  ('e65be5eb-d155-54d2-43a8-a5a912766393'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),
  ('e65be5eb-d155-54d2-43a8-a5a912766393'::uuid,'51c7c10b-f763-a181-63a9-aa9a86f2183e'::uuid,null,null, 2,'Sucre orange','ingredient'),

-- ── Green Roll Cake ──────────────────────────────────────────
  ('bc72524a-700f-4af9-d035-8f52f94f3809'::uuid,'689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),
  ('bc72524a-700f-4af9-d035-8f52f94f3809'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),
  ('bc72524a-700f-4af9-d035-8f52f94f3809'::uuid,'71c72198-2e71-d530-d3ed-28043c1858e0'::uuid,null,null, 2,'Sucre vert','ingredient'),

-- ── Coffee ───────────────────────────────────────────────────
  ('c33d9e5a-4e7e-1b82-52d6-8aee192001a2'::uuid,        '9d7f780b-ad0e-53c5-c0be-005ae8d4bebb'::uuid,null,null, 4,'Grains de café','ingredient'),

-- ── Coffee Latte ─────────────────────────────────────────────
  ('b3cb1041-c896-5957-b634-47290f85992e'::uuid,  '9d7f780b-ad0e-53c5-c0be-005ae8d4bebb'::uuid,null,null, 2,'Grains de café','ingredient'),
  ('b3cb1041-c896-5957-b634-47290f85992e'::uuid,  'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 2,'Lait','ingredient'),

-- ── Mellow Black Tea ─────────────────────────────────────────
  ('45d955b7-c83b-4c16-9b07-2bcfc10b2896'::uuid,'b43f91a0-779d-eed1-d6e9-d905b9565cc5'::uuid,null,null, 2,'Feuilles de thé','ingredient'),

-- ── Fragrant Milk Tea ────────────────────────────────────────
  ('36737e85-b2c6-a891-7c70-8476f9880a19'::uuid,'b43f91a0-779d-eed1-d6e9-d905b9565cc5'::uuid,null,null, 2,'Feuilles de thé','ingredient'),
  ('36737e85-b2c6-a891-7c70-8476f9880a19'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 2,'Lait','ingredient'),

-- ── Cocoa Milk Tea ───────────────────────────────────────────
  ('468f492c-31d0-2998-6fe1-bfef144e82fb'::uuid,'b43f91a0-779d-eed1-d6e9-d905b9565cc5'::uuid,null,null, 2,'Feuilles de thé','ingredient'),
  ('468f492c-31d0-2998-6fe1-bfef144e82fb'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),
  ('468f492c-31d0-2998-6fe1-bfef144e82fb'::uuid,'1653da8c-992e-e3c1-ed00-5d617ee114cc'::uuid,null,null, 1,'Cacao','ingredient'),

-- ── Refreshing Green Tea ─────────────────────────────────────
  ('b7c9d92b-23b4-8bd9-c454-e087d3430d51'::uuid,'2862808b-dfab-0cbe-c242-a4e1f14cac41'::uuid,null,null, 2,'Arbres à thé','ingredient'),

-- ── Milk Tea ─────────────────────────────────────────────────
  ('23d15208-f219-2e72-21d3-5ea20b1ea654'::uuid,      '2862808b-dfab-0cbe-c242-a4e1f14cac41'::uuid,null,null, 2,'Arbres à thé','ingredient'),
  ('23d15208-f219-2e72-21d3-5ea20b1ea654'::uuid,      'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 2,'Lait','ingredient'),

-- ── Matcha Milk Tea ──────────────────────────────────────────
  ('bc7d179b-4d27-6a5c-95fd-3ee27c46c2b3'::uuid,'2862808b-dfab-0cbe-c242-a4e1f14cac41'::uuid,null,null, 2,'Arbres à thé','ingredient'),
  ('bc7d179b-4d27-6a5c-95fd-3ee27c46c2b3'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),
  ('bc7d179b-4d27-6a5c-95fd-3ee27c46c2b3'::uuid,'51dddf86-df2c-50e5-c6de-81fb8b0c323f'::uuid,null,null, 1,'Poudre de matcha','ingredient'),

-- ── Daisy Tea ────────────────────────────────────────────────
  ('589a5f19-efef-88a4-5675-f9f713a1fec6'::uuid,     '2862808b-dfab-0cbe-c242-a4e1f14cac41'::uuid,null,null, 2,'Arbres à thé','ingredient'),
  ('589a5f19-efef-88a4-5675-f9f713a1fec6'::uuid,     null,'7632925c-c35b-415a-19ad-9ae0ffc9266b'::uuid,null, 2,'Pâquerettes blanches','foraged'),

-- ── Rose Tea ─────────────────────────────────────────────────
  ('fd64ba36-78a5-214e-d87f-91690ed51f48'::uuid,      '2862808b-dfab-0cbe-c242-a4e1f14cac41'::uuid,null,null, 2,'Arbres à thé','ingredient'),
  ('fd64ba36-78a5-214e-d87f-91690ed51f48'::uuid,      null,'2115501d-cf57-eabb-c617-96b82467b689'::uuid,null, 2,'Roses rouges','foraged'),

-- ── Cheese Cake ──────────────────────────────────────────────
  ('04cabfd5-2dd1-9a77-44ec-3204aecbabbb'::uuid,   'df481a54-44e6-1c26-dc86-708722a0484a'::uuid,null,null, 1,'Fromage','ingredient'),
  ('04cabfd5-2dd1-9a77-44ec-3204aecbabbb'::uuid,   'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),
  ('04cabfd5-2dd1-9a77-44ec-3204aecbabbb'::uuid,   '7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 1,'Blé','ingredient'),

-- ── Tiramisu ─────────────────────────────────────────────────
  ('e118292f-1207-299f-437c-5f617b805ba5'::uuid,      '9d7f780b-ad0e-53c5-c0be-005ae8d4bebb'::uuid,null,null, 1,'Grain de café','ingredient'),
  ('e118292f-1207-299f-437c-5f617b805ba5'::uuid,      '689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Œuf','ingredient'),
  ('e118292f-1207-299f-437c-5f617b805ba5'::uuid,      'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),
  ('e118292f-1207-299f-437c-5f617b805ba5'::uuid,      'c75408b4-c8a1-edc1-0f37-0c592ee78206'::uuid,null,null, 1,'Fromage','ingredient'),

-- ── Rustic Ratatouille ───────────────────────────────────────
  ('b378afb8-4dec-0826-4916-ee908fbcd5d3'::uuid,'7c9bb91e-1346-6b2c-d603-4e4b03d2b678'::uuid,null,null, 1,'Tomates','ingredient'),
  ('b378afb8-4dec-0826-4916-ee908fbcd5d3'::uuid,'b7495864-41bd-56bf-e21d-26ce9b72cdf6'::uuid,null,null, 1,'Pommes de terre','ingredient'),
  ('b378afb8-4dec-0826-4916-ee908fbcd5d3'::uuid,'7d40466d-5da2-7f16-3b9a-b0868830e823'::uuid,null,null, 1,'Laitue','ingredient'),

-- ── Meat Sauce Pasta ─────────────────────────────────────────
  ('00e4c60c-4b11-5550-2544-607d4f7243ef'::uuid,'35b3a4a7-8387-fd94-e1df-adc4c485c79b'::uuid,null,null, 1,'Viande','ingredient'),
  ('00e4c60c-4b11-5550-2544-607d4f7243ef'::uuid,'7c9bb91e-1346-6b2c-d603-4e4b03d2b678'::uuid,null,null, 1,'Tomate','ingredient'),
  ('00e4c60c-4b11-5550-2544-607d4f7243ef'::uuid,'7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 1,'Blé','ingredient'),
  ('00e4c60c-4b11-5550-2544-607d4f7243ef'::uuid,'df481a54-44e6-1c26-dc86-708722a0484a'::uuid,null,null, 1,'Fromage','ingredient'),

-- ── Carrot Cake ──────────────────────────────────────────────
  ('26aa298d-8314-dd54-8d50-1b4ada2166d8'::uuid,   '689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Oeuf','ingredient'),
  ('26aa298d-8314-dd54-8d50-1b4ada2166d8'::uuid,   '7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 1,'Blé','ingredient'),
  ('26aa298d-8314-dd54-8d50-1b4ada2166d8'::uuid,   'cd5317e5-9b0d-5f55-fd11-fdc7bf0a8d94'::uuid,null,null, 2,'Carottes','ingredient'),

-- ── Black Truffle Cream Pasta ────────────────────────────────
  ('5e18ac29-c7e6-ef5b-0a10-e30dc8f3d9a3'::uuid,null,'3ec27fdb-01ce-114c-d79d-30fc14b35299'::uuid,null, 1,'Truffes noires','foraged'),
  ('5e18ac29-c7e6-ef5b-0a10-e30dc8f3d9a3'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),
  ('5e18ac29-c7e6-ef5b-0a10-e30dc8f3d9a3'::uuid,'7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 2,'Blé','ingredient'),

-- ── Corn Soup ────────────────────────────────────────────────
  ('348c0ce1-1a35-1b8f-30e7-9d05799cb484'::uuid,     'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),
  ('348c0ce1-1a35-1b8f-30e7-9d05799cb484'::uuid,     'c75408b4-c8a1-edc1-0f37-0c592ee78206'::uuid,null,null, 1,'Blé','ingredient'),
  ('348c0ce1-1a35-1b8f-30e7-9d05799cb484'::uuid,     '2f2ecdda-27a6-09c5-1314-1ad1c85454ca'::uuid,null,null, 2,'Maïs','ingredient'),

-- ── Meat Burger ──────────────────────────────────────────────
  ('fec92f85-68ed-05fa-10db-c543677f09a8'::uuid,   '7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 1,'Blé','ingredient'),
  ('fec92f85-68ed-05fa-10db-c543677f09a8'::uuid,   '7d40466d-5da2-7f16-3b9a-b0868830e823'::uuid,null,null, 1,'Laitue','ingredient'),
  ('fec92f85-68ed-05fa-10db-c543677f09a8'::uuid,   '35b3a4a7-8387-fd94-e1df-adc4c485c79b'::uuid,null,null, 1,'Viande','ingredient'),
  ('fec92f85-68ed-05fa-10db-c543677f09a8'::uuid,   null,null,'c50a14b3-ca98-a761-31f4-eaf4a4143b66'::uuid, 1,'Sauce tomate','food'),

-- ── Baked Eggplant With Meat ─────────────────────────────────
  ('d38d17dc-4b8a-6afe-85a5-9761a80db3a1'::uuid,'53fb4855-be19-83c4-1d7c-10d9a144481a'::uuid,null,null, 1,'Aubergine','ingredient'),
  ('d38d17dc-4b8a-6afe-85a5-9761a80db3a1'::uuid,'35b3a4a7-8387-fd94-e1df-adc4c485c79b'::uuid,null,null, 1,'Viande','ingredient'),
  ('d38d17dc-4b8a-6afe-85a5-9761a80db3a1'::uuid,'30277655-f605-7f55-d387-f8fe67718fa3'::uuid,null,null, 1,'Huile','ingredient'),
  ('d38d17dc-4b8a-6afe-85a5-9761a80db3a1'::uuid,null,null,'c50a14b3-ca98-a761-31f4-eaf4a4143b66'::uuid, 1,'Sauce tomate','food'),

-- ── Fish N Chips ─────────────────────────────────────────────
  ('feee62c9-df03-6762-52ed-92acb3895714'::uuid,  null,'82ded839-5412-5bbc-bac1-2e35c9cb967d'::uuid,null, 2,'Poissons','foraged'),
  ('feee62c9-df03-6762-52ed-92acb3895714'::uuid,  'b7495864-41bd-56bf-e21d-26ce9b72cdf6'::uuid,null,null, 2,'Pommes de terre','ingredient'),

-- ── Deluxe Seafood Platter ───────────────────────────────────
  ('eeaf410f-26c5-4d7a-6de0-3c7d536e970a'::uuid,null,'37aa27f9-aab1-aeae-76b7-6cae02808edf'::uuid,null, 2,'Ecrevisses','foraged'),
  ('eeaf410f-26c5-4d7a-6de0-3c7d536e970a'::uuid,null,'82ded839-5412-5bbc-bac1-2e35c9cb967d'::uuid,null, 2,'Poissons','foraged'),

-- ── Seafood Risotto ──────────────────────────────────────────
  ('ec05566e-059c-08b4-686b-2c42c7ed4b02'::uuid,null,'54fb981e-b374-a296-5d08-966b66adfed1'::uuid,null, 2,'Fruits de mer','foraged'),
  ('ec05566e-059c-08b4-686b-2c42c7ed4b02'::uuid,'7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 1,'Blé','ingredient'),
  ('ec05566e-059c-08b4-686b-2c42c7ed4b02'::uuid,'7c9bb91e-1346-6b2c-d603-4e4b03d2b678'::uuid,null,null, 1,'Tomate','ingredient'),

-- ── Smoked Fish Bagel ────────────────────────────────────────
  ('c1f1d79f-1303-3cb0-7f37-3174411a4e15'::uuid,null,'82ded839-5412-5bbc-bac1-2e35c9cb967d'::uuid,null, 1,'Poissons','foraged'),
  ('c1f1d79f-1303-3cb0-7f37-3174411a4e15'::uuid,'df481a54-44e6-1c26-dc86-708722a0484a'::uuid,null,null, 1,'Fromage','ingredient'),
  ('c1f1d79f-1303-3cb0-7f37-3174411a4e15'::uuid,'7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 1,'Blé','ingredient'),
  ('c1f1d79f-1303-3cb0-7f37-3174411a4e15'::uuid,null,null,null, 1,'Légumes','generic'),

-- ── Seafood Pizza ────────────────────────────────────────────
  ('945cb414-be27-0adb-4f04-c6d4cb1c559d'::uuid, 'df481a54-44e6-1c26-dc86-708722a0484a'::uuid,null,null, 1,'Fromage','ingredient'),
  ('945cb414-be27-0adb-4f04-c6d4cb1c559d'::uuid, null,null,'c50a14b3-ca98-a761-31f4-eaf4a4143b66'::uuid, 1,'Sauce tomate','food'),
  ('945cb414-be27-0adb-4f04-c6d4cb1c559d'::uuid, '7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 1,'Blé','ingredient'),
  ('945cb414-be27-0adb-4f04-c6d4cb1c559d'::uuid, null,'82ded839-5412-5bbc-bac1-2e35c9cb967d'::uuid,null, 1,'Poisson','foraged'),

-- ── Steamed King Crab ────────────────────────────────────────
  ('77630d35-58e2-5ed5-0573-02409ea52c86'::uuid,null,'0e76afbc-07be-ee27-15b0-f7a2bed356f0'::uuid,null, 3,'Crabe','foraged'),
  ('77630d35-58e2-5ed5-0573-02409ea52c86'::uuid,'c75408b4-c8a1-edc1-0f37-0c592ee78206'::uuid,null,null, 1,'Beurre','ingredient'),

-- ── Steamed Golden King Crab ─────────────────────────────────
  ('664c2435-f16a-e9db-b5ba-dd788bd6bd06'::uuid,null,'475f3485-bd9d-7378-9438-01bfc65f5a32'::uuid,null, 3,'Crabe royal doré','foraged'),
  ('664c2435-f16a-e9db-b5ba-dd788bd6bd06'::uuid,'c75408b4-c8a1-edc1-0f37-0c592ee78206'::uuid,null,null, 1,'Beurre','ingredient'),

-- ── Cheese Shrimp Stuffed Crab ───────────────────────────────
  ('c9a0f031-052d-0ff0-7a84-3843a9c50e24'::uuid,null,'0e76afbc-07be-ee27-15b0-f7a2bed356f0'::uuid,null, 2,'Crabes royaux','foraged'),
  ('c9a0f031-052d-0ff0-7a84-3843a9c50e24'::uuid,null,'cb6a3735-49dc-b263-fa82-52b7ec3089e2'::uuid,null, 2,'Crevettes','foraged'),

-- ── Shrimp Avocado Cup ───────────────────────────────────────
  ('f4f0f325-1b53-7673-725f-b700c30640a4'::uuid,null,'cb6a3735-49dc-b263-fa82-52b7ec3089e2'::uuid,null, 2,'Crevettes','foraged'),
  ('f4f0f325-1b53-7673-725f-b700c30640a4'::uuid,'db3a78b6-b77c-0dee-618e-bdceaf049881'::uuid,null,null, 2,'Avocats','ingredient'),

-- ── Afternoon Tea ────────────────────────────────────────────
  ('4e40f26b-fcad-da0b-1a8c-ad648e1763bb'::uuid, null,null,'e118292f-1207-299f-437c-5f617b805ba5'::uuid, 1,'Tiramisu','food'),
  ('4e40f26b-fcad-da0b-1a8c-ad648e1763bb'::uuid, null,null,null, 1,'fruit','generic'),

-- ── Picnic Set ───────────────────────────────────────────────
  ('02cc1cc8-0643-e111-061e-13083d5dd6ae'::uuid,    null,null,'945cb414-be27-0adb-4f04-c6d4cb1c559d'::uuid, 1,'Pizza aux fruits de mer','food'),
  ('02cc1cc8-0643-e111-061e-13083d5dd6ae'::uuid,    null,null,'56652c6d-7e01-9e55-dfbd-141ed439d706'::uuid, 1,'Tarte aux pommes','food'),
  ('02cc1cc8-0643-e111-061e-13083d5dd6ae'::uuid,    null,null,'feee62c9-df03-6762-52ed-92acb3895714'::uuid, 1,'Poisson et frites','food'),
  ('02cc1cc8-0643-e111-061e-13083d5dd6ae'::uuid,    null,null,null, 1,'Café','generic'),

-- ── Candlelight Dinner ───────────────────────────────────────
  ('d134a79c-6bab-8243-6178-d1ceed1551db'::uuid,null,null,'42be1f9a-aef1-f678-f561-0b7d97120fcc'::uuid, 1,'Salade de campagne','food'),
  ('d134a79c-6bab-8243-6178-d1ceed1551db'::uuid,null,null,'c1f1d79f-1303-3cb0-7f37-3174411a4e15'::uuid, 1,'Bagel au poisson fumé','food'),
  ('d134a79c-6bab-8243-6178-d1ceed1551db'::uuid,null,null,'ec05566e-059c-08b4-686b-2c42c7ed4b02'::uuid, 1,'Risotto aux fruits de mer','food'),
  ('d134a79c-6bab-8243-6178-d1ceed1551db'::uuid,null,null,'e118292f-1207-299f-437c-5f617b805ba5'::uuid, 1,'Tiramisu','food'),

-- ── Crayfish Sashimi ─────────────────────────────────────────
  ('15047aff-5e74-3f07-8c20-1e4c1c9a2ab8'::uuid,null,'37aa27f9-aab1-aeae-76b7-6cae02808edf'::uuid,null, 3,'Ecrevisse','foraged'),
  ('15047aff-5e74-3f07-8c20-1e4c1c9a2ab8'::uuid,'7d40466d-5da2-7f16-3b9a-b0868830e823'::uuid,null,null, 1,'Salade','ingredient'),

-- ── Blue European Crayfish Sashimi ───────────────────────────
  ('84a2ec81-59d6-255d-fbbb-ce36f71fa379'::uuid,null,'d7fe53d7-b467-1a2e-e211-9339830d7794'::uuid,null, 3,'Ecrevisse noble bleu','foraged'),
  ('84a2ec81-59d6-255d-fbbb-ce36f71fa379'::uuid,'7d40466d-5da2-7f16-3b9a-b0868830e823'::uuid,null,null, 1,'Salade','ingredient'),

-- ── Exquisite Afternoon Tea ──────────────────────────────────
  ('61e206e8-749e-ea36-af34-2ccf745ef36b'::uuid,null,null,'04cabfd5-2dd1-9a77-44ec-3204aecbabbb'::uuid, 2,'Cheesecakes','food'),
  ('61e206e8-749e-ea36-af34-2ccf745ef36b'::uuid,null,null,'45d955b7-c83b-4c16-9b07-2bcfc10b2896'::uuid, 2,'Thés noirs doux','food'),

-- ── Milkshake ────────────────────────────────────────────────
  ('cb0e53c5-74cb-4471-2e4c-d8f8444feda4'::uuid,     null,null,null, 2,'Fruits','generic'),
  ('cb0e53c5-74cb-4471-2e4c-d8f8444feda4'::uuid,     'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 2,'Lait','ingredient'),

-- ── Strawberry Milkshake ─────────────────────────────────────
  ('cf7c970f-2bc8-c63f-0fb1-cb693bb42777'::uuid,'0a540b1d-e375-cccb-8bc4-5886f59e25a5'::uuid,null,null, 2,'Fraises','ingredient'),
  ('cf7c970f-2bc8-c63f-0fb1-cb693bb42777'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 2,'Lait','ingredient'),

-- ── Pineapple Milkshake ──────────────────────────────────────
  ('bcd3238b-7471-65f2-66a2-f993cb8f2323'::uuid,'5444aea0-3f60-8f75-43d1-851d7f5d86b6'::uuid,null,null, 2,'Ananas','ingredient'),
  ('bcd3238b-7471-65f2-66a2-f993cb8f2323'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 2,'Lait','ingredient'),

-- ── Mandarin Milkshake ───────────────────────────────────────
  ('05792e20-bda9-4724-bb85-efaa10220a3f'::uuid,null,'98fddbd3-42d1-3a3d-295b-71b847546bf0'::uuid,null, 2,'Oranges','foraged'),
  ('05792e20-bda9-4724-bb85-efaa10220a3f'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 2,'Lait','ingredient'),

-- ── Raspberry Milkshake ──────────────────────────────────────
  ('8fd4e061-8ceb-2350-863a-ae159a210be7'::uuid,null,'334c3241-e766-9a41-4e0d-fac650361d5f'::uuid,null, 2,'Framboises','foraged'),
  ('8fd4e061-8ceb-2350-863a-ae159a210be7'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 2,'Lait','ingredient'),

-- ── Blueberry Milkshake ──────────────────────────────────────
  ('65dfeb94-a60e-c97d-dd60-bf06b1bd24e4'::uuid,null,'bc143107-9629-527f-024e-6289f93df877'::uuid,null, 2,'Myrtilles','foraged'),
  ('65dfeb94-a60e-c97d-dd60-bf06b1bd24e4'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 2,'Lait','ingredient'),

-- ── Apple Milkshake ──────────────────────────────────────────
  ('21ddd72b-1d78-5d67-fe78-97638f23f748'::uuid,null,'ef3ccc1b-bba1-660c-d57b-9e65d6f99bb7'::uuid,null, 2,'Pommes','foraged'),
  ('21ddd72b-1d78-5d67-fe78-97638f23f748'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 2,'Lait','ingredient'),

-- ── Chocolate Milkshake ──────────────────────────────────────
  ('c1c979f1-3063-d8ca-8935-3f3d2bf65a27'::uuid,'1653da8c-992e-e3c1-ed00-5d617ee114cc'::uuid,null,null, 2,'Cacao','ingredient'),
  ('c1c979f1-3063-d8ca-8935-3f3d2bf65a27'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 2,'Lait','ingredient'),

-- ── Grape Milkshake ──────────────────────────────────────────
  ('226c4306-00b7-5168-2150-caa9461fa4d5'::uuid,'af7032bb-ff42-6d90-f36e-c72ad3ccf721'::uuid,null,null, 2,'Raisins','ingredient'),
  ('226c4306-00b7-5168-2150-caa9461fa4d5'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 2,'Lait','ingredient'),

-- ── Matcha Milkshake ─────────────────────────────────────────
  ('382c0987-f098-3ecf-695a-4a3b7fecb0eb'::uuid,'51dddf86-df2c-50e5-c6de-81fb8b0c323f'::uuid,null,null, 2,'Poudre de matcha','ingredient'),
  ('382c0987-f098-3ecf-695a-4a3b7fecb0eb'::uuid,'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 2,'Lait','ingredient'),

-- ── Onsen Egg ────────────────────────────────────────────────
  ('271eb8a4-2825-ed29-f8a3-48d89d1ea6e3'::uuid,     '925fd249-ab3a-6bcd-9e54-8758888f26d3'::uuid,null,null, 1,'œuf (Utiliser les paniers dans l''eau pour cuir l''œuf)','ingredient'),

-- ── Grass Cake ───────────────────────────────────────────────
  ('f402ce53-2718-c23b-f3b7-294c35681b3b'::uuid,    '7ef5c096-eadc-2574-75d7-2289b6607a73'::uuid,null,null, 1,'Blé','ingredient'),
  ('f402ce53-2718-c23b-f3b7-294c35681b3b'::uuid,    'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),
  ('f402ce53-2718-c23b-f3b7-294c35681b3b'::uuid,    '51dddf86-df2c-50e5-c6de-81fb8b0c323f'::uuid,null,null, 1,'Poudre de matcha','ingredient'),
  ('f402ce53-2718-c23b-f3b7-294c35681b3b'::uuid,    null,'e9ed6248-34e4-6f4b-6742-1fd00d11c55f'::uuid,null, 1,'Mauvaise herbe','foraged'),

-- ── Egg de Pâques ────────────────────────────────────────────
  ('95123191-7cfb-3227-e9f7-709f4fdf7a6f'::uuid,    '689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Œuf','ingredient'),
  ('95123191-7cfb-3227-e9f7-709f4fdf7a6f'::uuid,    'c85bbf73-76ec-395b-b0b1-d2fc1fdbd512'::uuid,null,null, 1,'Lait','ingredient'),

-- ── Orange Egg ───────────────────────────────────────────────
  ('81fdd26d-8d6a-e719-701c-80efcdbe48a5'::uuid,    '689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Œuf','ingredient'),
  ('81fdd26d-8d6a-e719-701c-80efcdbe48a5'::uuid,    null,'ef3ccc1b-bba1-660c-d57b-9e65d6f99bb7'::uuid,null, 1,'Pomme','foraged'),

-- ── Green Egg ────────────────────────────────────────────────
  ('82b6c923-f17e-45be-de1d-ad69123412cf'::uuid,     '689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Œuf','ingredient'),
  ('82b6c923-f17e-45be-de1d-ad69123412cf'::uuid,     '7d40466d-5da2-7f16-3b9a-b0868830e823'::uuid,null,null, 1,'Laitue','ingredient'),

-- ── Purple Egg ───────────────────────────────────────────────
  ('2f28a893-5ec8-3d05-c77b-64722eebea98'::uuid,    '689f845e-4e4f-8131-3e59-9ab74904e505'::uuid,null,null, 1,'Œuf','ingredient'),
  ('2f28a893-5ec8-3d05-c77b-64722eebea98'::uuid,    'af7032bb-ff42-6d90-f36e-c72ad3ccf721'::uuid,null,null, 1,'Raisin','ingredient'),

-- ── Colorful Egg Feast ───────────────────────────────────────
  ('a3f61950-bee9-733e-d324-63900fb0a53e'::uuid,null,null,'95123191-7cfb-3227-e9f7-709f4fdf7a6f'::uuid, 1,'Œuf Pâques','food'),
  ('a3f61950-bee9-733e-d324-63900fb0a53e'::uuid,null,null,'2f28a893-5ec8-3d05-c77b-64722eebea98'::uuid, 1,'Œuf Violet','food'),
  ('a3f61950-bee9-733e-d324-63900fb0a53e'::uuid,null,null,'81fdd26d-8d6a-e719-701c-80efcdbe48a5'::uuid, 1,'Œuf Orange','food'),
  ('a3f61950-bee9-733e-d324-63900fb0a53e'::uuid,null,null,'82b6c923-f17e-45be-de1d-ad69123412cf'::uuid, 1,'Œuf Vert','food')

on conflict do nothing;


-- ============================================================
-- FIN DU SEED
-- ============================================================

