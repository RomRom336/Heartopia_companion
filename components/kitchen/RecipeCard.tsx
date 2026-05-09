'use client'

import { useState } from 'react'
import { Coins, TrendingUp, TrendingDown } from 'lucide-react'
import { Badge } from '@/components/ui/badge'
import { cn } from '@/lib/utils'
import type { FoodProfitabilityRow } from '@/types/database.types'
import type { TrackedIngredient } from '@/app/cuisine/page'

const STAR_KEYS = [
  'sell_price_1_star',
  'sell_price_2_star',
  'sell_price_3_star',
  'sell_price_4_star',
  'sell_price_5_star',
] as const

const PROFIT_KEYS = [
  'net_profit_1_star',
  'net_profit_2_star',
  'net_profit_3_star',
  'net_profit_4_star',
  'net_profit_5_star',
] as const

export function RecipeCard({
  food,
  maxServings,
  tracked,
  onCook,
}: {
  food: FoodProfitabilityRow
  maxServings?: number | null
  tracked?: TrackedIngredient[]
  onCook?: () => void
}) {
  const [selectedStar, setSelectedStar] = useState<1 | 2 | 3 | 4 | 5>(1)

  const sellPrice = food[STAR_KEYS[selectedStar - 1]] ?? 0
  const netProfit = food[PROFIT_KEYS[selectedStar - 1]] ?? 0
  const isPositive = netProfit >= 0

  return (
    <article className="flex flex-col gap-3 rounded-xl border border-border bg-card p-4 shadow-sm transition-shadow hover:shadow-md">

      {/* En-tête : nom + niveau + prix/profit de l'étoile sélectionnée */}
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0">
          <h3 className="truncate font-semibold leading-tight">{food.food_name}</h3>
          <p className="text-xs text-muted-foreground">
            Niveau cuisine requis : {food.passion_level_required}
          </p>
        </div>

        <div className="flex shrink-0 flex-col items-end gap-1">
          <span className="text-lg font-bold tabular-nums leading-none">
            {sellPrice} G
          </span>
          <span
            className={cn(
              'flex items-center gap-0.5 text-sm font-semibold tabular-nums',
              isPositive ? 'text-emerald-500' : 'text-destructive',
            )}
          >
            {isPositive ? (
              <TrendingUp className="h-3.5 w-3.5" />
            ) : (
              <TrendingDown className="h-3.5 w-3.5" />
            )}
            {isPositive ? '+' : ''}{netProfit} 💰
          </span>
        </div>
      </div>

      {/* Recette (texte brut depuis DB) */}
      <p className="text-xs text-muted-foreground">
        <span className="font-medium text-foreground">Recette : </span>
        {food.recipe_text}
      </p>

      {/* Ingrédients en mode quantité */}
      {tracked && tracked.length > 0 && (
        <div className="flex flex-wrap gap-1.5">
          {tracked.map((ing, i) => (
            <span
              key={i}
              className="inline-flex items-center gap-1 rounded-full bg-blue-500/10 border border-blue-500/25 px-2.5 py-0.5 text-xs font-medium text-blue-700 dark:text-blue-300"
            >
              {ing.name}
              <span className="font-semibold tabular-nums text-blue-600 dark:text-blue-400">
                ({ing.available})
              </span>
            </span>
          ))}
        </div>
      )}

      {/* Sélecteur d'étoile + tableau des profits */}
      <div className="rounded-md bg-muted/60 p-2">
        <div className="mb-2 flex items-center justify-between text-xs">
          <span className="flex items-center gap-1 text-muted-foreground">
            <Coins className="h-3 w-3" />
            Coût : {food.total_cost} G
          </span>
          <div className="flex gap-0.5" aria-label="Sélectionner une qualité d'étoile">
            {([1, 2, 3, 4, 5] as const).map(n => (
              <button
                key={n}
                type="button"
                onClick={() => setSelectedStar(n)}
                aria-pressed={selectedStar === n}
                className={cn(
                  'rounded px-1.5 py-0.5 text-[11px] font-semibold transition-colors',
                  selectedStar === n
                    ? 'bg-accent text-accent-foreground'
                    : 'text-muted-foreground hover:bg-muted',
                )}
              >
                {n}★
              </button>
            ))}
          </div>
        </div>

        {/* Grille 5 étoiles */}
        <div className="grid grid-cols-5 gap-1 text-center text-xs">
          {([1, 2, 3, 4, 5] as const).map(star => {
            const profit = food[PROFIT_KEYS[star - 1]] ?? 0
            const isSelected = star === selectedStar
            const pos = profit >= 0
            return (
              <button
                key={star}
                type="button"
                onClick={() => setSelectedStar(star)}
                className={cn(
                  'rounded-sm py-1 transition-colors',
                  isSelected ? 'bg-accent/20 ring-1 ring-accent/50' : 'bg-background/60 hover:bg-muted',
                )}
              >
                <p className="text-[10px] text-muted-foreground">{star}★</p>
                <p
                  className={cn(
                    'font-semibold tabular-nums',
                    pos
                      ? isSelected ? 'text-emerald-500' : 'text-foreground'
                      : 'text-destructive',
                  )}
                >
                  {pos ? '+' : ''}{profit}
                </p>
              </button>
            )
          })}
        </div>
      </div>

      <div className="flex flex-wrap items-center gap-1.5">
        <Badge variant="outline" className="gap-1">
          <Coins className="h-3 w-3" />
          {food.total_cost} G coût
        </Badge>
        {maxServings != null && (
          <Badge variant="secondary">
            {maxServings}× réalisable
          </Badge>
        )}
        {maxServings != null && maxServings > 0 && (
          <Badge variant="accent">
            <TrendingUp className="h-3 w-3 mr-1" />
            Total : +{(food.net_profit_1_star ?? 0) * maxServings} G
          </Badge>
        )}
        {onCook && (
          <button
            type="button"
            onClick={onCook}
            className="ml-auto rounded-full bg-emerald-500 px-4 py-1.5 text-sm font-semibold text-white shadow-sm transition-colors hover:bg-emerald-600 active:bg-emerald-700"
          >
            J&apos;ai cuisiné !
          </button>
        )}
      </div>
    </article>
  )
}
