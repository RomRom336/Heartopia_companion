'use client'

import { useEffect, useMemo, useRef, useState } from 'react'
import { Check, ChefHat, Loader2 } from 'lucide-react'
import { InventoryList } from '@/components/kitchen/InventoryList'
import { RecipeCard } from '@/components/kitchen/RecipeCard'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { useKitchenStore } from '@/store/useKitchenStore'
import { useAuth } from '@/components/auth-provider'
import { createClient } from '@/utils/supabase/client'
import type { FoodProfitabilityRow, IngredientWithCost } from '@/types/database.types'

type RecipeIngredientRow = {
  food_id:          string
  ingredient_id:    string | null
  foraged_id:       string | null
  sub_food_id:      string | null
  quantity:         number
  ingredient_type:  string | null
  ingredient_label: string | null
}

type WildcardCat = 'Champignon' | 'Fruit' | 'Legume' | 'Sugar'

type CollectedReq = {
  specific:  Map<string, number>
  wildcards: Array<{ category: WildcardCat; qty: number }>
}

// ingredient_label → catégorie wildcard
const GENERIC_WILDCARD_MAP: Record<string, WildcardCat> = {
  'Tout type de champignons': 'Champignon',
  'Champignons':              'Champignon',
  'Toute type de fruits':     'Fruit',
  'Toute type de légumes':    'Legume',
  'Fruits':                   'Fruit',
  'fruit':                    'Fruit',
  "Sucre de n'importe quelle couleur": 'Sugar',
  'Légumes':                  'Legume',
}

// Noms FR des cultures qui comptent comme fruits dans le wildcard Fruit
const CROP_FRUIT_NAMES = new Set(['Fraise', 'Ananas', 'Raisin'])

// Résout récursivement tous les besoins d'un plat :
//   - specific : Map<ingredientId, qty>
//   - wildcards : catégories génériques (champignon, fruit, légume, sucre)
// Si un sub_food est en mode 'quantity' ou 'none', il est traité comme
// un ingrédient spécifique (pas de récursion).
function collectIngredients(
  food_id:  string,
  riByFood: Map<string, RecipeIngredientRow[]>,
  itemModes: Record<string, string>,
  depth = 0,
): CollectedReq {
  if (depth > 6) return { specific: new Map(), wildcards: [] }

  const specific  = new Map<string, number>()
  const wildcards: Array<{ category: WildcardCat; qty: number }> = []

  for (const ri of riByFood.get(food_id) ?? []) {
    const id = ri.ingredient_id ?? ri.foraged_id
    if (id != null) {
      specific.set(id, (specific.get(id) ?? 0) + ri.quantity)
    } else if (ri.sub_food_id != null) {
      const mode = itemModes[ri.sub_food_id] ?? 'infinite'
      if (mode !== 'infinite') {
        // Le plat préparé est suivi dans l'inventaire → traité comme item spécifique
        specific.set(ri.sub_food_id, (specific.get(ri.sub_food_id) ?? 0) + ri.quantity)
      } else {
        // Mode infini → on descend dans ses propres ingrédients
        const sub = collectIngredients(ri.sub_food_id, riByFood, itemModes, depth + 1)
        for (const [subId, subQty] of sub.specific)
          specific.set(subId, (specific.get(subId) ?? 0) + subQty * ri.quantity)
        for (const wc of sub.wildcards)
          wildcards.push({ ...wc, qty: wc.qty * ri.quantity })
      }
    } else if (ri.ingredient_type === 'generic' && ri.ingredient_label) {
      const cat = GENERIC_WILDCARD_MAP[ri.ingredient_label]
      if (cat) wildcards.push({ category: cat, qty: ri.quantity })
    }
  }
  return { specific, wildcards }
}

