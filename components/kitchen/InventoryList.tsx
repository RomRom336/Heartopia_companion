'use client'

import { Minus, Plus, X } from 'lucide-react'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import type { IngredientWithCost } from '@/types/database.types'
import { useKitchenStore } from '@/store/useKitchenStore'

export function InventoryList({
  ingredients,
  mode = 'quantity',
}: {
  ingredients: IngredientWithCost[]
  mode?: 'quantity' | 'toggle'
}) {
  const inventory  = useKitchenStore(s => s.inventory)
  const increment  = useKitchenStore(s => s.increment)
  const decrement  = useKitchenStore(s => s.decrement)
  const setQuantity = useKitchenStore(s => s.setQuantity)

  const CATEGORY_ORDER: IngredientWithCost['source_type'][] = ['Crop', 'Massimo_Store', 'Doris_Store']
  const CATEGORY_LABEL: Record<IngredientWithCost['source_type'], string> = {
    Crop: 'Cultures',
    Massimo_Store: 'Boutique Massimo',
    Doris_Store: 'Boutique Doris',
  }

  const grouped = CATEGORY_ORDER.map(cat => ({
    cat,
    label: CATEGORY_LABEL[cat],
    items: ingredients.filter(i => i.source_type === cat),
  })).filter(g => g.items.length > 0)

  return (
    <div className="space-y-4">
      {grouped.map(({ cat, label, items }) => (
        <div key={cat}>
          <p className="mb-1.5 text-xs font-semibold uppercase tracking-wide text-muted-foreground">
            {label}
          </p>
          <div className="space-y-2">
            {items.map(ing => (
              <IngredientRow
                key={ing.id}
                ingredient={ing}
                quantity={inventory[ing.id] ?? 0}
                mode={mode}
                onInc={() => increment(ing.id)}
                onDec={() => decrement(ing.id)}
                onSet={q => setQuantity(ing.id, q)}
                onToggle={() => setQuantity(ing.id, (inventory[ing.id] ?? 0) > 0 ? 0 : 1)}
              />
            ))}
          </div>
        </div>
      ))}
    </div>
  )
}

function IngredientRow({
  ingredient,
  quantity,
  mode,
  onInc,
  onDec,
  onSet,
  onToggle,
}: {
  ingredient: IngredientWithCost
  quantity: number
  mode: 'quantity' | 'toggle'
  onInc: () => void
  onDec: () => void
  onSet: (q: number) => void
  onToggle: () => void
}) {
  const active = quantity > 0
  return (
    <div
      className={
        'flex items-center justify-between gap-3 rounded-lg border bg-card p-3 transition-colors ' +
        (active ? 'border-accent/50' : 'border-border')
      }
    >
      <div className="min-w-0">
        <div className="flex items-center gap-2">
          <p className="truncate font-medium">{ingredient.name}</p>
          <Badge variant="muted" className="text-[10px]">
            {ingredient.source_type.replace('_', ' ')}
          </Badge>
        </div>
        <p className="text-xs text-muted-foreground">
          Coût unitaire : {ingredient.unit_cost} G
        </p>
      </div>

      {mode === 'toggle' ? (
        <div className="flex items-center gap-2">
          {active && (
            <span className="text-xs text-destructive">aliment retiré des recettes</span>
          )}
          <Button
            variant="outline"
            size="icon"
            className={active
              ? 'h-8 w-8 shrink-0 border-destructive text-destructive hover:bg-destructive/10'
              : 'h-8 w-8 shrink-0'}
            onClick={onToggle}
            aria-label={active ? `Réintégrer ${ingredient.name}` : `Retirer ${ingredient.name} des recettes`}
          >
            <X className="h-4 w-4" />
          </Button>
        </div>
      ) : (
        <div className="flex items-center gap-1.5">
          <Button
            variant="outline"
            size="icon"
            className="h-8 w-8"
            onClick={onDec}
            disabled={quantity === 0}
            aria-label={`Retirer un(e) ${ingredient.name}`}
          >
            <Minus className="h-4 w-4" />
          </Button>
          <Input
            type="number"
            min={0}
            value={quantity}
            onChange={e => onSet(Number(e.target.value))}
            onFocus={e => e.target.select()}
            className="h-8 w-16 text-center tabular-nums"
            aria-label={`Quantité de ${ingredient.name}`}
          />
          <Button
            variant="outline"
            size="icon"
            className="h-8 w-8"
            onClick={onInc}
            aria-label={`Ajouter un(e) ${ingredient.name}`}
          >
            <Plus className="h-4 w-4" />
          </Button>
        </div>
      )}
    </div>
  )
}
