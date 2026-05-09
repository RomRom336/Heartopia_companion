// ============================================================
// Heartopia Companion — Types TypeScript alignés sur le schéma DB
// ============================================================

// ── Enums (valeurs PostgreSQL) ───────────────────────────────
export type WeatherType = 'Soleil' | 'Pluie' | 'Neige' | 'Arc-en-ciel'
export type TimePeriod  = 'Nuit' | 'Matin' | 'Aprem' | 'Soirée'
export type ItemType    = 'Poisson' | 'Insecte' | 'Oiseau'
export type FishLocation = 'Mer' | 'Lac' | 'Rivière'
export type ShadowSize  = 'Petit' | 'Moyen' | 'Grand' | 'Doré' | 'Bleu' | 'Or'
export type IngredientSource =
  | 'Crop' | 'Massimo_Store' | 'Doris_Store'
  | 'Champignon' | 'Fruit' | 'Aquatique' | 'Autre'
  | 'SubFood'

// ── Tables de faune (DB rows) ────────────────────────────────
export interface DbFish {
  id: string
  name_en: string
  name: string
  passion_level: number
  weather: WeatherType[]
  time: TimePeriod[]
  location_type: FishLocation
  exact_location: string | null
  shadow_size: ShadowSize[]
  sell_price_1_star: number
  sell_price_2_star: number
  sell_price_3_star: number
  sell_price_4_star: number
  sell_price_5_star: number
  special_condition: string | null
  created_at: string
}

export interface DbInsect {
  id: string
  name_en: string
  name: string
  passion_level: number
  weather: WeatherType[]
  time: TimePeriod[]
  exact_location: string | null
  sell_price_1_star: number
  sell_price_2_star: number
  sell_price_3_star: number
  sell_price_4_star: number
  sell_price_5_star: number
  created_at: string
}

export interface DbBird {
  id: string
  name_en: string
  name: string
  passion_level: number
  weather: WeatherType[]
  time: TimePeriod[]
  exact_location: string | null
  sell_price_1_star: number
  sell_price_2_star: number
  sell_price_3_star: number
  sell_price_4_star: number
  sell_price_5_star: number
  created_at: string
}

// ── TrackerItem — type unifié utilisé par TrackerView/ItemCard ──
export interface TrackerItem {
  id: string
  name_en: string
  name: string
  type: ItemType
  passion_level: number
  weather: WeatherType[]
  time: TimePeriod[]
  exact_location: string
  sell_price_1_star: number
  sell_price_2_star: number
  sell_price_3_star: number
  sell_price_4_star: number
  sell_price_5_star: number
  // Poisson uniquement
  location_type?: FishLocation
  shadow_size?: ShadowSize[]
  special_condition?: string | null
}

// ── Adapteurs DB → TrackerItem ────────────────────────────────
export function fishToTrackerItem(f: DbFish): TrackerItem {
  return {
    id: f.id,
    name_en: f.name_en,
    name: f.name,
    type: 'Poisson',
    passion_level: f.passion_level,
    weather: f.weather,
    time: f.time,
    exact_location: f.exact_location ?? '',
    sell_price_1_star: f.sell_price_1_star,
    sell_price_2_star: f.sell_price_2_star,
    sell_price_3_star: f.sell_price_3_star,
    sell_price_4_star: f.sell_price_4_star,
    sell_price_5_star: f.sell_price_5_star,
    location_type: f.location_type,
    shadow_size: f.shadow_size,
    special_condition: f.special_condition,
  }
}

export function insectToTrackerItem(i: DbInsect): TrackerItem {
  return {
    id: i.id,
    name_en: i.name_en,
    name: i.name,
    type: 'Insecte',
    passion_level: i.passion_level,
    weather: i.weather,
    time: i.time,
    exact_location: i.exact_location ?? '',
    sell_price_1_star: i.sell_price_1_star,
    sell_price_2_star: i.sell_price_2_star,
    sell_price_3_star: i.sell_price_3_star,
    sell_price_4_star: i.sell_price_4_star,
    sell_price_5_star: i.sell_price_5_star,
  }
}

export function birdToTrackerItem(b: DbBird): TrackerItem {
  return {
    id: b.id,
    name_en: b.name_en,
    name: b.name,
    type: 'Oiseau',
    passion_level: b.passion_level,
    weather: b.weather,
    time: b.time,
    exact_location: b.exact_location ?? '',
    sell_price_1_star: b.sell_price_1_star,
    sell_price_2_star: b.sell_price_2_star,
    sell_price_3_star: b.sell_price_3_star,
    sell_price_4_star: b.sell_price_4_star,
    sell_price_5_star: b.sell_price_5_star,
  }
}

// ── Cuisine ──────────────────────────────────────────────────
export interface IngredientWithCost {
  id: string
  name_en: string
  name: string
  source_type: IngredientSource
  unit_cost: number
}

export interface FoodProfitabilityRow {
  food_id: string
  food_name: string
  name_en: string
  passion_level_required: number
  total_cost: number
  recipe_text: string
  sell_price_1_star: number | null
  sell_price_2_star: number | null
  sell_price_3_star: number | null
  sell_price_4_star: number | null
  sell_price_5_star: number | null
  net_profit_1_star: number | null
  net_profit_2_star: number | null
  net_profit_3_star: number | null
  net_profit_4_star: number | null
  net_profit_5_star: number | null
}

// ── Collection ───────────────────────────────────────────────
export interface UserCollectionRow {
  user_id: string
  item_type: ItemType
  item_id: string
  best_star: number | null
  caught_at: string
}
