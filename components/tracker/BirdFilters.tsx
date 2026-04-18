'use client'

import { Button } from '@/components/ui/button'
import { Label } from '@/components/ui/label'
import { useTrackerStore } from '@/store/useTrackerStore'

export function BirdFilters({ locations }: { locations: string[] }) {
  const specificFilters = useTrackerStore(s => s.specificFilters)
  const toggle = useTrackerStore(s => s.toggleSpecificFilter)
  const selected = specificFilters.exact_location ?? []

  return (
    <div className="flex flex-wrap items-center gap-2">
      <Label className="text-xs uppercase tracking-wide text-muted-foreground">
        Localisation
      </Label>
      {locations.map(l => (
        <Button
          key={l}
          size="sm"
          variant={selected.includes(l) ? 'default' : 'outline'}
          onClick={() => toggle('exact_location', l)}
          type="button"
        >
          {l}
        </Button>
      ))}
    </div>
  )
}
