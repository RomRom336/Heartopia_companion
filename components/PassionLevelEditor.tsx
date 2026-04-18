'use client'

import { useEffect, useState } from 'react'
import { AlertCircle, Check, Loader2 } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { useAuth } from '@/components/auth-provider'
import { createClient } from '@/utils/supabase/client'
import { useTrackerStore } from '@/store/useTrackerStore'
import { useKitchenStore } from '@/store/useKitchenStore'

type Passions = {
  fishing_passion: number
  bug_passion: number
  bird_passion: number
  cooking_passion: number
}

type SaveState = 'idle' | 'saving' | 'saved' | 'error'

export function PassionLevelEditor() {
  const { user } = useAuth()
  const setMaxFishLevel   = useTrackerStore(s => s.setMaxFishLevel)
  const setMaxInsectLevel = useTrackerStore(s => s.setMaxInsectLevel)
  const setMaxBirdLevel   = useTrackerStore(s => s.setMaxBirdLevel)
  const setCookingLevel   = useKitchenStore(s => s.setCookingLevel)

  const [values, setValues] = useState<Passions>({
    fishing_passion: 1,
    bug_passion: 1,
    bird_passion: 1,
    cooking_passion: 1,
  })
  const [saveState, setSaveState] = useState<SaveState>('idle')
  const [errorMsg, setErrorMsg]   = useState<string>('')

  useEffect(() => {
    if (!user) return
    let cancelled = false
    const supabase = createClient()
    ;(async () => {
      const { data, error } = await supabase
        .from('profiles')
        .select('fishing_passion, bug_passion, bird_passion, cooking_passion')
        .eq('id', user.id)
        .maybeSingle()
      if (cancelled) return
      if (error) {
        console.error('[PassionLevelEditor] SELECT error:', error)
        return
      }
      if (!data) {
        console.warn('[PassionLevelEditor] No profile row found for user', user.id)
        return
      }
      const next: Passions = {
        fishing_passion: data.fishing_passion ?? 1,
        bug_passion:     data.bug_passion     ?? 1,
        bird_passion:    data.bird_passion    ?? 1,
        cooking_passion: data.cooking_passion ?? 1,
      }
      setValues(next)
      setMaxFishLevel(next.fishing_passion)
      setMaxInsectLevel(next.bug_passion)
      setMaxBirdLevel(next.bird_passion)
      setCookingLevel(next.cooking_passion)
    })()
    return () => { cancelled = true }
  }, [user, setMaxFishLevel, setMaxInsectLevel, setMaxBirdLevel, setCookingLevel])

  const handleSave = async () => {
    if (!user) return
    setSaveState('saving')
    setErrorMsg('')
    const supabase = createClient()
    const { error } = await supabase
      .from('profiles')
      .upsert(
        {
          id:              user.id,
          fishing_passion: values.fishing_passion,
          bug_passion:     values.bug_passion,
          bird_passion:    values.bird_passion,
          cooking_passion: values.cooking_passion,
        },
        { onConflict: 'id' },
      )
    if (error) {
      console.error('[PassionLevelEditor] UPSERT error:', error)
      setErrorMsg(`Erreur (${error.code}) : ${error.message}`)
      setSaveState('error')
      return
    }
    setMaxFishLevel(values.fishing_passion)
    setMaxInsectLevel(values.bug_passion)
    setMaxBirdLevel(values.bird_passion)
    setCookingLevel(values.cooking_passion)
    setSaveState('saved')
    setTimeout(() => setSaveState('idle'), 2500)
  }

  const field = (label: string, key: keyof Passions) => (
    <div className="flex flex-col gap-1.5">
      <Label htmlFor={key} className="text-sm">{label}</Label>
      <Input
        id={key}
        type="number"
        min={1}
        max={100}
        value={values[key]}
        onChange={e =>
          setValues(v => ({
            ...v,
            [key]: Math.max(1, Math.min(100, Number(e.target.value) || 1)),
          }))
        }
        className="w-24"
      />
    </div>
  )

  if (!user) return null

  return (
    <div className="w-full max-w-5xl rounded-xl border border-border bg-card p-5">
      <h2 className="mb-4 text-lg font-semibold">Mes niveaux de passion</h2>
      <div className="flex flex-wrap items-end gap-6">
        {field('Pêche', 'fishing_passion')}
        {field('Insectes', 'bug_passion')}
        {field('Oiseaux', 'bird_passion')}
        {field('Cuisine', 'cooking_passion')}
        <Button
          onClick={handleSave}
          disabled={saveState === 'saving'}
          variant={saveState === 'error' ? 'destructive' : 'default'}
          className="mb-0.5"
        >
          {saveState === 'saving' && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
          {saveState === 'saved'  && <Check       className="mr-2 h-4 w-4" />}
          {saveState === 'error'  && <AlertCircle className="mr-2 h-4 w-4" />}
          {saveState === 'saving' ? 'Enregistrement…'
            : saveState === 'saved'  ? 'Sauvegardé !'
            : saveState === 'error'  ? 'Erreur'
            : 'Mettre à jour'}
        </Button>
      </div>
      {saveState === 'error' && errorMsg && (
        <p className="mt-3 text-xs text-destructive">{errorMsg}</p>
      )}
    </div>
  )
}
