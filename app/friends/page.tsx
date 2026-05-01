'use client'

import { useEffect, useRef, useState } from 'react'
import { Bell, Check, Copy, Loader2, Search, UserMinus, UserPlus, Users, X } from 'lucide-react'
import Link from 'next/link'
import { useAuth } from '@/components/auth-provider'
import { createClient } from '@/utils/supabase/client'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'

type Friend   = { id: string; username: string }
type Received = { rowId: string; from: Friend }
type Sent     = { rowId: string; to: Friend }
type Panel    = null | 'requests' | 'search'

export default function FriendsPage() {
  const { user } = useAuth()

  const [friends,  setFriends]  = useState<Friend[]>([])
  const [received, setReceived] = useState<Received[]>([])
  const [sent,     setSent]     = useState<Sent[]>([])
  const [loading,  setLoading]  = useState(true)
  const [loadErr,  setLoadErr]  = useState<string | null>(null)

  const [panel, setPanel] = useState<Panel>(null)

  const [search,        setSearch]        = useState('')
  const [searchResults, setSearchResults] = useState<Friend[]>([])
  const [searching,     setSearching]     = useState(false)
  const [addingId,      setAddingId]      = useState<string | null>(null)

  const [inviteLink, setInviteLink] = useState<string | null>(null)
  const [copied,     setCopied]     = useState(false)
  const [genLoading, setGenLoading] = useState(false)

  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  useEffect(() => { if (user) load() }, [user])

  const load = async () => {
    if (!user) return
    setLoading(true)
    setLoadErr(null)
    const supabase = createClient()

    const { data: rows, error } = await supabase
      .from('friendships')
      .select('id, user_id, friend_id, status')
      .or(`user_id.eq.${user.id},friend_id.eq.${user.id}`)

    if (error) { setLoadErr(error.message); setLoading(false); return }
    if (!rows?.length) { setFriends([]); setReceived([]); setSent([]); setLoading(false); return }

    const otherIds = rows.map(r => r.user_id === user.id ? r.friend_id : r.user_id)
    const { data: profiles } = await supabase
      .from('profiles')
      .select('id, username')
      .in('id', otherIds)

    const profileMap = new Map((profiles ?? []).map(p => [p.id, p as Friend]))

    const acc: Friend[]   = []
    const rec: Received[] = []
    const snt: Sent[]     = []

    for (const row of rows) {
      const otherId = row.user_id === user.id ? row.friend_id : row.user_id
      const profile = profileMap.get(otherId) ?? { id: otherId, username: '(sans pseudo)' }
      const isSender = row.user_id === user.id

      if (row.status === 'accepted') {
        acc.push(profile)
      } else if (row.status === 'pending') {
        if (isSender) snt.push({ rowId: row.id, to: profile })
        else          rec.push({ rowId: row.id, from: profile })
      }
    }

    setFriends(acc)
    setReceived(rec)
    setSent(snt)
    setLoading(false)
  }

  useEffect(() => {
    if (!user || search.trim().length < 2) { setSearchResults([]); return }
    if (debounceRef.current) clearTimeout(debounceRef.current)
    debounceRef.current = setTimeout(async () => {
      setSearching(true)
      const { data, error } = await createClient()
        .from('profiles')
        .select('id, username')
        .ilike('username', `${search.trim()}%`)
        .neq('id', user.id)
        .not('username', 'is', null)
        .limit(10)
      if (!error) setSearchResults((data ?? []) as Friend[])
      setSearching(false)
    }, 400)
  }, [search, user])

  const relatedIds = new Set([
    ...friends.map(f => f.id),
    ...sent.map(s => s.to.id),
    ...received.map(r => r.from.id),
  ])
  const visibleResults = searchResults.filter(p => !relatedIds.has(p.id))

  const sendRequest = async (to: Friend) => {
    if (!user) return
    setAddingId(to.id)
    const { error } = await createClient().from('friendships')
      .insert({ user_id: user.id, friend_id: to.id, status: 'pending' })
    setAddingId(null)
    if (!error) {
      setSent(s => [...s, { rowId: crypto.randomUUID(), to }])
      setSearchResults(r => r.filter(p => p.id !== to.id))
    }
  }

  const accept = async (rowId: string, from: Friend) => {
    await createClient().from('friendships').update({ status: 'accepted' }).eq('id', rowId)
    setReceived(r => r.filter(x => x.rowId !== rowId))
    setFriends(f => [...f, from])
  }

  const decline = async (rowId: string) => {
    await createClient().from('friendships').delete().eq('id', rowId)
    setReceived(r => r.filter(x => x.rowId !== rowId))
    setSent(s => s.filter(x => x.rowId !== rowId))
  }

  const removeFriend = async (friendId: string) => {
    if (!user) return
    await createClient().from('friendships').delete()
      .or(`and(user_id.eq.${user.id},friend_id.eq.${friendId}),and(user_id.eq.${friendId},friend_id.eq.${user.id})`)
    setFriends(f => f.filter(x => x.id !== friendId))
  }

  const generateLink = async () => {
    if (!user) return
    setGenLoading(true)
    const supabase = createClient()
    let { data } = await supabase.from('friend_invites').select('token').eq('user_id', user.id).maybeSingle()
    if (!data) {
      const ins = await supabase.from('friend_invites').insert({ user_id: user.id }).select('token').single()
      data = ins.data
    }
    if (data?.token) setInviteLink(`${window.location.origin}/invite/${data.token}`)
    setGenLoading(false)
  }

  const copyLink = async () => {
    if (!inviteLink) return
    await navigator.clipboard.writeText(inviteLink)
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }

  if (!user) return (
    <main className="container py-16 text-center text-sm text-muted-foreground">
      Connectez-vous pour accéder à vos amis.
    </main>
  )

  return (
    <main className="container max-w-2xl py-10">

      {/* Titre */}
      <h1 className="mb-6 flex items-center gap-2 text-2xl font-bold">
        <Users className="h-6 w-6 text-primary" />
        Amis
        {!loading && <span className="text-base font-normal text-muted-foreground">({friends.length})</span>}
      </h1>

      {/* Barre d'actions */}
      <div className="mb-6 flex gap-2">
        <Button
          variant={panel === 'requests' ? 'default' : 'outline'}
          className="gap-2"
          onClick={() => setPanel(p => p === 'requests' ? null : 'requests')}
        >
          <Bell className="h-4 w-4" />
          Demandes reçues
          {received.length > 0 && (
            <span className="flex h-5 w-5 items-center justify-center rounded-full bg-primary text-xs font-bold text-primary-foreground">
              {received.length}
            </span>
          )}
        </Button>
        <Button
          variant={panel === 'search' ? 'default' : 'outline'}
          className="gap-2"
          onClick={() => setPanel(p => p === 'search' ? null : 'search')}
        >
          <UserPlus className="h-4 w-4" />
          Ajouter un ami
        </Button>
      </div>

      {/* Panel — Demandes reçues */}
      {panel === 'requests' && (
        <div className="mb-6 rounded-xl border border-border bg-card p-5">
          <div className="mb-4 flex items-center justify-between">
            <h2 className="font-semibold">Demandes reçues</h2>
            <button onClick={() => setPanel(null)} className="rounded-md p-1 text-muted-foreground hover:bg-muted">
              <X className="h-4 w-4" />
            </button>
          </div>
          {loading ? (
            <div className="flex items-center gap-2 text-xs text-muted-foreground">
              <Loader2 className="h-4 w-4 animate-spin" /> Chargement…
            </div>
          ) : received.length === 0 ? (
            <p className="text-sm text-muted-foreground">Aucune demande en attente.</p>
          ) : (
            <ul className="space-y-2">
              {received.map(r => (
                <li key={r.rowId} className="flex items-center justify-between rounded-lg border border-primary/20 bg-primary/5 px-3 py-2">
                  <span className="font-medium">{r.from.username}</span>
                  <div className="flex gap-2">
                    <Button size="sm" className="gap-1.5" onClick={() => accept(r.rowId, r.from)}>
                      <Check className="h-3.5 w-3.5" /> Accepter
                    </Button>
                    <Button size="sm" variant="outline" onClick={() => decline(r.rowId)}>Refuser</Button>
                  </div>
                </li>
              ))}
            </ul>
          )}

          {/* Demandes envoyées dans le même panel */}
          {sent.length > 0 && (
            <>
              <div className="my-4 border-t border-border" />
              <h3 className="mb-3 text-sm font-medium text-muted-foreground">Envoyées ({sent.length})</h3>
              <ul className="space-y-2">
                {sent.map(s => (
                  <li key={s.rowId} className="flex items-center justify-between rounded-lg border border-border px-3 py-2">
                    <span className="text-sm text-muted-foreground">{s.to.username}</span>
                    <Button size="sm" variant="ghost" className="text-xs text-muted-foreground" onClick={() => decline(s.rowId)}>
                      Annuler
                    </Button>
                  </li>
                ))}
              </ul>
            </>
          )}
        </div>
      )}

      {/* Panel — Recherche */}
      {panel === 'search' && (
        <div className="mb-6 rounded-xl border border-border bg-card p-5">
          <div className="mb-4 flex items-center justify-between">
            <h2 className="font-semibold">Ajouter un ami</h2>
            <button onClick={() => setPanel(null)} className="rounded-md p-1 text-muted-foreground hover:bg-muted">
              <X className="h-4 w-4" />
            </button>
          </div>
          <div className="relative">
            <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
            <Input
              placeholder="Tapez un pseudo (min. 2 caractères)…"
              value={search}
              onChange={e => setSearch(e.target.value)}
              className="pl-9"
            />
          </div>
          <div className="mt-3 min-h-[2rem]">
            {searching && (
              <p className="flex items-center gap-1.5 text-xs text-muted-foreground">
                <Loader2 className="h-3.5 w-3.5 animate-spin" /> Recherche…
              </p>
            )}
            {!searching && search.trim().length >= 2 && searchResults.length === 0 && (
              <p className="text-xs text-muted-foreground">Aucun joueur trouvé.</p>
            )}
            {visibleResults.length > 0 && (
              <ul className="space-y-2">
                {visibleResults.map(p => (
                  <li key={p.id} className="flex items-center justify-between rounded-lg border border-border px-3 py-2">
                    <span className="font-medium">{p.username}</span>
                    <Button
                      size="sm"
                      variant="outline"
                      className="gap-1.5"
                      disabled={addingId === p.id}
                      onClick={() => sendRequest(p)}
                    >
                      {addingId === p.id ? <Loader2 className="h-3.5 w-3.5 animate-spin" /> : <UserPlus className="h-3.5 w-3.5" />}
                      {addingId === p.id ? 'Envoi…' : 'Ajouter'}
                    </Button>
                  </li>
                ))}
              </ul>
            )}
            {!searching && searchResults.length > 0 && visibleResults.length < searchResults.length && (
              <p className="mt-1 text-xs text-muted-foreground">
                {searchResults.length - visibleResults.length} résultat(s) déjà en relation masqué(s).
              </p>
            )}
          </div>
        </div>
      )}

      {/* Lien d'invitation */}
      <div className="mb-6 rounded-xl border border-border bg-card p-5">
        <h2 className="mb-1 text-sm font-semibold">Lien d'invitation</h2>
        <p className="mb-3 text-xs text-muted-foreground">
          Partagez ce lien — quiconque le visite vous envoie automatiquement une demande d'ami.
        </p>
        {inviteLink ? (
          <div className="flex gap-2">
            <Input value={inviteLink} readOnly className="flex-1 text-xs" />
            <Button size="sm" variant="outline" onClick={copyLink} className="shrink-0 gap-1.5">
              {copied ? <Check className="h-3.5 w-3.5" /> : <Copy className="h-3.5 w-3.5" />}
              {copied ? 'Copié !' : 'Copier'}
            </Button>
          </div>
        ) : (
          <Button size="sm" variant="outline" onClick={generateLink} disabled={genLoading} className="gap-1.5">
            {genLoading ? <Loader2 className="h-3.5 w-3.5 animate-spin" /> : <Copy className="h-3.5 w-3.5" />}
            Générer un lien
          </Button>
        )}
      </div>

      {/* Liste d'amis */}
      <section>
        <h2 className="mb-3 text-sm font-semibold">Mes amis</h2>
        {loadErr && <p className="mb-2 text-xs text-destructive">Erreur : {loadErr}</p>}
        {loading ? (
          <div className="flex items-center gap-2 text-xs text-muted-foreground">
            <Loader2 className="h-4 w-4 animate-spin" /> Chargement…
          </div>
        ) : friends.length === 0 ? (
          <p className="text-sm text-muted-foreground">
            Vous n'avez pas encore d'amis. Recherchez un pseudo ou partagez votre lien !
          </p>
        ) : (
          <ul className="space-y-2">
            {friends.map(f => (
              <li key={f.id} className="flex items-center gap-3 rounded-xl border border-border bg-card px-4 py-3">
                <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-primary/10 text-sm font-bold text-primary">
                  {f.username.slice(0, 2).toUpperCase()}
                </div>
                <span className="flex-1 font-medium">{f.username}</span>
                <Button size="sm" variant="outline" asChild>
                  <Link href={`/friends/${f.id}/profile`}>Voir le profil</Link>
                </Button>
                <button
                  onClick={() => removeFriend(f.id)}
                  className="rounded-md p-1.5 text-muted-foreground transition-colors hover:bg-destructive/10 hover:text-destructive"
                  aria-label={`Retirer ${f.username}`}
                >
                  <UserMinus className="h-4 w-4" />
                </button>
              </li>
            ))}
          </ul>
        )}
      </section>
    </main>
  )
}
