'use client'

import { cn } from '@/lib/utils'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import type { TrackerItem, WeatherType, TimePeriod } from '@/types/database.types'

const WEATHER_EMOJI: Record<WeatherType, string> = {
  Soleil: '☀️', Pluie: '🌧️', Neige: '❄️', 'Arc-en-ciel': '🌈',
}
const TIME_HOURS: Record<TimePeriod, string> = {
  Matin: '7h–13h', Aprem: '13h–19h', Soirée: '19h–1h', Nuit: '1h–7h',
}
const ALL_TIMES: TimePeriod[] = ['Nuit', 'Matin', 'Aprem', 'Soirée']

export type CatTestStatus = 'wrong' | 'correct'

export function FishTestCard({
  item,
  status,
  onSet,
}: {
  item: TrackerItem
  status: CatTestStatus | undefined
  onSet: (s: CatTestStatus | null) => void
}) {
  const isAllDay = ALL_TIMES.every(t => item.time.includes(t))

  return (
    <article
      className={cn(
        'flex flex-col overflow-hidden rounded-xl border bg-card shadow-sm transition-all',
        status === 'correct' && 'border-green-500/60 ring-1 ring-green-500/40',
        status === 'wrong'   && 'border-destructive/40 opacity-60',
        !status              && 'border-border',
      )}
    >
      <div className="flex flex-1 flex-col gap-2.5 p-4">
        {/* Nom + niveau */}
        <div className="flex items-start justify-between gap-2">
          <h3 className="font-semibold leading-tight">{item.name}</h3>
          <Badge variant="secondary" className="shrink-0">Niv. {item.passion_level}</Badge>
        </div>

        {/* Lieu */}
        <div className="flex flex-wrap items-center gap-1.5">
          {item.exact_location && (
            <span className="text-xs text-muted-foreground">{item.exact_location}</span>
          )}
          {item.location_type && <Badge variant="outline">{item.location_type}</Badge>}
          {item.shadow_size?.map(s => (
            <Badge key={s} variant="outline">Ombre {s}</Badge>
          ))}
        </div>

        {/* Météo */}
        <div className="flex items-center gap-2">
          <span className="w-14 shrink-0 text-xs text-muted-foreground">Météo</span>
          <div className="flex gap-1">
            {item.weather.map(w => (
              <span key={w} title={w}
                className="flex h-6 w-6 items-center justify-center rounded border border-border bg-muted/40 text-sm">
                {WEATHER_EMOJI[w]}
              </span>
            ))}
          </div>
        </div>

        {/* Horaires */}
        <div className="flex items-center gap-2">
          <span className="w-14 shrink-0 text-xs text-muted-foreground">Horaires</span>
          {isAllDay ? (
            <span className="text-xs font-medium">Toute la journée</span>
          ) : (
            <div className="flex flex-wrap gap-1">
              {item.time.map(t => (
                <span key={t} title={TIME_HOURS[t]}
                  className="rounded-md border border-border bg-muted/40 px-1.5 py-0.5 text-xs font-medium">
                  {t}
                </span>
              ))}
            </div>
          )}
        </div>

        {/* Statut */}
        <div className="mt-auto flex items-center justify-between gap-2 pt-1">
          <span className={cn(
            'text-xs',
            status === 'correct' && 'font-medium text-green-600 dark:text-green-400',
            status === 'wrong'   && 'text-muted-foreground line-through',
            !status              && 'text-muted-foreground',
          )}>
            {status === 'correct' ? '✅ C\'est lui !' : status === 'wrong' ? '❌ Pas le bon' : 'Non testé'}
          </span>
          <div className="flex gap-1.5">
            <Button
              size="sm"
              variant={status === 'wrong' ? 'destructive' : 'outline'}
              className="h-7 px-2 text-xs"
              onClick={() => onSet(status === 'wrong' ? null : 'wrong')}
            >
              ❌
            </Button>
            <Button
              size="sm"
              variant={status === 'correct' ? 'default' : 'outline'}
              className={cn(
                'h-7 px-2 text-xs',
                status === 'correct' && 'bg-green-600 hover:bg-green-700 border-green-600',
              )}
              onClick={() => onSet(status === 'correct' ? null : 'correct')}
            >
              ✅
            </Button>
          </div>
        </div>
      </div>
    </article>
  )
}
