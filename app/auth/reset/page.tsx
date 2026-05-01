'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { Check, Eye, EyeOff, Loader2 } from 'lucide-react'
import { createClient } from '@/utils/supabase/client'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'

export default function ResetPasswordPage() {
  const router = useRouter()
  const [ready,    setReady]    = useState(false)
  const [newPwd,   setNewPwd]   = useState('')
  const [confirm,  setConfirm]  = useState('')
  const [showPwd,  setShowPwd]  = useState(false)
  const [saving,   setSaving]   = useState(false)
  const [saved,    setSaved]    = useState(false)
  const [error,    setError]    = useState<string | null>(null)

  useEffect(() => {
    // Supabase émet un événnement PASSWORD_RECOVERY quand le lien est valide
    const supabase = createClient()
    const { data: { subscription } } = supabase.auth.onAuthStateChange((event) => {
      if (event === 'PASSWORD_RECOVERY') setReady(true)
    })
    return () => subscription.unsubscribe()
  }, [])

  const handleSave = async () => {
    setError(null)
    if (newPwd.length < 6) { setError('Au moins 6 caractères.'); return }
    if (newPwd !== confirm)  { setError('Les mots de passe ne correspondent pas.'); return }
    setSaving(true)
    const { error } = await createClient().auth.updateUser({ password: newPwd })
    setSaving(false)
    if (error) { setError(error.message); return }
    setSaved(true)
    setTimeout(() => router.push('/'), 2000)
  }

  return (
    <div className="container flex min-h-[calc(100vh-4rem)] items-center justify-center py-12">
      <div className="w-full max-w-md rounded-xl border border-border bg-card p-8 shadow-sm">
        <h1 className="mb-2 text-2xl font-semibold tracking-tight">Nouveau mot de passe</h1>

        {!ready ? (
          <div className="flex items-center gap-2 py-4 text-sm text-muted-foreground">
            <Loader2 className="h-4 w-4 animate-spin" />
            Vérification du lien…
          </div>
        ) : saved ? (
          <div className="flex items-center gap-2 py-4 text-sm text-green-600 dark:text-green-400">
            <Check className="h-5 w-5" />
            Mot de passe modifié ! Redirection…
          </div>
        ) : (
          <div className="mt-4 space-y-4">
            <div className="space-y-2">
              <Label htmlFor="new-pwd">Nouveau mot de passe</Label>
              <div className="relative">
                <Input id="new-pwd" type={showPwd ? 'text' : 'password'} value={newPwd}
                  onChange={e => { setNewPwd(e.target.value); setError(null) }}
                  placeholder="Au moins 6 caractères" className="pr-10" />
                <button type="button" onClick={() => setShowPwd(v => !v)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground">
                  {showPwd ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                </button>
              </div>
            </div>
            <div className="space-y-2">
              <Label htmlFor="confirm-pwd">Confirmer</Label>
              <Input id="confirm-pwd" type={showPwd ? 'text' : 'password'} value={confirm}
                onChange={e => { setConfirm(e.target.value); setError(null) }} />
            </div>
            {error && <p className="text-sm text-destructive">{error}</p>}
            <Button onClick={handleSave} disabled={saving || !newPwd || !confirm} className="w-full gap-1.5">
              {saving && <Loader2 className="h-4 w-4 animate-spin" />}
              {saving ? 'Enregistrement…' : 'Enregistrer'}
            </Button>
          </div>
        )}
      </div>
    </div>
  )
}
