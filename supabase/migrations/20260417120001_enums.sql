-- ============================================================
-- Heartopia Companion — Migration 01 : ENUMs globaux
-- Tous les types énumérés fixes du domaine.
-- ============================================================

-- Conditions météo observables dans le jeu
create type public.weather_type as enum (
  'Soleil',
  'Pluie',
  'Neige',
  'Arc-en-ciel'
);

-- Créneaux horaires du jeu
--   Nuit   : 01h00 - 07h00
--   Matin  : 07h00 - 13h00
--   Aprem  : 13h00 - 19h00
--   Soirée : 19h00 - 01h00
create type public.time_period as enum (
  'Nuit',
  'Matin',
  'Aprem',
  'Soirée'
);

-- Catégories de ressources glanées (foraged)
create type public.foraged_category as enum (
  'Champignon',
  'Fruit',
  'Bois',
  'Minéral',
  'Autre'
);

-- Provenance d'un ingrédient : culture perso ou boutiques PNJ
create type public.ingredient_source as enum (
  'Crop',
  'Massimo_Store',
  'Doris_Store'
);

-- Marque de la boutique (sous-ensemble utile de ingredient_source)
create type public.store_brand as enum (
  'Massimo',
  'Doris'
);

-- Zone de pêche
create type public.fish_location as enum (
  'Mer',
  'Lac',
  'Rivière'
);

-- Tailles / types d'ombre observables sur un poisson
create type public.shadow_size as enum (
  'Petit',
  'Moyen',
  'Grand',
  'Doré',
  'Bleu'
);
