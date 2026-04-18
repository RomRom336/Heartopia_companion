'use client'

import { useEffect, useMemo, useRef, useState, type ReactNode } from 'react'
import Link from 'next/link'
import { Check, Loader2, MoreHorizontal, Star } from 'lucide-react'
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

  const searchQuery = useTrackerStore(s => s.searchQuery)
  const hideCaught = useTrackerStore(s => s.hideCaught)
  const maxFishLevel      = useTrackerStore(s => s.maxFishLevel)
  const maxInsectLevel    = useTrackerStore(s => s.maxInsectLevel)
  const maxBirdLevel      = useTrackerStore(s => s.maxBirdLevel)
  const setMaxFishLevel   = useTrackerStore(s => s.setMaxFishLevel)
  const setMaxInsectLevel = useTrackerStore(s => s.setMaxInsectLevel)
  const setMaxBirdLevel   = useTrackerStore(s => s.setMaxBirdLevel)
  const selectedWeather = useTrackerStore(s => s.selectedWeather)
  const selectedTime = useTrackerStore(s => s.selectedTime)
  const specificFilterState = useTrackerStore(s => s.specificFilters)
  const clearSpecificFilters = useTrackerStore(s => s.clearSpecificFilters)
  const bestStars = useTrackerStore(s => s.bestStars)
  const setBestStars = useTrackerStore(s => s.setBestStars)
  const setStar = useTrackerStore(s => s.setStar)
  const clearStar = useTrackerStore(s => s.clearStar)

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

  // Reset des filtres spécifiques à chaque changement de catégorie —
  // évite qu'un filtre "Lieu=Mer" reste actif en passant de Poissons → Oiseaux.
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
      if (error) {
        console.error('Tracker — échec hydratation :', error)
        return
      }
      if (data) {
        const rec: Record<string, number> = {}
        for (const row of data) {
          if (row.best_star != null) {
            rec[row.item_id as string] = row.best_star as number
          }
        }
        setBestStars(rec)
      }
    })()
    return () => {
      cancelled = true
    }
  }, [user, setBestStars])

  // Click étoile : set (nouvelle valeur), re-set (autre valeur), ou unset (même valeur)
  const handleStarClick = async (item: TrackerItem, star: number) => {
    if (!user) return
    const previous = bestStars[item.id]
    const supabase = createClient()
    const isUnset = previous === star

    // 1. Optimiste
    if (isUnset) clearStar(item.id)
    else setStar(item.id, star)

    // 2. Persistance
    try {
      if (isUnset) {
        const { error } = await supabase
          .from('user_collection')
          .delete()
          .match({
            user_id: user.id,
            item_type: item.type,
            item_id: item.id,
          })
        if (error) throw error
      } else {
        const { error } = await supabase.from('user_collection').upsert(
          {
            user_id: user.id,
            item_type: item.type,
            item_id: item.id,
            best_star: star,
          },
          { onConflict: 'user_id,item_type,item_id' },
        )
        if (error) throw error
      }
    } catch (err) {
      // 3. Rollback
      console.error('Tracker — échec synchro :', err)
      if (previous == null) clearStar(item.id)
      else setStar(item.id, previous)
    }
  }

  const filteredItems = useMemo(() => {
    const q = searchQuery.trim().toLowerCase()
    return items.filter(item => {
      if (hideCaught && bestStars[item.id] != null) return false
      if (q && !item.name.toLowerCase().includes(q)) return false
      const maxLevel = item.type === 'Poisson' ? maxFishLevel : item.type === 'Insecte' ? maxInsectLevel : maxBirdLevel
      if (item.passion_level > maxLevel) return false
      if (
        selectedWeather.length &&
        !item.weather.some(w => selectedWeather.includes(w))
      )
        return false
      if (
        selectedTime.length &&
        !item.time.some(t => selectedTime.includes(t))
      )
        return false

      // Filtres spécifiques : intersection valeur(s) attendue(s) ↔ champ item
      for (const [key, values] of Object.entries(specificFilterState)) {
        if (values.length === 0) continue
        const field = (item as unknown as Record<string, unknown>)[key]
        if (Array.isArray(field)) {
          if (!field.some(v => values.includes(String(v)))) return false
        } else if (typeof field === 'string') {
          if (!values.includes(field)) return false
        } else {
          // Champ absent sur cet item (ex: shadow_size sur un oiseau) → exclu
          return false
        }
      }
      return true
    })
  }, [
    items,
    searchQuery,
    hideCaught,
    maxFishLevel,
    maxInsectLevel,
    maxBirdLevel,
    selectedWeather,
    selectedTime,
    specificFilterState,
    bestStars,
  ])

  const caughtCount = useMemo(
    () => items.reduce((n, i) => n + (bestStars[i.id] != null ? 1 : 0), 0),
    [items, bestStars],
  )

  // --- Bouton ⋯ / marquage en masse ---
  const [menuOpen, setMenuOpen]       = useState(false)
  const [threshold, setThreshold]     = useState(5)
  const [massState, setMassState]     = useState<'idle' | 'loading' | 'done'>('idle')
  const menuRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (!menuOpen) return
    const handler = (e: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(e.target as Node)) {
        setMenuOpen(false)
      }
    }
    document.addEventListener('mousedown', handler)
    return () => document.removeEventListener('mousedown', handler)
  }, [menuOpen])

  const handleMassCatch = async () => {
    if (!user) return
    const targets = items.filter(
      item => item.passion_level <= threshold && bestStars[item.id] == null,
    )
    if (targets.length === 0) { setMenuOpen(false); return }
    setMassState('loading')
    const supabase = createClient()
    const rows = targets.map(item => ({
      user_id:   user.id,
      item_type: item.type,
      item_id:   item.id,
      best_star: 1,
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

  return (
    <main className="container py-8">
      <header className="mb-4 flex flex-col gap-2">
        <div className="flex items-center justify-between gap-2">
          <h1 className="text-3xl font-bold tracking-tight">{title}</h1>

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
              <div className="absolute right-0 top-9 z-50 w-72 rounded-xl border border-border bg-card p-4 shadow-lg">
                <p className="mb-3 text-sm font-medium">Marquer en attrapé (1★)</p>
                <p className="mb-3 text-xs text-muted-foreground">
                  Tous les animaux non attrapés avec un niveau de passion ≤ au seuil seront marqués à 1 étoile.
                </p>
                <div className="mb-3 flex items-center gap-3">
                  <Label htmlFor="mass-threshold" className="whitespace-nowrap text-sm">
                    Niveau max
                  </Label>
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
                <Button
                  size="sm"
                  className="w-full gap-1.5"
                  disabled={massState === 'loading'}
                  onClick={handleMassCatch}
                >
                  {massState === 'loading' && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
                  {massState === 'done'    && <Check   className="h-3.5 w-3.5" />}
                  {massState === 'idle'    && <Star    className="h-3.5 w-3.5" />}
                  {massState === 'loading' ? 'Enregistrement…'
                    : massState === 'done'  ? 'Fait !'
                    : 'Confirmer'}
                </Button>
              </div>
            )}
          </div>
        </div>
        <p className="text-sm text-muted-foreground">
          <span className="font-medium text-foreground">{caughtCount}</span> /{' '}
          {items.length} attrapé{caughtCount > 1 ? 's' : ''} —{' '}
          <span className="font-medium text-foreground">
            {filteredItems.length}
          </span>{' '}
          affiché{filteredItems.length > 1 ? 's' : ''}.
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

      <FilterBar>{specificFilters}</FilterBar>

      {filteredItems.length > 0 ? (
        <section className="mt-6 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
          {filteredItems.map(item => (
            <ItemCard
              key={item.id}
              item={item}
              bestStar={bestStars[item.id]}
              onStarClick={star => handleStarClick(item, star)}
            />
          ))}
        </section>
      ) : (
        <p className="mt-16 text-center text-sm text-muted-foreground">
          Aucune créature ne correspond à vos filtres.
        </p>
      )}
    </main>
  )
}
