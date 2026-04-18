-- ============================================================
-- Heartopia Companion — Migration 04 : Faune (Fish, Insect, Bird)
-- Les conditions météo et horaires sont multi-valuées
-- → tableaux d'ENUM natifs PostgreSQL + index GIN pour les filtres.
-- ============================================================

-- ------------------------------------------------------------
-- Poissons
-- ------------------------------------------------------------
create table public.fish (
  id                 uuid primary key default gen_random_uuid(),
  name               text not null unique,
  location_type      fish_location not null,
  passion_level      int  not null default 1 check (passion_level >= 0),
  weather            weather_type[] not null default '{}',
  "time"             time_period[]  not null default '{}',
  shadow_size        shadow_size[]  not null default '{}',
  exact_location     text,
  sell_price_1_star  int check (sell_price_1_star >= 0),
  sell_price_2_star  int check (sell_price_2_star >= 0),
  sell_price_3_star  int check (sell_price_3_star >= 0),
  sell_price_4_star  int check (sell_price_4_star >= 0),
  sell_price_5_star  int check (sell_price_5_star >= 0),
  created_at         timestamptz not null default now()
);

comment on table public.fish is
  'Poissons pêchables. Les colonnes weather/time/shadow_size sont des tableaux (conditions multiples).';

create index fish_location_idx       on public.fish (location_type);
create index fish_passion_idx        on public.fish (passion_level);
create index fish_weather_gin_idx    on public.fish using gin (weather);
create index fish_time_gin_idx       on public.fish using gin ("time");
create index fish_shadow_gin_idx     on public.fish using gin (shadow_size);


-- ------------------------------------------------------------
-- Insectes (pas d'ombre : chasse au filet à vue)
-- ------------------------------------------------------------
create table public.insect (
  id                 uuid primary key default gen_random_uuid(),
  name               text not null unique,
  passion_level      int  not null default 1 check (passion_level >= 0),
  weather            weather_type[] not null default '{}',
  "time"             time_period[]  not null default '{}',
  exact_location     text,
  sell_price_1_star  int check (sell_price_1_star >= 0),
  sell_price_2_star  int check (sell_price_2_star >= 0),
  sell_price_3_star  int check (sell_price_3_star >= 0),
  sell_price_4_star  int check (sell_price_4_star >= 0),
  sell_price_5_star  int check (sell_price_5_star >= 0),
  created_at         timestamptz not null default now()
);

comment on table public.insect is
  'Insectes à attraper au filet.';

create index insect_passion_idx     on public.insect (passion_level);
create index insect_weather_gin_idx on public.insect using gin (weather);
create index insect_time_gin_idx    on public.insect using gin ("time");


-- ------------------------------------------------------------
-- Oiseaux (photographiés, pas capturés)
--   perfect_photo_distance : distance idéale à respecter
--   stretch_time           : durée pendant laquelle l'oiseau reste en pose
-- ------------------------------------------------------------
create table public.bird (
  id                      uuid primary key default gen_random_uuid(),
  name                    text not null unique,
  passion_level           int  not null default 1 check (passion_level >= 0),
  weather                 weather_type[] not null default '{}',
  "time"                  time_period[]  not null default '{}',
  perfect_photo_distance  text,
  stretch_time            text,
  exact_location          text,
  sell_price_1_star       int check (sell_price_1_star >= 0),
  sell_price_2_star       int check (sell_price_2_star >= 0),
  sell_price_3_star       int check (sell_price_3_star >= 0),
  sell_price_4_star       int check (sell_price_4_star >= 0),
  sell_price_5_star       int check (sell_price_5_star >= 0),
  created_at              timestamptz not null default now()
);

comment on table public.bird is
  'Oiseaux à photographier. Pas de capture physique → prix = valeur du cliché.';

create index bird_passion_idx     on public.bird (passion_level);
create index bird_weather_gin_idx on public.bird using gin (weather);
create index bird_time_gin_idx    on public.bird using gin ("time");
