'use client'

import { Label } from '@/components/ui/label'
import { LocationDropdown } from '@/components/tracker/LocationDropdown'

export function InsectFilters({ locations }: { locations: string[] }) {
  if (locations.length === 0) return null

  return (
    <div className="flex flex-wrap items-center gap-2">
      <Label className="text-xs uppercase tracking-wide text-muted-foreground">
        Localisation
      </Label>
      <LocationDropdown locations={locations} />
    </div>
  )
}
