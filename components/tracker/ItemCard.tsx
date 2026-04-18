'use client'

import {
  AlertCircle,
  Clock,
  CloudRain,
  CloudSnow,
  Coins,
  Rainbow,
  Star,
  Sun,
} from 'lucide-react'
import { Badge } from '@/components/ui/badge'
import { cn } from '@/lib/utils'
import type { TrackerItem, WeatherType } from '@/types/database.types'

const WEATHER_ICON: Record<WeatherType, React.ReactNode> = {
  Soleil:        <Sun       className="h-3 w-3" />,
  Pluie:         <CloudRain className="h-3 w-3" />,
  Neige:         <CloudSnow className="h-3 w-3" />,
  'Arc-en-ciel': <Rainbow   className="h-3 w-3" />,
}

export function ItemCard({
  item,
  bestStar,
  onStarClick,
}: {
  item: TrackerItem
  bestStar: number | undefined
  onStarClick: (star: number) => void
}) {
  const caught = bestStar != null

  return (
    <article
      className={cn(
        'flex flex-col overflow-hidden rounded-xl border bg-card shadow-sm transition-all hover:shadow-md',
        caught ? 'border-accent/60 ring-1 ring-accent/40' : 'border-border',
      )}
    >
      <div className="flex flex-1 flex-col gap-3 p-4">
        <div className="flex items-start justify-between gap-2">
          <h3 className="font-semibold leading-tight">{item.name}</h3>
          <Badge variant="muted" className="shrink-0">
            {item.type}
          </Badge>
        </div>

        <p className="text-xs text-muted-foreground">{item.exact_location}</p>

        <div className="flex flex-wrap gap-1.5">
          <Badge variant="secondary">Niv. {item.passion_level}</Badge>

          {item.weather.map(w => (
            <Badge key={w} variant="outline" className="gap-1">
              {WEATHER_ICON[w]}
              {w}
            </Badge>
          ))}

          {item.time.map(t => (
            <Badge key={t} variant="outline" className="gap-1">
              <Clock className="h-3 w-3" />
              {t}
            </Badge>
          ))}

          {item.location_type && (
            <Badge variant="outline">{item.location_type}</Badge>
          )}

          {item.shadow_size?.map(s => (
            <Badge key={s} variant="outline">
              Ombre {s}
            </Badge>
          ))}

          {item.special_condition && (
            <Badge variant="outline" className="gap-1 text-amber-600 dark:text-amber-400">
              <AlertCircle className="h-3 w-3" />
              {item.special_condition}
            </Badge>
          )}
        </div>

        <div className="flex items-center gap-1 text-xs text-muted-foreground">
          <Coins className="h-3 w-3" />
          <span className="tabular-nums">
            {item.sell_price_1_star}
            <span className="mx-1 opacity-40">→</span>
            {item.sell_price_5_star} G
          </span>
        </div>

        {/* 5 étoiles cliquables */}
        <div className="mt-auto flex items-center justify-between gap-2">
          <span className="text-xs text-muted-foreground">
            {caught ? `Meilleure : ${bestStar}★` : 'Non attrapé'}
          </span>
          <div
            className="flex gap-0.5"
            role="radiogroup"
            aria-label="Meilleure étoile obtenue"
          >
            {[1, 2, 3, 4, 5].map(n => {
              const filled    = bestStar != null && n <= bestStar
              const isCurrent = bestStar === n
              return (
                <button
                  key={n}
                  type="button"
                  role="radio"
                  aria-checked={isCurrent}
                  aria-label={`${n} étoile${n > 1 ? 's' : ''}${isCurrent ? ' (actuel — cliquer pour retirer)' : ''}`}
                  onClick={() => onStarClick(n)}
                  className="rounded p-0.5 transition-transform hover:scale-110 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                >
                  <Star
                    className={cn(
                      'h-5 w-5 transition-colors',
                      filled
                        ? 'fill-accent text-accent'
                        : 'text-muted-foreground/40',
                    )}
                  />
                </button>
              )
            })}
          </div>
        </div>
      </div>
    </article>
  )
}
