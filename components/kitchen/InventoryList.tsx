'use client'

import { useState } from 'react'
import { ChevronDown } from 'lucide-react'
import type { IngredientWithCost } from '@/types/database.types'
import { useKitchenStore, type IngredientMode } from '@/store/useKitchenStore'

const CATEGORY_ORDER: IngredientWithCost['source_type'][] = [
  'Champignon', 'Aquatique', 'Fruit',
  'Crop', 'Massimo_Store', 'Doris_Store',
  'SubFood', 'Autre',
]
const CATEGORY_LABEL: Record<IngredientWithCost['source_type'], string> = {
  Champignon:    '🍄 Champignons',
  Aquatique:     '🐟 Poissons & Crustacés',
  Fruit:         '🍎 Fruits',
  Crop:          '🌱 Cultures',
  Massimo_Store: '🛒 Boutique Massimo',
  Doris_Store:   '🍬 Boutique Doris',
  SubFood:       '🍽️ Plats préparés',
  Autre:         '📦 Autres',
}

// Retourne le mode si TOUS les ids ont le même mode, sinon null.
function allSameMode(ids: string[], itemModes: Record<string, IngredientMode>): IngredientMode | null {
  if (ids.length === 0) return null
  const first = itemModes[ids[0]] ?? 'infinite'
  return ids.every(id => (itemModes[id] ?? 'infinite') === first) ? first : null
}

export function InventoryList({ ingredients }: { ingredients: IngredientWithCost[] }) {
  const itemModes   = useKitchenStore(s => s.itemModes)
  const setItemMode = useKitchenStore(s => s.setItemMode)
  const setAllModes = useKitchenStore(s => s.setAllModes)
  const inventory   = useKitchenStore(s => s.inventory)
  const setQuantity = useKitchenStore(s => s.setQuantity)
  const increment   = useKitchenStore(s => s.increment)
  const decrement   = useKitchenStore(s => s.decrement)

  const allIds    = ingredients.map(i => i.id)
  const globalAll = allSameMode(allIds, itemModes)

  const grouped = CATEGORY_ORDER.map(cat => ({
    cat,
    label: CATEGORY_LABEL[cat],
    items: ingredients.filter(i => i.source_type === cat),
  })).filter(g => g.items.length > 0)

  return (
    <div className="space-y-3">
      {/* ── Raccourcis globaux ── */}
      <div className="flex flex-wrap items-center gap-2 rounded-xl border border-border bg-muted/40 px-4 py-3">
        <span className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
          Tout mettre en :
        </span>
        <GlobalModeButton mode="infinite" active={globalAll === 'infinite'} onClick={() => setAllModes(allIds, 'infinite')} label="∞ Infini"    />
        <GlobalModeButton mode="quantity" active={globalAll === 'quantity'} onClick={() => setAllModes(allIds, 'quantity')} label="# Quantités" />
        <GlobalModeButton mode="none"     active={globalAll === 'none'}     onClick={() => setAllModes(allIds, 'none')}     label="× Vide"      />
      </div>

      {/* ── Catégories déroulantes ── */}
      {grouped.map(({ cat, label, items }) => {
        const catIds = items.map(i => i.id)
        return (
          <CategorySection
            key={cat}
            label={label}
            items={items}
            catIds={catIds}
            itemModes={itemModes}
            inventory={inventory}
            setAllModes={setAllModes}
            setItemMode={setItemMode}
            setQuantity={setQuantity}
            increment={increment}
            decrement={decrement}
          />
        )
      })}
    </div>
  )
}

