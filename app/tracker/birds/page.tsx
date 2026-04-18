import { createClient } from '@/utils/supabase/server'
import { TrackerView } from '@/components/tracker/TrackerView'
import { BirdFilters } from '@/components/tracker/BirdFilters'
import { birdToTrackerItem } from '@/types/database.types'
import type { DbBird } from '@/types/database.types'

export default async function BirdTrackerPage() {
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('bird')
    .select('*')
    .order('passion_level', { ascending: true })
    .order('name', { ascending: true })

  if (error) console.error('Bird fetch error:', error)

  const items = ((data ?? []) as DbBird[]).map(birdToTrackerItem)

  const locations = Array.from(
    new Set(items.map(i => i.exact_location).filter(Boolean)),
  ).sort() as string[]

  return (
    <TrackerView
      items={items}
      category="Oiseaux"
      title="Oiseaux"
      specificFilters={<BirdFilters locations={locations} />}
    />
  )
}
