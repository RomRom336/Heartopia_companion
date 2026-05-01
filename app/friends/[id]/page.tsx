import { notFound, redirect } from 'next/navigation'
import { createClient } from '@/utils/supabase/server'
import { TrackerView } from '@/components/tracker/TrackerView'
import { FishFilters } from '@/components/tracker/FishFilters'
import { InsectFilters } from '@/components/tracker/InsectFilters'
import { BirdFilters } from '@/components/tracker/BirdFilters'
import {
  fishToTrackerItem, insectToTrackerItem, birdToTrackerItem,
} from '@/types/database.types'
import type { DbFish, DbInsect, DbBird, TrackerItem } from '@/types/database.types'
import type { TrackerCategory } from '@/store/useTrackerStore'

type Props = { params: Promise<{ id: string }>; searchParams: Promise<{ cat?: string }> }

export async function generateMetadata({ params }: Props) {
  const { id } = await params
  const supabase = await createClient()
  const { data } = await supabase.from('profiles').select('username').eq('id', id).maybeSingle()
  return { title: data?.username ? `Collection de ${data.username}` : 'Collection' }
}

export default async function FriendTrackerPage({ params, searchParams }: Props) {
  const { id }  = await params
  const { cat } = await searchParams

  const supabase = await createClient()

  // Vérifier que l'utilisateur courant est connecté et ami avec cet utilisateur
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const { data: friendship } = await supabase
    .from('friendships')
    .select('id')
    .eq('status', 'accepted')
    .or(`and(user_id.eq.${user.id},friend_id.eq.${id}),and(user_id.eq.${id},friend_id.eq.${user.id})`)
    .maybeSingle()

  if (!friendship) notFound()

  // Profil de l'ami (username + niveaux de passion)
  const { data: profile } = await supabase
    .from('profiles')
    .select('username, fishing_passion, bug_passion, bird_passion')
    .eq('id', id)
    .maybeSingle()

  if (!profile?.username) notFound()

  // Collection de l'ami
  const { data: collection } = await supabase
    .from('user_collection')
    .select('item_id, best_star')
    .eq('user_id', id)

  const friendBestStars: Record<string, number> = {}
  for (const row of collection ?? []) {
    if (row.best_star != null) friendBestStars[row.item_id as string] = row.best_star as number
  }

  const viewAs = {
    userId: id,
    username: profile.username,
    bestStars: friendBestStars,
    passionLevels: {
      fish:   profile.fishing_passion ?? null,
      insect: profile.bug_passion     ?? null,
      bird:   profile.bird_passion    ?? null,
    },
  }

  const category = (['Tous', 'Poissons', 'Insectes', 'Oiseaux'].includes(cat ?? '')
    ? cat : 'Tous') as TrackerCategory

  // Fetch des items selon la catégorie
  let items: TrackerItem[] = []
  let specificFilters = null
  let title = profile.username

  if (category === 'Tous' || category === 'Poissons') {
    const { data } = await supabase.from('fish').select('*').order('passion_level').order('name')
    const fish = ((data ?? []) as DbFish[]).map(fishToTrackerItem)
    if (category === 'Poissons') {
      items = fish
      title = `${profile.username} — Poissons`
      const exactLocations = Array.from(new Set(fish.map(i => i.exact_location).filter(Boolean))).sort() as string[]
      specificFilters = <FishFilters exactLocations={exactLocations} />
    } else {
      items = [...items, ...fish]
    }
  }
  if (category === 'Tous' || category === 'Insectes') {
    const { data } = await supabase.from('insect').select('*').order('passion_level').order('name')
    const insects = ((data ?? []) as DbInsect[]).map(insectToTrackerItem)
    if (category === 'Insectes') {
      items = insects
      title = `${profile.username} — Insectes`
      const locations = Array.from(new Set(insects.map(i => i.exact_location).filter(Boolean))).sort() as string[]
      specificFilters = <InsectFilters locations={locations} />
    } else {
      items = [...items, ...insects]
    }
  }
  if (category === 'Tous' || category === 'Oiseaux') {
    const { data } = await supabase.from('bird').select('*').order('passion_level').order('name')
    const birds = ((data ?? []) as DbBird[]).map(birdToTrackerItem)
    if (category === 'Oiseaux') {
      items = birds
      title = `${profile.username} — Oiseaux`
      const locations = Array.from(new Set(birds.map(i => i.exact_location).filter(Boolean))).sort() as string[]
      specificFilters = <BirdFilters locations={locations} />
    } else {
      items = [...items, ...birds]
    }
  }

  if (category === 'Tous') title = profile.username

  return (
    <TrackerView
      items={items}
      category={category}
      title={title}
      specificFilters={specificFilters ?? undefined}
      viewAs={viewAs}
    />
  )
}
