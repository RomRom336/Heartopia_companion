import { createClient } from '@/utils/supabase/server'
import { TrackerView } from '@/components/tracker/TrackerView'
import { InsectFilters } from '@/components/tracker/InsectFilters'
import { insectToTrackerItem } from '@/types/database.types'
import type { DbInsect } from '@/types/database.types'

export default async function InsectTrackerPage() {
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('insect')
    .select('*')
    .order('passion_level', { ascending: true })
    .order('name', { ascending: true })

  if (error) console.error('Insect fetch error:', error)

  const items = ((data ?? []) as DbInsect[]).map(insectToTrackerItem)

  const locations = Array.from(
    new Set(items.map(i => i.exact_location).filter(Boolean)),
  ).sort() as string[]

  return (
    <TrackerView
      items={items}
      category="Insectes"
      title="Insectes"
      specificFilters={<InsectFilters locations={locations} />}
    />
  )
}
