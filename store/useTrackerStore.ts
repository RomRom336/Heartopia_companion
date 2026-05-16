import { create } from 'zustand'
import type { WeatherType as Weather, TimePeriod } from '@/types/database.types'

export type TrackerCategory = 'Tous' | 'Poissons' | 'Insectes' | 'Oiseaux'

type TrackerState = {
  // Filtres globaux (persistent entre sous-routes)
  searchQuery: string
  hideCaught: boolean
  hideEvents: boolean
  showIgnored: boolean
  maxFishLevel: number
  maxInsectLevel: number
  maxBirdLevel: number
  selectedWeather: Weather[]
  strictWeather: boolean
  selectedTime: TimePeriod[]
  strictTime: boolean

  // Filtres spécifiques à la sous-route courante (ex: 'location_type' → ['Mer','Lac']).
  // Remis à vide par TrackerView à chaque changement de catégorie.
  specificFilters: Record<string, string[]>

  // Capture : item_id → meilleure étoile obtenue (1..5). Absent = jamais attrapé.
  bestStars: Record<string, number>

  // Ignorés : item_id → true (event terminé, plus attrapable)
  ignoredIds: Record<string, boolean>

  // Ami à activer en mode chasse dès l'arrivée sur /tracker
  pendingHuntFriend: { id: string; username: string } | null
  setPendingHuntFriend: (f: { id: string; username: string } | null) => void

  // Ami actif en mode comparaison (persisté entre onglets)
  activeHuntFriend: { id: string; username: string; stars: Record<string, number> } | null
  setActiveHuntFriend: (f: { id: string; username: string; stars: Record<string, number> } | null) => void

  // Actions filtres globaux
  setSearchQuery: (q: string) => void
  setHideCaught: (v: boolean) => void
  setHideEvents: (v: boolean) => void
  setShowIgnored: (v: boolean) => void
  setMaxFishLevel: (n: number) => void
  setMaxInsectLevel: (n: number) => void
  setMaxBirdLevel: (n: number) => void
  toggleWeather: (w: Weather) => void
  toggleStrictWeather: () => void
  toggleTime: (t: TimePeriod) => void
  toggleStrictTime: () => void

  // Actions filtres spécifiques
  toggleSpecificFilter: (key: string, value: string) => void
  clearSpecificFilters: () => void

  // Actions capture
  setBestStars: (record: Record<string, number>) => void
  setStar: (id: string, star: number) => void
  clearStar: (id: string) => void

  // Actions ignorés
  setIgnoredIds: (record: Record<string, boolean>) => void
  setIgnored: (id: string, val: boolean) => void

  reset: () => void
}

const initialFilters = {
  searchQuery: '',
  hideCaught: false,
  hideEvents: false,
  showIgnored: false,
  maxFishLevel: 10,
  maxInsectLevel: 10,
  maxBirdLevel: 10,
  selectedWeather: [] as Weather[],
  strictWeather: false,
  selectedTime: [] as TimePeriod[],
  strictTime: false,
  specificFilters: {} as Record<string, string[]>,
}

export const useTrackerStore = create<TrackerState>(set => ({
  ...initialFilters,
  bestStars: {},
  ignoredIds: {},
  pendingHuntFriend: null,
  setPendingHuntFriend: f => set({ pendingHuntFriend: f }),
  activeHuntFriend: null,
  setActiveHuntFriend: f => set({ activeHuntFriend: f }),

  setSearchQuery: q => set({ searchQuery: q }),
  setHideCaught: v => set({ hideCaught: v }),
  setHideEvents: v => set({ hideEvents: v }),
  setShowIgnored: v => set({ showIgnored: v }),
  setMaxFishLevel: n =>
    set({ maxFishLevel: Math.max(1, Math.min(100, Math.floor(n) || 1)) }),
  setMaxInsectLevel: n =>
    set({ maxInsectLevel: Math.max(1, Math.min(100, Math.floor(n) || 1)) }),
  setMaxBirdLevel: n =>
    set({ maxBirdLevel: Math.max(1, Math.min(100, Math.floor(n) || 1)) }),
  toggleWeather: w =>
    set(s => ({
      selectedWeather: s.selectedWeather.includes(w)
        ? s.selectedWeather.filter(x => x !== w)
        : [...s.selectedWeather, w],
    })),
  toggleStrictWeather: () => set(s => ({ strictWeather: !s.strictWeather })),
  toggleTime: t =>
    set(s => ({
      selectedTime: s.selectedTime.includes(t)
        ? s.selectedTime.filter(x => x !== t)
        : [...s.selectedTime, t],
    })),
  toggleStrictTime: () => set(s => ({ strictTime: !s.strictTime })),

  toggleSpecificFilter: (key, value) =>
    set(s => {
      const current = s.specificFilters[key] ?? []
      const next = current.includes(value)
        ? current.filter(v => v !== value)
        : [...current, value]
      return { specificFilters: { ...s.specificFilters, [key]: next } }
    }),
  clearSpecificFilters: () => set({ specificFilters: {} }),

  setBestStars: record => set({ bestStars: record }),
  setStar: (id, star) =>
    set(s => ({ bestStars: { ...s.bestStars, [id]: star } })),
  clearStar: id =>
    set(s => {
      if (!(id in s.bestStars)) return s
      const { [id]: _removed, ...rest } = s.bestStars
      return { bestStars: rest }
    }),

  setIgnoredIds: record => set({ ignoredIds: record }),
  setIgnored: (id, val) =>
    set(s => ({ ignoredIds: { ...s.ignoredIds, [id]: val } })),

  reset: () => set({ ...initialFilters, bestStars: {}, ignoredIds: {}, activeHuntFriend: null }),
}))
