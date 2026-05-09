import { create } from 'zustand'

// Mode par ingrédient (clé absente = 'infinite' par défaut)
export type IngredientMode = 'infinite' | 'quantity' | 'none'

type KitchenState = {
  itemModes:    Record<string, IngredientMode>
  inventory:    Record<string, number>          // quantités (mode 'quantity' uniquement)
  cookingLevel: number

  setItemMode:    (id: string, mode: IngredientMode) => void
  setAllModes:    (ids: string[], mode: IngredientMode) => void
  setQuantity:    (id: string, qty: number) => void
  increment:      (id: string) => void
  decrement:      (id: string) => void
  consumeRecipe:  (items: { id: string; qty: number }[]) => void
  setCookingLevel:(n: number) => void
  reset:          () => void
}

const initialState = {
  itemModes:    {} as Record<string, IngredientMode>,
  inventory:    {} as Record<string, number>,
  cookingLevel: 1,
}

export const useKitchenStore = create<KitchenState>(set => ({
  ...initialState,

  setItemMode: (id, mode) =>
    set(s => ({ itemModes: { ...s.itemModes, [id]: mode } })),

  setAllModes: (ids, mode) =>
    set(s => {
      const next = { ...s.itemModes }
      for (const id of ids) next[id] = mode
      return { itemModes: next }
    }),

  setQuantity: (id, qty) =>
    set(s => ({
      inventory: { ...s.inventory, [id]: Math.max(0, Math.floor(qty) || 0) },
    })),

  increment: id =>
    set(s => ({
      inventory: { ...s.inventory, [id]: (s.inventory[id] ?? 0) + 1 },
    })),

  decrement: id =>
    set(s => ({
      inventory: { ...s.inventory, [id]: Math.max(0, (s.inventory[id] ?? 0) - 1) },
    })),

  // Soustrait 1 portion pour chaque ingrédient en mode 'quantity'
  consumeRecipe: items =>
    set(s => {
      const inv = { ...s.inventory }
      for (const { id, qty } of items) {
        if ((s.itemModes[id] ?? 'infinite') === 'quantity') {
          inv[id] = Math.max(0, (inv[id] ?? 0) - qty)
        }
      }
      return { inventory: inv }
    }),

  setCookingLevel: n =>
    set({ cookingLevel: Math.max(1, Math.min(100, Math.floor(n) || 1)) }),

  reset: () => set(initialState),
}))
