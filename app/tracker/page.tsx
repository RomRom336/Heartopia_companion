import { createClient } from '@/utils/supabase/server'
import { TrackerView } from '@/components/tracker/TrackerView'
import {
  fishToTrackerItem,
  insectToTrackerItem,
  birdToTrackerItem,
} from '@/types/database.types'
import type { DbFish, DbInsect, DbBird } from '@/types/database.types'

export default async function TrackerPage() {
  const supabase = await createClient()

  const [fishRes, insectRes, birdRes] = await Promise.all([
    supabase.from('fish').select('*').order('passion_level').order('name'),
    supabase.from('insect').select('*').order('passion_level').order('name'),
    supabase.from('bird').select('*').order('passion_level').order('name'),
  ])

  const items = [
    ...((fishRes.data ?? []) as DbFish[]).map(fishToTrackerItem),
    ...((insectRes.data ?? []) as DbInsect[]).map(insectToTrackerItem),
    ...((birdRes.data ?? []) as DbBird[]).map(birdToTrackerItem),
  ]

  return <TrackerView items={items} category="Tous" title="Tracker" />
}
