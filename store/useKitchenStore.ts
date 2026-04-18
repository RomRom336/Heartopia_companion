import { create } from 'zustand'

type KitchenState = {
  // Map : ingredient_id → quantité possédée
  inventory: Record<string, number>
  cookingLevel: number
  // false = mode "ressources infinies" : l'algo ignore l'inventaire
  useInventoryMode: boolean

  setQuantity: (ingredientId: string, qty: number) => void
  increment: (ingredientId: string) => void
  decrement: (ingredientId: string) => void
  setCookingLevel: (n: number) => void
  setUseInventoryMode: (value: boolean) => void
  reset: () => void
}

const initialState = {
  inventory: {} as Record<string, number>,
  cookingLevel: 1,
  useInventoryMode: false,
}

export const useKitchenStore = create<KitchenState>(set => ({
  ...initialState,

  setQuantity: (ingredientId, qty) =>
    set(s => ({
      inventory: {
        ...s.inventory,
        [ingredientId]: Math.max(0, Math.floor(qty) || 0),
      },
    })),

  increment: ingredientId =>
    set(s => ({
      inventory: {
        ...s.inventory,
        [ingredientId]: (s.inventory[ingredientId] ?? 0) + 1,
      },
    })),

  decrement: ingredientId =>
    set(s => ({
      inventory: {
        ...s.inventory,
        [ingredientId]: Math.max(0, (s.inventory[ingredientId] ?? 0) - 1),
      },
    })),

  setCookingLevel: n =>
    set({ cookingLevel: Math.max(1, Math.min(100, Math.floor(n) || 1)) }),

  setUseInventoryMode: value => set({ useInventoryMode: value }),

  reset: () => set(initialState),
}))
