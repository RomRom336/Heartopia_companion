import { createClient } from '@/utils/supabase/server'
import { CatFoodView } from '@/components/chat/CatFoodView'
import { fishToTrackerItem } from '@/types/database.types'
import type { DbFish } from '@/types/database.types'

export const metadata = { title: 'Nourriture du chat' }

export default async function CatFoodPage() {
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('fish')
    .select('*')
    .order('passion_level', { ascending: true })
    .order('name', { ascending: true })

  if (error) console.error('Cat food fish fetch error:', error)

  const items = ((data ?? []) as DbFish[]).map(fishToTrackerItem)

  const exactLocations = Array.from(
    new Set(items.map(i => i.exact_location).filter(Boolean)),
  ).sort() as string[]

  return <CatFoodView items={items} exactLocations={exactLocations} />
}
