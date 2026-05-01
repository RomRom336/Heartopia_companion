'use client'

import { useState } from 'react'
import Link from 'next/link'
import { useRouter, useSearchParams } from 'next/navigation'
import { Check, Loader2 } from 'lucide-react'
import { createClient } from '@/utils/supabase/client'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'

export default function LoginPage() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const redirectTo = searchParams.get('redirectTo') ?? '/'

  const [email,    setEmail]    = useState('')
  const [password, setPassword] = useState('')
  const [loading,  setLoading]  = useState(false)
  const [error,    setError]    = useState<string | null>(null)

  const [forgotOpen,  setForgotOpen]  = useState(false)
  const [resetEmail,  setResetEmail]  = useState('')
  const [resetSending, setResetSending] = useState(false)
  const [resetSent,    setResetSent]    = useState(false)
  const [resetError,   setResetError]   = useState<string | null>(null)

  const supabase = createClient()

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setLoading(true)
    const { error } = await supabase.auth.signInWithPassword({ email, password })
    setLoading(false)
    if (error) { setError(error.message); return }
    router.push(redirectTo)
    router.refresh()
  }

  async function onReset(e: React.FormEvent) {
    e.preventDefault()
    setResetError(null)
    setResetSending(true)
    const { error } = await supabase.auth.resetPasswordForEmail(resetEmail, {
      redirectTo: `${window.location.origin}/auth/reset`,
    })
    setResetSending(false)
    if (error) { setResetError(error.message); return }
    setResetSent(true)
  }

  return (
    <div className="container flex min-h-[calc(100vh-4rem)] items-center justify-center py-12">
      <div className="w-full max-w-md rounded-xl border border-border bg-card p-8 shadow-sm">
        <h1 className="text-2xl font-semibold tracking-tight">Connexion</h1>
        <p className="mt-2 text-sm text-muted-foreground">
          Retrouvez votre progression Heartopia.
        </p>

        <form onSubmit={onSubmit} className="mt-6 space-y-4">
          <div className="space-y-2">
            <Label htmlFor="email">E-mail</Label>
            <Input id="email" type="email" required value={email}
              onChange={e => setEmail(e.target.value)} autoComplete="email" />
          </div>

          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <Label htmlFor="password">Mot de passe</Label>
              <button
                type="button"
                onClick={() => { setForgotOpen(v => !v); setResetSent(false); setResetError(null) }}
                className="text-xs text-muted-foreground hover:text-foreground hover:underline underline-offset-2"
              >
                {forgotOpen ? 'Annuler' : 'Mot de passe oublié ?'}
              </button>
            </div>
            <Input id="password" type="password" required={!forgotOpen} value={password}
              onChange={e => setPassword(e.target.value)} autoComplete="current-password" />
          </div>

          {/* Panel mot de passe oublié */}
          {forgotOpen && (
            <div className="space-y-3 rounded-lg border border-border bg-muted/30 p-4">
              {resetSent ? (
                <div className="flex items-center gap-2 text-sm text-green-600 dark:text-green-400">
                  <Check className="h-4 w-4" />
                  Email envoyé à <span className="font-medium">{resetEmail}</span>. Vérifiez votre boîte mail.
                </div>
              ) : (
                <form onSubmit={onReset} className="space-y-3">
                  <p className="text-xs text-muted-foreground">
                    Entrez votre adresse mail — nous vous enverrons un lien pour réinitialiser votre mot de passe.
                  </p>
                  <Input
                    type="email"
                    required
                    placeholder="votre@email.com"
                    value={resetEmail}
                    onChange={e => { setResetEmail(e.target.value); setResetError(null) }}
                  />
                  {resetError && <p className="text-xs text-destructive">{resetError}</p>}
                  <Button type="submit" size="sm" disabled={resetSending} className="w-full gap-1.5">
                    {resetSending && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
                    {resetSending ? 'Envoi…' : 'Envoyer le lien'}
                  </Button>
                </form>
              )}
            </div>
          )}

          {error && (
            <p className="rounded-md bg-destructive/10 px-3 py-2 text-sm text-destructive">{error}</p>
          )}

          <Button type="submit" disabled={loading} className="w-full">
            {loading ? 'Connexion…' : 'Se connecter'}
          </Button>
        </form>

        <p className="mt-6 text-center text-sm text-muted-foreground">
          Pas encore de compte ?{' '}
          <Link href="/register" className="font-medium text-primary hover:underline">
            S&apos;inscrire
          </Link>
        </p>
      </div>
    </div>
  )
}
