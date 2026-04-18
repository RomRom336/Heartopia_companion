-- ============================================================
-- Heartopia Companion — Seed complet (données réelles du jeu)
-- UUIDs stables : md5('<prefix>_' || name_en)::uuid
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
  (md5('foraged_Button')::uuid,        'Button',             'Champignon de Paris', 'Champignon', 16),
  (md5('foraged_Oyster')::uuid,        'Oyster',             'Pleurote',            'Champignon', 16),
  (md5('foraged_Shiitake')::uuid,      'Shiitake',           'Shiitake',            'Champignon', 16),
  (md5('foraged_PennyBun')::uuid,      'PennyBun',           'Cèpe',                'Champignon', 16),
  (md5('foraged_BlackTruffle')::uuid,  'BlackTruffle',       'Truffe noire',        'Champignon', 99),
  (md5('foraged_Matsutake')::uuid,     'Matsutake',          'Matsutake',           'Champignon',  0),
  -- Fruits sauvages
  (md5('foraged_Blueberry')::uuid,     'Blueberry',          'Myrtille',            'Fruit',      16),
  (md5('foraged_Raspberry')::uuid,     'Raspberry',          'Framboise',           'Fruit',      26),
  (md5('foraged_Mandarin')::uuid,      'Mandarin',           'Mandarine',           'Fruit',      28),
  (md5('foraged_Apple')::uuid,         'Apple',              'Pomme',               'Fruit',      28),
  -- Bois
  (md5('foraged_Bamboo')::uuid,        'Bamboo',             'Bambou',              'Bois',        7),
  (md5('foraged_Branch')::uuid,        'Branch',             'Branche',             'Bois',        5),
  (md5('foraged_Timber')::uuid,        'Timber',             'Bois',                'Bois',        6),
  (md5('foraged_QualityTimber')::uuid, 'Quality Timber',     'Bois de qualité',     'Bois',       12),
  (md5('foraged_RareTimber')::uuid,    'Rare Timber',        'Bois rare',           'Bois',       50),
  (md5('foraged_RoamingOak')::uuid,    'Roaming Oak Timber', 'Chêne errant',        'Bois',      150),
  -- Minéraux
  (md5('foraged_Stone')::uuid,         'Stone',              'Pierre',              'Minéral',     8),
  (md5('foraged_Ore')::uuid,           'Ore',                'Minerai',             'Minéral',    14),
  (md5('foraged_Fluorite')::uuid,      'Flawless Fluorite',  'Fluorite pure',       'Minéral',   150),
  (md5('foraged_Starfall')::uuid,      'Starfall Shard',     'Éclat d''étoile',     'Minéral',   150),
  -- Divers
  (md5('foraged_Popper')::uuid,        'Party Popper',       'Cotillon',            'Autre',      25),
  (md5('foraged_Dye')::uuid,           'Dye',                'Teinture',            'Autre',      50),
  (md5('foraged_Sparkler')::uuid,      'Colorful Sparkler',  'Cierge magique',      'Autre',     150),
  (md5('foraged_Kite')::uuid,          'Kite',               'Cerf-volant',         'Autre',     600),
  (md5('foraged_Balloon')::uuid,       'Balloon',            'Ballon',              'Autre',     600),
  -- Fleurs et plantes (ingrédients de recettes)
  (md5('foraged_WhiteDaisy')::uuid,    'White Daisy',        'Pâquerette blanche',  'Autre',       0),
  (md5('foraged_RedRose')::uuid,       'Red Rose',           'Rose rouge',          'Autre',       0),
  (md5('foraged_Weed')::uuid,          'Weed',               'Mauvaise herbe',      'Autre',       0);


-- ============================================================
-- 2. INGRÉDIENTS — table mère
--    source_type enum : Crop | Massimo_Store | Doris_Store
-- ============================================================
insert into public.ingredient
  (id, name_en, name, source_type)
values
  -- Massimo
  (md5('ingr_Meat')::uuid,          'Meat',          'Viande',           'Massimo_Store'),
  (md5('ingr_Egg')::uuid,           'Egg',           'Œuf',              'Massimo_Store'),
  (md5('ingr_Milk')::uuid,          'Milk',          'Lait',             'Massimo_Store'),
  (md5('ingr_Cheese')::uuid,        'Cheese',        'Fromage',          'Massimo_Store'),
  (md5('ingr_Butter')::uuid,        'Butter',        'Beurre',           'Massimo_Store'),
  (md5('ingr_CoffeeBeans')::uuid,   'CoffeeBeans',   'Grains de café',   'Massimo_Store'),
  (md5('ingr_TeaLeaves')::uuid,     'TeaLeaves',     'Feuilles de thé',  'Massimo_Store'),
  (md5('ingr_MatchaPowder')::uuid,  'MatchaPowder',  'Poudre de matcha', 'Massimo_Store'),
  (md5('ingr_RiceFlour')::uuid,     'RiceFlour',     'Farine de riz',    'Massimo_Store'),
  (md5('ingr_RedBean')::uuid,       'RedBean',       'Haricot rouge',    'Massimo_Store'),
  (md5('ingr_CookingOil')::uuid,    'CookingOil',    'Huile de cuisson', 'Massimo_Store'),
  (md5('ingr_PasturizedEgg')::uuid, 'PasturizedEgg', 'Œuf pasteurisé',   'Massimo_Store'),
  -- Doris
  (md5('ingr_BlueSugar')::uuid,     'BlueSugar',     'Sucre Bleu',       'Doris_Store'),
  (md5('ingr_IndigoSugar')::uuid,   'IndigoSugar',   'Sucre Indigo',     'Doris_Store'),
  (md5('ingr_VioletSugar')::uuid,   'VioletSugar',   'Sucre Violet',     'Doris_Store'),
  (md5('ingr_RedSugar')::uuid,      'RedSugar',      'Sucre Rouge',      'Doris_Store'),
  (md5('ingr_OrangeSugar')::uuid,   'OrangeSugar',   'Sucre Orange',     'Doris_Store'),
  (md5('ingr_YellowSugar')::uuid,   'YellowSugar',   'Sucre Jaune',      'Doris_Store'),
  (md5('ingr_GreenSugar')::uuid,    'GreenSugar',    'Sucre Vert',       'Doris_Store'),
  -- Cultures
  (md5('ingr_Tomato')::uuid,        'Tomato',        'Tomate',           'Crop'),
  (md5('ingr_Potato')::uuid,        'Potato',        'Pomme de terre',   'Crop'),
  (md5('ingr_Wheat')::uuid,         'Wheat',         'Blé',              'Crop'),
  (md5('ingr_Lettuce')::uuid,       'Lettuce',       'Laitue',           'Crop'),
  (md5('ingr_Pineapple')::uuid,     'Pineapple',     'Ananas',           'Crop'),
  (md5('ingr_Carrot')::uuid,        'Carrot',        'Carotte',          'Crop'),
  (md5('ingr_Strawberry')::uuid,    'Strawberry',    'Fraise',           'Crop'),
  (md5('ingr_Corn')::uuid,          'Corn',          'Maïs',             'Crop'),
  (md5('ingr_Grapes')::uuid,        'Grapes',        'Raisin',           'Crop'),
  (md5('ingr_Eggplant')::uuid,      'Eggplant',      'Aubergine',        'Crop'),
  (md5('ingr_TeaTree')::uuid,       'TeaTree',       'Arbre à thé',      'Crop'),
  (md5('ingr_Cocoa')::uuid,         'Cocoa',         'Cacao',            'Crop'),
  (md5('ingr_Avocado')::uuid,       'Avocado',       'Avocat',           'Crop');


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
  (md5('ingr_Tomato')::uuid,     1,  '15 minutes',  10,   30,   40,   50,   60,   70),
  (md5('ingr_Potato')::uuid,     1,  '1 hour',      30,   90,  120,  150,  180,  210),
  (md5('ingr_Wheat')::uuid,      2,  '4 hours',     95,  285,  381,  475,  570,  855),
  (md5('ingr_Lettuce')::uuid,    3,  '8 hours',    145,  435,  582,  726,  870, 1305),
  (md5('ingr_Pineapple')::uuid,  4,  '30 minutes',  15,   52,   69,   86,  104,  118),
  (md5('ingr_Carrot')::uuid,     5,  '2 hours',     50,  155,  207,  258,  310,  350),
  (md5('ingr_Strawberry')::uuid, 6,  '6 hours',    125,  375,  502,  626,  750, 1125),
  (md5('ingr_Corn')::uuid,       6,  '12 hours',   170,  515,  690,  860, 1030, 1545),
  (md5('ingr_Grapes')::uuid,     7,  '10 hours',   160,  480,  643,  801,  960, 1440),
  (md5('ingr_Eggplant')::uuid,   8,  '7 hours',    135,  406,  544,  678,  812, 1218),
  (md5('ingr_TeaTree')::uuid,    11, '45 minutes',  25,   75,  100,  125,  150,  225),
  (md5('ingr_Cocoa')::uuid,      12, '5 hours',    110,  330,  442,  551,  660,  990),
  (md5('ingr_Avocado')::uuid,    13, '13 hours',   180,  540,  735,  916, 1098, 1647);


-- ============================================================
-- 4. ARTICLES DE BOUTIQUE (store_item_detail)
--    discounted_price : uniquement Massimo (null pour Doris)
-- ============================================================
insert into public.store_item_detail
  (ingredient_id, store_name, base_price, discounted_price)
values
  (md5('ingr_Meat')::uuid,          'Massimo', 200, 120),
  (md5('ingr_Egg')::uuid,           'Massimo', 100,  60),
  (md5('ingr_Milk')::uuid,          'Massimo',  50,  30),
  (md5('ingr_Cheese')::uuid,        'Massimo', 100,  60),
  (md5('ingr_Butter')::uuid,        'Massimo', 150,  90),
  (md5('ingr_CoffeeBeans')::uuid,   'Massimo',  50,  30),
  (md5('ingr_TeaLeaves')::uuid,     'Massimo', 250, 150),
  (md5('ingr_MatchaPowder')::uuid,  'Massimo', 250, 150),
  (md5('ingr_RiceFlour')::uuid,     'Massimo',  50,  30),
  (md5('ingr_RedBean')::uuid,       'Massimo',  50,  30),
  (md5('ingr_CookingOil')::uuid,    'Massimo', 100,  60),
  (md5('ingr_PasturizedEgg')::uuid, 'Massimo', 100,  60),
  (md5('ingr_BlueSugar')::uuid,     'Doris',   150, null),
  (md5('ingr_IndigoSugar')::uuid,   'Doris',   150, null),
  (md5('ingr_VioletSugar')::uuid,   'Doris',   150, null),
  (md5('ingr_RedSugar')::uuid,      'Doris',   150, null),
  (md5('ingr_OrangeSugar')::uuid,   'Doris',   200, null),
  (md5('ingr_YellowSugar')::uuid,   'Doris',   150, null),
  (md5('ingr_GreenSugar')::uuid,    'Doris',   200, null);


-- ============================================================
-- 5. POISSONS (fish)
--
-- Mapping time_period[] depuis les chaînes JSON :
--   "Toute la journée"  → [Nuit,Matin,Aprem,Soirée]
--   "Attracteur Sirène" → []  + special_condition
--   "07:00 - 19:00"     → [Matin,Aprem]
--   "19:00 - 07:00"     → [Soirée,Nuit]
--   "13:00 - 01:00"     → [Aprem,Soirée]
--   "01:00 - 13:00"     → [Nuit,Matin]
--   "12:00 - 06:00"     → [Matin,Aprem,Soirée,Nuit]
--   "18:00 - 12:00"     → [Aprem,Soirée,Nuit,Matin]
--   "13:00 - 07:00"     → [Aprem,Soirée,Nuit]
--   "19:00 - 01:00"     → [Soirée]
--   "12:00 - 00:00"     → [Matin,Aprem,Soirée]
--   "07:00 - 01:00"     → [Matin,Aprem,Soirée]
--   "06:00 - 18:00"     → [Nuit,Matin,Aprem]
--   "18:00 - 06:00"     → [Aprem,Soirée,Nuit]
--   "19:00 - 13:00"     → [Soirée,Nuit,Matin]
--   "01:00 - 19:00"     → [Nuit,Matin,Aprem]
--   "19:00 - 02:00"     → [Soirée,Nuit]
--   "06:00 - 12:00"     → [Nuit,Matin]
--   "06:00 - 00:00"     → [Nuit,Matin,Aprem,Soirée]
--   "00:00 - 12:00"     → [Soirée,Nuit,Matin]
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
  (md5('fish_Striped Red Mullet')::uuid,
   'Striped Red Mullet','Rouget-barbet de roche',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Sea Fishing',ARRAY['Doré']::shadow_size[],
   320,480,640,1280,2560,null),

  (md5('fish_Common Octopus')::uuid,
   'Common Octopus','Poulpe commun',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Sea Fishing',ARRAY['Moyen','Doré']::shadow_size[],
   320,480,640,1280,2560,null),

  (md5('fish_Anglerfish')::uuid,
   'Anglerfish','Baudroie',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Sea Fishing',ARRAY['Doré']::shadow_size[],
   320,480,640,1280,2560,null),

  (md5('fish_Turbot')::uuid,
   'Turbot','Turbot',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Sea Fishing',ARRAY['Moyen']::shadow_size[],
   320,480,640,1280,2560,null),

  (md5('fish_European Flying Squid')::uuid,
   'European Flying Squid','Encornet rouge',5,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Sea Fishing',ARRAY['Doré']::shadow_size[],
   320,480,640,1280,2560,null),

  (md5('fish_Nursehound')::uuid,
   'Nursehound','Grande roussette',6,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Sea Fishing',ARRAY['Grand','Doré']::shadow_size[],
   535,802,1070,2140,4280,null),

  (md5('fish_Giant Oarfish')::uuid,
   'Giant Oarfish','Régalec géant',7,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Mer','Sea Fishing',ARRAY['Doré']::shadow_size[],
   535,802,1070,2140,4280,null),

  (md5('fish_Golden King Crab')::uuid,
   'Golden King Crab','Crabe royal doré',8,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Sea Fishing',ARRAY['Doré']::shadow_size[],
   850,1275,1700,3400,6800,null),

  (md5('fish_Moonfish')::uuid,
   'Moonfish','Opah (Poisson-lune)',9,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Mer','Sea Fishing',ARRAY['Doré']::shadow_size[],
   850,1275,1700,3400,6800,null),

  (md5('fish_Shortfin Mako Shark')::uuid,
   'Shortfin Mako Shark','Requin-taupe bleu',10,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Mer','Sea Fishing',ARRAY['Doré']::shadow_size[],
   850,1275,1700,3400,6800,null),

  (md5('fish_Whale Shark')::uuid,
   'Whale Shark','Requin-baleine',11,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit','Matin']::time_period[],
   'Mer','Sea Fishing',ARRAY['Or']::shadow_size[],
   0,0,0,0,0,null),

  (md5('fish_Moon Jellyfish')::uuid,
   'Moon Jellyfish','Méduse commune',12,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée','Nuit']::time_period[],
   'Mer','Sea Fishing',ARRAY['Or']::shadow_size[],
   0,0,0,0,0,null),

