'use client'

import { useEffect, useState } from 'react'
import { Check, Eye, EyeOff, Loader2, User } from 'lucide-react'
import { useAuth } from '@/components/auth-provider'
import { createClient } from '@/utils/supabase/client'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { cn } from '@/lib/utils'

const USERNAME_RE = /^[a-zA-Z0-9_-]{3,20}$/

type Stats = { caught: number; total: number; withinLevel: number; caughtWithin: number }

function StatCard({ emoji, label, level, stat }: {
  emoji: string; label: string; level: number; stat: Stats
}) {
  const remaining = stat.withinLevel - stat.caughtWithin
  const pct = stat.withinLevel > 0 ? Math.round((stat.caughtWithin / stat.withinLevel) * 100) : 0
  return (
    <div className="rounded-xl border border-border bg-card p-4">
      <div className="mb-3 flex items-center gap-2">
        <span className="text-xl">{emoji}</span>
        <div>
          <p className="font-semibold">{label}</p>
          <p className="text-xs text-muted-foreground">Niv.&nbsp;{level}</p>
        </div>
      </div>
      <div className="space-y-1.5 text-sm">
        <div className="flex justify-between">
          <span className="text-muted-foreground">Attrapés</span>
          <span className="font-medium">{stat.caught}&nbsp;/&nbsp;{stat.total}</span>
        </div>
        <div className="flex justify-between">
          <span className="text-muted-foreground">À mon niveau</span>
          <span className="font-medium">{stat.caughtWithin}&nbsp;/&nbsp;{stat.withinLevel}</span>
        </div>
        {remaining > 0 && (
          <div className="flex justify-between">
            <span className="text-muted-foreground">Restants</span>
            <span className="font-semibold text-primary">{remaining}</span>
          </div>
        )}
      </div>
      {stat.withinLevel > 0 && (
        <div className="mt-3 h-1.5 w-full overflow-hidden rounded-full bg-muted">
          <div className="h-full rounded-full bg-primary transition-all" style={{ width: `${pct}%` }} />
        </div>
      )}
    </div>
  )
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="rounded-xl border border-border bg-card p-6">
      <h2 className="mb-4 text-base font-semibold">{title}</h2>
      {children}
    </div>
  )
}

