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

const WEATHERS: WeatherType[] = ['Soleil', 'Pluie', 'Neige', 'Arc-en-ciel']
const TIMES: TimePeriod[]     = ['Nuit', 'Matin', 'Aprem', 'Soirée']

export function FilterBar({ children }: { children?: ReactNode }) {
  const { user } = useAuth()

  const searchQuery     = useTrackerStore(s => s.searchQuery)
  const setSearchQuery  = useTrackerStore(s => s.setSearchQuery)
  const hideCaught      = useTrackerStore(s => s.hideCaught)
  const setHideCaught   = useTrackerStore(s => s.setHideCaught)
  const maxFishLevel    = useTrackerStore(s => s.maxFishLevel)
  const setMaxFishLevel = useTrackerStore(s => s.setMaxFishLevel)
  const maxInsectLevel    = useTrackerStore(s => s.maxInsectLevel)
  const setMaxInsectLevel = useTrackerStore(s => s.setMaxInsectLevel)
  const maxBirdLevel    = useTrackerStore(s => s.maxBirdLevel)
  const setMaxBirdLevel = useTrackerStore(s => s.setMaxBirdLevel)
  const selectedWeather = useTrackerStore(s => s.selectedWeather)
  const toggleWeather   = useTrackerStore(s => s.toggleWeather)
  const selectedTime    = useTrackerStore(s => s.selectedTime)
  const toggleTime      = useTrackerStore(s => s.toggleTime)

  const [saving, setSaving] = useState(false)
  const [saved, setSaved]   = useState(false)

  const handleSaveLevels = async () => {
    if (!user) return
    setSaving(true)
    const { error } = await createClient()
      .from('profiles')
      .upsert(
        { id: user.id, fishing_passion: maxFishLevel, bug_passion: maxInsectLevel, bird_passion: maxBirdLevel },
        { onConflict: 'id' },
      )
    if (error) {
      console.error('[FilterBar] UPSERT error:', error)
      setSaving(false)
      return
    }
    setSaving(false)
    setSaved(true)
    setTimeout(() => setSaved(false), 2000)
  }

  return (
    <div className="flex flex-col gap-4 rounded-xl border border-border bg-card p-4 shadow-sm">
      {/* Ligne 1 : recherche + hide caught */}
      <div className="flex flex-col gap-3 md:flex-row md:items-center">
        <div className="relative flex-1">
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

        <div className="flex items-center gap-2">
          <Switch
            id="hide-caught"
            checked={hideCaught}
            onCheckedChange={setHideCaught}
          />
          <Label htmlFor="hide-caught" className="cursor-pointer whitespace-nowrap">
            Cacher attrapés
          </Label>
        </div>
      </div>

      {/* Ligne 2 : niveaux de passion par type + bouton save */}
      <div className="flex flex-wrap items-end gap-4">
        <div className="flex flex-col gap-1">
          <Label htmlFor="max-fish" className="text-xs text-muted-foreground">Pêche niv. max</Label>
          <Input
            id="max-fish"
            type="number"
            min={1}
            max={100}
            value={maxFishLevel}
            onChange={e => setMaxFishLevel(Number(e.target.value) || 1)}
            className="w-20"
          />
        </div>
        <div className="flex flex-col gap-1">
          <Label htmlFor="max-insect" className="text-xs text-muted-foreground">Insectes niv. max</Label>
          <Input
            id="max-insect"
            type="number"
            min={1}
            max={100}
            value={maxInsectLevel}
            onChange={e => setMaxInsectLevel(Number(e.target.value) || 1)}
            className="w-20"
          />
        </div>
        <div className="flex flex-col gap-1">
          <Label htmlFor="max-bird" className="text-xs text-muted-foreground">Oiseaux niv. max</Label>
          <Input
            id="max-bird"
            type="number"
            min={1}
            max={100}
            value={maxBirdLevel}
            onChange={e => setMaxBirdLevel(Number(e.target.value) || 1)}
            className="w-20"
          />
        </div>
        {user && (
          <Button size="sm" variant="outline" onClick={handleSaveLevels} disabled={saving} className="mb-0.5">
            {saving ? <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" /> : saved ? <Check className="mr-1.5 h-3.5 w-3.5" /> : null}
            {saved ? 'Sauvegardé' : 'Sauvegarder'}
          </Button>
        )}
      </div>

      {/* Ligne 3 : météos (multiselect) */}
      <div className="flex flex-wrap items-center gap-2">
        <Label className="text-xs uppercase tracking-wide text-muted-foreground">
          Météo
        </Label>
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
      </div>

      {/* Ligne 4 : créneaux (multiselect) */}
      <div className="flex flex-wrap items-center gap-2">
        <Label className="text-xs uppercase tracking-wide text-muted-foreground">
          Créneau
        </Label>
        {TIMES.map(t => (
          <Button
            key={t}
            size="sm"
            variant={selectedTime.includes(t) ? 'default' : 'outline'}
            onClick={() => toggleTime(t)}
            type="button"
          >
            {t}
          </Button>
        ))}
      </div>

      {/* Slot pour filtres spécifiques à la sous-route */}
      {children && (
        <div className="flex flex-col gap-3 border-t border-border pt-3">
          {children}
        </div>
      )}
    </div>
  )
}