// ── Section catégorie (accordéon) ─────────────────────────────
function CategorySection({
  label, items, catIds,
  itemModes, inventory,
  setAllModes, setItemMode, setQuantity, increment, decrement,
}: {
  label: string
  items: IngredientWithCost[]
  catIds: string[]
  itemModes: Record<string, IngredientMode>
  inventory: Record<string, number>
  setAllModes: (ids: string[], mode: IngredientMode) => void
  setItemMode: (id: string, mode: IngredientMode) => void
  setQuantity: (id: string, qty: number) => void
  increment: (id: string) => void
  decrement: (id: string) => void
}) {
  const [open, setOpen] = useState(false)
  const catAll = allSameMode(catIds, itemModes)

  return (
    <div className="overflow-hidden rounded-xl border border-border bg-card">
      {/* En-tête cliquable */}
      <div className="flex items-center gap-2 px-4 py-3">
        <button
          type="button"
          onClick={() => setOpen(o => !o)}
          className="flex flex-1 items-center gap-2 text-left"
        >
          <ChevronDown
            className={`h-4 w-4 shrink-0 text-muted-foreground transition-transform duration-200 ${open ? 'rotate-180' : ''}`}
          />
          <span className="font-semibold">{label}</span>
          <span className="ml-1 rounded-full bg-muted px-2 py-0.5 text-xs text-muted-foreground">
            {items.length}
          </span>
        </button>

        {/* Raccourcis catégorie — toujours visibles */}
        <div
          className="flex items-center gap-1.5 shrink-0"
          onClick={e => e.stopPropagation()}
        >
          <CatModeButton mode="infinite" active={catAll === 'infinite'} label="∞" title="Tout infini"    onClick={() => setAllModes(catIds, 'infinite')} />
          <CatModeButton mode="quantity" active={catAll === 'quantity'} label="#" title="Tout quantifier" onClick={() => setAllModes(catIds, 'quantity')} />
          <CatModeButton mode="none"     active={catAll === 'none'}     label="×" title="Tout vide"      onClick={() => setAllModes(catIds, 'none')} />
        </div>
      </div>

      {/* Contenu déroulant */}
      {open && (
        <div className="border-t border-border px-3 pb-3 pt-2 space-y-2">
          {items.map(ing => {
            const mode = itemModes[ing.id] ?? 'infinite'
            const qty  = inventory[ing.id] ?? 0
            return (
              <IngredientRow
                key={ing.id}
                ingredient={ing}
                mode={mode}
                quantity={qty}
                onModeChange={m => setItemMode(ing.id, m)}
                onSet={q => setQuantity(ing.id, q)}
                onInc={() => increment(ing.id)}
                onDec={() => decrement(ing.id)}
              />
            )
          })}
        </div>
      )}
    </div>
  )
}

// ── Bouton raccourci global (grande version) ──────────────────
function GlobalModeButton({ mode, active, onClick, label }: {
  mode: IngredientMode; active: boolean; onClick: () => void; label: string
}) {
  const activeCls =
    mode === 'infinite' ? 'bg-emerald-500/60 border-emerald-500/60 text-emerald-100 shadow-md shadow-emerald-500/15' :
    mode === 'quantity' ? 'bg-blue-500/60 border-blue-500/60 text-blue-100 shadow-md shadow-blue-500/15' :
                          'bg-red-500/60 border-red-500/60 text-red-100 shadow-md shadow-red-500/15'
  const idleCls =
    mode === 'infinite' ? 'border-emerald-500/50 text-emerald-600 hover:bg-emerald-500/50 hover:text-white' :
    mode === 'quantity' ? 'border-blue-500/50 text-blue-600 hover:bg-blue-500/50 hover:text-white' :
                          'border-red-400/50 text-red-500 hover:bg-red-500/50 hover:text-white'
  return (
    <button
      type="button"
      onClick={onClick}
      className={`rounded-full border-2 px-4 py-1.5 text-sm font-semibold transition-all ${active ? activeCls : idleCls}`}
    >
      {label}
    </button>
  )
}

