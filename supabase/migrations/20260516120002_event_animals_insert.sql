-- ============================================================
-- Heartopia Companion — INSERT des animaux d'événement
-- 15 poissons · 15 insectes · 14 oiseaux
-- ============================================================


-- ── Poissons ─────────────────────────────────────────────────
insert into public.fish
  (name, name_en, passion_level, weather, "time", shadow_size, location_type, exact_location, event_name,
   sell_price_1_star, sell_price_2_star, sell_price_3_star, sell_price_4_star, sell_price_5_star)
values
  ('Poisson-clown de blocs bleu',                 'Blue Brick Clownfish',                    1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', '{"Petit"}', 'Mer', 'East Sea',                   'Special Brick Fish Event', 100, 150, 200,  400,  800),
  ('Poisson-clown de blocs coloré',               'Colorful Brick Clownfish',                1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', '{"Petit"}', 'Mer', 'Special Brick Fish Event',   'Special Brick Fish Event', 150, 225, 300,  600, 1200),
  ('Poisson-clown de blocs vert',                 'Green Brick Clownfish',                   1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', '{"Petit"}', 'Mer', 'East Sea',                   'Special Brick Fish Event', 100, 150, 200,  400,  800),
  ('Poisson-clown de blocs violet',               'Purple Brick Clownfish',                  1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', '{"Petit"}', 'Mer', 'East Sea',                   'Special Brick Fish Event', 100, 150, 200,  400,  800),
  ('Poisson-clown de blocs rouge',                'Red Brick Clownfish',                     1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', '{"Petit"}', 'Mer', 'East Sea',                   'Special Brick Fish Event', 100, 150, 200,  400,  800),
  ('Pieuvre réalisatrice au chapeau cannelle',     'Director Common Octopus w Cinnamon Hat',  1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', '{"Grand"}', 'Mer', 'Whale Sea',                  'Octo Entertainment',       215, 322, 430,  860, 1720),
  ('Pieuvre réalisatrice au chapeau à motifs',    'Director Common Octopus w Patterned Hat', 1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', '{"Grand"}', 'Mer', 'Octo Entertainment',         'Octo Entertainment',       320, 480, 640, 1280, 2560),
  ('Pieuvre naine réalisatrice au chapeau marron', 'Director Pygmy Octopus w Brown Hat',      1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', '{"Petit"}', 'Mer', 'Whale Sea',                  'Octo Entertainment',       100, 150, 200,  400,  800),
  ('Pieuvre naine réalisatrice au chapeau cyan',   'Director Pygmy Octopus w Cyan Hat',       1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', '{"Petit"}', 'Mer', 'Whale Sea',                  'Octo Entertainment',       100, 150, 200,  400,  800),
  ('Pieuvre naine réalisatrice au chapeau marine', 'Director Pygmy Octopus w Navy Hat',       1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', '{"Petit"}', 'Mer', 'Whale Sea',                  'Octo Entertainment',       100, 150, 200,  400,  800),
  ('Hippocampe cristallin',                        'Frostspore Seahorse',                     1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', '{"Petit"}', 'Mer', 'Old Sea',                    'Frostspore Fish',          100, 150, 200,  400,  800),
  ('Crabe royal cristallin',                       'Frostspore King Crab',                    1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', '{"Grand"}', 'Mer', 'Old Sea',                    'Frostspore Fish',          215, 322, 430,  860, 1720),
  ('Poisson-lune cristallin',                      'Frostspore Ocean Sunfish',                1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', '{"Grand"}', 'Mer', 'Old Sea',                    'Frostspore Fish',          215, 322, 430,  860, 1720),
  ('Poisson-globe cristallin',                     'Frostspore Puffer Fish',                  1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', '{"Moyen"}', 'Mer', 'Old Sea',                    'Frostspore Fish',          155, 232, 310,  620, 1240),
  ('Requin baleine cristallin',                    'Frostspore Whale Shark',                  1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', '{"Grand"}', 'Mer', 'Frostspore Fish',             'Frostspore Fish',          320, 480, 640, 1280, 2560)
;


-- ── Insectes ─────────────────────────────────────────────────
insert into public.insect
  (name, name_en, passion_level, weather, "time", exact_location, event_name,
   sell_price_1_star, sell_price_2_star, sell_price_3_star, sell_price_4_star, sell_price_5_star)
values
  ('Grand agrion de blocs bleu',                     'Blue Brick Large Red Damselfly',          1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Deer Tower',              'Special Brick Insect Event',  75, 112, 150, 300,  600),
  ('Grand agrion de blocs coloré',                   'Colorful Brick Large Red Damselfly',      1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Special Brick Insect Event', 'Special Brick Insect Event', 110, 165, 220, 440,  880),
  ('Grand agrion de blocs rose',                     'Pink Brick Large Red Damselfly',          1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Forest Jump Puzzle',      'Special Brick Insect Event',  75, 112, 150, 300,  600),
  ('Grand agrion de blocs violet',                   'Purple Brick Large Red Damselfly',        1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Forest Island',           'Special Brick Insect Event',  75, 112, 150, 300,  600),
  ('Grand agrion de blocs jaune',                    'Yellow Brick Large Red Damselfly',        1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Spirit-Oak Pine Forest',  'Special Brick Insect Event',  75, 112, 150, 300,  600),
  ('Bourdon scripté doré',                           'Golden Script Supervisor Bumblebee',      1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Script Supervisor Bee',   'Script Supervisor Bee',      165, 247, 330, 660, 1320),
  ('Bourdon scripté vert',                           'Green Script Supervisor Bumblebee',       1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Amethyst Beach',          'Script Supervisor Bee',      110, 165, 220, 440,  880),
  ('Bourdon scripté rose',                           'Pink Script Supervisor Bumblebee',        1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Windmill Flower Field',   'Script Supervisor Bee',      110, 165, 220, 440,  880),
  ('Bourdon scripté violet',                         'Purple Script Supervisor Bumblebee',      1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Windmill Flower Field',   'Script Supervisor Bee',      110, 165, 220, 440,  880),
  ('Bourdon scripté rouge',                          'Red Script Supervisor Bumblebee',         1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Whale Mountain',          'Script Supervisor Bee',      110, 165, 220, 440,  880),
  ('Papillon hypolimnas cristallin',                 'Frostspore Mother-of-Pearl',              1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Spirit-Oak Pine Forest',  'Frostspore Butterfly',        60,  90, 120, 240,  480),
  ('Papillon facteur cristallin',                    'Frostspore Postman Butterfly',            1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Frostspore Butterfly',    'Frostspore Butterfly',        90, 135, 180, 360,  720),
  ('Papillon à taches violettes cristallin',        'Frostspore Purple Spotted Swallowtail',   1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Spirit-Oak Pine Forest',  'Frostspore Butterfly',        60,  90, 120, 240,  480),
  ('Papillon de la reine Alexandra cristallin',      'Frostspore Queen Alexandra''s Birdwing',  1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Deer Tower',              'Frostspore Butterfly',        60,  90, 120, 240,  480),
  ('Morpho de Sulkowsky cristallin',                 'Frostspore Sulkowsky''s Morpho',          1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Spirit-Oak Pine Forest',  'Frostspore Butterfly',        60,  90, 120, 240,  480)
;


-- ── Oiseaux ──────────────────────────────────────────────────
insert into public.bird
  (name, name_en, passion_level, weather, "time", exact_location, event_name,
   sell_price_1_star, sell_price_2_star, sell_price_3_star, sell_price_4_star, sell_price_5_star)
values
  ('Pigeon acteur bleu',          'Blue Suit Dove',           1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Spirit-Oak Pine Forest', 'Actor Dove',          15,  60, 120, 240,  480),
  ('Pigeon acteur gris',          'Gray Suit Dove',           1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Deer Tower',             'Actor Dove',          15,  60, 120, 240,  480),
  ('Pigeon acteur vert',          'Green Suit Dove',          1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Forest Jump Puzzle',     'Actor Dove',          15,  60, 120, 240,  480),
  ('Pigeon acteur rouge',         'Red Suit Dove',            1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Forest Island',          'Actor Dove',          15,  60, 120, 240,  480),
  ('Pigeon acteur rayé',          'Striped Suit Dove',        1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Actor Dove',             'Actor Dove',          17,  70, 140, 280,  560),
  ('Canard siffleur d''hiver',    'Winter Eurasian Wigeon',   1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Suburban Lake',          'Winter Birdwatching', 17,  70, 140, 280,  560),
  ('Flamant rose d''hiver',       'Winter Greater Flamingo',  1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Suburban Lake',          'Winter Birdwatching', 20,  80, 160, 320,  640),
  ('Canard colvert d''hiver',     'Winter Mallard',           1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Suburban Lake',          'Winter Birdwatching', 17,  70, 140, 280,  560),
  ('Canard mandarin d''hiver',    'Winter Mandarin Duck',     1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Winter Birdwatching',    'Winter Birdwatching', 22,  90, 180, 360,  720),
  ('Harle piette d''hiver',       'Winter Smew',              1, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Suburban Lake',          'Winter Birdwatching', 17,  70, 140, 280,  560),
  ('Goéland d''Audouin',          'Audouin''s Gull',          3, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Whale Sea',              null,                  17,  70, 140, 280,  560),
  ('Cormoran impérial',           'Imperial Shag',            9, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'East Sea',               null,                  45, 180, 360, 720, 1440),
  ('Cormoran à face rouge',      'Red Faced Cormorant',      6, '{"Arc-en-ciel","Soleil","Pluie"}', '{"Matin","Aprem","Soirée","Nuit"}', 'Old Sea',                null,                  22,  90, 180, 360,  720),
  ('Sterne',                      'Tern',                     7, '{"Arc-en-ciel"}',                 '{"Matin","Aprem","Soirée","Nuit"}', 'Seaside',                null,                  35, 140, 280, 560, 1120)
;