-- ── MER : Ocean ─────────────────────────────────────────────
  (md5('fish_Sardine')::uuid,
   'Sardine','Sardine',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Ocean',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  (md5('fish_Sea Bass')::uuid,
   'Sea Bass','Bar commun',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Ocean',ARRAY['Moyen']::shadow_size[],
   75,112,150,300,600,null),

  (md5('fish_Skipjack Tuna')::uuid,
   'Skipjack Tuna','Thon rose',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Ocean',ARRAY['Grand']::shadow_size[],
   210,315,420,840,1680,null),

  (md5('fish_Rabbit Fish')::uuid,
   'Rabbit Fish','Poisson-lapin',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY[]::time_period[],
   'Mer','Ocean',ARRAY['Moyen','Bleu']::shadow_size[],
   320,480,640,1280,2560,'Attracteur Sirène'),

-- ── MER : Zephyr Sea ────────────────────────────────────────
  (md5('fish_Beltfish')::uuid,
   'Beltfish','Poisson-sabre',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Grand']::shadow_size[],
   105,157,210,420,840,null),

  (md5('fish_Atlantic Pygmy Octopus')::uuid,
   'Atlantic Pygmy Octopus','Poulpe pygmée de l''Atlantique',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

  (md5('fish_False Scad')::uuid,
   'False Scad','Faux chinchard',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Moyen']::shadow_size[],
   155,232,310,620,1240,null),

  (md5('fish_European Lobster')::uuid,
   'European Lobster','Homard européen',5,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  (md5('fish_Blackspot Seabream')::uuid,
   'Blackspot Seabream','Dorade rose',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  (md5('fish_Bluefin Tuna')::uuid,
   'Bluefin Tuna','Thon rouge',9,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Grand']::shadow_size[],
   850,1275,1700,3400,6800,null),

  (md5('fish_Damselfly Fish')::uuid,
   'Damselfly Fish','Poisson-demoiselle',11,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Moyen']::shadow_size[],
   0,0,0,0,0,null),

  (md5('fish_Half-Blue Golden Damselfish')::uuid,
   'Half-Blue Golden Damselfish','Demoiselle dorée à queue bleue',14,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Mer','Zephyr Sea',ARRAY['Petit']::shadow_size[],
   0,0,0,0,0,null),

-- ── MER : East Sea ──────────────────────────────────────────
  (md5('fish_Common Prawn')::uuid,
   'Common Prawn','Crevette commune',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','East Sea',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  (md5('fish_Hermit Crab')::uuid,
   'Hermit Crab','Bernard-l''ermite',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','East Sea',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  (md5('fish_Goby')::uuid,
   'Goby','Gobie',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Mer','East Sea',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

  (md5('fish_Tub Gurnard')::uuid,
   'Tub Gurnard','Grondin perlon',6,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','East Sea',ARRAY['Moyen']::shadow_size[],
   380,570,760,1520,3040,null),

  (md5('fish_Haddock')::uuid,
   'Haddock','Églefin',8,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Mer','East Sea',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  (md5('fish_Ocean Sunfish')::uuid,
   'Ocean Sunfish','Môle (Poisson-lune)',9,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin']::time_period[],
   'Mer','East Sea',ARRAY['Grand']::shadow_size[],
   850,1275,1700,3400,6800,null),

  (md5('fish_Western Australian Fantasy Arowana')::uuid,
   'Western Australian Fantasy Arowana','Arowana fantastique d''Australie',14,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin']::time_period[],
   'Mer','East Sea',ARRAY['Moyen']::shadow_size[],
   0,0,0,0,0,null),

-- ── MER : Whale Sea ─────────────────────────────────────────
  (md5('fish_Scad')::uuid,
   'Scad','Chinchard',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Whale Sea',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  (md5('fish_Seahorse')::uuid,
   'Seahorse','Hippocampe',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Mer','Whale Sea',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  (md5('fish_Atlantic Salmon')::uuid,
   'Atlantic Salmon','Saumon atlantique',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Mer','Whale Sea',ARRAY['Moyen']::shadow_size[],
   155,232,310,620,1240,null),

  (md5('fish_Atlantic Mackerel')::uuid,
   'Atlantic Mackerel','Maquereau atlantique',5,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Mer','Whale Sea',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

  (md5('fish_King Crab')::uuid,
   'King Crab','Crabe royal',8,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Mer','Whale Sea',ARRAY['Grand']::shadow_size[],
   535,802,1070,2140,4280,null),

  (md5('fish_Swordfish')::uuid,
   'Swordfish','Espadon',10,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Mer','Whale Sea',ARRAY['Grand']::shadow_size[],
   850,1275,1700,3400,6800,null),

  (md5('fish_Green Sea Turtle')::uuid,
   'Green Sea Turtle','Tortue verte',12,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Mer','Whale Sea',ARRAY['Grand']::shadow_size[],
   0,0,0,0,0,null),

  (md5('fish_Lionfish')::uuid,
   'Lionfish','Poisson-lion',13,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit','Matin']::time_period[],
   'Mer','Whale Sea',ARRAY['Moyen']::shadow_size[],
   0,0,0,0,0,null),

-- ── MER : Old Sea ───────────────────────────────────────────
  (md5('fish_Sea Stickleback')::uuid,
   'Sea Stickleback','Épinoche de mer',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Old Sea',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  (md5('fish_Clownfish')::uuid,
   'Clownfish','Poisson-clown',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mer','Old Sea',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  (md5('fish_European Plaice')::uuid,
   'European Plaice','Carrelet européen',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Mer','Old Sea',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  (md5('fish_Pufferfish')::uuid,
   'Pufferfish','Poisson-globe',6,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Mer','Old Sea',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  (md5('fish_European Eel')::uuid,
   'European Eel','Anguille européenne',7,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Soirée']::time_period[],
   'Mer','Old Sea',ARRAY['Moyen']::shadow_size[],
   380,570,760,1520,3040,null),

  (md5('fish_Smooth Hammerhead')::uuid,
   'Smooth Hammerhead','Requin-marteau lisse',10,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Mer','Old Sea',ARRAY['Grand']::shadow_size[],
   850,1275,1700,3400,6800,null),

  (md5('fish_Koi')::uuid,
   'Koi','Carpe Koï',12,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Mer','Old Sea',ARRAY['Grand']::shadow_size[],
   0,0,0,0,0,null),

  (md5('fish_Blue Tang')::uuid,
   'Blue Tang','Chirurgien bleu',13,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée','Nuit']::time_period[],
   'Mer','Old Sea',ARRAY['Moyen']::shadow_size[],
   0,0,0,0,0,null),

-- ── LAC : Lake ──────────────────────────────────────────────
  (md5('fish_Common Bleak')::uuid,
   'Common Bleak','Ablette',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Lake',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  (md5('fish_Common Chub')::uuid,
   'Common Chub','Chevesne',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Lake',ARRAY['Moyen']::shadow_size[],
   75,112,150,300,600,null),

  (md5('fish_Edible Frog')::uuid,
   'Edible Frog','Grenouille comestible',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY[]::time_period[],
   'Lac','Lake',ARRAY['Bleu']::shadow_size[],
   320,480,640,1280,2560,'Attracteur Sirène'),

-- ── LAC : Forest Lake ───────────────────────────────────────
  (md5('fish_Tench')::uuid,
   'Tench','Tanche',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Forest Lake',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  (md5('fish_Largemouth Bass')::uuid,
   'Largemouth Bass','Achigan à grande bouche',4,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Forest Lake',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  (md5('fish_Mud Sunfish')::uuid,
   'Mud Sunfish','Amiure',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Lac','Forest Lake',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  (md5('fish_European Crayfish')::uuid,
   'European Crayfish','Écrevisse à pattes blanches',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit','Matin']::time_period[],
   'Lac','Forest Lake',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  (md5('fish_Large Pearl Mussel')::uuid,
   'Large Pearl Mussel','Moule perlière d''eau douce',6,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Forest Lake',ARRAY['Moyen']::shadow_size[],
   380,570,760,1520,3040,null),

  (md5('fish_Blue European Crayfish')::uuid,
   'Blue European Crayfish','Écrevisse bleue',8,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Lac','Forest Lake',ARRAY['Petit']::shadow_size[],
   250,375,500,1000,2000,null),

  (md5('fish_Arctic Char')::uuid,
   'Arctic Char','Omble chevalier',10,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Lac','Forest Lake',ARRAY['Moyen']::shadow_size[],
   610,915,1220,2440,4880,null),

  (md5('fish_Betta Fish')::uuid,
   'Betta Fish','Combattant (Betta)',12,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Lac','Forest Lake',ARRAY['Petit']::shadow_size[],
   0,0,0,0,0,null),

-- ── LAC : Meadow Lake ───────────────────────────────────────
  (md5('fish_European Smelt')::uuid,
   'European Smelt','Éperlan européen',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Meadow Lake',ARRAY['Moyen']::shadow_size[],
   100,150,200,400,800,null),

  (md5('fish_Trout')::uuid,
   'Trout','Truite',5,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Lac','Meadow Lake',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  (md5('fish_Butterfly Koi')::uuid,
   'Butterfly Koi','Carpe Koï papillon',4,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Meadow Lake',ARRAY['Grand']::shadow_size[],
   320,480,640,1280,2560,null),

  (md5('fish_Goldfish')::uuid,
   'Goldfish','Poisson rouge',8,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Lac','Meadow Lake',ARRAY['Petit']::shadow_size[],
   250,375,500,1000,2000,null),

  (md5('fish_Wels Catfish')::uuid,
   'Wels Catfish','Silure glane',10,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Lac','Meadow Lake',ARRAY['Moyen']::shadow_size[],
   610,915,1220,2440,4880,null),

  (md5('fish_Golden Arowana')::uuid,
   'Golden Arowana','Arowana doré',11,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Lac','Meadow Lake',ARRAY['Petit']::shadow_size[],
   0,0,0,0,0,null),

-- ── LAC : Suburban Lake ─────────────────────────────────────
  (md5('fish_Crucian Carp')::uuid,
   'Crucian Carp','Carpe carassin',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Suburban Lake',ARRAY['Moyen']::shadow_size[],
   75,112,150,300,600,null),

  (md5('fish_Schneider')::uuid,
   'Schneider','Spirlin',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Suburban Lake',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  (md5('fish_Stone Loach')::uuid,
   'Stone Loach','Loche de rivière',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Suburban Lake',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  (md5('fish_Mussel')::uuid,
   'Mussel','Moule',3,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Suburban Lake',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  (md5('fish_River Crab')::uuid,
   'River Crab','Crabe de rivière',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Suburban Lake',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  (md5('fish_Common Rudd')::uuid,
   'Common Rudd','Rotengle',5,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Suburban Lake',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

  (md5('fish_Grayling')::uuid,
   'Grayling','Ombre commun',6,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Suburban Lake',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  (md5('fish_Mediterranean Killifish')::uuid,
   'Mediterranean Killifish','Aphanius d''Espagne',7,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem']::time_period[],
   'Lac','Suburban Lake',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

  (md5('fish_European Mudminnow')::uuid,
   'European Mudminnow','Umbre de l''Est',8,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin']::time_period[],
   'Lac','Suburban Lake',ARRAY['Petit']::shadow_size[],
   250,375,500,1000,2000,null),

  (md5('fish_Northern Pike')::uuid,
   'Northern Pike','Grand brochet',9,
   ARRAY['Pluie','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Lac','Suburban Lake',ARRAY['Moyen']::shadow_size[],
   610,915,1220,2440,4880,null),

  (md5('fish_Angel Fish')::uuid,
   'Angel Fish','Poisson-ange',12,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Lac','Suburban Lake',ARRAY['Moyen']::shadow_size[],
   0,0,0,0,0,null),

-- ── LAC : Onsen Mountain Lake ────────────────────────────────
  (md5('fish_Common Whitefish')::uuid,
   'Common Whitefish','Corégone blanc',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Onsen Mountain Lake',ARRAY['Moyen']::shadow_size[],
   105,157,210,420,840,null),

  (md5('fish_Ruffe')::uuid,
   'Ruffe','Grémille',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Lac','Onsen Mountain Lake',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  (md5('fish_Tadpole')::uuid,
   'Tadpole','Têtard',3,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Onsen Mountain Lake',ARRAY['Petit']::shadow_size[],
   100,150,200,400,800,null),

  (md5('fish_Mottled Sculpin')::uuid,
   'Mottled Sculpin','Chabot tacheté',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Lac','Onsen Mountain Lake',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

  (md5('fish_Pumpkinseed')::uuid,
   'Pumpkinseed','Crapet-soleil',9,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Lac','Onsen Mountain Lake',ARRAY['Petit']::shadow_size[],
   250,375,500,1000,2000,null),

  (md5('fish_Bluegill')::uuid,
   'Bluegill','Crapet arlequin',10,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Lac','Onsen Mountain Lake',ARRAY['Petit']::shadow_size[],
   395,592,790,1580,3160,null),

  (md5('fish_Lionhead Goldfish')::uuid,
   'Lionhead Goldfish','Tête de lion (Poisson rouge)',11,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac','Onsen Mountain Lake',ARRAY['Petit']::shadow_size[],
   0,0,0,0,0,null),

-- ── RIVIÈRE : River ──────────────────────────────────────────
  (md5('fish_European Perch')::uuid,
   'European Perch','Perche commune',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','River',ARRAY['Moyen']::shadow_size[],
   75,112,150,300,600,null),

  (md5('fish_Oriental Shrimp')::uuid,
   'Oriental Shrimp','Crevette orientale',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','River',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  (md5('fish_Tilapia')::uuid,
   'Tilapia','Tilapia',4,
   ARRAY['Soleil','Pluie','Arc-en-ciel']::weather_type[],
   ARRAY[]::time_period[],
   'Rivière','River',ARRAY['Moyen','Bleu']::shadow_size[],
   320,480,640,1280,2560,'Attracteur Sirène'),

-- ── RIVIÈRE : Shallow River ──────────────────────────────────
  (md5('fish_Barbel')::uuid,
   'Barbel','Barbeau',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Shallow River',ARRAY['Moyen']::shadow_size[],
   75,112,150,300,600,null),

  (md5('fish_Three-Spined Stickleback')::uuid,
   'Three-Spined Stickleback','Épinoche à trois épines',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Shallow River',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

-- ── RIVIÈRE : Tranquil River ─────────────────────────────────
  (md5('fish_Minnow')::uuid,
   'Minnow','Vairon',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Tranquil River',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  (md5('fish_Burbot')::uuid,
   'Burbot','Lote',4,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Rivière','Tranquil River',ARRAY['Grand']::shadow_size[],
   230,345,460,920,1840,null),

  (md5('fish_Chum Salmon')::uuid,
   'Chum Salmon','Saumon kéta',6,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Tranquil River',ARRAY['Petit']::shadow_size[],
   150,225,300,600,1200,null),

-- ── RIVIÈRE : Giantwood River ────────────────────────────────
  (md5('fish_Spined Loach')::uuid,
   'Spined Loach','Loche de rivière commune',1,
   ARRAY['Soleil','Pluie','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Giantwood River',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  (md5('fish_Zander')::uuid,
   'Zander','Sandre',3,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Giantwood River',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  (md5('fish_Red-Bellied Piranha')::uuid,
   'Red-Bellied Piranha','Piranha à ventre rouge',4,
   ARRAY['Soleil','Pluie','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Giantwood River',ARRAY['Moyen']::shadow_size[],
   230,345,460,920,1840,null),

  (md5('fish_Huchen')::uuid,
   'Huchen','Huchon',9,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Rivière','Giantwood River',ARRAY['Moyen']::shadow_size[],
   380,570,760,1520,3040,null),

-- ── RIVIÈRE : Rosy River ─────────────────────────────────────
  (md5('fish_Streber')::uuid,
   'Streber','Apron du Danube',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière','Rosy River',ARRAY['Petit']::shadow_size[],
   50,75,100,200,400,null),

  (md5('fish_Common Carp')::uuid,
   'Common Carp','Carpe commune',4,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Rivière','Rosy River',ARRAY['Moyen']::shadow_size[],
   50,75,100,200,400,null),

  (md5('fish_Freshwater Blenny')::uuid,
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
  (md5('insect_Large Red Damselfly')::uuid,
   'Large Red Damselfly','Agrion rouge',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Bord de l''eau',35,52,70,140,280),

  (md5('insect_Orange-Tip')::uuid,
   'Orange-Tip','Aurore (Papillon)',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Zone Centrale',30,45,60,120,240),

  (md5('insect_Common Blue Butterfly')::uuid,
   'Common Blue Butterfly','Argus bleu',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Zone Centrale',105,157,210,300,600),

  (md5('insect_Sulkowsky''s Morpho')::uuid,
   'Sulkowsky''s Morpho','Morpho de Sulkowsky',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Attracteur d''insectes gonflable',90,135,180,360,720),

  (md5('insect_Common Whitetail')::uuid,
   'Common Whitetail','Libellule à queue blanche',4,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rive de la rivière',75,112,150,300,600),

-- ── Événement Appât ─────────────────────────────────────────
  (md5('insect_Apollo')::uuid,
   'Apollo','Apollon',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Appât',30,45,60,120,240),

  (md5('insect_Postman Butterfly')::uuid,
   'Postman Butterfly','Papillon facteur',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Appât',30,45,60,120,240),

  (md5('insect_Pink Katydid')::uuid,
   'Pink Katydid','Sauterelle rose',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Appât',90,135,180,360,720),

  (md5('insect_White Witch')::uuid,
   'White Witch','Sorcière blanche (Phalène)',6,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Appât',90,135,180,360,720),

  (md5('insect_Chestnut Tiger')::uuid,
   'Chestnut Tiger','Grand monarque oriental',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Appât',150,225,300,600,1200),

  (md5('insect_Rainbow Stag Beetle')::uuid,
   'Rainbow Stag Beetle','Lucane arc-en-ciel',10,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Ruines de l''Événement',440,660,880,1760,3520),

-- ── Terrains Privés et Rochers ──────────────────────────────
  (md5('insect_European Firebug')::uuid,
   'European Firebug','Gendarme',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rochers du terrain',35,52,70,140,280),

  (md5('insect_Amethyst Flower Beetle')::uuid,
   'Amethyst Flower Beetle','Cetoine améthyste',2,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rochers du terrain',165,247,330,660,1320),

  (md5('insect_Rajah Brooke''s Birdwing')::uuid,
   'Rajah Brooke''s Birdwing','Ornithoptère de Brooke',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit','Matin']::time_period[],
   'Terrains privés',90,135,180,360,720),

-- ── Banlieue ────────────────────────────────────────────────
  (md5('insect_Common Brimstone')::uuid,
   'Common Brimstone','Citron (Papillon)',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Banlieue',30,45,60,120,240),

  (md5('insect_Four-Spotted Skimmer')::uuid,
   'Four-Spotted Skimmer','Libellule à quatre taches',2,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rive de la banlieue',75,112,150,300,600),

  (md5('insect_Seven-Spotted Ladybug')::uuid,
   'Seven-Spotted Ladybug','Coccinelle à sept points',2,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Banlieue',110,165,220,440,880),

  (md5('insect_Mini Moon Moth')::uuid,
   'Mini Moon Moth','Mini papillon lune',3,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit','Matin']::time_period[],
   'Banlieue',105,158,210,420,840),

  (md5('insect_Large Banded Grasshopper')::uuid,
   'Large Banded Grasshopper','Criquet à bandes noires',4,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Banlieue',140,210,280,460,1120),

  (md5('insect_Green Birdwing')::uuid,
   'Green Birdwing','Ornithoptère vert',6,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Banlieue',150,225,300,600,1200),

  (md5('insect_Comet Moth')::uuid,
   'Comet Moth','Papillon comète',8,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Banlieue',240,360,480,960,1920),

  (md5('insect_Queen Alexandra''s Birdwing')::uuid,
   'Queen Alexandra''s Birdwing','Ornithoptère de la Reine Alexandra',11,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Rive de la banlieue',0,0,0,0,0),

  (md5('insect_Gorgeous Damselfly')::uuid,
   'Gorgeous Damselfly','Demoiselle magnifique',13,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Rive de la banlieue',0,0,0,0,0),

-- ── Village de Pêcheurs ─────────────────────────────────────
  (md5('insect_Cabbage White')::uuid,
   'Cabbage White','Piéride du chou',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Village',30,45,60,120,240),

  (md5('insect_Siberian Grasshopper')::uuid,
   'Siberian Grasshopper','Criquet de Sibérie',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Village',90,135,180,360,720),

  (md5('insect_Ant')::uuid,
   'Ant','Fourmi',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Place du Village',220,330,440,880,1760),

  (md5('insect_Beautiful Leopard')::uuid,
   'Beautiful Leopard','Lépidoptère léopard',4,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit','Matin']::time_period[],
   'Quai du Village',90,135,180,360,720),

  (md5('insect_Blue Shieldbug')::uuid,
   'Blue Shieldbug','Punaise bleue',6,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Phare du Village',110,165,220,440,880),

  (md5('insect_Horned Beetle')::uuid,
   'Horned Beetle','Scarabée cornu',8,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Jetée Est',275,412,550,1100,2200),

  (md5('insect_Cerulean Carpenter')::uuid,
   'Cerulean Carpenter','Abeille charpentière céruléenne',9,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Place du Village',440,660,880,1760,3520),

-- ── Mont Onsen ───────────────────────────────────────────────
  (md5('insect_Gold Grasshoppers')::uuid,
   'Gold Grasshoppers','Criquet doré',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mont Onsen',45,67,90,180,360),

  (md5('insect_Green Tiger Beetle')::uuid,
   'Green Tiger Beetle','Cicindèle verte',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mont Onsen',110,165,220,440,880),

  (md5('insect_Fire-Colored Beetle')::uuid,
   'Fire-Colored Beetle','Cardinal (Insecte)',3,
   ARRAY['Soleil','Pluie','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mont Onsen',110,165,220,440,880),

  (md5('insect_Four-Spotted Ladybug')::uuid,
   'Four-Spotted Ladybug','Coccinelle à quatre points',4,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac du Cratère',165,247,330,660,1320),

  (md5('insect_Hercules Beetle')::uuid,
   'Hercules Beetle','Scarabée Hercule',10,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Lac du Cratère',440,660,880,1760,3520),

  (md5('insect_Mediterranean Mantis')::uuid,
   'Mediterranean Mantis','Mante méditerranéenne',5,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Falaise rocheuse',195,292,390,780,1560),

  (md5('insect_Giant Asian Mantis')::uuid,
   'Giant Asian Mantis','Mante géante d''Asie',5,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Ruines d''Onsen',390,585,780,1560,3120),

  (md5('insect_Mourning Cloak')::uuid,
   'Mourning Cloak','Moro-sphinx',5,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Mont Onsen',90,135,180,360,720),

  (md5('insect_Silver Jewel Scarab')::uuid,
   'Silver Jewel Scarab','Scarabée bijou argenté',6,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Falaise rocheuse',165,247,330,660,1320),

  (md5('insect_Crimson Marsh Glider')::uuid,
   'Crimson Marsh Glider','Libellule pourpre des marais',7,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem']::time_period[],
   'Bord du lac',185,277,370,740,1480),

  (md5('insect_Minotaur Beetle')::uuid,
   'Minotaur Beetle','Minotaure (Scarabée)',8,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Ruines d''Onsen',275,412,550,1100,2200),

  (md5('insect_Conehead Mantis')::uuid,
   'Conehead Mantis','Mante à tête conique',9,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Ruines d''Onsen',515,772,1030,2060,4120),

  (md5('insect_Orchid Mantis')::uuid,
   'Orchid Mantis','Mante orchidée',11,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Ruines d''Onsen',0,0,0,0,0),

  (md5('insect_Milkweed Grasshopper')::uuid,
   'Milkweed Grasshopper','Criquet de l''asclépiade',12,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Lac d''Onsen',0,0,0,0,0),

  (md5('insect_Dream Glow Butterfly')::uuid,
   'Dream Glow Butterfly','Papillon éclat de rêve',13,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Cratère du lac d''Onsen',0,0,0,0,0),

-- ── Forêt de Pins du Chêne Spirituel ────────────────────────
  (md5('insect_Cicada')::uuid,
   'Cicada','Cigale',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Forêt de pins',220,330,440,880,1760),

  (md5('insect_Blue Morpho')::uuid,
   'Blue Morpho','Morpho bleu',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin']::time_period[],
   'Forêt de pins',150,225,300,600,1200),

  (md5('insect_Spanish Moon Moth')::uuid,
   'Spanish Moon Moth','Isabelle (Papillon)',9,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Forêt de pins',150,225,300,600,1200),

  (md5('insect_Golden Stag Beetle')::uuid,
   'Golden Stag Beetle','Lucane doré',9,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Forêt de pins',440,660,880,1760,3520),

  (md5('insect_Southeast Asian Giant Rhinoceros Beetle')::uuid,
   'Southeast Asian Giant Rhinoceros Beetle','Scarabée rhinocéros géant d''Asie',11,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée','Nuit']::time_period[],
   'Forêt de pins',0,0,0,0,0),

-- ── Champ de Fleurs ──────────────────────────────────────────
  (md5('insect_Asparagus Beetle')::uuid,
   'Asparagus Beetle','Criocère de l''asperge',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs',55,82,110,220,440),

  (md5('insect_Bumblebee')::uuid,
   'Bumblebee','Bourdon',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs',110,165,220,440,880),

  (md5('insect_Katydid')::uuid,
   'Katydid','Sauterelle verte',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs',180,270,360,720,1440),

  (md5('insect_Purple Emperor')::uuid,
   'Purple Emperor','Grand Mars changeant',3,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem']::time_period[],
   'Montagne des Baleines',90,135,180,360,720),

  (md5('insect_Splay-Footed Carpenter')::uuid,
   'Splay-Footed Carpenter','Abeille charpentière',5,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Montagne des Baleines',165,247,330,660,1320),

  (md5('insect_Peacock Butterfly')::uuid,
   'Peacock Butterfly','Paon-du-jour',5,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs du Moulin',90,135,180,360,720),

  (md5('insect_Elegant Flower Beetle')::uuid,
   'Elegant Flower Beetle','Cetoine élégante',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Montagne des Baleines',275,412,550,1100,2200),

  (md5('insect_Picasso Bug')::uuid,
   'Picasso Bug','Punaise Picasso',8,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Soirée','Nuit']::time_period[],
   'Plage d''Améthyste',185,277,370,740,1480),

  (md5('insect_Mother of Pearl')::uuid,
   'Mother of Pearl','Nacre (Papillon)',9,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs du Moulin',240,360,480,960,1920),

  (md5('insect_Morpho Helena')::uuid,
   'Morpho Helena','Morpho Helena',10,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Plage d''Améthyste',240,360,480,960,1920),

  (md5('insect_Rose Swallowtail Butterfly')::uuid,
   'Rose Swallowtail Butterfly','Voilier rose',12,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs du Moulin',0,0,0,0,0),

  (md5('insect_Flame Dragonfly')::uuid,
   'Flame Dragonfly','Libellule de feu',12,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Montagne des Baleines',0,0,0,0,0),

  (md5('insect_Glasswing Butterfly')::uuid,
   'Glasswing Butterfly','Papillon aux ailes de verre',14,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Montagne des Baleines',0,0,0,0,0),

-- ── Forêt ────────────────────────────────────────────────────
  (md5('insect_Old World Swallowtail')::uuid,
   'Old World Swallowtail','Machaon',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Forêt',30,45,60,120,240),

  (md5('insect_Wasp Beetle')::uuid,
   'Wasp Beetle','Clyte bélier',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Forêt',110,165,220,440,880),

  (md5('insect_Waroona Cuckoo Bee')::uuid,
   'Waroona Cuckoo Bee','Abeille coucou de Waroona',3,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Tour des cerfs',165,247,330,660,1320),

  (md5('insect_Alpine Longhorn Beetle')::uuid,
   'Alpine Longhorn Beetle','Rosalie des Alpes',5,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Île de la forêt',165,247,330,660,1320),

  (md5('insect_Asian Lady Beetle')::uuid,
   'Asian Lady Beetle','Coccinelle asiatique',5,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Tour des cerfs',165,247,330,660,1320),

  (md5('insect_Beautiful Demoiselle')::uuid,
   'Beautiful Demoiselle','Caloptéryx éclatant',6,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rive du lac de la forêt',110,165,220,440,880),

  (md5('insect_Golden Jewel Scarab')::uuid,
   'Golden Jewel Scarab','Scarabée bijou doré',7,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Puzzle de saut',275,412,550,1100,2200),

  (md5('insect_Stag Beetle')::uuid,
   'Stag Beetle','Lucane cerf-volant',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin']::time_period[],
   'Puzzle de saut',275,412,550,1100,2200),

  (md5('insect_Bagworm Moth')::uuid,
   'Bagworm Moth','Psyché (Papillon)',10,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Tour des cerfs',440,660,880,1760,3520),

  (md5('insect_Sunset Morpho')::uuid,
   'Sunset Morpho','Morpho du coucher de soleil',10,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Tour des cerfs',240,360,480,960,1920),

  (md5('insect_Goliathus Atlas Beetle')::uuid,
   'Goliathus Atlas Beetle','Scarabée Goliath',12,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée','Nuit']::time_period[],
   'Tour des cerfs',0,0,0,0,0),

  (md5('insect_Green Snail')::uuid,
   'Green Snail','Escargot vert',14,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Île de la forêt',0,0,0,0,0),

-- ── Zones Spécifiques / Montagnes ────────────────────────────
  (md5('insect_Little Thirteen-Star Ladybug')::uuid,
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
  (md5('bird_Greater Flamingo')::uuid,
   'Greater Flamingo','Grand Flamant',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Bord de l''eau',15,60,120,240,480),

  (md5('bird_Mallard')::uuid,
   'Mallard','Canard colvert',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac',12,50,100,200,400),

  (md5('bird_Eurasian Wigeon')::uuid,
   'Eurasian Wigeon','Canard siffleur',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière',17,70,140,280,560),

  (md5('bird_King Eider')::uuid,
   'King Eider','Eider à tête grise',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rivière',17,70,140,280,560),

  (md5('bird_Seagull')::uuid,
   'Seagull','Mouette',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Bord de mer',17,70,140,280,560),

  (md5('bird_European Shag')::uuid,
   'European Shag','Cormoran huppé',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Océan',17,70,140,280,560),

-- ── Événement Nid des Cent ──────────────────────────────────
  (md5('bird_Blue Peafowl')::uuid,
   'Blue Peafowl','Paon bleu',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',10,40,80,160,320),

  (md5('bird_Blue-and-Yellow Macaw')::uuid,
   'Blue-and-Yellow Macaw','Ara bleu',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',7,30,60,120,240),

  (md5('bird_Red-and-Green Macaw')::uuid,
   'Red-and-Green Macaw','Ara chloroptère',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',10,40,80,160,320),

  (md5('bird_Great Green Macaw')::uuid,
   'Great Green Macaw','Grand Ara vert',5,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',15,60,120,240,480),

  (md5('bird_Lear''s Macaw')::uuid,
   'Lear''s Macaw','Ara de Lear',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',22,90,180,360,720),

  (md5('bird_Green Peafowl')::uuid,
   'Green Peafowl','Paon vert',9,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',37,150,300,600,1200),

  (md5('bird_White Peacock')::uuid,
   'White Peacock','Paon blanc',11,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',0,0,0,0,0),

  (md5('bird_Black Peacock')::uuid,
   'Black Peacock','Paon noir',13,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Événement Nid des Cent',0,0,0,0,0),

-- ── Banlieue et Terrains Privés ─────────────────────────────
  (md5('bird_Eurasian Collared Dove')::uuid,
   'Eurasian Collared Dove','Tourterelle turque',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Terrains privés',10,40,80,160,320),

  (md5('bird_Eurasian Golden Oriole')::uuid,
   'Eurasian Golden Oriole','Loriot d''Europe',3,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Terrains privés',15,60,120,240,480),

  (md5('bird_Eurasian Bullfinch')::uuid,
   'Eurasian Bullfinch','Bouvreuil pivoine',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Banlieue',7,30,60,120,240),

  (md5('bird_Woodchat Shrike')::uuid,
   'Woodchat Shrike','Pie-grièche à tête rousse',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Banlieue',10,40,80,160,320),

  (md5('bird_Ruddy Shelduck')::uuid,
   'Ruddy Shelduck','Tadorne casarca',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac de banlieue',17,70,140,280,560),

  (md5('bird_Jambu Fruit Dove')::uuid,
   'Jambu Fruit Dove','Ptilope jambou',7,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Banlieue',27,110,220,440,880),

  (md5('bird_Eastern Bluebird')::uuid,
   'Eastern Bluebird','Merlebleu de l''Est',8,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Banlieue',30,120,240,480,960),

  (md5('bird_Paradise Tanager')::uuid,
   'Paradise Tanager','Tangara de paradis',9,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Banlieue',30,120,240,480,960),

  (md5('bird_Nicobar Pigeon')::uuid,
   'Nicobar Pigeon','Pigeon à camail',11,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée','Nuit']::time_period[],
   'Banlieue',0,0,0,0,0),

  (md5('bird_Mute Swan')::uuid,
   'Mute Swan','Cygne tuberculé',13,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rive de la banlieue',0,0,0,0,0),

  (md5('bird_Black Swan')::uuid,
   'Black Swan','Cygne noir',13,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem']::time_period[],
   'Rive de la banlieue',0,0,0,0,0),

-- ── Zone Centrale ────────────────────────────────────────────
  (md5('bird_Stock Dove')::uuid,
   'Stock Dove','Pigeon colombin',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Zone centrale',10,40,80,160,320),

  (md5('bird_Eurasian Robin')::uuid,
   'Eurasian Robin','Rouge-gorge familier',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Zone centrale',7,30,60,120,240),

  (md5('bird_Long-Tailed Tit')::uuid,
   'Long-Tailed Tit','Mésange à longue queue',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Tête de Blanc',2,8,16,32,64),

-- ── Village de Pêcheurs ─────────────────────────────────────
  (md5('bird_Pied Imperial Pigeon')::uuid,
   'Pied Imperial Pigeon','Carpophage blanc',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Village de pêcheurs',10,40,80,160,320),

  (md5('bird_Eurasian Nuthatch')::uuid,
   'Eurasian Nuthatch','Sittelle d''Europe',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Village de pêcheurs',10,40,80,160,320),

  (md5('bird_Przevalski''s Parrotbill')::uuid,
   'Przevalski''s Parrotbill','Paradoxornis de Przevalski',4,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Place du village',15,60,120,240,480),

  (md5('bird_Yellow Bellied Flycatcher')::uuid,
   'Yellow Bellied Flycatcher','Moucherolle à ventre jaune',5,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Quai du village',15,60,120,240,480),

  (md5('bird_Cinnamon Ground Dove')::uuid,
   'Cinnamon Ground Dove','Gallicolombe de Palau',6,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Jetée Est du village',27,110,220,440,880),

  (md5('bird_Double-Barred Finch')::uuid,
   'Double-Barred Finch','Diamant de Bicheno',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Phare du village',10,40,80,160,320),

  (md5('bird_Azores Bullfinch')::uuid,
   'Azores Bullfinch','Bouvreuil des Açores',10,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Phare du village',30,120,240,480,960),

-- ── Champ de Fleurs ──────────────────────────────────────────
  (md5('bird_Pink-Necked Green Pigeon')::uuid,
   'Pink-Necked Green Pigeon','Ptilope à cou rose',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs',15,60,120,240,480),

  (md5('bird_Eurasian Chaffinch')::uuid,
   'Eurasian Chaffinch','Pinson des arbres',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Champ de fleurs',7,30,60,120,240),

  (md5('bird_White Wagtail')::uuid,
   'White Wagtail','Bergeronnette grise',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Plage d''Améthyste',15,60,120,240,480),

  (md5('bird_American Flamingo')::uuid,
   'American Flamingo','Flamant des Caraïbes',9,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Plage d''Améthyste',55,220,440,880,1760),

  (md5('bird_Wallace''s Fruit Dove')::uuid,
   'Wallace''s Fruit Dove','Ptilope de Wallace',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Moulin du champ de fleurs',17,70,140,280,560),

  (md5('bird_Azure Tit')::uuid,
   'Azure Tit','Mésange azurée',7,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Moulin du champ de fleurs',22,90,180,360,720),

  (md5('bird_Pink Pigeon')::uuid,
   'Pink Pigeon','Pigeon rose',8,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Montagne des Baleines',27,110,220,440,880),

  (md5('bird_Purple Finch')::uuid,
   'Purple Finch','Roselin pourpré',11,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Moulin du champ de fleurs',0,0,0,0,0),

-- ── Mont Onsen et Mer Ancienne ───────────────────────────────
  (md5('bird_Brown Noddy')::uuid,
   'Brown Noddy','Noddi brun',5,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Bord de mer ancienne',22,90,180,360,720),

  (md5('bird_Great Tit')::uuid,
   'Great Tit','Mésange charbonnière',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mont Onsen',7,30,60,120,240),

  (md5('bird_Bearded Reedling')::uuid,
   'Bearded Reedling','Mésange à moustaches',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mont Onsen',10,40,80,160,320),

  (md5('bird_African Olive Pigeon')::uuid,
   'African Olive Pigeon','Pigeon roussard',5,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Mont Onsen',27,110,220,440,880),

  (md5('bird_Peregrine Falcon')::uuid,
   'Peregrine Falcon','Faucon pèlerin',8,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Mont Onsen',65,260,520,1040,2080),

  (md5('bird_Hawfinch')::uuid,
   'Hawfinch','Gros-bec casse-noyaux',6,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac du cratère Onsen',15,60,120,240,480),

  (md5('bird_Long Eared Owl')::uuid,
   'Long Eared Owl','Hibou moyen-duc',6,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Aprem','Soirée']::time_period[],
   'Falaise d''Onsen',47,190,380,760,1520),

  (md5('bird_European Bee-Eater')::uuid,
   'European Bee-Eater','Guêpier d''Europe',5,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rive du lac Onsen',22,90,180,360,720),

  (md5('bird_White-Headed Duck')::uuid,
   'White-Headed Duck','Érable à tête blanche',9,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Rive du lac Onsen',45,180,360,720,1440),

  (md5('bird_Lady Amherst Pheasant')::uuid,
   'Lady Amherst Pheasant','Faisan de Lady Amherst',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Ruines d''Onsen',17,70,140,280,560),

  (md5('bird_Amur Falcon')::uuid,
   'Amur Falcon','Faucon de l''Amour',10,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Ruines d''Onsen',65,260,520,1040,2080),

  (md5('bird_Spot-billed Duck')::uuid,
   'Spot-billed Duck','Canard à bec tacheté',11,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem']::time_period[],
   'Lac du mont Onsen',0,0,0,0,0),

  (md5('bird_Red-billed Leiothrix')::uuid,
   'Red-billed Leiothrix','Léiotrix à bec rouge',12,
   ARRAY['Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Cratère du lac Onsen',0,0,0,0,0),

  (md5('bird_Rock Pigeon')::uuid,
   'Rock Pigeon','Pigeon biset',11,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin']::time_period[],
   'Côte de la mer ancienne',0,0,0,0,0),

-- ── Forêt ────────────────────────────────────────────────────
  (md5('bird_Eurasian Wren')::uuid,
   'Eurasian Wren','Troglodyte mignon',1,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Forêt',7,30,60,120,240),

  (md5('bird_Wonga Pigeon')::uuid,
   'Wonga Pigeon','Pigeon wonga',2,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Forêt',15,60,120,240,480),

  (md5('bird_Silver-Throated Tit')::uuid,
   'Silver-Throated Tit','Mésange à gorge argentée',3,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Puzzle de saut forêt',10,40,80,160,320),

  (md5('bird_Verditer Flycatcher')::uuid,
   'Verditer Flycatcher','Gobe-mouche vert-de-gris',10,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Puzzle de saut forêt',30,120,240,480,960),

  (md5('bird_Pine Grosbeak')::uuid,
   'Pine Grosbeak','Durbec des sapins',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Île de la forêt',15,60,120,240,480),

  (md5('bird_Smew')::uuid,
   'Smew','Piette',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Lac de la forêt',22,90,180,360,720),

  (md5('bird_Lesser Flamingo')::uuid,
   'Lesser Flamingo','Petit Flamant',5,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Rive du lac forêt',27,110,220,440,880),

  (md5('bird_Regent Bowerbird')::uuid,
   'Regent Bowerbird','Jardinier prince-régent',4,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Forêt de pins du chêne spirituel',15,60,120,240,480),

  (md5('bird_Redpoll')::uuid,
   'Redpoll','Sizerin flammé',8,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Forêt de pins du chêne spirituel',22,90,180,360,720),

  (md5('bird_Common Kestrel')::uuid,
   'Common Kestrel','Faucon crécerelle',7,
   ARRAY['Soleil','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Tour des cerfs',47,190,380,760,1520),

  (md5('bird_Eagle-Owl')::uuid,
   'Eagle-Owl','Grand-duc d''Europe',10,
   ARRAY['Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Nuit','Matin','Aprem','Soirée']::time_period[],
   'Tour des cerfs',65,260,520,1040,2080),

  (md5('bird_Snowy Owl')::uuid,
   'Snowy Owl','Harfang des neiges',12,
   ARRAY['Soleil','Pluie','Neige','Arc-en-ciel']::weather_type[],
   ARRAY['Matin','Aprem','Soirée']::time_period[],
   'Cime des arbres forêt spirituelle',0,0,0,0,0),

  (md5('bird_Spectacled Owl')::uuid,
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
  (md5('food_Bizarre food')::uuid,       'Bizarre food',      'Nourriture bizarre',1,     30,null,null,null,null,     0,'Brûler n''importe quel aliment'),
  (md5('food_Bizzare drink')::uuid,      'Bizzare drink',     'Boisson bizarre',  1,     30,null,null,null,null,     0,'Brûler n''importe quelle boisson'),
  (md5('food_House Salad')::uuid,        'House Salad',       'Salade maison',    1,     90, 135, 180, 360, 720,    20,'2 Légumes'),
  (md5('food_Mixed Jam')::uuid,          'Mixed Jam',         'Confiture mixte',  1,    160, 240, 320, 640,1280,     0,'4 Fruits'),
  (md5('food_Blueberry Jam')::uuid,      'Blueberry Jam',     'Confiture de myrtilles',1,170, 255, 340, 680,1360,   0,'4 Myrtilles'),
  (md5('food_Tomato Sauce')::uuid,       'Tomato Sauce',      'Sauce tomate',     1,    180, 270, 360, 720,1440,    40,'4 Tomates'),
  (md5('food_Raspberry Jam')::uuid,      'Raspberry Jam',     'Confiture de framboises',1,250,475, 500,1000,2000,    0,'4 Framboises'),
  (md5('food_Apple Jam')::uuid,          'Apple Jam',         'Confiture de pommes',1,  270, 405, 540,1080,2160,    0,'4 Pommes'),
  (md5('food_Mandarin Jam')::uuid,       'Mandarin Jam',      'Confiture de mandarines',1,270,405, 540,1080,2160,   0,'4 Mandarines'),
  (md5('food_Pineapple Jam')::uuid,      'Pineapple Jam',     'Confiture d''ananas',4,  280, 420, 560,1120,2240,    60,'4 Ananas'),
  (md5('food_Strawberry Jam')::uuid,     'Strawberry Jam',    'Confiture de fraises',6, 1580,2370,3160,6320,12640, 500,'4 Fraises'),
  (md5('food_Grape Jam')::uuid,          'Grape Jam',         'Confiture de raisin',7,  2020,3030,4040,8080,16160, 640,'4 Raisins'),
  (md5('food_Chocolate Sauce')::uuid,    'Chocolate Sauce',   'Sauce chocolat',  12,    1400,2100,2800,5600,11200, 440,'4 Cacao'),
  (md5('food_Grilled Mushroom')::uuid,   'Grilled Mushroom',  'Champignon grillé',1,    180, 270, 360, 720,1440,    0,'4 Champignons'),
  (md5('food_Grilled Button Mushroom')::uuid,'Grilled Button Mushroom','Champignon de Paris grillé',1,180,270,360,720,1440,0,'4 Champignons de Paris'),
  (md5('food_Grilled Oyster Mushroom')::uuid,'Grilled Oyster Mushroom','Pleurote grillée',1,180,270,360,720,1440,0,'4 Pleurotes'),
  (md5('food_Grilled Penny Bun')::uuid,  'Grilled Penny Bun', 'Cèpe grillé',      1,    180, 270, 360, 720,1440,    0,'4 Cèpes'),
  (md5('food_Grilled Shiitake Mushroom')::uuid,'Grilled Shiitake Mushroom','Shiitake grillé',1,180,270,360,720,1440,0,'4 Shiitakes'),
  (md5('food_Mushroom Pie')::uuid,       'Mushroom Pie',      'Tarte aux champignons',1, 500, 750,1000,2000,4000,  195,'2 Champignons, 1 Blé, 1 Œuf'),
  (md5('food_Button Mushroom Pie')::uuid,'Button Mushroom Pie','Tarte aux champignons de Paris',1,500,750,1000,2000,4000,195,'2 Champignons de Paris, 1 Blé, 1 Œuf'),
  (md5('food_Oyster Mushroom Pie')::uuid,'Oyster Mushroom Pie','Tarte aux pleurotes',1,  500, 750,1000,2000,4000,  195,'2 Pleurotes, 1 Blé, 1 Œuf'),
  (md5('food_Penny Bun Pie')::uuid,      'Penny Bun Pie',     'Tarte aux cèpes',  1,    500, 750,1000,2000,4000,  195,'2 Cèpes, 1 Blé, 1 Œuf'),
  (md5('food_Shiitake Pie')::uuid,       'Shiitake Pie',      'Tarte aux shiitakes',1,  500, 750,1000,2000,4000,  195,'2 Shiitakes, 1 Blé, 1 Œuf'),
  (md5('food_Apple Pie')::uuid,          'Apple Pie',         'Tarte aux pommes', 5,    730,1095,1460,2920,5840,  345,'1 Pomme, 1 Blé, 1 Œuf, 1 Beurre'),
  (md5('food_Black Truffle Pie')::uuid,  'Black Truffle Pie', 'Tarte à la truffe noire',1,830,1245,1660,3320,6640,195,'2 Truffes noires, 1 Blé, 1 Œuf'),
  (md5('food_Original Roll Cake')::uuid, 'Original Roll Cake','Gâteau roulé original',1, 550, 825,1100,2280,4400, 450,'1 Œuf, 1 Lait, 2 Sucre'),
  (md5('food_Blue Roll Cake')::uuid,     'Blue Roll Cake',    'Gâteau roulé bleu',1,    570, 855,1140,2280,4560,  450,'1 Œuf, 1 Lait, 2 Sucre Bleu'),
  (md5('food_Indigo Roll Cake')::uuid,   'Indigo Roll Cake',  'Gâteau roulé indigo',1,  570, 855,1140,2280,4560,  450,'1 Œuf, 1 Lait, 2 Sucre Indigo'),
  (md5('food_Violet Roll Cake')::uuid,   'Violet Roll Cake',  'Gâteau roulé violet',1,  570, 855,1140,2280,4560,  450,'1 Œuf, 1 Lait, 2 Sucre Violet'),
  (md5('food_Red Roll Cake')::uuid,      'Red Roll Cake',     'Gâteau roulé rouge',1,   670,1005,1340,2680,5360,  450,'1 Œuf, 1 Lait, 2 Sucre Rouge'),
  (md5('food_Yellow Roll Cake')::uuid,   'Yellow Roll Cake',  'Gâteau roulé jaune',1,   670,1005,1340,2680,5360,  450,'1 Œuf, 1 Lait, 2 Sucre Jaune'),
  (md5('food_Orange Roll Cake')::uuid,   'Orange Roll Cake',  'Gâteau roulé orange',1,  670,1005,1340,2680,5360,  550,'1 Œuf, 1 Lait, 2 Sucre Orange'),
  (md5('food_Green Roll Cake')::uuid,    'Green Roll Cake',   'Gâteau roulé vert',1,    670,1005,1340,2680,5360,  550,'1 Œuf, 1 Lait, 2 Sucre Vert'),
  (md5('food_Coffee')::uuid,             'Coffee',            'Café',             2,    290, 435, 580,1160,2320,  200,'4 Grains de café'),
  (md5('food_Coffee Latte')::uuid,       'Coffee Latte',      'Café Latte',       2,    300, 450, 600,1200,2400,  200,'2 Grains de café, 2 Lait'),
  (md5('food_Mellow Black Tea')::uuid,   'Mellow Black Tea',  'Thé noir doux',   11,    840,1260,1680,3360,6720,  500,'2 Feuilles de thé'),
  (md5('food_Fragrant Milk Tea')::uuid,  'Fragrant Milk Tea', 'Thé au lait parfumé',11, 840,1260,1680,3360,6720,  600,'2 Feuilles de thé, 2 Lait'),
  (md5('food_Cocoa Milk Tea')::uuid,     'Cocoa Milk Tea',    'Thé au lait au cacao',11,1120,1680,2240,4480,8960, 660,'2 Feuilles de thé, 1 Lait, 1 Cacao'),
  (md5('food_Refreshing Green Tea')::uuid,'Refreshing Green Tea','Thé vert rafraîchissant',12,500,750,1000,2000,4000,50,'2 Arbres à thé'),
  (md5('food_Milk Tea')::uuid,           'Milk Tea',          'Thé au lait',     12,    500, 750,1000,2000,4000,  150,'2 Arbres à thé, 2 Lait'),
  (md5('food_Matcha Milk Tea')::uuid,    'Matcha Milk Tea',   'Thé au lait au matcha',12,700,1050,1400,2800,5600, 350,'2 Arbres à thé, 1 Lait, 1 Poudre de matcha'),
  (md5('food_Daisy Tea')::uuid,          'Daisy Tea',         'Thé à la pâquerette',12, 600, 900,1200,2400,4800,  110,'2 Arbres à thé, 2 Pâquerettes blanches'),
  (md5('food_Rose Tea')::uuid,           'Rose Tea',          'Thé à la rose',   12,   1930,2895,3860,7720,15440, 650,'2 Arbres à thé, 2 Roses rouges'),
  (md5('food_Cheese Cake')::uuid,        'Cheese Cake',       'Cheesecake',       1,    480, 720, 960,1920,3840,  245,'1 Fromage, 1 Lait, 1 Blé'),
  (md5('food_Tiramisu')::uuid,           'Tiramisu',          'Tiramisu',         6,    530, 795,1060,2120,4240,  350,'1 Grains de café, 1 Œuf, 1 Lait, 1 Beurre'),
  (md5('food_Rustic Ratatouille')::uuid, 'Rustic Ratatouille','Ratatouille rustique',3,  640, 960,1280,2560,5120, 185,'1 Tomate, 1 Pomme de terre, 1 Laitue'),
  (md5('food_Meat Sauce Pasta')::uuid,   'Meat Sauce Pasta',  'Pâtes sauce bolognaise',4,670,1005,1340,2680,5360, 405,'1 Viande, 1 Tomate, 1 Blé, 1 Fromage'),
  (md5('food_Carrot Cake')::uuid,        'Carrot Cake',       'Gâteau à la carotte',5,  840,1260,1680,3360,6720,  295,'1 Œuf, 1 Blé, 2 Carottes'),
  (md5('food_Black Truffle Cream Pasta')::uuid,'Black Truffle Cream Pasta','Pâtes à la crème de truffe noire',3,900,1350,1980,3600,7200,240,'1 Truffe noire, 1 Lait, 2 Blé'),
  (md5('food_Corn Soup')::uuid,          'Corn Soup',         'Soupe de maïs',    5,   1340,2010,2680,5360,10720, 540,'1 Lait, 1 Beurre, 2 Maïs'),
  (md5('food_Meat Burger')::uuid,        'Meat Burger',       'Burger à la viande',8,  1350,2025,2700,5400,10800, 480,'1 Blé, 1 Laitue, 1 Viande, 1 Sauce tomate'),
  (md5('food_Baked Eggplant With Meat')::uuid,'Baked Eggplant With Meat','Aubergine au four à la viande',9,1230,1845,2460,4920,9840,475,'1 Aubergine, 1 Viande, 1 Huile, 1 Sauce tomate'),
  (md5('food_Fish N Chips')::uuid,       'Fish N Chips',      'Fish N Chips',     1,    310, 465, 620,1240,2480,   60,'2 Poissons, 2 Pommes de terre'),
  (md5('food_Deluxe Seafood Platter')::uuid,'Deluxe Seafood Platter','Plateau fruits de mer de luxe',6,410,615,820,1640,3280,0,'2 Coquillages, 2 Poissons'),
  (md5('food_Seafood Risotto')::uuid,    'Seafood Risotto',   'Risotto aux fruits de mer',3,490,735,980,1960,3920,105,'2 Poissons, 1 Blé, 1 Tomate'),
  (md5('food_Smoked Fish Bagel')::uuid,  'Smoked Fish Bagel', 'Bagel au poisson fumé',2, 520, 780,1040,2080,4160, 205,'1 Poisson, 1 Fromage, 1 Blé, 1 Légume'),
  (md5('food_Seafood Pizza')::uuid,      'Seafood Pizza',     'Pizza aux fruits de mer',4,780,1170,1560,3120,6240, 235,'1 Fromage, 1 Sauce tomate, 1 Blé, 1 Poisson'),
  (md5('food_Steamed King Crab')::uuid,  'Steamed King Crab', 'Crabe royal à la vapeur',10,1990,2985,3980,7960,15920,150,'3 Crabes royaux, 1 Beurre'),
  (md5('food_Steamed Golden King Crab')::uuid,'Steamed Golden King Crab','Crabe royal doré à la vapeur',10,2980,4470,5960,11920,23840,150,'3 Crabes royaux dorés, 1 Beurre'),
  (md5('food_Cheese Shrimp Stuffed Crab')::uuid,'Cheese Shrimp Stuffed Crab','Crabe farci fromage crevette',13,1440,2160,2880,5760,11520,0,'2 Crabes royaux, 2 Crevettes'),
  (md5('food_Shrimp Avocado Cup')::uuid, 'Shrimp Avocado Cup','Coupe crevette avocat',13,1560,2340,3120,6240,12480,360,'2 Crevettes, 2 Avocats'),
  (md5('food_Afternoon Tea')::uuid,      'Afternoon Tea',     'Thé de l''après-midi',7,  710,1065,1420,2840,5680, 350,'1 Tiramisu, 1 Fruit ou légume'),
  (md5('food_Picnic Set')::uuid,         'Picnic Set',        'Panier de pique-nique',7, 2260,3390,4520,9040,18080,840,'1 Pizza fruits de mer, 1 Tarte pommes, 1 Fish N Chips, 1 Boisson'),
  (md5('food_Candlelight Dinner')::uuid, 'Candlelight Dinner','Dîner aux chandelles',9,  1760,2640,3520,7040,14080,680,'1 Salade maison, 1 Bagel poisson, 1 Risotto fruits de mer, 1 Tiramisu'),
  (md5('food_Crayfish Sashimi')::uuid,   'Crayfish Sashimi',  'Sashimi d''écrevisse',8,   850,1275,1700,3400,6800,145,'3 Crustacés, 1 Laitue'),
  (md5('food_Blue European Crayfish Sashimi')::uuid,'Blue European Crayfish Sashimi','Sashimi d''écrevisse bleue',8,1310,1965,2620,5240,10480,145,'3 Écrevisses bleues, 1 Laitue'),
  (md5('food_Exquisite Afternoon Tea')::uuid,'Exquisite Afternoon Tea','Thé de l''après-midi exquis',12,2970,4455,5940,11880,23760,1490,'2 Cheesecakes, 2 Thés noirs doux'),
  (md5('food_Milkshake')::uuid,          'Milkshake',         'Milkshake',       11,    400, 600, 800,1600,3200,  100,'2 Fruits, 2 Lait'),
  (md5('food_Strawberry Milkshake')::uuid,'Strawberry Milkshake','Milkshake à la fraise',11,1090,1635,2180,4360,8720,350,'2 Fraises, 2 Lait'),
  (md5('food_Pineapple Milkshake')::uuid,'Pineapple Milkshake','Milkshake à l''ananas',11,440,660,880,1760,3520,  130,'2 Ananas, 2 Lait'),
  (md5('food_Mandarin Milkshake')::uuid, 'Mandarin Milkshake','Milkshake à la mandarine',11,450,675,900,1800,3600,100,'2 Mandarines, 2 Lait'),
  (md5('food_Raspberry Milkshake')::uuid,'Raspberry Milkshake','Milkshake à la framboise',11,440,660,880,1760,3520,100,'2 Framboises, 2 Lait'),
  (md5('food_Blueberry Milkshake')::uuid,'Blueberry Milkshake','Milkshake à la myrtille',11,400,600,800,1600,3200,100,'2 Myrtilles, 2 Lait'),
  (md5('food_Apple Milkshake')::uuid,    'Apple Milkshake',   'Milkshake à la pomme',11,  450, 675, 900,1800,3600, 100,'2 Pommes, 2 Lait'),
  (md5('food_Chocolate Milkshake')::uuid,'Chocolate Milkshake','Milkshake au chocolat',11,1000,1500,2000,4000,8000,320,'2 Cacao, 2 Lait'),
  (md5('food_Grape Milkshake')::uuid,    'Grape Milkshake',   'Milkshake au raisin',11,  1300,1950,2600,5200,10400,420,'2 Raisins, 2 Lait'),
  (md5('food_Matcha Milkshake')::uuid,   'Matcha Milkshake',  'Milkshake au matcha',11,   840,1260,1680,3360,6720, 600,'2 Poudre de matcha, 2 Lait'),
  (md5('food_Onsen Egg')::uuid,          'Onsen Egg',         'Œuf Onsen',        1,    130, 195, 260, 520,1040,  100,'1 Œuf pasteurisé'),
  (md5('food_Grass Cake')::uuid,         'Grass Cake',        'Gâteau à l''herbe',1,    690,1035,1380,2760,5520,  395,'1 Blé, 1 Lait, 1 Poudre de matcha, 1 Mauvaise herbe'),
  (md5('food_Egg_Easter')::uuid,         'Egg_Easter',        'Œuf de Pâques',    1,    190, 285, 380, 760,1520,  150,'1 Œuf, 1 Lait'),
  (md5('food_Orange Egg')::uuid,         'Orange Egg',        'Œuf Orange',       1,    190, 285, 380, 760,1520,  100,'1 Œuf, 1 Pomme'),
  (md5('food_Green Egg')::uuid,          'Green Egg',         'Œuf Vert',         1,    570, 855,1140,2280,4560,  245,'1 Œuf, 1 Laitue'),
  (md5('food_Purple Egg')::uuid,         'Purple Egg',        'Œuf Violet',       1,    620, 930,1240,2480,4960,  260,'1 Œuf, 1 Raisin'),
  (md5('food_Colorful Egg Feast')::uuid, 'Colorful Egg Feast','Festin d''œufs colorés',1,1650,2475,3300,6600,13200,755,'1 Œuf Pâques, 1 Œuf Violet, 1 Œuf Orange, 1 Œuf Vert')

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

-- ── Bizarre food — générique ─────────────────────────────────
  (md5('food_Bizarre food')::uuid,  null,null,null, 1,'Aliment','generic'),
  (md5('food_Bizzare drink')::uuid, null,null,null, 1,'Boisson','generic'),

-- ── House Salad ──────────────────────────────────────────────
  (md5('food_House Salad')::uuid,   null,null,null, 2,'Légume','generic'),

-- ── Mixed Jam ────────────────────────────────────────────────
  (md5('food_Mixed Jam')::uuid,     null,null,null, 4,'Fruit','generic'),

-- ── Blueberry Jam ────────────────────────────────────────────
  (md5('food_Blueberry Jam')::uuid, null,md5('foraged_Blueberry')::uuid,null, 4,'Myrtilles','foraged'),

-- ── Tomato Sauce ─────────────────────────────────────────────
  (md5('food_Tomato Sauce')::uuid,  md5('ingr_Tomato')::uuid,null,null, 4,'Tomates','ingredient'),

-- ── Raspberry Jam ────────────────────────────────────────────
  (md5('food_Raspberry Jam')::uuid, null,md5('foraged_Raspberry')::uuid,null, 4,'Framboises','foraged'),

-- ── Apple Jam ────────────────────────────────────────────────
  (md5('food_Apple Jam')::uuid,     null,md5('foraged_Apple')::uuid,null, 4,'Pommes','foraged'),

-- ── Mandarin Jam ─────────────────────────────────────────────
  (md5('food_Mandarin Jam')::uuid,  null,md5('foraged_Mandarin')::uuid,null, 4,'Mandarines','foraged'),

-- ── Pineapple Jam ────────────────────────────────────────────
  (md5('food_Pineapple Jam')::uuid, md5('ingr_Pineapple')::uuid,null,null, 4,'Ananas','ingredient'),

-- ── Strawberry Jam ───────────────────────────────────────────
  (md5('food_Strawberry Jam')::uuid,md5('ingr_Strawberry')::uuid,null,null, 4,'Fraises','ingredient'),

-- ── Grape Jam ────────────────────────────────────────────────
  (md5('food_Grape Jam')::uuid,     md5('ingr_Grapes')::uuid,null,null, 4,'Raisins','ingredient'),

-- ── Chocolate Sauce ──────────────────────────────────────────
  (md5('food_Chocolate Sauce')::uuid,md5('ingr_Cocoa')::uuid,null,null, 4,'Cacao','ingredient'),

-- ── Grilled Mushroom ─────────────────────────────────────────
  (md5('food_Grilled Mushroom')::uuid,null,null,null, 4,'Champignon','generic'),

-- ── Grilled Button Mushroom ──────────────────────────────────
  (md5('food_Grilled Button Mushroom')::uuid,null,md5('foraged_Button')::uuid,null, 4,'Champignons de Paris','foraged'),

-- ── Grilled Oyster Mushroom ──────────────────────────────────
  (md5('food_Grilled Oyster Mushroom')::uuid,null,md5('foraged_Oyster')::uuid,null, 4,'Pleurotes','foraged'),

-- ── Grilled Penny Bun ────────────────────────────────────────
  (md5('food_Grilled Penny Bun')::uuid,null,md5('foraged_PennyBun')::uuid,null, 4,'Cèpes','foraged'),

-- ── Grilled Shiitake Mushroom ────────────────────────────────
  (md5('food_Grilled Shiitake Mushroom')::uuid,null,md5('foraged_Shiitake')::uuid,null, 4,'Shiitakes','foraged'),

-- ── Mushroom Pie ─────────────────────────────────────────────
  (md5('food_Mushroom Pie')::uuid,  null,null,null, 2,'Champignon','generic'),
  (md5('food_Mushroom Pie')::uuid,  md5('ingr_Wheat')::uuid,null,null, 1,'Blé','ingredient'),
  (md5('food_Mushroom Pie')::uuid,  md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),

-- ── Button Mushroom Pie ──────────────────────────────────────
  (md5('food_Button Mushroom Pie')::uuid,null,md5('foraged_Button')::uuid,null, 2,'Champignons de Paris','foraged'),
  (md5('food_Button Mushroom Pie')::uuid,md5('ingr_Wheat')::uuid,null,null, 1,'Blé','ingredient'),
  (md5('food_Button Mushroom Pie')::uuid,md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),

-- ── Oyster Mushroom Pie ──────────────────────────────────────
  (md5('food_Oyster Mushroom Pie')::uuid,null,md5('foraged_Oyster')::uuid,null, 2,'Pleurotes','foraged'),
  (md5('food_Oyster Mushroom Pie')::uuid,md5('ingr_Wheat')::uuid,null,null, 1,'Blé','ingredient'),
  (md5('food_Oyster Mushroom Pie')::uuid,md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),

-- ── Penny Bun Pie ────────────────────────────────────────────
  (md5('food_Penny Bun Pie')::uuid, null,md5('foraged_PennyBun')::uuid,null, 2,'Cèpes','foraged'),
  (md5('food_Penny Bun Pie')::uuid, md5('ingr_Wheat')::uuid,null,null, 1,'Blé','ingredient'),
  (md5('food_Penny Bun Pie')::uuid, md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),

-- ── Shiitake Pie ─────────────────────────────────────────────
  (md5('food_Shiitake Pie')::uuid,  null,md5('foraged_Shiitake')::uuid,null, 2,'Shiitakes','foraged'),
  (md5('food_Shiitake Pie')::uuid,  md5('ingr_Wheat')::uuid,null,null, 1,'Blé','ingredient'),
  (md5('food_Shiitake Pie')::uuid,  md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),

-- ── Apple Pie ────────────────────────────────────────────────
  (md5('food_Apple Pie')::uuid,     null,md5('foraged_Apple')::uuid,null, 1,'Pomme','foraged'),
  (md5('food_Apple Pie')::uuid,     md5('ingr_Wheat')::uuid,null,null, 1,'Blé','ingredient'),
  (md5('food_Apple Pie')::uuid,     md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),
  (md5('food_Apple Pie')::uuid,     md5('ingr_Butter')::uuid,null,null, 1,'Beurre','ingredient'),

-- ── Black Truffle Pie ────────────────────────────────────────
  (md5('food_Black Truffle Pie')::uuid,null,md5('foraged_BlackTruffle')::uuid,null, 2,'Truffes noires','foraged'),
  (md5('food_Black Truffle Pie')::uuid,md5('ingr_Wheat')::uuid,null,null, 1,'Blé','ingredient'),
  (md5('food_Black Truffle Pie')::uuid,md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),

-- ── Original Roll Cake ───────────────────────────────────────
  (md5('food_Original Roll Cake')::uuid,md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),
  (md5('food_Original Roll Cake')::uuid,md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),
  (md5('food_Original Roll Cake')::uuid,null,null,null, 2,'Sucre','generic'),

-- ── Blue Roll Cake ───────────────────────────────────────────
  (md5('food_Blue Roll Cake')::uuid,md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),
  (md5('food_Blue Roll Cake')::uuid,md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),
  (md5('food_Blue Roll Cake')::uuid,md5('ingr_BlueSugar')::uuid,null,null, 2,'Sucre Bleu','ingredient'),

-- ── Indigo Roll Cake ─────────────────────────────────────────
  (md5('food_Indigo Roll Cake')::uuid,md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),
  (md5('food_Indigo Roll Cake')::uuid,md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),
  (md5('food_Indigo Roll Cake')::uuid,md5('ingr_IndigoSugar')::uuid,null,null, 2,'Sucre Indigo','ingredient'),

-- ── Violet Roll Cake ─────────────────────────────────────────
  (md5('food_Violet Roll Cake')::uuid,md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),
  (md5('food_Violet Roll Cake')::uuid,md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),
  (md5('food_Violet Roll Cake')::uuid,md5('ingr_VioletSugar')::uuid,null,null, 2,'Sucre Violet','ingredient'),

-- ── Red Roll Cake ────────────────────────────────────────────
  (md5('food_Red Roll Cake')::uuid, md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),
  (md5('food_Red Roll Cake')::uuid, md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),
  (md5('food_Red Roll Cake')::uuid, md5('ingr_RedSugar')::uuid,null,null, 2,'Sucre Rouge','ingredient'),

-- ── Yellow Roll Cake ─────────────────────────────────────────
  (md5('food_Yellow Roll Cake')::uuid,md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),
  (md5('food_Yellow Roll Cake')::uuid,md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),
  (md5('food_Yellow Roll Cake')::uuid,md5('ingr_YellowSugar')::uuid,null,null, 2,'Sucre Jaune','ingredient'),

-- ── Orange Roll Cake ─────────────────────────────────────────
  (md5('food_Orange Roll Cake')::uuid,md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),
  (md5('food_Orange Roll Cake')::uuid,md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),
  (md5('food_Orange Roll Cake')::uuid,md5('ingr_OrangeSugar')::uuid,null,null, 2,'Sucre Orange','ingredient'),

-- ── Green Roll Cake ──────────────────────────────────────────
  (md5('food_Green Roll Cake')::uuid,md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),
  (md5('food_Green Roll Cake')::uuid,md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),
  (md5('food_Green Roll Cake')::uuid,md5('ingr_GreenSugar')::uuid,null,null, 2,'Sucre Vert','ingredient'),

-- ── Coffee ───────────────────────────────────────────────────
  (md5('food_Coffee')::uuid,        md5('ingr_CoffeeBeans')::uuid,null,null, 4,'Grains de café','ingredient'),

-- ── Coffee Latte ─────────────────────────────────────────────
  (md5('food_Coffee Latte')::uuid,  md5('ingr_CoffeeBeans')::uuid,null,null, 2,'Grains de café','ingredient'),
  (md5('food_Coffee Latte')::uuid,  md5('ingr_Milk')::uuid,null,null, 2,'Lait','ingredient'),

-- ── Mellow Black Tea ─────────────────────────────────────────
  (md5('food_Mellow Black Tea')::uuid,md5('ingr_TeaLeaves')::uuid,null,null, 2,'Feuilles de thé','ingredient'),

-- ── Fragrant Milk Tea ────────────────────────────────────────
  (md5('food_Fragrant Milk Tea')::uuid,md5('ingr_TeaLeaves')::uuid,null,null, 2,'Feuilles de thé','ingredient'),
  (md5('food_Fragrant Milk Tea')::uuid,md5('ingr_Milk')::uuid,null,null, 2,'Lait','ingredient'),

-- ── Cocoa Milk Tea ───────────────────────────────────────────
  (md5('food_Cocoa Milk Tea')::uuid,md5('ingr_TeaLeaves')::uuid,null,null, 2,'Feuilles de thé','ingredient'),
  (md5('food_Cocoa Milk Tea')::uuid,md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),
  (md5('food_Cocoa Milk Tea')::uuid,md5('ingr_Cocoa')::uuid,null,null, 1,'Cacao','ingredient'),

-- ── Refreshing Green Tea ─────────────────────────────────────
  (md5('food_Refreshing Green Tea')::uuid,md5('ingr_TeaTree')::uuid,null,null, 2,'Arbres à thé','ingredient'),

-- ── Milk Tea ─────────────────────────────────────────────────
  (md5('food_Milk Tea')::uuid,      md5('ingr_TeaTree')::uuid,null,null, 2,'Arbres à thé','ingredient'),
  (md5('food_Milk Tea')::uuid,      md5('ingr_Milk')::uuid,null,null, 2,'Lait','ingredient'),

-- ── Matcha Milk Tea ──────────────────────────────────────────
  (md5('food_Matcha Milk Tea')::uuid,md5('ingr_TeaTree')::uuid,null,null, 2,'Arbres à thé','ingredient'),
  (md5('food_Matcha Milk Tea')::uuid,md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),
  (md5('food_Matcha Milk Tea')::uuid,md5('ingr_MatchaPowder')::uuid,null,null, 1,'Poudre de matcha','ingredient'),

-- ── Daisy Tea ────────────────────────────────────────────────
  (md5('food_Daisy Tea')::uuid,     md5('ingr_TeaTree')::uuid,null,null, 2,'Arbres à thé','ingredient'),
  (md5('food_Daisy Tea')::uuid,     null,md5('foraged_WhiteDaisy')::uuid,null, 2,'Pâquerettes blanches','foraged'),

-- ── Rose Tea ─────────────────────────────────────────────────
  (md5('food_Rose Tea')::uuid,      md5('ingr_TeaTree')::uuid,null,null, 2,'Arbres à thé','ingredient'),
  (md5('food_Rose Tea')::uuid,      null,md5('foraged_RedRose')::uuid,null, 2,'Roses rouges','foraged'),

-- ── Cheese Cake ──────────────────────────────────────────────
  (md5('food_Cheese Cake')::uuid,   md5('ingr_Cheese')::uuid,null,null, 1,'Fromage','ingredient'),
  (md5('food_Cheese Cake')::uuid,   md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),
  (md5('food_Cheese Cake')::uuid,   md5('ingr_Wheat')::uuid,null,null, 1,'Blé','ingredient'),

-- ── Tiramisu ─────────────────────────────────────────────────
  (md5('food_Tiramisu')::uuid,      md5('ingr_CoffeeBeans')::uuid,null,null, 1,'Grains de café','ingredient'),
  (md5('food_Tiramisu')::uuid,      md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),
  (md5('food_Tiramisu')::uuid,      md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),
  (md5('food_Tiramisu')::uuid,      md5('ingr_Butter')::uuid,null,null, 1,'Beurre','ingredient'),

-- ── Rustic Ratatouille ───────────────────────────────────────
  (md5('food_Rustic Ratatouille')::uuid,md5('ingr_Tomato')::uuid,null,null, 1,'Tomate','ingredient'),
  (md5('food_Rustic Ratatouille')::uuid,md5('ingr_Potato')::uuid,null,null, 1,'Pomme de terre','ingredient'),
  (md5('food_Rustic Ratatouille')::uuid,md5('ingr_Lettuce')::uuid,null,null, 1,'Laitue','ingredient'),

-- ── Meat Sauce Pasta ─────────────────────────────────────────
  (md5('food_Meat Sauce Pasta')::uuid,md5('ingr_Meat')::uuid,null,null, 1,'Viande','ingredient'),
  (md5('food_Meat Sauce Pasta')::uuid,md5('ingr_Tomato')::uuid,null,null, 1,'Tomate','ingredient'),
  (md5('food_Meat Sauce Pasta')::uuid,md5('ingr_Wheat')::uuid,null,null, 1,'Blé','ingredient'),
  (md5('food_Meat Sauce Pasta')::uuid,md5('ingr_Cheese')::uuid,null,null, 1,'Fromage','ingredient'),

-- ── Carrot Cake ──────────────────────────────────────────────
  (md5('food_Carrot Cake')::uuid,   md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),
  (md5('food_Carrot Cake')::uuid,   md5('ingr_Wheat')::uuid,null,null, 1,'Blé','ingredient'),
  (md5('food_Carrot Cake')::uuid,   md5('ingr_Carrot')::uuid,null,null, 2,'Carottes','ingredient'),

-- ── Black Truffle Cream Pasta ────────────────────────────────
  (md5('food_Black Truffle Cream Pasta')::uuid,null,md5('foraged_BlackTruffle')::uuid,null, 1,'Truffe noire','foraged'),
  (md5('food_Black Truffle Cream Pasta')::uuid,md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),
  (md5('food_Black Truffle Cream Pasta')::uuid,md5('ingr_Wheat')::uuid,null,null, 2,'Blé','ingredient'),

-- ── Corn Soup ────────────────────────────────────────────────
  (md5('food_Corn Soup')::uuid,     md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),
  (md5('food_Corn Soup')::uuid,     md5('ingr_Butter')::uuid,null,null, 1,'Beurre','ingredient'),
  (md5('food_Corn Soup')::uuid,     md5('ingr_Corn')::uuid,null,null, 2,'Maïs','ingredient'),

-- ── Meat Burger ──────────────────────────────────────────────
  (md5('food_Meat Burger')::uuid,   md5('ingr_Wheat')::uuid,null,null, 1,'Blé','ingredient'),
  (md5('food_Meat Burger')::uuid,   md5('ingr_Lettuce')::uuid,null,null, 1,'Laitue','ingredient'),
  (md5('food_Meat Burger')::uuid,   md5('ingr_Meat')::uuid,null,null, 1,'Viande','ingredient'),
  (md5('food_Meat Burger')::uuid,   null,null,md5('food_Tomato Sauce')::uuid, 1,'Sauce tomate','food'),

-- ── Baked Eggplant With Meat ─────────────────────────────────
  (md5('food_Baked Eggplant With Meat')::uuid,md5('ingr_Eggplant')::uuid,null,null, 1,'Aubergine','ingredient'),
  (md5('food_Baked Eggplant With Meat')::uuid,md5('ingr_Meat')::uuid,null,null, 1,'Viande','ingredient'),
  (md5('food_Baked Eggplant With Meat')::uuid,md5('ingr_CookingOil')::uuid,null,null, 1,'Huile','ingredient'),
  (md5('food_Baked Eggplant With Meat')::uuid,null,null,md5('food_Tomato Sauce')::uuid, 1,'Sauce tomate','food'),

-- ── Fish N Chips ─────────────────────────────────────────────
  (md5('food_Fish N Chips')::uuid,  null,null,null, 2,'Poisson','generic'),
  (md5('food_Fish N Chips')::uuid,  md5('ingr_Potato')::uuid,null,null, 2,'Pommes de terre','ingredient'),

-- ── Deluxe Seafood Platter ───────────────────────────────────
  (md5('food_Deluxe Seafood Platter')::uuid,null,null,null, 2,'Coquillage','generic'),
  (md5('food_Deluxe Seafood Platter')::uuid,null,null,null, 2,'Poisson','generic'),

-- ── Seafood Risotto ──────────────────────────────────────────
  (md5('food_Seafood Risotto')::uuid,null,null,null, 2,'Poisson','generic'),
  (md5('food_Seafood Risotto')::uuid,md5('ingr_Wheat')::uuid,null,null, 1,'Blé','ingredient'),
  (md5('food_Seafood Risotto')::uuid,md5('ingr_Tomato')::uuid,null,null, 1,'Tomate','ingredient'),

-- ── Smoked Fish Bagel ────────────────────────────────────────
  (md5('food_Smoked Fish Bagel')::uuid,null,null,null, 1,'Poisson','generic'),
  (md5('food_Smoked Fish Bagel')::uuid,md5('ingr_Cheese')::uuid,null,null, 1,'Fromage','ingredient'),
  (md5('food_Smoked Fish Bagel')::uuid,md5('ingr_Wheat')::uuid,null,null, 1,'Blé','ingredient'),
  (md5('food_Smoked Fish Bagel')::uuid,null,null,null, 1,'Légume','generic'),

-- ── Seafood Pizza ────────────────────────────────────────────
  (md5('food_Seafood Pizza')::uuid, md5('ingr_Cheese')::uuid,null,null, 1,'Fromage','ingredient'),
  (md5('food_Seafood Pizza')::uuid, null,null,md5('food_Tomato Sauce')::uuid, 1,'Sauce tomate','food'),
  (md5('food_Seafood Pizza')::uuid, md5('ingr_Wheat')::uuid,null,null, 1,'Blé','ingredient'),
  (md5('food_Seafood Pizza')::uuid, null,null,null, 1,'Poisson','generic'),

-- ── Steamed King Crab ────────────────────────────────────────
  (md5('food_Steamed King Crab')::uuid,null,null,null, 3,'Crabe royal','generic'),
  (md5('food_Steamed King Crab')::uuid,md5('ingr_Butter')::uuid,null,null, 1,'Beurre','ingredient'),

-- ── Steamed Golden King Crab ─────────────────────────────────
  (md5('food_Steamed Golden King Crab')::uuid,null,null,null, 3,'Crabe royal doré','generic'),
  (md5('food_Steamed Golden King Crab')::uuid,md5('ingr_Butter')::uuid,null,null, 1,'Beurre','ingredient'),

-- ── Cheese Shrimp Stuffed Crab ───────────────────────────────
  (md5('food_Cheese Shrimp Stuffed Crab')::uuid,null,null,null, 2,'Crabe royal','generic'),
  (md5('food_Cheese Shrimp Stuffed Crab')::uuid,null,null,null, 2,'Crevette','generic'),

-- ── Shrimp Avocado Cup ───────────────────────────────────────
  (md5('food_Shrimp Avocado Cup')::uuid,null,null,null, 2,'Crevette','generic'),
  (md5('food_Shrimp Avocado Cup')::uuid,md5('ingr_Avocado')::uuid,null,null, 2,'Avocats','ingredient'),

-- ── Afternoon Tea ────────────────────────────────────────────
  (md5('food_Afternoon Tea')::uuid, null,null,md5('food_Tiramisu')::uuid, 1,'Tiramisu','food'),
  (md5('food_Afternoon Tea')::uuid, null,null,null, 1,'Fruit ou légume','generic'),

-- ── Picnic Set ───────────────────────────────────────────────
  (md5('food_Picnic Set')::uuid,    null,null,md5('food_Seafood Pizza')::uuid, 1,'Pizza fruits de mer','food'),
  (md5('food_Picnic Set')::uuid,    null,null,md5('food_Apple Pie')::uuid, 1,'Tarte aux pommes','food'),
  (md5('food_Picnic Set')::uuid,    null,null,md5('food_Fish N Chips')::uuid, 1,'Fish N Chips','food'),
  (md5('food_Picnic Set')::uuid,    null,null,null, 1,'Boisson','generic'),

-- ── Candlelight Dinner ───────────────────────────────────────
  (md5('food_Candlelight Dinner')::uuid,null,null,md5('food_House Salad')::uuid, 1,'Salade maison','food'),
  (md5('food_Candlelight Dinner')::uuid,null,null,md5('food_Smoked Fish Bagel')::uuid, 1,'Bagel au poisson fumé','food'),
  (md5('food_Candlelight Dinner')::uuid,null,null,md5('food_Seafood Risotto')::uuid, 1,'Risotto aux fruits de mer','food'),
  (md5('food_Candlelight Dinner')::uuid,null,null,md5('food_Tiramisu')::uuid, 1,'Tiramisu','food'),

-- ── Crayfish Sashimi ─────────────────────────────────────────
  (md5('food_Crayfish Sashimi')::uuid,null,null,null, 3,'Crustacé','generic'),
  (md5('food_Crayfish Sashimi')::uuid,md5('ingr_Lettuce')::uuid,null,null, 1,'Laitue','ingredient'),

-- ── Blue European Crayfish Sashimi ───────────────────────────
  (md5('food_Blue European Crayfish Sashimi')::uuid,null,null,null, 3,'Écrevisse bleue','generic'),
  (md5('food_Blue European Crayfish Sashimi')::uuid,md5('ingr_Lettuce')::uuid,null,null, 1,'Laitue','ingredient'),

-- ── Exquisite Afternoon Tea ──────────────────────────────────
  (md5('food_Exquisite Afternoon Tea')::uuid,null,null,md5('food_Cheese Cake')::uuid, 2,'Cheesecake','food'),
  (md5('food_Exquisite Afternoon Tea')::uuid,null,null,md5('food_Mellow Black Tea')::uuid, 2,'Thé noir doux','food'),

-- ── Milkshake ────────────────────────────────────────────────
  (md5('food_Milkshake')::uuid,     null,null,null, 2,'Fruit','generic'),
  (md5('food_Milkshake')::uuid,     md5('ingr_Milk')::uuid,null,null, 2,'Lait','ingredient'),

-- ── Strawberry Milkshake ─────────────────────────────────────
  (md5('food_Strawberry Milkshake')::uuid,md5('ingr_Strawberry')::uuid,null,null, 2,'Fraises','ingredient'),
  (md5('food_Strawberry Milkshake')::uuid,md5('ingr_Milk')::uuid,null,null, 2,'Lait','ingredient'),

-- ── Pineapple Milkshake ──────────────────────────────────────
  (md5('food_Pineapple Milkshake')::uuid,md5('ingr_Pineapple')::uuid,null,null, 2,'Ananas','ingredient'),
  (md5('food_Pineapple Milkshake')::uuid,md5('ingr_Milk')::uuid,null,null, 2,'Lait','ingredient'),

-- ── Mandarin Milkshake ───────────────────────────────────────
  (md5('food_Mandarin Milkshake')::uuid,null,md5('foraged_Mandarin')::uuid,null, 2,'Mandarines','foraged'),
  (md5('food_Mandarin Milkshake')::uuid,md5('ingr_Milk')::uuid,null,null, 2,'Lait','ingredient'),

-- ── Raspberry Milkshake ──────────────────────────────────────
  (md5('food_Raspberry Milkshake')::uuid,null,md5('foraged_Raspberry')::uuid,null, 2,'Framboises','foraged'),
  (md5('food_Raspberry Milkshake')::uuid,md5('ingr_Milk')::uuid,null,null, 2,'Lait','ingredient'),

-- ── Blueberry Milkshake ──────────────────────────────────────
  (md5('food_Blueberry Milkshake')::uuid,null,md5('foraged_Blueberry')::uuid,null, 2,'Myrtilles','foraged'),
  (md5('food_Blueberry Milkshake')::uuid,md5('ingr_Milk')::uuid,null,null, 2,'Lait','ingredient'),

-- ── Apple Milkshake ──────────────────────────────────────────
  (md5('food_Apple Milkshake')::uuid,null,md5('foraged_Apple')::uuid,null, 2,'Pommes','foraged'),
  (md5('food_Apple Milkshake')::uuid,md5('ingr_Milk')::uuid,null,null, 2,'Lait','ingredient'),

-- ── Chocolate Milkshake ──────────────────────────────────────
  (md5('food_Chocolate Milkshake')::uuid,md5('ingr_Cocoa')::uuid,null,null, 2,'Cacao','ingredient'),
  (md5('food_Chocolate Milkshake')::uuid,md5('ingr_Milk')::uuid,null,null, 2,'Lait','ingredient'),

-- ── Grape Milkshake ──────────────────────────────────────────
  (md5('food_Grape Milkshake')::uuid,md5('ingr_Grapes')::uuid,null,null, 2,'Raisins','ingredient'),
  (md5('food_Grape Milkshake')::uuid,md5('ingr_Milk')::uuid,null,null, 2,'Lait','ingredient'),

-- ── Matcha Milkshake ─────────────────────────────────────────
  (md5('food_Matcha Milkshake')::uuid,md5('ingr_MatchaPowder')::uuid,null,null, 2,'Poudre de matcha','ingredient'),
  (md5('food_Matcha Milkshake')::uuid,md5('ingr_Milk')::uuid,null,null, 2,'Lait','ingredient'),

-- ── Onsen Egg ────────────────────────────────────────────────
  (md5('food_Onsen Egg')::uuid,     md5('ingr_PasturizedEgg')::uuid,null,null, 1,'Œuf pasteurisé','ingredient'),

-- ── Grass Cake ───────────────────────────────────────────────
  (md5('food_Grass Cake')::uuid,    md5('ingr_Wheat')::uuid,null,null, 1,'Blé','ingredient'),
  (md5('food_Grass Cake')::uuid,    md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),
  (md5('food_Grass Cake')::uuid,    md5('ingr_MatchaPowder')::uuid,null,null, 1,'Poudre de matcha','ingredient'),
  (md5('food_Grass Cake')::uuid,    null,md5('foraged_Weed')::uuid,null, 1,'Mauvaise herbe','foraged'),

-- ── Egg de Pâques ────────────────────────────────────────────
  (md5('food_Egg_Easter')::uuid,    md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),
  (md5('food_Egg_Easter')::uuid,    md5('ingr_Milk')::uuid,null,null, 1,'Lait','ingredient'),

-- ── Orange Egg ───────────────────────────────────────────────
  (md5('food_Orange Egg')::uuid,    md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),
  (md5('food_Orange Egg')::uuid,    null,md5('foraged_Apple')::uuid,null, 1,'Pomme','foraged'),

-- ── Green Egg ────────────────────────────────────────────────
  (md5('food_Green Egg')::uuid,     md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),
  (md5('food_Green Egg')::uuid,     md5('ingr_Lettuce')::uuid,null,null, 1,'Laitue','ingredient'),

-- ── Purple Egg ───────────────────────────────────────────────
  (md5('food_Purple Egg')::uuid,    md5('ingr_Egg')::uuid,null,null, 1,'Œuf','ingredient'),
  (md5('food_Purple Egg')::uuid,    md5('ingr_Grapes')::uuid,null,null, 1,'Raisin','ingredient'),

-- ── Colorful Egg Feast ───────────────────────────────────────
  (md5('food_Colorful Egg Feast')::uuid,null,null,md5('food_Egg_Easter')::uuid, 1,'Œuf de Pâques','food'),
  (md5('food_Colorful Egg Feast')::uuid,null,null,md5('food_Purple Egg')::uuid, 1,'Œuf Violet','food'),
  (md5('food_Colorful Egg Feast')::uuid,null,null,md5('food_Orange Egg')::uuid, 1,'Œuf Orange','food'),
  (md5('food_Colorful Egg Feast')::uuid,null,null,md5('food_Green Egg')::uuid, 1,'Œuf Vert','food')

on conflict do nothing;


-- ============================================================
-- FIN DU SEED
-- ============================================================

