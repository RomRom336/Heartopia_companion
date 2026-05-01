'use client'

import { useEffect, useMemo, useRef, useState, type ReactNode } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { AlertTriangle, ArrowDownUp, Check, Loader2, MoreHorizontal, Star, Swords, Trash2, Users2, X } from 'lucide-react'
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

type HuntColor = 'red' | 'orange' | 'green'
type ViewAs    = {
  userId: string
  username: string
  bestStars: Record<string, number>
  passionLevels?: { fish: number | null; insect: number | null; bird: number | null }
}

const NAV: { category: TrackerCategory; label: string; href: string }[] = [
  { category: 'Tous',     label: 'Tous',     href: '/tracker' },
  { category: 'Poissons', label: 'Poissons', href: '/tracker/fish' },
  { category: 'Insectes', label: 'Insectes', href: '/tracker/insects' },
  { category: 'Oiseaux',  label: 'Oiseaux',  href: '/tracker/birds' },
]

const HUNT_COLORS: { value: HuntColor; label: string; cls: string }[] = [
  { value: 'green',  label: '🟢 Les deux',    cls: 'border-green-500 text-green-600 dark:text-green-400' },
  { value: 'orange', label: '🟠 Un seul',     cls: 'border-orange-400 text-orange-600 dark:text-orange-400' },
  { value: 'red',    label: '🔴 Aucun',       cls: 'border-destructive text-destructive' },
]