// Quantité disponible pour un wildcard (null = infini).
// Si au moins 1 item de la catégorie est en mode 'infinite' → infini.
// Sinon → somme des inventaires des items en mode 'quantity'.
function computeWildcardAvailable(
  category:    WildcardCat,
  ingredients: IngredientWithCost[],
  itemModes:   Record<string, string>,
  inventory:   Record<string, number>,
): number | null {
  let catItems: IngredientWithCost[]
  switch (category) {
    case 'Champignon':
      catItems = ingredients.filter(i => i.source_type === 'Champignon')
      break
    case 'Fruit':
      catItems = ingredients.filter(i =>
        i.source_type === 'Fruit' ||
        (i.source_type === 'Crop' && CROP_FRUIT_NAMES.has(i.name))
      )
      break
    case 'Legume':
      catItems = ingredients.filter(i =>
        i.source_type === 'Crop' && !CROP_FRUIT_NAMES.has(i.name)
      )
      break
    case 'Sugar':
      catItems = ingredients.filter(i => i.source_type === 'Doris_Store')
      break
  }
  if (catItems.length === 0) return null
  for (const item of catItems) {
    if ((itemModes[item.id] ?? 'infinite') === 'infinite') return null
  }
  return catItems.reduce((sum, item) => {
    if ((itemModes[item.id] ?? 'infinite') === 'quantity')
      return sum + (inventory[item.id] ?? 0)
    return sum  // 'none' → 0
  }, 0)
}

export type TrackedIngredient = {
  name: string
  required: number
  available: number
}

export type RealizableFood = {
  food: FoodProfitabilityRow
  maxServings: number | null   // null = all ingredients are infinite (no limit)
  tracked: TrackedIngredient[] // ingredients in 'quantity' mode
}

