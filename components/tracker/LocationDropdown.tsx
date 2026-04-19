'use client'

import { Check, ChevronDown } from 'lucide-react'
import { Button } from '@/components/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { useTrackerStore } from '@/store/useTrackerStore'

export function LocationDropdown({ locations }: { locations: string[] }) {
  const specificFilters = useTrackerStore(s => s.specificFilters)
  const toggle          = useTrackerStore(s => s.toggleSpecificFilter)
  const selected        = specificFilters.exact_location ?? []

  const label = selected.length === 0
    ? 'Lieu précis'
    : selected.length === 1
    ? selected[0]
    : `${selected.length} lieux`

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button
          variant={selected.length > 0 ? 'default' : 'outline'}
          size="sm"
          type="button"
          className="gap-1.5"
        >
          {label}
          <ChevronDown className="h-3.5 w-3.5 opacity-70" />
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="start" className="max-h-64 overflow-y-auto bg-card">
        {locations.map(l => (
          <DropdownMenuItem
            key={l}
            onSelect={e => { e.preventDefault(); toggle('exact_location', l) }}
            className="gap-2"
          >
            <Check className={selected.includes(l) ? 'h-4 w-4 opacity-100' : 'h-4 w-4 opacity-0'} />
            {l}
          </DropdownMenuItem>
        ))}
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