export function TrackerView({
  items,
  category,
  title,
  specificFilters,
  viewAs,
}: {
  items: TrackerItem[]
  category: TrackerCategory
  title: string
  specificFilters?: ReactNode
  viewAs?: ViewAs
}) {
  const { user } = useAuth()
  const router = useRouter()
  const isViewMode = viewAs !== undefined

  const searchQuery          = useTrackerStore(s => s.searchQuery)
  const hideCaught           = useTrackerStore(s => s.hideCaught)
  const maxFishLevel         = useTrackerStore(s => s.maxFishLevel)
  const maxInsectLevel       = useTrackerStore(s => s.maxInsectLevel)
  const maxBirdLevel         = useTrackerStore(s => s.maxBirdLevel)
  const setMaxFishLevel      = useTrackerStore(s => s.setMaxFishLevel)
  const setMaxInsectLevel    = useTrackerStore(s => s.setMaxInsectLevel)
  const setMaxBirdLevel      = useTrackerStore(s => s.setMaxBirdLevel)
  const selectedWeather      = useTrackerStore(s => s.selectedWeather)
  const strictWeather        = useTrackerStore(s => s.strictWeather)
  const selectedTime         = useTrackerStore(s => s.selectedTime)
  const strictTime           = useTrackerStore(s => s.strictTime)
  const specificFilterState  = useTrackerStore(s => s.specificFilters)
  const clearSpecificFilters = useTrackerStore(s => s.clearSpecificFilters)
  const storeBestStars         = useTrackerStore(s => s.bestStars)
  const setBestStars           = useTrackerStore(s => s.setBestStars)
  const setStar                = useTrackerStore(s => s.setStar)
  const clearStar              = useTrackerStore(s => s.clearStar)
  const pendingHuntFriend      = useTrackerStore(s => s.pendingHuntFriend)
  const setPendingHuntFriend   = useTrackerStore(s => s.setPendingHuntFriend)
  const activeHuntFriend       = useTrackerStore(s => s.activeHuntFriend)
  const setActiveHuntFriend    = useTrackerStore(s => s.setActiveHuntFriend)

  // En mode viewAs on affiche les étoiles de l'ami, sinon les nôtres
  const bestStars = isViewMode ? viewAs.bestStars : storeBestStars

  // ── Hydratations (désactivées en mode viewAs) ──────────────────
  useEffect(() => {
    if (!user || isViewMode) return
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
  }, [user, isViewMode, setMaxFishLevel, setMaxInsectLevel, setMaxBirdLevel])

  useEffect(() => { clearSpecificFilters() }, [category, clearSpecificFilters])

  useEffect(() => {
    if (!user || isViewMode) return
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
        for (const row of data) if (row.best_star != null) rec[row.item_id as string] = row.best_star as number
        setBestStars(rec)
      }
    })()
    return () => { cancelled = true }
  }, [user, isViewMode, setBestStars])

  // ── Click étoile (désactivé en mode viewAs) ───────────────────
  const handleStarClick = async (item: TrackerItem, star: number) => {
    if (!user || isViewMode) return
    const previous = storeBestStars[item.id]
    const isUnset = previous === star
    if (isUnset) clearStar(item.id)
    else setStar(item.id, star)
    try {
      if (isUnset) {
        const { error } = await createClient().from('user_collection').delete()
          .match({ user_id: user.id, item_type: item.type, item_id: item.id })
        if (error) throw error
      } else {
        const { error } = await createClient().from('user_collection').upsert(
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

  const remaining = (item: TrackerItem) => 5 - (bestStars[item.id] ?? 0)

  // ── Mode chasse ensemble ──────────────────────────────────────
  // huntFriend est dans le store pour survivre aux navigations entre onglets
  const huntFriend = activeHuntFriend
  const setHuntFriend = setActiveHuntFriend
  const [huntColorFilter, setHuntColorFilter] = useState<HuntColor[]>([])
  const [huntPanelOpen,   setHuntPanelOpen]   = useState(false)
  const [friendsList,     setFriendsList]      = useState<{ id: string; username: string }[]>([])
  const [friendsLoading,  setFriendsLoading]  = useState(false)
  const huntPanelRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (!huntPanelOpen) return
    const handler = (e: MouseEvent) => {
      if (huntPanelRef.current && !huntPanelRef.current.contains(e.target as Node)) setHuntPanelOpen(false)
    }
    document.addEventListener('mousedown', handler)
    return () => document.removeEventListener('mousedown', handler)
  }, [huntPanelOpen])

  const openHuntPanel = async () => {
    setHuntPanelOpen(o => !o)
    if (friendsList.length > 0 || !user) return
    setFriendsLoading(true)
    const supabase = createClient()
    const { data: rows } = await supabase
      .from('friendships')
      .select('user_id, friend_id')
      .or(`user_id.eq.${user.id},friend_id.eq.${user.id}`)
      .eq('status', 'accepted')
    const otherIds = (rows ?? []).map(r => r.user_id === user.id ? r.friend_id : r.user_id)
    if (otherIds.length > 0) {
      const { data: profiles } = await supabase
        .from('profiles')
        .select('id, username')
        .in('id', otherIds)
      setFriendsList((profiles ?? []) as { id: string; username: string }[])
    }
    setFriendsLoading(false)
  }

  const selectHuntFriend = async (friend: { id: string; username: string }) => {
    setHuntPanelOpen(false)
    const { data } = await createClient()
      .from('user_collection')
      .select('item_id, best_star')
      .eq('user_id', friend.id)
    const stars: Record<string, number> = {}
    for (const row of data ?? []) if (row.best_star != null) stars[row.item_id as string] = row.best_star as number
    setHuntFriend({ id: friend.id, username: friend.username, stars })
    setHuntColorFilter([])
  }

  useEffect(() => {
    if (!pendingHuntFriend || isViewMode) return
    setPendingHuntFriend(null)
    selectHuntFriend(pendingHuntFriend)
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const getHuntColor = (item: TrackerItem): HuntColor => {
    const mine   = storeBestStars[item.id] != null
    const theirs = huntFriend!.stars[item.id] != null
    if (mine && theirs)   return 'green'
    if (!mine && !theirs) return 'red'
    return 'orange'
  }

  const toggleHuntColor = (c: HuntColor) =>
    setHuntColorFilter(f => f.includes(c) ? f.filter(x => x !== c) : [...f, c])

  // ── Filtrage ──────────────────────────────────────────────────
  const filteredItems = useMemo(() => {
    const q = searchQuery.trim().toLowerCase()
    return items.filter(item => {
      if (hideCaught && bestStars[item.id] != null) return false
      if (q && !item.name.toLowerCase().includes(q)) return false
      const maxLevel = item.type === 'Poisson' ? maxFishLevel
        : item.type === 'Insecte' ? maxInsectLevel : maxBirdLevel
      if (item.passion_level > maxLevel) return false
      if (selectedWeather.length) {
        if (strictWeather) { if (!item.weather.every(w => selectedWeather.includes(w))) return false }
        else               { if (!item.weather.some(w => selectedWeather.includes(w))) return false }
      }
      if (selectedTime.length) {
        if (strictTime) { if (!item.time.every(t => selectedTime.includes(t))) return false }
        else            { if (!item.time.some(t => selectedTime.includes(t))) return false }
      }
      for (const [key, values] of Object.entries(specificFilterState)) {
        if (values.length === 0) continue
        const field = (item as unknown as Record<string, unknown>)[key]
        if (Array.isArray(field)) { if (!field.some(v => values.includes(String(v)))) return false }
        else if (typeof field === 'string') { if (!values.includes(field)) return false }
        else return false
      }
      if (huntFriend && huntColorFilter.length > 0) {
        if (!huntColorFilter.includes(getHuntColor(item))) return false
      }
      return true
    })
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [items, searchQuery, hideCaught, maxFishLevel, maxInsectLevel, maxBirdLevel,
      selectedWeather, strictWeather, selectedTime, strictTime, specificFilterState,
      bestStars, huntFriend, huntColorFilter, storeBestStars])

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

  const [sortByLocation, setSortByLocation] = useState(false)

  // ── Menu ⋯ (marquage en masse) ────────────────────────────────
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
    const targets = items.filter(i => i.passion_level > threshold && storeBestStars[i.id] != null)
    if (targets.length === 0) { setUnmarkState('idle'); setMenuOpen(false); return }
    setUnmarkState('loading')
    const { error } = await createClient().from('user_collection').delete()
      .eq('user_id', user.id).in('item_id', targets.map(i => i.id))
    if (!error) {
      for (const item of targets) clearStar(item.id)
      setUnmarkState('done')
      setTimeout(() => { setUnmarkState('idle'); setMenuOpen(false) }, 1500)
    } else {
      setUnmarkState('idle')
    }
  }

  const handleMassCatch = async () => {
    if (!user) return
    const targets = items.filter(i => i.passion_level <= threshold && storeBestStars[i.id] == null)
    if (targets.length === 0) { setMenuOpen(false); return }
    setMassState('loading')
    const rows = targets.map(item => ({ user_id: user.id, item_type: item.type, item_id: item.id, best_star: 1 }))
    const { error } = await createClient().from('user_collection').upsert(rows, { onConflict: 'user_id,item_type,item_id' })
    if (!error) {
      for (const item of targets) setStar(item.id, 1)
      setMassState('done')
      setTimeout(() => { setMassState('idle'); setMenuOpen(false) }, 1500)
    } else {
      setMassState('idle')
    }
  }

  const itemGrid = (its: TrackerItem[]) => (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
      {its.map(item => {
        const huntColor = huntFriend ? getHuntColor(item) : undefined
        const huntLabel = huntColor === 'orange'
          ? (storeBestStars[item.id] != null ? 'Seulement toi' : `Seulement ${huntFriend!.username}`)
          : undefined
        return (
          <ItemCard
            key={item.id}
            item={item}
            bestStar={bestStars[item.id]}
            onStarClick={star => handleStarClick(item, star)}
            readOnly={isViewMode}
            huntInfo={huntFriend ? {
              color: huntColor!,
              label: huntLabel,
              friendStar: huntFriend.stars[item.id],
              friendUsername: huntFriend.username,
            } : undefined}
          />
        )
      })}
    </div>
  )

  return (
    <main className="container py-8">
      <header className="mb-4 flex flex-col gap-2">

        {/* Bannière viewAs */}
        {isViewMode && (
          <div className="mb-2 flex items-center gap-2 rounded-lg border border-border bg-muted/40 px-4 py-2 text-sm text-muted-foreground">
            <Users2 className="h-4 w-4 shrink-0 text-primary" />
            <span>Collection de <span className="font-semibold text-foreground">{viewAs!.username}</span></span>
            {!huntFriend && (
              <button
                type="button"
                onClick={() => {
                  setPendingHuntFriend({ id: viewAs!.userId, username: viewAs!.username })
                  router.push('/tracker')
                }}
                className="ml-auto flex items-center gap-1.5 rounded-md border border-border bg-card px-3 py-1.5 text-xs font-medium text-foreground transition-colors hover:bg-muted"
              >
                <Swords className="h-3.5 w-3.5" />
                Comparer les collections
              </button>
            )}
          </div>
        )}

        <div className="flex items-center justify-between gap-2">
          <div className="flex flex-wrap items-baseline gap-4">
            <h1 className="text-3xl font-bold tracking-tight">{title}</h1>
            {!isViewMode && user && (
              <div className="flex flex-wrap gap-3">
                <span className="text-base font-medium text-muted-foreground">🎣 Niv.&nbsp;<span className="text-foreground">{maxFishLevel}</span></span>
                <span className="text-base font-medium text-muted-foreground">🦋 Niv.&nbsp;<span className="text-foreground">{maxInsectLevel}</span></span>
                <span className="text-base font-medium text-muted-foreground">🐦 Niv.&nbsp;<span className="text-foreground">{maxBirdLevel}</span></span>
              </div>
            )}
            {isViewMode && viewAs!.passionLevels && (
              <div className="flex flex-wrap gap-3">
                {viewAs!.passionLevels.fish   != null && (
                  <span className="text-base font-medium text-muted-foreground">🎣 Niv.&nbsp;<span className="text-foreground">{viewAs!.passionLevels.fish}</span></span>
                )}
                {viewAs!.passionLevels.insect != null && (
                  <span className="text-base font-medium text-muted-foreground">🦋 Niv.&nbsp;<span className="text-foreground">{viewAs!.passionLevels.insect}</span></span>
                )}
                {viewAs!.passionLevels.bird   != null && (
                  <span className="text-base font-medium text-muted-foreground">🐦 Niv.&nbsp;<span className="text-foreground">{viewAs!.passionLevels.bird}</span></span>
                )}
              </div>
            )}
          </div>

          <div className="flex items-center gap-1">
            {/* Tri par lieu */}
            <div className="group relative">
              <button
                type="button"
                onClick={() => setSortByLocation(v => !v)}
                className={cn('rounded-md p-1.5 transition-colors',
                  sortByLocation ? 'bg-primary/10 text-primary' : 'text-muted-foreground hover:bg-muted hover:text-foreground')}
                aria-label="Trier par lieu à visiter pour obtenir le plus d'étoiles manquantes"
              >
                <ArrowDownUp className="h-5 w-5" />
              </button>
              <div className="pointer-events-none absolute right-0 top-10 z-50 w-64 rounded-lg border border-border bg-card px-3 py-2 text-xs text-card-foreground shadow-lg opacity-0 transition-opacity group-hover:opacity-100">
                Trier par lieu à visiter pour obtenir le plus d'étoiles manquantes — regroupe les créatures par lieu précis, du plus d'étoiles à gagner au moins.
              </div>
            </div>

            {/* Menu amis — visible en mode normal et viewAs */}
            <div className="relative" ref={huntPanelRef}>
              <button
                type="button"
                onClick={openHuntPanel}
                className={cn('rounded-md p-1.5 transition-colors',
                  huntFriend ? 'bg-orange-400/20 text-orange-500' : 'text-muted-foreground hover:bg-muted hover:text-foreground')}
                aria-label="Comparer les collections"
                title="Comparer les collections"
              >
                <Users2 className="h-5 w-5" />
              </button>

              {huntPanelOpen && (
                <div className="absolute right-0 top-9 z-50 w-72 rounded-xl border border-border bg-card p-4 shadow-lg">
                  {friendsLoading ? (
                    <div className="flex justify-center py-4"><Loader2 className="h-5 w-5 animate-spin text-muted-foreground" /></div>
                  ) : friendsList.length === 0 ? (
                    <p className="text-xs text-muted-foreground">Vous n'avez pas encore d'amis. Ajoutez-en depuis la page <Link href="/friends" className="underline">Amis</Link>.</p>
                  ) : (
                    <ul className="space-y-2">
                      {friendsList.map(f => (
                        <li key={f.id} className="rounded-lg border border-border p-3">
                          <p className={cn('mb-2 text-sm font-semibold', huntFriend?.id === f.id && 'text-orange-500')}>
                            {f.username}
                            {huntFriend?.id === f.id && <span className="ml-2 text-xs font-normal opacity-70">actif</span>}
                          </p>
                          <div className="flex gap-1.5">
                            <button
                              type="button"
                              onClick={() => selectHuntFriend(f)}
                              className={cn(
                                'flex flex-1 items-center justify-center gap-1 rounded-md border px-2 py-1.5 text-xs font-medium transition-colors',
                                huntFriend?.id === f.id
                                  ? 'border-orange-400 bg-orange-400/10 text-orange-500'
                                  : 'border-border hover:bg-muted',
                              )}
                            >
                              <Swords className="h-3 w-3" />
                              Comparer
                            </button>
                            <Link
                              href={isViewMode && viewAs!.userId === f.id
                                ? `/friends/${f.id}/profile`
                                : `/friends/${f.id}`}
                              className="flex flex-1 items-center justify-center gap-1 rounded-md border border-border px-2 py-1.5 text-xs font-medium transition-colors hover:bg-muted"
                            >
                              <Users2 className="h-3 w-3" />
                              {isViewMode && viewAs!.userId === f.id ? 'Profil' : 'Collection'}
                            </Link>
                          </div>
                        </li>
                      ))}
                    </ul>
                  )}
                </div>
              )}
            </div>

            {/* Menu ⋯ (masqué en mode viewAs) */}
            {!isViewMode && (
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
                    <p className="mb-1 text-sm font-medium">Marquer en attrapé (1★)</p>
                    <p className="mb-3 text-xs text-muted-foreground">Animaux non attrapés avec passion ≤ seuil → marqués à 1★.</p>
                    <div className="mb-3 flex items-center gap-3">
                      <Label htmlFor="mass-threshold" className="whitespace-nowrap text-sm">Niveau ≤</Label>
                      <Input id="mass-threshold" type="number" min={1} max={100} value={threshold}
                        onChange={e => setThreshold(Math.max(1, Number(e.target.value) || 1))} className="w-20" />
                      <span className="text-xs text-muted-foreground">
                        ({items.filter(i => i.passion_level <= threshold && storeBestStars[i.id] == null).length} à marquer)
                      </span>
                    </div>
                    <Button size="sm" className="w-full gap-1.5" disabled={massState === 'loading'} onClick={handleMassCatch}>
                      {massState === 'loading' && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
                      {massState === 'done'    && <Check   className="h-3.5 w-3.5" />}
                      {massState === 'idle'    && <Star    className="h-3.5 w-3.5" />}
                      {massState === 'loading' ? 'Enregistrement…' : massState === 'done' ? 'Fait !' : 'Confirmer'}
                    </Button>

                    <div className="my-4 border-t border-border" />

                    <p className="mb-1 text-sm font-medium">Retirer le statut attrapé</p>
                    <p className="mb-3 text-xs text-muted-foreground">Animaux déjà attrapés avec passion &gt; seuil → remis à non attrapé.</p>
                    <div className="mb-3 flex items-center gap-3">
                      <Label htmlFor="unmark-threshold" className="whitespace-nowrap text-sm">Niveau &gt;</Label>
                      <Input id="unmark-threshold" type="number" min={1} max={100} value={threshold}
                        onChange={e => setThreshold(Math.max(1, Number(e.target.value) || 1))} className="w-20" />
                      <span className="text-xs text-muted-foreground">
                        ({items.filter(i => i.passion_level > threshold && storeBestStars[i.id] != null).length} concernés)
                      </span>
                    </div>
                    {unmarkState === 'confirm' ? (
                      <div className="space-y-3">
                        <div className="flex items-start gap-2 rounded-lg border border-destructive/40 bg-destructive/10 p-3 text-xs text-destructive">
                          <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />
                          <span>
                            Vous allez perdre <strong>{items.filter(i => i.passion_level > threshold && storeBestStars[i.id] != null).length} animaux</strong> enregistrés. Cette action est irréversible.
                          </span>
                        </div>
                        <div className="flex gap-2">
                          <Button size="sm" variant="outline" className="flex-1" onClick={() => setUnmarkState('idle')}>Annuler</Button>
                          <Button size="sm" variant="destructive" className="flex-1 gap-1.5" onClick={handleMassUnmark}>
                            <Trash2 className="h-3.5 w-3.5" />Confirmer
                          </Button>
                        </div>
                      </div>
                    ) : (
                      <Button size="sm" variant="outline" className="w-full gap-1.5" disabled={unmarkState === 'loading'}
                        onClick={() => { if (items.filter(i => i.passion_level > threshold && storeBestStars[i.id] != null).length > 0) setUnmarkState('confirm') }}>
                        {unmarkState === 'loading' && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
                        {unmarkState === 'done'    && <Check   className="h-3.5 w-3.5" />}
                        {unmarkState === 'idle'    && <Trash2  className="h-3.5 w-3.5" />}
                        {unmarkState === 'loading' ? 'Suppression…' : unmarkState === 'done' ? 'Fait !' : 'Retirer'}
                      </Button>
                    )}
                  </div>
                )}
              </div>
            )}
          </div>
        </div>

        {/* Bannière mode chasse */}
        {huntFriend && (
          <div className="flex flex-wrap items-center gap-3 rounded-lg border border-orange-400/40 bg-orange-400/5 px-3 py-2">
            <span className="text-sm font-medium text-orange-600 dark:text-orange-400">
              Comparaison avec {huntFriend.username}
            </span>
            <Link
              href={`/friends/${huntFriend.id}`}
              className="flex items-center gap-1.5 rounded-md border border-border bg-card px-2.5 py-1.5 text-xs font-medium text-foreground transition-colors hover:bg-muted"
            >
              <Users2 className="h-3.5 w-3.5" />
              Voir sa collection
            </Link>
            <div className="flex flex-wrap gap-1.5">
              {HUNT_COLORS.map(hc => (
                <button
                  key={hc.value}
                  type="button"
                  onClick={() => toggleHuntColor(hc.value)}
                  className={cn(
                    'rounded-md border px-2.5 py-1 text-xs font-medium transition-colors',
                    huntColorFilter.includes(hc.value)
                      ? hc.cls + ' bg-muted'
                      : 'border-border text-muted-foreground hover:bg-muted',
                  )}
                >
                  {hc.label}
                </button>
              ))}
            </div>
            <button
              type="button"
              onClick={() => { setHuntFriend(null); setHuntColorFilter([]) }}
              className="ml-auto rounded-md p-1 text-muted-foreground hover:bg-muted"
            >
              <X className="h-4 w-4" />
            </button>
          </div>
        )}

        <p className="text-sm text-muted-foreground">
          <span className="font-medium text-foreground">{caughtCount}</span> /{' '}
          {items.length} {isViewMode ? 'attrapé' : 'attrapé'}{caughtCount > 1 ? 's' : ''} —{' '}
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
            href={isViewMode ? `/friends/${viewAs!.userId}?cat=${n.category}` : n.href}
            className={cn(
              'rounded-md px-3 py-1.5 text-center text-sm font-medium transition-colors',
              n.category === category ? 'bg-primary text-primary-foreground' : 'text-muted-foreground hover:bg-muted',
            )}
          >
            {n.label}
          </Link>
        ))}
      </nav>

      <FilterBar category={category} readOnly={isViewMode}>{specificFilters}</FilterBar>

      {filteredItems.length === 0 ? (
        <p className="mt-16 text-center text-sm text-muted-foreground">
          Aucune créature ne correspond à vos filtres.
        </p>
      ) : sortByLocation ? (
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
        <section className="mt-6">{itemGrid(filteredItems)}</section>
      )}
    </main>
  )
}