export default function CuisinePage() {
  const { user } = useAuth()
  const supabase = useMemo(() => createClient(), [])

  const itemModes      = useKitchenStore(s => s.itemModes)
  const inventory      = useKitchenStore(s => s.inventory)
  const cookingLevel   = useKitchenStore(s => s.cookingLevel)
  const setCookingLevel= useKitchenStore(s => s.setCookingLevel)
  const consumeRecipe  = useKitchenStore(s => s.consumeRecipe)

  const [foods, setFoods]                         = useState<FoodProfitabilityRow[]>([])
  const [ingredients, setIngredients]             = useState<IngredientWithCost[]>([])
  const [recipeIngredients, setRecipeIngredients] = useState<RecipeIngredientRow[]>([])
  const [loading, setLoading]                     = useState(true)
  const [saving, setSaving]                       = useState(false)
  const [saved, setSaved]                         = useState(false)

  const hydratedRef = useRef(false)

  // Hydratation cooking_passion depuis le profil
  useEffect(() => {
    if (!user) return
    let cancelled = false
    ;(async () => {
      const { data, error } = await supabase
        .from('profiles')
        .select('cooking_passion')
        .eq('id', user.id)
        .maybeSingle()
      if (cancelled) return
      if (!error && data?.cooking_passion != null) setCookingLevel(data.cooking_passion)
      hydratedRef.current = true
    })()
    return () => { cancelled = true }
  }, [user, supabase, setCookingLevel])

  const handleSaveCookingLevel = async () => {
    if (!user) return
    setSaving(true)
    const { error } = await supabase
      .from('profiles')
      .upsert({ id: user.id, cooking_passion: cookingLevel }, { onConflict: 'id' })
    if (error) { console.error('[Cuisine] UPSERT error:', error); setSaving(false); return }
    setSaving(false)
    setSaved(true)
    setTimeout(() => setSaved(false), 2000)
  }

  // Fetch plats + ingrédients + table de liaison
  useEffect(() => {
    let cancelled = false
    setLoading(true)
    ;(async () => {
      const [foodRes, ingrRes, riRes] = await Promise.all([
        supabase
          .from('food_profitability_view')
          .select('*')
          .order('net_profit_1_star', { ascending: false, nullsFirst: false }),
        supabase
          .from('ingredient_unit_cost_view')
          .select('ingredient_id, ingredient_name, source_type, unit_cost')
          .order('ingredient_name', { ascending: true }),
        supabase
          .from('recipe_ingredient')
          .select('food_id, ingredient_id, foraged_id, sub_food_id, quantity, ingredient_type, ingredient_label'),
      ])
      if (cancelled) return
      if (foodRes.error) console.error('Food fetch error:', foodRes.error)
      if (ingrRes.error) console.error('Ingredient fetch error:', ingrRes.error)
      if (riRes.error)   console.error('RecipeIngredient fetch error:', riRes.error)

      setFoods((foodRes.data ?? []) as FoodProfitabilityRow[])
      setRecipeIngredients((riRes.data ?? []) as RecipeIngredientRow[])
      setIngredients(
        (ingrRes.data ?? []).map((row: {
          ingredient_id: string; ingredient_name: string
          source_type: string; unit_cost: number
        }) => ({
          id:          row.ingredient_id,
          name_en:     '',
          name:        row.ingredient_name,
          source_type: row.source_type as IngredientWithCost['source_type'],
          unit_cost:   row.unit_cost,
        })),
      )
      setLoading(false)
    })()
    return () => { cancelled = true }
  }, [supabase])

  // Map food_id → ingrédients de la recette
  const riByFood = useMemo(() => {
    const map = new Map<string, RecipeIngredientRow[]>()
    for (const ri of recipeIngredients) {
      const arr = map.get(ri.food_id) ?? []
      arr.push(ri)
      map.set(ri.food_id, arr)
    }
    return map
  }, [recipeIngredients])

  // Pour chaque plat accessible, calcule le nombre max de portions
  // en tenant compte du mode par ingrédient.
  // Retourne null  = tous les ingrédients sont en mode infini (pas de limite).
  // Retourne 0     = bloqué (mode 'none' ou stock insuffisant).
  // Retourne n > 0 = n portions réalisables.
  const WILDCARD_LABELS: Record<WildcardCat, string> = {
    Champignon: 'Champignons',
    Fruit:      'Fruits',
    Legume:     'Légumes',
    Sugar:      'Sucre',
  }

  const ingredientById = useMemo(
    () => new Map(ingredients.map(i => [i.id, i])),
    [ingredients],
  )

  const realizable = useMemo<RealizableFood[]>(() => {
    const byLevel = foods.filter(f => f.passion_level_required <= cookingLevel)

    return byLevel
      .map(food => {
        const req = collectIngredients(food.food_id, riByFood, itemModes)

        let hasTracked = false
        let maxServings = Infinity
        const tracked: TrackedIngredient[] = []

        // Ingrédients spécifiques
        for (const [id, qty] of req.specific) {
          const mode = itemModes[id] ?? 'infinite'
          if (mode === 'none') return { food, maxServings: 0, tracked: [] }
          if (mode === 'quantity') {
            hasTracked = true
            const have = inventory[id] ?? 0
            maxServings = Math.min(maxServings, Math.floor(have / qty))
            tracked.push({ name: ingredientById.get(id)?.name ?? id, required: qty, available: have })
          }
        }

        // Ingrédients wildcards (champignons / fruits / légumes / sucres)
        for (const { category, qty } of req.wildcards) {
          const available = computeWildcardAvailable(category, ingredients, itemModes, inventory)
          if (available === null) continue  // infini → pas de limite
          hasTracked = true
          if (available < qty) return { food, maxServings: 0, tracked: [] }
          maxServings = Math.min(maxServings, Math.floor(available / qty))
          tracked.push({ name: WILDCARD_LABELS[category], required: qty, available })
        }

        if (!hasTracked) return { food, maxServings: null, tracked: [] }
        return { food, maxServings: maxServings === Infinity ? 0 : maxServings, tracked }
      })
      // Affiche uniquement les plats réalisables (infini ou ≥1 portion)
      .filter(r => r.maxServings === null || r.maxServings > 0)
  }, [foods, cookingLevel, itemModes, inventory, riByFood, ingredients, ingredientById])

  const handleCook = (food_id: string) => {
    const req = collectIngredients(food_id, riByFood, itemModes)
    consumeRecipe(
      Array.from(req.specific.entries()).map(([id, qty]) => ({ id, qty }))
    )
    // Les wildcards (champignons/fruits génériques) ne sont pas déduits automatiquement
  }

  // ── Pagination progressive (infinite scroll) ──────────────────
  const RECIPE_PAGE = 12
  const [visibleRecipes, setVisibleRecipes] = useState(RECIPE_PAGE)
  const recipeSentinelRef = useRef<HTMLDivElement>(null)

  useEffect(() => { setVisibleRecipes(RECIPE_PAGE) }, [realizable])

  useEffect(() => {
    const el = recipeSentinelRef.current
    if (!el) return
    const obs = new IntersectionObserver(
      ([entry]) => { if (entry.isIntersecting) setVisibleRecipes(c => c + RECIPE_PAGE) },
      { rootMargin: '400px' },
    )
    obs.observe(el)
    return () => obs.disconnect()
  }, [realizable.length])

  return (
    <main className="container py-8">
      <header className="mb-6 flex flex-col gap-2">
        <h1 className="flex items-center gap-2 text-3xl font-bold tracking-tight">
          <ChefHat className="h-7 w-7 text-primary" />
          Cuisine
        </h1>
        <p className="text-sm text-muted-foreground">
          Gérez votre inventaire et découvrez les recettes les plus rentables du moment.
        </p>
      </header>

      {/* Niveau de cuisine */}
      <div className="mb-6 flex flex-wrap items-center gap-3 rounded-lg border border-border bg-card p-4">
        <Label htmlFor="cooking-level" className="whitespace-nowrap">
          Niveau de cuisine
        </Label>
        <Input
          id="cooking-level"
          type="number"
          min={1}
          max={100}
          value={cookingLevel}
          onChange={e => setCookingLevel(Number(e.target.value) || 1)}
          className="w-24"
        />
        {user && (
          <Button size="sm" variant="outline" onClick={handleSaveCookingLevel} disabled={saving}>
            {saving ? <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" />
              : saved ? <Check className="mr-1.5 h-3.5 w-3.5" /> : null}
            {saved ? 'Sauvegardé' : 'Sauvegarder'}
          </Button>
        )}
      </div>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Mon Frigo */}
        <section>
          <h2 className="mb-3 text-lg font-semibold">Mon Frigo</h2>
          {loading ? (
            <p className="text-sm text-muted-foreground">Chargement…</p>
          ) : (
            <InventoryList ingredients={ingredients} />
          )}
        </section>

        {/* Que cuisiner ? */}
        <section>
          <h2 className="mb-3 text-lg font-semibold">
            Que cuisiner ?{' '}
            <span className="text-sm font-normal text-muted-foreground">
              ({realizable.length} recette{realizable.length !== 1 ? 's' : ''})
            </span>
          </h2>
          {loading ? (
            <p className="text-sm text-muted-foreground">Chargement…</p>
          ) : realizable.length > 0 ? (
            <>
              <div className="space-y-3">
                {realizable.slice(0, visibleRecipes).map(({ food, maxServings, tracked }) => (
                  <RecipeCard
                    key={food.food_id}
                    food={food}
                    maxServings={maxServings}
                    tracked={tracked}
                    onCook={() => handleCook(food.food_id)}
                  />
                ))}
              </div>
              <div ref={recipeSentinelRef} className="h-2" />
              {visibleRecipes < realizable.length && (
                <div className="flex justify-center py-4">
                  <Loader2 className="h-5 w-5 animate-spin text-muted-foreground" />
                </div>
              )}
            </>
          ) : (
            <p className="rounded-md border border-dashed border-border bg-muted/30 p-6 text-center text-sm text-muted-foreground">
              Aucune recette accessible à votre niveau de cuisine actuel.
            </p>
          )}
        </section>
      </div>
    </main>
  )
}
