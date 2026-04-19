import { create } from 'zustand'

export type KitchenMode = 'infinite' | 'inventory' | 'exceptions'

type KitchenState = {
  inventory: Record<string, number>
  cookingLevel: number
  kitchenMode: KitchenMode

  setQuantity: (ingredientId: string, qty: number) => void
  increment: (ingredientId: string) => void
  decrement: (ingredientId: string) => void
  setCookingLevel: (n: number) => void
  setKitchenMode: (mode: KitchenMode) => void
  reset: () => void
}

const initialState = {
  inventory: {} as Record<string, number>,
  cookingLevel: 1,
  kitchenMode: 'infinite' as KitchenMode,
}

export const useKitchenStore = create<KitchenState>(set => ({
  ...initialState,

  setQuantity: (ingredientId, qty) =>
    set(s => ({
      inventory: { ...s.inventory, [ingredientId]: Math.max(0, Math.floor(qty) || 0) },
    })),

  increment: ingredientId =>
    set(s => ({
      inventory: { ...s.inventory, [ingredientId]: (s.inventory[ingredientId] ?? 0) + 1 },
    })),

  decrement: ingredientId =>
    set(s => ({
      inventory: { ...s.inventory, [ingredientId]: Math.max(0, (s.inventory[ingredientId] ?? 0) - 1) },
    })),

  setCookingLevel: n =>
    set({ cookingLevel: Math.max(1, Math.min(100, Math.floor(n) || 1)) }),

  setKitchenMode: mode => set({ kitchenMode: mode }),

  reset: () => set(initialState),
}))
