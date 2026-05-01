'use client'

import { useEffect, useState } from 'react'
import { useParams, useRouter } from 'next/navigation'
import { Check, Loader2, UserPlus } from 'lucide-react'
import Link from 'next/link'
import { useAuth } from '@/components/auth-provider'
import { createClient } from '@/utils/supabase/client'
import { Button } from '@/components/ui/button'

export default function InvitePage() {
  const { token } = useParams<{ token: string }>()
  const { user } = useAuth()
  const router = useRouter()

  const [inviter, setInviter] = useState<{ id: string; username: string } | null>(null)
  const [state, setState] = useState<'loading' | 'ready' | 'already_friends' | 'self' | 'invalid' | 'sending' | 'done' | 'error'>('loading')

  useEffect(() => {
    if (!token) return
    const supabase = createClient()
    ;(async () => {
      const { data: invite } = await supabase
        .from('friend_invites')
        .select('user_id')
        .eq('token', token)
        .maybeSingle()

      if (!invite) { setState('invalid'); return }

      const { data: profileData } = await supabase
        .from('profiles')
        .select('id, username')
        .eq('id', invite.user_id)
        .maybeSingle()

      if (!profileData) { setState('invalid'); return }

      const profile = profileData as { id: string; username: string }
      setInviter(profile)

      if (user) {
        if (profile.id === user.id) { setState('self'); return }
        const { data: existing } = await supabase
          .from('friendships')
          .select('id, status')
          .or(`and(user_id.eq.${user.id},friend_id.eq.${profile.id}),and(user_id.eq.${profile.id},friend_id.eq.${user.id})`)
          .maybeSingle()
        if (existing?.status === 'accepted') { setState('already_friends'); return }
        if (existing?.status === 'pending')  { setState('already_friends'); return }
      }
      setState('ready')
    })()
  }, [token, user])

  const accept = async () => {
    if (!user || !inviter) return
    setState('sending')
    const { error } = await createClient().from('friendships')
      .insert({ user_id: user.id, friend_id: inviter.id, status: 'pending' })
    if (error) { setState('error'); return }
    setState('done')
    setTimeout(() => router.push('/friends'), 2000)
  }

  return (
    <main className="container flex min-h-[60vh] max-w-md flex-col items-center justify-center py-16">
      <div className="w-full rounded-2xl border border-border bg-card p-8 text-center shadow-sm">
        {state === 'loading' && (
          <Loader2 className="mx-auto h-8 w-8 animate-spin text-muted-foreground" />
        )}

        {state === 'invalid' && (
          <>
            <p className="mb-4 text-lg font-semibold">Lien invalide ou expiré.</p>
            <Button asChild variant="outline"><Link href="/">Accueil</Link></Button>
          </>
        )}

        {state === 'self' && (
          <p className="text-sm text-muted-foreground">C'est votre propre lien d'invitation !</p>
        )}

        {state === 'already_friends' && inviter && (
          <>
            <p className="mb-4 text-sm text-muted-foreground">
              Vous êtes déjà ami(e) avec <span className="font-semibold text-foreground">{inviter.username}</span> ou une demande est déjà en attente.
            </p>
            <Button asChild variant="outline"><Link href="/friends">Mes amis</Link></Button>
          </>
        )}

        {state === 'ready' && inviter && !user && (
          <>
            <p className="mb-2 text-lg font-semibold">Invitation d'ami</p>
            <p className="mb-6 text-sm text-muted-foreground">
              <span className="font-semibold text-foreground">{inviter.username}</span> vous invite à rejoindre sa liste d'amis.
            </p>
            <p className="text-xs text-muted-foreground">Connectez-vous pour accepter l'invitation.</p>
            <div className="mt-4 flex justify-center gap-2">
              <Button asChild variant="outline"><Link href="/login">Se connecter</Link></Button>
              <Button asChild><Link href="/register">S'inscrire</Link></Button>
            </div>
          </>
        )}

        {state === 'ready' && inviter && user && (
          <>
            <UserPlus className="mx-auto mb-4 h-10 w-10 text-primary" />
            <p className="mb-2 text-lg font-semibold">Invitation d'ami</p>
            <p className="mb-6 text-sm text-muted-foreground">
              <span className="font-semibold text-foreground">{inviter.username}</span> vous invite à rejoindre sa liste d'amis.
            </p>
            <Button className="w-full gap-2" onClick={accept}>
              <UserPlus className="h-4 w-4" />
              Envoyer une demande
            </Button>
          </>
        )}

        {state === 'sending' && (
          <Loader2 className="mx-auto h-8 w-8 animate-spin text-primary" />
        )}

        {state === 'done' && (
          <>
            <Check className="mx-auto mb-3 h-10 w-10 text-green-500" />
            <p className="font-semibold">Demande envoyée !</p>
            <p className="text-xs text-muted-foreground">Redirection vers vos amis…</p>
          </>
        )}

        {state === 'error' && (
          <p className="text-sm text-destructive">Une erreur s'est produite. Réessayez.</p>
        )}
      </div>
    </main>
  )
}
