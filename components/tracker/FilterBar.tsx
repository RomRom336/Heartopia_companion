'use client'

import type { ReactNode } from 'react'
import { Check, Loader2, Search } from 'lucide-react'
import { useState } from 'react'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Switch } from '@/components/ui/switch'
import { Button } from '@/components/ui/button'
import { useTrackerStore } from '@/store/useTrackerStore'
import { useAuth } from '@/components/auth-provider'
import { createClient } from '@/utils/supabase/client'
import type { WeatherType, TimePeriod } from '@/types/database.types'
import type { TrackerCategory } from '@/store/useTrackerStore'

const WEATHERS: WeatherType[] = ['Soleil', 'Pluie', 'Neige', 'Arc-en-ciel']
const TIMES: TimePeriod[]     = ['Nuit', 'Matin', 'Aprem', 'Soirée']

const TIME_RANGES: Record<TimePeriod, string> = {
  Nuit:   '1h – 7h',
  Matin:  '7h – 13h',
  Aprem:  '13h – 19h',
  Soirée: '19h – 1h',
}

const LEVEL_CONFIG: Record<Exclude<TrackerCategory, 'Tous'>, {
  label: string
  field: 'fishing_passion' | 'bug_passion' | 'bird_passion'
  store: 'maxFishLevel' | 'maxInsectLevel' | 'maxBirdLevel'
}> = {
  Poissons: { label: 'Pêche niv.',    field: 'fishing_passion', store: 'maxFishLevel' },
  Insectes: { label: 'Insectes niv.', field: 'bug_passion',     store: 'maxInsectLevel' },
  Oiseaux:  { label: 'Oiseaux niv.',  field: 'bird_passion',    store: 'maxBirdLevel' },
}

