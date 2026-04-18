-- ============================================================
-- Heartopia Companion — Migration 02 : Ressources de base
-- foraged_item, ingredient + crop_detail + store_item_detail
-- (héritage par sous-tables pour éviter les colonnes NULL massives)
-- ============================================================

-- ------------------------------------------------------------
-- Objets glanés dans la nature : champignons, fruits, bois, minéraux…
-- ------------------------------------------------------------
create table public.foraged_item (
  id          uuid primary key default gen_random_uuid(),
  category    foraged_category not null,
  name        text not null unique,
  sell_price  int check (sell_price >= 0),
  created_at  timestamptz not null default now()
);

comment on table public.foraged_item is
  'Ressources ramassées dans la nature, utilisables directement ou comme ingrédients de recette.';

create index foraged_item_category_idx on public.foraged_item (category);


-- ------------------------------------------------------------
-- Table mère ingredient : identité minimale commune à toutes les sources.
-- Le détail vit dans crop_detail ou store_item_detail selon source_type.
-- ------------------------------------------------------------
create table public.ingredient (
  id          uuid primary key default gen_random_uuid(),
  name        text not null unique,
  source_type ingredient_source not null,
  created_at  timestamptz not null default now()
);

comment on table public.ingredient is
  'Table mère des ingrédients. Un ingrédient doit avoir une entrée dans crop_detail OU store_item_detail selon son source_type.';

create index ingredient_source_idx on public.ingredient (source_type);


-- ------------------------------------------------------------
-- Détail des ingrédients cultivés (source_type = Crop)
-- Clé primaire = ingredient_id pour garantir la relation 1-1.
-- ON DELETE CASCADE : supprimer l'ingrédient supprime son détail.
-- ------------------------------------------------------------
create table public.crop_detail (
  ingredient_id      uuid primary key references public.ingredient(id) on delete cascade,
  passion_level      int not null check (passion_level >= 0),
  growth_time        interval,                              -- ex: '3 days', '12:00:00'
  seed_cost          int check (seed_cost >= 0),
  sell_price_1_star  int check (sell_price_1_star >= 0),
  sell_price_2_star  int check (sell_price_2_star >= 0),
  sell_price_3_star  int check (sell_price_3_star >= 0),
  sell_price_4_star  int check (sell_price_4_star >= 0),
  sell_price_5_star  int check (sell_price_5_star >= 0)
);

comment on table public.crop_detail is
  'Détail des ingrédients de type culture (Crop) : coût des graines, temps de pousse, prix de revente par niveau d''étoiles.';


-- ------------------------------------------------------------
-- Détail des ingrédients achetés en boutique (Massimo ou Doris)
-- discounted_price : utilisable seulement pour Massimo (soldes hebdo),
-- laissé NULL pour Doris.
-- ------------------------------------------------------------
create table public.store_item_detail (
  ingredient_id     uuid primary key references public.ingredient(id) on delete cascade,
  store_name        store_brand not null,
  base_price        int not null check (base_price >= 0),
  discounted_price  int check (discounted_price >= 0),
  -- garde-fou : un prix soldé ne peut excéder le prix de base
  constraint store_item_discount_not_above_base
    check (discounted_price is null or discounted_price <= base_price)
);

comment on table public.store_item_detail is
  'Détail des ingrédients achetés en boutique. discounted_price n''est renseigné que pour Massimo.';

create index store_item_store_idx on public.store_item_detail (store_name);
