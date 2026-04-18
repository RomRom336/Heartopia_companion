'use client'

import { Button } from '@/components/ui/button'
import { Label } from '@/components/ui/label'
import type { FishLocation, ShadowSize } from '@/types/database.types'
import { useTrackerStore } from '@/store/useTrackerStore'

const LOCATIONS: FishLocation[] = ['Mer', 'Lac', 'Rivière']
const SHADOWS: ShadowSize[] = ['Petit', 'Moyen', 'Grand', 'Doré', 'Bleu', 'Or']

export function FishFilters({ exactLocations }: { exactLocations: string[] }) {
  const specificFilters = useTrackerStore(s => s.specificFilters)
  const toggle          = useTrackerStore(s => s.toggleSpecificFilter)
  const selType        = specificFilters.location_type   ?? []
  const selExact       = specificFilters.exact_location  ?? []
  const selShadow      = specificFilters.shadow_size     ?? []

  return (
    <>
      <div className="flex flex-wrap items-center gap-2">
        <Label className="text-xs uppercase tracking-wide text-muted-foreground">
          Type
        </Label>
        {LOCATIONS.map(l => (
          <Button
            key={l}
            size="sm"
            variant={selType.includes(l) ? 'default' : 'outline'}
            onClick={() => toggle('location_type', l)}
            type="button"
          >
            {l}
          </Button>
        ))}
      </div>

      {exactLocations.length > 0 && (
        <div className="flex flex-wrap items-center gap-2">
          <Label className="text-xs uppercase tracking-wide text-muted-foreground">
            Lieu précis
          </Label>
          {exactLocations.map(l => (
            <Button
              key={l}
              size="sm"
              variant={selExact.includes(l) ? 'default' : 'outline'}
              onClick={() => toggle('exact_location', l)}
              type="button"
            >
              {l}
            </Button>
          ))}
        </div>
      )}

      <div className="flex flex-wrap items-center gap-2">
        <Label className="text-xs uppercase tracking-wide text-muted-foreground">
          Ombre
        </Label>
        {SHADOWS.map(s => (
          <Button
            key={s}
            size="sm"
            variant={selShadow.includes(s) ? 'default' : 'outline'}
            onClick={() => toggle('shadow_size', s)}
            type="button"
          >
            {s}
          </Button>
        ))}
      </div>
    </>
  )
}
