-- ============================================================
-- Heartopia Companion — Traduction FR des noms d'événement
-- fish, insect, bird
-- ============================================================

UPDATE public.fish
SET event_name = CASE event_name
  WHEN 'Frostspore Fish'           THEN 'Poissons Frostspore'
  WHEN 'Octo Entertainment'        THEN 'Octo Entertainment'
  WHEN 'Special Brick Fish Event'  THEN 'Évènement Spécial Poissons de Briques'
  ELSE event_name
END
WHERE event_name IN (
  'Frostspore Fish', 'Octo Entertainment', 'Special Brick Fish Event'
);

UPDATE public.insect
SET event_name = CASE event_name
  WHEN 'Frostspore Butterfly'         THEN 'Papillons Frostspore'
  WHEN 'Script Supervisor Bee'        THEN 'Bourdon Scripté'
  WHEN 'Special Brick Insect Event'   THEN 'Évènement Spécial Insectes de Briques'
  ELSE event_name
END
WHERE event_name IN (
  'Frostspore Butterfly', 'Script Supervisor Bee', 'Special Brick Insect Event'
);

UPDATE public.bird
SET event_name = CASE event_name
  WHEN 'Actor Dove'          THEN 'Pigeon Acteur'
  WHEN 'Winter Birdwatching' THEN 'Observation des oiseaux d''hiver'
  ELSE event_name
END
WHERE event_name IN (
  'Actor Dove', 'Winter Birdwatching'
);
