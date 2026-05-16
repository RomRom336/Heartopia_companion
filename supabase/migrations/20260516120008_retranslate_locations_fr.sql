-- ============================================================
-- Heartopia Companion — Correction des traductions de lieux FR
-- ============================================================

UPDATE public.fish
SET exact_location = CASE exact_location
  WHEN 'Vieille Mer'              THEN 'Ancienne mer'
  WHEN 'Mer des Baleines'         THEN 'Mer de la baleine'
  WHEN 'Mer de vent doux'         THEN 'Mer calme'
  WHEN 'Fête de pêche en mer'     THEN 'Événement pêche en mer'
  WHEN 'Lac forestier'            THEN 'Lac de la forêt'
  WHEN 'Lac des Prairies'         THEN 'Lac dans la prairie'
  WHEN 'Lac des sources chaudes'  THEN 'Lac de montagne thermale'
  WHEN 'Rivière aux arbres géants' THEN 'Fleuve d''arbres géants'
  WHEN 'Rivière tranquille'       THEN 'Rivière calme'
  WHEN 'Rivière Xiaguang'         THEN 'Rivière aurore'
  ELSE exact_location
END
WHERE exact_location IN (
  'Vieille Mer', 'Mer des Baleines', 'Mer de vent doux', 'Fête de pêche en mer',
  'Lac forestier', 'Lac des Prairies', 'Lac des sources chaudes',
  'Rivière aux arbres géants', 'Rivière tranquille', 'Rivière Xiaguang'
);
