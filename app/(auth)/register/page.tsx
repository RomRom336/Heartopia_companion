'use client'

import { useEffect, useRef, useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { Check, Loader2, X } from 'lucide-react'
import { createClient } from '@/utils/supabase/client'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { cn } from '@/lib/utils'

const USERNAME_RE = /^[a-zA-Z0-9_-]{3,20}$/

export default function RegisterPage() {
  const router = useRouter()
  const supabase = createClient()

  const [username,  setUsername]  = useState('')
  const [email,     setEmail]     = useState('')
  const [password,  setPassword]  = useState('')
  const [loading,   setLoading]   = useState(false)
  const [error,     setError]     = useState<string | null>(null)
  const [needsVerification, setNeedsVerification] = useState(false)

  // Disponibilité du pseudo
  const [usernameAvail, setUsernameAvail] = useState<boolean | null>(null)
  const [checkingUser,  setCheckingUser]  = useState(false)
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  useEffect(() => {
    if (!USERNAME_RE.test(username)) { setUsernameAvail(null); return }
    if (debounceRef.current) clearTimeout(debounceRef.current)
    debounceRef.current = setTimeout(async () => {
      setCheckingUser(true)
      const { data } = await supabase.rpc('is_username_available', { p_username: username })
      setUsernameAvail(data === true)
      setCheckingUser(false)
    }, 400)
  }, [username])

  const usernameHint = () => {
    if (!username) return null
    if (!USERNAME_RE.test(username)) return { ok: false, msg: '3–20 caractères, lettres, chiffres, _ ou -.' }
    if (checkingUser) return null
    if (usernameAvail === true)  return { ok: true,  msg: 'Pseudo disponible !' }
    if (usernameAvail === false) return { ok: false, msg: 'Ce pseudo est déjà pris.' }
    return null
  }
  const hint = usernameHint()

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    if (!USERNAME_RE.test(username)) { setError('Pseudo invalide.'); return }
    if (usernameAvail === false)      { setError('Ce pseudo est déjà pris.'); return }
    setLoading(true)

    const { data, error: signUpError } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: { username },
        emailRedirectTo: `${window.location.origin}/auth/callback`,
      },
    })

    if (signUpError) { setError(signUpError.message); setLoading(false); return }

    // Session immédiate (pas de confirmation email)
    if (data.session && data.user) {
      await supabase.from('profiles')
        .upsert({ id: data.user.id, username }, { onConflict: 'id' })
      setLoading(false)
      router.push('/')
      router.refresh()
      return
    }

    // Email de confirmation requis → username sauvegardé dans les métadonnées auth
    setLoading(false)
    setNeedsVerification(true)
  }

  if (needsVerification) {
    return (
      <div className="container flex min-h-[calc(100vh-4rem)] items-center justify-center py-12">
        <div className="w-full max-w-md rounded-xl border border-border bg-card p-8 text-center shadow-sm">
          <h1 className="text-2xl font-semibold tracking-tight">Vérifiez votre boîte mail</h1>
          <p className="mt-4 text-sm text-muted-foreground">
            Nous avons envoyé un lien de confirmation à{' '}
            <span className="font-medium text-foreground">{email}</span>.
            Cliquez dessus pour activer votre compte.
          </p>
          <Button asChild variant="outline" className="mt-6">
            <Link href="/login">Retour à la connexion</Link>
          </Button>
        </div>
      </div>
    )
  }

  return (
    <div className="container flex min-h-[calc(100vh-4rem)] items-center justify-center py-12">
      <div className="w-full max-w-md rounded-xl border border-border bg-card p-8 shadow-sm">
        <h1 className="text-2xl font-semibold tracking-tight">Créer un compte</h1>
        <p className="mt-2 text-sm text-muted-foreground">
          Sauvegardez votre collection et votre inventaire dans le cloud.
        </p>

        <form onSubmit={onSubmit} className="mt-6 space-y-4">
          {/* Pseudo */}
          <div className="space-y-2">
            <Label htmlFor="username">Pseudo</Label>
            <div className="relative">
              <Input
                id="username"
                type="text"
                required
                value={username}
                onChange={e => { setUsername(e.target.value); setError(null) }}
                autoComplete="username"
                placeholder="votre_pseudo"
                className={cn(
                  hint?.ok === false && 'border-destructive focus-visible:ring-destructive',
                  hint?.ok === true  && 'border-green-500 focus-visible:ring-green-500',
                )}
              />
              {username && (
                <span className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2">
                  {checkingUser
                    ? <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />
                    : hint?.ok === true
                    ? <Check className="h-4 w-4 text-green-500" />
                    : hint?.ok === false
                    ? <X className="h-4 w-4 text-destructive" />
                    : null}
                </span>
              )}
            </div>
            {hint && (
              <p className={cn('text-xs', hint.ok ? 'text-green-600 dark:text-green-400' : 'text-destructive')}>
                {hint.msg}
              </p>
            )}
            {!hint && <p className="text-xs text-muted-foreground">3–20 caractères, lettres, chiffres, _ ou -.</p>}
          </div>

          {/* Email */}
          <div className="space-y-2">
            <Label htmlFor="email">E-mail</Label>
            <Input id="email" type="email" required value={email}
              onChange={e => setEmail(e.target.value)} autoComplete="email" />
          </div>

          {/* Mot de passe */}
          <div className="space-y-2">
            <Label htmlFor="password">Mot de passe</Label>
            <Input id="password" type="password" required minLength={6} value={password}
              onChange={e => setPassword(e.target.value)} autoComplete="new-password" />
            <p className="text-xs text-muted-foreground">Au moins 6 caractères.</p>
          </div>

          {error && (
            <p className="rounded-md bg-destructive/10 px-3 py-2 text-sm text-destructive">{error}</p>
          )}

          <Button
            type="submit"
            disabled={loading || usernameAvail === false || checkingUser || !USERNAME_RE.test(username)}
            className="w-full"
          >
            {loading ? 'Création…' : 'Créer mon compte'}
          </Button>
        </form>

        <p className="mt-6 text-center text-sm text-muted-foreground">
          Déjà un compte ?{' '}
          <Link href="/login" className="font-medium text-primary hover:underline">Se connecter</Link>
        </p>
      </div>
    </div>
  )
}