export default function AccountPage() {
  const { user } = useAuth()

  // ── Profil ────────────────────────────────────────────────
  const [username,     setUsername]     = useState('')
  const [initialUser,  setInitialUser]  = useState('')
  const [userSaving,   setUserSaving]   = useState(false)
  const [userSaved,    setUserSaved]    = useState(false)
  const [userError,    setUserError]    = useState<string | null>(null)

  // ── Niveaux de passion ────────────────────────────────────
  const [fishLevel,    setFishLevel]    = useState(10)
  const [insectLevel,  setInsectLevel]  = useState(10)
  const [birdLevel,    setBirdLevel]    = useState(10)
  const [levelSaving,  setLevelSaving]  = useState(false)
  const [levelSaved,   setLevelSaved]   = useState(false)

  // ── Mot de passe ──────────────────────────────────────────
  const [pwdPanelOpen, setPwdPanelOpen] = useState(false)
  const [currentPwd,   setCurrentPwd]   = useState('')
  const [newPwd,       setNewPwd]       = useState('')
  const [confirmPwd,   setConfirmPwd]   = useState('')
  const [showPwd,      setShowPwd]      = useState(false)
  const [pwdSaving,    setPwdSaving]    = useState(false)
  const [pwdSaved,     setPwdSaved]     = useState(false)
  const [pwdError,     setPwdError]     = useState<string | null>(null)

  // ── Stats ─────────────────────────────────────────────────
  const [stats, setStats] = useState<{ fish: Stats; insect: Stats; bird: Stats } | null>(null)

  useEffect(() => {
    if (!user) return
    const supabase = createClient()

    // Profil + niveaux
    supabase.from('profiles')
      .select('username, fishing_passion, bug_passion, bird_passion')
      .eq('id', user.id)
      .maybeSingle()
      .then(({ data }) => {
        if (!data) return
        const u = data.username ?? ''
        setUsername(u); setInitialUser(u)
        setFishLevel(data.fishing_passion ?? 10)
        setInsectLevel(data.bug_passion   ?? 10)
        setBirdLevel(data.bird_passion    ?? 10)
      })

    // Stats
    ;(async () => {
      const [fishAll, insectAll, birdAll, collection] = await Promise.all([
        supabase.from('fish').select('id, passion_level'),
        supabase.from('insect').select('id, passion_level'),
        supabase.from('bird').select('id, passion_level'),
        supabase.from('user_collection').select('item_id, item_type').eq('user_id', user.id),
      ])

      const caughtIds = new Set(collection.data?.map(r => r.item_id as string) ?? [])
      const fishCaught   = collection.data?.filter(r => r.item_type === 'Poisson').length ?? 0
      const insectCaught = collection.data?.filter(r => r.item_type === 'Insecte').length ?? 0
      const birdCaught   = collection.data?.filter(r => r.item_type === 'Oiseau').length  ?? 0

      // Les stats seront recalculées quand les niveaux sont chargés
      // On stocke les données brutes pour recalculer
      const rawFish   = fishAll.data   ?? []
      const rawInsect = insectAll.data ?? []
      const rawBird   = birdAll.data   ?? []

      // Utiliser les niveaux depuis le profil (on relit depuis profiles)
      const { data: prof } = await supabase.from('profiles')
        .select('fishing_passion, bug_passion, bird_passion')
        .eq('id', user.id).maybeSingle()

      const fl = prof?.fishing_passion ?? 10
      const il = prof?.bug_passion     ?? 10
      const bl = prof?.bird_passion    ?? 10

      const fishWithin   = rawFish.filter(i => i.passion_level <= fl)
      const insectWithin = rawInsect.filter(i => i.passion_level <= il)
      const birdWithin   = rawBird.filter(i => i.passion_level <= bl)

      setStats({
        fish:   { caught: fishCaught,   total: rawFish.length,   withinLevel: fishWithin.length,   caughtWithin: fishWithin.filter(i => caughtIds.has(i.id)).length },
        insect: { caught: insectCaught, total: rawInsect.length, withinLevel: insectWithin.length, caughtWithin: insectWithin.filter(i => caughtIds.has(i.id)).length },
        bird:   { caught: birdCaught,   total: rawBird.length,   withinLevel: birdWithin.length,   caughtWithin: birdWithin.filter(i => caughtIds.has(i.id)).length },
      })
    })()
  }, [user])

  const saveUsername = async () => {
    if (!user) return
    const trimmed = username.trim()
    if (!USERNAME_RE.test(trimmed)) { setUserError('3–20 caractères, lettres, chiffres, _ ou -.'); return }
    setUserSaving(true); setUserError(null)
    const supabase = createClient()
    const { error } = await supabase.from('profiles')
      .upsert({ id: user.id, username: trimmed }, { onConflict: 'id' })
    if (error) { setUserSaving(false); setUserError(error.code === '23505' ? 'Ce pseudo est déjà pris.' : error.message); return }
    await supabase.auth.updateUser({ data: { full_name: trimmed } })
    setUserSaving(false)
    setInitialUser(trimmed); setUserSaved(true)
    setTimeout(() => setUserSaved(false), 2000)
  }

  const saveLevels = async () => {
    if (!user) return
    setLevelSaving(true)
    await createClient().from('profiles').upsert(
      { id: user.id, fishing_passion: fishLevel, bug_passion: insectLevel, bird_passion: birdLevel },
      { onConflict: 'id' },
    )
    setLevelSaving(false); setLevelSaved(true)
    setTimeout(() => setLevelSaved(false), 2000)
  }

  const savePassword = async () => {
    if (!user) return
    setPwdError(null)
    if (newPwd.length < 6) { setPwdError('Le mot de passe doit faire au moins 6 caractères.'); return }
    if (newPwd !== confirmPwd) { setPwdError('Les mots de passe ne correspondent pas.'); return }
    setPwdSaving(true)
    // Vérifier l'ancien mot de passe
    const { error: signInErr } = await createClient().auth.signInWithPassword({
      email: user.email!, password: currentPwd,
    })
    if (signInErr) { setPwdError('Mot de passe actuel incorrect.'); setPwdSaving(false); return }
    const { error } = await createClient().auth.updateUser({ password: newPwd })
    setPwdSaving(false)
    if (error) { setPwdError(error.message); return }
    setPwdSaved(true); setCurrentPwd(''); setNewPwd(''); setConfirmPwd('')
    setTimeout(() => setPwdSaved(false), 3000)
  }

  if (!user) return (
    <main className="container py-16 text-center text-sm text-muted-foreground">
      Connectez-vous pour accéder à votre profil.
    </main>
  )

  const totalCaught = stats ? stats.fish.caught + stats.insect.caught + stats.bird.caught : null
  const grandTotal  = stats ? stats.fish.total  + stats.insect.total  + stats.bird.total  : null

  return (
    <main className="container max-w-2xl py-10">

      {/* En-tête */}
      <div className="mb-8 flex items-center gap-4">
        <div className="flex h-16 w-16 shrink-0 items-center justify-center rounded-full bg-primary/10 text-2xl font-bold text-primary">
          {(username || user.email || '?').slice(0, 2).toUpperCase()}
        </div>
        <div>
          <h1 className="text-2xl font-bold">{username || 'Mon profil'}</h1>
          {totalCaught != null && (
            <p className="text-sm text-muted-foreground">{totalCaught} / {grandTotal} créatures attrapées</p>
          )}
        </div>
      </div>

      <div className="space-y-6">

        {/* Profil */}
        <Section title="Profil">
          <div className="space-y-4">
            <div>
              <p className="mb-1 text-xs text-muted-foreground">Adresse e-mail</p>
              <div className="flex items-center justify-between gap-3">
                <p className="text-sm font-medium">{user.email}</p>
                <button
                  type="button"
                  onClick={() => { setPwdPanelOpen(v => !v); setPwdError(null) }}
                  className="shrink-0 text-xs text-muted-foreground underline-offset-2 hover:text-foreground hover:underline"
                >
                  {pwdPanelOpen ? 'Annuler' : 'Changer le mot de passe'}
                </button>
              </div>
            </div>

            {/* Panel mot de passe */}
            {pwdPanelOpen && (
              <div className="space-y-3 rounded-lg border border-border bg-muted/30 p-4">
                <div className="space-y-1.5">
                  <Label htmlFor="current-pwd" className="text-xs">Mot de passe actuel</Label>
                  <div className="relative">
                    <Input id="current-pwd" type={showPwd ? 'text' : 'password'} value={currentPwd}
                      onChange={e => { setCurrentPwd(e.target.value); setPwdError(null) }} className="pr-10" />
                    <button type="button" onClick={() => setShowPwd(v => !v)}
                      className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground">
                      {showPwd ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                    </button>
                  </div>
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="new-pwd" className="text-xs">Nouveau mot de passe</Label>
                  <Input id="new-pwd" type={showPwd ? 'text' : 'password'} value={newPwd}
                    onChange={e => { setNewPwd(e.target.value); setPwdError(null) }}
                    placeholder="Au moins 6 caractères" />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="confirm-pwd" className="text-xs">Confirmer</Label>
                  <Input id="confirm-pwd" type={showPwd ? 'text' : 'password'} value={confirmPwd}
                    onChange={e => { setConfirmPwd(e.target.value); setPwdError(null) }} />
                </div>
                {pwdError && <p className="text-xs text-destructive">{pwdError}</p>}
                {pwdSaved && <p className="text-xs text-green-600 dark:text-green-400">Mot de passe modifié !</p>}
                <Button onClick={savePassword} disabled={pwdSaving || !currentPwd || !newPwd || !confirmPwd}
                  size="sm" className="gap-1.5">
                  {pwdSaving ? <Loader2 className="h-3.5 w-3.5 animate-spin" /> : pwdSaved ? <Check className="h-3.5 w-3.5" /> : null}
                  {pwdSaved ? 'Modifié !' : 'Confirmer'}
                </Button>
              </div>
            )}
            <div className="space-y-2">
              <Label htmlFor="username">Pseudo</Label>
              <p className="text-xs text-muted-foreground">Visible par vos amis. 3–20 caractères.</p>
              <div className="flex gap-2">
                <Input
                  id="username"
                  value={username}
                  onChange={e => { setUsername(e.target.value); setUserError(null) }}
                  placeholder="votre_pseudo"
                  className={cn(
                    'flex-1',
                    userError && 'border-destructive focus-visible:ring-destructive',
                    userSaved && 'border-green-500 focus-visible:ring-green-500',
                  )}
                />
                <Button onClick={saveUsername} disabled={userSaving || username.trim() === initialUser} className="gap-1.5">
                  {userSaving ? <Loader2 className="h-4 w-4 animate-spin" /> : userSaved ? <Check className="h-4 w-4" /> : <User className="h-4 w-4" />}
                  {userSaved ? 'Sauvegardé' : 'Modifier'}
                </Button>
              </div>
              {userError && <p className="text-xs text-destructive">{userError}</p>}
            </div>
          </div>
        </Section>

        {/* Niveaux de passion */}
        <Section title="Niveaux de passion">
          <div className="grid grid-cols-3 gap-3">
            {[
              { emoji: '🎣', label: 'Pêche',    val: fishLevel,   set: setFishLevel },
              { emoji: '🦋', label: 'Insectes', val: insectLevel, set: setInsectLevel },
              { emoji: '🐦', label: 'Oiseaux',  val: birdLevel,   set: setBirdLevel },
            ].map(({ emoji, label, val, set }) => (
              <div key={label} className="space-y-1.5">
                <Label className="text-xs text-muted-foreground">{emoji} {label}</Label>
                <Input
                  type="number"
                  min={1}
                  max={100}
                  value={val}
                  onChange={e => set(Number(e.target.value) || 1)}
                  className="w-full"
                />
              </div>
            ))}
          </div>
          <Button onClick={saveLevels} disabled={levelSaving} className="mt-4 gap-1.5">
            {levelSaving ? <Loader2 className="h-4 w-4 animate-spin" /> : levelSaved ? <Check className="h-4 w-4" /> : null}
            {levelSaved ? 'Sauvegardé !' : 'Sauvegarder les niveaux'}
          </Button>
        </Section>

        {/* Statistiques */}
        {stats && (
          <Section title="Statistiques">
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-3">
              <StatCard emoji="🎣" label="Poissons" level={fishLevel}   stat={stats.fish}   />
              <StatCard emoji="🦋" label="Insectes" level={insectLevel} stat={stats.insect} />
              <StatCard emoji="🐦" label="Oiseaux"  level={birdLevel}   stat={stats.bird}   />
            </div>
          </Section>
        )}

      </div>
    </main>
  )
}
