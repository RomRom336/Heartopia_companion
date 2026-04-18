import { createClient } from '@/utils/supabase/server'
import { TrackerView } from '@/components/tracker/TrackerView'
import { FishFilters } from '@/components/tracker/FishFilters'
import { fishToTrackerItem } from '@/types/database.types'
import type { DbFish } from '@/types/database.types'

export default async function FishTrackerPage() {
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('fish')
    .select('*')
    .order('passion_level', { ascending: true })
    .order('name', { ascending: true })

  if (error) console.error('Fish fetch error:', error)

  const items = ((data ?? []) as DbFish[]).map(fishToTrackerItem)

  const exactLocations = Array.from(
    new Set(items.map(i => i.exact_location).filter(Boolean)),
  ).sort() as string[]

  return (
    <TrackerView
      items={items}
      category="Poissons"
      title="Poissons"
      specificFilters={<FishFilters exactLocations={exactLocations} />}
    />
  )
}