// ── Bouton raccourci catégorie (version compacte) ─────────────
function CatModeButton({ mode, active, label, title, onClick }: {
  mode: IngredientMode; active: boolean; label: string; title: string; onClick: () => void
}) {
  const activeCls =
    mode === 'infinite' ? 'bg-emerald-500/60 border-emerald-500/60 text-emerald-100 shadow-sm shadow-emerald-500/20' :
    mode === 'quantity' ? 'bg-blue-500/60 border-blue-500/60 text-blue-100 shadow-sm shadow-blue-500/20' :
                          'bg-red-500/60 border-red-500/60 text-red-100 shadow-sm shadow-red-500/20'
  const idleCls =
    mode === 'infinite' ? 'border-emerald-500/50 text-emerald-600 hover:bg-emerald-500/50 hover:text-white' :
    mode === 'quantity' ? 'border-blue-500/50 text-blue-600 hover:bg-blue-500/50 hover:text-white' :
                          'border-red-400/50 text-red-500 hover:bg-red-500/50 hover:text-white'
  return (
    <button
      type="button"
      onClick={onClick}
      title={title}
      className={`h-7 w-7 rounded-full border-2 text-sm font-bold transition-all ${active ? activeCls : idleCls}`}
    >
      {label}
    </button>
  )
}

// ── Ligne ingrédient ──────────────────────────────────────────
function IngredientRow({
  ingredient, mode, quantity, onModeChange, onSet, onInc, onDec,
}: {
  ingredient: IngredientWithCost
  mode: IngredientMode
  quantity: number
  onModeChange: (m: IngredientMode) => void
  onSet: (q: number) => void
  onInc: () => void
  onDec: () => void
}) {
  const borderClass =
    mode === 'infinite' ? 'border-emerald-500/30 bg-emerald-500/5' :
    mode === 'quantity' ? 'border-blue-500/30 bg-blue-500/5'       :
                          'border-red-400/20 opacity-50'

  return (
    <div className={`flex items-center justify-between gap-3 rounded-lg border px-3 py-2 transition-colors ${borderClass}`}>
      <div className="min-w-0 flex-1">
        <p className="truncate text-sm font-medium">{ingredient.name}</p>
        {ingredient.unit_cost > 0 && (
          <p className="text-xs text-muted-foreground">{ingredient.unit_cost} G</p>
        )}
      </div>

      <div className="flex items-center gap-0.5 shrink-0">
        {/* ∞ */}
        <button
          onClick={() => onModeChange('infinite')}
          title="Infini"
          className={`flex h-8 w-8 items-center justify-center rounded-l-md border text-base font-bold transition-colors
            ${mode === 'infinite' ? 'bg-emerald-500/60 border-emerald-500/60 text-emerald-100' : 'border-border bg-background text-muted-foreground hover:bg-emerald-500/30 hover:text-emerald-600 hover:border-emerald-400/60 dark:hover:bg-emerald-950/30'}`}
        >
          ∞
        </button>

        {/* Input qty */}
        <div className="relative">
          <input
            type="number"
            min={0}
            value={mode === 'none' ? 0 : quantity}
            disabled={mode === 'none'}
            onChange={e => onSet(Number(e.target.value))}
            onFocus={() => { if (mode !== 'quantity') onModeChange('quantity') }}
            className={`h-8 w-20 border-y border-x-0 bg-background text-center tabular-nums text-sm outline-none
              [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none
              transition-colors
              ${mode === 'quantity' ? 'border-blue-500/60 text-foreground' : 'border-border text-muted-foreground'}
              ${mode === 'none' ? 'cursor-not-allowed opacity-40' : ''}`}
          />
          {mode === 'quantity' && (
            <div className="absolute inset-y-0 right-0 flex flex-col">
              <button onClick={onInc} className="flex h-4 w-4 items-center justify-center text-[10px] text-muted-foreground hover:text-foreground leading-none">▲</button>
              <button onClick={onDec} disabled={quantity === 0} className="flex h-4 w-4 items-center justify-center text-[10px] text-muted-foreground hover:text-foreground leading-none disabled:opacity-30">▼</button>
            </div>
          )}
        </div>

        {/* × */}
        <button
          onClick={() => onModeChange('none')}
          title="Pas disponible"
          className={`flex h-8 w-8 items-center justify-center rounded-r-md border text-base font-bold transition-colors
            ${mode === 'none' ? 'bg-red-500/60 border-red-500/60 text-red-100' : 'border-border bg-background text-muted-foreground hover:bg-red-500/30 hover:text-red-500 hover:border-red-400/60 dark:hover:bg-red-950/30'}`}
        >
          ×
        </button>
      </div>
    </div>
  )
}
