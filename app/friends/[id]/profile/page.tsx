import { notFound, redirect } from 'next/navigation'
import Link from 'next/link'
import { ArrowLeft } from 'lucide-react'
import { createClient } from '@/utils/supabase/server'
import { Button } from '@/components/ui/button'
import { CompareButton } from '@/components/friends/CompareButton'

type Props = { params: Promise<{ id: string }> }

export async function generateMetadata({ params }: Props) {
  const { id } = await params
  const supabase = await createClient()
  const { data } = await supabase.from('profiles').select('username').eq('id', id).maybeSingle()
  return { title: data?.username ? `Profil de ${data.username}` : 'Profil' }
}

type StatBlock = { caught: number; total: number; withinLevel: number; caughtWithin: number }

function StatCard({
  emoji, label, level, stat,
}: {
  emoji: string
  label: string
  level: number | null
  stat: StatBlock
}) {
  const remaining = level != null ? stat.withinLevel - stat.caughtWithin : null
  return (
    <div className="rounded-xl border border-border bg-card p-4">
      <div className="mb-3 flex items-center gap-2">
        <span className="text-xl">{emoji}</span>
        <div>
          <p className="font-semibold">{label}</p>
          {level != null && <p className="text-xs text-muted-foreground">Niv.&nbsp;{level}</p>}
        </div>
      </div>
      <div className="space-y-1.5 text-sm">
        <div className="flex justify-between">
          <span className="text-muted-foreground">Attrapés</span>
          <span className="font-medium">{stat.caught} / {stat.total}</span>
        </div>
        {level != null && (
          <div className="flex justify-between">
            <span className="text-muted-foreground">À son niveau</span>
            <span className="font-medium">{stat.caughtWithin} / {stat.withinLevel}</span>
          </div>
        )}
        {remaining != null && remaining > 0 && (
          <div className="flex justify-between">
            <span className="text-muted-foreground">Restants</span>
            <span className="font-semibold text-primary">{remaining}</span>
          </div>
        )}
      </div>
      {level != null && stat.withinLevel > 0 && (
        <div className="mt-3 h-1.5 w-full overflow-hidden rounded-full bg-muted">
          <div
            className="h-full rounded-full bg-primary transition-all"
            style={{ width: `${Math.round((stat.caughtWithin / stat.withinLevel) * 100)}%` }}
          />
        </div>
      )}
    </div>
  )
}

export default async function FriendProfilePage({ params }: Props) {
  const { id } = await params
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const { data: friendship } = await supabase
    .from('friendships')
    .select('id')
    .eq('status', 'accepted')
    .or(`and(user_id.eq.${user.id},friend_id.eq.${id}),and(user_id.eq.${id},friend_id.eq.${user.id})`)
    .maybeSingle()

  if (!friendship) notFound()

  const { data: profile } = await supabase
    .from('profiles')
    .select('username, fishing_passion, bug_passion, bird_passion')
    .eq('id', id)
    .maybeSingle()

  if (!profile?.username) notFound()

  const fishLevel   = profile.fishing_passion as number | null
  const insectLevel = profile.bug_passion     as number | null
  const birdLevel   = profile.bird_passion    as number | null

  // Collection de l'ami
  const { data: collection } = await supabase
    .from('user_collection')
    .select('item_id, item_type')
    .eq('user_id', id)

  const fishCaught   = collection?.filter(r => r.item_type === 'Poisson').length ?? 0
  const insectCaught = collection?.filter(r => r.item_type === 'Insecte').length ?? 0
  const birdCaught   = collection?.filter(r => r.item_type === 'Oiseau').length  ?? 0
  const caughtIds    = new Set(collection?.map(r => r.item_id as string) ?? [])

  // Totaux et items dans le niveau de passion
  const [fishAll, insectAll, birdAll] = await Promise.all([
    supabase.from('fish').select('id, passion_level'),
    supabase.from('insect').select('id, passion_level'),
    supabase.from('bird').select('id, passion_level'),
  ])

  const fishTotal   = fishAll.data?.length   ?? 0
  const insectTotal = insectAll.data?.length ?? 0
  const birdTotal   = birdAll.data?.length   ?? 0

  const fishWithin       = fishAll.data?.filter(i => fishLevel   != null && i.passion_level <= fishLevel)   ?? []
  const insectWithin     = insectAll.data?.filter(i => insectLevel != null && i.passion_level <= insectLevel) ?? []
  const birdWithin       = birdAll.data?.filter(i => birdLevel   != null && i.passion_level <= birdLevel)   ?? []

  const fishCaughtWithin   = fishWithin.filter(i => caughtIds.has(i.id)).length
  const insectCaughtWithin = insectWithin.filter(i => caughtIds.has(i.id)).length
  const birdCaughtWithin   = birdWithin.filter(i => caughtIds.has(i.id)).length

  const stats = {
    fish:   { caught: fishCaught,   total: fishTotal,   withinLevel: fishWithin.length,   caughtWithin: fishCaughtWithin },
    insect: { caught: insectCaught, total: insectTotal, withinLevel: insectWithin.length, caughtWithin: insectCaughtWithin },
    bird:   { caught: birdCaught,   total: birdTotal,   withinLevel: birdWithin.length,   caughtWithin: birdCaughtWithin },
  }

  const totalCaught = fishCaught + insectCaught + birdCaught
  const grandTotal  = fishTotal + insectTotal + birdTotal

  return (
    <main className="container max-w-2xl py-10">

      <Link href="/friends" className="mb-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground">
        <ArrowLeft className="h-4 w-4" />
        Retour aux amis
      </Link>

      {/* En-tête profil */}
      <div className="mb-8 flex items-center gap-4">
        <div className="flex h-16 w-16 shrink-0 items-center justify-center rounded-full bg-primary/10 text-2xl font-bold text-primary">
          {profile.username.slice(0, 2).toUpperCase()}
        </div>
        <div>
          <h1 className="text-2xl font-bold">{profile.username}</h1>
          <p className="text-sm text-muted-foreground">
            {totalCaught} / {grandTotal} créatures attrapées
          </p>
        </div>
      </div>

      {/* Niveaux de passion */}
      <div className="mb-8 flex flex-wrap gap-4">
        {fishLevel   != null && <span className="text-base font-medium text-muted-foreground">🎣 Niv.&nbsp;<span className="text-foreground">{fishLevel}</span></span>}
        {insectLevel != null && <span className="text-base font-medium text-muted-foreground">🦋 Niv.&nbsp;<span className="text-foreground">{insectLevel}</span></span>}
        {birdLevel   != null && <span className="text-base font-medium text-muted-foreground">🐦 Niv.&nbsp;<span className="text-foreground">{birdLevel}</span></span>}
      </div>

      {/* Statistiques */}
      <div className="mb-8 grid grid-cols-1 gap-4 sm:grid-cols-3">
        <StatCard emoji="🎣" label="Poissons" level={fishLevel}   stat={stats.fish}   />
        <StatCard emoji="🦋" label="Insectes" level={insectLevel} stat={stats.insect} />
        <StatCard emoji="🐦" label="Oiseaux"  level={birdLevel}   stat={stats.bird}   />
      </div>

      {/* Actions */}
      <div className="flex flex-wrap gap-3">
        <Button asChild size="lg">
          <Link href={`/friends/${id}`}>Voir la collection</Link>
        </Button>
        <CompareButton friendId={id} username={profile.username} />
      </div>
    </main>
  )
}
