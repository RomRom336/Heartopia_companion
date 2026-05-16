-- ============================================================
-- Heartopia Companion — Traduction FR des lieux
-- fish : tous les poissons
-- insect / bird : animaux d'événement uniquement
-- ============================================================

-- ── Poissons (tous) ───────────────────────────────────────────
UPDATE public.fish
SET exact_location = CASE exact_location
  WHEN 'East Sea'             THEN 'Mer de l''Est'
  WHEN 'Old Sea'              THEN 'Ancienne mer'
  WHEN 'Whale Sea'            THEN 'Mer de la baleine'
  WHEN 'Zephyr Sea'           THEN 'Mer calme'
  WHEN 'Ocean'                THEN 'Océan'
  WHEN 'Sea Fishing'          THEN 'Événement pêche en mer'
  WHEN 'Forest Lake'          THEN 'Lac de la forêt'
  WHEN 'Meadow Lake'          THEN 'Lac dans la prairie'
  WHEN 'Suburban Lake'        THEN 'Lac de banlieue'
  WHEN 'Onsen Mountain Lake'  THEN 'Lac de montagne thermale'
  WHEN 'Lake'                 THEN 'Lac'
  WHEN 'Giantwood River'      THEN 'Fleuve d''arbres géants'
  WHEN 'Tranquil River'       THEN 'Rivière calme'
  WHEN 'Shallow River'        THEN 'Rivière peu profonde'
  WHEN 'Rosy River'           THEN 'Rivière aurore'
  WHEN 'River'                THEN 'Rivière'
  WHEN 'Deer Tower'           THEN 'Tour aux cerfs'
  WHEN 'Forest Island'        THEN 'Île forestière'
  WHEN 'Forest Jump Puzzle'   THEN 'Puzzle de saut forestier'
  WHEN 'Spirit-Oak Pine Forest' THEN 'Forêt de pins Spirit Oak'
  WHEN 'Amethyst Beach'       THEN 'Plage Améthyste'
  WHEN 'Whale Mountain'       THEN 'Montagne Baleine'
  WHEN 'Windmill Flower Field' THEN 'Champ de fleurs du moulin'
  ELSE exact_location
END
WHERE exact_location IN (
  'East Sea', 'Old Sea', 'Whale Sea', 'Zephyr Sea', 'Ocean', 'Sea Fishing',
  'Forest Lake', 'Meadow Lake', 'Suburban Lake', 'Onsen Mountain Lake', 'Lake',
  'Giantwood River', 'Tranquil River', 'Shallow River', 'Rosy River', 'River',
  'Deer Tower', 'Forest Island', 'Forest Jump Puzzle', 'Spirit-Oak Pine Forest',
  'Amethyst Beach', 'Whale Mountain', 'Windmill Flower Field'
);

-- ── Insectes d'événement ──────────────────────────────────────
UPDATE public.insect
SET exact_location = CASE exact_location
  WHEN 'Deer Tower'           THEN 'Tour aux cerfs'
  WHEN 'Forest Island'        THEN 'Île forestière'
  WHEN 'Forest Jump Puzzle'   THEN 'Puzzle de saut forestier'
  WHEN 'Spirit-Oak Pine Forest' THEN 'Forêt de pins Spirit Oak'
  WHEN 'Amethyst Beach'       THEN 'Plage Améthyste'
  WHEN 'Whale Mountain'       THEN 'Montagne Baleine'
  WHEN 'Windmill Flower Field' THEN 'Champ de fleurs du moulin'
  ELSE exact_location
END
WHERE event_name IS NOT NULL
  AND exact_location IN (
    'Deer Tower', 'Forest Island', 'Forest Jump Puzzle', 'Spirit-Oak Pine Forest',
    'Amethyst Beach', 'Whale Mountain', 'Windmill Flower Field'
  );

-- ── Oiseaux d'événement ───────────────────────────────────────
UPDATE public.bird
SET exact_location = CASE exact_location
  WHEN 'Deer Tower'           THEN 'Tour aux cerfs'
  WHEN 'Forest Island'        THEN 'Île forestière'
  WHEN 'Forest Jump Puzzle'   THEN 'Puzzle de saut forestier'
  WHEN 'Spirit-Oak Pine Forest' THEN 'Forêt de pins Spirit Oak'
  WHEN 'Amethyst Beach'       THEN 'Plage Améthyste'
  WHEN 'Whale Mountain'       THEN 'Montagne Baleine'
  WHEN 'Windmill Flower Field' THEN 'Champ de fleurs du moulin'
  ELSE exact_location
END
WHERE event_name IS NOT NULL
  AND exact_location IN (
    'Deer Tower', 'Forest Island', 'Forest Jump Puzzle', 'Spirit-Oak Pine Forest',
    'Amethyst Beach', 'Whale Mountain', 'Windmill Flower Field'
  );