export function FilterBar({
  children,
  category,
  hideCaughtLabel = 'Cacher attrapés',
  readOnly = false,
}: {
  children?: ReactNode
  category?: TrackerCategory
  hideCaughtLabel?: string
  readOnly?: boolean
}) {
  const { user } = useAuth()

  const searchQuery       = useTrackerStore(s => s.searchQuery)
  const setSearchQuery    = useTrackerStore(s => s.setSearchQuery)
  const hideCaught        = useTrackerStore(s => s.hideCaught)
  const setHideCaught     = useTrackerStore(s => s.setHideCaught)
  const hideEvents        = useTrackerStore(s => s.hideEvents)
  const setHideEvents     = useTrackerStore(s => s.setHideEvents)
  const showIgnored       = useTrackerStore(s => s.showIgnored)
  const setShowIgnored    = useTrackerStore(s => s.setShowIgnored)
  const maxFishLevel      = useTrackerStore(s => s.maxFishLevel)
  const setMaxFishLevel   = useTrackerStore(s => s.setMaxFishLevel)
  const maxInsectLevel    = useTrackerStore(s => s.maxInsectLevel)
  const setMaxInsectLevel = useTrackerStore(s => s.setMaxInsectLevel)
  const maxBirdLevel      = useTrackerStore(s => s.maxBirdLevel)
  const setMaxBirdLevel   = useTrackerStore(s => s.setMaxBirdLevel)
  const selectedWeather      = useTrackerStore(s => s.selectedWeather)
  const strictWeather        = useTrackerStore(s => s.strictWeather)
  const toggleWeather        = useTrackerStore(s => s.toggleWeather)
  const toggleStrictWeather  = useTrackerStore(s => s.toggleStrictWeather)
  const selectedTime         = useTrackerStore(s => s.selectedTime)
  const strictTime           = useTrackerStore(s => s.strictTime)
  const toggleTime           = useTrackerStore(s => s.toggleTime)
  const toggleStrictTime     = useTrackerStore(s => s.toggleStrictTime)

  const [saving, setSaving] = useState(false)
  const [saved, setSaved]   = useState(false)

  const levelValue = category === 'Poissons' ? maxFishLevel
    : category === 'Insectes' ? maxInsectLevel
    : category === 'Oiseaux'  ? maxBirdLevel
    : null

  const setLevelValue = category === 'Poissons' ? setMaxFishLevel
    : category === 'Insectes' ? setMaxInsectLevel
    : category === 'Oiseaux'  ? setMaxBirdLevel
    : null

  const handleSaveLevel = async () => {
    if (!user || !category) return
    setSaving(true)
    const payload = category === 'Tous'
      ? { id: user.id, fishing_passion: maxFishLevel, bug_passion: maxInsectLevel, bird_passion: maxBirdLevel }
      : { id: user.id, [LEVEL_CONFIG[category].field]: levelValue }
    const { error } = await createClient()
      .from('profiles')
      .upsert(payload, { onConflict: 'id' })
    if (error) { console.error('[FilterBar] UPSERT error:', error); setSaving(false); return }
    setSaving(false)
    setSaved(true)
    setTimeout(() => setSaved(false), 2000)
  }

  const showLevel    = !readOnly && category && category !== 'Tous' && levelValue !== null && setLevelValue !== null
  const showAllLevels = !readOnly && category === 'Tous'

  return (
    <div className="flex flex-col gap-4 rounded-xl border border-border bg-card p-4 shadow-sm">
      {/* Ligne 1 : recherche + niveau + hide caught */}
      <div className="flex flex-wrap items-center gap-3">
        <div className="relative min-w-0 flex-1">
          <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <Input
            type="search"
            placeholder="Rechercher une créature…"
            value={searchQuery}
            onChange={e => setSearchQuery(e.target.value)}
            className="pl-9"
            aria-label="Recherche"
          />
        </div>

        {showLevel && (
          <div className="flex items-center gap-2">
            <Label className="whitespace-nowrap text-xs text-muted-foreground">
              {LEVEL_CONFIG[category as Exclude<TrackerCategory, 'Tous'>].label}
            </Label>
            <Input
              type="number"
              min={1}
              max={100}
              value={levelValue}
              onChange={e => setLevelValue!(Number(e.target.value) || 1)}
              className="w-16"
            />
            {user && (
              <Button size="sm" variant="outline" onClick={handleSaveLevel} disabled={saving}>
                {saving ? <Loader2 className="h-3.5 w-3.5 animate-spin" />
                  : saved ? <Check className="h-3.5 w-3.5" /> : null}
                <span>{saved ? 'Sauvegardé' : 'Sauvegarder'}</span>
              </Button>
            )}
          </div>
        )}

        {showAllLevels && (
          <div className="flex flex-wrap items-center gap-2">
            <div className="flex items-center gap-1.5">
              <Label className="whitespace-nowrap text-xs text-muted-foreground">🎣</Label>
              <Input type="number" min={1} max={100} value={maxFishLevel}
                onChange={e => setMaxFishLevel(Number(e.target.value) || 1)} className="w-16" />
            </div>
            <div className="flex items-center gap-1.5">
              <Label className="whitespace-nowrap text-xs text-muted-foreground">🦋</Label>
              <Input type="number" min={1} max={100} value={maxInsectLevel}
                onChange={e => setMaxInsectLevel(Number(e.target.value) || 1)} className="w-16" />
            </div>
            <div className="flex items-center gap-1.5">
              <Label className="whitespace-nowrap text-xs text-muted-foreground">🐦</Label>
              <Input type="number" min={1} max={100} value={maxBirdLevel}
                onChange={e => setMaxBirdLevel(Number(e.target.value) || 1)} className="w-16" />
            </div>
            {user && (
              <Button size="sm" variant="outline" onClick={handleSaveLevel} disabled={saving}>
                {saving ? <Loader2 className="h-3.5 w-3.5 animate-spin" />
                  : saved ? <Check className="h-3.5 w-3.5" /> : null}
                <span>{saved ? 'Sauvegardé' : 'Sauvegarder'}</span>
              </Button>
            )}
          </div>
        )}

        <div className="flex items-center gap-2">
          <Switch id="hide-caught" checked={hideCaught} onCheckedChange={setHideCaught} />
          <Label htmlFor="hide-caught" className="cursor-pointer whitespace-nowrap">
            {hideCaughtLabel}
          </Label>
        </div>

        <div className="flex items-center gap-2">
          <Switch id="hide-events" checked={hideEvents} onCheckedChange={setHideEvents} />
          <Label htmlFor="hide-events" className="cursor-pointer whitespace-nowrap">
            Masquer événements
          </Label>
        </div>

        <div className="flex items-center gap-2">
          <Switch id="show-ignored" checked={showIgnored} onCheckedChange={setShowIgnored} />
          <Label htmlFor="show-ignored" className="cursor-pointer whitespace-nowrap">
            Afficher ignorés
          </Label>
        </div>
      </div>

      {/* Météo */}
      <div className="flex flex-wrap items-center gap-2">
        <Label className="text-xs uppercase tracking-wide text-muted-foreground">Météo</Label>
        {WEATHERS.map(w => (
          <Button
            key={w}
            size="sm"
            variant={selectedWeather.includes(w) ? 'default' : 'outline'}
            onClick={() => toggleWeather(w)}
            type="button"
          >
            {w}
          </Button>
        ))}
        {selectedWeather.length > 0 && (
          <Button
            size="sm"
            variant={strictWeather ? 'default' : 'outline'}
            onClick={toggleStrictWeather}
            type="button"
            className={strictWeather ? 'bg-amber-500 hover:bg-amber-600 border-amber-500 text-white' : 'text-muted-foreground'}
          >
            Strict
          </Button>
        )}
      </div>

      {/* Créneaux */}
      <div className="flex flex-wrap items-center gap-2">
        <Label className="text-xs uppercase tracking-wide text-muted-foreground">Créneau</Label>
        {TIMES.map(t => (
          <div key={t} className="group relative">
            <Button
              size="sm"
              variant={selectedTime.includes(t) ? 'default' : 'outline'}
              onClick={() => toggleTime(t)}
              type="button"
            >
              {t}
            </Button>
            <div className="pointer-events-none absolute bottom-full left-1/2 mb-1.5 -translate-x-1/2 whitespace-nowrap rounded-md border border-border bg-card px-2 py-1 text-xs text-card-foreground shadow-sm opacity-0 transition-opacity group-hover:opacity-100">
              {TIME_RANGES[t]}
            </div>
          </div>
        ))}
        {selectedTime.length > 0 && (
          <Button
            size="sm"
            variant={strictTime ? 'default' : 'outline'}
            onClick={toggleStrictTime}
            type="button"
            className={strictTime ? 'bg-amber-500 hover:bg-amber-600 border-amber-500 text-white' : 'text-muted-foreground'}
          >
            Strict
          </Button>
        )}
      </div>

      {/* Filtres spécifiques à la sous-route */}
      {children && (
        <div className="flex flex-col gap-3 border-t border-border pt-3">
          {children}
        </div>
      )}
    </div>
  )
}
