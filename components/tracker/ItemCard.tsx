'use client'

import { useState } from 'react'
import { AlertCircle, Coins, Star } from 'lucide-react'
import { Badge } from '@/components/ui/badge'
import { cn } from '@/lib/utils'
import type { TrackerItem, WeatherType, TimePeriod } from '@/types/database.types'

const IMG_FOLDER: Record<string, string> = {
  Poisson: 'fish',
  Insecte: 'insects',
  Oiseau:  'birds',
}

const IMG_BG: Record<string, string> = {
  Poisson: 'from-blue-400/20 via-blue-400/10 to-transparent',
  Insecte: 'from-green-400/20 via-green-400/10 to-transparent',
  Oiseau:  'from-amber-400/20 via-amber-400/10 to-transparent',
}

const WEATHER_EMOJI: Record<WeatherType, string> = {
  Soleil: '☀️', Pluie: '🌧️', Neige: '❄️', 'Arc-en-ciel': '🌈',
}
const TIME_HOURS: Record<TimePeriod, string> = {
  Matin: '7h–13h', Aprem: '13h–19h', Soirée: '19h–1h', Nuit: '1h–7h',
}
const ALL_TIMES: TimePeriod[] = ['Nuit', 'Matin', 'Aprem', 'Soirée']

type HuntColor = 'red' | 'orange' | 'green'

