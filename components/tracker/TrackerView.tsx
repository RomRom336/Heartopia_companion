'use client'

import { useEffect, useMemo, useRef, useState, type ReactNode } from 'react'
import Link from 'next/link'
import { AlertTriangle, ArrowDownUp, Check, Loader2, MoreHorizontal, Star, Trash2 } from 'lucide-react'
import { useAuth } from '@/components/auth-provider'
import { FilterBar } from '@/components/tracker/FilterBar'
import { ItemCard } from '@/components/tracker/ItemCard'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import type { TrackerItem } from '@/types/database.types'
import { useTrackerStore, type TrackerCategory } from '@/store/useTrackerStore'
import { createClient } from '@/utils/supabase/client'
import { cn } from '@/lib/utils'

const NAV: { category: TrackerCategory; label: string; href: string }[] = [
  { category: 'Tous',     label: 'Tous',     href: '/tracker' },
  { category: 'Poissons', label: 'Poissons', href: '/tracker/fish' },
  { category: 'Insectes', label: 'Insectes', href: '/tracker/insects' },
  { category: 'Oiseaux',  label: 'Oiseaux',  href: '/tracker/birds' },
]

export function TrackerView({
  items,
  category,
  title,
  specificFilters,
}: {
  items: TrackerItem[]
  category: TrackerCategory
  title: string
  specificFilters?: ReactNode
}) {
  const { user } = useAuth()

  const searchQuery       = useTrackerStore(s => s.searchQuery)
  const hideCaught        = useTrackerStore(s => s.hideCaught)
  const maxFishLevel      = useTrackerStore(s => s.maxFishLevel)
  const maxInsectLevel    = useTrackerStore(s => s.maxInsectLevel)
  const maxBirdLevel      = useTrackerStore(s => s.maxBirdLevel)
  const setMaxFishLevel   = useTrackerStore(s => s.setMaxFishLevel)
  const setMaxInsectLevel = useTrackerStore(s => s.setMaxInsectLevel)
  const setMaxBirdLevel   = useTrackerStore(s => s.setMaxBirdLevel)
  const selectedWeather      = useTrackerStore(s => s.selectedWeather)
  const selectedTime         = useTrackerStore(s => s.selectedTime)
  const specificFilterState  = useTrackerStore(s => s.specificFilters)
  const clearSpecificFilters = useTrackerStore(s => s.clearSpecificFilters)
  const bestStars   = useTrackerStore(s => s.bestStars)
  const setBestStars = useTrackerStore(s => s.setBestStars)
  const setStar     = useTrackerStore(s => s.setStar)
  const clearStar   = useTrackerStore(s => s.clearStar)

  // Hydratation des niveaux de passion depuis la DB
  useEffect(() => {
    if (!user) return
    let cancelled = false
    const supabase = createClient()
    ;(async () => {
      const { data, error } = await supabase
        .from('profiles')
        .select('fishing_passion, bug_passion, bird_passion')
        .eq('id', user.id)
        .maybeSingle()
      if (cancelled) return
      if (!error && data) {
        if (data.fishing_passion != null) setMaxFishLevel(data.fishing_passion)
        if (data.bug_passion     != null) setMaxInsectLevel(data.bug_passion)
        if (data.bird_passion    != null) setMaxBirdLevel(data.bird_passion)
      }
    })()
    return () => { cancelled = true }
  }, [user, setMaxFishLevel, setMaxInsectLevel, setMaxBirdLevel])

  useEffect(() => {
    clearSpecificFilters()
  }, [category, clearSpecificFilters])

  // Hydratation des étoiles depuis Supabase
  useEffect(() => {
    if (!user) return
    const supabase = createClient()
    let cancelled = false
    ;(async () => {
      const { data, error } = await supabase
        .from('user_collection')
        .select('item_id, best_star')
        .eq('user_id', user.id)
      if (cancelled) return
      if (error) { console.error('Tracker — échec hydratation :', error); return }
      if (data) {
        const rec: Record<string, number> = {}
        for (const row of data) {
          if (row.best_star != null) rec[row.item_id as string] = row.best_star as number
        }
        setBestStars(rec)
      }
    })()
    return () => { cancelled = true }
  }, [user, setBestStars])

  // Click étoile
  const handleStarClick = async (item: TrackerItem, star: number) => {
    if (!user) return
    const previous = bestStars[item.id]
    const supabase = createClient()
    const isUnset = previous === star
    if (isUnset) clearStar(item.id)
    else setStar(item.id, star)
    try {
      if (isUnset) {
        const { error } = await supabase.from('user_collection').delete()
          .match({ user_id: user.id, item_type: item.type, item_id: item.id })
        if (error) throw error
      } else {
        const { error } = await supabase.from('user_collection').upsert(
          { user_id: user.id, item_type: item.type, item_id: item.id, best_star: star },
          { onConflict: 'user_id,item_type,item_id' },
        )
        if (error) throw error
      }
    } catch (err) {
      console.error('Tracker — échec synchro :', err)
      if (previous == null) clearStar(item.id)
      else setStar(item.id, previous)
    }
  }

  // Étoiles restantes pour un item (5 max − meilleure étoile obtenue)
  const remaining = (item: TrackerItem) => 5 - (bestStars[item.id] ?? 0)

  const filteredItems = useMemo(() => {
    const q = searchQuery.trim().toLowerCase()
    return items.filter(item => {
      if (hideCaught && bestStars[item.id] != null) return false
      if (q && !item.name.toLowerCase().includes(q)) return false
      const maxLevel = item.type === 'Poisson' ? maxFishLevel
        : item.type === 'Insecte' ? maxInsectLevel : maxBirdLevel
      if (item.passion_level > maxLevel) return false
      if (selectedWeather.length && !item.weather.some(w => selectedWeather.includes(w))) return false
      if (selectedTime.length   && !item.time.some(t => selectedTime.includes(t)))         return false
      for (const [key, values] of Object.entries(specificFilterState)) {
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
  }, [items, searchQuery, hideCaught, maxFishLevel, maxInsectLevel, maxBirdLevel,
      selectedWeather, selectedTime, specificFilterState, bestStars])

  // Groupes par lieu précis, triés par étoiles restantes décroissantes
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
        items: [...its].sort((a, b) => remaining(b) - remaining(a)),
        totalRemaining: its.reduce((s, i) => s + remaining(i), 0),
      }))
      .sort((a, b) => b.totalRemaining - a.totalRemaining)
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [filteredItems, bestStars])

  const caughtCount = useMemo(
    () => items.reduce((n, i) => n + (bestStars[i.id] != null ? 1 : 0), 0),
    [items, bestStars],
  )

  // --- Vue : normal ou groupé par lieu ---
  const [sortByLocation, setSortByLocation] = useState(false)

  // --- Bouton ⋯ / marquage en masse ---
  const [menuOpen,    setMenuOpen]    = useState(false)
  const [threshold,   setThreshold]   = useState(5)
  const [massState,   setMassState]   = useState<'idle' | 'loading' | 'done'>('idle')
  const [unmarkState, setUnmarkState] = useState<'idle' | 'confirm' | 'loading' | 'done'>('idle')
  const menuRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (!menuOpen) return
    const handler = (e: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(e.target as Node)) setMenuOpen(false)
    }
    document.addEventListener('mousedown', handler)
    return () => document.removeEventListener('mousedown', handler)
  }, [menuOpen])

  const handleMassUnmark = async () => {
    if (!user) return
    const targets = items.filter(i => i.passion_level > threshold && bestStars[i.id] != null)
    if (targets.length === 0) { setUnmarkState('idle'); setMenuOpen(false); return }
    setUnmarkState('loading')
    const supabase = createClient()
    const { error } = await supabase
      .from('user_collection')
      .delete()
      .eq('user_id', user.id)
      .in('item_id', targets.map(i => i.id))
    if (!error) {
      for (const item of targets) clearStar(item.id)
      setUnmarkState('done')
      setTimeout(() => { setUnmarkState('idle'); setMenuOpen(false) }, 1500)
    } else {
      console.error('[TrackerView] mass unmark error:', error)
      setUnmarkState('idle')
    }
  }

  const handleMassCatch = async () => {
    if (!user) return
    const targets = items.filter(i => i.passion_level <= threshold && bestStars[i.id] == null)
    if (targets.length === 0) { setMenuOpen(false); return }
    setMassState('loading')
    const supabase = createClient()
    const rows = targets.map(item => ({
      user_id: user.id, item_type: item.type, item_id: item.id, best_star: 1,
    }))
    const { error } = await supabase
      .from('user_collection')
      .upsert(rows, { onConflict: 'user_id,item_type,item_id' })
    if (!error) {
      for (const item of targets) setStar(item.id, 1)
      setMassState('done')
      setTimeout(() => { setMassState('idle'); setMenuOpen(false) }, 1500)
    } else {
      console.error('[TrackerView] mass catch error:', error)
      setMassState('idle')
    }
  }

  const itemGrid = (its: TrackerItem[]) => (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
      {its.map(item => (
        <ItemCard
          key={item.id}
          item={item}
          bestStar={bestStars[item.id]}
          onStarClick={star => handleStarClick(item, star)}
        />
      ))}
    </div>
  )

  return (
    <main className="container py-8">
      <header className="mb-4 flex flex-col gap-2">
        <div className="flex items-center justify-between gap-2">
          <h1 className="text-3xl font-bold tracking-tight">{title}</h1>

          <div className="flex items-center gap-1">
            {/* Bouton tri par lieu / étoiles restantes */}
            <div className="group relative">
              <button
                type="button"
                onClick={() => setSortByLocation(v => !v)}
                className={cn(
                  'rounded-md p-1.5 transition-colors',
                  sortByLocation
                    ? 'bg-primary/10 text-primary'
                    : 'text-muted-foreground hover:bg-muted hover:text-foreground',
                )}
                aria-label="Trier par lieu à visiter pour obtenir le plus d'étoiles manquantes"
              >
                <ArrowDownUp className="h-5 w-5" />
              </button>
              <div className="pointer-events-none absolute right-0 top-10 z-50 w-64 rounded-lg border border-border bg-popover px-3 py-2 text-xs text-popover-foreground shadow-md opacity-0 transition-opacity group-hover:opacity-100">
                Trier par lieu à visiter pour obtenir le plus d'étoiles manquantes — regroupe les créatures par lieu précis, du plus d'étoiles à gagner au moins.
              </div>
            </div>

            {/* Bouton ⋯ paramètres */}
            <div className="relative" ref={menuRef}>
              <button
                type="button"
                onClick={() => setMenuOpen(o => !o)}
                className="rounded-md p-1.5 text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
                aria-label="Paramètres"
              >
                <MoreHorizontal className="h-5 w-5" />
              </button>

              {menuOpen && (
                <div className="absolute right-0 top-9 z-50 w-80 rounded-xl border border-border bg-card p-4 shadow-lg">

                  {/* Section 1 — Marquer attrapé */}
                  <p className="mb-1 text-sm font-medium">Marquer en attrapé (1★)</p>
                  <p className="mb-3 text-xs text-muted-foreground">
                    Animaux non attrapés avec passion ≤ seuil → marqués à 1★.
                  </p>
                  <div className="mb-3 flex items-center gap-3">
                    <Label htmlFor="mass-threshold" className="whitespace-nowrap text-sm">Niveau ≤</Label>
                    <Input
                      id="mass-threshold"
                      type="number"
                      min={1}
                      max={100}
                      value={threshold}
                      onChange={e => setThreshold(Math.max(1, Number(e.target.value) || 1))}
                      className="w-20"
                    />
                    <span className="text-xs text-muted-foreground">
                      ({items.filter(i => i.passion_level <= threshold && bestStars[i.id] == null).length} à marquer)
                    </span>
                  </div>
                  <Button size="sm" className="w-full gap-1.5" disabled={massState === 'loading'} onClick={handleMassCatch}>
                    {massState === 'loading' && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
                    {massState === 'done'    && <Check   className="h-3.5 w-3.5" />}
                    {massState === 'idle'    && <Star    className="h-3.5 w-3.5" />}
                    {massState === 'loading' ? 'Enregistrement…' : massState === 'done' ? 'Fait !' : 'Confirmer'}
                  </Button>

                  <div className="my-4 border-t border-border" />

                  {/* Section 2 — Retirer le statut */}
                  <p className="mb-1 text-sm font-medium">Retirer le statut attrapé</p>
                  <p className="mb-3 text-xs text-muted-foreground">
                    Animaux déjà attrapés avec passion &gt; seuil → remis à non attrapé.
                  </p>
                  <div className="mb-3 flex items-center gap-3">
                    <Label htmlFor="unmark-threshold" className="whitespace-nowrap text-sm">Niveau &gt;</Label>
                    <Input
                      id="unmark-threshold"
                      type="number"
                      min={1}
                      max={100}
                      value={threshold}
                      onChange={e => setThreshold(Math.max(1, Number(e.target.value) || 1))}
                      className="w-20"
                    />
                    <span className="text-xs text-muted-foreground">
                      ({items.filter(i => i.passion_level > threshold && bestStars[i.id] != null).length} concernés)
                    </span>
                  </div>

                  {unmarkState === 'confirm' ? (
                    <div className="space-y-3">
                      <div className="flex items-start gap-2 rounded-lg border border-destructive/40 bg-destructive/10 p-3 text-xs text-destructive">
                        <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />
                        <span>
                          Vous allez perdre{' '}
                          <strong>{items.filter(i => i.passion_level > threshold && bestStars[i.id] != null).length} animaux</strong>{' '}
                          enregistrés. Cette action est irréversible.
                        </span>
                      </div>
                      <div className="flex gap-2">
                        <Button
                          size="sm"
                          variant="outline"
                          className="flex-1"
                          onClick={() => setUnmarkState('idle')}
                        >
                          Annuler
                        </Button>
                        <Button
                          size="sm"
                          variant="destructive"
                          className="flex-1 gap-1.5"
                          onClick={handleMassUnmark}
                        >
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
                      disabled={unmarkState === 'loading'}
                      onClick={() => {
                        const count = items.filter(i => i.passion_level > threshold && bestStars[i.id] != null).length
                        if (count === 0) return
                        setUnmarkState('confirm')
                      }}
                    >
                      {unmarkState === 'loading' && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
                      {unmarkState === 'done'    && <Check   className="h-3.5 w-3.5" />}
                      {unmarkState === 'idle'    && <Trash2  className="h-3.5 w-3.5" />}
                      {unmarkState === 'loading' ? 'Suppression…' : unmarkState === 'done' ? 'Fait !' : 'Retirer'}
                    </Button>
                  )}
                </div>
              )}
            </div>
          </div>
        </div>

        <p className="text-sm text-muted-foreground">
          <span className="font-medium text-foreground">{caughtCount}</span> /{' '}
          {items.length} attrapé{caughtCount > 1 ? 's' : ''} —{' '}
          <span className="font-medium text-foreground">{filteredItems.length}</span>{' '}
          affiché{filteredItems.length > 1 ? 's' : ''}.
          {sortByLocation && (
            <span className="ml-2 inline-flex items-center gap-1 text-primary">
              <ArrowDownUp className="h-3 w-3" />
              Trié par lieu (étoiles manquantes)
            </span>
          )}
        </p>
      </header>

      <nav className="mb-4 grid grid-cols-4 gap-1 rounded-lg border border-border bg-card p-1">
        {NAV.map(n => (
          <Link
            key={n.category}
            href={n.href}
            className={cn(
              'rounded-md px-3 py-1.5 text-center text-sm font-medium transition-colors',
              n.category === category
                ? 'bg-primary text-primary-foreground'
                : 'text-muted-foreground hover:bg-muted',
            )}
          >
            {n.label}
          </Link>
        ))}
      </nav>

      <FilterBar category={category}>{specificFilters}</FilterBar>

      {filteredItems.length === 0 ? (
        <p className="mt-16 text-center text-sm text-muted-foreground">
          Aucune créature ne correspond à vos filtres.
        </p>
      ) : sortByLocation ? (
        /* Vue groupée par lieu, triée par étoiles restantes */
        <div className="mt-6 space-y-8">
          {locationGroups.map(({ loc, items: its, totalRemaining }) => (
            <section key={loc}>
              <div className="mb-3 flex items-center gap-3">
                <h2 className="font-semibold">{loc}</h2>
                <span className="flex items-center gap-1 rounded-full bg-primary/10 px-2 py-0.5 text-xs font-medium text-primary">
                  <Star className="h-3 w-3 fill-primary" />
                  {totalRemaining}★ restantes
                </span>
                <span className="text-xs text-muted-foreground">{its.length} créature{its.length > 1 ? 's' : ''}</span>
              </div>
              {itemGrid(its)}
            </section>
          ))}
        </div>
      ) : (
        /* Vue normale */
        <section className="mt-6">
          {itemGrid(filteredItems)}
        </section>
      )}
    </main>
  )
}
