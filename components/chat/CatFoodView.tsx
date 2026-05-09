'use client'

import { useEffect, useMemo, useRef, useState } from 'react'
import { ArrowDownUp, Cat, Check, Loader2, MoreHorizontal, Trash2 } from 'lucide-react'
import { useAuth } from '@/components/auth-provider'
import { createClient } from '@/utils/supabase/client'
import { FilterBar } from '@/components/tracker/FilterBar'
import { FishFilters } from '@/components/tracker/FishFilters'
import { FishTestCard, type CatTestStatus } from '@/components/chat/FishTestCard'
import { Button } from '@/components/ui/button'
import { useTrackerStore } from '@/store/useTrackerStore'
import type { TrackerItem } from '@/types/database.types'

export function CatFoodView({
  items,
  exactLocations,
}: {
  items: TrackerItem[]
  exactLocations: string[]
}) {
  const { user } = useAuth()

  const searchQuery          = useTrackerStore(s => s.searchQuery)
  const hideCaught           = useTrackerStore(s => s.hideCaught)
  const maxFishLevel         = useTrackerStore(s => s.maxFishLevel)
  const selectedWeather      = useTrackerStore(s => s.selectedWeather)
  const strictWeather        = useTrackerStore(s => s.strictWeather)
  const selectedTime         = useTrackerStore(s => s.selectedTime)
  const strictTime           = useTrackerStore(s => s.strictTime)
  const specificFilters      = useTrackerStore(s => s.specificFilters)
  const clearSpecificFilters = useTrackerStore(s => s.clearSpecificFilters)

  const [catTests,       setCatTests]       = useState<Record<string, CatTestStatus>>({})
  const [menuOpen,       setMenuOpen]       = useState(false)
  const [resetState,     setResetState]     = useState<'idle' | 'confirm' | 'loading' | 'done'>('idle')
  const [sortByLocation, setSortByLocation] = useState(false)
  const menuRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    clearSpecificFilters()
  }, [clearSpecificFilters])

  useEffect(() => {
    if (!menuOpen) return
    const handler = (e: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(e.target as Node)) {
        setMenuOpen(false)
        setResetState('idle')
      }
    }
    document.addEventListener('mousedown', handler)
    return () => document.removeEventListener('mousedown', handler)
  }, [menuOpen])

  // Hydratation depuis DB
  useEffect(() => {
    if (!user) return
    let cancelled = false
    const supabase = createClient()
    ;(async () => {
      const { data, error } = await supabase
        .from('cat_food_tests')
        .select('fish_id, status')
        .eq('user_id', user.id)
      if (cancelled) return
      if (error) { console.error('[CatFoodView] fetch error:', error); return }
      const rec: Record<string, CatTestStatus> = {}
      for (const row of data ?? []) rec[row.fish_id] = row.status as CatTestStatus
      setCatTests(rec)
    })()
    return () => { cancelled = true }
  }, [user])

  const handleSet = async (fishId: string, status: CatTestStatus | null) => {
    if (!user) return
    const previous = catTests[fishId]
    if (status === null) {
      setCatTests(s => { const { [fishId]: _, ...rest } = s; return rest })
    } else {
      setCatTests(s => ({ ...s, [fishId]: status }))
    }
    const supabase = createClient()
    try {
      if (status === null) {
        const { error } = await supabase.from('cat_food_tests')
          .delete().match({ user_id: user.id, fish_id: fishId })
        if (error) throw error
      } else {
        const { error } = await supabase.from('cat_food_tests')
          .upsert({ user_id: user.id, fish_id: fishId, status }, { onConflict: 'user_id,fish_id' })
        if (error) throw error
      }
    } catch (err) {
      console.error('[CatFoodView] sync error:', err)
      if (previous === undefined) {
        setCatTests(s => { const { [fishId]: _, ...rest } = s; return rest })
      } else {
        setCatTests(s => ({ ...s, [fishId]: previous }))
      }
    }
  }

  const handleReset = async () => {
    if (!user) return
    setResetState('loading')
    const supabase = createClient()
    const { error } = await supabase.from('cat_food_tests').delete().eq('user_id', user.id)
    if (!error) {
      setCatTests({})
      setResetState('done')
      setTimeout(() => { setResetState('idle'); setMenuOpen(false) }, 1500)
    } else {
      console.error('[CatFoodView] reset error:', error)
      setResetState('idle')
    }
  }

  const filteredItems = useMemo(() => {
    const q = searchQuery.trim().toLowerCase()
    return items.filter(item => {
      if (hideCaught && catTests[item.id] !== undefined) return false
      if (q && !item.name.toLowerCase().includes(q)) return false
      if (item.passion_level > maxFishLevel) return false
      if (selectedWeather.length) {
        if (strictWeather) {
          if (!item.weather.every(w => selectedWeather.includes(w))) return false
        } else {
          if (!item.weather.some(w => selectedWeather.includes(w))) return false
        }
      }
      if (selectedTime.length) {
        if (strictTime) {
          if (!item.time.every(t => selectedTime.includes(t))) return false
        } else {
          if (!item.time.some(t => selectedTime.includes(t))) return false
        }
      }
      for (const [key, values] of Object.entries(specificFilters)) {
        if (values.length === 0) continue
        const field = (item as unknown as Record<string, unknown>)[key]
        if (Array.isArray(field)) {
          if (!field.some(v => values.includes(String(v)))) return false
        } else if (typeof field === 'string') {
          if (!values.includes(field)) return false
        } else {
          return false
        }
      }
      return true
    })
  }, [items, searchQuery, hideCaught, catTests, maxFishLevel, selectedWeather,
      strictWeather, selectedTime, strictTime, specificFilters])

  // Tri par niveau de passion uniquement
  const sortedItems = useMemo(() =>
    [...filteredItems].sort((a, b) => a.passion_level - b.passion_level),
  [filteredItems])

  // Groupes par lieu, triés par nombre de non testés décroissant
  const locationGroups = useMemo(() => {
    const map = new Map<string, TrackerItem[]>()
    for (const item of filteredItems) {
      const loc = item.exact_location || 'Lieu non précisé'
      const arr = map.get(loc) ?? []
      arr.push(item)
      map.set(loc, arr)
    }
    return Array.from(map.entries())
      .map(([loc, its]) => ({
        loc,
        items: [...its].sort((a, b) => a.passion_level - b.passion_level),
        untested: its.filter(i => catTests[i.id] === undefined).length,
      }))
      .sort((a, b) => b.untested - a.untested)
  }, [filteredItems, catTests])

  const testedCount  = items.filter(i => catTests[i.id] !== undefined).length
  const wrongCount   = items.filter(i => catTests[i.id] === 'wrong').length
  const correctFound = items.find(i => catTests[i.id] === 'correct')

  // ── Pagination progressive (infinite scroll) ──────────────────
  const PAGE_SIZE = 24
  const [visibleCount, setVisibleCount] = useState(PAGE_SIZE)
  const sentinelRef = useRef<HTMLDivElement>(null)

  useEffect(() => { setVisibleCount(PAGE_SIZE) }, [filteredItems])

  useEffect(() => {
    if (sortByLocation) return
    const el = sentinelRef.current
    if (!el) return
    const obs = new IntersectionObserver(
      ([entry]) => { if (entry.isIntersecting) setVisibleCount(c => c + PAGE_SIZE) },
      { rootMargin: '400px' },
    )
    obs.observe(el)
    return () => obs.disconnect()
  }, [sortByLocation, filteredItems.length])

  return (
    <main className="container py-8">
      <header className="mb-6 flex flex-col gap-2">
        <div className="flex items-center justify-between gap-2">
          <h1 className="flex items-center gap-2 text-3xl font-bold tracking-tight">
            <Cat className="h-7 w-7 text-primary" />
            Nourriture du chat
          </h1>

          <div className="flex items-center gap-1">
            {/* Bouton tri par lieu */}
            <button
              type="button"
              onClick={() => setSortByLocation(v => !v)}
              className={`rounded-md p-1.5 transition-colors ${sortByLocation ? 'bg-primary/10 text-primary' : 'text-muted-foreground hover:bg-muted hover:text-foreground'}`}
              aria-label="Trier par lieu avec le plus de poissons non testés"
              title="Trier par lieu avec le plus de poissons non testés"
            >
              <ArrowDownUp className="h-5 w-5" />
            </button>

          {/* Bouton ⋯ */}
          <div className="relative" ref={menuRef}>
            <button
              type="button"
              onClick={() => { setMenuOpen(o => !o); setResetState('idle') }}
              className="rounded-md p-1.5 text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
              aria-label="Paramètres"
            >
              <MoreHorizontal className="h-5 w-5" />
            </button>

            {menuOpen && (
              <div className="absolute right-0 top-9 z-50 w-72 rounded-xl border border-border bg-card p-4 shadow-lg">
                <p className="mb-1 text-sm font-medium">Réinitialiser les tests</p>
                <p className="mb-4 text-xs text-muted-foreground">
                  Tous les poissons marqués seront remis à "non testé".
                </p>

                {resetState === 'confirm' ? (
                  <div className="space-y-3">
                    <div className="flex items-start gap-2 rounded-lg border border-destructive/40 bg-destructive/10 p-3 text-xs text-destructive">
                      <Trash2 className="mt-0.5 h-4 w-4 shrink-0" />
                      <span>
                        Vous allez perdre <strong>{testedCount} test{testedCount > 1 ? 's' : ''}</strong> enregistrés. Cette action est irréversible.
                      </span>
                    </div>
                    <div className="flex gap-2">
                      <Button size="sm" variant="outline" className="flex-1" onClick={() => setResetState('idle')}>
                        Annuler
                      </Button>
                      <Button size="sm" variant="destructive" className="flex-1 gap-1.5" onClick={handleReset}>
                        <Trash2 className="h-3.5 w-3.5" />
                        Confirmer
                      </Button>
                    </div>
                  </div>
                ) : (
                  <Button
                    size="sm"
                    variant="outline"
                    className="w-full gap-1.5"
                    disabled={resetState === 'loading' || testedCount === 0}
                    onClick={() => setResetState('confirm')}
                  >
                    {resetState === 'loading' && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
                    {resetState === 'done'    && <Check   className="h-3.5 w-3.5" />}
                    {resetState === 'idle'    && <Trash2  className="h-3.5 w-3.5" />}
                    {resetState === 'done' ? 'Réinitialisé !' : 'Tout remettre à zéro'}
                  </Button>
                )}
              </div>
            )}
          </div>
          </div>
        </div>

        <p className="text-sm text-muted-foreground">
          Trouvez le poisson préféré de votre chat par élimination.
        </p>

        {/* Résumé */}
        <div className="mt-1 flex flex-wrap gap-3 text-sm">
          <span className="text-muted-foreground">
            <span className="font-medium text-foreground">{testedCount}</span> / {items.length} testés
          </span>
          <span className="text-muted-foreground">
            <span className="font-medium text-destructive">{wrongCount}</span> éliminés
          </span>
          <span className="text-muted-foreground">
            <span className="font-medium text-foreground">{items.length - wrongCount}</span> candidats restants
          </span>
          {correctFound && (
            <span className="font-medium text-green-600 dark:text-green-400">
              ✅ Favori trouvé : {correctFound.name}
            </span>
          )}
        </div>
      </header>

      <FilterBar category="Poissons" hideCaughtLabel="Cacher testés">
        <FishFilters exactLocations={exactLocations} />
      </FilterBar>

      {filteredItems.length === 0 ? (
        <p className="mt-16 text-center text-sm text-muted-foreground">
          Aucun poisson ne correspond à vos filtres.
        </p>
      ) : sortByLocation ? (
        <div className="mt-6 space-y-8">
          {locationGroups.map(({ loc, items: its, untested }) => (
            <section key={loc}>
              <div className="mb-3 flex items-center gap-3">
                <h2 className="font-semibold">{loc}</h2>
                <span className="rounded-full bg-primary/10 px-2 py-0.5 text-xs font-medium text-primary">
                  {untested} non testé{untested > 1 ? 's' : ''}
                </span>
                <span className="text-xs text-muted-foreground">{its.length} poisson{its.length > 1 ? 's' : ''}</span>
              </div>
              <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
                {its.map(item => (
                  <FishTestCard
                    key={item.id}
                    item={item}
                    status={catTests[item.id]}
                    onSet={s => handleSet(item.id, s)}
                  />
                ))}
              </div>
            </section>
          ))}
        </div>
      ) : (
        <section className="mt-6">
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
            {sortedItems.slice(0, visibleCount).map(item => (
              <FishTestCard
                key={item.id}
                item={item}
                status={catTests[item.id]}
                onSet={s => handleSet(item.id, s)}
              />
            ))}
          </div>
          <div ref={sentinelRef} className="h-2" />
          {visibleCount < sortedItems.length && (
            <div className="flex justify-center py-6">
              <Loader2 className="h-5 w-5 animate-spin text-muted-foreground" />
            </div>
          )}
        </section>
      )}
    </main>
  )
}