export function ItemCard({
  item,
  bestStar,
  onStarClick,
  readOnly = false,
  huntInfo,
}: {
  item: TrackerItem
  bestStar: number | undefined
  onStarClick: (star: number) => void
  readOnly?: boolean
  huntInfo?: {
    color: HuntColor
    label?: string
    friendStar?: number
    friendUsername?: string
  }
}) {
  const [imgError, setImgError] = useState(false)
  const caught  = bestStar != null
  const isAllDay = ALL_TIMES.every(t => item.time.includes(t))

  const borderClass = huntInfo
    ? huntInfo.color === 'green'  ? 'border-green-500/70 ring-1 ring-green-500/40'
    : huntInfo.color === 'orange' ? 'border-orange-400/70 ring-1 ring-orange-400/40'
    :                               'border-destructive/50 ring-1 ring-destructive/30'
    : caught ? 'border-accent/60 ring-1 ring-accent/40' : 'border-border'

  const bgClass = huntInfo
    ? huntInfo.color === 'green'  ? 'bg-green-500/5'
    : huntInfo.color === 'orange' ? 'bg-orange-400/5'
    :                               'bg-destructive/5'
    : ''

  const imgFolder = IMG_FOLDER[item.type]
  const imgSrc    = `/${imgFolder}/${encodeURIComponent(item.name_en)}.webp`
  const imgBg     = IMG_BG[item.type]

  return (
    <article className={cn(
      'group flex flex-col overflow-hidden rounded-xl border shadow-sm transition-all hover:shadow-md',
      'bg-card', bgClass, borderClass,
    )}>

      {/* Image */}
      <div className={cn(
        'relative flex h-36 items-end justify-center overflow-hidden bg-gradient-to-b',
        imgBg,
      )}>
        {!imgError && (
          <img
            src={imgSrc}
            alt={item.name}
            onError={() => setImgError(true)}
            className={cn(
              'h-32 w-auto object-contain drop-shadow-[0_4px_10px_rgba(0,0,0,0.15)]',
              'transition-transform duration-300 group-hover:scale-105',
              caught ? 'opacity-100' : 'opacity-60 grayscale',
            )}
          />
        )}
      </div>

      <div className="flex flex-1 flex-col gap-3 p-4">

        {/* Nom + niveau + type */}
        <div className="flex items-start justify-between gap-2">
          <div className="flex min-w-0 items-baseline gap-2">
            <h3 className="font-semibold leading-tight">{item.name}</h3>
            <span className="shrink-0 text-xs text-muted-foreground">Niv.&nbsp;{item.passion_level}</span>
          </div>
          <Badge variant="muted" className="shrink-0">{item.type}</Badge>
        </div>

        {/* Hunt label */}
        {huntInfo?.label && (
          <p className={cn(
            'text-xs font-medium',
            huntInfo.color === 'orange' ? 'text-orange-500' : '',
          )}>
            {huntInfo.label}
          </p>
        )}

        {/* Lieu + infos */}
        <div className="flex flex-wrap items-center gap-1.5">
          {item.exact_location && (
            <span className="text-xs text-muted-foreground">{item.exact_location}</span>
          )}
          {item.location_type && <Badge variant="outline">{item.location_type}</Badge>}
          {item.shadow_size?.map(s => (
            <Badge key={s} variant="outline">Ombre {s}</Badge>
          ))}
          {item.special_condition && (
            <Badge variant="outline" className="gap-1 text-amber-600 dark:text-amber-400">
              <AlertCircle className="h-3 w-3" />
              {item.special_condition}
            </Badge>
          )}
        </div>

        {/* Météo */}
        <div className="flex items-center gap-2">
          <span className="w-14 shrink-0 text-xs text-muted-foreground">Météo</span>
          <div className="flex flex-wrap gap-1">
            {item.weather.map(w => (
              <span key={w} title={w}
                className="flex h-7 w-7 items-center justify-center rounded-md border border-border bg-muted/40 text-base">
                {WEATHER_EMOJI[w]}
              </span>
            ))}
          </div>
        </div>

        {/* Horaires */}
        <div className="flex items-center gap-2">
          <span className="w-14 shrink-0 text-xs text-muted-foreground">Horaires</span>
          {isAllDay ? (
            <span className="text-xs font-medium text-foreground">Toute la journée</span>
          ) : (
            <div className="flex flex-wrap gap-1">
              {item.time.map(t => (
                <span key={t} className="group relative">
                  <span className="rounded-md border border-border bg-muted/40 px-1.5 py-0.5 text-xs font-medium cursor-default">
                    {t}
                  </span>
                  <span className="pointer-events-none absolute bottom-full left-1/2 mb-1.5 -translate-x-1/2 whitespace-nowrap rounded-md border border-border bg-card px-2 py-1 text-xs text-card-foreground shadow-sm opacity-0 transition-opacity group-hover:opacity-100 z-10">
                    {TIME_HOURS[t]}
                  </span>
                </span>
              ))}
            </div>
          )}
        </div>

        {/* Prix */}
        <div className="flex items-center gap-1 text-xs text-muted-foreground">
          <Coins className="h-3 w-3" />
          <span className="tabular-nums">
            {item.sell_price_1_star}
            <span className="mx-1 opacity-40">→</span>
            {item.sell_price_5_star} G
          </span>
        </div>

        {/* Étoiles */}
        <div className="mt-auto flex flex-col gap-1.5">
          {/* Nos étoiles */}
          <div className="flex items-center justify-between gap-2">
            <span className="text-xs text-muted-foreground">
              {caught ? `Meilleure : ${bestStar}★` : 'Non attrapé'}
            </span>
            <div className="flex gap-0.5" role="radiogroup" aria-label="Meilleure étoile obtenue">
              {[1, 2, 3, 4, 5].map(n => {
                const filled    = bestStar != null && n <= bestStar
                const isCurrent = bestStar === n
                return (
                  <button
                    key={n}
                    type="button"
                    role="radio"
                    aria-checked={isCurrent}
                    disabled={readOnly}
                    onClick={() => !readOnly && onStarClick(n)}
                    className={cn(
                      'rounded p-0.5 transition-transform focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring',
                      readOnly ? 'cursor-default' : 'hover:scale-110',
                    )}
                  >
                    <Star className={cn(
                      'h-5 w-5 transition-colors',
                      filled ? 'fill-accent text-accent' : 'text-muted-foreground/40',
                    )} />
                  </button>
                )
              })}
            </div>
          </div>

          {/* Étoiles de l'ami en mode chasse */}
          {huntInfo && huntInfo.friendUsername && (
            <div className="flex items-center justify-between gap-2">
              <span className="text-xs text-muted-foreground">{huntInfo.friendUsername} :</span>
              <div className="flex gap-0.5">
                {[1, 2, 3, 4, 5].map(n => {
                  const filled = huntInfo.friendStar != null && n <= huntInfo.friendStar
                  return (
                    <Star key={n} className={cn(
                      'h-4 w-4',
                      filled ? 'fill-orange-400 text-orange-400' : 'text-muted-foreground/25',
                    )} />
                  )
                })}
              </div>
            </div>
          )}
        </div>
      </div>
    </article>
  )
}
