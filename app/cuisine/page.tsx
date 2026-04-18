'use client'

import { useEffect, useMemo, useRef, useState } from 'react'
import { Check, ChefHat, Infinity as InfinityIcon, Loader2, Package } from 'lucide-react'
import { InventoryList } from '@/components/kitchen/InventoryList'
import { RecipeCard } from '@/components/kitchen/RecipeCard'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Switch } from '@/components/ui/switch'
import { useKitchenStore } from '@/store/useKitchenStore'
import { useAuth } from '@/components/auth-provider'
import { createClient } from '@/utils/supabase/client'
import type { FoodProfitabilityRow, IngredientWithCost } from '@/types/database.types'

type RecipeIngredientRow = {
  food_id: string
  ingredient_id: string | null
  quantity: number
}

export type RealizableFood = {
  food: FoodProfitabilityRow
  maxServings: number | null
}

export default function CuisinePage() {
  const { user } = useAuth()
  const supabase = useMemo(() => createClient(), [])

  const inventory           = useKitchenStore(s => s.inventory)
  const cookingLevel        = useKitchenStore(s => s.cookingLevel)
  const setCookingLevel     = useKitchenStore(s => s.setCookingLevel)
  const useInventoryMode    = useKitchenStore(s => s.useInventoryMode)
  const setUseInventoryMode = useKitchenStore(s => s.setUseInventoryMode)

  const [foods, setFoods]                         = useState<FoodProfitabilityRow[]>([])
  const [ingredients, setIngredients]             = useState<IngredientWithCost[]>([])
  const [recipeIngredients, setRecipeIngredients] = useState<RecipeIngredientRow[]>([])
  const [loading, setLoading]                     = useState(true)
  const [saving, setSaving]                       = useState(false)
  const [saved, setSaved]                         = useState(false)

  const hydratedRef = useRef(false)

  // 1. Hydratation cooking_passion depuis DB
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
      if (!error && data?.cooking_passion != null) {
        setCookingLevel(data.cooking_passion)
      }
      hydratedRef.current = true
    })()
    return () => { cancelled = true }
  }, [user, supabase, setCookingLevel])

  // 2. Sauvegarde manuelle du niveau de cuisine
  const handleSaveCookingLevel = async () => {
    if (!user) return
    setSaving(true)
    const { error } = await supabase
      .from('profiles')
      .upsert({ id: user.id, cooking_passion: cookingLevel }, { onConflict: 'id' })
    if (error) {
      console.error('[Cuisine] UPSERT error:', error)
      setSaving(false)
      return
    }
    setSaving(false)
    setSaved(true)
    setTimeout(() => setSaved(false), 2000)
  }

  // 3. Fetch plats + ingrédients + recettes
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
          .select('food_id, ingredient_id, quantity'),
      ])
      if (cancelled) return

      if (foodRes.error) console.error('Food fetch error:', foodRes.error)
      if (ingrRes.error) console.error('Ingredient fetch error:', ingrRes.error)
      if (riRes.error)   console.error('RecipeIngredient fetch error:', riRes.error)

      setFoods((foodRes.data ?? []) as FoodProfitabilityRow[])
      setRecipeIngredients((riRes.data ?? []) as RecipeIngredientRow[])
      setIngredients(
        (ingrRes.data ?? []).map((row: {
          ingredient_id: string
          ingredient_name: string
          source_type: string
          unit_cost: number
        }) => ({
          id: row.ingredient_id,
          name_en: '',
          name: row.ingredient_name,
          source_type: row.source_type as IngredientWithCost['source_type'],
          unit_cost: row.unit_cost,
        })),
      )
      setLoading(false)
    })()
    return () => { cancelled = true }
  }, [supabase])

  // Index recipe_ingredient par food_id
  const riByFood = useMemo(() => {
    const map = new Map<string, RecipeIngredientRow[]>()
    for (const ri of recipeIngredients) {
      const arr = map.get(ri.food_id) ?? []
      arr.push(ri)
      map.set(ri.food_id, arr)
    }
    return map
  }, [recipeIngredients])

  const realizable = useMemo<RealizableFood[]>(() => {
    const byLevel = foods.filter(f => f.passion_level_required <= cookingLevel)

    if (!useInventoryMode) {
      return byLevel.map(food => ({ food, maxServings: null } satisfies RealizableFood))
    }

    const result: RealizableFood[] = []
    for (const food of byLevel) {
      const rows = riByFood.get(food.food_id) ?? []
      const trackable = rows.filter(ri => ri.ingredient_id != null)

      // Recette 100% générique → exclue en mode inventaire
      if (trackable.length === 0) continue

      let maxServings = Infinity
      for (const ri of trackable) {
        const have = inventory[ri.ingredient_id!] ?? 0
        maxServings = Math.min(maxServings, Math.floor(have / ri.quantity))
      }
      const servings = maxServings === Infinity ? 0 : maxServings
      if (servings >= 1) result.push({ food, maxServings: servings })
    }

    return result.sort((a, b) => {
      const aProfit = (a.food.net_profit_1_star ?? 0) * (a.maxServings ?? 0)
      const bProfit = (b.food.net_profit_1_star ?? 0) * (b.maxServings ?? 0)
      return bProfit - aProfit
    })
  }, [foods, cookingLevel, useInventoryMode, riByFood, inventory])

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

      <div className="mb-6 flex flex-col gap-3 rounded-lg border border-border bg-card p-4 sm:flex-row sm:items-center sm:justify-between">
        <div className="flex items-center gap-3">
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
              {saving ? <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" /> : saved ? <Check className="mr-1.5 h-3.5 w-3.5" /> : null}
              {saved ? 'Sauvegardé' : 'Sauvegarder'}
            </Button>
          )}
        </div>

        <div className="flex items-center gap-3">
          <Label
            htmlFor="inventory-mode"
            className="flex cursor-pointer items-center gap-2 text-sm"
          >
            {useInventoryMode ? (
              <Package className="h-4 w-4 text-accent" />
            ) : (
              <InfinityIcon className="h-4 w-4 text-primary" />
            )}
            {useInventoryMode ? 'Mon inventaire' : 'Ressources infinies'}
          </Label>
          <Switch
            id="inventory-mode"
            checked={useInventoryMode}
            onCheckedChange={setUseInventoryMode}
            aria-label="Utiliser mon inventaire"
          />
        </div>
      </div>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Mon Frigo */}
        <section className={useInventoryMode ? '' : 'opacity-60'}>
          <h2 className="mb-3 text-lg font-semibold">Mon Frigo</h2>
          {!useInventoryMode && (
            <p className="mb-3 rounded-md border border-dashed border-border bg-muted/30 p-3 text-xs text-muted-foreground">
              Mode ressources infinies : l'inventaire est ignoré pour le calcul des recettes.
            </p>
          )}
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
              ({realizable.length} recette{realizable.length > 1 ? 's' : ''})
            </span>
          </h2>

          {loading ? (
            <p className="text-sm text-muted-foreground">Chargement…</p>
          ) : realizable.length > 0 ? (
            <div className="space-y-3">
              {realizable.map(({ food, maxServings }) => (
                <RecipeCard key={food.food_id} food={food} maxServings={maxServings} />
              ))}
            </div>
          ) : (
            <p className="rounded-md border border-dashed border-border bg-muted/30 p-6 text-center text-sm text-muted-foreground">
              {useInventoryMode
                ? 'Aucune recette réalisable avec votre inventaire actuel.'
                : 'Aucune recette accessible à votre niveau de cuisine actuel.'}
            </p>
          )}
        </section>
      </div>
    </main>
  )
}
